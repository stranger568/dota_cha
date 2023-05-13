modifier_skill_masters_gift = class({})

function modifier_skill_masters_gift:IsHidden() return true end
function modifier_skill_masters_gift:IsPurgable() return false end
function modifier_skill_masters_gift:IsPurgeException() return false end
function modifier_skill_masters_gift:RemoveOnDeath() return false end
function modifier_skill_masters_gift:AllowIllusionDuplicate() return true end

function modifier_skill_masters_gift:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_skill_masters_gift:GetModifierBonusStats_Strength()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return 15
    end
    if self:GetParent():GetPrimaryAttribute() == 0 then return end
    return 25
end

function modifier_skill_masters_gift:GetModifierBonusStats_Agility()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return 15
    end
    if self:GetParent():GetPrimaryAttribute() == 1 then return end
    return 25
end

function modifier_skill_masters_gift:GetModifierBonusStats_Intellect()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return 15
    end
    if self:GetParent():GetPrimaryAttribute() == 2 then return end
    return 25
end