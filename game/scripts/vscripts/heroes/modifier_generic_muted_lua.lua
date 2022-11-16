modifier_generic_muted_lua = class({})

--------------------------------------------------------------------------------

function modifier_generic_muted_lua:IsDebuff()
	return true
end

function modifier_generic_muted_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_muted_lua:CheckState()
	local state = {
	[MODIFIER_STATE_MUTED] = true,
	}
	return state
end
