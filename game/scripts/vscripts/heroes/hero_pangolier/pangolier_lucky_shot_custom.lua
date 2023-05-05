LinkLuaModifier("modifier_pangolier_lucky_shot_custom", "heroes/hero_pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)

pangolier_lucky_shot_custom = class({})

local proc_abilities = 
{
    pangolier_swashbuckle = true,
    pangolier_shield_crash = true,
    pangolier_heartpiercer_custom = true,
    pangolier_gyroshell = true,
    pangolier_rollup = true,
}

function pangolier_lucky_shot_custom:GetIntrinsicModifierName()
    return "modifier_pangolier_lucky_shot_custom"
end

modifier_pangolier_lucky_shot_custom = class({})

function modifier_pangolier_lucky_shot_custom:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom:IsPurgable() return false end
function modifier_pangolier_lucky_shot_custom:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_pangolier_lucky_shot_custom:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_pangolier_lucky_shot_custom:GetModifierTotalDamageOutgoing_Percentage(params)
    if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then return end

    if params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK or (params.inflictor and proc_abilities[params.inflictor:GetAbilityName()]) then
        local chance = self:GetAbility():GetSpecialValueFor("chance_pct")

        if not params.target:IsMagicImmune() and RollPercentage(chance) then
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_luckyshot_disarm", { duration = duration * (1 - params.target:GetStatusResistance()) })
        end
    end
end