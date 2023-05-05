LinkLuaModifier("modifier_skill_mage_slayer_debuff", "modifiers/skills/modifier_skill_mage_slayer", LUA_MODIFIER_MOTION_NONE)

modifier_skill_mage_slayer = class({})

function modifier_skill_mage_slayer:IsHidden() return true end
function modifier_skill_mage_slayer:IsPurgable() return false end
function modifier_skill_mage_slayer:IsPurgeException() return false end
function modifier_skill_mage_slayer:RemoveOnDeath() return false end
function modifier_skill_mage_slayer:AllowIllusionDuplicate() return true end

function modifier_skill_mage_slayer:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then

        if params.target:IsOther() then
            return nil
        end

        if self:GetParent():IsIllusion() then
            return nil
        end

        params.target:AddNewModifier(self:GetParent(), nil, "modifier_skill_mage_slayer_debuff", {duration = (1 - params.target:GetStatusResistance())*5})
    end
end

function modifier_skill_mage_slayer:GetModifierMagicalResistanceBonus()
    return 25
end

function modifier_skill_mage_slayer:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

modifier_skill_mage_slayer_debuff = class({})

function modifier_skill_mage_slayer_debuff:GetTexture() return "modifier_skill_mage_slayer" end

function modifier_skill_mage_slayer_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_skill_mage_slayer_debuff:GetModifierSpellAmplify_Percentage()
	return -40
end