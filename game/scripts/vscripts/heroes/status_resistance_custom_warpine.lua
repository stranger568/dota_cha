LinkLuaModifier("modifier_status_resistance_custom_warpine", "heroes/status_resistance_custom_warpine", LUA_MODIFIER_MOTION_NONE)

status_resistance_custom_warpine = class({})

function status_resistance_custom_warpine:GetIntrinsicModifierName()
	return "modifier_status_resistance_custom_warpine"
end

modifier_status_resistance_custom_warpine = class({})

function modifier_status_resistance_custom_warpine:IsHidden() return true end

function modifier_status_resistance_custom_warpine:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_status_resistance_custom_warpine:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("status_resistance")
end