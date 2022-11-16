LinkLuaModifier("modifier_top1_season", "modifiers/modifier_top1_season", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_top2_season", "modifiers/modifier_top2_season", LUA_MODIFIER_MOTION_NONE)

if Pass == nil then Pass = class({}) end

function Pass:Init()

    CustomGameEventManager:RegisterListener("BanAbility",function(_, keys)
        self:BanAbility(keys)
    end)

    CustomGameEventManager:RegisterListener("BanHero",function(_, keys)
        self:BanHero(keys)
    end)

    CustomGameEventManager:RegisterListener("PlayerTip",function(_, keys)
        self:PlayerTip(keys)
    end)

    CustomGameEventManager:RegisterListener("PauseGame",function(_, keys)
        self:PauseGame(keys)
    end)

    CustomGameEventManager:RegisterListener("BattlePassBuy",function(_, keys)
        self:BattlePassBuy(keys)
    end)

    CustomGameEventManager:RegisterListener("SwapCurrency",function(_, keys)
        self:SwapCurrency(keys)
    end)

    CustomGameEventManager:RegisterListener("RewardAccept",function(_, keys)
        self:RewardAccept(keys)
    end)

    CustomGameEventManager:RegisterListener("SelectVO",function(_, keys)
        self:SelectVO(keys)
    end)

    CustomGameEventManager:RegisterListener("SelectSmile",function(_, keys)
        self:SelectSmile(keys)
    end)

    CustomGameEventManager:RegisterListener("RollChestStart",function(_, keys)
        self:RollChestStart(keys)
    end)

    CustomGameEventManager:RegisterListener("SelectChatWheel",function(_, keys)
        self:SelectChatWheel(keys)
    end)

    CustomGameEventManager:RegisterListener("change_nickname_customize",function(_, keys)
        self:change_nickname_customize(keys)
    end)

    CustomGameEventManager:RegisterListener("change_frame_customoze",function(_, keys)
        self:change_frame_customoze(keys)
    end)

    CustomGameEventManager:RegisterListener("change_effect_customoze",function(_, keys)
        self:change_effect_customoze(keys)
    end)
    CustomGameEventManager:RegisterListener("rating_reset",function(_, keys)
        self:rating_reset(keys)
    end)


    
    Pass.passInfo = {}
    
    Pass.steamPassInfo = {}

    
    Pass.banAbilityTime = {}    
    Pass.banAbilityList = {}

    
    Pass.banHeroTime = {}
    Pass.PauseCount = {}
    Pass.banHeroList = {}
    Pass.LeavePauseCount = {}
    Pass.RerollHeroCount = {}

    Pass.PauseCooldown = 0

    Pass.PauseOwner = nil

    Pass.blinkEffects = {"ti10_blink","ti9_blink","ti8_blink","ti7_blink","ti6_blink","ti5_blink","ti4_blink"}
    Pass.attackEffects = {"ti10_attack","ti9_attack","coconut","durian","desolation_fire","gift","virgas"}

    Pass.BattlePassPrice = {}

    Pass.PlayerPauseCooldown = {}
    Pass.PlayerLeavePauseCooldown = {}

    Pass.BattlePassPrice[1] = {
      [1] = 150,
      [3] = 450,
      [6] = 900,
      [12] = 1800,
    }

    Pass.BattlePassPrice[2] = {
      [1] = 250,
      [3] = 700,
      [6] = 1300,
      [12] = 2500,
    }

    Pass.BattlePassPrice[3] = {
      [1] = 400,
      [3] = 1100,
      [6] = 2100,
      [12] = 4000,
    }

    Pass.BattlePassDuration = {
      [1] = 30,
      [3] = 90,
      [6] = 180,
      [12] = 360,
    }

    Pass.rewards_data = 
    {
      --battlepass
      -- arena coin
      -- item id
      -- donate coin
      -- recalibrovka

      [1] = {0, 30, 0, 0, 0},
      [2] = {0, 50, 0, 0, 0},
      [3] = {0, 70, 0, 0, 0},
      [4] = {0, 100, 0, 0, 0},
      [5] = {0, 150, 0, 0, 0},
      [6] = {0, 0, 0, 50, 0},
      [7] = {3, 0, 0, 0, 0},
      [8] = {0, 30, 0, 0, 0},
      [9] = {0, 50, 0, 0, 0},
      [10] = {0, 70, 0, 0, 0},
      [11] = {0, 100, 0, 0, 0},
      [12] = {0, 150, 0, 0, 0},
      [13] = {0, 0, 0, 100, 0},
      [14] = {0, 0, 0, 0, 1},
      [15] = {3, 0, 0, 0, 0},
    }

    Pass.wheel_rewards_list = {
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      51,
      52,
      53,
      54,
      55,
      56,
      57,
      58,
      59,
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
      71,
      72,
      73,
      74,
      75,
      76,
      77,
      78,
      79,
      80,
      81,
      82,
      104,
      105,
      106,
      107,
      108,
      109,
      112,
      113,
      114,
      115,
      116,
      117,
      118,
      120,
      121,
      123,
      124,
    }

    Pass.wheel_rare_rewards_list = {
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      83,
      84,
      85,
      86,
      87,
      88,
      89,
      90,
      91,
      92,
      93,
      94,
      95,
      103,
      112,
      111,
      119,
      122,
      125,
      126,
    }
end

function Pass:SelectChatWheel(keys)
  if keys.PlayerID == nil then return end
  local id_chatwheel = tostring(keys.id)
  local item_chatwheel = tostring(keys.item)
  local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(keys.PlayerID))
  if player_table then
    if player_table.chat_wheel then
      local player_chat_wheel_change = {}
      for k, v in pairs(player_table.chat_wheel) do
            player_chat_wheel_change[k] = v
        end
        player_chat_wheel_change[id_chatwheel] = item_chatwheel
        player_table.chat_wheel = player_chat_wheel_change
        CustomNetTables:SetTableValue('cha_server_data', tostring(keys.PlayerID), player_table)
    end
  end
