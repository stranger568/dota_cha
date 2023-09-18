modifier_skill_recovery = class({})

function modifier_skill_recovery:IsHidden() return true end
function modifier_skill_recovery:IsPurgable() return false end
function modifier_skill_recovery:IsPurgeException() return false end
function modifier_skill_recovery:RemoveOnDeath() return false end
function modifier_skill_recovery:AllowIllusionDuplicate() return true end

function modifier_skill_recovery:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_skill_recovery:GetModifierConstantHealthRegen()
	return 40
end

function modifier_skill_recovery:GetModifierConstantManaRegen()
	return 15
end