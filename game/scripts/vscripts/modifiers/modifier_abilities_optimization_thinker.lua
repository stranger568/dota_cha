modifier_abilities_optimization_thinker = class({})

function modifier_abilities_optimization_thinker:IsHidden() return false end
function modifier_abilities_optimization_thinker:IsPurgable() return false end

function modifier_abilities_optimization_thinker:CheckState()
    return {
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
    }
end

function modifier_abilities_optimization_thinker:DeclareFunctions()
	return
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_abilities_optimization_thinker:OnTakeDamage(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local unit = params.unit
	local inflictor = params.inflictor
	if attacker == nil or unit == nil then return end

	
	-- modiifer_bloodseeker_bloodrage_custom
	if attacker:HasModifier("modiifer_bloodseeker_bloodrage_custom") then 
		local modifier = attacker:FindModifierByName("modiifer_bloodseeker_bloodrage_custom")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_abaddon_borrowed_time_custom
	if unit:HasModifier("modifier_abaddon_borrowed_time_custom") then
		local modifier = unit:FindModifierByName("modifier_abaddon_borrowed_time_custom")
		if modifier then
			modifier:_CheckHealth(params.original_damage)
		end
	end

	-- modifier_tempest_double_illusion
	if unit:HasModifier("modifier_tempest_double_illusion") then
		local modifier = unit:FindModifierByName("modifier_tempest_double_illusion")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_invoker_cold_snap_lua
	if unit:HasModifier("modifier_invoker_cold_snap_lua") then
		local modifier = unit:FindModifierByName("modifier_invoker_cold_snap_lua")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_meepo_ransack_custom
	if attacker:HasModifier("modifier_meepo_ransack_custom") then 
		local modifier = attacker:FindModifierByName("modifier_meepo_ransack_custom")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_spectre_dispersion_lua
	if unit:HasModifier("modifier_spectre_dispersion_lua") then
		local modifier = unit:FindModifierByName("modifier_spectre_dispersion_lua")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_fatal_bonds_debuff
	if unit:HasModifier("modifier_fatal_bonds_debuff") then
		local modifier = unit:FindModifierByName("modifier_fatal_bonds_debuff")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_item_bloodstone_2
	if attacker:HasModifier("modifier_item_bloodstone_2") then
		local modifier = attacker:FindModifierByName("modifier_item_bloodstone_2")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_item_summoner_crown_buff_int
	if attacker:HasModifier("modifier_item_summoner_crown_buff_int") then
		local modifier = attacker:FindModifierByName("modifier_item_summoner_crown_buff_int")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end
end

function modifier_abilities_optimization_thinker:OnAttackLanded(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local target = params.target
	if attacker == nil or target == nil then return end

	-- modiifer_bloodseeker_bloodrage_custom
	if attacker:HasModifier("modiifer_bloodseeker_bloodrage_custom") then 
		local modifier = attacker:FindModifierByName("modiifer_bloodseeker_bloodrage_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_creature_berserk
	if attacker:HasModifier("modifier_creature_berserk") then 
		local modifier = attacker:FindModifierByName("modifier_creature_berserk")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_creature_tear_armor
	if attacker:HasModifier("modifier_creature_tear_armor") then 
		local modifier = attacker:FindModifierByName("modifier_creature_tear_armor")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_axe_counter_helix_lua
	if target:HasModifier("modifier_axe_counter_helix_lua") then 
		local modifier = target:FindModifierByName("modifier_axe_counter_helix_lua")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_drow_ranger_marksmanship_custom
	if attacker:HasModifier("modifier_drow_ranger_marksmanship_custom") then 
		local modifier = attacker:FindModifierByName("modifier_drow_ranger_marksmanship_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_invoker_forge_spirit_lua
	if attacker:HasModifier("modifier_invoker_forge_spirit_lua") then 
		local modifier = attacker:FindModifierByName("modifier_invoker_forge_spirit_lua")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end


	-- modifier_liquid_fire_lua_orb
	if attacker:HasModifier("modifier_liquid_fire_lua_orb") then 
		local modifier = attacker:FindModifierByName("modifier_liquid_fire_lua_orb")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_liquid_ice_lua_orb
	if attacker:HasModifier("modifier_liquid_ice_lua_orb") then 
		local modifier = attacker:FindModifierByName("modifier_liquid_ice_lua_orb")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end


	-- modifier_monkey_king_jingu_mastery_lua
	if attacker:HasModifier("modifier_monkey_king_jingu_mastery_lua") then 
		local modifier = attacker:FindModifierByName("modifier_monkey_king_jingu_mastery_lua")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_monkey_king_jingu_mastery_lua_buff
	if attacker:HasModifier("modifier_monkey_king_jingu_mastery_lua_buff") then 
		local modifier = attacker:FindModifierByName("modifier_monkey_king_jingu_mastery_lua_buff")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_naga_siren_rip_tide_lua
	if attacker:HasModifier("modifier_naga_siren_rip_tide_lua") then 
		local modifier = attacker:FindModifierByName("modifier_naga_siren_rip_tide_lua")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_phantom_lancer_juxtapose_custom
	if attacker:HasModifier("modifier_phantom_lancer_juxtapose_custom") then 
		local modifier = attacker:FindModifierByName("modifier_phantom_lancer_juxtapose_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_troll_warlord_fervor_custom
	if attacker:HasModifier("modifier_troll_warlord_fervor_custom") then 
		local modifier = attacker:FindModifierByName("modifier_troll_warlord_fervor_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_undying_tombstone_lua_passive
	if attacker:HasModifier("modifier_undying_tombstone_lua_passive") then 
		local modifier = attacker:FindModifierByName("modifier_undying_tombstone_lua_passive")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_faceless_void_time_lock_custom
	if attacker:HasModifier("modifier_faceless_void_time_lock_custom") then 
		local modifier = attacker:FindModifierByName("modifier_faceless_void_time_lock_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_hellmask
	if attacker:HasModifier("modifier_item_hellmask") then 
		local modifier = attacker:FindModifierByName("modifier_item_hellmask")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_wraith_dominator_aura_buff
	if attacker:HasModifier("modifier_item_wraith_dominator_aura_buff") then 
		local modifier = attacker:FindModifierByName("modifier_item_wraith_dominator_aura_buff")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	if attacker:HasModifier("modifier_bounty_hunter_jinada_custom_crit") then 
		local modifier = attacker:FindModifierByName("modifier_bounty_hunter_jinada_custom_crit")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_rapier_custom
	if attacker:HasModifier("modifier_item_rapier_custom") then 
		local modifier = attacker:FindModifierByName("modifier_item_rapier_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_silencer_glaives_of_wisdom_custom
	if attacker:HasModifier("modifier_silencer_glaives_of_wisdom_custom") then 
		local modifier = attacker:FindModifierByName("modifier_silencer_glaives_of_wisdom_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end
end

function modifier_abilities_optimization_thinker:OnAttack(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local target = params.target
	if attacker == nil or target == nil then return end

	-- modifier_gyrocopter_flak_cannon_lua
	if attacker:HasModifier("modifier_gyrocopter_flak_cannon_lua") then 
		local modifier = attacker:FindModifierByName("modifier_gyrocopter_flak_cannon_lua")
		if modifier then
			modifier:AttackModifier( params )
		end
	end

	-- modifier_silencer_glaives_of_wisdom_custom
	if attacker:HasModifier("modifier_silencer_glaives_of_wisdom_custom") then 
		local modifier = attacker:FindModifierByName("modifier_silencer_glaives_of_wisdom_custom")
		if modifier then
			modifier:AttackModifier( params )
		end
	end

	-- modifier_liquid_fire_lua_orb
	if attacker:HasModifier("modifier_liquid_fire_lua_orb") then 
		local modifier = attacker:FindModifierByName("modifier_liquid_fire_lua_orb")
		if modifier then
			modifier:AttackModifier( params )
		end
	end

	-- modifier_frostivus2018_weaver_geminate_attack_custom
	if attacker:HasModifier("modifier_frostivus2018_weaver_geminate_attack_custom") then 
		local modifier = attacker:FindModifierByName("modifier_frostivus2018_weaver_geminate_attack_custom")
		if modifier then
			modifier:AttackModifier( params )
		end
	end
end

function modifier_abilities_optimization_thinker:OnDeath(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local target = params.unit

	if attacker:HasModifier("modifier_alchemist_goblins_greed_custom") then
		local modifier = attacker:FindModifierByName("modifier_alchemist_goblins_greed_custom")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_axe_battle_hunger_custom_debuff") then
		local modifier = target:FindModifierByName("modifier_axe_battle_hunger_custom_debuff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_silencer_glaives_of_wisdom_custom_debuff") then
		local modifier = target:FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_debuff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_dark_seer_wall_of_replica_nb2017") then
		local modifier = target:FindModifierByName("modifier_dark_seer_wall_of_replica_nb2017")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_duel_buff") then
		local modifier = target:FindModifierByName("modifier_duel_buff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_lion_finger_of_death_custom_buff") then
		local modifier = target:FindModifierByName("modifier_lion_finger_of_death_custom_buff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_lina_laguna_blade_custom_damage") then
		local modifier = target:FindModifierByName("modifier_lina_laguna_blade_custom_damage")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_necrolyte_heartstopper_aura_lua") then
		local modifier = attacker:FindModifierByName("modifier_necrolyte_heartstopper_aura_lua")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_phantom_lancer_juxtapose_custom") then
		local modifier = target:FindModifierByName("modifier_phantom_lancer_juxtapose_custom")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_sand_king_caustic_finale_lua_debuff") then
		local modifier = target:FindModifierByName("modifier_sand_king_caustic_finale_lua_debuff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_slark_essence_shift_lua") then
		local modifier = attacker:FindModifierByName("modifier_slark_essence_shift_lua")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_aegis") then
		local modifier = target:FindModifierByName("modifier_aegis")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_bounty_hunter_track_creep") then
		local modifier = target:FindModifierByName("modifier_bounty_hunter_track_creep")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_item_bloodstone_2") then
		local modifier = attacker:FindModifierByName("modifier_item_bloodstone_2")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_item_hellmask") then
		local modifier = attacker:FindModifierByName("modifier_item_hellmask")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if not attacker:IsHero() and attacker:GetOwner() ~= nil then
		if attacker:GetOwner():HasModifier("modifier_item_bloodstone_2") then
			local modifier = attacker:GetOwner():FindModifierByName("modifier_item_bloodstone_2")
			if modifier then
				modifier:OnDeathEvent(params)
			end
		end
		if attacker:GetOwner():HasModifier("modifier_item_hellmask") then
			local modifier = attacker:GetOwner():FindModifierByName("modifier_item_hellmask")
			if modifier then
				modifier:OnDeathEvent(params)
			end
		end
	end
end