modifier_skill_armor_investor = class({})

function modifier_skill_armor_investor:IsHidden() return false end
function modifier_skill_armor_investor:IsPurgable() return false end
function modifier_skill_armor_investor:IsPurgeException() return false end
function modifier_skill_armor_investor:RemoveOnDeath() return false end
function modifier_skill_armor_investor:AllowIllusionDuplicate() return true end
function modifier_skill_armor_investor:GetTexture() return "modifier_skill_armor_investor" end

function modifier_skill_armor_investor:OnCreated()
	if not IsServer() then return end
	self.bonus = 0
	self:SetHasCustomTransmitterData(true)
	self:StartIntervalThink(FrameTime())
end

function modifier_skill_armor_investor:AddCustomTransmitterData() 
    return 
    {
        bonus = self.bonus,
    } 
end

function modifier_skill_armor_investor:HandleCustomTransmitterData(data)
    self.bonus = data.bonus
end

function modifier_skill_armor_investor:OnIntervalThink()
	if not IsServer() then return end
	self:SendBuffRefreshToClients()
	local gold = self:GetParent():GetGold() --math.min(20000, self:GetParent():GetGold())
	self.bonus = gold / 300
	self:SetStackCount(self.bonus)
	self:SendBuffRefreshToClients()
end

function modifier_skill_armor_investor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_skill_armor_investor:GetModifierPhysicalArmorBonus()
	return self.bonus
end

function modifier_skill_armor_investor:OnTooltip()
	return self:GetStackCount()
end