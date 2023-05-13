modifier_skill_teachers_gift = class({})

function modifier_skill_teachers_gift:IsHidden() return true end
function modifier_skill_teachers_gift:IsPurgable() return false end
function modifier_skill_teachers_gift:IsPurgeException() return false end
function modifier_skill_teachers_gift:RemoveOnDeath() return false end
function modifier_skill_teachers_gift:AllowIllusionDuplicate() return true end

function modifier_skill_teachers_gift:OnCreated()
	if not IsServer() then return end
	self:GetParent():CalculateStatBonus(true)
end

function modifier_skill_teachers_gift:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end

function modifier_skill_teachers_gift:GetModifierBonusStats_Strength()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return 50
    end
    if self:GetParent():GetPrimaryAttribute() ~= 0 then
        return 75
    end
    return 0
end

function modifier_skill_teachers_gift:GetModifierBonusStats_Agility()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return 50
    end
    if self:GetParent():GetPrimaryAttribute() ~= 1 then
        return 75
    end
    return 0
end

function modifier_skill_teachers_gift:GetModifierBonusStats_Intellect()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return 50
    end
    if self:GetParent():GetPrimaryAttribute() ~= 2 then
        return 75
    end
    return 0
end