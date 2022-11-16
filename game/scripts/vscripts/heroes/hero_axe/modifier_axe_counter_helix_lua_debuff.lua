modifier_axe_counter_helix_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_axe_counter_helix_lua_debuff:IsHidden()
    return false
end

function modifier_axe_counter_helix_lua_debuff:IsPurgable()
    return false
end

function modifier_axe_counter_helix_lua_debuff:IsDebuff()
    return true
end


function modifier_axe_counter_helix_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_axe_counter_helix_lua_debuff:GetModifierDamageOutgoing_Percentage(params)
   return   -1*self:GetStackCount() *15
end