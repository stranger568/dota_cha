modifier_skill_based = class({})

function modifier_skill_based:IsHidden() return true end
function modifier_skill_based:IsPurgable() return false end
function modifier_skill_based:IsPurgeException() return false end
function modifier_skill_based:RemoveOnDeath() return false end
function modifier_skill_based:AllowIllusionDuplicate() return true end

function modifier_skill_based:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_skill_based:GetModifierBaseDamageOutgoing_Percentage()
	return 25
end