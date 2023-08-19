LinkLuaModifier( "modifier_loser_curse", "heroes/modifier_loser_curse", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_win_6sec", "heroes/modifier_duel_win", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_win_15sec", "heroes/modifier_duel_win", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_teleporting", "heroes/modifier_duel_teleporting", LUA_MODIFIER_MOTION_NONE )

if PvpModule == nil then PvpModule = class({}) end

PvpModule.winnerSoundMap = 
{
	npc_dota_hero_abaddon=                 "abaddon_abad_win_03",
	npc_dota_hero_abyssal_underlord=       "abyssal_underlord_abys_win_05",
	npc_dota_hero_alchemist=               "alchemist_alch_win_03",
	npc_dota_hero_ancient_apparition=      "ancient_apparition_appa_win_03",
	npc_dota_hero_antimage=                "antimage_anti_win_03",
	npc_dota_hero_arc_warden=              "arc_warden_arcwar_win_05",
	npc_dota_hero_axe=                     "axe_axe_win_02",
	npc_dota_hero_bane=                    "bane_bane_win_02",
	npc_dota_hero_batrider=                "batrider_bat_win_04",
	npc_dota_hero_beastmaster=             "beastmaster_beas_win_02",
	npc_dota_hero_bloodseeker=            "bloodseeker_blod_win_03",
	npc_dota_hero_bounty_hunter=           "bounty_hunter_bount_win_05",
	npc_dota_hero_brewmaster=              "brewmaster_brew_win_03",
	npc_dota_hero_bristleback=             "bristleback_bristle_win_04",
	npc_dota_hero_broodmother=             "broodmother_broo_win_04",
	npc_dota_hero_centaur=                 "centaur_cent_win_04",
	npc_dota_hero_chaos_knight=            "chaos_knight_chaknight_win_04",
	npc_dota_hero_chen=                    "chen_chen_win_02",
	npc_dota_hero_clinkz=                  "clinkz_clinkz_win_03",
	npc_dota_hero_crystal_maiden=          "crystalmaiden_cm_win_04",
	npc_dota_hero_dark_seer=               "dark_seer_dkseer_win_05",
	npc_dota_hero_dark_willow=             "dark_willow_sylph_win_05",
	npc_dota_hero_dazzle=                  "dazzle_dazz_win_03",
	npc_dota_hero_death_prophet=           "death_prophet_dpro_win_03",
	npc_dota_hero_disruptor=               "disruptor_dis_win_05",
	npc_dota_hero_doom_bringer=            "doom_bringer_doom_win_03",
	npc_dota_hero_dragon_knight=           "dragon_knight_drag_win_03",
	npc_dota_hero_drow_ranger=             "drowranger_dro_win_05",
	npc_dota_hero_earth_spirit=            "earth_spirit_earthspi_win_03",
	npc_dota_hero_earthshaker=             "earthshaker_erth_win_03",
	npc_dota_hero_elder_titan=             "elder_titan_elder_win_03",
	npc_dota_hero_ember_spirit=            "ember_spirit_embr_win_03",
	npc_dota_hero_enchantress=             "enchantress_ench_rare_02",
	npc_dota_hero_enigma=                  "enigma_enig_rare_01",
	npc_dota_hero_faceless_void=           "faceless_void_face_win_03",
	npc_dota_hero_furion=                  "furion_furi_view_victory_03",
	npc_dota_hero_grimstroke=               "grimstroke_grimstroke_win_04",
	npc_dota_hero_gyrocopter=              "gyrocopter_gyro_kill_04",
	npc_dota_hero_huskar=                  "huskar_husk_win_03",
	npc_dota_hero_invoker=                 "invoker_invo_win_01",
	npc_dota_hero_jakiro=                  "jakiro_jak_win_02",
	npc_dota_hero_juggernaut=              "juggernaut_jug_rare_06",
	npc_dota_hero_keeper_of_the_light=     "keeper_of_the_light_keep_win_02",
	npc_dota_hero_kunkka=                  "kunkka_kunk_win_03",
	npc_dota_hero_legion_commander=        "legion_commander_legcom_win_03",
	npc_dota_hero_leshrac=                 "leshrac_lesh_rare_01",
	npc_dota_hero_lich=                    "lich_lich_rare_01",
	npc_dota_hero_life_stealer=            "life_stealer_lifest_win_03",
	npc_dota_hero_lina=                    "lina_lina_win_03",
	npc_dota_hero_lion=                    "lion_lion_kill_06",
	npc_dota_hero_lone_druid=              "lone_druid_lone_druid_win_03",
	npc_dota_hero_luna=                    "luna_luna_win_03",
	npc_dota_hero_lycan=                   "lycan_lycan_respawn_06",
	npc_dota_hero_magnataur=               "magnataur_magn_win_01",
	npc_dota_hero_mars=                    "mars_mars_win_02 ",
	npc_dota_hero_medusa=                  "medusa_medus_win_05",
	npc_dota_hero_meepo=                   "meepo_meepo_win_04",
	npc_dota_hero_mirana=                  "mirana_mir_rare_09",
	npc_dota_hero_monkey_king=             "monkey_king_monkey_win_01",
	npc_dota_hero_morphling=               "morphling_mrph_win_03",
	npc_dota_hero_naga_siren=              "naga_siren_naga_win_03",
	npc_dota_hero_necrolyte=               "necrolyte_necr_respawn_13",
	npc_dota_hero_nevermore=               "nevermore_nev_win_03",
	npc_dota_hero_night_stalker=           "night_stalker_nstalk_win_01",
	npc_dota_hero_nyx_assassin=            "nyx_assassin_nyx_win_04",
	npc_dota_hero_obsidian_destroyer=      "outworld_destroyer_odest_win_04",
	npc_dota_hero_ogre_magi=               "ogre_magi_ogmag_win_03",
	npc_dota_hero_omniknight=              "omniknight_omni_win_03",
	npc_dota_hero_oracle=                  "oracle_orac_win_01",
	npc_dota_hero_pangolier=               "pangolin_pangolin_win_02",
	npc_dota_hero_phantom_assassin=        "phantom_assassin_phass_win_02",
	npc_dota_hero_phantom_lancer=          "phantom_lancer_plance_kill_10",
	npc_dota_hero_phoenix=                 "phoenix_phoenix_bird_victory",
	npc_dota_hero_puck=                    "puck_puck_win_04",
	npc_dota_hero_pudge=                   "pudge_pud_rare_05",
	npc_dota_hero_pugna=                   "pugna_pugna_win_03",
	npc_dota_hero_queenofpain=             "queenofpain_pain_win_03",
	npc_dota_hero_rattletrap=              "rattletrap_ratt_win_04",
	npc_dota_hero_razor=                   "razor_raz_level_04",
	npc_dota_hero_riki=                    "riki_riki_level_05",
	npc_dota_hero_rubick=                  "rubick_rubick_win_03",
	npc_dota_hero_sand_king=               "sandking_skg_level_02",
	npc_dota_hero_shadow_demon=            "shadow_demon_shadow_demon_win_03",
	npc_dota_hero_shadow_shaman=           "shadowshaman_shad_win_03",
	npc_dota_hero_snapfire=                "snapfire_snapfire_win_01",
	npc_dota_hero_shredder=                "shredder_timb_levelup_07",
	npc_dota_hero_silencer=                "silencer_silen_win_03",
	npc_dota_hero_skeleton_king=           "skeleton_king_wraith_level_07",
	npc_dota_hero_skywrath_mage=           "skywrath_mage_drag_levelup_02",
	npc_dota_hero_slardar=                 "slardar_slar_win_05",
	npc_dota_hero_slark=                   "slark_slark_win_03",
	npc_dota_hero_sniper=                  "sniper_snip_rare_01",
	npc_dota_hero_spectre=                 "spectre_spec_win_01",
	npc_dota_hero_spirit_breaker=          "spirit_breaker_spir_win_03",
	npc_dota_hero_storm_spirit=            "stormspirit_ss_win_03",
	npc_dota_hero_sven=                    "sven_sven_win_05",
	npc_dota_hero_techies=                 "techies_tech_move_52",
	npc_dota_hero_templar_assassin=        "templar_assassin_temp_win_03",
	npc_dota_hero_terrorblade=             "terrorblade_terr_shards_win_03",
	npc_dota_hero_tidehunter=              "tidehunter_tide_rare_01",
	npc_dota_hero_tinker=                  "tinker_tink_win_03",
	npc_dota_hero_tiny=                    "tiny_tiny_win_02",
	npc_dota_hero_treant=                  "treant_treant_win_04",
	npc_dota_hero_troll_warlord=           "troll_warlord_troll_win_03",
	npc_dota_hero_tusk=                    "tusk_tusk_win_01",
	npc_dota_hero_undying=                 "undying_undying_win_05",
	npc_dota_hero_ursa=                    "ursa_ursa_win_02",
	npc_dota_hero_vengefulspirit=          "vengefulspirit_vng_win_02",
	npc_dota_hero_venomancer=              "venomancer_venm_win_03",
	npc_dota_hero_viper=                   "viper_vipe_win_02",
	npc_dota_hero_visage=                  "visage_visa_win_03",
	npc_dota_hero_void_spirit=             "void_spirit_voidspir_win_01",
	npc_dota_hero_warlock=                 "warlock_warl_win_04",
	npc_dota_hero_weaver=                  "weaver_weav_win_03",
	npc_dota_hero_windrunner=              "windrunner_wind_win_04",
	npc_dota_hero_winter_wyvern=           "winter_wyvern_winwyv_win_02",
	npc_dota_hero_wisp=                    "wisp_win",
	npc_dota_hero_witch_doctor=            "witchdoctor_wdoc_win_04",
	npc_dota_hero_zuus=                    "zuus_zuus_rare_03",
	npc_dota_hero_hoodwink=                "hoodwink_hoodwink_win_03",
	npc_dota_hero_dawnbreaker=             "dawnbreaker_valora_win_02",
	npc_dota_hero_marci=                   "marci_marci_laugh",
	npc_dota_hero_primal_beast=            "primal_beast_primal_happy_01",
}

function PvpModule:Init()
  	PvpModule.bEnd=true
  	PvpModule.bLeaveHand = true
  	PvpModule.pvpPairs={}
  	PvpModule.singlePlayerPvpPairs={}
  	PvpModule.nInterval = 1
  	PvpModule.currentPair = {}
  	PvpModule.currentSinglePair = {}
  	PvpModule.nLastPvpRound = 1
  	if IsInToolsMode() then
		PvpModule.nLastPvpRound = 0
  	end
  	PvpModule.betValueSum ={}
  	PvpModule.betHistory = {}
  	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
	  	PvpModule.betValueSum[nPlayerID] = 0
  	end
  	PvpModule.nBetBonus = 150
  	PvpModule.allPairLog ={}
  	CustomGameEventManager:RegisterListener("ConfirmBet",function(_, keys)
		PvpModule:ConfirmBet(keys)
  	end)
  	ListenToGameEvent("entity_killed", Dynamic_Wrap(PvpModule, "OnEntityKilled"), self)
end

function PvpModule:RoundPrepare(nRoundNumber)
	local nAliveTeamNumber = 0 
	for _,bAlive in pairs(GameMode.vAliveTeam) do
	  	if bAlive then
		 	nAliveTeamNumber = nAliveTeamNumber+1
	  	end
	end
	local nBaseBonus = 152
	local nBonusRatio = 1
	if GetMapName()=="2x6" then
	   	nBaseBonus = 152 + 142*2
	   	nBonusRatio = 1.4
	end
	PvpModule.nBetBonus = (nBaseBonus + 142 * nAliveTeamNumber*nBonusRatio) * math.pow(1.024, (nRoundNumber-1))
	PvpModule.betMap = {}
	PvpModule.nLastPvpRound = nRoundNumber
	PvpModule:CalculatePvpInterval()
	if GetMapName()=="5v5" and nRoundNumber%6~=0 then
		PvpModule:PrepareSinglePvp() 
	else
	   	PvpModule:PrepareTeamPvp()
	end
end

function PvpModule:PrepareTeamPvp()
	if #PvpModule.pvpPairs == 0 then
		PvpModule:PairPvp()
		table.insert(PvpModule.allPairLog,"Pair Pvp")
	end
	if #PvpModule.pvpPairs > 0 then
		local pair = PvpModule:ChooseOnePair()
		if pair and pair.nFirstTeamId~=nil and pair.nSecondeTeamId~=nil then
			PvpModule.bEnd=false
			PvpModule.bLeaveHand = false
			PvpModule.betMap[pair.nFirstTeamId]={}
			PvpModule.betMap[pair.nSecondeTeamId]={} 		
			PvpModule.currentPair = {}
			table.insert(PvpModule.currentPair, pair.nFirstTeamId)
			table.insert(PvpModule.currentPair, pair.nSecondeTeamId)
			if PvpModule.lastPair then
			   PvpModule.secondLastPair = PvpModule.lastPair
			end
			PvpModule.lastPair = {}
			PvpModule.lastPair.nFirstTeamId = pair.nFirstTeamId
			PvpModule.lastPair.nSecondeTeamId = pair.nSecondeTeamId
			table.insert(PvpModule.allPairLog,PvpModule.currentPair)
			local nRandomIndex = RandomInt(1,2)
			if nRandomIndex==1 then
			   	PvpModule.nHomeTeamID = pair.nFirstTeamId
			end
			if nRandomIndex==2 then
			   	PvpModule.nHomeTeamID = pair.nSecondeTeamId
			end
			PvpModule.vHomeCenter = GameMode.vTeamLocationMap[PvpModule.nHomeTeamID]
			Summon:KillSummonedCreatureAsyn(PvpModule.vHomeCenter)

			local dataList={}
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			  	if PlayerResource:GetTeam( nPlayerID ) == pair.nFirstTeamId or PlayerResource:GetTeam( nPlayerID )==pair.nSecondeTeamId then
				 	local data = {}
				 	data.playerID = nPlayerID
				 	data.teamID = PlayerResource:GetTeam( nPlayerID )
				 	table.insert(dataList, data)
			  	end
			end
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			  	if PlayerResource:IsValidPlayer(nPlayerID) and ( IsInToolsMode() or PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED)  then                      
					if GameMode.vAliveTeam[PlayerResource:GetTeam( nPlayerID )] then
						local hPlayer = PlayerResource:GetPlayer(nPlayerID)
						local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
						if hPlayer and hHero then
						  	hHero.sBetUISecret = CreateSecretKey()
						  	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBet",{players=dataList,firstTeamId=pair.nFirstTeamId,secondTeamId=pair.nSecondeTeamId,bet_ui_secret=hHero.sBetUISecret} )   
						end
					end
					if true then
						local hPlayer = PlayerResource:GetPlayer(nPlayerID)
						local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
						if hPlayer and hHero and hHero:GetTeamNumber() == DOTA_TEAM_CUSTOM_7 then
							hHero.sBetUISecret = CreateSecretKey()
						  	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBet",{players=dataList,firstTeamId=pair.nFirstTeamId,secondTeamId=pair.nSecondeTeamId,bet_ui_secret=hHero.sBetUISecret} )
						end
					end
				end
				if PlayerResource:IsValidPlayer(nPlayerID) then
					if GameMode.vAliveTeam[PlayerResource:GetTeam( nPlayerID )] then
					   	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID) 
					   	if hHero and hHero.bTakenOverByBot then
						   	if PlayerResource:GetTeam( nPlayerID )~=pair.nFirstTeamId and PlayerResource:GetTeam( nPlayerID )~=pair.nSecondeTeamId then
							 	PvpModule:BotAutoBet(nPlayerID)
						   	end
					   	end
					end
				end 
			end
		end
	end
