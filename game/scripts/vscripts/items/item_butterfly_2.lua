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
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_AVOID_DAMAGE
    }

    return funcs
end

function modifier_item_butterfly_2:OnCreated()
    self.ability = self:GetAbility()
    self.bonus_agility = self.ability:GetSpecialValueFor('bonus_agility')
    self.bonus_damage = self.ability:GetSpecialValueFor('bonus_damage')
    self.bonus_evasion = self.ability:GetSpecialValueFor('bonus_evasion')
    self.bonus_attack_speed = self.ability:GetSpecialValueFor('bonus_attack_speed')
    self.bonus_movespeed = self.ability:GetSpecialValueFor('bonus_movespeed')
    self.bonus_universal_evasion = self.ability:GetSpecialValueFor('bonus_universal_evasion')
end

function modifier_item_butterfly_2:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_item_butterfly_2:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_item_butterfly_2:GetModifierEvasion_Constant()
    return self.bonus_evasion
end

function modifier_item_butterfly_2:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

function modifier_item_butterfly_2:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_movespeed
end

function modifier_item_butterfly_2:GetModifierAvoidDamage()
    if not IsServer() then return end
    if RollPercentage(self.bonus_universal_evasion) then
        return 1
    end
    return 0
end