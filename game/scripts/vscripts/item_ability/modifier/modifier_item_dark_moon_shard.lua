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
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	local flBaseAttackTime = self.parent:GetBaseAttackTime()
    local nbaseAttackReduction = 23
    if self.ability then
       nbaseAttackReduction = self.ability:GetSpecialValueFor("base_attack_time_reduction")
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
        local bonus = 0
        if self.parent:HasModifier("modifier_skill_swiftness") then
            bonus = -0.2
        end
        return self.flBaseAttackTime + bonus
    end
end