end

function Pass:change_nickname_customize(keys)
    if keys.PlayerID == nil then return end
    local id = keys.id
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(keys.PlayerID))
    if player_table then
        player_table.nickname = id
    end
    CustomNetTables:SetTableValue('cha_server_data', tostring(keys.PlayerID), player_table)
end

function Pass:change_frame_customoze(keys)
    if keys.PlayerID == nil then return end
    local id = keys.id
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(keys.PlayerID))
    if player_table then
        player_table.frame = id
    end
    CustomNetTables:SetTableValue('cha_server_data', tostring(keys.PlayerID), player_table)
end

function Pass:change_effect_customoze(keys)
    if keys.PlayerID == nil then return end
    local id = keys.id
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(keys.PlayerID))
    if player_table then
        player_table.effect = id
    end

    if id == 0 then
        local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
        if hero then
            hero:RemoveModifierByName("modifier_top1_season")
            hero:RemoveModifierByName("modifier_top2_season")
        end
    end

    if id == 1 then
        local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
        if hero then
            hero:RemoveModifierByName("modifier_top2_season")
            hero:AddNewModifier(hero, nil, "modifier_top1_season", {})
        end
    end

    if id == 2 then
        local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
        if hero then
            hero:RemoveModifierByName("modifier_top1_season")
            hero:AddNewModifier(hero, nil, "modifier_top2_season", {})
        end
    end

    CustomNetTables:SetTableValue('cha_server_data', tostring(keys.PlayerID), player_table)
end

