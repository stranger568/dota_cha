if GameMode == nil then
	_G.GameMode = class({}) 
end

------------Дополнительные библиотеки
require( "utils/utility_functions" )
require( "utils/timers" )
require( "utils/bit" )
require( "utils/table" )
require( "utils/notifications" )
require( "utils/cdota_base_npc" )
require( "utils/cdota_base_ability" )
require( "utils/cdota_modifier_lua" )
require( 'utils/disconnect' )
require( "util" )
require( "overlord/playertables" )
require( "overlord/worldpanels" )
---------------------------------------------

------ Фильтры --------------------------
require( "filter/damage_filter" )
require( "filter/order_filter" )
require( "filter/modifier_filter" )
-------------------------------------------

require("quests") -- Квесты
require("skills") -- Навыки
require('web/requests') -- Библиотека реквестов
require("web/mmr") -- Рейтинг и вебдата
require( "pass" ) -- Донатные функции
require( "hero_builder" ) -- Функции создания героя и способностей
require( "debugger" ) -- Дебаггер
require( "round" ) -- Создание раундов
require( "spawner" ) -- Спавн крипов на аренах
require( "barrage" ) -- Летающий текст
require( "pvp_module" ) -- Дуэли
require( "item_loot" ) -- Нейтральные предметы
require( "summon" ) -- Библиотека на суммонеров
require( "illusion" ) -- Создание иллюзий
require( "extra_creature" ) -- Спавн мобов с книг
require( "utils/keyvalues" )
require( "utils/error_tracking")
require( "utils/event_driver")

------ Данные--------------------------------------------------------------------------------------

GameRules.allHeroesKV = LoadKeyValues("scripts/npc/herolist.txt")
GameRules.heroesPoolList = {}
GameRules.heroesPoolList_strength_list = {}
GameRules.heroesPoolList_agility_list = {}
GameRules.heroesPoolList_intellect_list = {}
GameRules.heroesPoolList_all_list = {}
GameRules.hero_list_duplicate = {}
GameRules.nian_count = 0

for k,_ in pairs(GameRules.allHeroesKV) do
    table.insert(GameRules.heroesPoolList,k)
end

local heroes_list = LoadKeyValues("scripts/npc/heroes_list.txt")

for _,hero in pairs(GameRules.heroesPoolList) do
    if heroes_list[hero].AttributePrimary == "DOTA_ATTRIBUTE_STRENGTH" then
        table.insert(GameRules.heroesPoolList_strength_list, hero)
    elseif heroes_list[hero].AttributePrimary == "DOTA_ATTRIBUTE_AGILITY" then
        table.insert(GameRules.heroesPoolList_agility_list, hero)
    elseif heroes_list[hero].AttributePrimary == "DOTA_ATTRIBUTE_INTELLECT" then
        table.insert(GameRules.heroesPoolList_intellect_list, hero)
    elseif heroes_list[hero].AttributePrimary == "DOTA_ATTRIBUTE_ALL" then
        table.insert(GameRules.heroesPoolList_all_list, hero)
    end
end

--------------------------------------------------------------------------------------

Precache = require "Precache"

function Precache( context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_cha_custom.vsndevts", context)
end

function Activate()
    ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, "OnPlayerReconnected"), self)
    Chadisconnect:RegListeners()
    GameMode:InitGameMode()
    SendToServerConsole("tv_delay 0")
end

function GameMode:InitGameMode()
    GameRules:GetGameModeEntity().GameMode = self
    Pass:Init()
    HeroBuilder:Init()
    Debugger:Init()
    Barrage:Init()
    PvpModule:Init()
    ItemLoot:Init()
    Summon:Init()
    Illusion:Init()
    ExtraCreature:Init()

    GameRules.teamAbandonMap = {}
    GameMode.reportActorTime = {}
    GameMode.HeroesPlayersList = {}
    GameMode.feedbackTime = {}
    GameMode.partyListMap= {}
    GameMode.nPartyNumber= 0
    GameMode.partyNumberMap= {}
    GameMode.fow_viwer_teams = {}

    GameRules:SetSameHeroSelectionEnabled(true)
    GameRules:SetHeroSelectionTime(5)
    GameRules:SetStrategyTime(7)
    GameRules:SetShowcaseTime(0)
    GameRules:SetSafeToLeave(true)

    GameRules:SetCustomGameSetupRemainingTime(10)
    GameRules:SetCustomGameSetupTimeout(10)
    GameRules:SetCustomGameSetupAutoLaunchDelay(10)

    if IsInToolsMode() then
       GameRules:SetPreGameTime(12)
       GameRules:SetStartingGold(600)
    else
       GameRules:SetPreGameTime(65)
       GameRules:SetStartingGold(600)
    end

    GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(999)

    local xpTable = {230,600,1080,1660,2260,2980,3730,4510,5320,6160,7030,7930,9155,10405,11680,12980,14305,15805,17395,18995,20845,22945,25295,27895}

    xpTable[0] = 0

    for i = 25, 1000 do
        xpTable[i] = xpTable[i-1]+(i-24)*1000+2500
    end

    GameRules.xpTable = xpTable
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(xpTable)
    GameMode:AssembleHeroesData()
    GameMode:SetTeam()
    GameMode:ReadRoundConfigurations()
    GameRules:SetHeroRespawnEnabled( false )
    GameRules:GetGameModeEntity():SetFixedRespawnTime(99990000)
    GameRules:SetUseUniversalShopMode( true )
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(false) 
    GameRules:GetGameModeEntity():SetDaynightCycleDisabled(true) 
    GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_smoke_of_deceit_custom")
    GameRules:GetGameModeEntity():SetNeutralStashEnabled(true)
    GameRules:GetGameModeEntity():SetDefaultStickyItem( "item_smoke_of_deceit_custom" )
    GameRules:SetCustomGameEndDelay( 120 )
    GameRules:SetCustomVictoryMessageDuration(120)
    GameRules:SetPostGameTime(120)
    GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( GameMode, "BountyRunePickupFilter" ), self )

    SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
    ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(GameMode, "OnItemPurchased"), self)
    ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(GameMode, "OnHeroLevelUp"), self)
    ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(GameMode, "OnPlayerUsedAbility"), self)
    ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(GameMode, "OnHeroLearnAbility"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameMode, "OnNPCSpawned"), self)
    ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickUp"), self )
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)

    CustomGameEventManager:RegisterListener("HeroIconClicked", Dynamic_Wrap(GameMode, 'HeroIconClicked'))
    CustomGameEventManager:RegisterListener("ToggleAutoDuel", Dynamic_Wrap(GameMode, 'ToggleAutoDuel'))
    CustomGameEventManager:RegisterListener("ToggleAutoCreep", Dynamic_Wrap(GameMode, 'ToggleAutoCreep'))
    CustomGameEventManager:RegisterListener("ClientReconnected", Dynamic_Wrap(GameMode, 'ClientReconnected'))
    CustomGameEventManager:RegisterListener("cha_update_camera_visible", Dynamic_Wrap(GameMode, 'cha_update_camera_visible'))
    CustomGameEventManager:RegisterListener("StartGameCodeOk", Dynamic_Wrap(GameMode, 'StartGameCodeOk'))
    CustomGameEventManager:RegisterListener("RemoveSmoke", Dynamic_Wrap(GameMode, 'RemoveSmoke'))
    CustomGameEventManager:RegisterListener("ChooseSkill", Dynamic_Wrap(Skills,'ChooseSkill'))
    CustomGameEventManager:RegisterListener("ChooseSkillReal", Dynamic_Wrap(Skills,'ChooseSkillReal'))
    CustomGameEventManager:RegisterListener("ChangeQuest", Dynamic_Wrap(Quests_arena,'ChangeQuest'))
    CustomGameEventManager:RegisterListener("PlayerSettings", Dynamic_Wrap(ChaServerData,'PlayerSettings'))

    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
    GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
    GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierGainedFilter"), self)
    GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "ModifyGoldFilter"), self)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    GameRules:SetTreeRegrowTime(60)

    local vTeamColors = {}
    vTeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  
    vTeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   
    vTeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  
    vTeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   
    vTeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   
    vTeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  
    vTeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   
    vTeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  
    vTeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  
    vTeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  

    for nTeamNumber = 0, (DOTA_TEAM_COUNT-1) do
        local color = vTeamColors[ nTeamNumber ]
        if color then
            SetTeamCustomHealthbarColor( nTeamNumber, color[1], color[2], color[3] )
        end
    end

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
        GameMode.feedbackTime[nPlayerID]=10
    end

    local fix_pos_timer = SpawnEntityFromTableSynchronous("info_target", { targetname = "Fix_position" })
    fix_pos_timer:SetThink( FixPosition, 1 )
