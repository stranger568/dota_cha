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
	return 40
end

function modifier_skill_berserker:GetModifierIncomingDamage_Percentage()
	return 15
end