centaur_return_lua = class({})
LinkLuaModifier( "modifier_centaur_return_lua", "heroes/hero_centaur/modifier_centaur_return_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_lua_aura", "heroes/hero_centaur/modifier_centaur_return_lua_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function centaur_return_lua:GetIntrinsicModifierName()
	return "modifier_centaur_return_lua_aura"
end
