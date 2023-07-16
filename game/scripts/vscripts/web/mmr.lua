ChaServerData = class({})
ChaServerData.url = 'https://data.strangerdev.ru/'  -- сайт с бд


-- Кто это видит, тот лох !
-------------------------------------------------------------------------------

ChaServerData.PLAYERS_GLOBAL_INFORMATION = {}
ChaServerData.PLAYERS_LOSE_MMR_STATS = {}

function ChaServerData:RegisterPlayerSiteInfo(player_id)
    if not PlayerResource:IsValidPlayerID(player_id) then return end
    if tostring( PlayerResource:GetSteamAccountID( player_id ) ) == nil then return end
    if PlayerResource:GetSteamAccountID( player_id ) == 0 then return end
    if PlayerResource:GetSteamAccountID( player_id ) == "0" then return end

    local set_data = function(data, id)
        if data == nil then
            data = 
            {
                mmr = {},
                games = {},
                calibrating_games = {},
                top_number = {},
            }
        end
        local table_info = 
        {
            steamid=PlayerResource:GetSteamAccountID(id),
            arena_level = tonumber(data.arena_level) or 0,
            max_tips = data.max_tips or 0,
            max_tips_game = 0,
            quest_swap1 = data.quest_swap1 or 0,
            quest_swap2 = data.quest_swap2 or 0,
            quest_swap3 = data.quest_swap3 or 0,
            quest_complete1 = tonumber(data.quest_complete1) or 0,
            quest_complete2 = tonumber(data.quest_complete2) or 0,
            quest_complete3 = tonumber(data.quest_complete3) or 0,
            mmr = data.mmr[GetMapName()] or {},
            games = data.games[GetMapName()] or {},
            calibrating_games = data.calibrating_games[GetMapName()] or {},
            rating_number_in_top = data.top_number[GetMapName()] or 0,
            player_items = data.player_items or {},
            pass_level_1_days = tonumber(data.pass_level_1_days) or 1,
            pass_level_2_days = tonumber(data.pass_level_2_days) or 1,
            pass_level_3_days = tonumber(data.pass_level_3_days) or 1,
            donate_coin = tonumber(data.donate_coin) or 0,
            game_coin = tonumber(data.game_coin) or 0,
            game_blocked = tonumber(data.game_blocked) or 0,
            last_ban_heroes = data.last_ban_heroes or "",
            last_ban_abilities = data.last_ban_abilities or "",
            stranger_surprice = tonumber(data.stranger_surprice) or 0,
            month_rewards_days = (tonumber(data.month_rewards_days) or 0) + 1,
            month_days_disabled = tonumber(data.month_days_disabled) or 0,
            game_coin_daily = tonumber(data.game_coin_daily) or 0,
            ticket_calibrate = tonumber(data.ticket_calibrate) or 0,
            effect = ChaServerData.GetEffectID(tonumber(data.effect) or 0, tonumber(data.pass_level_1_days) or 0, tonumber(data.pass_level_2_days) or 0, tonumber(data.pass_level_3_days) or 0),
            nickname = ChaServerData.GetNickNameID(tonumber(data.nickname) or 0, tonumber(data.pass_level_1_days) or 0, tonumber(data.pass_level_2_days) or 0, tonumber(data.pass_level_3_days) or 0),
            frame = ChaServerData.GetFrameID(tonumber(data.frame) or 0, tonumber(data.pass_level_1_days) or 0, tonumber(data.pass_level_2_days) or 0, tonumber(data.pass_level_3_days) or 0),
            chat_wheel = data.chat_wheel or {},
            current_ban_heroes = {},
            current_ban_abilities = {},
            spell_damage = {},
            spell_damage_income = {},
            quest_1 = Quests_arena:CheckQuest(id, 1, data.quest_1, PlayerResource:GetSteamAccountID(id)) or {},
            quest_2 = Quests_arena:CheckQuest(id, 2, data.quest_2, PlayerResource:GetSteamAccountID(id)) or {},
            quest_3 = Quests_arena:CheckQuest(id, 3, data.quest_3, PlayerResource:GetSteamAccountID(id)) or {},
            game_time = tonumber(data.game_time) or 0,
            bind_1 = "",
            bind_2 = "",
            bind_3 = "",
            bind_4 = "",
            bind_5 = "",
            bind_6 = "",
            bind_7 = "",
            bind_8 = "",
            bind_9 = "",
            bind_10 = "",
        }

        local settings_table = 
        {
            settings_right_select = data.settings_right_select or 0,
            settings_effect_select = data.settings_effect_select or 0,
            settings_width_select = data.settings_width_select or 0,
            keybinds = data.keybinds or {},
        }

        ChaServerData.PLAYERS_GLOBAL_INFORMATION[id] = table_info
        CustomNetTables:SetTableValue('cha_server_data', tostring(id), table_info)
        CustomNetTables:SetTableValue('player_info', "setting_data_"..tostring(id), settings_table)
        Pass:InitPassData(id)
    end

    RequestData(ChaServerData.url .. '/cha_data/get_player_data_new.php?steamid=' .. PlayerResource:GetSteamAccountID(player_id) .. '&token=' .. GetDedicatedServerKeyV3('cha'), function(data) set_data(data, player_id) end)
end