end

function PvpModule:PrepareSinglePvp()
	if #PvpModule.singlePlayerPvpPairs == 0 then
		PvpModule:PairSinglePlayer()
	end
	if #PvpModule.singlePlayerPvpPairs > 0 then
		local pair = PvpModule:ChooseOneSinglePair()
		if pair and pair.nFirstPlayerId~=nil and pair.nSecondePlayerId~=nil then
			PvpModule.bEnd=false
			PvpModule.bLeaveHand = true
			PvpModule.betMap[PlayerResource:GetTeam(pair.nFirstPlayerId)]={}
			PvpModule.betMap[PlayerResource:GetTeam(pair.nSecondePlayerId)]={} 
			PvpModule.currentSinglePair = {}
			table.insert(PvpModule.currentSinglePair, pair.nFirstPlayerId)
			table.insert(PvpModule.currentSinglePair, pair.nSecondePlayerId)
			if PvpModule.lastSinglePair then
			   PvpModule.secondLastSinglePair = PvpModule.lastSinglePair
			end
			PvpModule.lastSinglePair = {}
			PvpModule.lastSinglePair.nFirstPlayerId = pair.nFirstPlayerId
			PvpModule.lastSinglePair.nSecondePlayerId = pair.nSecondePlayerId
			local wayPoint = Entities:FindByName(nil, "center_single_pvp")
			Summon:KillSummonedCreatureAsyn(wayPoint:GetOrigin())
			local dataList={}
			local firstData = {}
			firstData.playerID = pair.nFirstPlayerId
			firstData.teamID = PlayerResource:GetTeam( pair.nFirstPlayerId )
			table.insert(dataList, firstData)
			local secondData = {}
			secondData.playerID = pair.nSecondePlayerId
			secondData.teamID = PlayerResource:GetTeam( pair.nSecondePlayerId )
			table.insert(dataList, secondData)
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			  	if PlayerResource:IsValidPlayer(nPlayerID) and ( IsInToolsMode() or PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED)  then                      
					if GameMode.vAliveTeam[PlayerResource:GetTeam( nPlayerID )] then
						local hPlayer = PlayerResource:GetPlayer(nPlayerID)
						local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
						if hPlayer and hHero then
					  		hHero.sBetUISecret = CreateSecretKey()
					  		CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBet",{players=dataList,firstTeamId=PlayerResource:GetTeam(pair.nFirstPlayerId) ,secondTeamId=PlayerResource:GetTeam(pair.nSecondePlayerId),bet_ui_secret=hHero.sBetUISecret} )   
						end
					end
					if true then
						local hPlayer = PlayerResource:GetPlayer(nPlayerID)
						local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
						if hPlayer and hHero and hHero:GetTeamNumber() == DOTA_TEAM_CUSTOM_7 then
					  		hHero.sBetUISecret = CreateSecretKey()
					  		CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBet",{players=dataList,firstTeamId=PlayerResource:GetTeam(pair.nFirstPlayerId) ,secondTeamId=PlayerResource:GetTeam(pair.nSecondePlayerId),bet_ui_secret=hHero.sBetUISecret} )   
						end
					end
			 	end
			end
		end
	end
