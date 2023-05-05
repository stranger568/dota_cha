modifier_skill_two_hearted = class({})

function modifier_skill_two_hearted:IsHidden() return true end
function modifier_skill_two_hearted:IsPurgable() return false end
function modifier_skill_two_hearted:IsPurgeException() return false end
function modifier_skill_two_hearted:RemoveOnDeath() return false end
function modifier_skill_two_hearted:AllowIllusionDuplicate() return true end

function modifier_skill_two_hearted:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_skill_two_hearted:GetModifierHealthRegenPercentage()
	return 4
end