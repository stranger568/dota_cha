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
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_HEAL_RECEIVED
	}
end

function modifier_abilities_optimization_thinker:OnHealReceived( params )

end

function modifier_abilities_optimization_thinker:OnAbilityFullyCast( params )
	local unit = params.unit
	if unit == nil then return end
	if unit:HasModifier("modifier_oracle_false_promise_custom") then
		local modifier_oracle_false_promise_custom = unit:FindModifierByName("modifier_oracle_false_promise_custom")
		if modifier_oracle_false_promise_custom then
			modifier_oracle_false_promise_custom:OnAbilityfullCastCustom(params)
		end
	end
	if unit:HasModifier("modifier_skill_rearm") then
		local modifier_skill_rearm = unit:FindModifierByName("modifier_skill_rearm")
		if modifier_skill_rearm then
			modifier_skill_rearm:OnAbilityfullCastCustom(params)
		end
	end
end

function modifier_abilities_optimization_thinker:OnAbilityExecuted( params )
	if not IsServer() then return end
	if not params.ability then return end
	local unit = params.unit
	if unit == nil then return end
	if params.unit:HasModifier("modifier_skill_multicast") then
		local modifier_skill_multicast = params.unit:FindModifierByName("modifier_skill_multicast")
		if modifier_skill_multicast then
			modifier_skill_multicast:OnAbilityExecutedCustom(params)
		end
	end

	if params.ability:GetAbilityName() == "warlock_rain_of_chaos" then
	    for _, warlock_gl in pairs(FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do
	        if warlock_gl:GetUnitName() == "npc_dota_warlock_golem" and warlock_gl:GetOwner() == unit then
	            warlock_gl:ForceKill(false)               
	       	end
	    end
	end

	if params.ability:GetAbilityName() == "skeleton_king_vampiric_aura_custom" then
	    for _, warlock_gl in pairs(FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do
	        if warlock_gl:GetUnitName() == "npc_dota_wraith_king_skeleton_warrior" and warlock_gl:GetOwner() == unit then
	            warlock_gl:Destroy()             
	       	end
	    end
	end

	if params.unit:HasModifier("modifier_multicast_lua") then
		local modifier_multicast_lua = params.unit:FindModifierByName("modifier_multicast_lua")
		if modifier_multicast_lua then
			modifier_multicast_lua:OnAbilityExecutedCustom(params)
		end
	end

	if params.unit:HasModifier("modifier_lina_fiery_soul_lua") then
		local modifier_lina_fiery_soul_lua = params.unit:FindModifierByName("modifier_lina_fiery_soul_lua")
		if modifier_lina_fiery_soul_lua then
			modifier_lina_fiery_soul_lua:OnAbilityExecutedCustom(params)
		end
	end

	if params.unit:HasModifier("modifier_monkey_king_jingu_mastery_lua_buff") then
		local modifier_monkey_king_jingu_mastery_lua_buff = params.unit:FindModifierByName("modifier_monkey_king_jingu_mastery_lua_buff")
		if modifier_monkey_king_jingu_mastery_lua_buff then
			modifier_monkey_king_jingu_mastery_lua_buff:OnAbilityExecutedCustom(params)
		end
	end

	if params.ability:GetAbilityName() == "item_abyssal_blade" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 31, 1)
	end
	if params.ability:GetAbilityName() == "item_nullifier" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 32, 1)
	end
	if params.ability:GetAbilityName() == "item_sheepstick" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 33, 1)
	end
	if params.ability:GetAbilityName() == "item_orchid" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 35, 1)
	end
	if params.ability:GetAbilityName() == "item_bloodthorn" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 35, 1)
	end
	if params.ability:GetAbilityName() == "item_ethereal_blade" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 36, 1)
	end
	if params.ability:GetAbilityName() == "item_dagon_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 34, 1)
	end
	if params.ability:GetAbilityName() == "item_dagon_2_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 34, 1)
	end
	if params.ability:GetAbilityName() == "item_dagon_3_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 34, 1)
	end
	if params.ability:GetAbilityName() == "item_dagon_4_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 34, 1)
	end
	if params.ability:GetAbilityName() == "item_dagon_5_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 34, 1)
	end
	if params.ability:GetAbilityName() == "item_rune_forge" then
		Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 39, 1)
	end
	if params.unit.bJoiningPvp then
		if params.ability:GetAbilityName() == "item_refresher_custom" then
			Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 38, 1)
		end
		if params.ability:GetAbilityName() == "item_bloodstone_2" then
			Quests_arena:QuestProgress(params.unit:GetPlayerOwnerID(), 37, 1)
		end
	end