end

function PvpModule:CalculatePvpInterval()
  	if GetMapName()=="5v5" then
	 	PvpModule.nInterval = 1
	 	return 
  	end
  	local pvpValideTeamMap = {}
  	local nValideTeam = 0
  	local pvpValideTeamList ={}
  	for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
		if bAlive then
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:IsValidPlayer(nPlayerID) and ( IsInToolsMode() or PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED)  then
				  	if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
					 	if pvpValideTeamMap[nTeamNumber] ==nil then
							nValideTeam = nValideTeam +1
							pvpValideTeamMap[nTeamNumber] = true
							table.insert(pvpValideTeamList, nTeamNumber)
					 	end
				  	end
			  	end
			end
		 end
	end
  	if nValideTeam == 3 or nValideTeam == 4 or nValideTeam == 5 then
	  	PvpModule.nInterval = 2
  	end
  	if nValideTeam==2 or nValideTeam==1 then
	  	PvpModule.nInterval = 3
  	end
end




















































function PvpModule:PairPvp()
	PvpModule.pvpPairs={}
	local pvpValideTeamMap = {}
	local nValideTeam = 0
	local pvpValideTeamList ={}

	for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
	  	if bAlive then
		  	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:IsValidPlayer(nPlayerID) and ( IsInToolsMode() or PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED)  then
					if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
				   		if pvpValideTeamMap[nTeamNumber] ==nil then
					  		nValideTeam = nValideTeam +1
					  		pvpValideTeamMap[nTeamNumber] = true
					  		table.insert(pvpValideTeamList, nTeamNumber)
				   		end
					end
				end
		  	end
	   	end
	end

	if nValideTeam==1 then
		return 
	end

	for _,nTeamNumber in ipairs(pvpValideTeamList) do
	  	for _,nEnemyTeamNumber in ipairs(pvpValideTeamList) do
		 	if nEnemyTeamNumber<nTeamNumber then
		   		local pair = {}
		   		pair.nFirstTeamId = nTeamNumber
		   		pair.nSecondeTeamId = nEnemyTeamNumber
		   		pair.nTeamJoinTimes = 0
		   		table.insert(PvpModule.pvpPairs,pair)
		 	end 
	  	end
	end
end

function PvpModule:ChooseOnePair()
	PvpModule.pvpPairs=table.shuffle(PvpModule.pvpPairs)
	for _,pair in ipairs(PvpModule.pvpPairs) do
			pair.nScore =pair.nTeamJoinTimes
			if PvpModule.lastPair then
		  		if pair.nFirstTeamId == PvpModule.lastPair.nFirstTeamId or
			 	pair.nFirstTeamId == PvpModule.lastPair.nSecondeTeamId then
			 	pair.nScore = pair.nScore + 1
		  	end
		  	if pair.nSecondeTeamId == PvpModule.lastPair.nFirstTeamId or
			 	pair.nSecondeTeamId == PvpModule.lastPair.nSecondeTeamId then
			 	pair.nScore = pair.nScore + 1
		  	end
		end
		if PvpModule.secondLastPair then
		  	if pair.nFirstTeamId == PvpModule.secondLastPair.nFirstTeamId or
			 	pair.nFirstTeamId == PvpModule.secondLastPair.nSecondeTeamId then
			 	pair.nScore = pair.nScore + 0.1
		  	end
		  	if pair.nSecondeTeamId == PvpModule.secondLastPair.nFirstTeamId or
			 	pair.nSecondeTeamId == PvpModule.secondLastPair.nSecondeTeamId then
			 	pair.nScore = pair.nScore + 0.1
		  	end
		end
	end

	table.sort(PvpModule.pvpPairs,function(a, b) return a.nScore < b.nScore end)
	local result = PvpModule.pvpPairs[1]
	table.remove(PvpModule.pvpPairs, 1)

	for i=1,#PvpModule.pvpPairs do
	   	if PvpModule.pvpPairs[i] then
		  	if PvpModule.pvpPairs[i].nFirstTeamId==result.nFirstTeamId or PvpModule.pvpPairs[i].nSecondeTeamId==result.nFirstTeamId then
			 	PvpModule.pvpPairs[i].nTeamJoinTimes = PvpModule.pvpPairs[i].nTeamJoinTimes + 1              
		  	end
		  	if PvpModule.pvpPairs[i].nFirstTeamId==result.nSecondeTeamId or PvpModule.pvpPairs[i].nSecondeTeamId==result.nSecondeTeamId then
			 	PvpModule.pvpPairs[i].nTeamJoinTimes = PvpModule.pvpPairs[i].nTeamJoinTimes + 1            
		  	end
	   	end
	end

	return result
