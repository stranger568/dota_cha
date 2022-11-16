modifier_cha_ban = class({})

function modifier_cha_ban:GetTexture()
	return "solo322"
end


function modifier_cha_ban:IsHidden()
	return false
end

function modifier_cha_ban:IsDebuff()
	return true
end

function modifier_cha_ban:IsPurgable()
	return false
end

function modifier_cha_ban:IsPermanent()
	return true
end

function modifier_cha_ban:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
       MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
       MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
       MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_cha_ban:GetModifierIncomingDamage_Percentage(params)
	return 15
end

function modifier_cha_ban:OnTooltip()
	return self:GetStackCount()
end

function modifier_cha_ban:GetModifierTotalDamageOutgoing_Percentage(params)
    return -15
end

function modifier_cha_ban:GetModifierBonusStats_Strength(params)
    return -0.1*self:GetParent():GetBaseStrength()
end

function modifier_cha_ban:GetModifierBonusStats_Agility(params)
    return -0.1*self:GetParent():GetBaseAgility()
end

function modifier_cha_ban:GetModifierBonusStats_Intellect(params)
    return -0.1*self:GetParent():GetBaseIntellect()
end