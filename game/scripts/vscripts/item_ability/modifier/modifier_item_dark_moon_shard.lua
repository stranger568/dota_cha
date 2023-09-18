modifier_item_dark_moon_shard = class({})

function modifier_item_dark_moon_shard:IsHidden()
	return true
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
end

function modifier_item_dark_moon_shard:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end

function modifier_item_dark_moon_shard:GetModifierAttackSpeedPercentage()
    return 35
end