end

function CleanTempData(tempTable,nId)
	for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
		if bAlive and tempTable[nTeamNumber] then
		  table.remove_item(tempTable[nTeamNumber],nId)
		end
	end
end

function PvpModule:ConfirmBet(keys)
	if not keys.PlayerID then return end
	local nPlayerId = keys.PlayerID;
	local nMaxGold=math.floor(PlayerResource:GetGold(nPlayerId)/2)

	if GetMapName()=="5v5" then
	   return
	end

	if type(keys.value) ~= "number" then
		return
	end

	if PvpModule.bLeaveHand then
		return
	end

	if not GameMode.vAliveTeam[PlayerResource:GetTeam(nPlayerId)] then
		return
	end
	
	local bAlreadyBet =false

	for _,dataList in pairs(PvpModule.betMap) do
		for _,data in ipairs(dataList) do
			if data.nPlayerId == nPlayerId then
				bAlreadyBet=true
			end
		end
	end

	if bAlreadyBet then
		return
	end

	local nValue = math.floor(keys.value)

	if nValue<=0 then
	   	return
	end
	
	if nValue>nMaxGold then
	   	nValue = nMaxGold
	end
	
	if PvpModule.betMap[keys.wish_team_id] == nil then
	   	return 
	end

	if keys.wish_team_id == PlayerResource:GetTeam(nPlayerId) then
	   	return
	end

	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
	if hHero==nil or hHero:IsNull() then
	   	return
	end

	local data = {}
	data.nPlayerId = nPlayerId
	data.nValue = nValue
	table.insert(PvpModule.betMap[keys.wish_team_id], data)
	PvpModule.nBetBonus = PvpModule.nBetBonus + nValue;

	if PvpModule.betValueSum[nPlayerId] then
	   	PvpModule.betValueSum[nPlayerId] = PvpModule.betValueSum[nPlayerId] + nValue
	end

	hHero:SpendGold(nValue, DOTA_ModifyGold_Unspecified)
	hHero:EmitSound("DOTA_Item.Hand_Of_Midas")
	local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_midas_coinshower.vpcf", PATTACH_ABSORIGIN, hHero)
    ParticleManager:ReleaseParticleIndex(particle)
end


function PvpModule:SummarizeBetInfo()
   	PvpModule.bLeaveHand = true
   	if PvpModule.bEnd then
	 	return
   	end
   	local nPvpFreeBet = 0
   	for nTeamID,list in pairs(PvpModule.betMap) do
	   	local nSumBet = 0  

	   	for _,data in ipairs(list) do
		  	nSumBet= nSumBet+ data.nValue
	   	end
	   
	   	if string.find(GetMapName(),"1x8") then
		 	local data={}
		 	data.type = "bet_summary_solo"
		 	data.playerId = PlayerResource:GetNthPlayerIDOnTeam(nTeamID, 1)
		 	data.gold_value = nSumBet
		 	Barrage:FireBullet(data)
	   	end

	   	if GetMapName() =="2x6" then
		 	local data={}
		 	data.type = "bet_summary"
		 	data.teamId = nTeamID
		 	data.gold_value = nSumBet
		 	Barrage:FireBullet(data)
	   	end

	   	for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamID]) do
		   	local data = {}
		   	local flPvpBetRatio = 0.05
		   	if GetMapName()=="2x6" then
			  	flPvpBetRatio = 0.02
		   	end
		   	if GetMapName()=="5v5" then
			  	flPvpBetRatio = 0.08
		   	end
		   	data.nValue = math.floor(PvpModule.nBetBonus*flPvpBetRatio)
		   	data.nPlayerId = nPlayerID
		   	data.sType = "pvp_free"
		   	nSumBet = nSumBet + data.nValue
		   	nPvpFreeBet = nPvpFreeBet + data.nValue
		   	table.insert(list, data)
	   	end

	   	for _,data in ipairs(list) do
		  	local flRatio= data.nValue/nSumBet
		  	data.flRatio = flRatio
	   	end  
   end
   PvpModule.nBetBonus = PvpModule.nBetBonus + nPvpFreeBet
end

function PvpModule:OnEntityKilled(keys)
    xpcall(function()
		local hKilledUnit = EntIndexToHScript(keys.entindex_killed)
		if hKilledUnit == nil then
			return
		end
		if Util:IsReincarnationWork(hKilledUnit) then
		   return
		end
		local hTp = hKilledUnit:FindItemInInventory('item_tpscroll')
		if hTp then
		   hTp:RemoveSelf()
		end
		if GameMode.currentRound and GameMode.currentRound.nTimeLimit ==nil then
		   	return
		end
		if hKilledUnit:IsRealHero() and not hKilledUnit:IsTempestDouble() then
		  	local nKilledPlayerID = hKilledUnit:GetPlayerOwnerID();
		  	local nKilledTeamID = PlayerResource:GetTeam(nKilledPlayerID);
		  	for i,nPlayerID in ipairs(PvpModule.currentSinglePair) do
			  	if nKilledPlayerID == nPlayerID then
				  	local nLoserId = nKilledPlayerID
				  	local nWinnerId =  PvpModule.currentSinglePair[3-i]
				  	PvpModule:EndSinglePvp(nWinnerId,nLoserId);
			  	end
		  	end
		  	for i,nTeamID in ipairs(PvpModule.currentPair) do
			  	if nKilledTeamID==nTeamID and PvpModule:CheckTeamAllDead(nTeamID) then
				  	local nLoserTeamId = nKilledTeamID
				  	local nWinnerTeamId =  PvpModule.currentPair[3-i];
				  	PvpModule:EndPvp(nWinnerTeamId,nLoserTeamId);
			  	end
		  	end
		end
	end,
	  	function(e)
		print(e)
	end)
end

function PvpModule:CheckTeamAllDead(nTeamID)
	local bResult= true;
	for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID) do
	  	local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID, i)
	  	local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
	  	if hHero and (hHero:IsAlive() or hHero:IsReincarnating()) then
		 	bResult= false
	  	end
	end
	return bResult
end

