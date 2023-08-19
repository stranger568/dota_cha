LinkLuaModifier("modifier_aegis", "heroes/modifier_aegis", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_aegis_buff", "heroes/modifier_aegis_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_generic_muted_lua", "heroes/modifier_generic_muted_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skywrath_mage_shard_lua", "heroes/hero_skywrath_mage/modifier_skywrath_mage_shard_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skywrath_mage_shard_bonus_counter_lua", "heroes/hero_skywrath_mage/modifier_skywrath_mage_shard_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_legion_commander_duel_creep", "heroes/hero_legion_commander/legion_commander_duel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_spell_amplify_controller", "heroes/modifier_spell_amplify_controller", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua_scepter", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meepo_talent", "modifiers/modifier_meepo_talent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cha_vision", "modifiers/modifier_cha_vision", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cha_ban", "modifiers/modifier_cha_ban", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cha_stranger", "modifiers/modifier_cha_stranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gaben_int_fixed", "modifiers/modifier_gaben_int_fixed", LUA_MODIFIER_MOTION_NONE)

if HeroBuilder == nil then 
    HeroBuilder = class({}) 
end

HeroBuilder.totalAbilityNumber = {}
HeroBuilder.nInitAegisNumber = 2
HeroBuilder.neutral_list = LoadKeyValues("scripts/npc/neutral_items.txt")
HeroBuilder.RewardForPlayer = {}
HeroBuilder.RewardForPlayerRoshan = {}
HeroBuilder.NeutralsHasRandomed = {}
HeroBuilder.HasUseNeutralFiveTier = {}

for nPlayerID = 0, 24 do
    HeroBuilder.totalAbilityNumber[nPlayerID] = 2
    HeroBuilder.NeutralsHasRandomed[nPlayerID] = {}
    HeroBuilder.HasUseNeutralFiveTier[nPlayerID] = false
    HeroBuilder.RewardForPlayer[nPlayerID] = {}
    HeroBuilder.RewardForPlayerRoshan[nPlayerID] = {}
    for tier_ne = 1, 5 do
        HeroBuilder.RewardForPlayer[nPlayerID][tier_ne] = {}
        HeroBuilder.RewardForPlayerRoshan[nPlayerID][tier_ne] = {}
    end
end

-- Способности которые не могут быть вместе
abilityExclusion={}

-- Способности которые не могут быть у героя
heroExclusion={}
heroExclusion["npc_dota_hero_silencer"]={"monkey_king_wukongs_command"}
heroExclusion["npc_dota_hero_razor"]={"monkey_king_wukongs_command"}
heroExclusion["npc_dota_hero_meepo"]={"arc_warden_tempest_double_lua"}
heroExclusion["npc_dota_hero_rattletrap"]={"phoenix_supernova"}

-- Удаленные способности
unremovableAbilities={}
unremovableAbilities["monkey_king_wukongs_command"]=true

-- Способности с аганима которые привязаны к герою
scepterAbilities = {}
scepterAbilities["npc_dota_hero_antimage"]={"antimage_mana_overload"}
scepterAbilities["npc_dota_hero_kunkka"]={"kunkka_torrent_storm_custom"}
scepterAbilities["npc_dota_hero_rattletrap"]={"rattletrap_overclocking"}
scepterAbilities["npc_dota_hero_enchantress"]={"enchantress_little_friends"}
scepterAbilities["npc_dota_hero_treant"]={"treant_eyes_in_the_forest"}
scepterAbilities["npc_dota_hero_ogre_magi"]={"ogre_magi_unrefined_fireblast"}
scepterAbilities["npc_dota_hero_earth_spirit"]={"earth_spirit_petrify"}
scepterAbilities["npc_dota_hero_juggernaut"]={"juggernaut_swift_slash_custom"}
scepterAbilities["npc_dota_hero_snapfire"]={"snapfire_gobble_up","snapfire_spit_creep"}
scepterAbilities["npc_dota_hero_nyx_assassin"]={"nyx_assassin_burrow","nyx_assassin_unburrow"}
scepterAbilities["npc_dota_hero_shredder"]={"shredder_chakram_2_lua","shredder_chakram_lua_2_return"}
scepterAbilities["npc_dota_hero_tusk"]={"tusk_walrus_kick"}
scepterAbilities["npc_dota_hero_grimstroke"]={"grimstroke_dark_portrait"}
scepterAbilities["npc_dota_hero_zuus"]={"zuus_cloud"}
scepterAbilities["npc_dota_hero_spectre"]={"spectre_haunt","spectre_reality"}
scepterAbilities["npc_dota_hero_clinkz"]={"clinkz_burning_army"}
scepterAbilities["npc_dota_hero_keeper_of_the_light"]={"keeper_of_the_light_will_o_wisp"}
scepterAbilities["npc_dota_hero_leshrac"]={"leshrac_greater_lightning_storm"}
scepterAbilities["npc_dota_hero_terrorblade"]={"terrorblade_terror_wave"}
scepterAbilities["npc_dota_hero_templar_assassin"]={"templar_assassin_trap_teleport"}
scepterAbilities["npc_dota_hero_visage"]={"visage_silent_as_the_grave"}
scepterAbilities["npc_dota_hero_lycan"]={"lycan_wolf_bite"}
scepterAbilities["npc_dota_hero_hoodwink"]={"hoodwink_decoy"}
scepterAbilities["npc_dota_hero_broodmother"]={"broodmother_sticky_snare"}
scepterAbilities["npc_dota_hero_dark_seer"]={"dark_seer_normal_punch"}
scepterAbilities["npc_dota_hero_beastmaster"]={"beastmaster_drums_of_slom"}
scepterAbilities["npc_dota_hero_viper"]={"viper_nose_dive"}
scepterAbilities["npc_dota_hero_bloodseeker"]={"bloodseeker_blood_mist_custom"}
scepterAbilities["npc_dota_hero_oracle"]={"oracle_rain_of_destiny"}
scepterAbilities["npc_dota_hero_centaur"]={"centaur_work_horse", "centaur_mount"}
scepterAbilities["npc_dota_hero_lina"]={"lina_flame_cloak_custom"}
scepterAbilities["npc_dota_hero_brewmaster"]={"brewmaster_primal_companion"}

-- Способности с аганима которые привязаны к способности
scepterLinkAbilities = {}
scepterLinkAbilities["shredder_chakram_lua"]={"shredder_chakram_2_lua","shredder_chakram_lua_2_return"}
scepterLinkAbilities["kunkka_torrent"]={"kunkka_torrent_storm_custom"}
scepterLinkAbilities["templar_assassin_psionic_trap"]={"templar_assassin_trap_teleport"}
scepterLinkAbilities["zuus_lightning_bolt"]={"zuus_cloud"}
scepterLinkAbilities["lycan_shapeshift_custom"]={"lycan_wolf_bite"}
scepterLinkAbilities["lina_laguna_blade_custom"]={"lina_flame_cloak_custom"}
scepterLinkAbilities["juggernaut_omni_slash_custom"]={"juggernaut_swift_slash_custom"}
scepterLinkAbilities["bloodseeker_thirst"]={"bloodseeker_blood_mist_custom"}
scepterLinkAbilities["leshrac_pulse_nova"]={"leshrac_greater_lightning_storm"}
scepterLinkAbilities["kunkka_torrent"]={"kunkka_torrent_storm_custom"}
scepterLinkAbilities["nyx_assassin_vendetta"]={"nyx_assassin_burrow","nyx_assassin_unburrow"}

-- Способности с шарда которые привязаны к способности
shardLinkAbilities = {}
shardLinkAbilities["shadow_demon_demonic_purge"]={"shadow_demon_demonic_cleanse"}
shardLinkAbilities["medusa_mystic_snake"]={"medusa_cold_blooded"}
shardLinkAbilities["necrolyte_death_pulse"]={"necrolyte_death_seeker"}
shardLinkAbilities["slark_shadow_dance_custom"]={"slark_depth_shroud_custom"}
shardLinkAbilities["witch_doctor_death_ward"]={"witch_doctor_voodoo_switcheroo"}
shardLinkAbilities["tusk_snowball"]={"tusk_launch_snowball"}
shardLinkAbilities["dragon_knight_elder_dragon_form_custom"]={"dragon_knight_fireball"}
shardLinkAbilities["alchemist_chemical_rage"]={"alchemist_berserk_potion"}
shardLinkAbilities["jakiro_liquid_fire_lua"]={"jakiro_liquid_ice_lua"}
shardLinkAbilities["lich_chain_frost_custom"]={"lich_ice_spire"}
shardLinkAbilities["shredder_whirling_death"]={"shredder_flamethrower"}
--shardLinkAbilities["tidehunter_ravage"]={"tidehunter_arm_of_the_deep_custom"}
shardLinkAbilities["zuus_arc_lightning_custom"]={"zuus_lightning_hands_custom"}

-- Способности с шарда которые привязаны к герою
scepterShardAbilities = {}
scepterShardAbilities["npc_dota_hero_crystal_maiden"]={"crystal_maiden_crystal_clone"}
scepterShardAbilities["npc_dota_hero_drow_ranger"]={"drow_ranger_glacier"}
scepterShardAbilities["npc_dota_hero_antimage"]={"antimage_counterspell_ally"}
scepterShardAbilities["npc_dota_hero_alchemist"]={"alchemist_berserk_potion"}
scepterShardAbilities["npc_dota_hero_furion"]={"furion_curse_of_the_forest"}
scepterShardAbilities["npc_dota_hero_bristleback"]={"bristleback_hairball"}
scepterShardAbilities["npc_dota_hero_venomancer"]={"venomancer_latent_poison"}
scepterShardAbilities["npc_dota_hero_enchantress"]={"enchantress_bunny_hop"}
scepterShardAbilities["npc_dota_hero_rattletrap"]={"rattletrap_jetpack"}
scepterShardAbilities["npc_dota_hero_tidehunter"]={"tidehunter_dead_in_the_water"}
scepterShardAbilities["npc_dota_hero_jakiro"]={"jakiro_liquid_ice_lua"}
scepterShardAbilities["npc_dota_hero_kunkka"]={"kunkka_tidal_wave"}
scepterShardAbilities["npc_dota_hero_lich"]={"lich_ice_spire"}
scepterShardAbilities["npc_dota_hero_life_stealer"]={"life_stealer_open_wounds"}
scepterShardAbilities["npc_dota_hero_magnataur"]={"magnataur_horn_toss"}
scepterShardAbilities["npc_dota_hero_meepo"]={"meepo_petrify"}
scepterShardAbilities["npc_dota_hero_necrolyte"]={"necrolyte_death_seeker"}
scepterShardAbilities["npc_dota_hero_ogre_magi"]={"ogre_magi_smash"}
scepterShardAbilities["npc_dota_hero_omniknight"]={"omniknight_degen_aura_custom"}
scepterShardAbilities["npc_dota_hero_pangolier"]={"pangolier_rollup"}
scepterShardAbilities["npc_dota_hero_phantom_assassin"]={"custom_phantom_assassin_fan_of_knives"}
scepterShardAbilities["npc_dota_hero_riki"]={"riki_poison_dart"}
scepterShardAbilities["npc_dota_hero_slark"]={"slark_depth_shroud_custom"}
scepterShardAbilities["npc_dota_hero_sniper"]={"sniper_concussive_grenade"}
scepterShardAbilities["npc_dota_hero_storm_spirit"]={"storm_spirit_electric_rave"}
scepterShardAbilities["npc_dota_hero_shredder"]={"shredder_flamethrower"}
scepterShardAbilities["npc_dota_hero_tinker"]={"tinker_warp_grenade"}
scepterShardAbilities["npc_dota_hero_terrorblade"]={"terrorblade_demon_zeal"}
scepterShardAbilities["npc_dota_hero_tiny"]={"tiny_craggy_exterior"}
scepterShardAbilities["npc_dota_hero_witch_doctor"]={"witch_doctor_voodoo_switcheroo"}
scepterShardAbilities["npc_dota_hero_troll_warlord"]={"troll_warlord_rampage"}
scepterShardAbilities["npc_dota_hero_hoodwink"]={"hoodwink_decoy"}
scepterShardAbilities["npc_dota_hero_windrunner"]={"windrunner_gale_force"}
scepterShardAbilities["npc_dota_hero_primal_beast"]={"primal_beast_rock_throw"}
scepterShardAbilities["npc_dota_hero_hoodwink"]={"hoodwink_hunters_boomerang"}
scepterShardAbilities["npc_dota_hero_skywrath_mage"]={"skywrath_mage_shield_of_the_scion"}
scepterShardAbilities["npc_dota_hero_spirit_breaker"]={"spirit_breaker_planar_pocket"}
scepterShardAbilities["npc_dota_hero_clinkz"]={"clinkz_burning_barrage"}

-- Способности суммона
HeroBuilder.summonAbilities = 
{
    "beastmaster_call_of_the_wild_boar",
    "shadow_shaman_mass_serpent_ward",
    "brewmaster_primal_split",
    "furion_force_of_nature_custom",
    "lone_druid_spirit_bear",
    "venomancer_plague_ward",
    "witch_doctor_death_ward",
    "warlock_rain_of_chaos",
    "lycan_summon_wolves",
    "broodmother_spawn_spiderlings",
    "invoker_forge_spirit_lua",
    "visage_summon_familiars",
    "enigma_demonic_conversion_custom",
    "undying_tombstone_lua"
}

-- Способности на который повышен шанс выпадения
AbilitiesRandomChanceList_1 = 
{
    "frostivus2018_clinkz_wind_walk",
    "abaddon_frostmourne",
    "axe_counter_helix",
    "beastmaster_inner_beast",
    "brewmaster_drunken_brawler",
    "chaos_knight_chaos_strike",
    "doom_bringer_infernal_blade",
    "elder_titan_natural_order",
    "lycan_shapeshift_custom",
    "magnataur_empower_custom",
    "marci_guardian",
    "mars_bulwark",
    "night_stalker_hunter_in_the_night_custom",
    "spirit_breaker_greater_bash",
    "sven_great_cleave",
    "skeleton_king_vampiric_aura_custom",
    "antimage_mana_break",
    "clinkz_strafe",
    "gyrocopter_flak_cannon_lua",
    "juggernaut_blade_dance",
    "lone_druid_spirit_link",
    "luna_moon_glaive",
    "medusa_split_shot",
    "monkey_king_jingu_mastery_lua",
    "pangolier_lucky_shot_custom",
    "phantom_assassin_phantom_strike",
    "nevermore_necromastery",
    "slark_essence_shift_lua",
    "sniper_take_aim_custom",
    "spectre_dispersion_custom",
    "custom_terrorblade_metamorphosis",
    "ursa_overpower",
    "vengefulspirit_wave_of_terror",
    "invoker_alacrity_lua",
    "lina_fiery_soul",
    "ogre_magi_bloodlust",
    "windrunner_focusfire",
    "legion_commander_moment_of_courage",
    "life_stealer_ghoul_frenzy",
    "marci_unleash",
    "night_stalker_darkness_custom",
    "slardar_amplify_damage_custom",
    "sven_gods_strength_custom",
    "tiny_grow",
    "skeleton_king_mortal_strike",
    "bounty_hunter_track",
    "juggernaut_omni_slash_custom",
    "pangolier_heartpiercer_custom",
    "phantom_assassin_coup_de_grace",
    "razor_eye_of_the_storm",
    "nevermore_dark_lord",
    "templar_assassin_psi_blades",
    "troll_warlord_fervor_custom",
    "vengefulspirit_command_aura",
    "frostivus2018_clinkz_searing_arrows",
}

-- Способности вторые на который повышен шанс выпадения
AbilitiesRandomChanceList_2 = 
{
    "alchemist_chemical_rage",
    "dragon_knight_elder_dragon_form_custom",
    "frostivus2018_huskar_burning_spear",
    "life_stealer_feast_custom",
    "tiny_tree_grab_lua",
    "bloodseeker_bloodrage_custom",
    "faceless_void_time_lock_custom",
    "ursa_fury_swipes",
    "frostivus2018_weaver_geminate_attack_custom",
    "wisp_overcharge_custom",
    "broodmother_insatiable_hunger_custom",
    "drow_ranger_frost_arrows_custom",
    "meepo_ransack_custom",
    "tiny_grow",
    "lycan_shapeshift_custom",
    "sven_gods_strength_custom",
}

-- Способности которые меняют вид атаки
HeroBuilder.attackCapabilityModifiers={}
HeroBuilder.attackCapabilityModifiers["modifier_troll_warlord_berserkers_rage"]=true
HeroBuilder.attackCapabilityModifiers["modifier_lone_druid_true_form_custom"]=true
HeroBuilder.attackCapabilityModifiers["modifier_custom_terrorblade_metamorphosis"]=true
HeroBuilder.attackCapabilityModifiers["modifier_dragon_knight_elder_dragon_form_custom"]=true

-- Инициализация системы абилок
function HeroBuilder:Init()
    CustomGameEventManager:RegisterListener("HeroSelected",function(_, keys)
        self:HeroSelected(keys)
    end)

    CustomGameEventManager:RegisterListener("RerollHeroes",function(_, keys)
        self:RerollHeroes(keys)
    end)

    CustomGameEventManager:RegisterListener("AbilitySelected",function(_, keys)
        self:AbilitySelected(keys)
    end)

    CustomGameEventManager:RegisterListener("SpellBookAbilitySelected",function(_, keys)
        self:SpellBookAbilitySelected(keys)
    end)

    CustomGameEventManager:RegisterListener("RelearnBookAbilitySelected",function(_, keys)
        self:RelearnBookAbilitySelected(keys)
    end)

    CustomGameEventManager:RegisterListener("OminiscientSelectAbility",function(_, keys)
        self:OminiscientSelectAbility(keys)
    end)

    CustomGameEventManager:RegisterListener("SwapAbility",function(_, keys)
        self:SwapAbility(keys)
    end)

    CustomGameEventManager:RegisterListener("ProposeTeammateSwap", function (_, keys)
        self:ProposeTeammateSwap(keys)
    end)

    CustomGameEventManager:RegisterListener("AcceptTeammateSwap", function (_, keys)
        self:AcceptTeammateSwap(keys)
    end)

    CustomGameEventManager:RegisterListener("DeclineTeammateSwap", function (_, keys)
        self:DeclineTeammateSwap(keys)
    end)

    CustomGameEventManager:RegisterListener("ReorderComplete",function(_, keys)
        self:ReorderComplete(keys)
    end)

    CustomGameEventManager:RegisterListener("SelectNeutralReward",function(_, keys)
        self:SelectNeutralReward(keys)
    end)

    CustomGameEventManager:RegisterListener("SelectNeutralRewardReturn",function(_, keys)
        self:SelectNeutralRewardReturn(keys)
    end)

    HeroBuilder.allHeroeNames=table.deepcopy(GameRules.heroesPoolList)
    HeroBuilder.heroAbilityPool={}
    HeroBuilder.abilityHeroMap={}
    HeroBuilder.linkedAbilities={}
    HeroBuilder.linkedAbilitiesLevel={}
    HeroBuilder.pendingSwaps={}
    HeroBuilder.subsidiaryAbilitiesList={}
    HeroBuilder.attackCapabilityChanged={}
    HeroBuilder.pendingPrecache={}
    HeroBuilder.precached={}

    local allAbilityNames={}

    local abilityListKV = LoadKeyValues("scripts/npc/npc_abilities_list.txt")

    for szHeroName, data in pairs(abilityListKV) do
        HeroBuilder.heroAbilityPool["npc_dota_hero_"..szHeroName]={}
        local netTableData = {}
        if data and type(data) == "table" then 
            for key, value in pairs(data) do
                if type(value) ~= "table" then
                    table.insert(allAbilityNames, value)
                    table.insert(HeroBuilder.heroAbilityPool["npc_dota_hero_"..szHeroName], value)
                    HeroBuilder.abilityHeroMap[value] =szHeroName
                    table.insert(netTableData, value)
                else
                    HeroBuilder.linkedAbilities[key]={}
                    for k,v in pairs(value) do
                        table.insert(HeroBuilder.linkedAbilities[key],k)                        
                        table.insert(HeroBuilder.subsidiaryAbilitiesList,k)
                        HeroBuilder.linkedAbilitiesLevel[k] = tonumber(v)
                    end
                end
            end
        end

        CustomNetTables:SetTableValue("hero_info","Abilities_"..szHeroName,netTableData)
    end
    
    for _,abilityName in pairs(HeroBuilder.subsidiaryAbilitiesList) do
        CustomNetTables:SetTableValue("subsidiary_list", abilityName, {abilityName=abilityName})
    end

    for _,abilityList in pairs(scepterAbilities) do
        for _,sAbilityName in ipairs(abilityList) do
            CustomNetTables:SetTableValue("subsidiary_list", sAbilityName, {abilityName=sAbilityName})
        end
    end

    for _,abilityList in pairs(scepterShardAbilities) do
        for _,sAbilityName in ipairs(abilityList) do
            CustomNetTables:SetTableValue("subsidiary_list", sAbilityName, {abilityName=sAbilityName})
        end
        CustomNetTables:SetTableValue("subsidiary_list", "dragon_knight_fireball", {abilityName="dragon_knight_fireball"})
    end

    for _,abilityList in pairs(shardLinkAbilities) do
        for _,sAbilityName in ipairs(abilityList) do
            CustomNetTables:SetTableValue("subsidiary_list", sAbilityName, {abilityName=sAbilityName})
        end
    end

    HeroBuilder.allAbilityNames = allAbilityNames
    HeroBuilder.scepterOwners = {}
    if GetMapName() ~= "1x8_pve" then
        HeroBuilder:BanRandomAbilities()
        HeroBuilder:BanRandomHeroes()
    end
end

function HeroBuilder:BanRandomAbilities()
    for i=1,RandomInt(3, 8) do
        local keys = {}
        keys.abilityName = HeroBuilder.allAbilityNames[RandomInt(1, #HeroBuilder.allAbilityNames)]
        if table.contains(HeroBuilder.allAbilityNames,keys.abilityName) then
            table.remove_item(HeroBuilder.allAbilityNames,keys.abilityName)
        end
        local sHeroName = HeroBuilder.abilityHeroMap[keys.abilityName]
        if not sHeroName then
            return
        end
        if HeroBuilder.heroAbilityPool[sHeroName] then
            if table.contains(HeroBuilder.heroAbilityPool[sHeroName],keys.abilityName) then
                table.remove_item(HeroBuilder.heroAbilityPool[sHeroName],keys.abilityName)
            end
        end
        if table.contains(HeroBuilder.summonAbilities,keys.abilityName) then
            table.remove_item(HeroBuilder.summonAbilities,keys.abilityName)
        end
        if not table.contains(Pass.banAbilityList,keys.abilityName) then
            table.insert(Pass.banAbilityList, keys.abilityName)
            CustomGameEventManager:Send_ServerToAllClients( 'UpdatebanAbility', {abilityName = keys.abilityName})
            CustomNetTables:SetTableValue("hero_info", "ban_abilities", Pass.banAbilityList)
        end
    end
end

function HeroBuilder:BanRandomHeroes()
    for i=1,RandomInt(3, 5) do
        local sHeroName = HeroBuilder.allHeroeNames[RandomInt(1, #HeroBuilder.allHeroeNames)]
        CustomGameEventManager:Send_ServerToAllClients( 'UpdatebanHero', {hero = sHeroName:gsub('npc_dota_hero_','')})
        table.remove_item(HeroBuilder.allHeroeNames,sHeroName)
        table.remove_item(GameRules.heroesPoolList_strength_list,sHeroName)
        table.remove_item(GameRules.heroesPoolList_agility_list,sHeroName)
        table.remove_item(GameRules.heroesPoolList_intellect_list,sHeroName)
        table.remove_item(GameRules.heroesPoolList_all_list,sHeroName)
        if not table.contains(Pass.banHeroList,sHeroName) then
            table.insert(Pass.banHeroList, sHeroName)
            CustomNetTables:SetTableValue("hero_info", "hero_abilities", Pass.banHeroList)
        end
    end
end

-- Создание выбора героя
function HeroBuilder:ShowRandomHeroSelection(nPlayerID)
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if hHero and (true ~= hHero.bSelected) and (true ~= hHero.bSettled) then
        if hHero.randomHeroNames == nil then
            local randomHeroNames = {}

            local random_strength_hero_copy = table.deepcopy(GameRules.heroesPoolList_strength_list)
            local random_agility_hero_copy = table.deepcopy(GameRules.heroesPoolList_agility_list)
            local random_intellect_hero_copy = table.deepcopy(GameRules.heroesPoolList_intellect_list)
            local random_all_hero_copy = table.deepcopy(GameRules.heroesPoolList_all_list)

            table.remove_item(random_strength_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))
            table.remove_item(random_agility_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))
            table.remove_item(random_intellect_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))
            table.remove_item(random_all_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))

            local random_strength_hero = random_strength_hero_copy[RandomInt(1, #random_strength_hero_copy)]
            local random_agility_hero = random_agility_hero_copy[RandomInt(1, #random_agility_hero_copy)]
            local random_intellect_hero =  random_intellect_hero_copy[RandomInt(1, #random_intellect_hero_copy)]
            local random_all_hero = random_all_hero_copy[RandomInt(1, #random_all_hero_copy)]

            table.insert(randomHeroNames, random_strength_hero)
            table.insert(randomHeroNames, random_agility_hero)
            table.insert(randomHeroNames, random_intellect_hero)
            table.insert(randomHeroNames, random_all_hero)

            if GameRules.hero_list_duplicate[random_strength_hero] == nil then
                GameRules.hero_list_duplicate[random_strength_hero] = 1
            else
                GameRules.hero_list_duplicate[random_strength_hero] = GameRules.hero_list_duplicate[random_strength_hero] + 1
            end

            if GameRules.hero_list_duplicate[random_strength_hero] then
                if GameRules.hero_list_duplicate[random_strength_hero] >= 3 then
                    table.remove_item(GameRules.heroesPoolList_strength_list, random_strength_hero)
                end
            end

            if GameRules.hero_list_duplicate[random_agility_hero] == nil then
                GameRules.hero_list_duplicate[random_agility_hero] = 1
            else
                GameRules.hero_list_duplicate[random_agility_hero] = GameRules.hero_list_duplicate[random_agility_hero] + 1
            end

            if GameRules.hero_list_duplicate[random_agility_hero] then
                if GameRules.hero_list_duplicate[random_agility_hero] >= 3 then
                    table.remove_item(GameRules.heroesPoolList_agility_list, random_agility_hero)
                end
            end

            if GameRules.hero_list_duplicate[random_intellect_hero] == nil then
                GameRules.hero_list_duplicate[random_intellect_hero] = 1
            else
                GameRules.hero_list_duplicate[random_intellect_hero] = GameRules.hero_list_duplicate[random_intellect_hero] + 1
            end

            if GameRules.hero_list_duplicate[random_intellect_hero] then
                if GameRules.hero_list_duplicate[random_intellect_hero] >= 3 then
                    table.remove_item(GameRules.heroesPoolList_intellect_list, random_intellect_hero)
                end
            end

            if GameRules.hero_list_duplicate[random_all_hero] == nil then
                GameRules.hero_list_duplicate[random_all_hero] = 1
            else
                GameRules.hero_list_duplicate[random_all_hero] = GameRules.hero_list_duplicate[random_all_hero] + 1
            end

            if GameRules.hero_list_duplicate[random_all_hero] then
                if GameRules.hero_list_duplicate[random_all_hero] >= 3 then
                    table.remove_item(GameRules.heroesPoolList_all_list, random_all_hero)
                end
            end

            hHero.randomHeroNames = randomHeroNames
        end
        -- Реролл игрока
        if hPlayer then
            local style = "no"
            if Pass.RerollHeroCount[nPlayerID] then
                if Pass.RerollHeroCount[nPlayerID] >= 1 then
                    style = "yes"
                end
            end
            CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowRandomHeroSelection",{data=hHero.randomHeroNames, first_random = style})
        end
    end
end

function HeroBuilder:RerollHeroes(keys)

    local nPlayerID = keys.player_id

    if Pass.RerollHeroCount[keys.player_id] then
        if Pass.RerollHeroCount[keys.player_id] <= 0 then return end
        if Pass.RerollHeroCount[keys.player_id] then
            Pass.RerollHeroCount[keys.player_id] = Pass.RerollHeroCount[keys.player_id] - 1
        end
    end

    local hPlayer = PlayerResource:GetPlayer(keys.player_id)
    local hHero = PlayerResource:GetSelectedHeroEntity(keys.player_id)

    if hHero then
        local randomHeroNames = {}

        local random_strength_hero_copy = table.deepcopy(GameRules.heroesPoolList_strength_list)
        local random_agility_hero_copy = table.deepcopy(GameRules.heroesPoolList_agility_list)
        local random_intellect_hero_copy = table.deepcopy(GameRules.heroesPoolList_intellect_list)
        local random_all_hero_copy = table.deepcopy(GameRules.heroesPoolList_all_list)

        table.remove_item(random_strength_hero_copy, hHero.randomHeroNames[1])
        table.remove_item(random_agility_hero_copy, hHero.randomHeroNames[2])
        table.remove_item(random_intellect_hero_copy, hHero.randomHeroNames[3])
        table.remove_item(random_all_hero_copy, hHero.randomHeroNames[4])

        table.remove_item(random_strength_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))
        table.remove_item(random_agility_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))
        table.remove_item(random_intellect_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))
        table.remove_item(random_all_hero_copy, PlayerResource:GetSelectedHeroName(nPlayerID))

        local random_strength_hero = random_strength_hero_copy[RandomInt(1, #random_strength_hero_copy)]
        local random_agility_hero = random_agility_hero_copy[RandomInt(1, #random_agility_hero_copy)]
        local random_intellect_hero =  random_intellect_hero_copy[RandomInt(1, #random_intellect_hero_copy)]
        local random_all_hero = random_all_hero_copy[RandomInt(1, #random_all_hero_copy)]

        table.insert(randomHeroNames, random_strength_hero)
        table.insert(randomHeroNames, random_agility_hero)
        table.insert(randomHeroNames, random_intellect_hero)
        table.insert(randomHeroNames, random_all_hero)

        if GameRules.hero_list_duplicate[random_strength_hero] == nil then
            GameRules.hero_list_duplicate[random_strength_hero] = 1
        else
            GameRules.hero_list_duplicate[random_strength_hero] = GameRules.hero_list_duplicate[random_strength_hero] + 1
        end

        if GameRules.hero_list_duplicate[random_strength_hero] then
            if GameRules.hero_list_duplicate[random_strength_hero] >= 3 then
                table.remove_item(GameRules.heroesPoolList_strength_list, random_strength_hero)
            end
        end

        if GameRules.hero_list_duplicate[random_agility_hero] == nil then
            GameRules.hero_list_duplicate[random_agility_hero] = 1
        else
            GameRules.hero_list_duplicate[random_agility_hero] = GameRules.hero_list_duplicate[random_agility_hero] + 1
        end

        if GameRules.hero_list_duplicate[random_agility_hero] then
            if GameRules.hero_list_duplicate[random_agility_hero] >= 3 then
                table.remove_item(GameRules.heroesPoolList_agility_list, random_agility_hero)
            end
        end

        if GameRules.hero_list_duplicate[random_intellect_hero] == nil then
            GameRules.hero_list_duplicate[random_intellect_hero] = 1
        else
            GameRules.hero_list_duplicate[random_intellect_hero] = GameRules.hero_list_duplicate[random_intellect_hero] + 1
        end

        if GameRules.hero_list_duplicate[random_intellect_hero] then
            if GameRules.hero_list_duplicate[random_intellect_hero] >= 3 then
                table.remove_item(GameRules.heroesPoolList_intellect_list, random_intellect_hero)
            end
        end

        if GameRules.hero_list_duplicate[random_all_hero] == nil then
            GameRules.hero_list_duplicate[random_all_hero] = 1
        else
            GameRules.hero_list_duplicate[random_all_hero] = GameRules.hero_list_duplicate[random_all_hero] + 1
        end

        if GameRules.hero_list_duplicate[random_all_hero] then
            if GameRules.hero_list_duplicate[random_all_hero] >= 3 then
                table.remove_item(GameRules.heroesPoolList_all_list, random_all_hero)
            end
        end

        hHero.randomHeroNames = randomHeroNames

        if hPlayer then
            local style = "no"
            if Pass.RerollHeroCount[keys.player_id] then
                if Pass.RerollHeroCount[keys.player_id] >= 1 then
                    style = "yes"
                end
            end
            CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowRandomHeroSelection",{data=hHero.randomHeroNames, first_random = style})
        end
    end
end

function HeroBuilder:InitPlayerHero( hHero )
    hHero.bInited = true

    -- Модификаторы
    hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
    hHero:AddNewModifier(hHero, nil, "modifier_cha_vision", {})
    hHero:AddNewModifier(hHero, nil, "modifier_gaben_int_fixed", {})
    if hHero:GetUnitName() == "npc_dota_hero_gyrocopter" then
        hHero:AddNewModifier(hHero, nil, "modifier_gyrocopter_flak_cannon_lua_scepter", {})
    end
    hHero.selected_skills = {}

    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()] ~= nil then
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()].game_blocked ~= 0 and ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()].game_blocked >= 0 then
            local modifier = hHero:AddNewModifier(hHero, nil, "modifier_cha_ban", {})
            if modifier then
                modifier:SetStackCount(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()].game_blocked)
            end
        end
    end

    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()] ~= nil then
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()].stranger_surprice ~= 0 and ChaServerData.PLAYERS_GLOBAL_INFORMATION[hHero:GetPlayerID()].stranger_surprice >= 0 then
            local modifier = hHero:AddNewModifier(hHero, nil, "modifier_cha_stranger", {})
        end
    end

    CustomGameEventManager:Send_ServerToAllClients( 'UpdatePassInfo', {})

    for i = 0, 23 do
        local hAbility = hHero:GetAbilityByIndex(i)
        if hAbility then
            local sAbilityName = hAbility:GetAbilityName()
            if not string.find(sAbilityName, "special_bonus") then
                hHero:RemoveAbility(sAbilityName)
            end
            print("удаление")
        end
    end

    local hTp = hHero:FindItemInInventory('item_tpscroll')
    if hTp then
        hTp:RemoveSelf()
    end

    for i = 0, 5 do
        local hAbility = hHero:AddAbility("empty_"..i)
        hAbility.nPlaceholder = i + 1
    end

    hHero:AddNewModifier(hHero, nil, "modifier_spell_amplify_controller", {})
    HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerOwnerID())
end

function HeroBuilder:HeroSelectedLoad(hero_name, player_id, aegis_count, level, ability_number, total_ability_number, gold, bet_value_sum)
    local szHeroName = hero_name
    local nPlayerID = player_id
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if not hPlayer then return end

    local nPrecacheCount = 20    
    PrecacheUnitByNameAsync(szHeroName, function()
        Timers:CreateTimer(1, function()
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
            if hHero then
                if hPlayer then
                    local hOldHero = hHero
                    local itemDataList = {}
                    for i = 0, 16 do
                        local hItem = hOldHero:GetItemInSlot(i);
                        if hItem ~= nil and hItem:GetPurchaser():GetPlayerID()==hOldHero:GetPlayerID() then
                            local itemData = {}
                            itemData.sItemName = hItem:GetName()
                            itemData.nPurchaserID=hItem:GetPurchaser():GetPlayerID()
                            itemData.nCharges=hItem:GetCurrentCharges()
                            table.insert(itemDataList, itemData)
                        end
                    end
                    hHero = PlayerResource:ReplaceHeroWith(nPlayerID,szHeroName,gold,0)
                    for _,itemData in ipairs(itemDataList) do
                        local hItem = CreateItem(itemData.sItemName,hHero,hHero)
                        hItem:SetCurrentCharges(itemData.nCharges)
                        hHero:AddItem(hItem)
                    end
                    Timers:CreateTimer(0.5, function()
                        hOldHero:ForceKill(false)
                        UTIL_Remove(hOldHero)
                    end)
                    HeroBuilder:InitPlayerHero(hHero)
                    local hModifierAegis = hHero:AddNewModifier(hHero, nil, "modifier_aegis", {})
                    if hModifierAegis then
                        CustomNetTables:SetTableValue("aegis_count", tostring(nPlayerID), {count = aegis_count})
                        hModifierAegis:SetStackCount(aegis_count)
                    end
                    print("test8")
                    hHero.bSettled=true
                    hHero.bSelected = true
                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"HideHeroPrecacheCountDown",{})
                    hHero.nOriginalAttackCapability = hHero:GetAttackCapability()
                    hHero.nAbilityNumber = ability_number
                    hHero.abilitiesList = {}
                    HeroBuilder.totalAbilityNumber[nPlayerID] = total_ability_number
                    PvpModule.betValueSum[nPlayerID] = bet_value_sum
                    for lsla = 1, level -1 do
                        hHero:HeroLevelUp( false )
                    end
                    Timers:CreateTimer(1, function()
                        hHero.nAbilityNumber=ability_number
                        if hHero.nAbilityNumber< HeroBuilder.totalAbilityNumber[nPlayerID] then
                            if not hHero.bSelectingAbility then
                                HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
                            end
                        end
                    end)
                end
                return nil
            end
            return 1
        end)
    end)
end

function HeroBuilder:HeroSelected(keys)
    local szHeroName = keys.hero_name
    local nPlayerID = keys.player_id
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if not hPlayer then return end

    if not (table.contains(hHero.randomHeroNames, szHeroName) or szHeroName == PlayerResource:GetSelectedHeroName(nPlayerID)) then return end

    if hHero and hHero.bSelected then return end

    hHero.bSelected = true

    if szHeroName==PlayerResource:GetSelectedHeroName(nPlayerID) then
        HeroBuilder:SettleCurrentHero(nPlayerID)
    else
        local nPrecacheCount = 20    

        Timers:CreateTimer(1, function()
            nPrecacheCount = nPrecacheCount - 1
            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if hPlayer and nPrecacheCount>0 then
                if hHero==nil or true~=hHero.bSettled then 
                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowHeroPrecacheCountDown",{countDown=nPrecacheCount})
                end
            end
            return 1
        end)

        PrecacheUnitByNameAsync(szHeroName, function()
            Timers:CreateTimer(1, function()
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                if hHero then
                    if hPlayer then
                        if true~=hHero.bSettled then
                            local hOldHero = hHero
                            local itemDataList = {}
                            for i = 0, 16 do
                                local hItem = hOldHero:GetItemInSlot(i);
                                if hItem ~= nil and hItem:GetPurchaser():GetPlayerID()==hOldHero:GetPlayerID() then
                                    local itemData = {}
                                    itemData.sItemName = hItem:GetName()
                                    itemData.nPurchaserID=hItem:GetPurchaser():GetPlayerID()
                                    itemData.nCharges=hItem:GetCurrentCharges()
                                    table.insert(itemDataList, itemData)
                                end
                            end
                            hHero = PlayerResource:ReplaceHeroWith(nPlayerID,szHeroName,hHero:GetGold(),0)
                            for _,itemData in ipairs(itemDataList) do
                                local hItem = CreateItem(itemData.sItemName,hHero,hHero)
                                hItem:SetCurrentCharges(itemData.nCharges)
                                hHero:AddItem(hItem)
                            end
                            Timers:CreateTimer(0.5, function()
                                hOldHero:ForceKill(false)
                                UTIL_Remove(hOldHero)
                            end)
                            HeroBuilder:InitPlayerHero(hHero)
                            local hModifierAegis = hHero:AddNewModifier(hHero, nil, "modifier_aegis", {})
                            if hModifierAegis then
                                CustomNetTables:SetTableValue("aegis_count", tostring(nPlayerID), {count = 2})
                                hModifierAegis:SetStackCount(HeroBuilder.nInitAegisNumber)
                            end
                            hHero.bSettled=true
                            CustomGameEventManager:Send_ServerToPlayer(hPlayer,"HideHeroPrecacheCountDown",{})
                            hHero.nOriginalAttackCapability = hHero:GetAttackCapability()
                            hHero.nAbilityNumber=0
                            hHero.abilitiesList = {}
                            Timers:CreateTimer(1, function()
                                hHero.nAbilityNumber=0
                                if hHero.nAbilityNumber< HeroBuilder.totalAbilityNumber[nPlayerID] then
                                    if not hHero.bSelectingAbility then
                                        HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
                                    end
                                end
                            end)
                        end
                        return nil
                    end
                end
                return 1
            end)
        end)
    end
end

function HeroBuilder:SettleCurrentHero(nPlayerID)
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    local hModifierAegis = hHero:AddNewModifier(hHero, nil, "modifier_aegis", {})

    if hModifierAegis then
        CustomNetTables:SetTableValue("aegis_count", tostring(nPlayerID), {count = 2})
        hModifierAegis:SetStackCount(HeroBuilder.nInitAegisNumber)
    end

    hHero.bSelected=true
    hHero.bSettled=true
    hHero.nOriginalAttackCapability = hHero:GetAttackCapability()
    hHero.nAbilityNumber=0
    hHero.abilitiesList={}

    if hPlayer then
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "HideHeroSelection", {})
    end

    Timers:CreateTimer(1, function()
        hHero.nAbilityNumber=0
        if hHero.nAbilityNumber < HeroBuilder.totalAbilityNumber[nPlayerID] then
            if not hHero.bSelectingAbility then
                HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
            end
        end
    end)
end

function HeroBuilder:ForceFinishHeroBuild()
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)   
            if hHero then
                if true ~= hHero.bSettled then                 
                    HeroBuilder:SettleCurrentHero(nPlayerID)
                end
            end
        end
    end    
end

-- Создание окна с выбором способности
function HeroBuilder:ShowRandomAbilitySelection(nPlayerID)

    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if not hHero then return end

    local hPlayer = PlayerResource:GetPlayer(nPlayerID)

    if not hPlayer then return end

    if true == hHero.bOmniscientBookSelectingAbility then return end

    if true == hHero.bRemovingAbility then
        local hItem = CreateItem("item_relearn_book_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
    end

    hHero.bRemovingAbility = false

    if true == hHero.bOmniscientBookRemoving then
        local hItem = CreateItem("item_omniscient_book", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
    end

    hHero.bOmniscientBookRemoving = false

    if true == hHero.bSelectingSpellBook then
        local hItem = CreateItem("item_spell_book_empty_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
        hItem:SetSellable(false)
    end

    hHero.bSelectingSpellBook = false

    if hHero.randomAbilityNames == nil then
        local tempList = table.deepcopy(HeroBuilder.allAbilityNames) 
        local ownList = table.deepcopy(HeroBuilder.heroAbilityPool[hHero:GetUnitName()]) 
        local AbilitiesRandomChanceList_1List = table.deepcopy(AbilitiesRandomChanceList_1)
        local AbilitiesRandomChanceList_2List = table.deepcopy(AbilitiesRandomChanceList_2)

        if hHero.abilitiesList == nil then
            hHero.abilitiesList = {}
        end

        for _, sAbilityName in ipairs(hHero.abilitiesList) do
            table.remove_item(tempList, sAbilityName)
            table.remove_item(ownList, sAbilityName)
            table.remove_item(AbilitiesRandomChanceList_1List, sAbilityName)
            table.remove_item(AbilitiesRandomChanceList_2List, sAbilityName)

            if abilityExclusion[sAbilityName] then
                for _,sExclusion in ipairs(abilityExclusion[sAbilityName]) do
                    table.remove_item(tempList, sExclusion)
                    table.remove_item(ownList, sExclusion)
                    table.remove_item(AbilitiesRandomChanceList_1List, sExclusion)
                    table.remove_item(AbilitiesRandomChanceList_2List, sExclusion)
                end
            end
        end

        local rubick_skill = hHero:FindAbilityByName("rubick_spell_steal_custom")
        if rubick_skill then
            if rubick_skill.currentSpell ~= nil then
                table.remove_item(tempList, rubick_skill.currentSpell:GetAbilityName())
                table.remove_item(ownList, rubick_skill.currentSpell:GetAbilityName())
                table.remove_item(AbilitiesRandomChanceList_1List, rubick_skill.currentSpell:GetAbilityName())
                table.remove_item(AbilitiesRandomChanceList_2List, rubick_skill.currentSpell:GetAbilityName())
            end
        end

        if heroExclusion[hHero:GetUnitName()] then
            for _,sAbilityName in ipairs(heroExclusion[hHero:GetUnitName()]) do
                table.remove_item(tempList, sAbilityName)
                table.remove_item(AbilitiesRandomChanceList_1List, sAbilityName)
                table.remove_item(AbilitiesRandomChanceList_2List, sAbilityName)
            end
        end

        for _,sAbilityName in ipairs(Pass.banAbilityList) do
            table.remove_item(ownList, sAbilityName)       
            table.remove_item(tempList, sAbilityName)
            table.remove_item(AbilitiesRandomChanceList_1List, sAbilityName)
            table.remove_item(AbilitiesRandomChanceList_2List, sAbilityName)
        end

        local randomAbilityNames ={}

        if RandomInt(1, 100) < 90 and #ownList > 0 then
            local count_abilities_from_all = 8
            local random_ability_1 = nil
            local random_ability_2 = nil
            local random_ability_3 = nil

            local randomOwnAbilities = table.random_some(ownList, 1)

            if randomOwnAbilities[1] then
               table.remove_item(tempList, randomOwnAbilities[1])
               table.remove_item(AbilitiesRandomChanceList_1List, randomOwnAbilities[1])
               table.remove_item(AbilitiesRandomChanceList_2List, randomOwnAbilities[1])
            end

            count_abilities_from_all = count_abilities_from_all - 1

            --random_ability_1 = table.random_some(AbilitiesRandomChanceList_1List, 1)
--
            --if random_ability_1[1] then
            --    table.remove_item(tempList, random_ability_1[1])
            --    table.remove_item(AbilitiesRandomChanceList_1List, random_ability_1[1])
            --    table.remove_item(AbilitiesRandomChanceList_2List, random_ability_1[1])
            --end

            --count_abilities_from_all = count_abilities_from_all - 1

            if RandomInt(1, 100) <= 5 then
                random_ability_3 = table.random_some(AbilitiesRandomChanceList_2List, 1)
                if random_ability_3[1] then
                    table.remove_item(tempList, random_ability_3[1])
                    --table.remove_item(AbilitiesRandomChanceList_1List, random_ability_3[1])
                    table.remove_item(AbilitiesRandomChanceList_2List, random_ability_3[1])
                end
                count_abilities_from_all = count_abilities_from_all - 1
            end

            randomAbilityNames= table.random_some(tempList, count_abilities_from_all)
            randomAbilityNames= table.join(randomAbilityNames,randomOwnAbilities)

            --if random_ability_1 ~= nil then
            --    randomAbilityNames=table.join(randomAbilityNames, random_ability_1)
            --end

            --if random_ability_2 ~= nil then
            --    randomAbilityNames=table.join(randomAbilityNames, random_ability_2)
            --end

            if random_ability_3 ~= nil then
                randomAbilityNames=table.join(randomAbilityNames, random_ability_3)
            end
        else
            local count_abilities_from_all = 8
            local random_ability_1 = nil
            local random_ability_2 = nil
            local random_ability_3 = nil

            --random_ability_1 = table.random_some(AbilitiesRandomChanceList_1List, 1)

            --if random_ability_1[1] then
            --    table.remove_item(tempList, random_ability_1[1])
            --    table.remove_item(AbilitiesRandomChanceList_1List, random_ability_1[1])
            --    table.remove_item(AbilitiesRandomChanceList_2List, random_ability_1[1])
            --end

            --count_abilities_from_all = count_abilities_from_all - 1

            if RandomInt(1, 100) <= 5 then
                random_ability_3 = table.random_some(AbilitiesRandomChanceList_2List, 1)
                if random_ability_3[1] then
                    table.remove_item(tempList, random_ability_3[1])
                    --table.remove_item(AbilitiesRandomChanceList_1List, random_ability_3[1])
                    table.remove_item(AbilitiesRandomChanceList_2List, random_ability_3[1])
                end
                count_abilities_from_all = count_abilities_from_all - 1
            end

            randomAbilityNames= table.random_some(tempList, count_abilities_from_all)

            --if random_ability_1 ~= nil then
            --    randomAbilityNames=table.join(randomAbilityNames, random_ability_1)
            --end

            --if random_ability_2 ~= nil then
            --    randomAbilityNames=table.join(randomAbilityNames, random_ability_2)
            --end

            if random_ability_3 ~= nil then
                randomAbilityNames=table.join(randomAbilityNames, random_ability_3)
            end
        end

        if IsInToolsMode() then
            randomAbilityNames=table.join(randomAbilityNames, "abyssal_underlord_firestorm_custom")
        end

        hHero.randomAbilityNames = randomAbilityNames
        hHero.bSelectingAbility = true
    end

    local dataList = {}

    for _,randomAbilityName in pairs(hHero.randomAbilityNames) do
        local data={}

        data.ability_name = randomAbilityName

        if HeroBuilder.linkedAbilities[randomAbilityName] then
            data.linked_abilities = HeroBuilder.linkedAbilities[randomAbilityName]
        end

        table.insert(dataList, data)

        CustomGameEventManager:Send_ServerToPlayer(hPlayer,"RegisterHoverableAbility",{ability_name = randomAbilityName})
    end

    hHero.sUISecret = CreateSecretKey()
    
    if hHero.nAbilityNumber == nil then
        hHero.nAbilityNumber = 0
    end

    CustomGameEventManager:Send_ServerToPlayer(hPlayer, "ShowRandomAbilitySelection", {data_list = dataList, ability_number = hHero.nAbilityNumber + 1, ui_secret = hHero.sUISecret})
end

function HeroBuilder:AbilitySelected(keys)

    local sAbilityName = keys.ability_name

    local nPlayerID = keys.player_id

    local bSpellBookSelected = keys.spell_book_selected

    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if not hHero then return end

    if not hHero.bSelectingAbility then return end

    if hHero.sUISecret ~= keys.ui_secret then return end

    hHero.bSelectingAbility = false

    if sAbilityName == nil then
        sAbilityName= HeroBuilder:ChooseRandomOneAbility(nPlayerID)
    else
        if hHero.randomAbilityNames then
            if not table.contains(hHero.randomAbilityNames, sAbilityName) then
                return
            end
        end
    end

    hHero.randomAbilityNames = nil

    if hHero.nAbilityNumber >= HeroBuilder.totalAbilityNumber[nPlayerID] then return end

    hHero.nAbilityNumber = hHero.nAbilityNumber + 1

    table.insert(hHero.abilitiesList, sAbilityName)
    
    if 1 == bSpellBookSelected and PlayerResource:GetGold(nPlayerID)>=150 then
        hHero:SpendGold(150,DOTA_ModifyGold_Unspecified)
        hHero:EmitSound("Item.TomeOfKnowledge")
        HeroBuilder:RecordAbility(nPlayerID, sAbilityName)
    else
        HeroBuilder:AddAbility(nPlayerID, sAbilityName)
    end

    if hHero.nAbilityNumber==HeroBuilder.totalAbilityNumber[nPlayerID] and PlayerResource:GetPlayer(nPlayerID) then
        local hPlayer = PlayerResource:GetPlayer(nPlayerID)

        if hHero.nAbilityNumber == 2 then
            Notifications:Bottom(hPlayer,{ text = "#next_ability_round_3", duration = 5, style = { color = "Red" }} )
        end

        if hHero.nAbilityNumber == 3 then
            Notifications:Bottom(hPlayer,{ text = "#next_ability_round_6", duration = 5, style = { color = "Red" }} )
        end

        if hHero.nAbilityNumber == 4 then
            Notifications:Bottom(hPlayer,{ text = "#next_ability_round_9", duration = 5, style = { color = "Red" }} )
        end
    end

    if hHero.nAbilityNumber < HeroBuilder.totalAbilityNumber[nPlayerID] then
        HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
    end
end

function HeroBuilder:ShowAllAbiliySelection(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if not hHero then return end

    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    if not hPlayer then return end
    hHero.bOmniscientBookSelectingAbility = true
    hHero.bSelectingAbility = false
    hHero.bRemovingAbility = false
    hHero.bSelectingSpellBook = false
    hHero.bOmniscientBookRemoving = false
    hHero.sUISecret = CreateSecretKey()

    local exclusion = {}

    for _, sAbilityName in ipairs(hHero.abilitiesList) do
        table.insert(exclusion, sAbilityName)
        if abilityExclusion[sAbilityName] then
            for _,sExclusion in ipairs(abilityExclusion[sAbilityName]) do
                table.insert(exclusion, sExclusion)
            end
        end
    end

    if heroExclusion[hHero:GetUnitName()] then
        for _,sAbilityName in ipairs(heroExclusion[hHero:GetUnitName()]) do
            table.insert(exclusion, sAbilityName)
        end
    end

    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowAllAbilitySelection",{exclusion=exclusion,ui_secret=hHero.sUISecret})
end

function HeroBuilder:OminiscientSelectAbility(keys)
    local sAbilityName=keys.ability_name
    local nPlayerID=keys.PlayerID
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if not hHero then
        return
    end

    if not hHero.bOmniscientBookSelectingAbility then
        return
    end

    if table.contains(Pass.banAbilityList,sAbilityName) then
        return
    end

    if hHero.sUISecret~=keys.ui_secret then
        return
    end

    hHero.bOmniscientBookSelectingAbility = false

    if sAbilityName == nil then
        return
    end

    if hHero.nAbilityNumber >= HeroBuilder.totalAbilityNumber[nPlayerID] then
        return
    end

    hHero.nAbilityNumber = hHero.nAbilityNumber + 1

    table.insert(hHero.abilitiesList, sAbilityName)

    HeroBuilder:AddAbility(nPlayerID, sAbilityName)

    if hHero.nAbilityNumber<HeroBuilder.totalAbilityNumber[nPlayerID] then
        HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
    end
end

function HeroBuilder:RelearnBookAbilitySelected(keys, retry)
    local sAbilityName=keys.ability_name
    local nPlayerID=keys.player_id
    local bSummonBook = keys.summon_book
    local bOmniscientBook = false
    local bChaosScroll = keys.chaos_scroll

    if keys.omniscient_book and keys.omniscient_book==1 then
        bOmniscientBook = true
    end

    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if hHero:IsNull() then
        print("Герой не найден")
        return 
    end

    if ( true ~= hHero.bRemovingAbility) and ( true ~= hHero.bOmniscientBookRemoving) then
        print("Relearn Book - 1")
        return
    end

    if hHero.sUISecret ~= keys.ui_secret then
        local hPlayer = PlayerResource:GetPlayer(nPlayerID)
        hHero.sUISecret= CreateSecretKey()
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "ShowRelearnBookAbilitySelection", {ui_secret=hHero.sUISecret})
        print("Relearn Book - 2")
        return
    end

    local hook = hHero:FindAbilityByName("pudge_meat_hook")
    if hook then
        hook:SetActivated(true)
    end
    
    if sAbilityName=="ancient_apparition_ice_blast" then
        local hAbility= hHero:FindAbilityByName(sAbilityName)
        if hAbility and hAbility:IsHidden() then
            sAbilityName = nil 
        end
    end

    if not table.contains(hHero.abilitiesList, sAbilityName) then
        sAbilityName = nil 
    end

    if sAbilityName == nil and hHero.bRemovingAbility then
        local hItem = CreateItem("item_relearn_book_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
        hHero.bRemovingAbility = false
        print("Relearn Book - 3")
        return 
    end

    if sAbilityName == nil and hHero.bOmniscientBookRemoving then
        local hItem = CreateItem("item_omniscient_book", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
        hHero.bOmniscientBookRemoving = false
        print("Relearn Book - 4")
        return 
    end

    if unremovableAbilities[sAbilityName] then
        print("Relearn Book - 5")
        return 
    end

    --if sAbilityName == "rubick_spell_steal_custom" then
    --    local ability_rubick = hHero:FindAbilityByName("rubick_spell_steal_custom")
    --    if ability_rubick and ability_rubick.activate_ability ~= nil then
    --        local hItem = CreateItem("item_relearn_book_lua", hHero, hHero)
    --        hHero:AddItem(hItem)
    --        hItem:SetPurchaseTime(0)
    --        hHero.bRemovingAbility = false
    --        hHero.bOmniscientBookRemoving = false
    --        print("Relearn Book - 6")
    --        return
    --    end
    --end
    
    Timers:CreateTimer(0.1, function()
        hHero.bRemovingAbility = false
        hHero.bOmniscientBookRemoving = false
        
        local bFoundSomeWhere = false

        if hHero.spellBooks and hHero.spellBooks[sAbilityName] and not hHero.spellBooks[sAbilityName]:IsNull() then
            local hItem = hHero.spellBooks[sAbilityName]
            hHero.nAbilityNumber = hHero.nAbilityNumber -1
            table.remove_item(hHero.abilitiesList,sAbilityName)
            local nAbilityPoints = hHero:GetAbilityPoints()
            local nAbilityLevel = hItem.nAbilityLevel or 0
            nAbilityPoints = nAbilityPoints + nAbilityLevel
            hHero:SetAbilityPoints(nAbilityPoints)
            local hContainner = hItem:GetContainer()
            UTIL_Remove(hItem)
            if hContainner then
                UTIL_Remove(hContainner)
            end
            hHero.spellBooks[sAbilityName] =nil
            bFoundSomeWhere=true
        else
            local hAbility = hHero:FindAbilityByName(sAbilityName)
            if hAbility and hAbility.sRemovalTimer==nil then
                local nAbilityLevel = hAbility:GetLevel()
                HeroBuilder:RemoveAbility(nPlayerID,sAbilityName)
                hHero.nAbilityNumber = hHero.nAbilityNumber -1
                table.remove_item(hHero.abilitiesList,sAbilityName)
                local nAbilityPoints = hHero:GetAbilityPoints()
                nAbilityPoints = nAbilityPoints + nAbilityLevel
                hHero:SetAbilityPoints(nAbilityPoints)
                bFoundSomeWhere=true
            end
        end

        print("bFoundSomeWhere", bFoundSomeWhere, sAbilityName, hHero:FindAbilityByName(sAbilityName) == nil)

        if bFoundSomeWhere then
            if bSummonBook then
                local sSummonAbilityName = HeroBuilder:ChooseRandomSummonAbility(nPlayerID)
                hHero.bSelectingAbility = true
                hHero.sUISecret= CreateSecretKey()
                HeroBuilder:AbilitySelected({ability_name=sSummonAbilityName,player_id=nPlayerID,ui_secret=hHero.sUISecret})
            elseif bOmniscientBook then
                HeroBuilder:ShowAllAbiliySelection(nPlayerID)
            elseif bChaosScroll then
                hHero.bSelectingAbility = true
                hHero.sUISecret= CreateSecretKey()
                HeroBuilder:AbilitySelected({player_id=nPlayerID,ui_secret=hHero.sUISecret})         
            else
                HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
            end
        else
            if retry == nil then
                retry = 1
            end
            if retry <= 5 then
                print("Какая-то проблемка, попробуем еще раз перезапустить эту хуйню", retry)
                retry = retry + 1
                HeroBuilder:RelearnBookAbilitySelected(keys, retry)
            end
        end

        HeroBuilder:RefreshAbilityOrder(nPlayerID)
    end)
end

function HeroBuilder:RecordAbility(nPlayerID,sAbilityName)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if hHero:IsNull() then
        return
    end

    local hItem = CreateItem("item_spell_book_lua", hHero, hHero)
    hItem.sAbilityName = sAbilityName
    hHero:AddItem(hItem)

    if hHero.spellBooks==nil then
       hHero.spellBooks = {}
    end

    hHero.spellBooks[sAbilityName] = hItem
end

function HeroBuilder:SpellBookAbilitySelected(keys)
    local sAbilityName = keys.ability_name
    local nPlayerID = keys.player_id
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hHero:IsNull() then return end
    if true ~= hHero.bSelectingSpellBook then return end
    if hHero.sUISecret~=keys.ui_secret then return end

    hHero.bSelectingSpellBook= false

    if sAbilityName=="ancient_apparition_ice_blast" then
       local hAbility= hHero:FindAbilityByName(sAbilityName)
       if hAbility and hAbility:IsHidden() then
           sAbilityName = nil 
       end
    end

    if not table.contains(hHero.abilitiesList,sAbilityName) then
       sAbilityName = nil 
    end

    if sAbilityName == nil then
        local hItem = CreateItem("item_spell_book_empty_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetSellable(false)
        return
    end

    if sAbilityName == "brewmaster_primal_split" then
        local hItem = CreateItem("item_spell_book_empty_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetSellable(false)
        return
    end

    if unremovableAbilities[sAbilityName] then
        return
    end

    local hAbility = hHero:FindAbilityByName(sAbilityName)

    if hAbility then
        local nAbilityLevel = hAbility:GetLevel()
        local flAbilityCoolDown = hAbility:GetCooldownTimeRemaining()
        HeroBuilder:RemoveAbility(nPlayerID,sAbilityName)

        local hItem = CreateItem("item_spell_book_lua", hHero, hHero)
        hItem.sAbilityName = sAbilityName
        hItem.nAbilityLevel = nAbilityLevel
        hItem.flAbilityCoolDown = flAbilityCoolDown
        hHero:AddItem(hItem)
        hItem:StartCooldown(0.5)

        if hHero.spellBooks==nil then
            hHero.spellBooks = {}
        end

        hHero.spellBooks[sAbilityName] = hItem
        HeroBuilder:RefreshAbilityOrder(nPlayerID)
    end
end

function HeroBuilder:RunAbilitySoundPrecache()
    print("мм хуета")
    Timers:CreateTimer(1, function()
        local sHeroName
        if HeroBuilder.pendingPrecache and #HeroBuilder.pendingPrecache > 0 then
            sHeroName = HeroBuilder.pendingPrecache[#HeroBuilder.pendingPrecache]
            table.remove(HeroBuilder.pendingPrecache, #HeroBuilder.pendingPrecache)
        end
        if not sHeroName then return 5 end
        PrecacheUnitByNameAsync("npc_precache_npc_dota_hero_"..sHeroName, function()
            HeroBuilder.precached[sHeroName] = true
            HeroBuilder:RunAbilitySoundPrecache()
        end)
    end)
end

function HeroBuilder:AddLinkedAbilities(hHero, sAbilityName,nLevel)
    if HeroBuilder.linkedAbilities[sAbilityName] then
        for _,szLinkedAbilityName in ipairs(HeroBuilder.linkedAbilities[sAbilityName]) do
            if not hHero:HasAbility(szLinkedAbilityName) then
                local hNewLinkedAbility = hHero:AddAbility(szLinkedAbilityName)
                if szLinkedAbilityName=="lone_druid_true_form_druid" or  szLinkedAbilityName=="lone_druid_true_form_battle_cry" then
                    hNewLinkedAbility:SetHidden(false)
                end

                if HeroBuilder.linkedAbilitiesLevel[szLinkedAbilityName]>0 then
                    hNewLinkedAbility:SetLevel(HeroBuilder.linkedAbilitiesLevel[szLinkedAbilityName])
                end
                if nLevel and nLevel>0 then
                    hNewLinkedAbility:SetLevel(nLevel)
                end
               
                if hNewLinkedAbility and not hNewLinkedAbility:IsNull() then
                    hNewLinkedAbility:MarkAbilityButtonDirty()
                end

               
                Timers:CreateTimer(0.1, function()
                    if hNewLinkedAbility and not hNewLinkedAbility:IsNull() and not hNewLinkedAbility:IsHidden() then 
                        HeroBuilder:SetAbilityToSlot(hHero, hNewLinkedAbility) 
                    end
                end)
            end
        end
    end
end

function HeroBuilder:SetAbilityToSlot(hHero, hAbility)
    if not hHero or hHero:IsNull() then return end
    if not hAbility or hAbility:IsNull() then return end

    for i=0, 5 do
        local hSlotAbility = hHero:GetAbilityByIndex(i)
        
        if not hSlotAbility or hSlotAbility:IsNull() then
            slot_ability = hero:AddAbility("empty_"..i)
			slot_ability.placeholder = i + 1
        end

        if hSlotAbility and hSlotAbility.nPlaceholder then
            hHero:SwapAbilities(hSlotAbility:GetAbilityName(), hAbility:GetAbilityName(), false, true)
            hAbility:SetAbilityIndex(hSlotAbility.nPlaceholder - 1)
            return
        end
    end
end

function HeroBuilder:AddAbility(nPlayerID, sAbilityName, nLevel, flCoolDown)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hHero then
        PrecacheItemByNameAsync(sAbilityName, function()
            if hHero and not hHero:IsNull() then          
                local bHasInvulnerable = false
                if hHero:HasModifier("modifier_hero_refreshing") then
                   bHasInvulnerable = true
                   hHero:RemoveModifierByName("modifier_hero_refreshing")
                end
                local hNewAbility = hHero:AddAbility(sAbilityName)
                if bHasInvulnerable then
                   hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
                end  
                if hNewAbility and (not hNewAbility:IsNull()) then
                    hNewAbility:ClearInnateModifiers()
                    hNewAbility:MarkAbilityButtonDirty()
                    hHero:CalculateStatBonus(false) 
                    if flCoolDown and flCoolDown>0 then
                       hNewAbility:StartCooldown(flCoolDown)
                    end
                    hNewAbility:SetRefCountsModifiers(true)
                    if hNewAbility:GetAbilityName() == "muerta_pierce_the_veil" then
                        hHero:AddNewModifier(hHero, hNewAbility, "modifier_muerta_pierce_the_veil", {})
                    end
                    if nLevel and nLevel>0 then
                        hNewAbility:SetLevel(nLevel)
                    end
                    Timers:CreateTimer(0.1, function()
                        if not hNewAbility or hNewAbility:IsNull() then return end
                        if hNewAbility.sRemovalTimer then return end
                        HeroBuilder:SetAbilityToSlot(hHero, hNewAbility)
                        HeroBuilder:AddLinkedAbilities(hHero,sAbilityName,nLevel)
                        HeroBuilder:AddScepterLinkAbilities(hHero)
                        HeroBuilder:AddShardLinkAbilities(hHero)
                        HeroBuilder:FixShardAbilities(hHero)
                        HeroBuilder:RefreshAbilityOrder(nPlayerID)
                    end)
                    local sHeroOwnerName = HeroBuilder.abilityHeroMap[sAbilityName]
                    if sHeroOwnerName and not table.contains(HeroBuilder.pendingPrecache, sHeroOwnerName) and not HeroBuilder.precached[sHeroOwnerName] then
                        table.insert(HeroBuilder.pendingPrecache, sHeroOwnerName)  
                    end
                end
            end
        end)
    end
end

function HeroBuilder:RemoveAbility(nPlayerID, sAbilityName)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local hAbility = hHero:FindAbilityByName(sAbilityName)
    if hHero and hAbility then
        if HeroBuilder.linkedAbilities[sAbilityName] then
            for _, sLinkedAbilityName in ipairs(HeroBuilder.linkedAbilities[sAbilityName]) do
                local hLinkedAbility = hHero:FindAbilityByName(sLinkedAbilityName)

                local bStillUsing = false                
                for _,sOtherAbility in pairs(hHero.abilitiesList) do
                    if (sOtherAbility~=sAbilityName) and HeroBuilder.linkedAbilities[sOtherAbility] and table.contains(HeroBuilder.linkedAbilities[sOtherAbility],sLinkedAbilityName) then
                        bStillUsing = true
                    end
                end

                if hLinkedAbility and (not bStillUsing) then
                    if hLinkedAbility:IsHidden() then
                        hHero:RemoveAbilityForEmpty(sLinkedAbilityName)
                    else
                        hHero:RemoveAbilityWithRestructure(sLinkedAbilityName)
                    end
                end
            end
        end

        if hAbility and hAbility:GetIntrinsicModifierName() ~= nil then
            local modifier_intrinsic = hHero:FindModifierByName(hAbility:GetIntrinsicModifierName())
            if modifier_intrinsic then
                hHero:RemoveModifierByName(modifier_intrinsic:GetName())
            end
        end

        hHero:RemoveAbilityForEmpty(sAbilityName)
        Util:RemoveAbilityClean(hHero, sAbilityName)
        HeroBuilder:RemoveScepterLinkAbilities(hHero, sAbilityName)
        HeroBuilder:RemoveShardLinkAbilities(hHero, sAbilityName)
    end
end

function HeroBuilder:ChooseRandomOneAbility(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local tempList = table.deepcopy(HeroBuilder.allAbilityNames)

    for _, sAbilityName in ipairs(hHero.abilitiesList) do
        table.remove_item(tempList,sAbilityName)
        if abilityExclusion[sAbilityName] then
            for _,sExclusion in ipairs(abilityExclusion[sAbilityName]) do
                table.remove_item(tempList,sExclusion)
            end
        end
    end

    local rubick_skill = hHero:FindAbilityByName("rubick_spell_steal_custom")
    if rubick_skill then
        if rubick_skill.currentSpell ~= nil then
            table.remove_item(tempList,rubick_skill.currentSpell:GetAbilityName())
        end
    end

    if heroExclusion[hHero:GetUnitName()] then
        for _,sAbilityName in ipairs(heroExclusion[hHero:GetUnitName()]) do
            table.remove_item(tempList,sAbilityName)
        end
    end
    for sAbilityName,v in pairs(unremovableAbilities) do         
        table.remove_item(tempList,sAbilityName)
    end
    for _,sAbilityName in ipairs(Pass.banAbilityList) do
        table.remove_item(tempList,sAbilityName)
    end
    return table.random(tempList)
end


function HeroBuilder:RefreshAbilityOrder(nPlayerID)
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hPlayer and hHero then
        Timers:CreateTimer(0.1, function()
            hHero.sSwapUISecret=CreateSecretKey()
            CustomGameEventManager:Send_ServerToPlayer(hPlayer,"RefreshAbilityOrder",{swap_ui_secret=hHero.sSwapUISecret})
            CustomGameEventManager:Send_ServerToTeam(hHero:GetTeamNumber(),"UpdateTeamPlayers",{})
        end)
    end
end

function HeroBuilder:SwapAbility(keys)
    local nPlayerID=keys.player_id
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hHero.sSwapUISecret~=keys.swap_ui_secret then
        return
    end
    local sSwap_1=keys.swap_1
    local sSwap_2=keys.swap_2
    if hHero then
        local hAbility1 = hHero:FindAbilityByName(sSwap_1)
        local hAbility2 = hHero:FindAbilityByName(sSwap_2)
        if hAbility1 and hAbility2  and not hAbility1:IsHidden() and not hAbility2:IsHidden() then
            hHero:SwapAbilities(sSwap_1, sSwap_2, true, true)
        end
    end
    HeroBuilder:RefreshAbilityOrder(nPlayerID)
end


function HeroBuilder:ChooseRandomSummonAbility(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local tempList = table.deepcopy(HeroBuilder.summonAbilities)
    for _, sAbilityName in ipairs(hHero.abilitiesList) do
        table.remove_item(tempList,sAbilityName)
        if abilityExclusion[sAbilityName] then
            for _,sExclusion in ipairs(abilityExclusion[sAbilityName]) do
                table.remove_item(tempList,sExclusion)
            end
        end
    end
    return table.random(tempList)
end

function HeroBuilder:RegisterAttackCapabilityChanged(hHero)
    if not hHero or  hHero:IsTempestDouble() or hHero:HasModifier("modifier_arc_warden_tempest_double_lua") then 
        return 
    end
    HeroBuilder.attackCapabilityChanged[hHero:GetEntityIndex()] = hHero
end

function HeroBuilder:HasAttackCapabilityModifiers(hHero)
    for _, hModifier in ipairs(hHero:FindAllModifiers()) do
        if HeroBuilder.attackCapabilityModifiers[hModifier:GetName()] then
            return true
        end
    end
    return false
end

function HeroBuilder:FixAttackCapability()
    for _, hHero in pairs(HeroBuilder.attackCapabilityChanged) do
        if  hHero and hHero.nOriginalAttackCapability and not HeroBuilder:HasAttackCapabilityModifiers(hHero) then
            hHero:SetAttackCapability(hHero.nOriginalAttackCapability)
        end
    end
end

function HeroBuilder:ProposeTeammateSwap( event )
    if not event.own or not event.other then return end
    local hProposeHero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    
    if not hProposeHero then 
        return 
    end

    if hProposeHero.sTeamSwapUISecret~=event.ui_secret then
        return 
    end

    if not hProposeHero.nSwappingItemIndex then 
        return 
    end

    local hFirstAbility = EntIndexToHScript(event.own)

    if not hFirstAbility then return end
    if not hFirstAbility:GetCaster() then return end

    if event.PlayerID ~=hFirstAbility:GetCaster():GetPlayerID() then 
        return 
    end

    event.team_nubmer = PlayerResource:GetTeam(event.PlayerID)
    event.proposer_id = event.PlayerID

    local hSecondAbility = EntIndexToHScript(event.other)
    if not hSecondAbility then 
        return 
    end
  
    local hFirstPlayer = hFirstAbility:GetCaster():GetPlayerOwner()
    local hSecondPlayer = hSecondAbility:GetCaster():GetPlayerOwner()
  
    local hFirstHero = hFirstAbility:GetCaster()
    local hSecondHero = hSecondAbility:GetCaster()
  
    if abilityExclusion[hSecondAbility:GetAbilityName()] then
        for _,sExclusion in ipairs(abilityExclusion[hSecondAbility:GetAbilityName()]) do
            if table.contains(hFirstHero.abilitiesList, sExclusion) and sExclusion~=hFirstAbility:GetAbilityName() then
                if hFirstPlayer then
                CustomGameEventManager:Send_ServerToPlayer(hFirstPlayer,"ConflictAbility",{})
                end
                HeroBuilder:SwapNotValide(event)
                return
            end
        end
    end

    if abilityExclusion[hFirstAbility:GetAbilityName()] then
        for _,sExclusion in ipairs(abilityExclusion[hFirstAbility:GetAbilityName()]) do
            if table.contains(hSecondHero.abilitiesList, sExclusion) and sExclusion~=hSecondAbility:GetAbilityName() then
                if hFirstPlayer then
                CustomGameEventManager:Send_ServerToPlayer(hFirstPlayer,"ConflictTeammateAbility",{})
                end
                HeroBuilder:SwapNotValide(event)
                return
            end
        end
    end

    if heroExclusion[hFirstHero:GetUnitName()] then
        for _,sExclusion in ipairs(heroExclusion[hFirstHero:GetUnitName()]) do
            if sExclusion == hSecondAbility:GetAbilityName() then
                if hFirstPlayer then
                    CustomGameEventManager:Send_ServerToPlayer(hFirstPlayer,"ConflictModel",{})
                end
                HeroBuilder:SwapNotValide(event)
                return
            end
        end
    end

    if heroExclusion[hSecondHero:GetUnitName()] then
        for _,sExclusion in ipairs(heroExclusion[hSecondHero:GetUnitName()]) do
            if sExclusion == hFirstAbility:GetAbilityName() then
                if hFirstPlayer then
                    CustomGameEventManager:Send_ServerToPlayer(hFirstPlayer,"ConflictTeammateModel",{})
                end
                HeroBuilder:SwapNotValide(event)
                return
            end
        end
    end

    local sVerification = tostring(event.own) .. "_" .. tostring(event.other)
    HeroBuilder.pendingSwaps[sVerification] = event

    if (hSecondHero and hSecondHero.bTakenOverByBot) or PlayerResource:IsFakeClient(hSecondHero:GetPlayerID()) then
        HeroBuilder:AcceptTeammateSwap(event)
    else
        CustomGameEventManager:Send_ServerToTeam(hSecondAbility:GetCaster():GetTeamNumber(), "LockAbilities", event)
        Timers:CreateTimer(1/15, function() 
            CustomGameEventManager:Send_ServerToPlayer(hSecondPlayer, "SwapProposed", event)
        end)
        Timers:CreateTimer(sVerification, {
            useGameTime = false,
            endTime = 19.8,
            callback = function()
            HeroBuilder:ResetSwapStatus(event,false)
        end})
    end
end


function HeroBuilder:ReplaceAbilityList(hHero, sPreName, sNewName)
    if not hHero.abilitiesList then return end
    for i, x in pairs(hHero.abilitiesList) do
        if x == sPreName then
            table.remove(hHero.abilitiesList, i)
            break
        end
    end
    table.insert(hHero.abilitiesList, sNewName)
end

function HeroBuilder:AcceptTeammateSwap( event )
    xpcall(function()
        if not event.own or not event.other then return end
        local sVerification = tostring(event.own) .. "_" .. tostring(event.other)
        if not HeroBuilder.pendingSwaps[sVerification] then return end
        local swapData = HeroBuilder.pendingSwaps[sVerification]
        if swapData.own ~= event.own or swapData.other ~= event.other then return end
        Timers:RemoveTimer(sVerification)

        local hFirstAbility = EntIndexToHScript(event.own)
        local hSecondAbility = EntIndexToHScript(event.other)

        if not hFirstAbility or not hSecondAbility then 
            event.team_nubmer = PlayerResource:GetTeam(event.PlayerID)
            HeroBuilder:ResetSwapStatus(event, false)
            return 
        end

        if event.item_index and type(event.item_index) == "number" then
            local hSwapItem = EntIndexToHScript(event.item_index)
            if not hSwapItem then
                HeroBuilder:ResetSwapStatus(event, false)
                return 
            end
        else
            HeroBuilder:ResetSwapStatus(event, false)
            return 
        end

        local hFirstHero = hFirstAbility:GetCaster()
        local hSecondHero = hSecondAbility:GetCaster()
        local sFirstName = hFirstAbility:GetAbilityName()
        local sSecondName = hSecondAbility:GetAbilityName()

        local nSecondPlayerID = hSecondHero:GetPlayerOwnerID()
        if event.PlayerID ~= nSecondPlayerID and not (PlayerResource:IsFakeClient(nSecondPlayerID) or  hSecondHero.bTakenOverByBot)  then
            return
        end

        local nFirstPlayerID = hFirstHero:GetPlayerOwnerID()
  
  
        if not table.contains(hFirstHero.abilitiesList,sFirstName) then
            HeroBuilder:ResetSwapStatus(event, false)
            return 
        end

        if not table.contains(hSecondHero.abilitiesList,sSecondName) then
            HeroBuilder:ResetSwapStatus(event, false)
            return 
        end

        if not hFirstHero:HasAbility(sFirstName) then
            HeroBuilder:ResetSwapStatus(event, false)
            return 
        end
  
        if not hSecondHero:HasAbility(sSecondName) then
            HeroBuilder:ResetSwapStatus(event, false)
            return 
        end
  
        event.team_nubmer = PlayerResource:GetTeam(event.PlayerID)
        event.proposer_id = hFirstHero:GetPlayerOwnerID()
        local flFirstCooldown = hFirstAbility:GetCooldownTimeRemaining()
        local flSecondCooldown = hSecondAbility:GetCooldownTimeRemaining()
        hFirstHero:SetAbilityPoints(hFirstHero:GetAbilityPoints() + hFirstAbility:GetLevel())
        hSecondHero:SetAbilityPoints(hSecondHero:GetAbilityPoints() + hSecondAbility:GetLevel())
        HeroBuilder:RemoveAbility(nFirstPlayerID, sFirstName)
        HeroBuilder:RemoveAbility(nSecondPlayerID, sSecondName)
        HeroBuilder:AddAbility(nFirstPlayerID,sSecondName,nil,flSecondCooldown)
        HeroBuilder:AddAbility(nSecondPlayerID,sFirstName,nil,flFirstCooldown)
        HeroBuilder:ReplaceAbilityList(hFirstHero, sFirstName, sSecondName)
        HeroBuilder:ReplaceAbilityList(hSecondHero, sSecondName, sFirstName)

        Timers:CreateTimer(0.02, function()
            HeroBuilder:RefreshAbilityOrder(hFirstHero:GetPlayerOwnerID())
            HeroBuilder:RefreshAbilityOrder(hSecondHero:GetPlayerOwnerID())
        end)

        HeroBuilder:ResetSwapStatus(event, true)
    end,
    function(e)
        HeroBuilder:ResetSwapStatus(event, false)
    end)        
end

function HeroBuilder:DeclineTeammateSwap(keys)
    local nPlayerID =  keys.PlayerID
    keys.team_nubmer = PlayerResource:GetTeam(nPlayerID)
    HeroBuilder:ResetSwapStatus(keys, false)
end

function HeroBuilder:ResetSwapStatus(event, bAccept)
    if not event.own or not event.other then return end
    local sVerification = tostring(event.own) .. "_" .. tostring(event.other)
    if not HeroBuilder.pendingSwaps[sVerification] then return end
  
    if event.proposer_id then
        local hProposeHero = PlayerResource:GetSelectedHeroEntity(event.proposer_id)
        hProposeHero.nSwappingItemIndex = nil
    end

    if event.item_index and  bAccept then
        local hSwapItem = EntIndexToHScript(event.item_index)
        if hSwapItem and hSwapItem.SpendCharge then
            hSwapItem:SpendCharge()
        end
    end

    event.accepted = bAccept
    HeroBuilder.pendingSwaps[sVerification] = nil
    CustomGameEventManager:Send_ServerToTeam(event.team_nubmer, "UnlockAbilities", event)
end


function HeroBuilder:SwapNotValide(event)
    if not event.own or not event.other then return end
    if event.proposer_id then
        local hProposeHero = PlayerResource:GetSelectedHeroEntity(event.proposer_id)
        hProposeHero.nSwappingItemIndex = nil
    end
    local hPlayer = PlayerResource:GetPlayer(event.PlayerID)   
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, "SwapNotValide", event)
end

function HeroBuilder:ReorderComplete(keys)
    if not keys.PlayerID then
        return
    end
   
    local nPlayerID=keys.PlayerID
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    if hHero.sSwapUISecret~=keys.swap_ui_secret then
        return
    end

    local sSwap_1=keys.moved_ability
    local sSwap_2=keys.ref_ability
     
    if hHero then
        local hAbility1 = hHero:FindAbilityByName(sSwap_1)
        local hAbility2 = hHero:FindAbilityByName(sSwap_2)

        if hAbility1 and hAbility2 and not hAbility1:IsHidden() and not hAbility2:IsHidden()   then
            hHero:SwapAbilities(sSwap_1, sSwap_2, true, true)
        end
    end

    HeroBuilder:RefreshAbilityOrder(nPlayerID)
end

function HeroBuilder:MakeRandomHeroSelection(nPlayerID)
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    if hPlayer then
        local sHeroName = table.random(HeroBuilder.allHeroeNames)
        table.remove_item(HeroBuilder.allHeroeNames,sHeroName)
        hPlayer:SetSelectedHero(sHeroName)
    end
end

function HeroBuilder:ReconnectRefundBook(hHero)

    if true == hHero.bOmniscientBookSelectingAbility then

    end

    hHero.bOmniscientBookSelectingAbility = false

    if true == hHero.bRemovingAbility then
        local hItem = CreateItem("item_relearn_book_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
    end

    hHero.bRemovingAbility = false
    
    if true == hHero.bOmniscientBookRemoving then
        local hItem = CreateItem("item_omniscient_book", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
    end

    hHero.bOmniscientBookRemoving = false

    if true == hHero.bSelectingSpellBook then
        local hItem = CreateItem("item_spell_book_empty_lua", hHero, hHero)
        hHero:AddItem(hItem)
        hItem:SetPurchaseTime(0)
        hItem:SetSellable(false)
    end

    hHero.bSelectingSpellBook = false
end

--===========================================
-- Аганимные и шардовые способности 
--===========================================
function HeroBuilder:AddScepterLinkAbilities(hHero)
    if hHero and hHero:IsRealHero() and hHero:GetUnitName() and hHero:HasScepter() then
        for sLoopAbilityName, abilityList in pairs(scepterLinkAbilities) do
            local hLoopAbility = hHero:FindAbilityByName(sLoopAbilityName)
            
            if hLoopAbility and not hLoopAbility:IsNull() and hLoopAbility.sRemovalTimer==nil then
                for i,sAbilityName in ipairs(abilityList) do
                    local hAbility = hHero:FindAbilityByName(sAbilityName)
                    if not (hAbility and hAbility.sRemovalTimer==nil) then
                        if hLoopAbility.rubick_spell == nil then
                            local hScepterAbility= hHero:AddAbility(sAbilityName)
                            if hScepterAbility and (not hScepterAbility:IsNull()) then
                                hScepterAbility:SetLevel(1)
                                hScepterAbility.bScepterAbility = true
                                if i == 1 then
                                    HeroBuilder:SetAbilityToSlot(hHero, hScepterAbility)
                                    hHero:FindHotKeyForAbility(sAbilityName)
                                    hScepterAbility:SetHidden(false)
                                end
                            end
                        end
                    end
                end
            end
        end

        if hHero.GetPlayerID and hHero:GetPlayerID() then
            Timers:CreateTimer(FrameTime(), function()
                HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerID())
            end)
        end
    end
end

function HeroBuilder:AddShardLinkAbilities(hHero)
    if hHero and hHero:IsRealHero() and hHero:GetUnitName() and hHero:HasShard() then
        for sLoopAbilityName,abilityList in pairs(shardLinkAbilities) do
            local hLoopAbility = hHero:FindAbilityByName(sLoopAbilityName)
            
            if hLoopAbility and not hLoopAbility:IsNull() and hLoopAbility.sRemovalTimer==nil then
                for i,sAbilityName in ipairs(abilityList) do
                    local hAbility = hHero:FindAbilityByName(sAbilityName)
                    if not (hAbility and hAbility.sRemovalTimer==nil) then
                        if hLoopAbility.rubick_spell == nil then
                            local hShardAbility= hHero:AddAbility(sAbilityName)
                            if hShardAbility and (not hShardAbility:IsNull()) then                        
                                if sAbilityName ~= "shadow_demon_demonic_cleanse" then
                                    hShardAbility:SetLevel(1)
                                end
                             
                                if i == 1 then
                                    HeroBuilder:SetAbilityToSlot(hHero, hShardAbility)
                                    hHero:FindHotKeyForAbility(sAbilityName)
                                    hShardAbility:SetHidden(false)
                                end
                            end
                        end
                    end
                end
            end
        end

        if hHero.GetPlayerID and hHero:GetPlayerID() then
            Timers:CreateTimer(FrameTime(), function()
                HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerID())
            end)
        end
    end
end

function HeroBuilder:AddScepterShardAbility(nHeroIndex)
    local hHero = EntIndexToHScript(nHeroIndex)

    if hHero and hHero:IsRealHero() and hHero:GetUnitName() and scepterShardAbilities[hHero:GetUnitName()] then
        local abilityList = scepterShardAbilities[hHero:GetUnitName()]

        for i,sAbilityName in ipairs(abilityList) do
            local hAbility = hHero:FindAbilityByName(sAbilityName)
            if not hAbility then
              local hScepterShardAbility= hHero:AddAbility(sAbilityName)
                if hScepterShardAbility then
                    hScepterShardAbility:SetLevel(1)
                    hScepterShardAbility:MarkAbilityButtonDirty()
                
                    if i == 1 then
                        HeroBuilder:SetAbilityToSlot(hHero, hScepterShardAbility)
                        if hScepterShardAbility and (not hScepterShardAbility:IsNull()) and hScepterShardAbility:IsHidden() then
                            hHero:FindHotKeyForAbility(sAbilityName)
                            hScepterShardAbility:SetHidden(false)
                        end
                    end
                end
            end
        end

        if hHero.GetPlayerID and hHero:GetPlayerID() then
            Timers:CreateTimer(FrameTime(), function()
                HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerID())
            end)
        end
    end

    if hHero and hHero:IsRealHero() and hHero:GetUnitName() then
        HeroBuilder:FixShardAbilities(hHero)
    end

    if hHero:IsRealHero() and hHero:GetUnitName() and hHero:GetUnitName()=="npc_dota_hero_lycan" and not hHero:IsTempestDouble() and not hHero:HasModifier("modifier_arc_warden_tempest_double_lua") then
        if not hHero.bElfWolf then
            hHero.bElfWolf = true
            ExtraCreature:AddExtraCreature(hHero:GetPlayerID(),"npc_dota_elf_wolf")
        end
    end
end

function HeroBuilder:AddScepterAbility(hHero)
    if hHero and hHero:IsRealHero() and hHero:GetUnitName() then
        if scepterAbilities[hHero:GetUnitName()] then
            local abilityList = scepterAbilities[hHero:GetUnitName()]
            for i,sAbilityName in ipairs(abilityList) do
                local hAbility = hHero:FindAbilityByName(sAbilityName)
                if not hAbility then
                  local hScepterAbility = hHero:AddAbility(sAbilityName)
                  if hScepterAbility and (not hScepterAbility:IsNull()) then
                        hScepterAbility:SetLevel(1)
                        hScepterAbility.bScepterAbility = true
                        hScepterAbility:MarkAbilityButtonDirty()
                     
                        if i == 1 then
                            HeroBuilder:SetAbilityToSlot(hHero, hScepterAbility)
                            if hScepterAbility and (not hScepterAbility:IsNull()) and hScepterAbility:IsHidden() then
                                hScepterAbility:SetHidden(false)
                                hHero:FindHotKeyForAbility(sAbilityName)
                            end
                        end
                    end
                end
            end
        end

        if hHero.GetPlayerID and hHero:GetPlayerID() then
            Timers:CreateTimer(FrameTime(), function()
                HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerID())
            end)
        end
    end
end

function HeroBuilder:FixShardAbilities(hHero)
    if hHero:HasModifier("modifier_item_aghanims_shard") then
        if hHero:HasAbility("sandking_epicenter") then
            if not hHero:HasModifier("modifier_sand_king_shard") then
                hHero:AddNewModifier(hHero, hHero:FindAbilityByName("sandking_epicenter"), "modifier_sand_king_shard", {})
            end
        end
      
        if hHero:HasAbility("dragon_knight_elder_dragon_form_custom") then
            if not hHero:HasAbility("dragon_knight_fireball") then
                hHero:AddAbility("dragon_knight_fireball")
            end
        end
    end
end

function HeroBuilder:RegisterScepterOwner(hHero)
    if not hHero or not hHero:IsMainHero() then return end
    HeroBuilder.scepterOwners[hHero:GetEntityIndex()] = hHero
end

function HeroBuilder:UnregisterScepterOwner(hHero)
    if not hHero or not hHero:IsMainHero() then return end
    if hHero:GetEntityIndex() and HeroBuilder.scepterOwners[hHero:GetEntityIndex()] then
       HeroBuilder.scepterOwners[hHero:GetEntityIndex()] = nil
    end
end

function HeroBuilder:ProcessScepterOwners()
    for _, hHero in pairs(HeroBuilder.scepterOwners) do
        if hHero and not hHero:IsNull() and not hHero:HasScepter() then
            HeroBuilder:OnScepterLost(hHero)
        end
    end
end

function HeroBuilder:OnScepterLost(hHero)
    if not hHero or not hHero:IsMainHero() then 
        return 
    end

    HeroBuilder:UnregisterScepterOwner(hHero)

    for i = 0, hHero:GetAbilityCount() - 1 do
        local hAbility = hHero:GetAbilityByIndex(i)
        if hAbility and hAbility.bScepterAbility then
            local sAbilityName = hAbility:GetAbilityName()
            hHero:RemoveAbilityWithRestructure(sAbilityName) -- Удаление способности
        end
    end

    HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerOwnerID())

    if hHero:HasModifier("modifier_bloodseeker_blood_mist_custom") then
        hHero:RemoveModifierByName("modifier_bloodseeker_blood_mist_custom")
    end
    
    EventDriver:Dispatch("Hero:scepter_lost", { hero = hHero } )
end

function HeroBuilder:RemoveScepterLinkAbilities(hHero,sRawAbilityName)
    if hHero and  hHero:IsRealHero() and hHero:GetUnitName() and scepterLinkAbilities[sRawAbilityName]  then
        for i,sAbilityName in ipairs(scepterLinkAbilities[sRawAbilityName]) do
            local hAbility = hHero:FindAbilityByName(sAbilityName)
            if hAbility then
                if scepterAbilities[hHero:GetUnitName()]==nil or (not table.contains(scepterAbilities[hHero:GetUnitName()],sAbilityName)) then
                    hHero:RemoveAbilityWithRestructure(sAbilityName) -- Удаление способности
                end
            end
        end
        if hHero.GetPlayerID and hHero:GetPlayerID() then
            Timers:CreateTimer(FrameTime(), function()
                HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerID())
            end)
        end
    end
end

function HeroBuilder:RemoveShardLinkAbilities(hHero,sRawAbilityName)
    if hHero and hHero:IsRealHero() and hHero:GetUnitName() and shardLinkAbilities[sRawAbilityName] then
        for i,sAbilityName in ipairs(shardLinkAbilities[sRawAbilityName]) do
            local hAbility = hHero:FindAbilityByName(sAbilityName)
            if hAbility then
                if scepterShardAbilities[hHero:GetUnitName()]==nil or (not table.contains(scepterShardAbilities[hHero:GetUnitName()],sAbilityName)) then
                    hHero:RemoveAbilityWithRestructure(sAbilityName)
                end
            end
        end
        if hHero.GetPlayerID and hHero:GetPlayerID() then
            Timers:CreateTimer(FrameTime(), function()
                HeroBuilder:RefreshAbilityOrder(hHero:GetPlayerID())
            end)
        end
    end
end

function HeroBuilder:NeutralItemSelect(hero, id, tier)
    local current_random = HeroBuilder.neutral_list[tostring(tier)]["items"]
    if HeroBuilder.RewardForPlayer[id][tier] ~= nil and HeroBuilder.RewardForPlayer[id][tier][1] == nil then
        HeroBuilder.RewardForPlayer[id][tier] = {}
        local random_items_list = {}
        for name, data in pairs(current_random) do
            if HeroBuilder.NeutralsHasRandomed[id][name] == nil then
                table.insert(random_items_list, name)
            end
        end
        local random_items_for_player = table.random_some(random_items_list, 5)
        HeroBuilder.RewardForPlayer[id][tier] = random_items_for_player
    end
    local player = PlayerResource:GetPlayer(id)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "event_neutral_select", {neutral_items = HeroBuilder.RewardForPlayer[id][tier], tier = tier })
    end
end

function HeroBuilder:NeutralItemSelectRoshan(hero, id, tier)
    local current_random = HeroBuilder.neutral_list[tostring(tier)]["items"]
    if HeroBuilder.RewardForPlayerRoshan[id][tier] ~= nil and HeroBuilder.RewardForPlayerRoshan[id][tier][1] == nil then
        HeroBuilder.RewardForPlayerRoshan[id][tier] = {}
        local random_items_list = {}
        for name, data in pairs(current_random) do
            if HeroBuilder.NeutralsHasRandomed[id][name] == nil then
                table.insert(random_items_list, name)
            end
        end
        local random_items_for_player = table.random_some(random_items_list, 1)
        HeroBuilder.RewardForPlayerRoshan[id][tier] = random_items_for_player
    end
    local player = PlayerResource:GetPlayer(id)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "event_neutral_select", {neutral_items = HeroBuilder.RewardForPlayerRoshan[id][tier], roshan = 1, tier = tier })
    end
end

function HeroBuilder:SelectNeutralRewardReturn(data)
	if data.PlayerID == nil then return end
	local id = data.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(id)
    if hero == nil then return end
    if not hero:IsAlive() then return end
    hero.neutral_select = false
    local roshan = data.roshan
    if roshan then
        hero:AddItemByName("item_tier"..data.tier.."_token_roshan_custom")
    else
        hero:AddItemByName("item_tier"..data.tier.."_token_custom")
    end
end

function HeroBuilder:SelectNeutralReward(data)
	if data.PlayerID == nil then return end
	local id = data.PlayerID
	local choose = data.choose
	local hero = PlayerResource:GetSelectedHeroEntity(id)
    local roshan = data.roshan
    local tier = data.tier
    if hero == nil then return end
    if not hero:IsAlive() then return end

    if roshan then
        if HeroBuilder.RewardForPlayerRoshan[id][tier][choose] == nil then return end
        local item_name = HeroBuilder.RewardForPlayerRoshan[id][tier][choose]
        if hero and item_name then
            HeroBuilder.NeutralsHasRandomed[id][item_name] = true
            local neutralItem = CreateItem(item_name, hero, hero)
            hero:AddItem(neutralItem)
            neutralItem:SetPurchaseTime(0)
            neutralItem.owner = hero
        end
        hero.neutral_select = false
        HeroBuilder.RewardForPlayerRoshan[id][tier] = {}
    else
        if HeroBuilder.RewardForPlayer[id][tier][choose] == nil then return end
        local item_name = HeroBuilder.RewardForPlayer[id][tier][choose]
        if hero and item_name then
            HeroBuilder.NeutralsHasRandomed[id][item_name] = true
            local neutralItem = CreateItem(item_name, hero, hero)
            hero:AddItem(neutralItem)
            neutralItem:SetPurchaseTime(0)
            neutralItem.owner = hero
        end
        hero.neutral_select = false
        HeroBuilder.RewardForPlayer[id][tier] = {}
        if tier == 5 then
            HeroBuilder.HasUseNeutralFiveTier[id] = true
        end
    end
end

function HeroBuilder:GetUniqueNeutralItemRandom(id, tier)
    local neutrals_items = HeroBuilder.neutral_list[tostring(tier)]["items"]
    local random_items_list = {}
    for name, data in pairs(neutrals_items) do
        if HeroBuilder.NeutralsHasRandomed[id][name] == nil then
            table.insert(random_items_list, name)
        end
    end
    return table.random_some(random_items_list, 1)
end
