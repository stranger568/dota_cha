if Setting == nil then Setting = class({}) end

function Setting:Init()
    CustomGameEventManager:RegisterListener("UpdateSetting",function(_, keys)
        self:UpdateSetting(keys)
    end)

end

function Setting:InitSettingData(settingData)

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
        local hPlayer = PlayerResource:GetPlayer(nPlayerID)
        if hPlayer and PlayerResource:GetSteamAccountID(nPlayerID) then
            local sSteamID = tostring(PlayerResource:GetSteamAccountID(nPlayerID))

            if settingData[sSteamID] and settingData[sSteamID].player_steam_id then
                CustomNetTables:SetTableValue("player_info", "setting_data_"..nPlayerID, settingData[sSteamID])
            end
        end
    end
    
end

function Setting:UpdateSetting(keys)
end

