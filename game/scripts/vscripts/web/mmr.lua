ChaServerData = class({})
ChaServerData.url = 'http://91.219.192.6'  -- сайт с бд


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
        local table_info = {
            steamid=PlayerResource:GetSteamAccountID(id),

            mmr = data.mmr[GetMapName()] or {},
            games = data.games[GetMapName()] or {},
            calibrating_games = data.calibrating_games[GetMapName()] or {},
            rating_number_in_top = data.top_number[GetMapName()] or 0,
            player_items = data.player_items or {},
            pass_level_1_days = tonumber(data.pass_level_1_days) or 0,
            pass_level_2_days = tonumber(data.pass_level_2_days) or 0,
            pass_level_3_days = tonumber(data.pass_level_3_days) or 0,
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
        }
        ChaServerData.PLAYERS_GLOBAL_INFORMATION[id] = table_info
        CustomNetTables:SetTableValue('cha_server_data', tostring(id), table_info)
        Pass:InitPassData(id)
    end 

    RequestData(ChaServerData.url .. '/cha_data/get_player_data_new.php?steamid=' .. PlayerResource:GetSteamAccountID(player_id), function(data) set_data(data, player_id) end)
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
    RequestData(ChaServerData.url .. '/cha_data/get_top_200.php', function(data) CustomNetTables:SetTableValue('cha_server_data', 'top_rating_solo_200', data) end)
    RequestData(ChaServerData.url .. '/cha_data/get_top_200_duo.php', function(data) CustomNetTables:SetTableValue('cha_server_data', 'top_rating_duo_200', data) end)
    RequestData(ChaServerData.url .. '/cha_data/get_top_200_pve.php', function(data) CustomNetTables:SetTableValue('cha_server_data', 'top_rating_pve_200', data) end)
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
    local post_data = { 
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
        print("отправить", player_table_banned.hero_ban, player_table_banned.ability_ban)
        table.insert(post_data.players, player_table_banned)
    end
    if not GameRules:IsCheatMode() or IsInToolsMode() then
        print("я отправил")
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

    if ((not GameRules:IsCheatMode() and ChaServerData.GetPlayersCount() > 5 and ((GameRules:GetGameTime() - GameRules.nGameStartTime) / 60) >= 10 ) or IsInToolsMode()) then
        SendData(ChaServerData.url .. '/cha_data/post_new_data_rating.php', post_data, nil)
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

local calibrating_ratings_bonus = {
    [1] = 300,
    [2] = 200,
    [3] = 150,
    [4] = 100,
    [5] = 50,
    [6] = 0,
    [7] = -50,
    [8] = -100,
}

local calibrating_ratings_bonus_diff_5000_high_1 = {
    [1] = 3,
    [2] = 1,
    [3] = 0,
    [4] = -20,
    [5] = -45,
    [6] = -90,
    [7] = -135,
    [8] = -200,
}
local calibrating_ratings_bonus_diff_5000_high_2 = {
    [1] = 10,
    [2] = 4,
    [3] = 1,
    [4] = 0,
    [5] = -20,
    [6] = -45,
    [7] = -90,
    [8] = -135,
}
local calibrating_ratings_bonus_diff_5000_high_3 = {
    [1] = 20,
    [2] = 8,
    [3] = 4,
    [4] = 0,
    [5] = -15,
    [6] = -30,
    [7] = -60,
    [8] = -90,
}
local calibrating_ratings_bonus_diff_5000_high_4 = {
    [1] = 30,
    [2] = 15,
    [3] = 8,
    [4] = 0,
    [5] = -10,
    [6] = -20,
    [7] = -40,
    [8] = -60,
}

local calibrating_ratings_bonus_diff_5000_low_1 = {
    [1] = 240,
    [2] = 160,
    [3] = 80,
    [4] = 60,
    [5] = 40,
    [6] = 20,
    [7] = 10,
    [8] = 0,
}
local calibrating_ratings_bonus_diff_5000_low_2 = {
    [1] = 120,
    [2] = 80,
    [3] = 40,
    [4] = 20,
    [5] = 10,
    [6] = 0,
    [7] = -10,
    [8] = -15,
}
local calibrating_ratings_bonus_diff_5000_low_3 = {
    [1] = 60,
    [2] = 40,
    [3] = 20,
    [4] = 10,
    [5] = 0,
    [6] = -10,
    [7] = -20,
    [8] = -30,
}
local calibrating_ratings_bonus_diff_5000_low_4 = {
    [1] = 30,
    [2] = 20,
    [3] = 10,
    [4] = 0,
    [5] = -10,
    [6] = -20,
    [7] = -40,
    [8] = -60,
}

function ChaServerData.GetMmrByTeamPlace(player_id, place)
    if ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id] == nil then
        CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = 0, new_rating = 0})
        return 0
    end

    local original_rating = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].mmr[3] or 2500

    local new_rating = original_rating

    local average_rating = 0

    local bonus_rating_time_multiple = math.min((0.01 * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60), 1)

    for id, player_info in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION) do
        average_rating = average_rating + (player_info.mmr[3] or 2500)
    end

    local players_count = math.max(ChaServerData.GetPlayersCount(), 1)

    average_rating = average_rating / players_count

    local rating_difference = math.abs(average_rating - original_rating)

    local calibrating_games = ChaServerData.PLAYERS_GLOBAL_INFORMATION[player_id].calibrating_games[3] or 10

    if calibrating_games > 0 then
        local rating_bonus = calibrating_ratings_bonus[place]
        if rating_bonus then
            rating_bonus = tonumber(rating_bonus)
            new_rating = original_rating + rating_bonus
            CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
            return rating_bonus
        end
    end

    if average_rating > 5000 or original_rating >= 5000 then
        if original_rating >= average_rating then
            if rating_difference >= 3001 then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_1[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_2[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_3[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            else
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_4[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            end
        else
            if rating_difference >= 3001 then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_1[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_2[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_3[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            else
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_4[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus) + (rating_bonus * bonus_rating_time_multiple)
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            end
        end
    elseif average_rating > 3000 then
        if original_rating >= average_rating then
            if rating_difference >= 3001 then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_1[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_2[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_3[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            else
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_4[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            end
        else
            if rating_difference >= 3001 then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_1[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_2[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_3[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            else
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_4[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 2
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 1.5
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            end
        end
    else
        if original_rating >= average_rating then
            if rating_difference >= 3001 then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_1[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_2[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_3[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            else
                local rating_bonus = calibrating_ratings_bonus_diff_5000_high_4[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            end
        else
            if rating_difference >= 3001 then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_1[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 2001 and rating_difference <= 3000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_2[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            elseif (rating_difference >= 1001 and rating_difference <= 2000) then
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_3[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            else
                local rating_bonus = calibrating_ratings_bonus_diff_5000_low_4[place]
                if rating_bonus then
                    rating_bonus = tonumber(rating_bonus)
                    if rating_bonus > 0 then
                        rating_bonus = rating_bonus * 3
                    elseif rating_bonus < 0 then
                        rating_bonus = rating_bonus * 2
                    end
                    new_rating = original_rating + rating_bonus
                    rating_bonus = math.floor(rating_bonus)
                    new_rating = math.floor(new_rating)
                    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
                    return rating_bonus
                end
            end
        end
    end

    CustomNetTables:SetTableValue('mmr_player', tostring(player_id), {original_rating = original_rating, new_rating = new_rating})
    return 0
end