end

function GameMode:OnItemPickUp( event )
    local item = EntIndexToHScript( event.ItemEntityIndex )
    local owner
    if event.HeroEntityIndex then
        owner = EntIndexToHScript(event.HeroEntityIndex)
    elseif event.UnitEntityIndex then
        owner = EntIndexToHScript(event.UnitEntityIndex)
    end
    if event.itemname == "item_bag_of_gold" then
        local gold = 300
        if GameMode.currentRound.nRoundNumber > 10 then
            gold = math.min(1000, 300 + (math.floor(GameMode.currentRound.nRoundNumber / 10) * 100) )
        end
        PlayerResource:ModifyGold( owner:GetPlayerID(), gold, true, 0 )
        SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, gold, nil )
        UTIL_Remove( item )
    end 
end

function FixPosition()
    local allHeroes = HeroList:GetAllHeroes()
    for _, hero in pairs(allHeroes) do
        if hero:IsRealHero() then
            local origin = hero:GetAbsOrigin()
            if origin.z < -200 then
                local mapCenter = Entities:FindByName(nil, "map_center")
                if mapCenter then
                    if not GridNav:IsTraversable(origin) and not hero:HasFlyingVision() and not hero:HasFlyMovementCapability() then
                        if not hero:IsCurrentlyHorizontalMotionControlled() and not hero:IsCurrentlyVerticalMotionControlled() then
                            FindClearSpaceForUnit(hero, mapCenter:GetAbsOrigin(), true)
                        end
                    end
                end
            end
        end
    end
    return 1
end

function GameMode:BountyRunePickupFilter( data )
    local hero = PlayerResource:GetSelectedHeroEntity(data.player_id_const)
    if hero then
        local alchemist = hero:FindAbilityByName("alchemist_goblins_greed_custom")
        if alchemist and alchemist:GetLevel() > 0 then
            data["gold_bounty"] = data["gold_bounty"] * alchemist:GetSpecialValueFor("bounty_multiplier")
        end
        Quests_arena:QuestProgress(hero:GetPlayerOwnerID(), 24, 1)
    end
    return true
end

LinkLuaModifier("modifier_abilities_optimization_thinker", "modifiers/modifier_abilities_optimization_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creator_statue", "modifiers/modifier_creator_statue", LUA_MODIFIER_MOTION_NONE)

function GameMode:SpawnCreators()
    Timers:CreateTimer(2.5, function()
        local npc_unit_top1_spawn = Entities:FindByName(nil, "spawn_top1")
        if npc_unit_top1_spawn then
            local origin = npc_unit_top1_spawn:GetAbsOrigin()
            local top_unit_one = CreateUnitByName( "npc_unit_top1", origin, false, nil, nil, DOTA_TEAM_NEUTRALS )
            top_unit_one:SetForwardVector((Vector(0,0,0) - top_unit_one:GetAbsOrigin()):Normalized())
            top_unit_one:AddNewModifier( top_unit_one, nil, "modifier_creator_statue", {id = "444746023"} )
            top_unit_one:SetAbsOrigin(top_unit_one:GetAbsOrigin() + (Vector(0,0,60)))
        end 
    end)
    Timers:CreateTimer(1, function()
        local npc_unit_top2_spawn = Entities:FindByName(nil, "spawn_top2")
        if npc_unit_top2_spawn then
            local origin = npc_unit_top2_spawn:GetAbsOrigin()
            local top_unit_two = CreateUnitByName( "npc_unit_top2", origin, false, nil, nil, DOTA_TEAM_NEUTRALS )
            top_unit_two:SetForwardVector((Vector(0,0,0) - top_unit_two:GetAbsOrigin()):Normalized())
            top_unit_two:AddNewModifier( top_unit_two, nil, "modifier_creator_statue", {id = "1155253013"} )
            top_unit_two:SetAbsOrigin(top_unit_two:GetAbsOrigin() + (Vector(0,0,40)))
        end
    end)
    Timers:CreateTimer(1.5, function()
        local npc_unit_top3_spawn = Entities:FindByName(nil, "spawn_top3")
        if npc_unit_top3_spawn then
            local origin = npc_unit_top3_spawn:GetAbsOrigin()
            local top_unit_three = CreateUnitByName( "npc_unit_top3", origin, false, nil, nil, DOTA_TEAM_NEUTRALS )
            top_unit_three:SetForwardVector((Vector(0,0,0) - top_unit_three:GetAbsOrigin()):Normalized())
            top_unit_three:AddNewModifier( top_unit_three, nil, "modifier_creator_statue", {id = "376804643"} )
            top_unit_three:SetAbsOrigin(top_unit_three:GetAbsOrigin() + (Vector(0,0,20)))
        end
    end)
