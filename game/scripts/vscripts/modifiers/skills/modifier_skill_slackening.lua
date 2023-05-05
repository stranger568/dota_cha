LinkLuaModifier("modifier_skill_slackening_debuff", "modifiers/skills/modifier_skill_slackening", LUA_MODIFIER_MOTION_NONE)

modifier_skill_slackening = class({})

function modifier_skill_slackening:IsHidden() return true end
function modifier_skill_slackening:IsPurgable() return false end
function modifier_skill_slackening:IsPurgeException() return false end
function modifier_skill_slackening:RemoveOnDeath() return false end
function modifier_skill_slackening:AllowIllusionDuplicate() return true end

function modifier_skill_slackening:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then

        if params.target:IsOther() then
            return nil
        end

        if self:GetParent():IsIllusion() then
            return nil
        end

        params.target:AddNewModifier(self:GetParent(), nil, "modifier_skill_slackening_debuff", {duration = (1 - params.target:GetStatusResistance())*3})
    end
end

function modifier_skill_slackening:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
	}
end

function modifier_skill_slackening:GetModifierExtraManaPercentage()
	return 15
end

function modifier_skill_slackening:GetModifierExtraHealthPercentage()
	return 15
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
