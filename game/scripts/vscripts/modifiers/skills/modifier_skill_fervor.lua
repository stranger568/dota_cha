LinkLuaModifier("modifier_skill_fervor_debuff", "modifiers/skills/modifier_skill_fervor", LUA_MODIFIER_MOTION_NONE)

modifier_skill_fervor = class({})

function modifier_skill_fervor:IsHidden() return false end
function modifier_skill_fervor:IsPurgable() return false end
function modifier_skill_fervor:IsPurgeException() return false end
function modifier_skill_fervor:RemoveOnDeath() return false end
function modifier_skill_fervor:AllowIllusionDuplicate() return true end

function modifier_skill_fervor:GetTexture()
    return "troll_warlord_fervor"
end

function modifier_skill_fervor:OnCreated()
	if not IsServer() then return end
	self.current_target = nil
end

function modifier_skill_fervor:AttackLandedModifier( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if params.no_attack_cooldown then return end
	if self:GetParent():PassivesDisabled() then return end

    if self.current_target ~= nil and self.current_target ~= params.target then
        self:SetStackCount(self:GetStackCount() / 2)
    end

    if self.current_target == params.target then
    	if self:GetStackCount() < 12 then
        	self:SetStackCount(self:GetStackCount() + 1)
        end
    end

    self.current_target = params.target
end

function modifier_skill_fervor:IsAura() return true end

function modifier_skill_fervor:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_fervor:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_fervor:GetModifierAura()
	return "modifier_skill_fervor_debuff"
end

function modifier_skill_fervor:GetAuraRadius()
	return 1500
end

function modifier_skill_fervor:GetAuraDuration()
	return 1
end

modifier_skill_fervor_debuff = class({})

function modifier_skill_fervor_debuff:IsDebuff() return true end
function modifier_skill_fervor_debuff:IsPurgable() return false end
function modifier_skill_fervor_debuff:GetTexture() return "modifier_skill_fervor" end

function modifier_skill_fervor_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_skill_fervor_debuff:GetModifierIncomingDamage_Percentage(params)
    if self:GetParent():IsDebuffImmune() then
        return self:GetCaster():GetModifierStackCount("modifier_skill_fervor", self:GetCaster()) * 3.5 / 2
    end
	return self:GetCaster():GetModifierStackCount("modifier_skill_fervor", self:GetCaster()) * 3.5
end