end

function GameMode:AssembleHeroesData()
    local heroKV = LoadKeyValues("scripts/npc/heroes_list.txt")
    local abilityKV = LoadKeyValues("scripts/npc/npc_abilities_visual.txt")
    for szHeroName, data in pairs(heroKV) do
        if data and type(data) == "table" then
            local heroInfo={}
            heroInfo.szHeroName = szHeroName
            heroInfo.szAttributePrimary = data.AttributePrimary
            CustomNetTables:SetTableValue( "hero_info", szHeroName, heroInfo)
        end
    end
end

function FindTalentValue(abilityKV,heroKV,sTalentName,szHeroName)
    local result = {}
    if abilityKV[sTalentName] then
        local specialVal = abilityKV[sTalentName]["AbilitySpecial"]
        if specialVal then
            for l, m in pairs(specialVal) do
                for k,v in pairs(m) do
                    if k~="var_type" and k~="ad_linked_ability" and k~="ad_linked_abilities" and k~="linked_ad_abilities" then
                        if tonumber(v) then
                            if v == math.floor(v) then
                                table.insert(result, v)
                            else
                                table.insert(result, string.format("%.1f", v))
                            end
                        else
                            table.insert(result, v)
                        end
                    end
                end
            end
        else
            local data = heroKV[szHeroName]
            for i=1,24 do
                if data["Ability"..i] and not string.find(data["Ability"..i], "special_bonus_") then
                   local sAbilityName = data["Ability"..i]
                    if abilityKV[sAbilityName] then
                       local abilityValues = abilityKV[sAbilityName]["AbilityValues"] 
                        if abilityValues then
                            for k, v in pairs(abilityValues) do
                                if type(v) =="table" then
                                    local value = v[sTalentName]
                                    if value then
                                        table.insert(result, value)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return result
end

function GameMode:ReadRoundConfigurations()
    GameMode.vRoundData={}
    GameMode.vRoundDataAbilities={}
    GameMode.vRoundListRaw = {}
    GameMode.vRoundList = {}
    GameMode.vRoundListFull = {}
   
    for i=1, 50 do
        GameMode.vRoundListRaw[i] = {}
        GameMode.vRoundList[i] = {}
    end

    local roundsKV =LoadKeyValues("scripts/kv/rounds.txt")
    local units_txt =LoadKeyValues("scripts/npc/npc_units_custom.txt")

    for sPhase, phaseData in pairs(roundsKV) do
        if phaseData and type(phaseData) == "table" then
            for sRoundName,roundData in pairs(phaseData) do
                if roundData and type(roundData) == "table" then
                    table.insert(GameMode.vRoundListRaw[tonumber(sPhase)], sRoundName)
                    table.insert(GameMode.vRoundList[tonumber(sPhase)], sRoundName)
                    if GetMapName()=="2x6" then
                        for k,vData in pairs(roundData) do
                            vData.UnitNumber = math.ceil(tonumber(vData.UnitNumber)*2)
                        end
                    end
                    GameMode.vRoundData[sRoundName] = roundData
                end
            end
        end
    end

    for i=2,50 do
        if #GameMode.vRoundList[i] < 10 then
            local randomPool = {}

            for j=1, i-1 do
                randomPool=table.join(randomPool,GameMode.vRoundListRaw[j])
            end

            local nToSupplement = 10 - #GameMode.vRoundList[i]
            local supplementList = table.random_some(randomPool, nToSupplement)
            GameMode.vRoundList[i] = table.join(GameMode.vRoundList[i], supplementList)
        end
    end

    GameMode.vRoundListFull = table.deepcopy(GameMode.vRoundList)

    for round_name, round_info in pairs(GameMode.vRoundData) do
        GameMode.vRoundDataAbilities[round_name]={}
        for unit_id, unit_info in pairs(round_info) do
            if units_txt[unit_info.UnitName] then
                for ab = 1, 10 do
                    if units_txt[unit_info.UnitName]["Ability" ..ab] ~= nil and  units_txt[unit_info.UnitName]["Ability"..ab] ~= "" and  units_txt[unit_info.UnitName]["Ability"..ab] ~= "generic_hidden" then
                        table.insert(GameMode.vRoundDataAbilities[round_name], units_txt[unit_info.UnitName]["Ability" ..ab])
                    end
                end
            end
        end
    end

    for phase, rounds in pairs(GameMode.vRoundList) do
        if phase >= 6 then
            local has_randomcreeps = false
            for id, name in pairs(rounds) do
                if name == "Round_RandomCreeps" then
                    has_randomcreeps = true
                end
            end
            if not has_randomcreeps then
                for id, name in pairs(rounds) do
                    if name ~= "Round_Roshan" and name ~= "Round_Nian" then
                        if not has_randomcreeps then
                            GameMode.vRoundList[phase][id] = "Round_RandomCreeps"
                            has_randomcreeps = true
                        end
                    end
                end
            end
        end
    end
end

function GameMode:OnHeroLevelUp(keys)
    local hHero = PlayerResource:GetSelectedHeroEntity(keys.player_id)
    local nLevel = hHero:GetLevel()
    if keys.level == nLevel then
        if nLevel > 25 then
            local nAbilityPoints = hHero:GetAbilityPoints()
            nAbilityPoints = nAbilityPoints + 1
            hHero:SetAbilityPoints(nAbilityPoints)
        end
    end
end

function GameMode:OnPlayerReconnected(keys)
   local retryTimes = 0
   local nPlayerID = keys.PlayerID

   if GameMode.reconnectedConfirm == nil then
      GameMode.reconnectedConfirm ={}
   end

   GameMode.reconnectedConfirm[nPlayerID] = false

   local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
   if hHero and hHero.bSettled then
        HeroBuilder:ReconnectRefundBook(hHero)
   end
   
   Timers:CreateTimer({
        endTime = 5,
        callback = function()
        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
        if hHero then                      
            if retryTimes>50 then
                return nil
            end

            if true~=hHero.bSettled then
                return nil
            end
            
            if hHero.nAbilityNumber then                   
                if hHero.nAbilityNumber< HeroBuilder.totalAbilityNumber[nPlayerID] then
                    HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
                end
            end
        end
        retryTimes = retryTimes + 1
        return 1
    end})
end

