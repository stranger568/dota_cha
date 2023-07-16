modifier_skill_double_trouble = class({})

function modifier_skill_double_trouble:IsHidden() return true end
function modifier_skill_double_trouble:IsPurgable() return false end
function modifier_skill_double_trouble:IsPurgeException() return false end
function modifier_skill_double_trouble:RemoveOnDeath() return false end
function modifier_skill_double_trouble:AllowIllusionDuplicate() return true end

function modifier_skill_double_trouble:DeclareFunctions()
    return  
    {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_skill_double_trouble:GetModifierTotalDamageOutgoing_Percentage(params)
    if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
        if RollPercentage(50) then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, params.original_damage * 1.5, nil)
            return 50
        end
    end
end