function Pass:rating_reset(keys)
    if keys.PlayerID == nil then return end
    local id = keys.id
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(keys.PlayerID))

    if player_table then
        if player_table.ticket_calibrate > 0 then
            player_table.ticket_calibrate = player_table.ticket_calibrate - 1
            local player = PlayerResource:GetPlayer(keys.PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_accept", {})
            end
            ChaServerData.RecalibratingPlayer(keys.PlayerID)
        else
            local player = PlayerResource:GetPlayer(keys.PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_no_ticket"})
            end
            return
        end
    else
        local player = PlayerResource:GetPlayer(keys.PlayerID)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_server_disconnect"})
        end
        return
    end

    CustomNetTables:SetTableValue('cha_server_data', tostring(keys.PlayerID), player_table)
end

function Pass:BattlePassBuy(keys)
    local playerid = keys.PlayerID
    local coin_type = keys.coin_type
    local level = keys.level
    local duration_type = keys.duration_type
    local player_arena_coin = 0
    local player_donate_coin = 0
    local player_table_info = CustomNetTables:GetTableValue('cha_server_data', tostring(playerid))

    if player_table_info then
        player_arena_coin = player_table_info.game_coin
        player_donate_coin = player_table_info.donate_coin
    else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_server_disconnect"})
        end
        return
    end

    if coin_type == "arena" then
      if player_arena_coin >= 2000 then
        player_table_info.pass_level_1_days = player_table_info.pass_level_1_days + Pass.BattlePassDuration[duration_type]
        player_table_info.game_coin = player_table_info.game_coin - 2000
        player_table_info.ticket_calibrate = player_table_info.ticket_calibrate + 1
        CustomNetTables:SetTableValue("cha_server_data", tostring(playerid), player_table_info)
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_accept", {})
        end
        ChaServerData.AddBattlePassPlayer(playerid, coin_type, Pass.BattlePassDuration[duration_type], level, 2000)
        Pass:InitPassData(playerid)
      else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_no_arena_coin"})
        end
        return
      end
    elseif coin_type == "donate" then
      if player_donate_coin >= Pass.BattlePassPrice[level][duration_type] then
        if level == 3 then
          player_table_info.pass_level_3_days = player_table_info.pass_level_3_days + Pass.BattlePassDuration[duration_type]
          player_table_info.ticket_calibrate = player_table_info.ticket_calibrate + 1
        elseif level == 2 then
          player_table_info.pass_level_2_days = player_table_info.pass_level_2_days + Pass.BattlePassDuration[duration_type]
          player_table_info.ticket_calibrate = player_table_info.ticket_calibrate + 1
        elseif level == 1 then
          player_table_info.pass_level_1_days = player_table_info.pass_level_1_days + Pass.BattlePassDuration[duration_type]
        end
        player_table_info.donate_coin = player_table_info.donate_coin - Pass.BattlePassPrice[level][duration_type]
        CustomNetTables:SetTableValue("cha_server_data", tostring(playerid), player_table_info)
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_accept", {})
        end
        ChaServerData.AddBattlePassPlayer(playerid, coin_type, Pass.BattlePassDuration[duration_type], level, Pass.BattlePassPrice[level][duration_type])
        Pass:InitPassData(playerid)
      else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_no_donate_coin"})
        end
        return
      end
    end
end



function Pass:SwapCurrency(keys)
    local playerid = keys.PlayerID
    local donate_coin_swap = keys.donate
    local arena_coin_swap = keys.arena
    local player_arena_coin = 0
    local player_donate_coin = 0
    local player_table_info = CustomNetTables:GetTableValue('cha_server_data', tostring(playerid))

    if player_table_info then
        player_arena_coin = player_table_info.game_coin
        player_donate_coin = player_table_info.donate_coin
    else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_server_disconnect"})
        end
        return
    end

    if player_donate_coin >= donate_coin_swap then
      player_table_info.donate_coin = player_table_info.donate_coin - donate_coin_swap
      player_table_info.game_coin = player_table_info.game_coin + arena_coin_swap
      CustomNetTables:SetTableValue("cha_server_data", tostring(playerid), player_table_info)
      ChaServerData.SwapCurrency(playerid, donate_coin_swap, arena_coin_swap)
      local player = PlayerResource:GetPlayer(playerid)
      if player then
          CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_accept", {})
      end
    else
      local player = PlayerResource:GetPlayer(playerid)
      if player then
          CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_no_donate_coin"})
      end
    end
end

function Pass:RewardAccept(keys)
    local playerid = keys.PlayerID
    local reward_name = keys.reward_name
    local day = tonumber(keys.day)
    local player_arena_coin = 0
    local player_donate_coin = 0
    local player_table_info = CustomNetTables:GetTableValue('cha_server_data', tostring(playerid))

    if player_table_info then
        player_arena_coin = player_table_info.game_coin
        player_donate_coin = player_table_info.donate_coin
    else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_server_disconnect"})
        end
        return
    end

    if player_table_info.month_days_disabled == 1 then
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "reward_error_has_received"})
        end
        return
    end

    player_table_info.month_days_disabled = 1

    if Pass.rewards_data[day][1] > 0 then
      player_table_info.pass_level_3_days = player_table_info.pass_level_3_days + Pass.rewards_data[day][1]
    end

    if Pass.rewards_data[day][2] > 0 then
      player_table_info.game_coin = player_table_info.game_coin + Pass.rewards_data[day][2]
    end

    if Pass.rewards_data[day][4] > 0 then
      player_table_info.donate_coin = player_table_info.donate_coin + Pass.rewards_data[day][4]
    end

    if Pass.rewards_data[day][5] > 0 then
      player_table_info.ticket_calibrate = player_table_info.ticket_calibrate + Pass.rewards_data[day][5]
    end

    local player_items_table = {}

    for k, v in pairs(player_table_info.player_items) do
        table.insert(player_items_table, v)
    end

    if Pass.rewards_data[day][3] > 0 then
        table.insert(player_items_table, Pass.rewards_data[day][3])
        player_table_info.player_items = player_items_table
    end

    CustomNetTables:SetTableValue("cha_server_data", tostring(playerid), player_table_info)
    ChaServerData.GiveReward(playerid, Pass.rewards_data[day][1], Pass.rewards_data[day][2], Pass.rewards_data[day][3], Pass.rewards_data[day][4], Pass.rewards_data[day][5])

    local player = PlayerResource:GetPlayer(playerid)
    if player then
      CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_accept", {})
    end
end

function Pass:BanHero(keys)
    
    if Pass.passInfo[keys.PlayerID] and keys.heroName then
       if Pass.banHeroTime[keys.PlayerID] and Pass.banHeroTime[keys.PlayerID]>0 then
          local sHeroName =  "npc_dota_hero_"..keys.heroName
          CustomGameEventManager:Send_ServerToAllClients( 'UpdatebanHero', {hero = keys.heroName})
          table.remove_item(HeroBuilder.allHeroeNames,sHeroName)
          table.remove_item(GameRules.heroesPoolList_strength_list,sHeroName)
          table.remove_item(GameRules.heroesPoolList_agility_list,sHeroName)
          table.remove_item(GameRules.heroesPoolList_intellect_list,sHeroName)
          Pass.banHeroTime[keys.PlayerID] = Pass.banHeroTime[keys.PlayerID]-1
          CustomNetTables:SetTableValue("ban_count", tostring(keys.PlayerID), {ban_count_hero = Pass.banHeroTime[keys.PlayerID], ban_count_ability = Pass.banAbilityTime[keys.PlayerID]})
          if not table.contains(Pass.banHeroList,sHeroName) then
            table.insert(Pass.banHeroList, sHeroName)
            CustomNetTables:SetTableValue("hero_info", "hero_abilities", Pass.banHeroList)
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[keys.PlayerID] ~= nil then
                table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[keys.PlayerID].current_ban_heroes, sHeroName)
            end
          end
       end
    end