function GameMode:cha_update_camera_visible(data)
    if data.PlayerID == nil then return end
    local playerid = data.PlayerID
    local player =  PlayerResource:GetPlayer(playerid)
    if player then
        local hero = player:GetAssignedHero()
        if hero then
            local team_number = hero:GetTeamNumber()
            if GameMode.fow_viwer_teams[team_number] ~= nil then
                RemoveFOWViewer(team_number, GameMode.fow_viwer_teams[team_number])
                GameMode.fow_viwer_teams[team_number] = nil
            end
            local point = Vector(data.x, data.y, data.z)
            local new_fow = AddFOWViewer(team_number, point, 2500, 99999, false)
            GameMode.fow_viwer_teams[team_number] = new_fow
        end
    end
end

function GameMode:BanSystem()
    local ban_timer_stage = 20
    if GameRules:IsCheatMode() then
        ban_timer_stage = 5
    end
    CustomGameEventManager:Send_ServerToAllClients("UpdateTimerBanStage", {time = ban_timer_stage} )
    Timers:CreateTimer(1, function()
        ban_timer_stage = ban_timer_stage - 1
        CustomGameEventManager:Send_ServerToAllClients("UpdateTimerBanStage", {time = ban_timer_stage} )
        if ban_timer_stage <= 0 then
            GameRules:FinishCustomGameSetup()
            return nil
        end
        return 1
    end)
end

function GameMode:OnGameRulesStateChange()
  xpcall( function() 

    local nNewState = GameRules:State_Get()   

    -- Загрузка
    if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        ChaServerData:RegisterSeasonInfo()
        GameRules.vPlayerSteamIdMap={}
        for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
            if PlayerResource:IsValidPlayer( nPlayerID ) then
                local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
                GameRules.sValidePlayerSteamIds=GameRules.sValidePlayerSteamIds..nPlayerSteamId..","
                GameMode.nValidPlayerNumber = GameMode.nValidPlayerNumber + 1
                GameRules.vPlayerSteamIdMap[nPlayerSteamId]=nPlayerID
            end
        end
        if string.sub(GameRules.sValidePlayerSteamIds,string.len(GameRules.sValidePlayerSteamIds))=="," then   
            GameRules.sValidePlayerSteamIds=string.sub(GameRules.sValidePlayerSteamIds,0,string.len(GameRules.sValidePlayerSteamIds)-1)
        end
        ----------------------------------------------------------------------------------------------------------------------------------
    end
  
    -- Выбор героев
    if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        if GameMode.nValidPlayerNumber>1 then
           GameRules:GetGameModeEntity():SetPauseEnabled(false)
        end
        
        Timers:CreateTimer(0.1, function()
            for nPlayerNumber = 0, DOTA_MAX_TEAM_PLAYERS do
                Timers:CreateTimer(0,function()
                    if PlayerResource:IsValidTeamPlayerID(nPlayerNumber) or PlayerResource:IsFakeClient(nPlayerNumber) then
                        local hPlayer = PlayerResource:GetPlayer(nPlayerNumber)
                        if hPlayer then
                            if not IsInToolsMode() and GetMapName() ~= "1x8_pve" then
                                HeroBuilder:MakeRandomHeroSelection(nPlayerNumber)
                            end
                            Timers:CreateTimer(1, function()
                                if GameRules:IsGamePaused() then
                                    return 0.03 
                                end
                                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerNumber) or GameMode.HeroesPlayersList[nPlayerNumber]
                                if not hHero then
                                    return 0.03
                                end
                                Timers:CreateTimer(function()
                                    if not IsValidAlive(hHero) then
                                        hHero:RespawnHero(false, false)
                                    end
                                end)
                                if GameMode.autoDuelMap==nil then
                                    GameMode.autoDuelMap = {}
                                end
                                GameMode.autoDuelMap[nPlayerNumber]=true
                                if GameMode.autoCreepMap==nil then
                                    GameMode.autoCreepMap = {}
                                end
                                GameMode.autoCreepMap[nPlayerNumber]=false                         
                                table.insert(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()], nPlayerNumber)
                                if true~=GameMode.vAliveTeam[hHero:GetTeamNumber()] then
                                    GameMode.vAliveTeam[hHero:GetTeamNumber()] =true
                                    GameMode.nRank = GameMode.nRank + 1
                                    GameMode.nValidTeamNumber = GameMode.nValidTeamNumber + 1
                                    CustomNetTables:SetTableValue("team_rank", tostring(hHero:GetTeamNumber()), {rank=0,defeat_round=0})
                                end
                                CustomNetTables:SetTableValue("pvp_record", tostring(nPlayerNumber), {win=0,lose=0,total_bet_reward=0})
                                Timers:CreateTimer(RandomFloat(0, 0.2), function()
                                    if not hHero.bInited then
                                        HeroBuilder:InitPlayerHero(hHero)
                                    end                               
                                end)
                                if PlayerResource:GetPartyID(nPlayerNumber) and tostring(PlayerResource:GetPartyID(nPlayerNumber))~="0" then
                                    local sPartyID = tostring(PlayerResource:GetPartyID(nPlayerNumber))
                                    if GameMode.partyListMap[sPartyID]==nil then
                                        GameMode.nPartyNumber = GameMode.nPartyNumber + 1
                                        GameMode.partyListMap[sPartyID] = GameMode.nPartyNumber
                                    end     
                                    GameMode.partyNumberMap[nPlayerNumber] = GameMode.partyListMap[sPartyID]
                                end
                                CustomNetTables:SetTableValue("hero_info", "party_map", GameMode.partyNumberMap)
                            end)
                            return nil
                        end
                        return 0.1
                    end
                end)
            end
        end)
    end

    -- Стратегия до 00:00
    if nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        for nPlayerNumber = 0, DOTA_MAX_TEAM_PLAYERS do
            local hPlayer = PlayerResource:GetPlayer(nPlayerNumber)
            if hPlayer then
                if PlayerResource:GetSelectedHeroName(nPlayerNumber)==nil or PlayerResource:GetSelectedHeroName(nPlayerNumber)=="" then
                    hPlayer:MakeRandomHeroSelection()
                end
            end
        end
    end

    -- Пре гейм гдет на выборе
    if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
        ChaServerData.UpdateLastBanneds()

        Timers:CreateTimer(2.0, function()
            CustomGameEventManager:Send_ServerToAllClients("banned_this_game_information", {heroes = Pass.banHeroList, abilities = Pass.banAbilityList} )
            GameMode:SpawnCreators()
        end)

        local retryTimes = 0;
        Timers:CreateTimer(0.5, function()
            if retryTimes<55 then
               for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
                    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                    if hPlayer then
                        HeroBuilder:ShowRandomHeroSelection(nPlayerID)
                        if retryTimes<12 then
                            CustomGameEventManager:Send_ServerToPlayer(hPlayer,"InitFeedback",{})
                        end
                    end
               end
               retryTimes = retryTimes +1
               return 1.0
            else
                return nil
            end
        end)
    end

   -- Прогресс
    if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        GameMode:StartGame()
    end

   end,
     function(e)
        print("------------------ОШИБКА--------------------")
       print(e)
   end)
