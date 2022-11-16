modifier_meepo_talent = class({})

function modifier_meepo_talent:IsHidden() return true end

function modifier_meepo_talent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_RAT_PACK,
	}
end

function modifier_meepo_talent:GetModifierIsRatPack()
	return 1
end