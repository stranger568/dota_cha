Chadisconnect = class({})

function Chadisconnect:RegListeners()
    ListenToGameEvent( "player_disconnect", Dynamic_Wrap( self, 'OnDisconnect' ), self )
    ListenToGameEvent( "player_reconnected", Dynamic_Wrap( self, "OnPlayerReconnected"), self)
end

function Chadisconnect:OnDisconnect(table)
    local id = tonumber(table.PlayerID)
    Pass:PauseDisconnectPlayer(id)
end     

function Chadisconnect:OnPlayerReconnected(keys)
   local retryTimes = 0
   local nPlayerID = keys.PlayerID
   local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID) or GameMode.HeroesPlayersList[nPlayerID]

    if hHero and hHero.bSettled then
        HeroBuilder:ReconnectRefundBook(hHero)
    end

    Timers:CreateTimer({ endTime = 1, callback = function()
        if hHero then                   
            if retryTimes > 50 then
                return nil
            end
            if true ~= hHero.bSettled then
                return nil
            end
            if hHero.nAbilityNumber then                 
                if hHero.nAbilityNumber < HeroBuilder.totalAbilityNumber[nPlayerID] then
                    HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
                else
                    return nil
                end
            end
        end
        retryTimes = retryTimes + 1
        return 1
    end})

    Timers:CreateTimer({ endTime = 1, callback = function()
        if hHero then                   
            if retryTimes > 50 then
                return nil
            end
            if hHero.selected_skill ~= true then
                return nil
            end
            if hHero.selected_skill[1] == nil and GameMode.currentRound and GameMode.currentRound.nRoundNumber > 10 then                 
                Skills:CreateRandomSkillsForPlayer(nPlayerID, 1)
                return nil
            end
            if hHero.selected_skill[2] == nil and GameMode.currentRound and GameMode.currentRound.nRoundNumber > 20 then                 
                Skills:CreateRandomSkillsForPlayer(nPlayerID, 2)
                return nil
            end
            if hHero.selected_skill[3] == nil and GameMode.currentRound and GameMode.currentRound.nRoundNumber > 30 then                 
                Skills:CreateRandomSkillsForPlayer(nPlayerID, 3)
                return nil
            end
            if hHero.selected_skill[4] == nil and GameMode.currentRound and GameMode.currentRound.nRoundNumber > 40 then                 
                Skills:CreateRandomSkillsForPlayer(nPlayerID, 4)
                return nil
            end
            if hHero.selected_skill[5] == nil and GameMode.currentRound and GameMode.currentRound.nRoundNumber > 50 then                 
                Skills:CreateRandomSkillsForPlayer(nPlayerID, 5)
                return nil
            end
            if hHero.selected_skill[6] == nil and GameMode.currentRound and GameMode.currentRound.nRoundNumber > 80 then                 
                Skills:CreateRandomSkillsForPlayer(nPlayerID, 5)
                return nil
            end
        end
        retryTimes = retryTimes + 1
        return 1
    end})
end