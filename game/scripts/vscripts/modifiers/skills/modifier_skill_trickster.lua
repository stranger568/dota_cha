modifier_skill_trickster = class({})

function modifier_skill_trickster:IsHidden() return true end
function modifier_skill_trickster:IsPurgable() return false end
function modifier_skill_trickster:IsPurgeException() return false end
function modifier_skill_trickster:RemoveOnDeath() return false end
function modifier_skill_trickster:AllowIllusionDuplicate() return true end

function modifier_skill_trickster:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

function modifier_skill_trickster:GetModifierEvasion_Constant()
    return 45
end