end

function modifier_abilities_optimization_thinker:OnTakeDamage(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local unit = params.unit
	local inflictor = params.inflictor
	if attacker == nil or unit == nil then return end

	if unit:HasModifier("modifier_duel_damage_check") then
		local modifier = unit:FindModifierByName("modifier_duel_damage_check")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	if unit:HasModifier("modifier_stranger_think") then
		local modifier = unit:FindModifierByName("modifier_stranger_think")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modiifer_bloodseeker_bloodrage_custom
	if attacker:HasModifier("modiifer_bloodseeker_bloodrage_custom") then 
		local modifier = attacker:FindModifierByName("modiifer_bloodseeker_bloodrage_custom")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_skill_spell_lifestealer
	if attacker:HasModifier("modifier_skill_spell_lifestealer") then 
		local modifier = attacker:FindModifierByName("modifier_skill_spell_lifestealer")
		if modifier then
			modifier:TakeDamageScriptModifier( params )
		end
	end

	-- modifier_skill_lifestealer
	if attacker:HasModifier("modifier_skill_lifestealer") then 
		local modifier = attacker:FindModifierByName("modifier_skill_lifestealer")
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

	-- modifier_skill_last_chance
	if unit:HasModifier("modifier_skill_last_chance") then
		local modifier = unit:FindModifierByName("modifier_skill_last_chance")
		if modifier then
			modifier:TakeDamageScriptModifier(params)
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

	-- modifier_skill_requite
	if target:HasModifier("modifier_skill_requite") then 
		local modifier = target:FindModifierByName("modifier_skill_requite")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_skill_craggy_man
	if target:HasModifier("modifier_skill_craggy_man") then 
		local modifier = target:FindModifierByName("modifier_skill_craggy_man")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_skill_slackening
	--if attacker:HasModifier("modifier_skill_slackening") then 
	--	local modifier = attacker:FindModifierByName("modifier_skill_slackening")
	--	if modifier then
	--		modifier:AttackLandedModifier( params )
	--	end
	--end

	-- modifier_zuus_lightning_hands_custom_tracker
	if attacker:HasModifier("modifier_zuus_lightning_hands_custom_tracker") then 
		local modifier = attacker:FindModifierByName("modifier_zuus_lightning_hands_custom_tracker")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_skill_pierce
	if attacker:HasModifier("modifier_skill_pierce") then 
		local modifier = attacker:FindModifierByName("modifier_skill_pierce")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_skill_fervor
	if attacker:HasModifier("modifier_skill_fervor") then 
		local modifier = attacker:FindModifierByName("modifier_skill_fervor")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_omniknight_hammer_of_purity_custom
	if attacker:HasModifier("modifier_omniknight_hammer_of_purity_custom") then 
		local modifier = attacker:FindModifierByName("modifier_omniknight_hammer_of_purity_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_bfury_2
	if attacker:HasModifier("modifier_item_bfury_2") then 
		local modifier = attacker:FindModifierByName("modifier_item_bfury_2")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_bfury_3
	if attacker:HasModifier("modifier_item_bfury_3") then 
		local modifier = attacker:FindModifierByName("modifier_item_bfury_3")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_ranged_cleave
	if attacker:HasModifier("modifier_item_ranged_cleave") then 
		local modifier = attacker:FindModifierByName("modifier_item_ranged_cleave")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_ranged_cleave_2
	if attacker:HasModifier("modifier_item_ranged_cleave_2") then 
		local modifier = attacker:FindModifierByName("modifier_item_ranged_cleave_2")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_item_ranged_cleave_3
	if attacker:HasModifier("modifier_item_ranged_cleave_3") then 
		local modifier = attacker:FindModifierByName("modifier_item_ranged_cleave_3")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_ninja_gear_custom
	if attacker:HasModifier("modifier_ninja_gear_custom") then 
		local modifier = attacker:FindModifierByName("modifier_ninja_gear_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

		-- modifier_skill_mage_slayer
	if attacker:HasModifier("modifier_skill_mage_slayer") then 
		local modifier = attacker:FindModifierByName("modifier_skill_mage_slayer")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_skill_goldstealer
	if attacker:HasModifier("modifier_skill_goldstealer") then 
		local modifier = attacker:FindModifierByName("modifier_skill_goldstealer")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end



	-- modifier_skill_goldgainer
	if attacker:HasModifier("modifier_skill_goldgainer") then 
		local modifier = attacker:FindModifierByName("modifier_skill_goldgainer")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_skill_basher
	if attacker:HasModifier("modifier_skill_basher") then 
		local modifier = attacker:FindModifierByName("modifier_skill_basher")
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

	-- modifier_item_desolator_2_custom
	if attacker:HasModifier("modifier_item_desolator_2_custom") then 
		local modifier = attacker:FindModifierByName("modifier_item_desolator_2_custom")
		if modifier then
			modifier:AttackLandedModifier( params )
		end
	end

	-- modifier_nian_bash
	if attacker:HasModifier("modifier_nian_bash") then 
		local modifier = attacker:FindModifierByName("modifier_nian_bash")
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

	-- modifier_gold_roshan_bash
	if attacker:HasModifier("modifier_gold_roshan_bash") then 
		local modifier = attacker:FindModifierByName("modifier_gold_roshan_bash")
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

	-- modifier_drow_ranger_marksmanship_custom
	if attacker:HasModifier("modifier_drow_ranger_marksmanship_custom") then 
		local modifier = attacker:FindModifierByName("modifier_drow_ranger_marksmanship_custom")
		if modifier then
			modifier:AttackModifier( params )
		end
	end

	-- modifier_skill_pierce
	if attacker:HasModifier("modifier_skill_pierce") then 
		local modifier = attacker:FindModifierByName("modifier_skill_pierce")
		if modifier then
			modifier:AttackModifier( params )
		end
	end

	-- modifier_silencer_glaives_of_wisdom_custom_orb
	if attacker:HasModifier("modifier_silencer_glaives_of_wisdom_custom_orb") then 
		local modifier = attacker:FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_orb")
		if modifier then
			modifier:AttackModifier( params )
		end
	end

	-- modifier_oracle_false_promise_custom
	if attacker:HasModifier("modifier_oracle_false_promise_custom") then 
		local modifier = attacker:FindModifierByName("modifier_oracle_false_promise_custom")
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

	-- modifier_item_desolator_2_custom
	if attacker:HasModifier("modifier_item_desolator_2_custom") then 
		local modifier = attacker:FindModifierByName("modifier_item_desolator_2_custom")
		if modifier then
			modifier:AttackModifier( params )
		end
	end
end

function modifier_abilities_optimization_thinker:OnDeath(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local target = params.unit

	if attacker:HasModifier("modifier_skill_killgolder") then
		local modifier = attacker:FindModifierByName("modifier_skill_killgolder")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_pudge_flesh_heap_lua") then
		local modifier = attacker:FindModifierByName("modifier_pudge_flesh_heap_lua")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_skill_cashback_buff") then
		local modifier = attacker:FindModifierByName("modifier_skill_cashback_buff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if attacker:HasModifier("modifier_skill_golden_warrior") then
		local modifier = attacker:FindModifierByName("modifier_skill_golden_warrior")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

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

	if target:HasModifier("modifier_cha_boss_drop_roshan") then
		local modifier = target:FindModifierByName("modifier_cha_boss_drop_roshan")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_drow_ranger_frost_arrows_custom_debuff") then
		local modifier = target:FindModifierByName("modifier_drow_ranger_frost_arrows_custom_debuff")
		if modifier then
			modifier:OnDeathEvent(params)
		end
	end

	if target:HasModifier("modifier_cha_boss_drop_nian") then
		local modifier = target:FindModifierByName("modifier_cha_boss_drop_nian")
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

	if (not attacker:IsHero() or attacker:IsTempestDouble()) and attacker:GetOwner() ~= nil then
		if attacker:GetOwner().HasModifier and attacker:GetOwner():HasModifier("modifier_item_bloodstone_2") then
			local modifier = attacker:GetOwner():FindModifierByName("modifier_item_bloodstone_2")
			if modifier then
				modifier:OnDeathEvent(params)
			end
		end
		if attacker:GetOwner().HasModifier and attacker:GetOwner():HasModifier("modifier_item_hellmask") then
			local modifier = attacker:GetOwner():FindModifierByName("modifier_item_hellmask")
			if modifier then
				modifier:OnDeathEvent(params)
			end
		end
	end

	if (not attacker:IsHero() or attacker:IsTempestDouble()) and attacker:GetOwner() ~= nil then
		if attacker.owner ~= nil and attacker.owner:HasModifier("modifier_item_bloodstone_2") then
			local modifier = attacker.owner:FindModifierByName("modifier_item_bloodstone_2")
			if modifier then
				modifier:OnDeathEvent(params)
			end
		end
		if attacker.owner ~= nil and attacker.owner:HasModifier("modifier_item_hellmask") then
			local modifier = attacker.owner:FindModifierByName("modifier_item_hellmask")
			if modifier then
				modifier:OnDeathEvent(params)
			end
		end
	end

	-- Выполнение квестов на убийство мобов

	if params.unit and params.unit:GetUnitName() == "npc_dota_skeleton" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 1, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_kobold" or params.unit:GetUnitName() == "npc_dota_kobold_tunneler" or params.unit:GetUnitName() == "npc_dota_kobold_taskmaster") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 2, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_forest_troll_high_priest" or params.unit:GetUnitName() == "npc_dota_forest_troll_berserker") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 3, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_gnoll_assassin" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 4, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_fel_beast" or params.unit:GetUnitName() == "npc_dota_ghost") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 5, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_harpy_scout" or params.unit:GetUnitName() == "npc_dota_harpy_storm") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 6, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_crocodilian" or params.unit:GetUnitName() == "npc_dota_crocodilian_ranged") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 7, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_chameleon" or params.unit:GetUnitName() == "npc_dota_chameleon_ranged") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 8, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_greevil" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 9, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_timber_spider" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 10, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_warpine_cone_custom" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 11, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_spider_melee" or params.unit:GetUnitName() == "npc_dota_spider_range") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 49, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_giant_wolf" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 13, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_alpha_wolf" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 14, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_satyr_trickster" or params.unit:GetUnitName() == "npc_dota_satyr_soulstealer") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 15, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_ogre_mauler" or params.unit:GetUnitName() == "npc_dota_ogre_magi") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 16, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_ogreseal" or params.unit:GetUnitName() == "npc_dota_ogreseal_big") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 17, 1)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_mud_golem" or params.unit:GetUnitName() == "npc_dota_mud_golem_split") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 18, 1)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_roshan" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 19, 1)
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 57, 2)
	end

	if params.unit and params.unit:GetUnitName() == "npc_dota_nian" then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 20, 1)
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 57, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_granite_golem" or params.unit:GetUnitName() == "npc_dota_rock_golem") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 45, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_polar_furbolg_champion" or params.unit:GetUnitName() == "npc_dota_polar_furbolg_ursa_warrior") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 46, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_wildkin" or params.unit:GetUnitName() == "npc_dota_enraged_wildkin") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 47, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_centaur_outrunner" or params.unit:GetUnitName() == "npc_dota_centaur_khan") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 48, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_explode_spider") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 12, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_dark_troll" or params.unit:GetUnitName() == "npc_dota_dark_troll_warlord") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 50, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_black_drake" or params.unit:GetUnitName() == "npc_dota_black_dragon") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 51, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_small_thunder_lizard" or params.unit:GetUnitName() == "npc_dota_big_thunder_lizard") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 52, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_prowler_acolyte" or params.unit:GetUnitName() == "npc_dota_prowler_shaman") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 53, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_frostbitten_mage" or params.unit:GetUnitName() == "npc_dota_frostbitten_gaint") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 54, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_siltbreaker_red" or params.unit:GetUnitName() == "npc_dota_siltbreaker_blue") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 55, 2)
	end

	if params.unit and (params.unit:GetUnitName() == "npc_dota_roshling_small" or params.unit:GetUnitName() == "npc_dota_roshling_big") then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 56, 2)
	end

	if params.inflictor and params.inflictor.GetAbilityName then
		if params.inflictor:GetAbilityName() == "item_blade_mail" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 50, 2)
		end
		if params.inflictor:GetAbilityName() == "doom_bringer_devour_custom" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.inflictor:GetAbilityName() == "life_stealer_infest" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.inflictor:GetAbilityName() == "pudge_meat_hook" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.inflictor:GetAbilityName() == "night_stalker_hunter_in_the_night_custom" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.inflictor:GetAbilityName() == "snapfire_gobble_up" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.inflictor:GetAbilityName() == "mirana_arrow" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.inflictor:GetAbilityName() == "enigma_demonic_conversion_custom" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 62, 2)
			Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 84, 3)
		end
		if params.unit:IsRealHero() then
			if params.inflictor:GetAbilityName() == "item_dagon_custom" then
				Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 74, 2)
			end
			if params.inflictor:GetAbilityName() == "item_dagon_2_custom" then
				Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 74, 2)
			end
			if params.inflictor:GetAbilityName() == "item_dagon_3_custom" then
				Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 74, 2)
			end
			if params.inflictor:GetAbilityName() == "item_dagon_4_custom" then
				Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 74, 2)
			end
			if params.inflictor:GetAbilityName() == "item_dagon_5_custom" then
				Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 74, 2)
			end
		end
	end
end