function PvpModule:EndPvp(nWinnerTeamID,nLoserTeamID)
	PvpModule:RefreshTeamHero(nWinnerTeamID)
	PvpModule:QuestCheck(nWinnerTeamID)
	PvpModule:SkillUpdate(nWinnerTeamID, nLoserTeamID)
	if GameMode.vAliveTeam and true==GameMode.vAliveTeam[nLoserTeamID] then
		PvpModule:RefreshTeamHero(nLoserTeamID)
	end

	if PvpModule.bEnd then
	   	return
	end

	Summon:KillSummonedCreatureAsyn(PvpModule.vHomeCenter)
	PvpModule:CompensateTeamExp(nWinnerTeamID)
	PvpModule:CompensateTeamExp(nLoserTeamID)
	PvpModule.bEnd = true
	PvpModule:PlayWinnerTeamEffect(nWinnerTeamID)

	Timers:CreateTimer({ endTime = 1, callback = function()
		if string.find(GetMapName(),"1x8") then
			 if GameMode.currentRound["nRoundNumber"] > 80 then
                PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
            --elseif GameMode.currentRound["nRoundNumber"] > 80 then
            --    if GameMode.nRank and GameMode.nRank <= 5 then
            --        PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
            --    end
            elseif GameMode.currentRound["nRoundNumber"] > 70 then
                if GameMode.nRank and GameMode.nRank <= 5 then
                    PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
                end
			else 
				if GameMode.nRank and GameMode.nRank <= 3 and ( GameMode.nValidTeamNumber >=5 or IsInToolsMode() ) then
					PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
				end
			end
		end
		if GetMapName()=="2x6" then
		  	if GameMode.nRank and GameMode.nRank <= 2 and ( GameMode.nValidTeamNumber >=4 or IsInToolsMode() ) then
				PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
		  	end
		end
		if GetMapName()=="5v5" then           
		   PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
		end
	end})

	for _,data in ipairs(PvpModule.betMap[nWinnerTeamID]) do
		if data and data.nPlayerId  and data.flRatio then
			local nPlayerId = data.nPlayerId
			local flRatio = data.flRatio
			local nBonusGold = math.floor(PvpModule.nBetBonus * flRatio)
			local barrageData={}
			barrageData.type = "bet_win"
			if data.sType and "pvp_free"==data.sType then
			   	if flRatio>=0.99 then 
				  	barrageData.type = "bet_jackpot"
			   	else
				  	barrageData.type = "pvp_win"
				  	nBonusGold = nBonusGold + math.floor(PvpModule.nBetBonus*0.15)
			   	end
			   	PvpModule:RewardWinnerBonus(nPlayerId,nBonusGold)
			else
			   PvpModule:RewardBetBonus(nPlayerId,nBonusGold)
			end

			barrageData.playerId = nPlayerId
			barrageData.gold_value = nBonusGold
			Barrage:FireBullet(barrageData)
			PvpModule:SumBetReward(nPlayerId,nBonusGold)           
			PvpModule:RecordBetHistory(nPlayerId,(nBonusGold-data.nValue),nWinnerTeamID,nLoserTeamID)
		end
	end
	for _,data in ipairs(PvpModule.betMap[nLoserTeamID]) do
		if data and data.nPlayerId  and data.flRatio and data.nValue then   
		   PvpModule:RewardBetLoseBonus(data.nPlayerId,data.nValue)
		end
	end 
	for _,data in ipairs(PvpModule.betMap[nLoserTeamID]) do    
		if data and data.nPlayerId  and data.flRatio and data.nValue then       
		  	PvpModule:RecordBetHistory(data.nPlayerId,(-1*data.nValue),nWinnerTeamID,nLoserTeamID)
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("TeamWin",{winnerTeamID=nWinnerTeamID,loserTeamID=nLoserTeamID} );
	CustomGameEventManager:Send_ServerToAllClients("CloseTopInfo",{} );
	PvpModule:RecordWinner(nWinnerTeamID)
	PvpModule:RecordLoser(nLoserTeamID)
end

function PvpModule:EndSinglePvp(nWinnerID,nLoserID)
	if PvpModule.bEnd then return end
	PvpModule:RefreshSingleHero(nWinnerID)
	PvpModule:RefreshSingleHero(nLoserID)
	local nWinnerTeamID= PlayerResource:GetTeam(nWinnerID)
	local nLoserTeamID= PlayerResource:GetTeam(nLoserID)
	PvpModule:CompensatePlayerExp(nWinnerID)
	PvpModule:CompensatePlayerExp(nLoserID)
	PvpModule.bEnd = true
	PvpModule:PlayWinnerHeroEffect(nWinnerID)
	local winner_hero = PlayerResource:GetSelectedHeroEntity(nWinnerID)
	if winner_hero and winner_hero:HasModifier("modifier_loser_curse") then
		Quests_arena:QuestProgress(nWinnerID, 85, 3)
	end
	if winner_hero and winner_hero:HasModifier("modifier_duel_win_6sec") then
		Quests_arena:QuestProgress(nWinnerID, 86, 3)
	end
	if winner_hero and winner_hero:HasModifier("modifier_duel_win_15sec") then
		Quests_arena:QuestProgress(nWinnerID, 71, 2)
	end

	Quests_arena:QuestProgress(nWinnerID, 22, 1)
	Quests_arena:QuestProgress(nWinnerID, 35, 1)
	Quests_arena:QuestProgress(nWinnerID, 60, 2)
	 
	for _,data in ipairs(PvpModule.betMap[nWinnerTeamID]) do
		if data and data.nPlayerId  and data.flRatio then
			local nPlayerId = data.nPlayerId
			local flRatio = data.flRatio
			local nBonusGold = math.floor(PvpModule.nBetBonus * flRatio)
			local barrageData={}
			barrageData.type = "pvp_win"
			barrageData.gold_value = nBonusGold
			barrageData.playerId = nPlayerId
			Barrage:FireBullet(barrageData)
			PvpModule:RewardWinnerBonus(nPlayerId,nBonusGold)
			PvpModule:SumBetReward(nPlayerId,nBonusGold)
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("TeamWin",{winnerTeamID=nWinnerTeamID,loserTeamID=nLoserTeamID} );
	CustomGameEventManager:Send_ServerToAllClients("CloseTopInfo",{} );
end

function PvpModule:PunishLoser(nWinnerTeamID,nLoserTeamID)
	local nWinnerPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nWinnerTeamID, RandomInt(1, PlayerResource:GetPlayerCountForTeam(nWinnerTeamID)))
	local hWinnerHero = PlayerResource:GetSelectedHeroEntity(nWinnerPlayerID)
	for i=1,PlayerResource:GetPlayerCountForTeam(nLoserTeamID) do
		local nLoserPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nLoserTeamID, i)
		local hLoserHero = PlayerResource:GetSelectedHeroEntity(nLoserPlayerID)
		if hLoserHero  then
		   	if hWinnerHero then
				local nParticle = ParticleManager:CreateParticle("particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hLoserHero)
				ParticleManager:SetParticleControl(nParticle, 0, hLoserHero:GetAbsOrigin())
				ParticleManager:SetParticleControl(nParticle, 1, hLoserHero:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(nParticle, 0, hWinnerHero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hWinnerHero:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(nParticle, 1, hLoserHero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hLoserHero:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(nParticle)
		   	end

		   	local hAegis = hLoserHero:FindModifierByName("modifier_aegis")
		   
		   	if hAegis and hAegis:GetStackCount()>=1 then
			  	local data={}
			  	data.type = "pvp_lose_aegis"
			  	data.playerId = nLoserPlayerID
			  	Barrage:FireBullet(data)
			  	local nCount = hAegis:GetStackCount()
			  	hAegis:SetStackCount(nCount-1)
			  	CustomNetTables:SetTableValue("aegis_count", tostring(hLoserHero:GetPlayerOwnerID()), {count = nCount-1})
		   	else
			  	local data={}
			  	data.type = "pvp_stack_curse"
			  	data.playerId = nLoserPlayerID
			  	Barrage:FireBullet(data)
			  	local hDebuff = hLoserHero:FindModifierByName("modifier_loser_curse")
			  	if hDebuff == nil then
			  		local curse_ability = nil
			  		local empty_0 = hLoserHero:FindAbilityByName("empty_0")
			  		if empty_0 then
			  			curse_ability = empty_0
			  		end
					hDebuff = hLoserHero:AddNewModifier(hLoserHero, curse_ability, "modifier_loser_curse", {})
					if hDebuff ~= nil then
						hDebuff:SetStackCount(0)
					end
			  	end
			  	if hDebuff ~= nil then
				 	hDebuff:SetStackCount(hDebuff:GetStackCount() + 1)
			  	end
		   	end
		end 
	end
end

function PvpModule:QuestCheck(nTeamID)
	for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID) do
		local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID, i)
		local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
		if hHero and (not hHero:IsNull()) then
		  	if hHero and hHero:HasModifier("modifier_loser_curse") then
			  	Quests_arena:QuestProgress(nPlayerID, 85, 3)
		  	end
		  	if hHero and hHero:HasModifier("modifier_duel_win_6sec") then
			  	Quests_arena:QuestProgress(nPlayerID, 86, 3)
		  	end
		  	if hHero and hHero:HasModifier("modifier_duel_win_15sec") then
			  	Quests_arena:QuestProgress(nPlayerID, 71, 2)
		  	end
		  	Quests_arena:QuestProgress(nPlayerID, 22, 1)
		  	Quests_arena:QuestProgress(nPlayerID, 35, 1)
		  	Quests_arena:QuestProgress(nPlayerID, 60, 2)
		end
	end
end

function PvpModule:SkillUpdate(wTeamID, lTeamID)
	for i=1,PlayerResource:GetPlayerCountForTeam(wTeamID) do
		local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(wTeamID, i)
		local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
		if hHero and (not hHero:IsNull()) then
			if hHero:HasModifier('modifier_skill_deposit') then
				local modifier_skill_deposit = hHero:FindModifierByName("modifier_skill_deposit")
				if modifier_skill_deposit then
					modifier_skill_deposit:IncrementStackCount()
				end
			end
			if hHero:HasModifier('modifier_skill_retraining') then
	            local modifier_skill_retraining = hHero:FindModifierByName("modifier_skill_retraining")
	            if modifier_skill_retraining then
	                modifier_skill_retraining:IncrementStackCount()
	            end
	        end
			if hHero:HasModifier('modifier_skill_investment') then
				local modifier_skill_investment = hHero:FindModifierByName("modifier_skill_investment")
				if modifier_skill_investment then
					modifier_skill_investment:IncrementStackCount()
				end
			end
		end
	end
	for i=1,PlayerResource:GetPlayerCountForTeam(lTeamID) do
		local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(lTeamID, i)
		local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
		if hHero and (not hHero:IsNull()) then
			if hHero:HasModifier('modifier_skill_deposit') then
				local modifier_skill_deposit = hHero:FindModifierByName("modifier_skill_deposit")
				if modifier_skill_deposit then
					modifier_skill_deposit:IncrementStackCount()
				end
			end
			if hHero:HasModifier('modifier_skill_retraining') then
	            local modifier_skill_retraining = hHero:FindModifierByName("modifier_skill_retraining")
	            if modifier_skill_retraining then
	                modifier_skill_retraining:IncrementStackCount()
	            end
	        end
			if hHero:HasModifier('modifier_skill_investment') then
				local modifier_skill_investment = hHero:FindModifierByName("modifier_skill_investment")
				if modifier_skill_investment then
					modifier_skill_investment:IncrementStackCount()
				end
			end
		end
	end
end

function PvpModule:CompensateTeamExp(nTeamID)
	for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID) do
  		local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID, i)
  		local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
  		if hHero then
			local nRoundNumber = PvpModule.nLastPvpRound
			if nRoundNumber and GameRules.xpTable[nRoundNumber+1] and GameRules.xpTable[nRoundNumber] then
	  			local nExp = math.floor( (GameRules.xpTable[nRoundNumber+1] -GameRules.xpTable[nRoundNumber]) *0.7)
	  			hHero:AddExperience(nExp, 0, false, false)
			end
  		end
	end
