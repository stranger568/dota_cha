modifier_skill_wisdom = class({})

function modifier_skill_wisdom:IsHidden() return false end
function modifier_skill_wisdom:IsPurgable() return false end
function modifier_skill_wisdom:IsPurgeException() return false end
function modifier_skill_wisdom:RemoveOnDeath() return false end
function modifier_skill_wisdom:AllowIllusionDuplicate() return true end
function modifier_skill_wisdom:GetTexture() return "skill_wisdom" end
function modifier_skill_wisdom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_skill_wisdom:GetModifierSpellAmplify_Percentage()
    return self:GetParent():GetLevel() * 0.2
end