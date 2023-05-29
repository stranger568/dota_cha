modifier_skill_veteran = class({})

function modifier_skill_veteran:IsHidden() return true end
function modifier_skill_veteran:IsPurgable() return false end
function modifier_skill_veteran:IsPurgeException() return false end
function modifier_skill_veteran:RemoveOnDeath() return false end
function modifier_skill_veteran:AllowIllusionDuplicate() return true end

function modifier_skill_veteran:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_EXP_RATE_BOOST 
	}
end

function modifier_skill_veteran:GetModifierPercentageExpRateBoost()
	return 100
end