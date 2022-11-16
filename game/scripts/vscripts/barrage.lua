if Barrage == nil then Barrage = class({}) end

function Barrage:Init()
    ListenToGameEvent("player_chat", Dynamic_Wrap(Barrage, "OnPlayerSay"), self)   
end




function Barrage:OnPlayerSay(keys) 
 
    local hPlayer = PlayerResource:GetPlayer( keys.playerid )

    if not hPlayer or hPlayer:IsNull() then
       return
    end

    local hHero = hPlayer:GetAssignedHero()
    
    if hHero==nil then
       return
    end
    
    local nPlayerId= hHero:GetPlayerID()
    local szText = string.trim(keys.text)

    
    if ( GetMapName()=="2x6" or  GetMapName()=="5v5" )  and  1==keys.teamonly then
        return
    end

    local vData={}
    vData.type = "player_say"
    vData.playerId = nPlayerId
    vData.content =szText
    self:FireBullet(vData)
end



function Barrage:FireBullet(vData)
     CustomGameEventManager:Send_ServerToAllClients("FireBullet",vData);
end
