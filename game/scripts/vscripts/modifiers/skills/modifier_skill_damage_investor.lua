modifier_skill_damage_investor = class({})

function modifier_skill_damage_investor:IsHidden() return false end
function modifier_skill_damage_investor:IsPurgable() return false end
function modifier_skill_damage_investor:IsPurgeException() return false end
function modifier_skill_damage_investor:RemoveOnDeath() return false end
function modifier_skill_damage_investor:AllowIllusionDuplicate() return true end
function modifier_skill_damage_investor:GetTexture() return "modifier_skill_damage_investor" end

function modifier_skill_damage_investor:OnCreated()
	if not IsServer() then return end
	self.bonus = 0
	self:SetHasCustomTransmitterData(true)
	self:StartIntervalThink(FrameTime())
end

function modifier_skill_damage_investor:AddCustomTransmitterData() 
    return 
    {
        bonus = self.bonus,
    } 
end

function modifier_skill_damage_investor:HandleCustomTransmitterData(data)
    self.bonus = data.bonus
end

function modifier_skill_damage_investor:OnIntervalThink()
	if not IsServer() then return end
	self:SendBuffRefreshToClients()
	local gold = self:GetParent():GetGold() --math.min(20000, self:GetParent():GetGold())
	self.bonus = gold / 25
	self:SetStackCount(self.bonus)
	self:SendBuffRefreshToClients()
end

function modifier_skill_damage_investor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_skill_damage_investor:GetModifierPreAttack_BonusDamage()
	return self.bonus
end

function modifier_skill_damage_investor:OnTooltip()
	return self:GetStackCount()
end