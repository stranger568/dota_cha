modifier_skill_ultimate_strength = class({})

function modifier_skill_ultimate_strength:IsHidden() return true end
function modifier_skill_ultimate_strength:IsPurgable() return false end
function modifier_skill_ultimate_strength:IsPurgeException() return false end
function modifier_skill_ultimate_strength:RemoveOnDeath() return false end
function modifier_skill_ultimate_strength:AllowIllusionDuplicate() return true end

function modifier_skill_ultimate_strength:OnCreated()
	if not IsServer() then return end
	self:GetParent():CalculateStatBonus(true)
end

function modifier_skill_ultimate_strength:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_skill_ultimate_strength:GetModifierBonusStats_Strength()
	return 15
end

function modifier_skill_ultimate_strength:GetModifierBonusStats_Agility()
	return 15
end

function modifier_skill_ultimate_strength:GetModifierBonusStats_Intellect()
	return 15
end