end

function GameMode:RemoveSmoke(data)
    local unit = data.unit
    if unit ~= nil then
        unit = EntIndexToHScript(unit)
    end
    if unit:HasModifier("modifier_smoke_of_deceit_cha_custom") then
        unit:RemoveModifierByName("modifier_smoke_of_deceit_cha_custom")
    end
end

function spawn_creeps_timer()
    GameMode:AsyncSpawn()
    return 0
end

local spawn_table = {}
local max_per_tick = 6

function GameMode:CreateUnitCustom(name, vector, clear_space, npc_owner, entity_owner, team, callback)
    table.insert(spawn_table, function() 
        callback(CreateUnitByName(name, vector, clear_space, npc_owner, entity_owner, team))
    end)
end

function GameMode:AsyncSpawn()
    local limit = 0
    while true do 
        local callback = spawn_table[1]
    
        if not callback then 
            return 0
        end

        table.remove(spawn_table,1)
        callback()


        limit = limit + 1
        if limit >= max_per_tick then 
            return 0
        end
    end
end

function GameMode:StartGame()
    Notifications:BottomToAll({ text = "#best_tournament_mans", duration = 3, style = { color = "Red" }})
    CreateModifierThinker(nil, nil, "modifier_abilities_optimization_thinker", {}, Vector(0,0,0), DOTA_TEAM_NEUTRALS, false)
    GameRules:GetGameModeEntity():SetThink( spawn_creeps_timer, "spawn_creeps_timer", 0 )
    HeroBuilder:RunAbilitySoundPrecache()
    GameRules.nGameStartTime = GameRules:GetGameTime()
    GameMode.currentRound = Round()
    GameMode.currentRound:Prepare(1)

    -- Запускает проверку на аганим и проверку на дальность от арены
    Util:InitHeroFence()
    Timers:CreateTimer(FrameTime(), function()
        HeroBuilder:FixAttackCapability()
        HeroBuilder:ProcessScepterOwners()
        return FrameTime()
    end)
         
    Timers:CreateTimer(2, function()
        for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
            local bTeamAbandon = true
            for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                if PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED then
                    bTeamAbandon = false
                end
                if ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID] and ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage and ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage_income then
                    table.sort( ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage, function(x,y) return y.damage < x.damage end )
                    CustomNetTables:SetTableValue("spell_damage", tostring(nPlayerID), ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage)

                    table.sort( ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage_income, function(x,y) return y.damage < x.damage end )
                    CustomNetTables:SetTableValue("spell_damage_income", tostring(nPlayerID), ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage_income)
                end
            end
            if bTeamAbandon then
                GameRules.teamAbandonMap[nTeamNumber] = true
            end
        end
        return 2
    end)
end

function GameMode:FinishRound()
    local nRoundNumber = GameMode.currentRound.nRoundNumber
    GameMode.currentRound:End()
    nRoundNumber = nRoundNumber +1 
    GameMode.currentRound= Round()
    GameMode.currentRound:Prepare(nRoundNumber)
end   

function GameMode:SetTeam()
    GameRules.sValidePlayerSteamIds=""
    GameRules.sEarlyLeavePlayerSteamIds=""
    GameRules.sAlwaysEarlyLeavePlayerSteamIds=""
    GameMode.vTeamList = {}
    GameMode.vTeamPlayerMap={}
    GameMode.vAliveTeam = {}
    GameMode.nRank = 0
    GameMode.rankMap = {}
    GameMode.nValidTeamNumber = 0
    GameMode.nValidPlayerNumber = 0
    GameMode.vTeamLocationMap = {}
    GameMode.vTeamStartLocationMap = {}

    for _, hPlayerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
        table.insert(GameMode.vTeamList, hPlayerStart:GetTeam())
        GameMode.vTeamStartLocationMap[hPlayerStart:GetTeam()] = hPlayerStart:GetOrigin()
    end
    
    local nTeamMaxPlayers = 1
    if string.find(GetMapName(),"1x8") then 
       nTeamMaxPlayers = 1
    end

    if GetMapName() == "2x6"  then 
       nTeamMaxPlayers = 2
    end
    
    if GetMapName() == "5v5"  then 
       nTeamMaxPlayers = 5
    end

    for i=1,#GameMode.vTeamList do
        local nTeamNumber = GameMode.vTeamList[i]
        GameRules:SetCustomGameTeamMaxPlayers(nTeamNumber, nTeamMaxPlayers )
        GameMode.vAliveTeam[nTeamNumber] =false
        GameMode.vTeamPlayerMap[nTeamNumber] = {}
        local wayPoint = Entities:FindByName(nil, "center_"..nTeamNumber)
        GameMode.vTeamLocationMap[nTeamNumber] = wayPoint:GetOrigin()
        ExtraCreature.teamCreatureMap[nTeamNumber] = {}
    end
end

function GameMode:ModifyGoldFilter(keys)
    Timers:CreateTimer( GameRules:GetGameFrameTime(), function()
        GameMode:UpdatePlayerGold(keys.player_id_const)
    end)
    if keys.reason_const == DOTA_ModifyGold_HeroKill then
        local playerID = keys.player_id_const
        local heroUnit = playerID and PlayerResource:GetSelectedHeroEntity(playerID)
        if heroUnit then
            if heroUnit:HasModifier("modifier_skill_head_hunter") then
                keys.gold = keys.gold * 4
            end
        end
    end
    return true
end

function GameMode:UpdatePlayerGold(nPlayerID)
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    if hPlayer and GameRules.nGameStartTime then
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "UpdateBetInput", {})
        local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
        nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
        CustomNetTables:SetTableValue("player_info", tostring(nPlayerID), {gold=nGold})
        if nGold >= 150000 then
            Quests_arena:QuestProgress(nPlayerID, 88, 3)
        end
    end
end

