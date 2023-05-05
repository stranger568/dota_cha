modifier_skill_dodger = class({})

function modifier_skill_dodger:IsHidden() return true end
function modifier_skill_dodger:IsPurgable() return false end
function modifier_skill_dodger:IsPurgeException() return false end
function modifier_skill_dodger:RemoveOnDeath() return false end
function modifier_skill_dodger:AllowIllusionDuplicate() return true end

function modifier_skill_dodger:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_skill_dodger:GetModifierEvasion_Constant()
	return 25
end