end

function Pass:PauseDisconnectPlayer(id)
    if Pass.LeavePauseCount[id] == nil then
      Pass.LeavePauseCount[id] = 1
    end
    if Pass.LeavePauseCount[id] >= 2 then
      return
    else
      Pass.LeavePauseCount[id] = Pass.LeavePauseCount[id] + 1
    end

    local hHero = PlayerResource:GetSelectedHeroEntity(id) 
    if hHero and not hHero:IsNull() and hHero:IsAlive() then
      if Pass.PlayerLeavePauseCooldown[id] and Pass.PlayerLeavePauseCooldown[id] <= 0 and not GameRules:IsGamePaused() then
          PauseGame(true)
          Pass.PauseOwner = id
          CustomNetTables:SetTableValue("pause_owner", "owner", {owner = id})
          Pass.PauseCooldown = 20
          Timers:CreateTimer({
            useGameTime = false,
            endTime = 1,
            callback = function()
              if Pass.PauseCooldown <= 0 then return nil end
              if PlayerResource:GetConnectionState(id) ~= nil and (PlayerResource:GetConnectionState(id) == DOTA_CONNECTION_STATE_ABANDONED or PlayerResource:GetConnectionState(id) == DOTA_CONNECTION_STATE_UNKNOWN or PlayerResource:GetConnectionState(id) == DOTA_CONNECTION_STATE_CONNECTED ) then
                PauseGame(false)
                Pass.PauseOwner = nil
                Pass.PauseCooldown = 0
              end
              Pass.PauseCooldown = Pass.PauseCooldown - 1
              return 1
            end
          })
          Pass.PlayerLeavePauseCooldown[id] = 120
          Timers:CreateTimer({
            useGameTime = false,
            endTime = 1,
            callback = function()
              if Pass.PlayerLeavePauseCooldown[id] <= 0 then return nil end
              Pass.PlayerLeavePauseCooldown[id] = Pass.PlayerLeavePauseCooldown[id] - 1
              return 1
            end
          })
      end
    end
end

