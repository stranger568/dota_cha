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
		self:SetStackCount( math.min(self:GetStackCount()+3, 30) )
		self.distance = 0
	end
	self.origin = self:GetParent():GetAbsOrigin()
end

function modifier_skill_overclocking:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_skill_overclocking:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():HasModifier("modifier_loser_curse") then return end
	local damage_bonus = self:GetStackCount()
	local modifier_loser_curse = self:GetParent():FindModifierByName("modifier_loser_curse")
	if modifier_loser_curse then
		damage_bonus = damage_bonus - ( damage_bonus / 100 * (-12 * modifier_loser_curse:GetStackCount()) )
	end
	return math.max(damage_bonus, 0)
end