function GameMode:OnItemPurchased(keys)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "UpdateBetInput", {})

    local PlayerID = keys.PlayerID
    local item_name = keys.itemname
    local gold_item = keys.itemcost

    if PlayerID ~= nil then
        if item_name == "item_aegis_lua" then
            Quests_arena:QuestProgress(PlayerID, 73, 2)
        end

        local hero = PlayerResource:GetSelectedHeroEntity(PlayerID)

        if hero.cashback_info == nil then
            hero.cashback_info = {}
        end

        if hero and hero:HasModifier("modifier_skill_merchant") then
            Timers:CreateTimer(0, function()
                hero.cashback_info[item_name] = false
                for i=0, 18 do
                    local item = hero:GetItemInSlot(i)
                    if item and item:GetAbilityName() == item_name then
                        item:SetPurchaseTime(0)
                        item:SetSellable(false)
                        Timers:CreateTimer(FrameTime(), function()
                            if item ~= nil and not item:IsNull() then
                                item:SetSellable(true)
                            end
                        end)
                        if hero.cashback_info[item_name] == false then
                            hero.cashback_info[item_name] = true
                            local cashback = gold_item / 100 * 20
                            print("cashback 1")
                            hero:ModifyGold(cashback, true, 0)
                        end
                    end
                end
            end)
        end

        if hero and hero:HasModifier("modifier_skill_highroller") and item_name == "item_relearn_book_lua" then
            Timers:CreateTimer(0, function()
                hero.cashback_info[item_name] = false
                for i=0, 18 do
                    local item = hero:GetItemInSlot(i)
                    if item and item:GetAbilityName() == item_name then
                        item:SetPurchaseTime(0)
                        item:SetSellable(false)
                        Timers:CreateTimer(2, function()
                            if item ~= nil and not item:IsNull() then
                                item:SetSellable(true)
                            end
                        end)
                        if hero.cashback_info[item_name] == false then
                            hero.cashback_info[item_name] = true
                            local cashback = gold_item / 100 * 35
                            print("cashback 2")
                            hero:ModifyGold(cashback, true, 0)
                        end
                    end
                end
            end)
        end

        if hero and hero:HasModifier("modifier_skill_highroller") and (item_name == "item_paragon_book" or item_name == "item_paragon_book_2") then
            Timers:CreateTimer(0, function()
                hero.cashback_info[item_name] = false
                for i=0, 18 do
                    local item = hero:GetItemInSlot(i)
                    if item and item:GetAbilityName() == item_name then
                        item:SetPurchaseTime(0)
                        item:SetSellable(false)
                        Timers:CreateTimer(2, function()
                            if item ~= nil and not item:IsNull() then
                                item:SetSellable(true)
                            end
                        end)
                        if hero.cashback_info[item_name] == false then
                            hero.cashback_info[item_name] = true
                            local cashback = gold_item / 100 * 25
                            print("cashback 3")
                            hero:ModifyGold(cashback, true, 0)
                        end
                    end
                end
            end)
        end

        if hero and hero:HasModifier("modifier_skill_zoo_enjoyer") and string.find(item_name, "item_extra_creature") then
            Timers:CreateTimer(0, function()
                hero.cashback_info[item_name] = false
                for i=0, 18 do
                    local item = hero:GetItemInSlot(i)
                    if item and item:GetAbilityName() == item_name then
                        item:SetPurchaseTime(0)
                        item:SetSellable(false)
                        Timers:CreateTimer(2, function()
                            if item ~= nil and not item:IsNull() then
                                item:SetSellable(true)
                            end
                        end)
                        if hero.cashback_info[item_name] == false then
                            hero.cashback_info[item_name] = true
                            local cashback = gold_item / 100 * 30
                            print("cashback 4")
                            hero:ModifyGold(cashback, true, 0)
                        end
                    end
                end
            end)
        end
    end
end

function GameMode:HeroIconClicked(keys) 
    local nPlayerID = keys.playerId
    local nTargetPlayerID = keys.targetPlayerId
    local nDoubleClick = keys.doubleClick
    local nControldown = keys.controldown
    local nAltDown = keys.altdown
    local hTargetHero =  PlayerResource:GetSelectedHeroEntity(nTargetPlayerID)  

    if hTargetHero then                             
        if nDoubleClick==1 or nControldown==1 then
            PlayerResource:SetCameraTarget(nPlayerID,hTargetHero)
            Timers:CreateTimer({ endTime = 0.1, 
                callback = function()
                PlayerResource:SetCameraTarget(nPlayerID,nil) 
            end})
        end
    end

    if hTargetHero and nAltDown==1 then
        if PlayerResource:GetPlayer(nPlayerID) then
        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if hHero then
                if nPlayerID~=nTargetPlayerID then
                    hHero.sActorUISecret = CreateSecretKey()
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"ShowActorPanel",{target_player_id=nTargetPlayerID, time=GameMode.reportActorTime[nPlayerID]} );
                end
            end
        end
    end
end

function GameMode:ToggleAutoDuel(keys)
    local nPlayerID = keys.PlayerID
    local bSelected = (1==keys.selected)
    if nPlayerID and GameMode.autoDuelMap then
        GameMode.autoDuelMap[nPlayerID]=bSelected
    end
end

function GameMode:ToggleAutoCreep(keys)
    local nPlayerID = keys.PlayerID
    local bSelected = (1==keys.selected)
    if nPlayerID and GameMode.autoCreepMap then
        GameMode.autoCreepMap[nPlayerID]=bSelected
    end
end

