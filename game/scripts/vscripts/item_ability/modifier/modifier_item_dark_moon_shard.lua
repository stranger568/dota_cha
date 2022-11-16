modifier_item_dark_moon_shard = class({})

function modifier_item_dark_moon_shard:IsHidden()
	return false
end

function modifier_item_dark_moon_shard:GetTexture()
	return "item_dark_moon_shard"
end


function modifier_item_dark_moon_shard:IsPermanent()
	return true
end


function modifier_item_dark_moon_shard:IsPurgable()
	return false
end

function modifier_item_dark_moon_shard:OnCreated()
	local flBaseAttackTime = self:GetParent():GetBaseAttackTime()
    local nbaseAttackReduction = 23
    if self:GetAbility() then
       nbaseAttackReduction = self:GetAbility():GetSpecialValueFor("base_attack_time_reduction")
    end
    self.flBaseAttackTime = flBaseAttackTime* (100-nbaseAttackReduction)/100
end



function modifier_item_dark_moon_shard:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end


function modifier_item_dark_moon_shard:GetModifierBaseAttackTimeConstant()
    
    if self.flBaseAttackTime then
       return self.flBaseAttackTime
    end

end
