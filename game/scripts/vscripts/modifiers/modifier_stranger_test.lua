modifier_stranger_test = class({})

function modifier_stranger_test:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_stranger_test:GetModifierDamageOutgoing_Percentage()
    return 10000
end

function modifier_stranger_test:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end