function Pass:PauseGame(keys)
    if GameRules:IsGamePaused() then
        if Pass.PauseOwner ~= keys.PlayerID and Pass.PauseCooldown > 0 then
            local player = PlayerResource:GetPlayer(keys.PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#cha_pause_cooldown_on", time =Pass.PauseCooldown})
            end
            return
        end
        PauseGame(false)
        CustomGameEventManager:Send_ServerToAllClients("player_unpause_chat", {id = keys.PlayerID})
        Pass.PauseOwner = nil
    else
        if Pass.PauseCount[keys.PlayerID] ~= nil and Pass.PauseCount[keys.PlayerID] <= 0 then
            local player = PlayerResource:GetPlayer(keys.PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#cha_pause_count_null", time=""})
            end
            return
        end
        if Pass.PlayerPauseCooldown[keys.PlayerID] ~= nil and Pass.PlayerPauseCooldown[keys.PlayerID] > 0 then
            local player = PlayerResource:GetPlayer(keys.PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#cha_pause_cooldown_off", time=Pass.PlayerPauseCooldown[keys.PlayerID]})
            end
            return
        end
        if Pass.PauseCount[keys.PlayerID] ~= nil and Pass.PauseCount[keys.PlayerID]>0 then
            Pass.PauseCount[keys.PlayerID] = Pass.PauseCount[keys.PlayerID] - 1
            PauseGame(true)
            Pass.PauseOwner = keys.PlayerID
            CustomNetTables:SetTableValue("pause_owner", "owner", {owner = keys.PlayerID})
            Pass.PauseCooldown = 15
            Timers:CreateTimer({
              useGameTime = false,
              endTime = 1,
              callback = function()
                if Pass.PauseCooldown <= 0 then return nil end
                Pass.PauseCooldown = Pass.PauseCooldown - 1
                return 1
              end
            })
            Pass.PlayerPauseCooldown[keys.PlayerID] = 120
            Timers:CreateTimer({
              useGameTime = false,
              endTime = 1,
              callback = function()
                if Pass.PlayerPauseCooldown[keys.PlayerID] <= 0 then return nil end
                Pass.PlayerPauseCooldown[keys.PlayerID] = Pass.PlayerPauseCooldown[keys.PlayerID] - 1
                return 1
              end
            })
        end
    end
end

function Pass:PlayerTip(keys)
    local cooldown = 60
    if IsInToolsMode() then
      cooldown = 1
    end
    local id_caster = keys.PlayerID
    local id_target = keys.player_id_tip

    CustomGameEventManager:Send_ServerToAllClients( 'TipPlayerNotification', {player_id_1 = id_caster, player_id_2 = id_target})

    if Pass.passInfo[keys.PlayerID] then
        CustomNetTables:SetTableValue("tip_cooldown", tostring(id_caster), {cooldown = cooldown})
        Timers:CreateTimer(1, function()
          cooldown = cooldown - 1
          CustomNetTables:SetTableValue("tip_cooldown", tostring(id_caster), {cooldown = cooldown})
          if cooldown <= 0 then return nil end
          return 1
        end)
    end
end

function Pass:BanAbility(keys)
    
    if Pass.passInfo[keys.PlayerID] then
       if Pass.banAbilityTime[keys.PlayerID] and Pass.banAbilityTime[keys.PlayerID]>0 then
         
          if table.contains(HeroBuilder.allAbilityNames,keys.abilityName) then
            table.remove_item(HeroBuilder.allAbilityNames,keys.abilityName)
          end
          
          local sHeroName = HeroBuilder.abilityHeroMap[keys.abilityName]
          
          if not sHeroName then
             return
          end
          
          print("Ban Hero:"..sHeroName.." Ability: "..keys.abilityName)

          if HeroBuilder.heroAbilityPool[sHeroName] then
            if table.contains(HeroBuilder.heroAbilityPool[sHeroName],keys.abilityName) then
               table.remove_item(HeroBuilder.heroAbilityPool[sHeroName],keys.abilityName)
            end
          end

          if table.contains(HeroBuilder.summonAbilities,keys.abilityName) then
             table.remove_item(HeroBuilder.summonAbilities,keys.abilityName)
          end

          Pass.banAbilityTime[keys.PlayerID] = Pass.banAbilityTime[keys.PlayerID]-1
          CustomNetTables:SetTableValue("ban_count", tostring(keys.PlayerID), {ban_count_hero = Pass.banHeroTime[keys.PlayerID], ban_count_ability = Pass.banAbilityTime[keys.PlayerID]})
          if not table.contains(Pass.banAbilityList,keys.abilityName) then
            table.insert(Pass.banAbilityList, keys.abilityName)
            CustomGameEventManager:Send_ServerToAllClients( 'UpdatebanAbility', {abilityName = keys.abilityName})
            CustomNetTables:SetTableValue("hero_info", "ban_abilities", Pass.banAbilityList)
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[keys.PlayerID] ~= nil then
                table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[keys.PlayerID].current_ban_abilities, keys.abilityName)
            end
          end
       end
    end
    
end


function Pass:InitPassData(playerid)

    local hPlayer = PlayerResource:GetPlayer(playerid)
    if hPlayer and PlayerResource:GetSteamAccountID(playerid) then
        local sSteamID = tostring(PlayerResource:GetSteamAccountID(playerid))
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid] and (ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].pass_level_3_days > 0 or ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].pass_level_2_days > 0 or ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].pass_level_1_days > 0) then
            Pass.passInfo[playerid] = true
            Pass.steamPassInfo[sSteamID] = true
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].pass_level_3_days > 0 then
              Pass.banAbilityTime[playerid] = 3
              Pass.banHeroTime[playerid] = 2
              Pass.PauseCount[playerid] = 5
              Pass.RerollHeroCount[playerid] = 1
              Pass.PlayerPauseCooldown[playerid] = 0
              Pass.PlayerLeavePauseCooldown[playerid] = 0
              CustomNetTables:SetTableValue("tip_cooldown", tostring(playerid), {cooldown = 0})
            elseif ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].pass_level_2_days > 0 then
              Pass.banAbilityTime[playerid] = 2
              Pass.banHeroTime[playerid] = 1
              Pass.PauseCount[playerid] = 1
              Pass.PlayerPauseCooldown[playerid] = 0
              Pass.PlayerLeavePauseCooldown[playerid] = 0
              CustomNetTables:SetTableValue("tip_cooldown", tostring(playerid), {cooldown = 0})
            elseif ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].pass_level_1_days > 0 then
              Pass.banAbilityTime[playerid] = 2
              Pass.banHeroTime[playerid] = 1
              Pass.PauseCount[playerid] = 0
              Pass.PlayerPauseCooldown[playerid] = 0
              Pass.PlayerLeavePauseCooldown[playerid] = 0
            end
            CustomNetTables:SetTableValue("ban_count", tostring(playerid), {ban_count_hero = Pass.banHeroTime[playerid], ban_count_ability = Pass.banAbilityTime[playerid]})
            CustomNetTables:SetTableValue("player_info", "pass_data_"..playerid, ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid])
        else
            Pass.PlayerLeavePauseCooldown[playerid] = 0       
            Pass.passInfo[playerid] = false
        end
    end

    local nRetryTime=1

    Timers:CreateTimer(0.0, function()
        local hPlayer = PlayerResource:GetPlayer(playerid)
        local recentBannedAbilities = ""
        local recentBannedHeroes = ""
        local sSteamID = tostring(PlayerResource:GetSteamAccountID(playerid))
        if hPlayer then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid] then
                if ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].last_ban_heroes and ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].last_ban_abilities then
                    recentBannedAbilities = ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].last_ban_abilities
                    recentBannedHeroes = ChaServerData.PLAYERS_GLOBAL_INFORMATION[playerid].last_ban_heroes
                end
            end

            



           CustomGameEventManager:Send_ServerToPlayer(hPlayer,"UpdatePassData",{pass_valid=Pass.passInfo[playerid],recent_banned_abilities=recentBannedAbilities,recent_banned_heroes=recentBannedHeroes})
        end
      nRetryTime = nRetryTime+1
      if nRetryTime>300 then
         return nil
      else
         return 0.05
      end
    end)
    
