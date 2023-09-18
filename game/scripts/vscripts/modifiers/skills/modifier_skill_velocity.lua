modifier_skill_velocity = class({})

function modifier_skill_velocity:IsHidden() return true end
function modifier_skill_velocity:IsPurgable() return false end
function modifier_skill_velocity:IsPurgeException() return false end
function modifier_skill_velocity:RemoveOnDeath() return false end
function modifier_skill_velocity:AllowIllusionDuplicate() return true end

function modifier_skill_velocity:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_skill_velocity:CheckState()
    return
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_skill_velocity:GetModifierMoveSpeedBonus_Constant()
    return 75
end