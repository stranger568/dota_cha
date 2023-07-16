modifier_skill_amplification = class({})

function modifier_skill_amplification:IsHidden() return true end
function modifier_skill_amplification:IsPurgable() return false end
function modifier_skill_amplification:IsPurgeException() return false end
function modifier_skill_amplification:RemoveOnDeath() return false end
function modifier_skill_amplification:AllowIllusionDuplicate() return true end

function modifier_skill_amplification:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
	}
end

function modifier_skill_amplification:GetModifierSpellAmplify_Percentage()
	return 7
end

function modifier_skill_amplification:GetModifierPercentageManacostStacking()
	return 7
end