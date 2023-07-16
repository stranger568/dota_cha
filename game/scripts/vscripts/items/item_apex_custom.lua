LinkLuaModifier("modifier_item_apex_custom", "items/item_apex_custom", LUA_MODIFIER_MOTION_NONE)

item_apex_custom = class({})

function item_apex_custom:GetIntrinsicModifierName()
	return "modifier_item_apex_custom"
end

modifier_item_apex_custom = class({})

function modifier_item_apex_custom:IsPurgable() return false end
function modifier_item_apex_custom:IsHidden() return false end

function modifier_item_apex_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_apex_custom:OnCreated()
    if not IsServer() then return end
    self.percent = self:GetAbility():GetSpecialValueFor("primary_stat")
    self.attribute_bonus = 0
    self.attribute_bonus_all_str = 0
    self.attribute_bonus_all_agi = 0
    self.attribute_bonus_all_int = 0
    if self:GetParent():GetPrimaryAttribute() == 0 then
        self.attribute_bonus = self:GetParent():GetStrength() / 100 * self.percent
    elseif self:GetParent():GetPrimaryAttribute() == 1 then
        self.attribute_bonus = self:GetParent():GetAgility() / 100 * self.percent
    elseif self:GetParent():GetPrimaryAttribute() == 2 then
        self.attribute_bonus = self:GetParent():GetIntellect() / 100 * self.percent
    end
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        self.attribute_bonus_all_str = self:GetParent():GetStrength() / 100 * 20
        self.attribute_bonus_all_agi = self:GetParent():GetAgility() / 100 * 20
        self.attribute_bonus_all_int = self:GetParent():GetIntellect() / 100 * 20
    end
    self:StartIntervalThink(0.25)
end

function modifier_item_apex_custom:OnIntervalThink()
	if not IsServer() then return end
    self.percent = self:GetAbility():GetSpecialValueFor("primary_stat")
    self.attribute_bonus = 0
    if self:GetParent():GetPrimaryAttribute() == 0 then
        self.attribute_bonus = self:GetParent():GetStrength() / 100 * self.percent
    elseif self:GetParent():GetPrimaryAttribute() == 1 then
        self.attribute_bonus = self:GetParent():GetAgility() / 100 * self.percent
    elseif self:GetParent():GetPrimaryAttribute() == 2 then
        self.attribute_bonus = self:GetParent():GetIntellect() / 100 * self.percent
    end
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        self.attribute_bonus_all_str = self:GetParent():GetStrength() / 100 * 20
        self.attribute_bonus_all_agi = self:GetParent():GetAgility() / 100 * 20
        self.attribute_bonus_all_int = self:GetParent():GetIntellect() / 100 * 20
    end
	self:GetParent():CalculateStatBonus(true)
end

function modifier_item_apex_custom:GetModifierBonusStats_Strength()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return self.attribute_bonus_all_str
    end
    if self:GetParent():GetPrimaryAttribute() == 0 then
        return self.attribute_bonus
    end
    return 0
end

function modifier_item_apex_custom:GetModifierBonusStats_Agility()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return self.attribute_bonus_all_agi
    end
    if self:GetParent():GetPrimaryAttribute() == 1 then
        return self.attribute_bonus
    end
    return 0
end

function modifier_item_apex_custom:GetModifierBonusStats_Intellect()
    if self:GetParent():GetPrimaryAttribute() == 3 then 
        return self.attribute_bonus_all_int
    end
    if self:GetParent():GetPrimaryAttribute() == 2 then
        return self.attribute_bonus
    end
    return 0
end