function ChaServerData:RegisterPlayerSiteInfoTournament(player_id)
    if not PlayerResource:IsValidPlayerID(player_id) then return end
    if tostring( PlayerResource:GetSteamAccountID( player_id ) ) == nil then return end
    if PlayerResource:GetSteamAccountID( player_id ) == 0 then return end
    if PlayerResource:GetSteamAccountID( player_id ) == "0" then return end
    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id] ~= nil then return end

    local table_info = 
    {
        steamid=PlayerResource:GetSteamAccountID(player_id),
        arena_level = 0,
        max_tips = 0,
        max_tips_game = 0,
        quest_swap1 = 0,
        quest_swap2 = 0,
        quest_swap3 = 0,
        quest_complete1 = 0,
        quest_complete2 = 0,
        quest_complete3 = 0,
        mmr = {},
        games = {},
        calibrating_games = {},
        rating_number_in_top = 0,
        player_items = {},
        pass_level_1_days = 99,
        pass_level_2_days = 99,
        pass_level_3_days = 99,
        donate_coin = 0,
        game_coin = 0,
        game_blocked = 0,
        last_ban_heroes = "",
        last_ban_abilities = "",
        stranger_surprice = 0,
        month_rewards_days = 1,
        month_days_disabled = 0,
        game_coin_daily = 0,
        ticket_calibrate = 0,
        effect = 0,
        nickname = 0,
        frame = 0,
        chat_wheel = {},
        current_ban_heroes = {},
        current_ban_abilities = {},
        spell_damage = {},
        spell_damage_income = {},
        quest_1 = {},
        quest_2 = {},
        quest_3 = {},
        game_time = 0,
    }

    local settings_table = 
    {
        settings_right_select = 0,
        settings_effect_select = 0,
        keybinds = {},
    }

    ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] = table_info
    CustomNetTables:SetTableValue('cha_server_data', tostring(player_id), table_info)
    CustomNetTables:SetTableValue('player_info', "setting_data_"..tostring(player_id), settings_table)
    Pass:InitPassData(player_id)
end

function ChaServerData:PlayerSettings(data)
    if data.PlayerID == nil then return end

    local settings = CustomNetTables:GetTableValue("player_info", "setting_data_"..tostring(data.PlayerID))

    if data.effect_ability_selection ~= nil then
        settings.settings_effect_select = data.effect_ability_selection
    end

    if data.right_ability_selection ~= nil then
        settings.settings_right_select = data.right_ability_selection
    end

    if data.width_ability_selection ~= nil then
        settings.settings_width_select = data.width_ability_selection
    end

    CustomNetTables:SetTableValue("player_info", "setting_data_"..tostring(data.PlayerID), settings)
end

function ChaServerData:GetSettingsAbilitiesSelect(id, effect, right, width)
    local settings = CustomNetTables:GetTableValue("player_info", "setting_data_"..tostring(id))

    if effect and settings.settings_effect_select ~= nil then
        return settings.settings_effect_select
    end

    if right and settings.settings_right_select ~= nil then
        return settings.settings_right_select
    end

    if width and settings.settings_width_select ~= nil then
        return settings.settings_width_select
    end

    return 0
end

function ChaServerData.GetEffectID(input_id, bp1, bp2, bp3)
    if input_id == 1 then
        if bp1 <= 0 then
            return 0
        end
    end
    
    if input_id == 2 then
        if bp2 <= 0 then
            return 0
        end
    end

    if input_id == 3 then
        if bp3 <= 0 then
            return 0
        end
    end

    return input_id
end

function ChaServerData.GetNickNameID(input_id, bp1, bp2, bp3)
    if input_id == 1 then
        if bp1 <= 0 then
            return 0
        end
    end

    if input_id == 2 then
        if bp2 <= 0 then
            return 0
        end
    end

    if input_id == 3 then
        if bp3 <= 0 then
            return 0
        end
    end

    return input_id
end

function ChaServerData.GetFrameID(input_id, bp1, bp2, bp3)
    return input_id
end

function ChaServerData.GetChatWheel(id, number)
    local player_table_for_chat_wheel = CustomNetTables:GetTableValue('cha_server_data', tostring(id))
    if player_table_for_chat_wheel then
        if player_table_for_chat_wheel.chat_wheel then
            local player_chat_wheel_change = {}
            for k, v in pairs(player_table_for_chat_wheel.chat_wheel) do
                player_chat_wheel_change[k] = v
            end
            local sound_return = player_chat_wheel_change[number] or "0"
            return sound_return
        end
    end
    return "0"
end   

function ChaServerData:RegisterSeasonInfo()
    RequestData(ChaServerData.url .. '/cha_data/get_top_200.php?token='.. GetDedicatedServerKeyV3('cha'), function(data) CustomNetTables:SetTableValue('cha_server_data', 'top_rating_solo_200', data) end)
    RequestData(ChaServerData.url .. '/cha_data/get_top_200_duo.php?token='.. GetDedicatedServerKeyV3('cha'), function(data) CustomNetTables:SetTableValue('cha_server_data', 'top_rating_duo_200', data) end)
    RequestData(ChaServerData.url .. '/cha_data/get_top_200_pve.php?token='.. GetDedicatedServerKeyV3('cha'), function(data) CustomNetTables:SetTableValue('cha_server_data', 'top_rating_pve_200', data) end)
end 

