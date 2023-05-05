modifier_skill_resister = class({})

function modifier_skill_resister:IsHidden() return true end
function modifier_skill_resister:IsPurgable() return false end
function modifier_skill_resister:IsPurgeException() return false end
function modifier_skill_resister:RemoveOnDeath() return false end
function modifier_skill_resister:AllowIllusionDuplicate() return true end

function modifier_skill_resister:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING 
	}
end

function modifier_skill_resister:GetModifierStatusResistanceStacking()
	return 30
end