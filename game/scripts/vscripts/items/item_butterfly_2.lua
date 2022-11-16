LinkLuaModifier("modifier_item_butterfly_2", "items/item_butterfly_2", LUA_MODIFIER_MOTION_NONE)

item_butterfly_2 = class({})

function item_butterfly_2:GetIntrinsicModifierName()
    return "modifier_item_butterfly_2"
end

modifier_item_butterfly_2 = class({})

function modifier_item_butterfly_2:IsHidden()
    return true
end

function modifier_item_butterfly_2:IsPurgable()
    return false
end

function modifier_item_butterfly_2:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_butterfly_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_butterfly_2:GetModifierBonusStats_Agility()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor('bonus_agility')
    end
end

function modifier_item_butterfly_2:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor('bonus_damage')
    end
end

function modifier_item_butterfly_2:GetModifierEvasion_Constant()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor('bonus_evasion')
    end
end

function modifier_item_butterfly_2:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
    end
end

function modifier_item_butterfly_2:GetModifierMoveSpeedBonus_Constant()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor('bonus_movespeed')
    end
end