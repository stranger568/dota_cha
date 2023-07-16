modifier_abilities_optimization_thinker = class({})

function modifier_abilities_optimization_thinker:IsHidden() return false end
function modifier_abilities_optimization_thinker:IsPurgable() return false end

function modifier_abilities_optimization_thinker:CheckState()
    return 
    {
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

    local modifiers = 
    {
        "modifier_oracle_false_promise_custom",
        "modifier_skill_rearm",
    }

    for _, modifier_name in pairs(modifiers) do
        local modifier = unit:FindModifierByName(modifier_name)
        if modifier then
            modifier:OnAbilityfullCastCustom( params )
        end
    end
end

function modifier_abilities_optimization_thinker:OnAbilityExecuted( params )
	if not IsServer() then return end
	if not params.ability then return end
	local unit = params.unit
	if unit == nil then return end
    
    local modifiers = 
    {
        "modifier_skill_multicast",
        "modifier_multicast_lua",
        "modifier_lina_fiery_soul_lua",
        "modifier_monkey_king_jingu_mastery_lua_buff",
    }

    for _, modifier_name in pairs(modifiers) do
        local modifier = unit:FindModifierByName(modifier_name)
        if modifier then
            modifier:OnAbilityExecutedCustom( params )
        end
    end

    local ability_name = params.ability:GetAbilityName()

	if ability_name == "warlock_rain_of_chaos" then
	    for _, warlock_gl in pairs(FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do
	        if warlock_gl:GetUnitName() == "npc_dota_warlock_golem" and warlock_gl:GetOwner() == unit then
	            warlock_gl:ForceKill(false)               
	       	end
	    end
	end

	if ability_name == "skeleton_king_vampiric_aura_custom" then
	    for _, warlock_gl in pairs(FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do
	        if warlock_gl:GetUnitName() == "npc_dota_wraith_king_skeleton_warrior" and warlock_gl:GetOwner() == unit then
	            warlock_gl:Destroy()             
	       	end
	    end
	end

    local unit_id = params.unit:GetPlayerOwnerID()

	if ability_name == "item_abyssal_blade" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 31, 1)
	end
	if ability_name == "item_nullifier" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 32, 1)
	end
	if ability_name == "item_sheepstick" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 33, 1)
	end
	if ability_name == "item_orchid" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 35, 1)
	end
	if ability_name == "item_bloodthorn" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 35, 1)
	end
	if ability_name == "item_ethereal_blade" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 36, 1)
	end
	if ability_name == "item_dagon_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 34, 1)
	end
	if ability_name == "item_dagon_2_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 34, 1)
	end
	if ability_name == "item_dagon_3_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 34, 1)
	end
	if ability_name == "item_dagon_4_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 34, 1)
	end
	if ability_name == "item_dagon_5_custom" and params.target and params.target:IsHero() then
		Quests_arena:QuestProgress(unit_id, 34, 1)
	end
	if ability_name == "item_rune_forge" then
		Quests_arena:QuestProgress(unit_id, 39, 1)
	end
	if params.unit.bJoiningPvp then
		if ability_name == "item_refresher_custom" then
			Quests_arena:QuestProgress(unit_id, 38, 1)
		end
		if ability_name == "item_bloodstone_2" then
			Quests_arena:QuestProgress(unit_id, 37, 1)
		end
	end
end

