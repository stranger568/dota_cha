if Security == nil then Security = class({}) end









function Security:Init()
	
	
    Security.securityKeysList={}
	  Security.securityKeys={}
    Security.matchKeys={}
    
    
    CustomGameEventManager:RegisterListener("SecurityKeyConfirmed",function(_, keys)
        self:SecurityKeyConfirmed(keys)
    end)

    Security:LoopUpdateSecurityKeys()
end


function Security:GetSecurityKey(nPlayerID)
    return Security.securityKeys[nPlayerID]
end



function Security:LoopUpdateSecurityKeys()
    Timers:CreateTimer(0.5, function()
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
          if PlayerResource:IsValidPlayer(nPlayerID) then
            
            if Security.securityKeysList[nPlayerID]==nil then
               Security.securityKeysList[nPlayerID] = {}
            end
            
            if (#(Security.securityKeysList[nPlayerID])) > 50 then
               table.remove(Security.securityKeysList[nPlayerID], 1)
            end

            if Security.securityKeys[nPlayerID]==nil then
              local hPlayer = PlayerResource:GetPlayer(nPlayerID)
              if hPlayer then
                 local sSecurityKey = CreateSecretKey()
                 table.insert(Security.securityKeysList[nPlayerID], sSecurityKey)
                 local sNetTableSecurityKey = GetDedicatedServerKeyV2(sSecurityKey)
                 CustomNetTables:SetTableValue("player_info", "net_table_security_key_"..nPlayerID, {net_table_security_key=sNetTableSecurityKey})
                 CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SetSecurityKey",{security_key=sSecurityKey,net_table_security_key=sNetTableSecurityKey} )   
              end
            end
          end
        end
        return 0.5
    end)
end


function Security:SecurityKeyConfirmed(keys)
    local nPlayerID = keys.player_id
    if table.contains(Security.securityKeysList[nPlayerID], keys.security_key) then
       Security.securityKeys[nPlayerID] = keys.security_key
    end
end