end

function Pass:AddDemoCosmetics(data,nRequestPlayerID)
    
    local econRarity = CustomNetTables:GetTableValue("econ_rarity", "econ_rarity");
    local econType = CustomNetTables:GetTableValue("econ_type", "econ_type");
    local availableCosmetics ={}

    if not econRarity then
        return
    end

    for key,value in pairs(econRarity) do
        if value=="1" or value=="2" or value=="3" or (IsInToolsMode() and value=="4" ) then
          table.insert(availableCosmetics, key)
        end
    end

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
        local hPlayer = PlayerResource:GetPlayer(nPlayerID)
        if hPlayer and (nRequestPlayerID==nil or nPlayerID==nRequestPlayerID) then
            local sSteamID = tostring(PlayerResource:GetSteamAccountID(nPlayerID))
            
            if Pass.steamPassInfo[sSteamID] then

                local nNumber = 0;

                availableCosmetics=table.shuffle(availableCosmetics)

                local ownCosmetics={}
                
                
                if not data then
                  data = {}
                  data["econ_info"] = {}
                  data["econ_info"][sSteamID] = {}

                  CustomNetTables:GetTableValue("econ_data", "econ_info_"..sSteamID);
                  local bucketData = CustomNetTables:GetTableValue("econ_data", "econ_total_bucket_"..sSteamID) 
                  if bucketData and  bucketData.total_bucket then
                    local nBucketNumber = tonumber(bucketData.total_bucket)
                    for i=1,nBucketNumber do
                      local playerData = CustomNetTables:GetTableValue("econ_data", "econ_info_"..sSteamID.."_"..i)          
                      if playerData then
                         for nIndex,v in pairs(playerData) do
                            table.insert(data["econ_info"][sSteamID], v)
                         end
                      end
                    end
                  end

                  print("data[sSteamID]")
                  --PrintTable(data["econ_info"][sSteamID])
                  print("data[sSteamID] end")
                  data["money"] = {}
                  data["money"][sSteamID] = CustomNetTables:GetTableValue("econ_data", "money_"..sSteamID).money;
                  data["fragment"] = {}
                  data["fragment"][sSteamID] = CustomNetTables:GetTableValue("econ_data", "money_"..sSteamID).fragment;
                end
                for _,v in pairs(data["econ_info"][sSteamID]) do
                    if type(v) == "table" then
                       table.insert(ownCosmetics, v.name)
                    end
                end

                for _,cosmetic in ipairs(availableCosmetics) do
                   
                   if not table.contains(ownCosmetics, cosmetic) then
                      local tempCosmetic ={}
                      tempCosmetic["player_steam_id"] = sSteamID
                      tempCosmetic["name"] = cosmetic
                      tempCosmetic["equip"] = "false"
                      tempCosmetic["type"] = econType[cosmetic]
                      tempCosmetic["demo"] = "true"
                      table.insert(data["econ_info"][sSteamID], tempCosmetic)         
                      nNumber = nNumber +1
                   end
                   local nMaxNumber = 30
                   if IsInToolsMode() then
                      nMaxNumber = 10
                   end
                   if nNumber>nMaxNumber then
                      break;
                   end
                end
                for _,sName in ipairs(Pass.blinkEffects) do
                  if not table.contains(ownCosmetics, sName) then
                    local temp ={}
                    temp["player_steam_id"] = sSteamID
                    temp["name"] = sName
                    temp["equip"] = "false"
                    temp["demo"] = "true"
                    temp["type"] = "BlinkEffect"
                    table.insert(data["econ_info"][sSteamID], temp)
                  end
                end
                for _,sName in ipairs(Pass.attackEffects) do
                  if not table.contains(ownCosmetics, sName) then
                    local temp ={}
                    temp["player_steam_id"] = sSteamID
                    temp["name"] = sName
                    temp["equip"] = "false"
                    temp["demo"] = "true"
                    temp["type"] = "AttackEffect"
                    table.insert(data["econ_info"][sSteamID], temp)
                  end
                end
            end

            Econ:SetEconNetTable(data["econ_info"][sSteamID],sSteamID)
            CustomNetTables:SetTableValue("econ_data", "money_"..sSteamID, {money=data["money"][sSteamID],fragment=data["fragment"][sSteamID]})
            
        end
    end
end

