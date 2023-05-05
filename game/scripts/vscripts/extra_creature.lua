if ExtraCreature == nil then ExtraCreature = class({}) end

function ExtraCreature:Init()
    ExtraCreature.teamCreatureMap={}
    ExtraCreature.soundMap={}
end

function ExtraCreature:AddExtraCreature(nPlayerID,sCreatureName)
    local nTeamNumber = PlayerResource:GetTeam(nPlayerID)
    if nTeamNumber then
    	if ExtraCreature.teamCreatureMap and  ExtraCreature.teamCreatureMap[nTeamNumber] then
            table.insert(ExtraCreature.teamCreatureMap[nTeamNumber],sCreatureName)
        end
      
    	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
    	    if PlayerResource:IsValidPlayer(nPlayerID) then
               local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                if hPlayer then
                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ExtraCreatureAdded",{creatureName=sCreatureName})
    	        end
    	    end
    	end

        local vData={}
        vData.type = "add_extra_creature"
        vData.playerId = nPlayerID
        vData.creatureName = sCreatureName
        Barrage:FireBullet(vData)
        Util:RecordConsumableItem(nPlayerID,"item_extra_creature_"..string.sub(sCreatureName,10,string.len(sCreatureName)))
    end
end