end

function PvpModule:CompensatePlayerExp(nPlayerID)
	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
	if hHero then
  		local nRoundNumber = PvpModule.nLastPvpRound
  		if nRoundNumber and GameRules.xpTable[nRoundNumber+1] and GameRules.xpTable[nRoundNumber] then
			local nExp = math.floor( (GameRules.xpTable[nRoundNumber+1] -GameRules.xpTable[nRoundNumber]) *0.7)
			hHero:AddExperience(nExp, 0, false, false)
  		end
	end
end

-- ВЫЗЫВАЕТСЯ ДЛЯ ПОБЕДИТЕЛЯ В ДУЭЛИ
function PvpModule:RewardWinnerBonus(nPlayerId,nBonusGold)
	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
	if hHero and hHero:HasModifier("modifier_skill_benefiter") then
		nBonusGold = nBonusGold + (nBonusGold / 100 * 35)
	end
	local nParticle1 = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_start_ti6.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hHero)
	ParticleManager:SetParticleControlEnt(nParticle1, 0, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetOrigin(), true)
	local nParticle2 = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_start_ti6_lvl3_rays.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hHero)
	ParticleManager:SetParticleControlEnt(nParticle2, 0, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetOrigin(), true)
	SendOverheadEventMessage(hHero, OVERHEAD_ALERT_GOLD, hHero, nBonusGold, nil)
	PlayerResource:ModifyGold(nPlayerId, nBonusGold, true, DOTA_ModifyGold_GameTick)
	GameMode:UpdatePlayerGold(nPlayerId)
	ParticleManager:DestroyParticle(nParticle1, false)
	ParticleManager:DestroyParticle(nParticle2, false)
	ParticleManager:ReleaseParticleIndex(nParticle1)
	ParticleManager:ReleaseParticleIndex(nParticle2)
end

-- Вызываетс когда ставка прошла успешно
function PvpModule:RewardBetBonus(nPlayerId, nBonusGold)
	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
	if hHero and hHero:HasModifier("modifier_skill_gambler") then
		nBonusGold = nBonusGold + (nBonusGold / 100 * 15)
	end
	Quests_arena:QuestProgress(nPlayerId, 25, 1, nBonusGold)
	Quests_arena:QuestProgress(nPlayerId, 67, 2, nBonusGold)
	Quests_arena:QuestProgress(nPlayerId, 82, 3, nBonusGold)
	SendOverheadEventMessage(hHero, OVERHEAD_ALERT_GOLD, hHero, nBonusGold, nil)
	PlayerResource:ModifyGold(nPlayerId, nBonusGold, true, DOTA_ModifyGold_GameTick)
	GameMode:UpdatePlayerGold(nPlayerId)
	local nParticle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_spindle_rig.vpcf", PATTACH_OVERHEAD_FOLLOW, hHero)
	ParticleManager:ReleaseParticleIndex(nParticle)
end

-- Вызываетс когда ставка проиграна
function PvpModule:RewardBetLoseBonus(nPlayerId, nBonusGold)
	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
	if hHero and (hHero:HasModifier("modifier_skill_benefiter") or hHero:HasModifier("modifier_skill_gambler")) then
		local cashback = nBonusGold / 100 * 10
		if cashback > 0 then
			SendOverheadEventMessage(hHero, OVERHEAD_ALERT_GOLD, hHero, cashback, nil)
			PlayerResource:ModifyGold(nPlayerId, cashback, true, DOTA_ModifyGold_GameTick)
			GameMode:UpdatePlayerGold(nPlayerId)
		end
	end
end

function PvpModule:ConfirmActor(keys)
	local nPlayerID = keys.player_id;
	local nTargetPlayerID = keys.target_player_id
	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
	if hHero:IsNull() then return end
	if GameMode.reportActorTime[tonumber(nPlayerID)] and GameMode.reportActorTime[tonumber(nPlayerID)]>0 then
		local data={}
		data.type = "report_actor"
		data.playerId = nTargetPlayerID
		Barrage:FireBullet(data)
		GameMode.reportActorTime[tonumber(nPlayerID)] = GameMode.reportActorTime[tonumber(nPlayerID)] -1
	else
		return
	end
end

function PvpModule:PlayWinnerTeamEffect(nWinnerTeamId)
  	for i=1,PlayerResource:GetPlayerCountForTeam(nWinnerTeamId) do
	 	local nWinnerPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nWinnerTeamId, i)
	 	local hWinnerHero = PlayerResource:GetSelectedHeroEntity(nWinnerPlayerID)
	 	if hWinnerHero then
		 	local nWinnerParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, hWinnerHero)
		 	ParticleManager:ReleaseParticleIndex(nWinnerParticleIndex)
		 	EmitSoundOn("Hero_LegionCommander.Duel.Victory", hWinnerHero)
		 	Timers:CreateTimer({ endTime = 2, callback = function()
				if PvpModule.winnerSoundMap[hWinnerHero:GetUnitName()]~=nil then
			  		EmitGlobalSound(PvpModule.winnerSoundMap[hWinnerHero:GetUnitName()])
		   		end
			end})
	 	end
  	end
end