function ChaServerData.SetPlayerStatsGameEnd(player_id, place)
    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] == nil then return end
    if place == 0 then return end
    local player_table = 
    {
        map_name = tostring(GetMapName()),
        steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
        rating = ChaServerData.GetMmrByTeamPlace(player_id, place),
        game_coin = ChaServerData.GetGameCoin(player_id, place),
        game_blocked = ChaServerData.CheckUnbanGame(place),
        games = 1,
        max_tips = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].max_tips,
        games_calibrating = -1,
        chatwheel_1 = ChaServerData.GetChatWheel(player_id, "1"),
        chatwheel_2 = ChaServerData.GetChatWheel(player_id, "2"),
        chatwheel_3 = ChaServerData.GetChatWheel(player_id, "3"),
        chatwheel_4 = ChaServerData.GetChatWheel(player_id, "4"),
        chatwheel_5 = ChaServerData.GetChatWheel(player_id, "5"),
        chatwheel_6 = ChaServerData.GetChatWheel(player_id, "6"),
        chatwheel_7 = ChaServerData.GetChatWheel(player_id, "7"),
        chatwheel_8 = ChaServerData.GetChatWheel(player_id, "8"),
        effect = ChaServerData.GetCurrentEffect(player_id),
        nickname = ChaServerData.GetCurrentNickName(player_id),
        frame = ChaServerData.GetCurrentFrame(player_id),
        effect_settings = ChaServerData:GetSettingsAbilitiesSelect(player_id, true, false, false),
        right_settings = ChaServerData:GetSettingsAbilitiesSelect(player_id, false, true, false),
        width_settings = ChaServerData:GetSettingsAbilitiesSelect(player_id, false, false, true),
        game_time = GameRules:GetGameTime() - GameRules.nGameStartTime,
        bind_1 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_1,
        bind_2 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_2,
        bind_3 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_3,
        bind_4 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_4,
        bind_5 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_5,
        bind_6 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_6,
        bind_7 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_7,
        bind_8 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_8,
        bind_9 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_9,
        bind_10 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].bind_10,
    }
    ChaServerData.PLAYERS_LOSE_MMR_STATS[player_id] =  player_table
end

function ChaServerData.GetCurrentEffect(id)
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(id))
    if player_table then
        if player_table.effect then
            return player_table.effect
        end
    end
    return 0
end

function ChaServerData.GetCurrentNickName(id)
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(id))
    if player_table then
        if player_table.nickname then
            return player_table.nickname
        end
    end
    return 0
end

function ChaServerData.GetCurrentFrame(id)
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(id))
    if player_table then
        if player_table.frame then
            return player_table.frame
        end
    end
    return 0
end

function ChaServerData.UpdateLastBanneds()
    local post_data = 
    { 
        players = {}
    }

    for id, info in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION) do
        local hero_ban = ""
        local ability_ban = ""

        for count, hero_name in pairs(info.current_ban_heroes) do
            if info.current_ban_heroes[count+1] == nil then
                hero_ban = hero_ban .. hero_name
            else
                hero_ban = hero_ban .. hero_name .. ","
            end
        end

        for count, ability_name in pairs(info.current_ban_abilities) do
            if info.current_ban_abilities[count+1] == nil then
                ability_ban = ability_ban .. ability_name
            else
                ability_ban = ability_ban .. ability_name .. ","
            end
        end

        local player_table_banned = 
        {
            steamid = info.steamid,
            hero_ban = hero_ban,
            ability_ban = ability_ban,
        }
        table.insert(post_data.players, player_table_banned)
    end

    if not GameRules:IsCheatMode() or IsInToolsMode() then
        SendData(ChaServerData.url .. '/cha_data/post_banned_data.php', post_data, nil)
    end
end

function ChaServerData.AddBattlePassPlayer(player_id, coin_type, days, level, price)
    local post_data = 
    {
        player = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                coin_type = coin_type,
                days = days,
                level = level,
                price = price,
            }
        },
    }

    SendData(ChaServerData.url .. '/cha_data/add_battlepass_player.php', post_data, nil)
end

function ChaServerData.SwapCurrency(player_id, donate, arena)
    local post_data = 
    {
        player = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                donate = donate,
                arena = arena,
            }
        },
    }

    SendData(ChaServerData.url .. '/cha_data/swap_currency.php', post_data, nil)
end

function ChaServerData.GiveReward(player_id, battlepass_days, arena_coin, item_id, donate_coin, ticket_calibrate)
    local post_data = 
    {
        player = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                battlepass_days = battlepass_days,
                arena_coin = arena_coin,
                item_id = item_id,
                donate_coin = donate_coin,
                ticket_calibrate = ticket_calibrate,
            }
        },
    }

    SendData(ChaServerData.url .. '/cha_data/give_reward_new.php', post_data, nil)
end

function ChaServerData.RecalibratingPlayer(player_id)
    local post_data = 
    {
        player = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
            }
        },
    }

    SendData(ChaServerData.url .. '/cha_data/calibrate_player.php', post_data, nil)
end

function ChaServerData.WheelGiveReward(player_id, item_id)
    local post_data = 
    {
        player = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                item_id = item_id,
            }
        },
    }

    SendData(ChaServerData.url .. '/cha_data/wheel_reward.php', post_data, nil)
end