function GameMode:TeamLose(nTeamNumber)
    GameMode.vAliveTeam[nTeamNumber] = false
    local data={}
    data.type = "team_lose"
    data.nTeamNumber = nTeamNumber
    Barrage:FireBullet(data)

    for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
        if nPlayerID and GameMode.nRank then
            ChaServerData.SetPlayerStatsGameEnd(nPlayerID, GameMode.nRank)
        end
        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
        if hHero then
            hHero:SetGold(0, true)
        end
    end

    if GameMode.currentRound.spanwers[nTeamNumber]  then
        GameMode.currentRound.spanwers[nTeamNumber].bForceStop = true
        for i, hCreep in ipairs( GameMode.currentRound.spanwers[nTeamNumber].vCurrentCreeps ) do
            if hCreep and (not hCreep:IsNull()) and  hCreep:IsAlive() then
                hCreep.nSpawnerTeamNumber =nil
                hCreep:ForceKill(false)
            end
        end            
    end

    Util:CleanPvpPair(nTeamNumber)

    if GameMode.nValidTeamNumber == 1 and GameMode.nRank == 1 then 
        if string.find(GetMapName(),"1x8") then
            if not GameRules:IsCheatMode() or (IsInToolsMode()) then
                if GetMapName() == "1x8_pve" then
                    ChaServerData.PostDataPVE()
                    GameRules:SetGameWinner(nTeamNumber)
                end
            else
                Notifications:BottomToAll({ text = "#cheat_no_record", duration = 4, style = { color = "Red" }})
                Timers:CreateTimer(4, function()
                    GameRules:SetGameWinner(nTeamNumber)
                end)
            end
        end
        if GetMapName()=="2x6" or GetMapName()=="5v5" then
            Notifications:BottomToAll({ text = "#one_team_in_multi_map_no_record", duration = 4, style = { color = "Red" }})
            Timers:CreateTimer(4, function()
                GameRules:SetGameWinner(nTeamNumber)
            end)
        end
    else
        if GameMode.nValidTeamNumber >= 2 and GameMode.nRank == 2 then
            local nWinnerTeam 
            for nAliveTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
                 if bAlive then
                     nWinnerTeam = nAliveTeamNumber
                 end
            end
            GameMode.rankMap[2] = nTeamNumber
            CustomNetTables:SetTableValue("team_rank", tostring(nTeamNumber), {rank=2,defeat_round=GameMode.currentRound.nRoundNumber})
            GameMode.rankMap[1] = nWinnerTeam
            CustomNetTables:SetTableValue("team_rank", tostring(nWinnerTeam), {rank=1,defeat_round=GameMode.currentRound.nRoundNumber})
            if (not GameRules:IsCheatMode() or IsInToolsMode()) then
                if GetMapName()=="5v5" then
                    Notifications:BottomToAll({ text = "#5v5_no_record", duration = 4, style = { color = "Red" } })
                    Timers:CreateTimer(4, function()
                        GameRules:SetGameWinner(nWinnerTeam)
                    end)
                else
                    for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nWinnerTeam]) do
                        if nPlayerID then
                            Quests_arena:QuestProgress(nPlayerID, 58, 2)
                            Quests_arena:QuestProgress(nPlayerID, 79, 3)
                            ChaServerData.SetPlayerStatsGameEnd(nPlayerID, 1)
                        end
                    end
                    ChaServerData.PostData()
                    GameRules:SetGameWinner(nWinnerTeam)
                end
            else
                Notifications:BottomToAll({ text = "#cheat_no_record", duration = 4, style = { color = "Red" } })
                Timers:CreateTimer(4, function()
                    GameRules:SetGameWinner(nWinnerTeam)
                end)
            end
            GameMode.nRank = GameMode.nRank-1
        else
            for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                if hPlayer then
                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPlayerLose",{game_rank= GameMode.nRank,valid_team=GameMode.nValidTeamNumber})
                end
                if GameMode.nRank <= 4 then
                    Quests_arena:QuestProgress(nPlayerID, 21, 1)
                end
            end
            GameMode.rankMap[GameMode.nRank] = nTeamNumber
            CustomNetTables:SetTableValue("team_rank", tostring(nTeamNumber), {rank=GameMode.nRank,defeat_round=GameMode.currentRound.nRoundNumber})
            GameMode.nRank = GameMode.nRank -1
        end
    end
end

function GameMode:OnPlayerUsedAbility(keys)
   HeroBuilder:RefreshAbilityOrder(keys.PlayerID)
end

function GameMode:ClientReconnected(keys)
    local nPlayerID = keys.PlayerID
    if GameMode.reconnectedConfirm then
        GameMode.reconnectedConfirm[nPlayerID] = true
    end
end

function GameMode:OnHeroLearnAbility(keys)
   local hHero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
   if "lone_druid_true_form_custom" == keys.abilityname and hHero and hHero:IsRealHero() and not hHero:IsTempestDouble() and not hHero:HasModifier("modifier_arc_warden_tempest_double_lua") then
       local hAbility1 = hHero:FindAbilityByName("lone_druid_true_form_druid") 
       if hAbility1 then
            hAbility1:SetLevel(hAbility1:GetLevel()+1)
       end
       local hAbility2 = hHero:FindAbilityByName("lone_druid_true_form_battle_cry") 
       if hAbility2 then
           hAbility2:SetLevel(hAbility2:GetLevel()+1)
       end
   end
    if "lone_druid_true_form_druid" ==  keys.abilityname and hHero and hHero:IsRealHero() and not hHero:IsTempestDouble() and not hHero:HasModifier("modifier_arc_warden_tempest_double_lua") then
        local hAbility1 = hHero:FindAbilityByName("lone_druid_true_form_battle_cry") 
        if hAbility1 then
           hAbility1:SetLevel(hAbility1:GetLevel()+1)
        end
    end
end

function GameMode:GetAllTeamInfo()
    local nMaxTeamNumber = 8
    local nMaxPerTeam = 1
    if string.find(GetMapName(),"1x8") then
        nMaxTeamNumber = 8
        nMaxPerTeam = 1
    end
    if GetMapName()== "2x6" then
        nMaxTeamNumber = 6
        nMaxPerTeam = 2
    end
    if GetMapName()== "5v5" then
        nMaxTeamNumber = 2
        nMaxPerTeam = 5
    end
    return nMaxTeamNumber,nMaxPerTeam
end