function Pass:SelectSmile(keys)
  if keys.PlayerID == nil then return end
  if HasInInventory(keys.PlayerID, keys.id) then

      local player = PlayerResource:GetPlayer(keys.PlayerID)
      if player.smile_cooldown == nil then
          player.smile_cooldown = 0
      end
      
      if player.smile_cooldown and player.smile_cooldown > 0 then
        local player = PlayerResource:GetPlayer(keys.PlayerID)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#cha_smile_cooldown", time=player.smile_cooldown})
        end
        return
      end

      player.smile_cooldown = 1
      Timers:CreateTimer(1, function() 
          if player.smile_cooldown <= 0 then return nil end
          player.smile_cooldown = player.smile_cooldown - 1
          return 1
      end)

      print(player.smile_cooldown)

      local hero_name = ""
      local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
      if hero then
        hero_name = hero:GetUnitName()
      end
      CustomGameEventManager:Send_ServerToAllClients( 'chat_cha_smile', {hero_name = hero_name, player_id = keys.PlayerID, smile_icon = keys.smile_icon})
      local data={}
      data.type = "donate_smile"
      data.playerId = keys.PlayerID
      data.smile_icon = keys.smile_icon
      Barrage:FireBullet(data)
  end
end

function Pass:SelectVO(keys)
  if keys.PlayerID == nil then return end

  local sounds = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "50",
    "106",
    "107",
    "108",
    "109",
    "110",
    "111",
    "112",
    "113",
    "114",

    "115",
    "116",
    "117",
    "118",
    "119",
    "120",
    "121",
    "122",
    "123",
    "124",
    "125",
    "126",
  }

  local player = PlayerResource:GetPlayer(keys.PlayerID)

  if HasInInventory(keys.PlayerID, keys.num) then
    for _,sound in pairs(sounds) do
      if tostring(keys.num) == tostring(sound) then

        if player.sound_use_one == nil then
            player.sound_use_one = 0
        end
        if player.sound_use_two == nil then
            player.sound_use_two = 0
        end
        
        if (player.sound_use_one and player.sound_use_one > 0) and (player.sound_use_two and player.sound_use_two > 0) then
          local player = PlayerResource:GetPlayer(keys.PlayerID)
          if player then
              local cooldown_sound = math.max(player.sound_use_one, player.sound_use_two)
              CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#cha_sound_cooldown", time=cooldown_sound})
          end
          EmitSoundOnClient("General.Cancel", player)
          return
        end

        if not IsInToolsMode() then
          if player.sound_use_one > 0 then
              player.sound_use_two = 30
              Timers:CreateTimer(1, function() 
                  if player.sound_use_two <= 0 then return nil end
                  player.sound_use_two = player.sound_use_two - 1
                  return 1
              end)
          else
              player.sound_use_one = 30
              Timers:CreateTimer(1, function() 
                  if player.sound_use_one <= 0 then return nil end
                  player.sound_use_one = player.sound_use_one - 1
                  return 1
              end)
          end
        end

        local chat_sounds = {
          [1] = "Absolutely Perfect",
          [2] = "Ceeeeeeeb",
          [3] = "唉唉唉唉唉",
          [4] = "Ding Ding Ding Mother******",
          [5] = "Duiyou ne",
          [6] = "The next level play",
          [7] = "There is nothing that can stop this man",
          [8] = "Oyoy oy oy, oy, oy, oy, oy, oy!",
          [9] = "Robert B. Weide",
          [10] = "What the **** just happened?",
          [11] = "Zai jian le bao bei",
          [12] = "AYAYA",
          [13] = "Вот это поворот",
          [14] = "Жил до конца, умер как герой",
          [15] = "Красавчик",
          [16] = "Легкая, легчайшая для величайшего",
          [17] = "Лежать + Сосать",
          [18] = "Парни шо мы надрафтили, я ебал",
          [19] = "Lakad Matataaag! Normalin, Normalin",
          [20] = "Смех",
          [21] = "Hunter: Заебался сосать хуй",
          [22] = "Ты даже не стараешься",
          [23] = "Хилимся, живем",
          [24] = "Что сейчас произошло?",
          [25] = "Какая жесть",
          [26] = "Это лучшее, что я видел в своей жизни",
          [27] = "Это ненормально, это нечестно",
          [28] = "Это, просто, нечто",
          [29] = "Я паникую",
          [30] = "Вот так вот я дефаю блять",
          [31] = "КАААААК БЛЯТЬ!!!",
          [32] = "КАКОЙ ЖЕ ТЫ ДЕБИЛ",
          [33] = "Найс лагает",
          [34] = "Найс Damage, Найс Баланс",
          [35] = "Не надо дядя",
          [36] = "НЫЫЫЫЫААААААА",
          [37] = "Потому что я умный",
          [38] = "Почему тут нету помощи??",
          [39] = "ЭТО МНЕЕЕ?",
          [40] = "Я бессмертие нашел",
          [41] = "Easiest money of my life!",
          [42] = "Нужно больше золота",
          [43] = "Surprise motherf***er",
          [44] = "Хех, здарова",
          [45] = "А ну-ка иди-ка сюда. А вот все. Все",
          [46] = "Ебаный рот, этого казино, блять",
          [47] = "Ммм, хуета",
          [48] = "Попахивает фидом",
          [49] = "Анализируем силы на файт",
          [50] = "Ставлю душу своей матери",
          [106] = "Weron: Заебался сосать хуй",
          
          [107] = "Бооомба",
          [108] = "Заебись, четко",
          [109] = "Звук пива",
          [110] = "Похуй, похуй, похуй",
          [111] = "Сейчас я вас буду резать",
          [112] = "Смех папича",
          [113] = "Чего блять",
          [114] = "Я просто похлопаю",

          [115] = "Ass we can",
          [116] = "Boy next door",
          [117] = "Do you like what you see",
          [118] = "Dungeon Master",
          [119] = "Fisting is 300$",
          [120] = "Fuck you",
          [121] = "Fucking slaves",
          [122] = "Gachimuchi aAA",
          [123] = "Its so fucking deep",
          [124] = "Oh shit im sorry",
          [125] = "Stick your finger in my ass",
          [126] = "without further interruption lets celebrate and suck some dick",
        }

        local sound_name = "item_wheel_"..keys.num

        --EmitGlobalSound(sound_name)

        local hero_name = ""
        local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
        if hero then
          hero_name = hero:GetUnitName()
        end

        CustomGameEventManager:Send_ServerToAllClients( 'chat_cha_sound', {hero_name = hero_name, player_id = keys.PlayerID, sound_name = chat_sounds[keys.num], sound_name_global = sound_name})
      end
    end
  else
    EmitSoundOnClient("General.Cancel", player)
  end
