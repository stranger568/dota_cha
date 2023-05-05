modifier_skill_berserker = class({})

function modifier_skill_berserker:IsHidden() return true end
function modifier_skill_berserker:IsPurgable() return false end
function modifier_skill_berserker:IsPurgeException() return false end
function modifier_skill_berserker:RemoveOnDeath() return false end
function modifier_skill_berserker:AllowIllusionDuplicate() return true end

function modifier_skill_berserker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_skill_berserker:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():HasModifier("modifier_loser_curse") then return end
	return 35
end

function modifier_skill_berserker:GetModifierIncomingDamage_Percentage()
	if self:GetParent():HasModifier("modifier_loser_curse") then return end
	return 15
end