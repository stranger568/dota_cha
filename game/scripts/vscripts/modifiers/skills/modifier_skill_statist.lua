modifier_skill_statist = class({})

function modifier_skill_statist:IsHidden() return true end
function modifier_skill_statist:IsPurgable() return false end
function modifier_skill_statist:IsPurgeException() return false end
function modifier_skill_statist:RemoveOnDeath() return false end
function modifier_skill_statist:AllowIllusionDuplicate() return true end

function modifier_skill_statist:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_skill_statist:GetModifierBonusStats_Agility()
	return 1.25 * self:GetParent():GetLevel()
end

function modifier_skill_statist:GetModifierBonusStats_Intellect()
	return 1.25 * self:GetParent():GetLevel()
end

function modifier_skill_statist:GetModifierBonusStats_Strength()
	return 1.25 * self:GetParent():GetLevel()
end