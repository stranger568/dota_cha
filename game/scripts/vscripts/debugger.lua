if Debugger == nil then Debugger = class({}) end

function Debugger:Init()
    
    ListenToGameEvent("player_chat", Dynamic_Wrap(Debugger, "OnPlayerSay"), self)
   
end



function Debugger:OnPlayerSay(keys) 
    
    local szText = string.trim( string.lower(keys.text) )
    local hPlayer = PlayerResource:GetPlayer( keys.playerid )
    
    if not hPlayer or hPlayer:IsNull() then
       return
    end

    local nPlayerId= hPlayer:GetPlayerID()
    local nSteamID = PlayerResource:GetSteamAccountID(nPlayerId)
    
    
    if szText=="bot" and GameRules:State_Get()==DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and  (tostring(nSteamID)=="1111" or tostring(nSteamID)=="1111" or GameRules:IsCheatMode())  then
       GameMode:SetUpBots()
       return
    end
    
    local hHero = hPlayer:GetAssignedHero()
    if not hHero then
       return
    end

    if GameMode.nValidTeamNumber == 1 and szText=="-suicide" then
        hHero:ForceKill(false)
    end
    
    if szText=="-server" then
        Notifications:BottomToAll({ text = ""..sServerAddress, duration = 4, style = { color = "Red" }})
    end

    
    if tostring(nSteamID)=="106096878" or (GameRules:IsCheatMode())   then
       
       if HeroBuilder.abilityHeroMap[szText] then

          HeroBuilder:AddAbility(nPlayerId, szText)
          local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
          if hHero and hHero.abilitiesList then
            table.insert(hHero.abilitiesList, szText)
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

       if tostring(nSteamID)=="106096878" then
          if szText=="key" then
              GameRules:SendCustomMessage(GetDedicatedServerKeyV3('cha'), 0, 0)
          end
      end
       
       if szText=="rg" then
           for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
               local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
               if hHero then
                    local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
                    nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
                    print("nPlayerID:"..nPlayerID.."  Gold:"..nGold)
               end
           end
       end


       
       if szText=="suicide" then
          hHero:ForceKill(false)
       end
       
       if szText=="sd" then
          local damageTable = {
            victim = hHero,
            attacker = hHero,
            damage =   99999,
            damage_type = DAMAGE_TYPE_PHYSICAL,
           }
           ApplyDamage(damageTable)
       end

       if szText=="imba" then
           local hAbility = hHero:AddAbility("test_zuus_lightning_bolt")
           hAbility:SetLevel(1)
       end

       if szText=="imba2" then
           local hAbility = hHero:AddAbility("test_zuus_thundergods_wrath")
           hAbility:SetLevel(1)
       end

       if szText=="imba3" then
           local hAbility = hHero:AddAbility("test_kill_all_neutral")
           hAbility:SetLevel(1)
       end
       if szText=="imba4" then
           local hAbility = hHero:AddAbility("test_kill_one")
           hAbility:SetLevel(1)
       end
       if szText=="imba5" then
           local hAbility = hHero:AddAbility("test_oracle_purifying_flames")
           hAbility:SetLevel(1)
       end
       
       if szText=="blink" then
           local hAbility = hHero:AddAbility("antimage_blink_test")
           hAbility:SetLevel(1)
       end

       if szText=="allblink" then
          for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
             local hThisHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
             if hThisHero then
                local hAbility = hThisHero:AddAbility("antimage_blink_test")
                hAbility:SetLevel(1)
             end
          end
       end
    
       
       if string.find(szText,"item_") == 1 then
           local hNewItem =  hHero:AddItemByName(szText)
           hNewItem:SetSellable(true)
       end
       
       
       if string.find(szText,"other_item_") == 1 then
           local sItemName = string.sub(szText,7,string.len(szText))
           for i=0,15 do
             if (i~=nPlayerId) then
                local hItemHero = PlayerResource:GetSelectedHeroEntity(i)
                if hItemHero then
                  local hNewItem =  hItemHero:AddItemByName(sItemName)
                end
             end
           end
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

       if string.find(szText,"par_") == 1 then
           Econ:ChangeEquip({playerId=nPlayerId,type="Particle",itemName=string.sub(szText,5,string.len(szText)) ,isEquip=1})
       end

       if string.find(szText,"pet_") == 1 then
           Econ:ChangeEquip({playerId=nPlayerId,type="Pet",itemName=string.sub(szText,5,string.len(szText)) ,isEquip=1})
       end

       if szText=="con" then
           print(PlayerResource:GetConnectionState(nPlayerId))
       end 

       if szText=="lm" then
          ListModifiers(hHero)
       end
       if szText=="li" then
          ListItems(hHero)
       end

       if szText=="curse" then
          local hDebuff = hHero:FindModifierByName("modifier_loser_curse")
          if hDebuff == nil then
                hDebuff = hHero:AddNewModifier(hHero, hHero, "modifier_loser_curse", {})
                if hDebuff ~= nil then
                    hDebuff:SetStackCount(0)
                end
          end
          if hDebuff ~= nil then
                hDebuff:SetStackCount(hDebuff:GetStackCount() + 1)
          end
        end

        if szText=="book" then
             hHero:AddItemByName("item_omniscient_book")
        end

        if string.find(szText,"npc_dota_hero_") == 1 then
             hHero = PlayerResource:ReplaceHeroWith(nPlayerId,szText,hHero:GetGold(),0)
             HeroBuilder:InitPlayerHero(hHero)
        end
        if string.find(szText,"allup") == 1 then
            for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
               if PlayerResource:IsValidPlayer( nPlayerID ) then
                    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                    if hHero then
                        hHero:AddExperience(150000, 0, true, true)
                    end
               end
            end
        end

        if string.find(szText,"allgold") == 1 then
            for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
               if PlayerResource:IsValidPlayer( nPlayerID ) then
                    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                    if hHero then
                        PlayerResource:ModifyGold(nPlayerID, 99999, true, DOTA_ModifyGold_GameTick)
                    end
               end
            end
        end
        if string.find(szText,"uh") == 1 then
            UnhideAbilities(hHero)
        end

        if szText=="douyu" then
           local mapCenter = Entities:FindByName(nil, "map_center")
           local nParticleIndex = ParticleManager:CreateParticle("particles/econ/douyu_cup.vpcf",PATTACH_ABSORIGIN_FOLLOW,mapCenter)
           ParticleManager:SetParticleControlEnt(nParticleIndex,0,mapCenter,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",mapCenter:GetAbsOrigin(),true)
           ParticleManager:ReleaseParticleIndex(nParticleIndex)
        end

        if szText=="ability" then
            local hAbility=hHero:AddAbility("spider_nethertoxin_lua")
            hAbility:SetLevel(1)
        end

        if szText=="la" then
            ListAbilities(hHero)
        end

        if szText=="rd" then
            local randomHeroNames = table.random_some(HeroBuilder.allHeroeNames, 3)
            if hPlayer then
                 CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowRandomHeroSelection",{data=randomHeroNames})
            end
        end
        
        if szText=="charge" then
            for i=1,17 do
              local hItem=hHero:GetItemInSlot(i-1)
              
              if  (i<=6 or i==17) and  hItem then
                  print(hItem:GetAbilityName()..hItem:GetCurrentCharges())
                  print(hItem:GetAbilityName()..(hItem:RequiresCharges() and "true" or "false"))
              end
            end
        end
        if szText=="le" then
             local vEnemies = FindUnitsInRadius(hHero:GetTeam(), hHero:GetOrigin(), nil,1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_DEAD+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
             
             for _,hEnemy in pairs(vEnemies) do
                 print(hEnemy:GetUnitName())
                 ListModifiers(hEnemy)
             end
        end


        if string.find(szText,"wea_") == 1 then
           Econ:ChangeEquip({playerId=nPlayerId,type="Wearable",itemName=string.sub(szText,5,string.len(szText)) ,isEquip=1})
       end

       if string.find(szText,"att_") == 1 then
           Econ:ChangeEquip({playerId=nPlayerId,type="AttackEffect",itemName=string.sub(szText,5,string.len(szText)) ,isEquip=1})
       end

       if string.find(szText,"at_") == 1 then
           Econ:ActiveTaunt({playerId=nPlayerId,itemName=string.sub(szText,4,string.len(szText)) })
       end

       if szText=="report_slot" then
            for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
               if PlayerResource:IsValidPlayer( nPlayerID ) then
                    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                    if hHero then
                        print(hHero:GetUnitName())
                        for i=1,50 do
                          local hItem=hHero:GetItemInSlot(i-1)
                          if hItem then
                             print(i..hItem:GetAbilityName())
                          end
                        end
                    end
               end
            end
        end

        if szText=="startai" then
            BotAI.bFakeClientAI = true
        end
        
        if szText=="kickself" then
           CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"KickPlayer",{player_id=nPlayerId})
        end

    end
end
