modifier_skill_magic_investor = class({})

function modifier_skill_magic_investor:IsHidden() return false end
function modifier_skill_magic_investor:IsPurgable() return false end
function modifier_skill_magic_investor:IsPurgeException() return false end
function modifier_skill_magic_investor:RemoveOnDeath() return false end
function modifier_skill_magic_investor:AllowIllusionDuplicate() return true end
function modifier_skill_magic_investor:GetTexture() return "modifier_skill_magic_investor" end

function modifier_skill_magic_investor:OnCreated()
	if not IsServer() then return end
	self.bonus = 0
	self:SetHasCustomTransmitterData(true)
	self:StartIntervalThink(FrameTime())
end

function modifier_skill_magic_investor:AddCustomTransmitterData() 
    return 
    {
        bonus = self.bonus,
    } 
end

function modifier_skill_magic_investor:HandleCustomTransmitterData(data)
    self.bonus = data.bonus
end

function modifier_skill_magic_investor:OnIntervalThink()
	if not IsServer() then return end
	self:SendBuffRefreshToClients()
	local gold = math.min(20000, self:GetParent():GetGold())
	self.bonus = gold / 500
	self:SetStackCount(self.bonus)
	self:SendBuffRefreshToClients()
end

function modifier_skill_magic_investor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_skill_magic_investor:GetModifierSpellAmplify_Percentage()
	return self.bonus * 0.5
end

function modifier_skill_magic_investor:OnTooltip()
	return self:GetStackCount() * 0.5
end