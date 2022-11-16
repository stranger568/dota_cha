shredder_chakram_lua = class({})
shredder_chakram_lua_return = class({})

LinkLuaModifier("modifier_shredder_chakram_thinker_lua", "heroes/hero_shredder/modifier_shredder_chakram_thinker_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredder_chakram_slow_lua", "heroes/hero_shredder/modifier_shredder_chakram_slow_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredder_chakram_disarm_lua", "heroes/hero_shredder/modifier_shredder_chakram_disarm_lua", LUA_MODIFIER_MOTION_NONE)

shredder_chakram_lua.return_ability_name = "shredder_chakram_lua_return"


function shredder_chakram_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function shredder_chakram_lua:OnUpgrade()
	if not IsServer() then return end
	if self.is_scepter then return end

	local scepter_ability = self:GetCaster():FindAbilityByName("shredder_chakram_2_lua")
	if scepter_ability and not scepter_ability:IsNull() then
		scepter_ability:SetLevel(self:GetLevel())
	end
end


function shredder_chakram_lua:OnSpellStart()
	local caster = self:GetCaster()
	local cast_point = self:GetCursorPosition()

	local thinker = CreateModifierThinker(
		caster, 
		self, 
		"modifier_shredder_chakram_thinker_lua", -- modifier name
		{
			target_x = cast_point.x,
			target_y = cast_point.y,
			target_z = cast_point.z,
			scepter = self.is_scepter
		},
		caster:GetAbsOrigin(),
		caster:GetTeamNumber(),
		false
	)

	local modifier = thinker:FindModifierByName("modifier_shredder_chakram_thinker_lua")
	local return_ability = caster:FindAbilityByName(self.return_ability_name)

	if not return_ability then
		return_ability = caster:AddAbility(self.return_ability_name)
	end

	return_ability.thinker_modifier = modifier
	return_ability:SetLevel(1)

	caster:SwapAbilities(
		self:GetAbilityName(),
		self.return_ability_name,
		false,
		true
	)

	caster:EmitSound("Hero_Shredder.Chakram.Cast")
end


function shredder_chakram_lua_return:OnSpellStart()
	if not self.thinker_modifier or self.thinker_modifier:IsNull() then return end
	self.thinker_modifier:Return()
end


shredder_chakram_2_lua = class(shredder_chakram_lua)
shredder_chakram_2_lua.is_scepter = true
shredder_chakram_2_lua.return_ability_name = "shredder_chakram_lua_2_return"


function shredder_chakram_2_lua:Spawn()
	if not IsServer() then return end
	local caster = self:GetCaster()

	local main_ability = caster:FindAbilityByName("shredder_chakram_lua")
	if not main_ability or main_ability:IsNull() or main_ability:GetLevel() == 0 then return end

	-- spawn is called on ability init, setting level at this stage does nothing as it gets overridden
	-- by scepter management logic afterwards, thus waiting next frame
	Timers:CreateTimer(0, function()
		if not self or self:IsNull() or not main_ability or main_ability:IsNull() then return end
		self:SetLevel(main_ability:GetLevel())
	end)
end


shredder_chakram_lua_2_return = class(shredder_chakram_lua_return)