function GameMode:OnNPCSpawned(keys)
    local hSpawnedUnit = EntIndexToHScript(keys.entindex)
    if hSpawnedUnit then
        Timers:CreateTimer(0.1, function()
            Illusion:InitIllusion(hSpawnedUnit)
        end)
        hSpawnedUnit:RemoveModifierByName("modifier_fountain_invulnerability")
        local hOwner = hSpawnedUnit:GetOwner()
        if hOwner and hOwner.HasModifier and hOwner:HasModifier("modifier_hero_refreshing") then
            if hSpawnedUnit and hSpawnedUnit:GetUnitName()=="npc_dota_phoenix_sun" then
                hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_hero_refreshing", {})
            end
            if hSpawnedUnit and (hSpawnedUnit:GetName() == "npc_dota_brewmaster_storm" or hSpawnedUnit:GetName() == "npc_dota_brewmaster_fire"  or hSpawnedUnit:GetName() == "npc_dota_brewmaster_earth")  then
                hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_hero_refreshing", {})
            end
        end
        if hSpawnedUnit and hSpawnedUnit:IsRealHero() and hSpawnedUnit.inmassive == nil then
            GameMode.HeroesPlayersList[hSpawnedUnit:GetPlayerID()] = hSpawnedUnit
            hSpawnedUnit.inmassive = true
        end
        if IsInToolsMode() then
            if hSpawnedUnit:IsRealHero() then
                Timers:CreateTimer(RandomFloat(0, 0.2), function()
                    if not hSpawnedUnit.bInited then
                        HeroBuilder:InitPlayerHero(hSpawnedUnit)
                    end                               
                end)
                if GameMode.autoDuelMap==nil then
                    GameMode.autoDuelMap = {}
                end
                if GameMode.autoCreepMap==nil then
                    GameMode.autoCreepMap = {}
                end
                GameMode.autoDuelMap[hSpawnedUnit:GetPlayerOwnerID()]=true
                GameMode.autoCreepMap[hSpawnedUnit:GetPlayerOwnerID()]=false                         
                table.insert(GameMode.vTeamPlayerMap[hSpawnedUnit:GetTeamNumber()], hSpawnedUnit:GetPlayerOwnerID())
                if true~=GameMode.vAliveTeam[hSpawnedUnit:GetTeamNumber()] then
                    GameMode.vAliveTeam[hSpawnedUnit:GetTeamNumber()] =true
                    GameMode.nRank = GameMode.nRank + 1
                    GameMode.nValidTeamNumber = GameMode.nValidTeamNumber + 1
                    CustomNetTables:SetTableValue("team_rank", tostring(hSpawnedUnit:GetTeamNumber()), {rank=0,defeat_round=0})
                end
                CustomNetTables:SetTableValue("pvp_record", tostring(hSpawnedUnit:GetPlayerOwnerID()), {win=0,lose=0,total_bet_reward=0})
            end
        end
        if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit.GetUnitName and  hSpawnedUnit:GetUnitName() and not hSpawnedUnit:IsIllusion() and not hSpawnedUnit:IsTempestDouble() and not hSpawnedUnit:HasModifier("modifier_arc_warden_tempest_double_lua") then
            if hSpawnedUnit:IsSummoned() or Summon.efficiency[hSpawnedUnit:GetUnitName()] then
                local flWaitTime = 0
                if "npc_dota_clinkz_skeleton_archer" == hSpawnedUnit:GetUnitName() then
                    hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_clinkz_skeletons", {})
                    flWaitTime=0.1  
                end
                Timers:CreateTimer(flWaitTime, function()               
                    if not hSpawnedUnit or hSpawnedUnit:IsNull() then return end
                    local hOwner = hSpawnedUnit:GetOwner()
                    if hOwner and hOwner:IsRealHero() then
                        if hOwner:HasModifier("modifier_item_summoner_crown") or hOwner:HasModifier("modifier_item_wraith_dominator") then
                            local flEfficiency = Summon.efficiency[hSpawnedUnit:GetUnitName()] or 1.0
                            if hOwner:HasAbility("special_bonus_unique_furion") and Summon.treant[hSpawnedUnit:GetUnitName()] then
                                local hTalent = hOwner:FindAbilityByName("special_bonus_unique_furion")
                                if hTalent:GetLevel() > 0 then
                                    flEfficiency = flEfficiency * 0.6
                                end
                            end
                            local hSourceItem = hOwner:FindItemInInventory("item_wraith_dominator") or hOwner:FindItemInInventory("item_summoner_crown_3") or hOwner:FindItemInInventory("item_summoner_crown_2") or hOwner:FindItemInInventory("item_summoner_crown_1")
                            if hSourceItem and not hSourceItem:IsNull() then
                                local hBuffAgi = hSpawnedUnit:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_buff_agi", {})
                                if (not hBuffAgi) or hBuffAgi:IsNull() then
                                    return nil
                                end
                                hBuffAgi:SetStackCount(hOwner:GetAgility() * flEfficiency)                          
                                local hBuffInt = hSpawnedUnit:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_buff_int", {})
                                hBuffInt:SetStackCount(hOwner:GetIntellect() * flEfficiency)
                                hSpawnedUnit:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_model_size", {})
                                Timers:CreateTimer(FrameTime(), function()                             
                                    if hSourceItem and not hSourceItem:IsNull() then
                                        if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit:IsAlive() then
                                            local nCurrentHealth = hSpawnedUnit:GetMaxHealth()                     
                                            if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then
                                                nCurrentHealth = 2000 + 75 * hSpawnedUnit:GetLevel()
                                            end
                                          
                                            if nCurrentHealth>1 then
                                                hSpawnedUnit.nOldHealth = nCurrentHealth
                                                local nNewHealth = math.floor(nCurrentHealth * (1 + 0.01 * hOwner:GetStrength() * flEfficiency * hSourceItem:GetSpecialValueFor("hp_bonus_per_str") ))
                                                if nNewHealth>1 then
                                                    hSpawnedUnit:SetBaseMaxHealth(nNewHealth)
                                                    hSpawnedUnit:SetMaxHealth(nNewHealth)
                                                    hSpawnedUnit:SetHealth(nNewHealth)
                                                end
                                            end
                                        end
                                    end
                                end)
                                if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then 
                                    if hOwner and hOwner:IsRealHero() and hOwner.bUsedBearDarkMoon and  not hSpawnedUnit:HasModifier("modifier_item_dark_moon_shard") then
                                        hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_item_dark_moon_shard", {})
                                    end
                                end     
                            end               
                        else
                            hSpawnedUnit:RemoveModifierByName("modifier_item_summoner_crown_buff_agi")
                            hSpawnedUnit:RemoveModifierByName("modifier_item_summoner_crown_buff_int")
                            hSpawnedUnit:RemoveModifierByName("modifier_item_summoner_crown_model_size")
                            Timers:CreateTimer(FrameTime(), function()
                                if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then
                                    local nCurrentHealth = 2000 + 75 * hSpawnedUnit:GetLevel()
                                    hSpawnedUnit:SetBaseMaxHealth(nCurrentHealth)
                                    hSpawnedUnit:SetMaxHealth(nCurrentHealth)
                                    hSpawnedUnit:SetHealth(nCurrentHealth)
                                end
                            end)
                        end
                        if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then 
                            if hOwner and hOwner:IsRealHero() and hOwner.bUsedBearDarkMoon and  not hSpawnedUnit:HasModifier("modifier_item_dark_moon_shard") then
                                hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_item_dark_moon_shard", {})
                            end
                        end 
                    end     
                end)
                if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then 
                    Timers:CreateTimer(2.0, function()
                       if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit:IsAlive() then
                            Summon:RefreshBear(hSpawnedUnit)
                            return 2.0
                        else
                            return nil
                        end
                    end) 
                end
            end
        end
    end
end

function GameMode:OnConnectFull(data)
    local player_index = EntIndexToHScript( data.index )
    if player_index == nil then
        return
    end
    local hPlayer = PlayerResource:GetPlayer(data.PlayerID)
    if hPlayer then
        CustomGameEventManager:Send_ServerToPlayer(hPlayer,"loading_screen_event",{})
    end
    ChaServerData:RegisterPlayerSiteInfo(data.PlayerID)
end