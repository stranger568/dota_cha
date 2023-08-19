modifier_invoker_ghost_walk_lua_debuff = class({})

function modifier_invoker_ghost_walk_lua_debuff:IsPurgable()
    return false
end

function modifier_invoker_ghost_walk_lua_debuff:OnCreated()
    self.enemy_slow = self:GetAbility():GetSpecialValueFor("enemy_slow")
end

function modifier_invoker_ghost_walk_lua_debuff:OnRefresh()
    self.enemy_slow = self:GetAbility():GetSpecialValueFor("enemy_slow")
end

function modifier_invoker_ghost_walk_lua_debuff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_invoker_ghost_walk_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.enemy_slow
end

function modifier_invoker_ghost_walk_lua_debuff:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_invoker_ghost_walk_lua_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end