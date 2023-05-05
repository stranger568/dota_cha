modifier_skill_ranger = class({})

function modifier_skill_ranger:IsHidden() return true end
function modifier_skill_ranger:IsPurgable() return false end
function modifier_skill_ranger:IsPurgeException() return false end
function modifier_skill_ranger:RemoveOnDeath() return false end
function modifier_skill_ranger:AllowIllusionDuplicate() return true end

function modifier_skill_ranger:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end

function modifier_skill_ranger:GetModifierAttackRangeBonus()
    return 300
end