modifier_loser_curse = class({})


function modifier_loser_curse:GetTexture()
	return "doom_bringer_doom"
end


function modifier_loser_curse:IsHidden()
	return false
end

function modifier_loser_curse:IsDebuff()
	return true
end

function modifier_loser_curse:IsPurgable()
	return false
end

function modifier_loser_curse:IsPermanent()
	return true
end


function modifier_loser_curse:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
       MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
       MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end


function modifier_loser_curse:GetModifierIncomingDamage_Percentage(params)
	if true==self:GetParent().bJoiningPvp then
		return 0
	else
		return 25*self:GetStackCount()
	end
end


function modifier_loser_curse:GetModifierTotalDamageOutgoing_Percentage(params)
	if true==self:GetParent().bJoiningPvp then
		 return 0
    else
         return -25*self:GetStackCount()
    end
end

function modifier_loser_curse:GetModifierBonusStats_Strength(params)
	if true==self:GetParent().bJoiningPvp then
		 return 0
    else
         return -0.1*self:GetStackCount()*self:GetParent():GetBaseStrength()
    end
end

function modifier_loser_curse:GetModifierBonusStats_Agility(params)
	if true==self:GetParent().bJoiningPvp then
		 return 0
    else
         return -0.1*self:GetStackCount()*self:GetParent():GetBaseAgility()
    end
end

function modifier_loser_curse:GetModifierBonusStats_Intellect(params)
	if true==self:GetParent().bJoiningPvp then
		 return 0
    else
         return -0.1*self:GetStackCount()*self:GetParent():GetBaseIntellect()
    end
end