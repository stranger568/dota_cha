if Debugger == nil then Debugger = class({}) end

function Debugger:Init()
    ListenToGameEvent("player_chat", Dynamic_Wrap(Debugger, "OnPlayerSay"), self)
end

function Debugger:OnPlayerSay(keys) 
    local szText = string.trim( string.lower(keys.text) )
    local hPlayer = PlayerResource:GetPlayer( keys.playerid )
    if not hPlayer or hPlayer:IsNull() then return end
    local nPlayerId= hPlayer:GetPlayerID()
    local nSteamID = PlayerResource:GetSteamAccountID(nPlayerId)
    local hHero = hPlayer:GetAssignedHero()
    if not hHero then return end

    if GameMode.nValidTeamNumber == 1 and szText=="-suicide" then
        hHero:ForceKill(false)
    end

    if tostring(nSteamID)=="106096878" or (GameRules:IsCheatMode()) then
        if HeroBuilder.abilityHeroMap[szText] then
            HeroBuilder:AddAbility(nPlayerId, szText)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
            if hHero and hHero.abilitiesList then
                table.insert(hHero.abilitiesList, szText)
            end
        end
        if szText=="suicide" then
            hHero:ForceKill(false)
        end
        --if szText=="force_game_end" then
        --    ChaServerData.SetPlayerStatsGameEnd(0, 1)
        --    ChaServerData.PostData()
        --end
        if string.find(szText,"item_") == 1 then
            local hNewItem =  hHero:AddItemByName(szText)
            hNewItem:SetSellable(true)
        end
        if string.match(szText, "^%-[r|R][o|O][u|U][n|N][d|D]%d+") ~= nil then  
            local nRoundNumber = string.match(szText, "%d+")
            GameMode.currentRound:End()
            GameMode.currentRound= Round()
            GameMode.currentRound:Prepare(tonumber(nRoundNumber))
        end
        if string.match(szText, "^%-[r|R][a|A][t|T][i|I][n|N]%d+") ~= nil then  
            local team = string.match(szText, "%d+")
            print(team)
            GameMode:TeamLose(tonumber(team))
        end
        if szText=="book" then
             hHero:AddItemByName("item_omniscient_book")
        end
        if szText=="reconnect" then
            GameMode:OnPlayerReconnected({PlayerID = nPlayerId})
        end
        if szText=="rating_time" then
            ChaServerData:RatingDebug()
        end
        if szText == "curse" then
            local hDebuff = hHero:FindModifierByName("modifier_loser_curse")
            if hDebuff == nil then
                local curse_ability = nil
                local empty_0 = hHero:FindAbilityByName("empty_0")
                if empty_0 then
                    curse_ability = empty_0
                end
                hDebuff = hHero:AddNewModifier(hHero, curse_ability, "modifier_loser_curse", {})
                if hDebuff ~= nil then
                    hDebuff:SetStackCount(0)
                end
            end
            if hDebuff ~= nil then
                hDebuff:SetStackCount(hDebuff:GetStackCount() + 1)
            end
        end
        if string.find(szText,"other_") == 1 then
          local sAbilityName = string.sub(szText,7,string.len(szText))
          print(sAbilityName)
          if HeroBuilder.abilityHeroMap[sAbilityName] then
             for i=0,10 do
                if (i~=nPlayerId) then
                  local hOtherHero = PlayerResource:GetSelectedHeroEntity(i)
                  if hOtherHero then
                    HeroBuilder:AddAbility(i, sAbilityName)
                    hOtherHero.nAbilityNumber = hOtherHero.nAbilityNumber+1
                    table.insert(hOtherHero.abilitiesList, sAbilityName)
                  end
                end
             end
          end
       end
        if string.find(szText,"npc_dota_hero_") == 1 then
             hHero = PlayerResource:ReplaceHeroWith(nPlayerId,szText,hHero:GetGold(),0)
             HeroBuilder:InitPlayerHero(hHero)
        end
    end
end