function modifier_abilities_optimization_thinker:OnTakeDamage(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local unit = params.unit
	local inflictor = params.inflictor
	if attacker == nil or unit == nil then return end

    local units_modifiers = 
    {
        "modifier_duel_damage_check",
        "modifier_stranger_think",
        "modifier_abaddon_borrowed_time_custom",
        "modifier_skill_last_chance",
        "modifier_tempest_double_illusion",
        "modifier_invoker_cold_snap_lua",
        "modifier_fatal_bonds_debuff",
    }

    local attacker_modifiers = 
    {
        "modiifer_bloodseeker_bloodrage_custom",
        "modifier_skill_spell_lifestealer",
        "modifier_skill_lifestealer",
        "modifier_meepo_ransack_custom",
        "modifier_item_bloodstone_2",
        "modifier_item_summoner_crown_buff_int",
    }
    
    for _, modifier_name in pairs(units_modifiers) do
        local modifier = unit:FindModifierByName(modifier_name)
        if modifier then
            modifier:TakeDamageScriptModifier( params )
        end
    end

    for _, modifier_name in pairs(attacker_modifiers) do
        local modifier = attacker:FindModifierByName(modifier_name)
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

    local target_modifiers = 
    {
        "modifier_skill_requite",
        "modifier_skill_craggy_man",
        "modifier_axe_counter_helix_lua",
    }

    local attacker_modifiers = 
    {
        "modifier_zuus_lightning_hands_custom_tracker",
        "modifier_skill_pierce",
        "modifier_skill_fervor",
        "modifier_wisp_overcharge_custom",
        "modifier_omniknight_hammer_of_purity_custom",
        "modifier_item_bfury_2",
        "modifier_item_bfury_3",
        "modifier_item_disperser_custom",
        "modifier_item_ranged_cleave",
        "modifier_item_ranged_cleave_2",
        "modifier_item_ranged_cleave_3",
        "modifier_ninja_gear_custom",
        "modifier_skill_mage_slayer",
        "modifier_skill_goldstealer",
        "modifier_skill_goldgainer",
        "modifier_skill_basher",
        "modifier_creature_berserk",
        "modifier_item_desolator_2_custom",
        "modifier_nian_bash",
        "modifier_creature_tear_armor",
        "modifier_drow_ranger_marksmanship_custom",
        "modifier_invoker_forge_spirit_lua",
        "modifier_liquid_fire_lua_orb",
        "modifier_liquid_ice_lua_orb",
        "modifier_monkey_king_jingu_mastery_lua",
        "modifier_gold_roshan_bash",
        "modifier_monkey_king_jingu_mastery_lua_buff",
        "modifier_naga_siren_rip_tide_lua",
        "modifier_troll_warlord_fervor_custom",
        "modifier_undying_tombstone_lua_passive",
        "modifier_faceless_void_time_lock_custom",
        "modifier_item_hellmask",
        "modifier_item_wraith_dominator_aura_buff",
        "modifier_bounty_hunter_jinada_custom_crit",
        "modifier_silencer_glaives_of_wisdom_custom",
    }

    for _, modifier_name in pairs(target_modifiers) do
        local modifier = target:FindModifierByName(modifier_name)
		if modifier then
			modifier:AttackLandedModifier( params )
		end
    end

    for _, modifier_name in pairs(attacker_modifiers) do
        local modifier = attacker:FindModifierByName(modifier_name)
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

    local attacker_modifiers = 
    {
       "modifier_gyrocopter_flak_cannon_lua",
       "modifier_drow_ranger_marksmanship_custom",
       "modifier_skill_pierce",
       "modifier_liquid_ice_lua_orb",
       "modifier_silencer_glaives_of_wisdom_custom_orb",
       "modifier_oracle_false_promise_custom",
       "modifier_silencer_glaives_of_wisdom_custom",
       "modifier_liquid_fire_lua_orb",
       "modifier_frostivus2018_weaver_geminate_attack_custom",
       "modifier_item_desolator_2_custom",
    }
    
    for _, modifier_name in pairs(attacker_modifiers) do
        local modifier = attacker:FindModifierByName(modifier_name)
		if modifier then
			modifier:AttackModifier( params )
		end
    end
end

function modifier_abilities_optimization_thinker:OnDeath(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local target = params.unit

    local target_modifiers = 
    {
        "modifier_axe_battle_hunger_custom_debuff",
        "modifier_cha_boss_drop_roshan",
        "modifier_drow_ranger_frost_arrows_custom_debuff",
        "modifier_cha_boss_drop_nian",
        "modifier_silencer_glaives_of_wisdom_custom_debuff",
        "modifier_dark_seer_wall_of_replica_nb2017",
        "modifier_duel_buff",
        "modifier_lion_finger_of_death_custom_buff",
        "modifier_lina_laguna_blade_custom_damage",
        "modifier_sand_king_caustic_finale_lua_debuff",
        "modifier_aegis",
        "modifier_bounty_hunter_track_creep",
    }

    local attacker_modifiers = 
    {
        "modifier_skill_killgolder",
        "modifier_pudge_flesh_heap_lua",
        "modifier_skill_cashback_buff",
        "modifier_skill_golden_warrior",
        "modifier_alchemist_goblins_greed_custom",
        "modifier_item_bloodstone_2",
        "modifier_item_hellmask",
    }

    for _, modifier_name in pairs(target_modifiers) do
        local modifier = target:FindModifierByName(modifier_name)
		if modifier then
			modifier:OnDeathEvent( params )
		end
    end

    for _, modifier_name in pairs(attacker_modifiers) do
        local modifier = attacker:FindModifierByName(modifier_name)
		if modifier then
			modifier:OnDeathEvent( params )
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

    local attacker_id = params.attacker:GetPlayerOwnerID()
    local target_unit_name = params.unit:GetUnitName()

	-- Выполнение квестов на убийство мобов

	if params.unit and target_unit_name == "npc_dota_skeleton" then
		Quests_arena:QuestProgress(attacker_id, 1, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_kobold" or target_unit_name == "npc_dota_kobold_tunneler" or target_unit_name == "npc_dota_kobold_taskmaster") then
		Quests_arena:QuestProgress(attacker_id, 2, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_forest_troll_high_priest" or target_unit_name == "npc_dota_forest_troll_berserker") then
		Quests_arena:QuestProgress(attacker_id, 3, 1)
	end

	if params.unit and target_unit_name == "npc_dota_gnoll_assassin" then
		Quests_arena:QuestProgress(attacker_id, 4, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_fel_beast" or target_unit_name == "npc_dota_ghost") then
		Quests_arena:QuestProgress(attacker_id, 5, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_harpy_scout" or target_unit_name == "npc_dota_harpy_storm") then
		Quests_arena:QuestProgress(attacker_id, 6, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_crocodilian" or target_unit_name == "npc_dota_crocodilian_ranged") then
		Quests_arena:QuestProgress(attacker_id, 7, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_chameleon" or target_unit_name == "npc_dota_chameleon_ranged") then
		Quests_arena:QuestProgress(attacker_id, 8, 1)
	end

	if params.unit and target_unit_name == "npc_dota_greevil" then
		Quests_arena:QuestProgress(attacker_id, 9, 1)
	end

	if params.unit and target_unit_name == "npc_dota_timber_spider" then
		Quests_arena:QuestProgress(attacker_id, 10, 1)
	end

	if params.unit and target_unit_name == "npc_dota_warpine_cone_custom" then
		Quests_arena:QuestProgress(attacker_id, 11, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_spider_melee" or target_unit_name == "npc_dota_spider_range") then
		Quests_arena:QuestProgress(attacker_id, 49, 1)
	end

	if params.unit and target_unit_name == "npc_dota_giant_wolf" then
		Quests_arena:QuestProgress(attacker_id, 13, 1)
	end

	if params.unit and target_unit_name == "npc_dota_alpha_wolf" then
		Quests_arena:QuestProgress(attacker_id, 14, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_satyr_trickster" or target_unit_name == "npc_dota_satyr_soulstealer") then
		Quests_arena:QuestProgress(attacker_id, 15, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_ogre_mauler" or target_unit_name == "npc_dota_ogre_magi") then
		Quests_arena:QuestProgress(attacker_id, 16, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_ogreseal" or target_unit_name == "npc_dota_ogreseal_big") then
		Quests_arena:QuestProgress(attacker_id, 17, 1)
	end

	if params.unit and (target_unit_name == "npc_dota_mud_golem" or target_unit_name == "npc_dota_mud_golem_split") then
		Quests_arena:QuestProgress(attacker_id, 18, 1)
	end

	if params.unit and target_unit_name == "npc_dota_roshan" then
		Quests_arena:QuestProgress(attacker_id, 19, 1)
		Quests_arena:QuestProgress(attacker_id, 57, 2)
	end

	if params.unit and target_unit_name == "npc_dota_nian" then
		Quests_arena:QuestProgress(attacker_id, 20, 1)
		Quests_arena:QuestProgress(attacker_id, 57, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_granite_golem" or target_unit_name == "npc_dota_rock_golem") then
		Quests_arena:QuestProgress(attacker_id, 45, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_polar_furbolg_champion" or target_unit_name == "npc_dota_polar_furbolg_ursa_warrior") then
		Quests_arena:QuestProgress(attacker_id, 46, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_wildkin" or target_unit_name == "npc_dota_enraged_wildkin") then
		Quests_arena:QuestProgress(attacker_id, 47, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_centaur_outrunner" or target_unit_name == "npc_dota_centaur_khan") then
		Quests_arena:QuestProgress(attacker_id, 48, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_explode_spider") then
		Quests_arena:QuestProgress(attacker_id, 12, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_dark_troll" or target_unit_name == "npc_dota_dark_troll_warlord") then
		Quests_arena:QuestProgress(attacker_id, 50, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_black_drake" or target_unit_name == "npc_dota_black_dragon") then
		Quests_arena:QuestProgress(attacker_id, 51, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_small_thunder_lizard" or target_unit_name == "npc_dota_big_thunder_lizard") then
		Quests_arena:QuestProgress(attacker_id, 52, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_prowler_acolyte" or target_unit_name == "npc_dota_prowler_shaman") then
		Quests_arena:QuestProgress(attacker_id, 53, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_frostbitten_mage" or target_unit_name == "npc_dota_frostbitten_gaint") then
		Quests_arena:QuestProgress(attacker_id, 54, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_siltbreaker_red" or target_unit_name == "npc_dota_siltbreaker_blue") then
		Quests_arena:QuestProgress(attacker_id, 55, 2)
	end

	if params.unit and (target_unit_name == "npc_dota_roshling_small" or target_unit_name == "npc_dota_roshling_big") then
		Quests_arena:QuestProgress(attacker_id, 56, 2)
	end

	if params.inflictor and params.inflictor.GetAbilityName then
        local ability_name = params.inflictor:GetAbilityName()
		if ability_name == "item_blade_mail" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 50, 2)
		end
		if ability_name == "doom_bringer_devour_custom" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if ability_name == "life_stealer_infest" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if ability_name == "pudge_meat_hook" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if ability_name == "night_stalker_hunter_in_the_night_custom" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if ability_name == "snapfire_gobble_up" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if ability_name == "mirana_arrow" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if ability_name == "enigma_demonic_conversion_custom" and not params.unit:IsHero() then
			Quests_arena:QuestProgress(attacker_id, 62, 2)
			Quests_arena:QuestProgress(attacker_id, 84, 3)
		end
		if params.unit:IsRealHero() then
			if ability_name == "item_dagon_custom" then
				Quests_arena:QuestProgress(attacker_id, 74, 2)
			end
			if ability_name == "item_dagon_2_custom" then
				Quests_arena:QuestProgress(attacker_id, 74, 2)
			end
			if ability_name == "item_dagon_3_custom" then
				Quests_arena:QuestProgress(attacker_id, 74, 2)
			end
			if ability_name == "item_dagon_4_custom" then
				Quests_arena:QuestProgress(attacker_id, 74, 2)
			end
			if ability_name == "item_dagon_5_custom" then
				Quests_arena:QuestProgress(attacker_id, 74, 2)
			end
		end
	end
end