function PvpModule:PlayWinnerHeroEffect(nWinnerPlayerID)
   	local hWinnerHero = PlayerResource:GetSelectedHeroEntity(nWinnerPlayerID)
   	if hWinnerHero then
	   	local nWinnerParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, hWinnerHero)
	   	ParticleManager:ReleaseParticleIndex(nWinnerParticleIndex)
	   	EmitSoundOn("Hero_LegionCommander.Duel.Victory", hWinnerHero)
	    Timers:CreateTimer({ endTime = 2, callback = function()
			if PvpModule.winnerSoundMap[hWinnerHero:GetUnitName()]~=nil then
				EmitGlobalSound(PvpModule.winnerSoundMap[hWinnerHero:GetUnitName()])
			end
		end})
   	end
end

function PvpModule:RecordWinner(nWinnerTeamID)
  	for i=1,PlayerResource:GetPlayerCountForTeam(nWinnerTeamID) do
	 	local nWinnerPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nWinnerTeamID, i)
	 	local winnerRecord = CustomNetTables:GetTableValue("pvp_record", tostring(nWinnerPlayerID))
	 	if winnerRecord and winnerRecord.win then
	   		winnerRecord.win = winnerRecord.win +1
	   		CustomNetTables:SetTableValue("pvp_record", tostring(nWinnerPlayerID),winnerRecord)
	 	end
  	end
end

function PvpModule:RecordLoser(nLoserTeamID)
  	for i=1,PlayerResource:GetPlayerCountForTeam(nLoserTeamID) do
	 	local nLoserPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nLoserTeamID, i)
	 	local loserRecord = CustomNetTables:GetTableValue("pvp_record", tostring(nLoserPlayerID))
	 	if loserRecord and loserRecord.lose then
	   		loserRecord.lose = loserRecord.lose +1
	   		CustomNetTables:SetTableValue("pvp_record", tostring(nLoserPlayerID),loserRecord)
	 	end
  	end
end

function PvpModule:SumBetReward(nPlayerID,nValue) 
	local record = CustomNetTables:GetTableValue("pvp_record", tostring(nPlayerID))
	if record and record.total_bet_reward then
	   	record.total_bet_reward = record.total_bet_reward +nValue
	   	CustomNetTables:SetTableValue("pvp_record", tostring(nPlayerID),record)
	end
end

function PvpModule:RecordBetHistory(nPlayerID,nValue,nWinnerID,nLoserID)
	if PvpModule.betHistory[nPlayerID]==nil then
		PvpModule.betHistory[nPlayerID] = {}
	end
	if #PvpModule.betHistory[nPlayerID]>90 then
		return
	end
	local data = {}
	local winners= {}
	local losers= {}
	for nWinnerPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nWinnerPlayerID ) == nWinnerID then
		   table.insert(winners, nWinnerPlayerID)
		end
	end
	for nLoserPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nLoserPlayerID ) == nLoserID then
		   table.insert(losers, nLoserPlayerID)
		end
	end
	data.winners = winners
	data.losers = losers
	data.value = nValue
	table.insert(PvpModule.betHistory[nPlayerID], data)
	CustomNetTables:SetTableValue("pvp_record", "bet_history_"..tostring(nPlayerID),PvpModule.betHistory[nPlayerID])
end

function PvpModule:PairSinglePlayer()
	PvpModule.singlePlayerPvpPairs={}
	local nValidePlayer = 0
	local pvpValidePlayerList ={}

	for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
	  	if bAlive then
		  	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			
				if PlayerResource:IsValidPlayer(nPlayerID) and ( IsInToolsMode() or PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED)  then
					if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then                  
						table.insert(pvpValidePlayerList, nPlayerID)
						nValidePlayer = nValidePlayer + 1
					end
				end
		  	end
	   	end
	end

	for _,nPlayerID in ipairs(pvpValidePlayerList) do
	  	for _,nEnemyPlayerID in ipairs(pvpValidePlayerList) do
		 	if nEnemyPlayerID<nPlayerID  and PlayerResource:GetTeam(nEnemyPlayerID)~=PlayerResource:GetTeam(nPlayerID) then
		   		local pair = {}
		   		pair.nFirstPlayerId = nPlayerID
		   		pair.nSecondePlayerId = nEnemyPlayerID
		   
		   		pair.nJoinTimes = 0
		   		table.insert(PvpModule.singlePlayerPvpPairs,pair)
		 	end 
	  	end
	end
end

function PvpModule:ChooseOneSinglePair()
	PvpModule.singlePlayerPvpPairs=table.shuffle(PvpModule.singlePlayerPvpPairs)
	for _,pair in ipairs(PvpModule.singlePlayerPvpPairs) do
		pair.nScore =pair.nJoinTimes
		if PvpModule.lastSinglePair then
		  	if pair.nFirstPlayerId == PvpModule.lastSinglePair.nFirstPlayerId or
			 	pair.nFirstPlayerId == PvpModule.lastSinglePair.nSecondePlayerId then
			 	pair.nScore = pair.nScore + 1
		  	end
		  	if pair.nSecondePlayerId == PvpModule.lastSinglePair.nFirstPlayerId or
			 	pair.nSecondePlayerId == PvpModule.lastSinglePair.nSecondePlayerId then
			 	pair.nScore = pair.nScore + 1
		  	end
		end
		if PvpModule.secondLastSinglePair then
		  	if pair.nFirstPlayerId == PvpModule.secondLastSinglePair.nFirstPlayerId or
			 	pair.nFirstPlayerId == PvpModule.secondLastSinglePair.nSecondePlayerId then
			 	pair.nScore = pair.nScore + 0.1
		  	end
		  	if pair.nSecondePlayerId == PvpModule.secondLastSinglePair.nFirstPlayerId or
			 	pair.nSecondePlayerId == PvpModule.secondLastSinglePair.nSecondePlayerId then
			 	pair.nScore = pair.nScore + 0.1
		  	end
		end
	end
	table.sort(PvpModule.singlePlayerPvpPairs,function(a, b) return a.nScore < b.nScore end)
	local result = PvpModule.singlePlayerPvpPairs[1]
	table.remove(PvpModule.singlePlayerPvpPairs, 1)
	for i=1,#PvpModule.singlePlayerPvpPairs do
	   	if PvpModule.singlePlayerPvpPairs[i] then
		  	if PvpModule.singlePlayerPvpPairs[i].nFirstPlayerId==result.nFirstPlayerId or PvpModule.singlePlayerPvpPairs[i].nSecondePlayerId==result.nFirstPlayerId then
			 	PvpModule.singlePlayerPvpPairs[i].nJoinTimes = PvpModule.singlePlayerPvpPairs[i].nJoinTimes + 1              
		  	end
		  	if PvpModule.singlePlayerPvpPairs[i].nFirstPlayerId==result.nSecondePlayerId or PvpModule.singlePlayerPvpPairs[i].nSecondePlayerId==result.nSecondePlayerId then
			 	PvpModule.singlePlayerPvpPairs[i].nJoinTimes = PvpModule.singlePlayerPvpPairs[i].nJoinTimes + 1            
		  	end
	   	end
	end
	return result
end

