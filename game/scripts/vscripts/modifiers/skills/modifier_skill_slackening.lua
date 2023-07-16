LinkLuaModifier("modifier_skill_slackening_debuff", "modifiers/skills/modifier_skill_slackening", LUA_MODIFIER_MOTION_NONE)

modifier_skill_slackening = class({})

function modifier_skill_slackening:IsHidden() return true end
function modifier_skill_slackening:IsPurgable() return false end
function modifier_skill_slackening:IsPurgeException() return false end
function modifier_skill_slackening:RemoveOnDeath() return false end
function modifier_skill_slackening:AllowIllusionDuplicate() return true end

function modifier_skill_slackening:OnCreated()
    self.parent = self:GetParent()
    self:StartIntervalThink(1)
end

function modifier_skill_slackening:OnIntervalThink()
    if not IsServer() then return end
    self.parent:CalculateStatBonus(true)
end

function modifier_skill_slackening:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_skill_slackening:GetModifierHealthBonus()
	return self.parent:GetStrength() / 5 * 22
end

function modifier_skill_slackening:GetModifierManaBonus()
	return self.parent:GetIntellect() / 5 * 12
end

function modifier_skill_slackening:GetAuraRadius()
	return 800
end

function modifier_skill_slackening:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_skill_slackening:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_slackening:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_skill_slackening:GetModifierAura()
	return "modifier_skill_slackening_debuff"
end

function modifier_skill_slackening:IsAura()
	return true
end

modifier_skill_slackening_debuff = class({})

function modifier_skill_slackening_debuff:GetTexture() return "modifier_skill_slackening" end

function modifier_skill_slackening_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
end

function modifier_skill_slackening_debuff:GetModifierLifestealRegenAmplify_Percentage()
	return -40
end

function modifier_skill_slackening_debuff:GetModifierHealAmplify_PercentageTarget()
	return -40
end

function modifier_skill_slackening_debuff:GetModifierHPRegenAmplify_Percentage()
	return -40
end
