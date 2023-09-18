modifier_skill_speedster = class({})

function modifier_skill_speedster:IsHidden() return true end
function modifier_skill_speedster:IsPurgable() return false end
function modifier_skill_speedster:IsPurgeException() return false end
function modifier_skill_speedster:RemoveOnDeath() return false end
function modifier_skill_speedster:AllowIllusionDuplicate() return true end

function modifier_skill_speedster:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_skill_speedster:GetModifierAttackSpeedBonus_Constant()
	return 60
end