function ChaServerData.PostData()
    local post_data = { 
        players = {}
    }

    for id, player_info in pairs(ChaServerData.PLAYERS_LOSE_MMR_STATS) do
        table.insert(post_data.players, player_info)
    end

    if ((not GameRules:IsCheatMode() and ChaServerData.GetPlayersCount() > 5 and ((GameRules:GetGameTime() - GameRules.nGameStartTime) / 60) >= 25 ) or IsInToolsMode()) then
        SendData(ChaServerData.url .. '/cha_data/post_new_data_rating.php', post_data, nil)
    end

    for id, player_info in pairs(ChaServerData.PLAYERS_LOSE_MMR_STATS) do
        ChaServerData.SendQuestProgreess(id)
    end
end

function ChaServerData.PostDataPVE()
    local post_data = { 
        players = {}
    }

    for id, info in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION) do
        local solo_player = 
        {
            map_name = tostring(GetMapName()),
            steamid = info.steamid,
            time = GameRules:GetDOTATime(false, false),
            round = math.min(tonumber(GameMode.currentRound.nRoundNumber), 500),
            games = 1,
            chatwheel_1 = ChaServerData.GetChatWheel(id, "1"),
            chatwheel_2 = ChaServerData.GetChatWheel(id, "2"),
            chatwheel_3 = ChaServerData.GetChatWheel(id, "3"),
            chatwheel_4 = ChaServerData.GetChatWheel(id, "4"),
            chatwheel_5 = ChaServerData.GetChatWheel(id, "5"),
            chatwheel_6 = ChaServerData.GetChatWheel(id, "6"),
            chatwheel_7 = ChaServerData.GetChatWheel(id, "7"),
            chatwheel_8 = ChaServerData.GetChatWheel(id, "8"),
            effect = ChaServerData.GetCurrentEffect(id),
            nickname = ChaServerData.GetCurrentNickName(id),
            frame = ChaServerData.GetCurrentFrame(id),
            effect_settings = ChaServerData:GetSettingsAbilitiesSelect(id, true, false, false),
            right_settings = ChaServerData:GetSettingsAbilitiesSelect(id, false, true, false),
            width_settings = ChaServerData:GetSettingsAbilitiesSelect(id, false, false, true),
            bind_1 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_1,
            bind_2 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_2,
            bind_3 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_3,
            bind_4 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_4,
            bind_5 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_5,
            bind_6 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_6,
            bind_7 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_7,
            bind_8 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_8,
            bind_9 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_9,
            bind_10 = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].bind_10,
        }
        table.insert(post_data.players, solo_player)
    end

    if (not GameRules:IsCheatMode() or IsInToolsMode()) then
        SendData(ChaServerData.url .. '/cha_data/post_new_data_pve.php', post_data, nil)
    end
end

local game_coins_table = {
    [1] = 30,
    [2] = 20,
    [3] = 10,
    [4] = 5,
    [5] = 0,
    [6] = 0,
    [7] = 0,
    [8] = 0,
}

function ChaServerData.GetPlayersCount()
    local players_count = 0
    for id, player in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION) do
        players_count = players_count + 1
    end
    return players_count
end

function ChaServerData.GetGameCoin(player_id, place)
    local coins_bonus = game_coins_table[place] or 0
    local maximum_daily = 50

    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] and ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].pass_level_3_days > 0 then
        coins_bonus = coins_bonus * 2
        maximum_daily = 200
    elseif ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] and ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].pass_level_2_days > 0 then
        coins_bonus = coins_bonus * 1.5
        maximum_daily = 100
    end

    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] then
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].game_coin_daily >= maximum_daily then
            coins_bonus = 0
        end
    end

    CustomNetTables:SetTableValue('coins_table', tostring(player_id), {coins_bonus = coins_bonus})
    return coins_bonus
end

function ChaServerData.CheckUnbanGame(place)
    if place <= 4 then
        return "-1"
    else
        return "0"
    end
end

local calibrating_ratings_bonus = 
{
    [1] = 300,
    [2] = 200,
    [3] = 150,
    [4] = 100,
    [5] = 50,
    [6] = 0,
    [7] = -50,
    [8] = -100,
}

local calibrating_ratings_bonus_diff_5000_high_1 = 
{
    [1] = 3,
    [2] = 1,
    [3] = 0,
    [4] = -20,
    [5] = -40,
    [6] = -60,
    [7] = -80,
    [8] = -120,
}
local calibrating_ratings_bonus_diff_5000_high_2 = 
{
    [1] = 10,
    [2] = 4,
    [3] = 1,
    [4] = 0,
    [5] = -20,
    [6] = -40,
    [7] = -60,
    [8] = -80,
}
local calibrating_ratings_bonus_diff_5000_high_3 = 
{
    [1] = 20,
    [2] = 8,
    [3] = 4,
    [4] = 0,
    [5] = -10,
    [6] = -20,
    [7] = -40,
    [8] = -60,
}
local calibrating_ratings_bonus_diff_5000_high_4 = 
{
    [1] = 30,
    [2] = 15,
    [3] = 8,
    [4] = 3,
    [5] = 0,
    [6] = -10,
    [7] = -20,
    [8] = -40,
}