end

function HasInInventory(id, item)
  local player_shop_table = CustomNetTables:GetTableValue("cha_server_data", tostring(id))
  if player_shop_table then
    local player_shop_table_items = player_shop_table.player_items
    for _, item_id in pairs(player_shop_table_items) do
      if tostring(item_id) == tostring(item) then
        return true
      end
    end
    return false
  end
  return false
end

function Pass:RollChestStart(keys)
    print("запустил колесо")
    local playerid = keys.PlayerID
    local player_arena_coin = 0
    local player_donate_coin = 0
    local player_table_info = CustomNetTables:GetTableValue('cha_server_data', tostring(playerid))

    if player_table_info then
        player_arena_coin = player_table_info.game_coin
        player_donate_coin = player_table_info.donate_coin
    else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_server_disconnect"})
        end
        return
    end

      if player_arena_coin >= 100 then
        player_table_info.game_coin = player_table_info.game_coin - 100
        CustomNetTables:SetTableValue("cha_server_data", tostring(playerid), player_table_info)
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_accept", {})
        end
        print("запустил колесо 2")
        Pass:PlayerRollActivate(playerid)
      else
        local player = PlayerResource:GetPlayer(playerid)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "donate_event_error", {error_name = "bp_error_no_arena_coin"})
        end
        return
      end
end

function Pass:PlayerRollActivate(id)
    local current_rewards = {}

    local basic_rewards = table.random_some(Pass.wheel_rewards_list, 15)

    local rare_rewards = table.random_some(Pass.wheel_rare_rewards_list, 5)

    current_rewards = table.join(current_rewards,basic_rewards)

    current_rewards = table.join(current_rewards,rare_rewards)

    current_rewards = table.shuffle(current_rewards)

    current_rewards = table.shuffle(current_rewards)

    local random_list = RandomInt(21, 41)

    local current_block = 1

    local reward_count_intable = 1

    local player = PlayerResource:GetPlayer(id)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "wheel_update_items", {items_list = current_rewards, rare_list = rare_rewards})
    end

    Timers:CreateTimer(0, function()

        if reward_count_intable > 20 then
            reward_count_intable = 1
        end

        if current_block == random_list then
            if reward_count_intable == 1 then
              Pass:GiveGiftPlayer(id, current_rewards[20])
            else
              Pass:GiveGiftPlayer(id, current_rewards[reward_count_intable - 1])
            end
            return
        end

        local player = PlayerResource:GetPlayer(id)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "wheel_change_animation", {current_block = reward_count_intable})
        end

        reward_count_intable = reward_count_intable + 1

        current_block = current_block + 1

        if (random_list - 6) <= current_block then
            return 0.5
        end

        return 0.1
    end)
end

function Pass:GiveGiftPlayer(id, item_id)
    local player_table_info = CustomNetTables:GetTableValue('cha_server_data', tostring(id))
    local player_items_table = {}

    for k, v in pairs(player_table_info.player_items) do
        table.insert(player_items_table, v)
    end

    if HasInInventory(id, item_id) then
      player_table_info.game_coin = player_table_info.game_coin + 50
      ChaServerData.WheelGiveReward(id, 0)
      item_id = 0
    else
      table.insert(player_items_table, item_id)
      player_table_info.player_items = player_items_table
      ChaServerData.WheelGiveReward(id, item_id)
    end

    CustomNetTables:SetTableValue("cha_server_data", tostring(id), player_table_info)

    local player = PlayerResource:GetPlayer(id)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "wheel_gift_end", {item_id = item_id})
    end
end