LinkLuaModifier("modifier_skill_overclocking_debuff", "modifiers/skills/modifier_skill_overclocking", LUA_MODIFIER_MOTION_NONE)

modifier_skill_overclocking = class({})
function modifier_skill_overclocking:GetTexture() return "modifier_skill_overclocking" end
function modifier_skill_overclocking:IsHidden() return false end
function modifier_skill_overclocking:IsPurgable() return false end
function modifier_skill_overclocking:IsPurgeException() return false end
function modifier_skill_overclocking:RemoveOnDeath() return false end
function modifier_skill_overclocking:AllowIllusionDuplicate() return true end

function modifier_skill_overclocking:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(0)
	self.origin = self:GetParent():GetAbsOrigin()
	self.distance = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_skill_overclocking:OnIntervalThink()
	if not IsServer() then return end
	self.distance = self.distance + ((self:GetParent():GetAbsOrigin() - self.origin):Length2D())
	if self.distance >= 100 then
		self:SetStackCount( math.min(self:GetStackCount()+1, 30) )
		self.distance = 0
	end
	self.origin = self:GetParent():GetAbsOrigin()
end

function modifier_skill_overclocking:IsAura() return true end

function modifier_skill_overclocking:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_overclocking:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_overclocking:GetModifierAura()
	return "modifier_skill_overclocking_debuff"
end

function modifier_skill_overclocking:GetAuraRadius()
	return 1500
end

function modifier_skill_overclocking:GetAuraDuration()
	return 1
end

modifier_skill_overclocking_debuff = class({})

function modifier_skill_overclocking_debuff:IsDebuff() return true end
function modifier_skill_overclocking_debuff:IsPurgable() return false end
function modifier_skill_overclocking_debuff:GetTexture() return "modifier_skill_overclocking" end

function modifier_skill_overclocking_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_skill_overclocking_debuff:GetModifierIncomingDamage_Percentage(params)
    if self:GetParent():IsDebuffImmune() then
        return math.max(self:GetCaster():GetModifierStackCount("modifier_skill_overclocking", self:GetCaster()), 0) / 2
    end
	return math.max(self:GetCaster():GetModifierStackCount("modifier_skill_overclocking", self:GetCaster()), 0)
end