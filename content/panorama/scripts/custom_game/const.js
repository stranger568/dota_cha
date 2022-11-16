//常量
var HERO_SPAWN_SOUND_EVENTS = {
    npc_dota_hero_abaddon: [
        "abaddon_abad_spawn_01",
        "abaddon_abad_spawn_02",
        "abaddon_abad_spawn_03",
        "abaddon_abad_spawn_04",
        "abaddon_abad_spawn_05",
    ],
    npc_dota_hero_abyssal_underlord: [
        "abyssal_underlord_abys_spawn_02",
        "abyssal_underlord_abys_spawn_03",
        "abyssal_underlord_abys_spawn_04",
        "abyssal_underlord_abys_spawn_05",
        "abyssal_underlord_abys_spawn_06",
        "abyssal_underlord_abys_spawn_07",
        "abyssal_underlord_abys_spawn_08",
    ],
    npc_dota_hero_alchemist: [
        "alchemist_alch_spawn_01",
        "alchemist_alch_spawn_02",
        "alchemist_alch_spawn_03",
        "alchemist_alch_spawn_04",
        "alchemist_alch_spawn_05",
        "alchemist_alch_spawn_06",
    ],
    npc_dota_hero_ancient_apparition: [
        "ancient_apparition_appa_spawn_01",
        "ancient_apparition_appa_spawn_02",
        "ancient_apparition_appa_spawn_03",
        "ancient_apparition_appa_spawn_04",
    ],
    npc_dota_hero_antimage: [
        "antimage_anti_spawn_01",
        "antimage_anti_spawn_02",
        "antimage_anti_spawn_03",
        "antimage_anti_spawn_04",
    ],
    npc_dota_hero_arc_warden: [
        "arc_warden_arcwar_spawn_01",
        "arc_warden_arcwar_spawn_02",
        "arc_warden_arcwar_spawn_03",
        "arc_warden_arcwar_spawn_04",
        "arc_warden_arcwar_spawn_05",
        "arc_warden_arcwar_spawn_06",
        "arc_warden_arcwar_spawn_07",
        "arc_warden_arcwar_spawn_08",
        "arc_warden_arcwar_spawn_09",
    ],
    npc_dota_hero_axe: [
        "axe_axe_spawn_01",
        "axe_axe_spawn_02",
        "axe_axe_spawn_03",
        "axe_axe_spawn_04",
        "axe_axe_spawn_05",
        "axe_axe_spawn_06",
        "axe_axe_spawn_07",
        "axe_axe_spawn_08",
        "axe_axe_spawn_09",
        "axe_axe_spawn_10",
    ],
    npc_dota_hero_bane: [
        "bane_bane_spawn_01",
        "bane_bane_spawn_02",
        "bane_bane_spawn_03",
        "bane_bane_spawn_04",
        "bane_bane_spawn_05",
        "bane_bane_spawn_06",
        "bane_bane_spawn_07",
    ],
    npc_dota_hero_batrider: [
        "batrider_bat_spawn_01",
        "batrider_bat_spawn_02",
        "batrider_bat_spawn_03",
        "batrider_bat_spawn_04",
        "batrider_bat_spawn_05",
    ],
    npc_dota_hero_beastmaster: [
        "beastmaster_beas_spawn_01",
        "beastmaster_beas_spawn_02",
        "beastmaster_beas_spawn_03",
        "beastmaster_beas_spawn_04",
        "beastmaster_beas_spawn_05",
        "beastmaster_beas_spawn_06",
    ],
    npc_dota_hero_bloodseeker: [
        "bloodseeker_blod_spawn_01",
        "bloodseeker_blod_spawn_02",
        "bloodseeker_blod_spawn_03",
        "bloodseeker_blod_spawn_04",
        "bloodseeker_blod_spawn_05",
        "bloodseeker_blod_spawn_06",
        "bloodseeker_blod_spawn_07",
        "bloodseeker_blod_spawn_08",
    ],
    npc_dota_hero_bounty_hunter: [
        "bounty_hunter_bount_spawn_01",
        "bounty_hunter_bount_spawn_02",
        "bounty_hunter_bount_spawn_03",
        "bounty_hunter_bount_spawn_04",
    ],
    npc_dota_hero_brewmaster: [
        "brewmaster_brew_spawn_01",
        "brewmaster_brew_spawn_02",
        "brewmaster_brew_spawn_03",
        "brewmaster_brew_spawn_04",
        "brewmaster_brew_spawn_05",
        "brewmaster_brew_spawn_06",
    ],
    npc_dota_hero_bristleback: [
        "bristleback_bristle_spawn_01",
        "bristleback_bristle_spawn_02",
        "bristleback_bristle_spawn_03",
        "bristleback_bristle_spawn_04",
        "bristleback_bristle_spawn_05",
    ],
    npc_dota_hero_broodmother: [
        "broodmother_broo_spawn_01",
        "broodmother_broo_spawn_02",
        "broodmother_broo_spawn_03",
        "broodmother_broo_spawn_04",
        "broodmother_broo_spawn_05",
    ],
    npc_dota_hero_centaur: [
        "centaur_cent_spawn_01",
        "centaur_cent_spawn_02",
        "centaur_cent_spawn_03",
        "centaur_cent_spawn_04",
        "centaur_cent_spawn_05",
        "centaur_cent_spawn_06",
        "centaur_cent_spawn_07",
    ],
    npc_dota_hero_chaos_knight: [
        "chaos_knight_chaknight_spawn_01",
        "chaos_knight_chaknight_spawn_02",
        "chaos_knight_chaknight_spawn_03",
        "chaos_knight_chaknight_spawn_04",
        "chaos_knight_chaknight_spawn_05",
    ],
    npc_dota_hero_chen: [
        "chen_chen_spawn_01",
        "chen_chen_spawn_02",
        "chen_chen_spawn_03",
        "chen_chen_spawn_04",
        "chen_chen_spawn_05",
    ],
    npc_dota_hero_clinkz: [
        "clinkz_clinkz_spawn_01",
        "clinkz_clinkz_spawn_02",
        "clinkz_clinkz_spawn_03",
        "clinkz_clinkz_spawn_04",
    ],
    npc_dota_hero_crystal_maiden: [
        "crystalmaiden_cm_spawn_01",
        "crystalmaiden_cm_spawn_02",
        "crystalmaiden_cm_spawn_03",
        "crystalmaiden_cm_spawn_04",
        "crystalmaiden_cm_spawn_05",
        "crystalmaiden_cm_spawn_06",
        "crystalmaiden_cm_spawn_07",
        "crystalmaiden_cm_spawn_08",
    ],
    npc_dota_hero_dark_seer: [
        "dark_seer_dkseer_spawn_01",
        "dark_seer_dkseer_spawn_01",
        "dark_seer_dkseer_spawn_01",
        "dark_seer_dkseer_spawn_01",
        "dark_seer_dkseer_spawn_01",
    ],
    npc_dota_hero_dark_willow: [
        "dark_willow_sylph_spawn_01",
        "dark_willow_sylph_spawn_02",
        "dark_willow_sylph_spawn_03",
        "dark_willow_sylph_spawn_04",
        "dark_willow_sylph_spawn_06",
        "dark_willow_sylph_spawn_07",
        "dark_willow_sylph_spawn_08",
        "dark_willow_sylph_spawn_09",
        "dark_willow_sylph_spawn_10",
        "dark_willow_sylph_spawn_11",
        "dark_willow_sylph_spawn_12",
        "dark_willow_sylph_spawn_13",
        "dark_willow_sylph_spawn_14",
        "dark_willow_sylph_spawn_15",
        "dark_willow_sylph_spawn_16",
        "dark_willow_sylph_spawn_17",
        "dark_willow_sylph_spawn_18",
        "dark_willow_sylph_spawn_19",
        "dark_willow_sylph_spawn_20",
    ],
    npc_dota_hero_dazzle: [
        "dazzle_dazz_spawn_01",
        "dazzle_dazz_spawn_02",
        "dazzle_dazz_spawn_03",
        "dazzle_dazz_spawn_04",
        "dazzle_dazz_spawn_05",
    ],
    npc_dota_hero_death_prophet: [
        "death_prophet_dpro_spawn_01",
        "death_prophet_dpro_spawn_02",
        "death_prophet_dpro_spawn_03",
        "death_prophet_dpro_spawn_04",
        "death_prophet_dpro_spawn_05",
        "death_prophet_dpro_spawn_06",
    ],
    npc_dota_hero_disruptor: [
        "disruptor_dis_spawn_01",
        "disruptor_dis_spawn_02",
        "disruptor_dis_spawn_03",
        "disruptor_dis_spawn_04",
    ],
    npc_dota_hero_doom_bringer: [
        "doom_bringer_doom_spawn_01",
        "doom_bringer_doom_spawn_03",
        "doom_bringer_doom_spawn_04",
    ],
    npc_dota_hero_dragon_knight: [
        "dragon_knight_drag_spawn_01",
        "dragon_knight_drag_spawn_02",
        "dragon_knight_drag_spawn_03",
        "dragon_knight_drag_spawn_04",
    ],
    npc_dota_hero_drow_ranger: [
        "drowranger_dro_spawn_01",
        "drowranger_dro_spawn_02",
        "drowranger_dro_spawn_03",
        "drowranger_dro_spawn_04",
        "drowranger_dro_spawn_05",
        "drowranger_dro_spawn_06",
        "drowranger_dro_spawn_07",
    ],
    npc_dota_hero_earth_spirit: [
        "earth_spirit_earthspi_spawn_01",
        "earth_spirit_earthspi_spawn_02",
        "earth_spirit_earthspi_spawn_03",
        "earth_spirit_earthspi_spawn_04",
        "earth_spirit_earthspi_spawn_05",
        "earth_spirit_earthspi_spawn_06",
        "earth_spirit_earthspi_spawn_07",
    ],
    npc_dota_hero_earthshaker: [
        "earthshaker_erth_spawn_01",
        "earthshaker_erth_spawn_02",
        "earthshaker_erth_spawn_03",
        "earthshaker_erth_spawn_04",
        "earthshaker_erth_spawn_05",
        "earthshaker_erth_spawn_06",
    ],
    npc_dota_hero_elder_titan: [
        "elder_titan_elder_spawn_01",
        "elder_titan_elder_spawn_02",
        "elder_titan_elder_spawn_03",
        "elder_titan_elder_spawn_04",
        "elder_titan_elder_spawn_05",
        "elder_titan_elder_spawn_06",
        "elder_titan_elder_spawn_07",
        "elder_titan_elder_spawn_08",
        "elder_titan_elder_spawn_09",
    ],
    npc_dota_hero_ember_spirit: [
        "ember_spirit_embr_spawn_01",
        "ember_spirit_embr_spawn_02",
        "ember_spirit_embr_spawn_03",
        "ember_spirit_embr_spawn_04",
        "ember_spirit_embr_spawn_05",
        "ember_spirit_embr_spawn_06",
        "ember_spirit_embr_spawn_07",
    ],
    npc_dota_hero_enchantress: [
        "enchantress_ench_spawn_01",
        "enchantress_ench_spawn_02",
        "enchantress_ench_spawn_03",
        "enchantress_ench_spawn_04",
        "enchantress_ench_spawn_05",
    ],
    npc_dota_hero_enigma: [
        "enigma_enig_spawn_01",
        "enigma_enig_spawn_02",
        "enigma_enig_spawn_03",
        "enigma_enig_spawn_04",
        "enigma_enig_spawn_05",
        "enigma_enig_spawn_06",
        "enigma_enig_spawn_07",
        "enigma_enig_spawn_08",
        "enigma_enig_spawn_09",
    ],
    npc_dota_hero_faceless_void: [
        "faceless_void_face_spawn_01",
        "faceless_void_face_spawn_02",
        "faceless_void_face_spawn_03",
        "faceless_void_face_spawn_04",
    ],
    npc_dota_hero_furion: [
        "furion_furi_spawn_01",
        "furion_furi_spawn_02",
        "furion_furi_spawn_03",
    ],
    npc_dota_hero_gyrocopter: [
        "gyrocopter_gyro_spawn_01",
        "gyrocopter_gyro_spawn_02",
        "gyrocopter_gyro_spawn_03",
        "gyrocopter_gyro_spawn_04",
        "gyrocopter_gyro_spawn_05",
        "gyrocopter_gyro_spawn_06",
    ],
    npc_dota_hero_huskar: [
        "huskar_husk_spawn_01",
        "huskar_husk_spawn_02",
        "huskar_husk_spawn_03",
        "huskar_husk_spawn_04",
        "huskar_husk_spawn_05",
    ],
    npc_dota_hero_invoker: [
        "invoker_invo_spawn_01",
        "invoker_invo_spawn_02",
        "invoker_invo_spawn_03",
        "invoker_invo_spawn_04",
        "invoker_invo_spawn_05",
    ],
    npc_dota_hero_jakiro: [
        "jakiro_jak_spawn_01",
        "jakiro_jak_spawn_02",
        "jakiro_jak_spawn_03",
        "jakiro_jak_spawn_04",
        "jakiro_jak_spawn_05",
    ],
    npc_dota_hero_juggernaut: [
        "juggernaut_jug_spawn_01",
        "juggernaut_jug_spawn_02",
        "juggernaut_jug_spawn_03",
        "juggernaut_jug_spawn_04",
        "juggernaut_jug_spawn_05",
        "juggernaut_jug_spawn_06",
        "juggernaut_jug_spawn_07",
        "juggernaut_jug_spawn_08",
    ],
    npc_dota_hero_keeper_of_the_light: [
        "keeper_of_the_light_keep_spawn_01",
        "keeper_of_the_light_keep_spawn_02",
        "keeper_of_the_light_keep_spawn_03",
        "keeper_of_the_light_keep_spawn_04",
        "keeper_of_the_light_keep_spawn_05",
    ],
    npc_dota_hero_kunkka: [
        "kunkka_kunk_spawn_01",
        "kunkka_kunk_spawn_02",
        "kunkka_kunk_spawn_03",
        "kunkka_kunk_spawn_04",
        "kunkka_kunk_spawn_05",
        "kunkka_kunk_spawn_06",
        "kunkka_kunk_spawn_07",
        "kunkka_kunk_spawn_08",
        "kunkka_kunk_spawn_09",
        "kunkka_kunk_spawn_10",
        "kunkka_kunk_spawn_11",
        "kunkka_kunk_spawn_12",
    ],
    npc_dota_hero_legion_commander: [
        "legion_commander_legcom_spawn_01",
        "legion_commander_legcom_spawn_02",
        "legion_commander_legcom_spawn_03",
        "legion_commander_legcom_spawn_04",
        "legion_commander_legcom_spawn_05",
    ],

    npc_dota_hero_leshrac  : [
        "leshrac_lesh_spawn_01",
        "leshrac_lesh_spawn_02",
        "leshrac_lesh_spawn_03",
        "leshrac_lesh_spawn_04",
    ],
    npc_dota_hero_lich: [
        "lich_lich_spawn_01",
        "lich_lich_spawn_02",
        "lich_lich_spawn_03",
        "lich_lich_spawn_04",
        "lich_lich_spawn_05",
    ],
    npc_dota_hero_life_stealer: [
        "life_stealer_lifest_spawn_01",
        "life_stealer_lifest_spawn_02",
        "life_stealer_lifest_spawn_03",
        "life_stealer_lifest_spawn_04",
    ],
    npc_dota_hero_lina  : [
        "lina_lina_spawn_01",
        "lina_lina_spawn_02",
        "lina_lina_spawn_03",
        "lina_lina_spawn_04",
        "lina_lina_spawn_05",
        "lina_lina_spawn_06",
        "lina_lina_spawn_07",
        "lina_lina_spawn_08",
        "lina_lina_spawn_09",
    ],
    npc_dota_hero_lion: [
        "lion_lion_spawn_01",
        "lion_lion_spawn_02",
        "lion_lion_spawn_03",
        "lion_lion_spawn_04",
        "lion_lion_spawn_05",
        "lion_lion_spawn_06",
    ],
    npc_dota_hero_lone_druid: [
        "lone_druid_lone_druid_spawn_01",
        "lone_druid_lone_druid_spawn_02",
        "lone_druid_lone_druid_spawn_03",
        "lone_druid_lone_druid_spawn_04",
        "lone_druid_lone_druid_spawn_05",
        "lone_druid_lone_druid_spawn_06",
    ],

    npc_dota_hero_luna: [
        "luna_luna_spawn_01",
        "luna_luna_spawn_02",
        "luna_luna_spawn_03",
        "luna_luna_spawn_04",
    ],

    npc_dota_hero_lycan: [
        "lycan_lycan_spawn_01",
        "lycan_lycan_spawn_02",
        "lycan_lycan_spawn_03",
        "lycan_lycan_spawn_04",
    ],

    npc_dota_hero_magnataur: [
        "magnataur_magn_spawn_02",
        "magnataur_magn_spawn_04",
        "magnataur_magn_spawn_05",
        "magnataur_magn_spawn_06",
    ],
    npc_dota_hero_medusa: [
        "medusa_medus_spawn_01",
        "medusa_medus_spawn_02",
        "medusa_medus_spawn_03",
        "medusa_medus_spawn_04",
        "medusa_medus_spawn_05",
    ],
    npc_dota_hero_meepo: [
        "meepo_meepo_spawn_01",
        "meepo_meepo_spawn_02",
        "meepo_meepo_spawn_03",
        "meepo_meepo_spawn_04",
        "meepo_meepo_spawn_05",
    ],
    npc_dota_hero_mirana: [
        "mirana_mir_spawn_01",
        "mirana_mir_spawn_02",
        "mirana_mir_spawn_03",
        "mirana_mir_spawn_04",
        "mirana_mir_spawn_05",
        "mirana_mir_spawn_06",
        "mirana_mir_spawn_07",
        "mirana_mir_spawn_08",
        "mirana_mir_spawn_09",
        "mirana_mir_spawn_10",
        "mirana_mir_spawn_11",
        "mirana_mir_spawn_12",
    ],
    npc_dota_hero_monkey_king  : [
        "monkey_king_monkey_spawn_01",
        "monkey_king_monkey_spawn_02",
        "monkey_king_monkey_spawn_03",
        "monkey_king_monkey_spawn_04",
        "monkey_king_monkey_spawn_05",
        "monkey_king_monkey_spawn_06",
        "monkey_king_monkey_spawn_07",
        "monkey_king_monkey_spawn_08",
        "monkey_king_monkey_spawn_09",
        "monkey_king_monkey_spawn_10",
        "monkey_king_monkey_spawn_11",
        "monkey_king_monkey_spawn_12",
        "monkey_king_monkey_spawn_13",
        "monkey_king_monkey_spawn_14",
        "monkey_king_monkey_spawn_15",
        "monkey_king_monkey_spawn_16",
        "monkey_king_monkey_spawn_17",
        "monkey_king_monkey_spawn_18",
        "monkey_king_monkey_spawn_19",
        "monkey_king_monkey_spawn_21",
    ],

    npc_dota_hero_morphling: [
        "morphling_mrph_spawn_01",
        "morphling_mrph_spawn_04",
        "morphling_mrph_spawn_05",
        "morphling_mrph_spawn_06",
        "morphling_mrph_spawn_08",
    ],

    npc_dota_hero_naga_siren: [
        "naga_siren_naga_spawn_01",
        "naga_siren_naga_spawn_02",
        "naga_siren_naga_spawn_03",
        "naga_siren_naga_spawn_04",
        "naga_siren_naga_spawn_05",
        "naga_siren_naga_spawn_06",
    ],

    npc_dota_hero_necrolyte: [
        "necrolyte_necr_spawn_01",
        "necrolyte_necr_spawn_02",
        "necrolyte_necr_spawn_03",
        "necrolyte_necr_spawn_04",
    ],

    npc_dota_hero_nevermore: [
        "nevermore_nev_spawn_01",
        "nevermore_nev_spawn_02",
        "nevermore_nev_spawn_03",
        "nevermore_nev_spawn_04",
        "nevermore_nev_spawn_05",
        "nevermore_nev_spawn_06",
        "nevermore_nev_spawn_07",
        "nevermore_nev_spawn_08",
        "nevermore_nev_spawn_09",
        "nevermore_nev_spawn_10",
        "nevermore_nev_spawn_11",
    ],

    npc_dota_hero_night_stalker: [
        "night_stalker_nstalk_spawn_01",
        "night_stalker_nstalk_spawn_02",
        "night_stalker_nstalk_spawn_03",
        "night_stalker_nstalk_spawn_04",
        "night_stalker_nstalk_spawn_05",
    ],

    npc_dota_hero_nyx_assassin: [
        "nyx_assassin_nyx_spawn_01",
        "nyx_assassin_nyx_spawn_02",
        "nyx_assassin_nyx_spawn_03",
        "nyx_assassin_nyx_spawn_04",
        "nyx_assassin_nyx_spawn_05",
    ],

    npc_dota_hero_ogre_magi: [
        "ogre_magi_ogmag_spawn_01",
        "ogre_magi_ogmag_spawn_02",
        "ogre_magi_ogmag_spawn_03",
        "ogre_magi_ogmag_spawn_04",
        "ogre_magi_ogmag_spawn_05",
        "ogre_magi_ogmag_spawn_06",
    ],

    npc_dota_hero_omniknight: [
        "omniknight_omni_spawn_01",
        "omniknight_omni_spawn_02",
        "omniknight_omni_spawn_03",
        "omniknight_omni_spawn_04",
        "omniknight_omni_spawn_05",
    ],

    npc_dota_hero_oracle: [
        "oracle_orac_spawn_01",
        "oracle_orac_spawn_02",
        "oracle_orac_spawn_03",
    ],

    npc_dota_hero_obsidian_destroyer: [
        "outworld_destroyer_odest_spawn_02",
        "outworld_destroyer_odest_spawn_04",
        "outworld_destroyer_odest_spawn_05",
        "outworld_destroyer_odest_spawn_06",
    ],
    
    npc_dota_hero_pangolier: [
        "pangolin_pangolin_spawn_01",
        "pangolin_pangolin_spawn_02",
        "pangolin_pangolin_spawn_03",
        "pangolin_pangolin_spawn_04",
        "pangolin_pangolin_spawn_05",
        "pangolin_pangolin_spawn_06",
        "pangolin_pangolin_spawn_07",
        "pangolin_pangolin_spawn_08",
        "pangolin_pangolin_spawn_09",
        "pangolin_pangolin_spawn_10",
        "pangolin_pangolin_spawn_11",
        "pangolin_pangolin_spawn_12",
        "pangolin_pangolin_spawn_13",
        "pangolin_pangolin_spawn_14",
        "pangolin_pangolin_spawn_15",
        "pangolin_pangolin_spawn_16",
        "pangolin_pangolin_spawn_17",
        "pangolin_pangolin_spawn_18",
        "pangolin_pangolin_spawn_20",
        "pangolin_pangolin_spawn_21",
        "pangolin_pangolin_spawn_22",
    ],

    npc_dota_hero_phantom_assassin  : [
        "phantom_assassin_phass_spawn_01",
        "phantom_assassin_phass_spawn_02",
        "phantom_assassin_phass_spawn_03",
        "phantom_assassin_phass_spawn_04",
        "phantom_assassin_phass_spawn_05",
    ],

    npc_dota_hero_phantom_lancer  : [
        "phantom_lancer_plance_spawn_01",
        "phantom_lancer_plance_spawn_02",
        "phantom_lancer_plance_spawn_03",
        "phantom_lancer_plance_spawn_04",
        "phantom_lancer_plance_spawn_05",
    ],

    npc_dota_hero_phoenix  : [
        "phoenix_phoenix_bird_respawn",
    ],

    npc_dota_hero_puck  : [
        "puck_puck_spawn_01",
        "puck_puck_spawn_02",
        "puck_puck_spawn_04",
        "puck_puck_spawn_05",
        "puck_puck_spawn_06",
        "puck_puck_spawn_07",
        "puck_puck_spawn_08",
    ],

    npc_dota_hero_pudge  : [
        "pudge_pud_spawn_01",
        "pudge_pud_spawn_02",
        "pudge_pud_spawn_03",
        "pudge_pud_spawn_04",
        "pudge_pud_spawn_06",
        "pudge_pud_spawn_07",
        "pudge_pud_spawn_08",
        "pudge_pud_spawn_09",
        "pudge_pud_spawn_10",
        "pudge_pud_spawn_11",
    ],

    npc_dota_hero_pugna  : [
        "pugna_pugna_spawn_01",
        "pugna_pugna_spawn_02",
        "pugna_pugna_spawn_03",
        "pugna_pugna_spawn_04",
        "pugna_pugna_spawn_05",
    ],
    npc_dota_hero_queenofpain  : [
        "queenofpain_pain_spawn_01",
        "queenofpain_pain_spawn_02",
        "queenofpain_pain_spawn_03",
        "queenofpain_pain_spawn_04",
    ],

    npc_dota_hero_rattletrap : [
        "rattletrap_ratt_spawn_01",
        "rattletrap_ratt_spawn_02",
        "rattletrap_ratt_spawn_03",
        "rattletrap_ratt_spawn_04",
        "rattletrap_ratt_spawn_05",
    ],
    
    npc_dota_hero_razor : [
        "razor_raz_spawn_01",
        "razor_raz_spawn_02",
        "razor_raz_spawn_03",
        "razor_raz_spawn_04",
        "razor_raz_spawn_05",
        "razor_raz_spawn_06",
        "razor_raz_spawn_07",
        "razor_raz_spawn_08",
        "razor_raz_spawn_09",
    ],

    npc_dota_hero_riki : [
        "riki_riki_spawn_01",
        "riki_riki_spawn_02",
        "riki_riki_spawn_03",
        "riki_riki_spawn_04",
        "riki_riki_spawn_05",
        "riki_riki_spawn_06",
        "riki_riki_spawn_07",
        "riki_riki_spawn_08",
    ],

    npc_dota_hero_rubick : [
        "rubick_rubick_spawn_01",
        "rubick_rubick_spawn_02",
        "rubick_rubick_spawn_03",
        "rubick_rubick_spawn_04",
        "rubick_rubick_spawn_05",
        "rubick_rubick_spawn_06",
    ],


    npc_dota_hero_sand_king : [
        "sandking_skg_spawn_01",
        "sandking_skg_spawn_02",
        "sandking_skg_spawn_03",
        "sandking_skg_spawn_04",
        "sandking_skg_spawn_05",
        "sandking_skg_spawn_06",
        "sandking_skg_spawn_07",
    ],

    npc_dota_hero_shadow_demon : [
        "shadow_demon_shadow_demon_spawn_01",
        "shadow_demon_shadow_demon_spawn_02",
        "shadow_demon_shadow_demon_spawn_03",
        "shadow_demon_shadow_demon_spawn_04",
        "shadow_demon_shadow_demon_spawn_05",
    ],

    npc_dota_hero_shadow_shaman  : [
        "shadowshaman_shad_spawn_01",
        "shadowshaman_shad_spawn_02",
        "shadowshaman_shad_spawn_03",
        "shadowshaman_shad_spawn_04",
        "shadowshaman_shad_spawn_05",
    ],

    npc_dota_hero_shredder  : [
        "shredder_timb_spawn_01",
        "shredder_timb_spawn_02",
        "shredder_timb_spawn_03",
        "shredder_timb_spawn_04",
        "shredder_timb_spawn_05",
    ],

    npc_dota_hero_silencer  : [
        "silencer_silen_spawn_01",
        "silencer_silen_spawn_02",
        "silencer_silen_spawn_03",
        "silencer_silen_spawn_04",
    ],
    
    npc_dota_hero_skeleton_king  : [
        "skeleton_king_wraith_spawn_01",
        "skeleton_king_wraith_spawn_02",
        "skeleton_king_wraith_spawn_03",
        "skeleton_king_wraith_spawn_04",
    ],

    npc_dota_hero_skywrath_mage  : [
        "skywrath_mage_drag_spawn_01",
        "skywrath_mage_drag_spawn_02",
        "skywrath_mage_drag_spawn_03",
        "skywrath_mage_drag_spawn_04",
    ],

    npc_dota_hero_slardar  : [
        "slardar_slar_spawn_01",
        "slardar_slar_spawn_02",
        "slardar_slar_spawn_03",
        "slardar_slar_spawn_04",
        "slardar_slar_spawn_05",
    ],

    npc_dota_hero_slark: [
        "slark_slark_spawn_01",
        "slark_slark_spawn_02",
        "slark_slark_spawn_03",
        "slark_slark_spawn_04",
        "slark_slark_spawn_05",
    ],

    npc_dota_hero_sniper: [
        "sniper_snip_spawn_01",
        "sniper_snip_spawn_02",
        "sniper_snip_spawn_03",
        "sniper_snip_spawn_04",
        "sniper_snip_spawn_05",
        "sniper_snip_spawn_06",
    ],

    npc_dota_hero_spectre: [
        "spectre_spec_spawn_01",
        "spectre_spec_spawn_02",
        "spectre_spec_spawn_03",
        "spectre_spec_spawn_04",
    ],

    npc_dota_hero_spirit_breaker: [
        "spirit_breaker_spir_spawn_01",
        "spirit_breaker_spir_spawn_02",
        "spirit_breaker_spir_spawn_03",
        "spirit_breaker_spir_spawn_04",
    ],

    npc_dota_hero_storm_spirit: [
        "stormspirit_ss_spawn_01",
        "stormspirit_ss_spawn_02",
        "stormspirit_ss_spawn_03",
        "stormspirit_ss_spawn_04",
        "stormspirit_ss_spawn_05",
        "stormspirit_ss_spawn_06",
        "stormspirit_ss_spawn_07",
        "stormspirit_ss_spawn_08",
        "stormspirit_ss_spawn_09",
    ],

    npc_dota_hero_sven: [
        "sven_sven_spawn_01",
        "sven_sven_spawn_02",
        "sven_sven_spawn_03",
        "sven_sven_spawn_04",
        "sven_sven_spawn_05",
        "sven_sven_spawn_06",
        "sven_sven_spawn_07",
    ],

    npc_dota_hero_techies: [
        "techies_tech_spawn_01",
        "techies_tech_spawn_02",
        "techies_tech_spawn_03",
        "techies_tech_spawn_04",
        "techies_tech_spawn_05",
        "techies_tech_spawn_06",
    ],

    npc_dota_hero_templar_assassin: [
        "templar_assassin_temp_spawn_01",
        "templar_assassin_temp_spawn_02",
        "templar_assassin_temp_spawn_03",
        "templar_assassin_temp_spawn_04",
    ],

    npc_dota_hero_terrorblade: [
        "terrorblade_terr_spawn_01",
        "terrorblade_terr_spawn_02",
        "terrorblade_terr_spawn_03",
        "terrorblade_terr_spawn_04",
        "terrorblade_terr_spawn_05",
    ],
    
    npc_dota_hero_tidehunter: [
        "tidehunter_tide_spawn_01",
        "tidehunter_tide_spawn_02",
        "tidehunter_tide_spawn_03",
        "tidehunter_tide_spawn_04",
        "tidehunter_tide_spawn_05",
        "tidehunter_tide_spawn_06",
        "tidehunter_tide_spawn_07",
        "tidehunter_tide_spawn_08",
        "tidehunter_tide_spawn_09",
    ],
    npc_dota_hero_tinker  : [
        "tinker_tink_spawn_01",
        "tinker_tink_spawn_02",
        "tinker_tink_spawn_03",
        "tinker_tink_spawn_04",
        "tinker_tink_spawn_05",
        "tinker_tink_spawn_06",
        "tinker_tink_spawn_07",
        "tinker_tink_spawn_08",
        "tinker_tink_spawn_09",
    ],
    npc_dota_hero_tiny  : [
        "tiny_tiny_spawn_01",
        "tiny_tiny_spawn_02",
        "tiny_tiny_spawn_03",
        "tiny_tiny_spawn_04",
        "tiny_tiny_spawn_05",
        "tiny_tiny_spawn_06",
        "tiny_tiny_spawn_07",
        "tiny_tiny_spawn_08",
        "tiny_tiny_spawn_09",
    ],

    npc_dota_hero_treant  : [
        "treant_treant_spawn_01",
        "treant_treant_spawn_02",
        "treant_treant_spawn_03",
        "treant_treant_spawn_04",
        "treant_treant_spawn_05",
        "treant_treant_spawn_06",
    ],

    npc_dota_hero_troll_warlord: [
        "troll_warlord_troll_spawn_01",
        "troll_warlord_troll_spawn_02",
        "troll_warlord_troll_spawn_03",
        "troll_warlord_troll_spawn_04",
        "troll_warlord_troll_spawn_05",
        "troll_warlord_troll_spawn_06",
    ],

    npc_dota_hero_tusk: [
        "tusk_tusk_spawn_01",
        "tusk_tusk_spawn_02",
        "tusk_tusk_spawn_03",
        "tusk_tusk_spawn_04",
        "tusk_tusk_spawn_05",
        "tusk_tusk_spawn_06",
        "tusk_tusk_spawn_07",
        "tusk_tusk_spawn_08",
    ],

    npc_dota_hero_undying: [
        "undying_undying_spawn_01",
        "undying_undying_spawn_02",
        "undying_undying_spawn_03",
        "undying_undying_spawn_04",
        "undying_undying_spawn_05",
    ],

    npc_dota_hero_ursa  : [
        "ursa_ursa_spawn_01",
        "ursa_ursa_spawn_02",
        "ursa_ursa_spawn_03",
        "ursa_ursa_spawn_04",
        "ursa_ursa_spawn_05",
        "ursa_ursa_spawn_06",
        "ursa_ursa_spawn_07",
        "ursa_ursa_spawn_08",
        "ursa_ursa_spawn_09",
        "ursa_ursa_spawn_10",
        "ursa_ursa_spawn_11",
    ],


    npc_dota_hero_vengefulspirit: [
        "vengefulspirit_vng_spawn_01",
        "vengefulspirit_vng_spawn_02",
        "vengefulspirit_vng_spawn_03",
        "vengefulspirit_vng_spawn_04",
        "vengefulspirit_vng_spawn_05",
        "vengefulspirit_vng_spawn_06",
        "vengefulspirit_vng_spawn_07",
    ],

    npc_dota_hero_venomancer: [
        "venomancer_venm_spawn_01",
        "venomancer_venm_spawn_02",
        "venomancer_venm_spawn_03",
        "venomancer_venm_spawn_04",
    ],

    npc_dota_hero_viper: [
        "viper_vipe_spawn_01",
        "viper_vipe_spawn_02",
        "viper_vipe_spawn_03",
        "viper_vipe_spawn_04",
        "viper_vipe_spawn_05",
    ],

    npc_dota_hero_visage: [
        "visage_visa_spawn_01",
        "visage_visa_spawn_02",
        "visage_visa_spawn_03",
        "visage_visa_spawn_04",
        "visage_visa_spawn_05",
        "visage_visa_spawn_06",
        "visage_visa_spawn_07",
    ],
    npc_dota_hero_warlock: [
        "warlock_warl_spawn_01",
        "warlock_warl_spawn_02",
        "warlock_warl_spawn_03",
        "warlock_warl_spawn_04",
    ],

    npc_dota_hero_weaver: [
        "weaver_weav_spawn_01",
        "weaver_weav_spawn_02",
        "weaver_weav_spawn_03",
        "weaver_weav_spawn_04",
        "weaver_weav_spawn_05",
    ],

    npc_dota_hero_windrunner: [
        "windrunner_wind_spawn_01",
        "windrunner_wind_spawn_02",
        "windrunner_wind_spawn_03",
        "windrunner_wind_spawn_04",
        "windrunner_wind_spawn_05",
        "windrunner_wind_spawn_06",
        "windrunner_wind_spawn_07",
        "windrunner_wind_spawn_08",
    ],
    npc_dota_hero_wisp: [
        "wisp_spawn_respawn",
    ],
    npc_dota_hero_winter_wyvern: [
        "winter_wyvern_winwyv_spawn_01",
        "winter_wyvern_winwyv_spawn_02",
        "winter_wyvern_winwyv_spawn_03",
        "winter_wyvern_winwyv_spawn_04",
        "winter_wyvern_winwyv_spawn_05",
        "winter_wyvern_winwyv_spawn_06",
        "winter_wyvern_winwyv_spawn_07",
    ],
    npc_dota_hero_witch_doctor: [
        "witchdoctor_wdoc_spawn_01",
        "witchdoctor_wdoc_spawn_02",
        "witchdoctor_wdoc_spawn_03",
        "witchdoctor_wdoc_spawn_04",
    ],
    npc_dota_hero_zuus: [
        "zuus_zuus_spawn_01",
        "zuus_zuus_spawn_02",
        "zuus_zuus_spawn_03",
        "zuus_zuus_spawn_04",
        "zuus_zuus_spawn_05",
        "zuus_zuus_spawn_06",
        "zuus_zuus_spawn_07",
        "zuus_zuus_spawn_08",
    ],

}

//怪物物品声音
var EXTRA_CREATURE_SOUND_EVENTS={
  npc_dota_satyr_trickster:"n_creep_SatyrTrickster.Cast",
  npc_dota_big_thunder_lizard:"n_creep_Thunderlizard_Big.Roar",
  npc_dota_spider_range:"Hero_Viper.Nethertoxin.Cast",
  npc_dota_dark_troll_warlord:"n_creep_TrollWarlord.Ensnare",
  npc_dota_ghost:"n_creep_ghost.Death",
  npc_dota_centaur_khan:"n_creep_Centaur.Stomp",
  npc_dota_prowler_shaman:"n_creep_Spawnlord.Stomp",
  npc_dota_granite_golem:"n_creep_golemRock.Death",
  npc_dota_rock_golem:"n_creep_golemRock.Death",
  npc_dota_gnoll_assassin:"n_creep_gnoll.Death",
  npc_dota_kobold:"n_creep_kobolds.Death",
  npc_dota_timber_spider:"Hero_Shredder.WhirlingDeath.Cast",
  npc_dota_explode_spider:"Hero_Broodmother.SpawnSpiderlings",
}