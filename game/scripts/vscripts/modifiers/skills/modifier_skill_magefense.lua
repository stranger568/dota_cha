modifier_skill_magefense = class({})

function modifier_skill_magefense:IsHidden() return true end
function modifier_skill_magefense:IsPurgable() return false end
function modifier_skill_magefense:IsPurgeException() return false end
function modifier_skill_magefense:RemoveOnDeath() return false end
function modifier_skill_magefense:AllowIllusionDuplicate() return true end

function modifier_skill_magefense:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_skill_magefense:GetModifierMagicalResistanceBonus()
    return 40
end