local calibrating_ratings_bonus_diff_5000_low_1 = 
{
    [1] = 240,
    [2] = 160,
    [3] = 80,
    [4] = 60,
    [5] = 40,
    [6] = 20,
    [7] = 10,
    [8] = 0,
}
local calibrating_ratings_bonus_diff_5000_low_2 = 
{
    [1] = 120,
    [2] = 80,
    [3] = 40,
    [4] = 20,
    [5] = 10,
    [6] = 5,
    [7] = 0,
    [8] = -10,
}
local calibrating_ratings_bonus_diff_5000_low_3 = 
{
    [1] = 60,
    [2] = 40,
    [3] = 20,
    [4] = 10,
    [5] = 5,
    [6] = 0,
    [7] = -10,
    [8] = -20,
}
local calibrating_ratings_bonus_diff_5000_low_4 = 
{
    [1] = 30,
    [2] = 20,
    [3] = 10,
    [4] = 5,
    [5] = 0,
    [6] = -10,
    [7] = -20,
    [8] = -40,
}

function ChaServerData.GetMmrByTeamPlace(player_id, place)

    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] == nil then
        CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = 0, new_rating = 0})
        return 0
    end

    --- Текущий рейтинг + средний переменная + новый рейтинг изменнный + игр в калибровке  ----------------------------------------
    local original_rating = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].mmr[6] or 2500
    local new_rating = original_rating
    local average_rating = 0
    local calibrating_games = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].calibrating_games[6] or 10
    ------------------------------------------------------------------------

    ------------ Cредний рейтинг----------------------------------------
    for id, player_info in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION) do
        average_rating = average_rating + (player_info.mmr[6] or 2500)
    end
    local players_count = math.max(ChaServerData.GetPlayersCount(), 1)
    average_rating = average_rating / players_count
    ------------------------------------------------------------------------

    -- Разница Среднего и твоего рейтинга
    local rating_difference = math.abs(average_rating - original_rating)

    -- Множитель рейтинга за игру
    local game_time_minutes = ((GameRules:GetGameTime() - GameRules.nGameStartTime) / 60)
    local game_time_hours = game_time_minutes / 60
    local bonus_rating_time_multiple = math.max(1, math.min(game_time_hours, 3))

    -- Выходные
    if true then
        game_time_minutes = ((GameRules:GetGameTime() - GameRules.nGameStartTime) / 60) + 60
        game_time_hours = game_time_minutes / 60
        bonus_rating_time_multiple = math.max(1, math.min(game_time_hours, 3))
    end

    -- Если у человека до сих пор идет калибровка
    if calibrating_games > 0 then
        local rating_bonus = calibrating_ratings_bonus[place]
        if rating_bonus then
            rating_bonus = tonumber(rating_bonus)
            new_rating = original_rating + rating_bonus
            CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
            return rating_bonus
        end
    end

    local rating_bonus = 0

    -- Если средний рейтинг выше 5к или у тебя 5к рейтинга
    if average_rating > 5000 or original_rating >= 5000 then
        -- Если у тебя больше чем средний рейтинг
        if original_rating >= average_rating then
            if rating_difference >= 3001 then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_1[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_2[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_3[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            else
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_4[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            end
        else -- Если средний рейтинг меньше твоего ммр
            if rating_difference >= 3001 then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_1[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_2[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_3[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            else
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_4[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * bonus_rating_time_multiple
                    else
                        rating_bonus = tonumber(rating_bonus_place) / bonus_rating_time_multiple
                    end
                end
            end
        end
    -- Средний рейтинг выше 3к
    elseif average_rating > 3000 then
        if original_rating >= average_rating then
            if rating_difference >= 3001 then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_1[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_2[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_3[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            else
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_4[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            end
        else
            if rating_difference >= 3001 then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_1[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_2[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_3[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            else
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_4[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 1.5
                    end
                end
            end
        end
    else
        if original_rating >= average_rating then
            if rating_difference >= 3001 then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_1[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_2[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_3[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            else
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_high_4[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            end
        else
            if rating_difference >= 3001 then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_1[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_2[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_3[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            else
                local rating_bonus_place = calibrating_ratings_bonus_diff_5000_low_4[place]
                if rating_bonus_place then
                    if rating_bonus_place > 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 3
                    elseif rating_bonus_place < 0 then
                        rating_bonus = tonumber(rating_bonus_place) * 2
                    end
                end
            end
        end
    end

    rating_bonus = math.floor(rating_bonus)
    new_rating = math.floor(original_rating + rating_bonus)
    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
    return rating_bonus
end

-- Quests

function ChaServerData.ChangeQuestSend(player_id, tier, quest_id, swap)

    local post_data = 
    {
        players = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                tier = tier,
                quest_id = quest_id,
                swap = swap,
            }
        },
    }
    if not GameRules:IsCheatMode() or IsInToolsMode() then
        SendData(ChaServerData.url .. '/cha_data/post_data_change_quest.php', post_data, nil)
    end
end

function ChaServerData.GetNewExpLevel(player_id, new_exp, bonus_donate_coin, bonus_arena_coin)

    local post_data = 
    {
        players = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                new_exp = new_exp,
                bonus_donate_coin = bonus_donate_coin,
                bonus_arena_coin = bonus_arena_coin,
            }
        },
    }
    if not GameRules:IsCheatMode() or IsInToolsMode() then
        SendData(ChaServerData.url .. '/cha_data/post_data_new_exp.php', post_data, nil)
    end
end

function ChaServerData.CloseQuest(player_id, quest_id, tier)

    local post_data = 
    {
        players = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                quest_id = quest_id,
                tier = tier,
            }
        },
    }
    if not GameRules:IsCheatMode() or IsInToolsMode() then
        SendData(ChaServerData.url .. '/cha_data/post_data_close_quest.php', post_data, nil)
    end
end


function ChaServerData.AddQuest(steamid, quest_id, tier)

    local post_data = 
    {
        players = 
        {
            {
                steamid = steamid,
                quest_id = quest_id,
                tier = tier,
            }
        },
    }
    if not GameRules:IsCheatMode() or IsInToolsMode() then
        SendData(ChaServerData.url .. '/cha_data/post_data_add_quest.php', post_data, nil)
    end
end

function ChaServerData.SendQuestProgreess(id)
    local player_table = CustomNetTables:GetTableValue('cha_server_data', tostring(id))
    if player_table then
        local post_data = 
        {
            players = 
            {
                {
                    steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].steamid,
                    quest1 = player_table.quest_1["current_point"],
                    quest2 = player_table.quest_2["current_point"],
                    quest3 = player_table.quest_3["current_point"],
                }
            },
        }
        if not GameRules:IsCheatMode() or IsInToolsMode() then
            SendData(ChaServerData.url .. '/cha_data/post_data_progress_quest.php', post_data, nil)
        end
    end
end

----- Rating Debug
function ChaServerData:RatingDebug()
    local game_time_minutes = ((GameRules:GetGameTime() - GameRules.nGameStartTime) / 60)
    local game_time_hours = game_time_minutes / 60
    local bonus_rating_time_multiple = math.max(1, math.min(game_time_hours, 3))
end

function ChaServerData:LoadThisGame(save_num)
    --RequestData(ChaServerData.url .. '/cha_data/load_game_tournament.php?game_id=' .. save_num .. '&token=' .. GetDedicatedServerKeyV3('cha'), function(data) ChaServerData:InitializationLoadGame(data, save_num) end)
    RequestData(ChaServerData.url .. '/cha_data/load_game_tournament.php?game_id=' .. save_num .. '&token=' .. "7FC576CCE396626D5E7432CE0E05A8647F4D0EA7", function(data) ChaServerData:InitializationLoadGame(data, save_num) end)
end

function ChaServerData:InitializationLoadGame(data, save_num)
    local current_round = data["round"]
    local heroes = data["heroes"]
    local abilities = data["abilities"]
    local items = data["items"]
    local modifiers = data["modifiers"]
    local skills = data["skills"]

    GameRules:SendCustomMessage("<font color='#58ACFA'>Загрузка сохранения №"..save_num.." [----------]0%</font>", 0, 0)

    ChaServerData:PerBanLoad(data["ban_list"])
    ChaServerData:PerPvpLoad(data["pvp_list"])

    for i=0, 24 do
        local hero = PlayerResource:GetSelectedHeroEntity(i)
        if hero and hero:IsRealHero() and hero:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_7 then
            local id = i
            local current_hero_info = ChaServerData:GetTableWithCurrentSteam(hero:GetPlayerOwnerID(), heroes)[1]
            local current_abilities_info = ChaServerData:GetTableWithCurrentSteam(hero:GetPlayerOwnerID(), abilities)
            local current_items_info = ChaServerData:GetTableWithCurrentSteam(hero:GetPlayerOwnerID(), items)
            local current_modifiers_info = ChaServerData:GetTableWithCurrentSteam(hero:GetPlayerOwnerID(), modifiers)
            local current_skills_info = ChaServerData:GetTableWithCurrentSteam(hero:GetPlayerOwnerID(), skills)
            HeroBuilder:HeroSelectedLoad(current_hero_info["hero_name"], hero:GetPlayerOwnerID(), tonumber(current_hero_info["aegis_count"]), tonumber(current_hero_info["level"]), tonumber(current_hero_info["ability_number"]), tonumber(current_hero_info["total_ability_number"]), tonumber(current_hero_info["gold"]), tonumber(current_hero_info["bet_value_sum"]))
            Timers:CreateTimer(20, function()
                hero = PlayerResource:GetSelectedHeroEntity(id)
                for _, ability_inf in pairs(current_abilities_info) do
                    HeroBuilder:AddAbility(id, ability_inf["ability_name"], tonumber(ability_inf["level"]), 0)
                    table.insert(hero.abilitiesList, ability_inf["ability_name"])
                end
                for _, skills_inf in pairs(current_skills_info) do
                    hero.selected_skills[tonumber(skills_inf["skill"])] = true
                end
            end)
            Timers:CreateTimer(25, function()
                hero = PlayerResource:GetSelectedHeroEntity(id)
                for _, item_inf in pairs(current_items_info) do
                    local n_ability = hero:AddItemByName(item_inf["item_name"])
                    if n_ability then
                        n_ability:StartCooldown(tonumber(item_inf["cooldown"]))
                        n_ability:SetCurrentCharges(tonumber(item_inf["charges"]))
                        n_ability:SetSecondaryCharges(tonumber(item_inf["charges_sub"]))
                    end
                end
            end)
            Timers:CreateTimer(30, function()
                hero = PlayerResource:GetSelectedHeroEntity(id)
                for _, mod_inf in pairs(current_modifiers_info) do
                    local modifier = hero:FindModifierByName(tostring(mod_inf["modifier_name"]))
                    if modifier then
                        modifier:SetStackCount(tonumber(mod_inf["stack"]))
                    else
                        if string.find(mod_inf["modifier_name"],"modifier_skill") or tonumber(mod_inf["stack"]) > 0 or string.find(mod_inf["modifier_name"],"modifier_item_aghanims_shard") or string.find(mod_inf["modifier_name"],"modifier_item_ultimate_scepter_consumed") then
                            if tonumber(mod_inf["duration"]) <= 0 then
                                local ability = nil
                                if hero:FindAbilityByName(mod_inf["ability_name"]) ~= nil then
                                    ability = hero:FindAbilityByName(mod_inf["ability_name"])
                                end
                                if hero:FindItemInInventory(mod_inf["ability_name"]) ~= nil then
                                    ability = hero:FindItemInInventory(mod_inf["ability_name"])
                                end
                                modifier = hero:AddNewModifier(hero, ability, tostring(mod_inf["modifier_name"]), {})
                                modifier:SetStackCount(tonumber(mod_inf["stack"]))
                            else
                                local ability = nil
                                if hero:FindAbilityByName(mod_inf["ability_name"]) ~= nil then
                                    ability = hero:FindAbilityByName(mod_inf["ability_name"])
                                end
                                if hero:FindItemInInventory(mod_inf["ability_name"]) ~= nil then
                                    ability = hero:FindItemInInventory(mod_inf["ability_name"])
                                end
                                modifier = hero:AddNewModifier(hero, ability, tostring(mod_inf["modifier_name"]), {duration = tonumber(mod_inf["duration"])})
                                modifier:SetStackCount(tonumber(mod_inf["stack"]))
                            end
                        end
                    end
                end
            end)
        end
    end

    local timer_visual = 0
    Timers:CreateTimer(1, function()
        timer_visual = timer_visual + 1
        if timer_visual == 1 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Загрузка сохранения №"..save_num.." [||--------]20%</font>", 0, 0)
        elseif timer_visual == 10 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Загрузка сохранения №"..save_num.." [||||------]40%</font>", 0, 0)
        elseif timer_visual == 16 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Загрузка сохранения №"..save_num.." [||||||----]60%</font>", 0, 0)
        elseif timer_visual == 25 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Загрузка сохранения №"..save_num.." [||||||||--]80%</font>", 0, 0)
        elseif timer_visual == 30 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Загрузка сохранения №"..save_num.." [||||||||||]100%</font>", 0, 0)
            GameRules:SendCustomMessage("<font color='#58ACFA'>Игра №"..save_num.." успешно загружена!</font>", 0, 0)
        end
        if timer_visual >= 30 then return end
        return 1
    end)

    if GameMode.currentRound then
        GameMode.currentRound:End()
    end

    GameMode.LoadRound = tonumber(current_round)
end

function ChaServerData:GetTableWithCurrentSteam(id, tables)
    local steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].steamid

    local new_table = {}

    for _, info in pairs(tables) do
        if info and tostring(info["steamid"]) == tostring(steamid) then
            table.insert(new_table, info)
        end
    end

    return new_table
end

function ChaServerData:SaveThisGame(save_num)
    local data = {}
    data.heroes = {}
    data.game_info = {}
    local hasabilitylist = function(abilityname, heros)
        for _, ab_n in pairs(heros.abilitiesList) do
            if tostring(ab_n) == tostring(abilityname) then
                return true
            end
        end
        return false
    end
    for i=0, 24 do
        local hero = PlayerResource:GetSelectedHeroEntity(i)
        if hero and hero:IsRealHero() and hero:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_7 and ChaServerData.PLAYERS_GLOBAL_INFORMATION[i] ~= nil then
            local new_hero_info = {}
            new_hero_info.game_id = save_num
            new_hero_info.hero_name = hero:GetUnitName()
            new_hero_info.steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[i].steamid
            new_hero_info.level = hero:GetLevel()
            new_hero_info.items = {}
            new_hero_info.gold = hero:GetGold()
            new_hero_info.abilities = {}
            new_hero_info.modifiers = {}
            new_hero_info.skills = hero.selected_skills
            new_hero_info.nAbilityNumber = hero.nAbilityNumber
            new_hero_info.totalAbilityNumber = HeroBuilder.totalAbilityNumber[i]
            new_hero_info.aegis_count = 0
            new_hero_info.betValueSum = PvpModule.betValueSum[i]
            local modifier_aegis = hero:FindModifierByName("modifier_aegis")
            if modifier_aegis then
                new_hero_info.aegis_count = modifier_aegis:GetStackCount()
            end
            for item_slot = 0, 16 do
                local item = hero:GetItemInSlot(item_slot)
                if item then
                    local new_item_info = {}
                    new_item_info.item_name = item:GetAbilityName()
                    new_item_info.charges = item:GetCurrentCharges()
                    new_item_info.charges_sub = item:GetSecondaryCharges()
                    new_item_info.cooldown = math.floor(item:GetCooldownTimeRemaining())
                    table.insert(new_hero_info.items, new_item_info)
                end
            end
            for _, modifier in pairs(hero:FindAllModifiers()) do
                if modifier and modifier:GetCaster() == hero then
                    local new_modifier_info = {}
                    new_modifier_info.game_id = save_num
                    new_modifier_info.modifier_name = modifier:GetName()
                    new_modifier_info.ability_name = ""
                    if modifier:GetAbility() ~= nil then
                        new_modifier_info.ability_name = modifier:GetAbility():GetAbilityName()
                    end
                    new_modifier_info.duration = modifier:GetRemainingTime()
                    new_modifier_info.stack = modifier:GetStackCount()
                    table.insert(new_hero_info.modifiers, new_modifier_info)
                end
            end
            for ability_index = 0, hero:GetAbilityCount() - 1 do
                local ability = hero:GetAbilityByIndex(ability_index)
                if ability and ability:GetAbilityType() ~= DOTA_ABILITY_TYPE_ATTRIBUTES and hasabilitylist(ability:GetAbilityName(), hero) then
                    local new_ability_info = {}
                    new_ability_info.game_id = save_num
                    new_ability_info.ability_name = ability:GetAbilityName()
                    new_ability_info.level = ability:GetLevel()
                    table.insert(new_hero_info.abilities, new_ability_info)
                end
            end
            table.insert(data.heroes, new_hero_info)
        end   
    end

    data.game_info.round = tonumber(GameMode.currentRound.nRoundNumber)
    data.game_info.game_id = save_num
    data.game_info.ban_list = Pass.banAbilityList
    data.game_info.pvp_list = PvpModule.pvpPairs
    SendData(ChaServerData.url .. '/cha_data/save_game_tournament.php', data, nil)
    GameRules:SendCustomMessage("<font color='#58ACFA'>Сохранение игры №"..save_num.." [----------]0%</font>", 0, 0)
    local timer_visual = 0
    Timers:CreateTimer(0, function()
        timer_visual = timer_visual + 1
        if timer_visual == 1 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Сохранение игры №"..save_num.." [||--------]20%</font>", 0, 0)
        elseif timer_visual == 2 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Сохранение игры №"..save_num.." [||||------]40%</font>", 0, 0)
        elseif timer_visual == 3 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Сохранение игры №"..save_num.." [||||||----]60%</font>", 0, 0)
        elseif timer_visual == 4 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Сохранение игры №"..save_num.." [||||||||--]80%</font>", 0, 0)
        elseif timer_visual == 5 then
            GameRules:SendCustomMessage("<font color='#58ACFA'>Сохранение игры №"..save_num.." [||||||||||]100%</font>", 0, 0)
        end
        if timer_visual >= 5 then return end
        return 2
    end)
end


function ChaServerData:PerBanLoad(ban_list)
    Pass.banAbilityList = {}

    local allAbilityNames = {}

    local abilityListKV = LoadKeyValues("scripts/npc/npc_abilities_list.txt")

    for szHeroName, data in pairs(abilityListKV) do
        HeroBuilder.heroAbilityPool["npc_dota_hero_"..szHeroName]={}
        if data and type(data) == "table" then 
            for key, value in pairs(data) do
                if type(value) ~= "table" then
                    table.insert(allAbilityNames, value)
                    table.insert(HeroBuilder.heroAbilityPool["npc_dota_hero_"..szHeroName], value)
               end
            end
        end
    end

    HeroBuilder.allAbilityNames = allAbilityNames

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

    for _, ability_name in pairs(ban_list) do
        if table.contains(HeroBuilder.allAbilityNames,ability_name["ability_name"]) then
            table.remove_item(HeroBuilder.allAbilityNames,ability_name["ability_name"])
        end

        local sHeroName = HeroBuilder.abilityHeroMap[tostring(ability_name["ability_name"])]
        if sHeroName ~= nil then
            if HeroBuilder.heroAbilityPool[sHeroName] then
                if table.contains(HeroBuilder.heroAbilityPool[sHeroName],ability_name["ability_name"]) then
                    table.remove_item(HeroBuilder.heroAbilityPool[sHeroName],ability_name["ability_name"])
                end
            end
        end

        if table.contains(HeroBuilder.summonAbilities,ability_name["ability_name"]) then
            table.remove_item(HeroBuilder.summonAbilities,ability_name["ability_name"])
        end

        if not table.contains(Pass.banAbilityList,ability_name["ability_name"]) then
            table.insert(Pass.banAbilityList, ability_name["ability_name"])
            CustomGameEventManager:Send_ServerToAllClients( 'UpdatebanAbility', {abilityName = ability_name["ability_name"]})
            CustomNetTables:SetTableValue("hero_info", "ban_abilities", Pass.banAbilityList)
        end
    end
end

function ChaServerData:PerPvpLoad(pvp_list)
    PvpModule.pvpPairs = {}
    for _, info in pairs(pvp_list) do
        info.nScore = tonumber(info.nScore)
        info.nTeamJoinTimes = tonumber(info.nTeamJoinTimes)
        info.nFirstTeamId = tonumber(info.nFirstTeamId)
        info.nSecondeTeamId = tonumber(info.nSecondeTeamId)
        table.insert(PvpModule.pvpPairs, info)
    end
end

function ChaServerData.BuyItemInShop(player_id, item_id, item_cost, coin_type)
    local post_data = 
    {
        player = 
        {
            {
                steamid = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].steamid,
                item_id = item_id,
                item_cost = item_cost,
                coin_type = coin_type,
            }
        },
    }
    SendData(ChaServerData.url .. '/cha_data/buy_item_in_shop.php', post_data, nil)
end