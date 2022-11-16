modifier_invoker_alacrity_talent = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_alacrity_talent:IsHidden()
    return true
end

function modifier_invoker_alacrity_talent:IsDebuff()
    return false
end

function modifier_invoker_alacrity_talent:IsPurgable()
    return false
end

--------------------------------------------------------------------------------