function PvpModule:BotAutoBet(nPlayerID)
	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
	if hHero==nil or hHero:IsNull() then return end
	if hHero.nBotSpendGold ==nil then hHero.nBotSpendGold = 0 end
	local nCurrentGold = Util:GetBotEarnedGold(nPlayerID)- hHero.nBotSpendGold
	local nMaxGold=math.floor(PlayerResource:GetGold(nPlayerID)/2)

	if PvpModule.bLeaveHand then
		return
	end

	if not GameMode.vAliveTeam[PlayerResource:GetTeam(nPlayerID)] then
		return
	end

	local bAlreadyBet =false

	for _,dataList in pairs(PvpModule.betMap) do
		for _,data in ipairs(dataList) do
			if data.nPlayerId == nPlayerID then
				bAlreadyBet=true
			end
		end
	end

	if bAlreadyBet then
		return
	end
 
	local nGoldSum = 0
	local wishTeamList = {}

	local nFinialWishTeamID

	for nPvpTeamID,_ in pairs(PvpModule.betMap) do
	   local nTotalGold = 0
	   	for _,nPvpPlayerID in ipairs(GameMode.vTeamPlayerMap[nPvpTeamID]) do
		  	local goldData = CustomNetTables:GetTableValue( "player_info", tostring(nPvpPlayerID) )
		  	if goldData then
			 	nTotalGold = nTotalGold+goldData.gold
		  	else
				nTotalGold = nTotalGold +600
		  	end
	   end
	   table.insert(wishTeamList, {nGold=nTotalGold,nWishTeamID=nPvpTeamID})
	   nGoldSum = nGoldSum + nTotalGold
	end 

	if RandomFloat(0, 1)<wishTeamList[1].nGold/nGoldSum then
	   	nFinialWishTeamID = wishTeamList[1].nWishTeamID
	else
	   	nFinialWishTeamID = wishTeamList[2].nWishTeamID
	end
  
	local nValue = math.floor(RandomFloat(0, 1)*nCurrentGold*0.4)
	
	if nValue<=0 then
	   return
	end

	local data = {}
	data.nPlayerId = nPlayerID
	data.nValue = nValue
	table.insert(PvpModule.betMap[nFinialWishTeamID], data)
	PvpModule.nBetBonus = PvpModule.nBetBonus + nValue;
	
	if PvpModule.betValueSum[nPlayerID] then
	   PvpModule.betValueSum[nPlayerID] = PvpModule.betValueSum[nPlayerID] + nValue
	end

	hHero.nBotSpendGold = hHero.nBotSpendGold + nValue
	hHero:EmitSound("DOTA_Item.Hand_Of_Midas")
	local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_midas_coinshower.vpcf", PATTACH_ABSORIGIN, hHero)
    ParticleManager:ReleaseParticleIndex(particle)
end

function PvpModule:RefreshTeamHero(nTeamID)
	for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID) do
	  	local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID, i)
	  	local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
  		if hHero and (not hHero:IsNull()) then
	  		if not hHero:IsAlive() then
		   		Timers:CreateTimer({ endTime = 0.01, callback = function()
					hHero:RespawnHero(false, false)
					Util:MoveHeroToCenter( nPlayerID )
					hHero:RemoveModifierByName("modifier_razor_static_link")
					hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
					hHero:RemoveModifierByName("modifier_duel_damage_check")
					hHero:RemoveModifierByName("modifier_duel_curse")
					hHero:RemoveModifierByName("modifier_duel_curse_cooldown")
					hHero.bJoiningPvp = false
			  	end})
			  	Timers:CreateTimer({ endTime = 0.7, callback = function()
			  		Util:RefreshAbilityAndItem( hHero )
			  	end})
		   		for _, modifier in pairs( hHero:FindAllModifiers() ) do
			  		if modifier and modifier:GetCaster() ~= hHero and modifier:IsDebuff() then
						modifier:Destroy()
			  		end
				end
	  		else
		   		hHero:SetHealth(hHero:GetMaxHealth())
		   		hHero:SetMana(hHero:GetMaxMana())
		   		hHero:RemoveModifierByName("modifier_razor_static_link")
		   		hHero:RemoveModifierByName("modifier_duel_damage_check")
		   		hHero:RemoveModifierByName("modifier_duel_curse")
		   		hHero:RemoveModifierByName("modifier_duel_curse_cooldown")
		   		hHero:AddNewModifier(hHero, nil, "modifier_duel_teleporting", {duration = 1})
		   		Timers:CreateTimer({ endTime = 1, callback = function()
		   			hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
					Util:RefreshAbilityAndItem( hHero )
					Util:MoveHeroToCenter(nPlayerID)
					hHero.bJoiningPvp = false
				end})
				Timers:CreateTimer({ endTime = 0.7, callback = function()
			  		Util:RefreshAbilityAndItem( hHero )
			  	end})
				for _, modifier in pairs( hHero:FindAllModifiers() ) do
			  		if modifier and modifier:GetCaster() ~= hHero and modifier:IsDebuff() then
						modifier:Destroy()
			  		end
				end
				hHero:Purge(false, true, false, true, true)
	  		end
  		end
	end
end

function PvpModule:RefreshSingleHero(nPlayerID)
	local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
	if hHero and (not hHero:IsNull()) then
		if not hHero:IsAlive() then
			Timers:CreateTimer({ endTime = 0.01, callback = function()
				hHero:RespawnHero(false, false)
				local nTeamNumber = hHero:GetTeam()
			  	if nTeamNumber and GameMode.currentRound and  GameMode.currentRound.spanwers and GameMode.currentRound.spanwers[nTeamNumber] and GameMode.currentRound.spanwers[nTeamNumber].bProgressFinished==false then                   
					local wayPoint = Entities:FindByName(nil, "center_"..nTeamNumber)
					hHero:RemoveModifierByName("modifier_razor_static_link")
					hHero:RemoveModifierByName("modifier_duel_damage_check")
					hHero:RemoveModifierByName("modifier_duel_curse")
					Util:MoveHeroToLocation( nPlayerID,wayPoint:GetOrigin() )
					Timers:CreateTimer({ endTime = 0.7, callback = function()
			  			Util:RefreshAbilityAndItem( hHero )
			  		end})
			  	else
				 	hHero:RemoveModifierByName("modifier_razor_static_link")
				 	hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
				 	hHero:RemoveModifierByName("modifier_duel_damage_check")
				 	hHero:RemoveModifierByName("modifier_duel_curse")
				 	hHero:RemoveModifierByName("modifier_duel_curse_cooldown")
				 	Util:MoveHeroToCenter( nPlayerID )
				 	Timers:CreateTimer({ endTime = 0.7, callback = function()
			  			Util:RefreshAbilityAndItem( hHero )
			  		end})
			  	end  
			  	hHero.bJoiningPvp = false
			end})
			Util:RefreshAbilityAndItem( hHero )
			for _, modifier in pairs( hHero:FindAllModifiers() ) do
			  	if modifier and modifier:GetCaster() ~= hHero and modifier:IsDebuff() then
					modifier:Destroy()
			  	end
			end
		else
			Util:RefreshAbilityAndItem( hHero )
			hHero:SetHealth(hHero:GetMaxHealth())
			hHero:SetMana(hHero:GetMaxMana())
			hHero:RemoveModifierByName("modifier_razor_static_link")
			hHero:RemoveModifierByName("modifier_duel_damage_check")
			hHero:RemoveModifierByName("modifier_duel_curse")
			hHero:RemoveModifierByName("modifier_duel_curse_cooldown")
			hHero:AddNewModifier(hHero, nil, "modifier_duel_teleporting", {duration = 1})
			Timers:CreateTimer({ endTime = 1, callback = function()
				Util:RefreshAbilityAndItem( hHero )
				local nTeamNumber = hHero:GetTeam()
				if nTeamNumber and GameMode.currentRound and  GameMode.currentRound.spanwers and GameMode.currentRound.spanwers[nTeamNumber] and GameMode.currentRound.spanwers[nTeamNumber].bProgressFinished==false then                    
					local wayPoint = Entities:FindByName(nil, "center_"..nTeamNumber)
					Util:MoveHeroToLocation( nPlayerID,wayPoint:GetOrigin() )
				else
					hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
					Util:MoveHeroToCenter( nPlayerID )
				end
				hHero.bJoiningPvp = false
			end})
			hHero:Purge(false, true, false, true, true)
			for _, modifier in pairs( hHero:FindAllModifiers() ) do
				if modifier and modifier:GetCaster() ~= hHero and modifier:IsDebuff() then
				  	modifier:Destroy()
				end
			end
		end
	end
end