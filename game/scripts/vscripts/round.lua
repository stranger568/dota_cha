if Round == nil then Round = class({}) end
LinkLuaModifier( "modifier_creature_berserk", "creature_ability/modifier_creature_berserk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_berserk_debuff", "creature_ability/modifier_creature_berserk_debuff", LUA_MODIFIER_MOTION_NONE )



nBasePrepareTotalTime=15
if IsInToolsMode() then
    nBasePrepareTotalTime=8
end

nRoundLimitTime=50
if IsInToolsMode() then
    nRoundLimitTime=50
end
nRoundBaseBonus=300



compensateRoundNumber = {}
compensateRoundNumber[10]=true
compensateRoundNumber[20]=true
compensateRoundNumber[30]=true
compensateRoundNumber[40]=true
compensateRoundNumber[50]=true

if IsInToolsMode() then
 compensateRoundNumber[1]=true
 compensateRoundNumber[2]=true
 compensateRoundNumber[3]=true
end



abilitySelectionRoundNumber = {}
abilitySelectionRoundNumber[3]=true
abilitySelectionRoundNumber[6]=true
abilitySelectionRoundNumber[9]=true


if IsInToolsMode() then
  abilitySelectionRoundNumber = {}
  abilitySelectionRoundNumber[2]=true
  abilitySelectionRoundNumber[3]=true
  abilitySelectionRoundNumber[4]=true
end

function Round:Prepare(nRoundNumber)
    
    self.spanwers={}
    self.bEnd = false
    
    self.nCreatureNumber = 0
    self.nRoundNumber=nRoundNumber
    
    if nRoundNumber>=1 then
       GameRules:SetSafeToLeave(true)
    end

    if GetMapName() == "1x8_pve" then
        if nRoundNumber > 500 then
            ChaServerData.PostDataPVE()
            return
        end
    end

    
    self.nPlayerRank = 0
        
    self.nPrepareTotalTime = nBasePrepareTotalTime

    self.readyPlayers = {}

    
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
      if bAlive then
          for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
            if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                self.readyPlayers[nPlayerID] = false
            end
          end
       end
    end


    
    if abilitySelectionRoundNumber[nRoundNumber] then

       for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
          HeroBuilder.totalAbilityNumber[nPlayerID] = HeroBuilder.totalAbilityNumber[nPlayerID]+1
       end
       
       
       if IsInToolsMode() then
         self.nPrepareTotalTime = nBasePrepareTotalTime + 1
       else
         self.nPrepareTotalTime = nBasePrepareTotalTime + 15
       end
    end
    
    
    self.nAliveTeamNumber = 0 
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
      if bAlive then
        self.nAliveTeamNumber = self.nAliveTeamNumber+1
        
        if abilitySelectionRoundNumber[nRoundNumber] then
          for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
              HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
          end
        end
      end
    end

    if GetMapName()=="2x6" then
       nRoundBaseBonus = 320
    end

    if GetMapName()=="5v5" then
       nRoundBaseBonus = 350
    end
    
    if tonumber(nRoundNumber)<65 then
       self.flBonus = nRoundBaseBonus * math.pow(1.031, (tonumber(nRoundNumber)-1))
    else
       self.flBonus = nRoundBaseBonus * math.pow(1.031, 65)
    end
    

    
    local nPhase = math.ceil(nRoundNumber/10)

    
    if GameMode.vRoundList[nPhase] ==nil then
       local nRandomPhase = RandomInt(5, 49)
       
       GameMode.vRoundList[nPhase] = table.deepcopy(GameMode.vRoundListFull[nRandomPhase])
    end

    self.sRoundName = table.random(GameMode.vRoundList[nPhase])
    for i,v in ipairs(GameMode.vRoundList[nPhase]) do
        if v == self.sRoundName then
            table.remove(GameMode.vRoundList[nPhase], i)
        end
    end
    
    
    for k,vData in pairs(GameMode.vRoundData[self.sRoundName]) do
       self.nCreatureNumber = tonumber(vData.UnitNumber) +self.nCreatureNumber
    end
    
    
    self.flExpMulti = 1 
    
    if GetMapName()=="2x6" then
       self.flExpMulti = 2
    end

    if GetMapName()=="5v5" then
       self.flExpMulti = 5
    end

    
    if self.nRoundNumber - PvpModule.nLastPvpRound >= PvpModule.nInterval then
       
       if self.sRoundName~="Round_Roshan" then

          
          if string.find(GetMapName(),"1x8") then
             self.nPrepareTotalTime = self.nPrepareTotalTime + 2
          end

          if GetMapName()=="2x6" then
             self.nPrepareTotalTime = self.nPrepareTotalTime + 5
          end

          PvpModule:RoundPrepare(self.nRoundNumber)
       end
    end

    if self.nRoundNumber>=40 then
       self.nPrepareTotalTime  = self.nPrepareTotalTime +2
    end

    if self.nRoundNumber>=50 then
       self.nPrepareTotalTime  = self.nPrepareTotalTime +2
    end
    
    if self.nRoundNumber>=60 then
       self.nPrepareTotalTime  = self.nPrepareTotalTime +2
    end
    
    
    self.nPrepareTime = 0

    CustomGameEventManager:Send_ServerToAllClients("CreateQuest", { name = "RoundPrepare", text = "#round_prepare", svalue = 0, evalue = self.nPrepareTotalTime, text_value=self.nRoundNumber, text_value_2="#"..self.sRoundName })
    CustomGameEventManager:Send_ServerToAllClients("UpdateReadyButton", {visible=true})
    CustomGameEventManager:RegisterListener("PlayerReady",function(_, keys) self:PlayerReady(keys) end)


    Timers:CreateTimer(1, function()
           self.nPrepareTime = self.nPrepareTime+1
           CustomGameEventManager:Send_ServerToAllClients("RefreshQuest", { name = "RoundPrepare", text = "#round_prepare", svalue =self.nPrepareTime, evalue = self.nPrepareTotalTime, text_value=self.nRoundNumber,text_value_2="#"..self.sRoundName })
           CustomGameEventManager:Send_ServerToAllClients("UpdateConfirmButton", { currentTime =self.nPrepareTime, totalTime = self.nPrepareTotalTime })
           
           if self.bEnd then
              CustomGameEventManager:Send_ServerToAllClients("RemoveQuest", { name = "RoundPrepare" })
              
              return nil
           end

           local bAllReady = true
           
           for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
             if bAlive then
                for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                  if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                     if false==self.readyPlayers[nPlayerID] then
                         bAllReady = false
                     end
                  end
                end
             end
           end

           if bAllReady or (self.nPrepareTime >= self.nPrepareTotalTime) then

              
               xpcall(
                function()
              
                self:Begin()

              
              end,
                function(e)
                  print(e)
              end)        
              

              return nil
           else
              return 1
           end
    end)
end




function Round:Begin()

    
    if self.nRoundNumber==1 then
       HeroBuilder:ForceFinishHeroBuild()
    end
    
    
    if GetMapName()=="halloween_1x8" then
       Halloween:SettleDamageBonus()
       if self.nRoundNumber==1 then
          Halloween:SpawnPumpkinKing()
       end
    end

    self.nTimeLimit = nRoundLimitTime

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
      
      if PlayerResource:IsValidPlayer(nPlayerID)  then
         local hPlayer = PlayerResource:GetPlayer(nPlayerID)
         if hPlayer then
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "HidePvpBet", {})
         end
      end
    end

    CustomGameEventManager:Send_ServerToAllClients("ResetPlayerReadyList", {})

    
    PvpModule:SummarizeBetInfo()
    
    CustomGameEventManager:Send_ServerToAllClients("UpdateReadyButton", {visible=false})
    CustomGameEventManager:Send_ServerToAllClients("RemoveQuest", { name = "RoundPrepare" })

    
    
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
       if bAlive==true then
          
          
          local bTeamPvpFlag = false 

          
          for nPlayerIndex,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID] then
              ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage = {}
              CustomNetTables:SetTableValue("spell_damage", tostring(nPlayerID), ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage)
              ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage_income = {}
              CustomNetTables:SetTableValue("spell_damage_income", tostring(nPlayerID), ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage)
              CustomGameEventManager:Send_ServerToAllClients( "remove_damage_units", {} )
            end

            local bPlayerPvpFlag = false
            local vCenter = GameMode.vTeamLocationMap[nTeamNumber]
            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)  

             
             for i,pvpTeamID in ipairs(PvpModule.currentPair) do
                if pvpTeamID == nTeamNumber then
                   
                   vCenter = PvpModule.vHomeCenter - Vector( (3-i*2)*550,0,0)

                   
                   if GetMapName()=="2x6" then
                        vCenter = vCenter + Vector(0,(3-nPlayerIndex*2)*350,0)
                   end

                   
                   if GetMapName()=="5v5" then
                      local wayPoint = Entities:FindByName(nil, "center_pvp_"..nTeamNumber)
                      vCenter = wayPoint:GetOrigin()+RandomVector(300)
                   end

                   bTeamPvpFlag =true
                   bPlayerPvpFlag= true
                   
                   local nPvpParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_start_ring_arcana.vpcf", PATTACH_CUSTOMORIGIN, nil)
                   ParticleManager:SetParticleControl(nPvpParticle, 0, vCenter)  
                   ParticleManager:SetParticleControl(nPvpParticle, 7, vCenter)  
                   Timers:CreateTimer({ endTime = 1, 
                      callback = function()
                          ParticleManager:DestroyParticle(nPvpParticle, false)
                          ParticleManager:ReleaseParticleIndex(nPvpParticle)
                      end
                   })
                   
                   hHero.bJoiningPvp = true
                   EmitSoundOn("Hero_LegionCommander.Duel",hHero)
                   Timers:CreateTimer({ endTime = 1.5, 
                      callback = function()
                        StopSoundOn("Hero_LegionCommander.Duel",hHero)
                      end
                   })
                end
             end


             
             for i,nPvpPlayerID in ipairs(PvpModule.currentSinglePair) do
                if nPvpPlayerID == nPlayerID then

                   
                   local nTeamNumber = PlayerResource:GetTeam(nPvpPlayerID)
                   local wayPoint = Entities:FindByName(nil, "center_single_pvp")
                  vCenter = wayPoint:GetOrigin() - Vector( (5-nTeamNumber*2)*550,0,0)

                   bPlayerPvpFlag= true      
                               
                   local nPvpParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_start_ring_arcana.vpcf", PATTACH_CUSTOMORIGIN, nil)
                   ParticleManager:SetParticleControl(nPvpParticle, 0, vCenter)  
                   ParticleManager:SetParticleControl(nPvpParticle, 7, vCenter)  
                   Timers:CreateTimer({ endTime = 1, 
                      callback = function()
                          ParticleManager:DestroyParticle(nPvpParticle, false)
                          ParticleManager:ReleaseParticleIndex(nPvpParticle)
                      end
                   })
                   
                   hHero.bJoiningPvp = true
                   EmitSoundOn("Hero_LegionCommander.Duel",hHero)
                   Timers:CreateTimer({ endTime = 1.5, 
                      callback = function()
                        StopSoundOn("Hero_LegionCommander.Duel",hHero)
                      end
                   })
                end
             end
             
             
             if hPlayer and (not bPlayerPvpFlag) and (not PvpModule.bEnd) then
                
                hHero.bJoiningPvp = false
                
                local dataList={}
                local firstTeamId
                local secondTeamId

                
                for nTempPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                  if PlayerResource:IsValidPlayer(nTempPlayerID) and (PlayerResource:GetTeam( nTempPlayerID ) == PvpModule.currentPair[1] or PlayerResource:GetTeam( nTempPlayerID )==PvpModule.currentPair[2]) then
                     local data = {}
                     data.playerID = nTempPlayerID
                     data.teamID = PlayerResource:GetTeam( nTempPlayerID )
                     table.insert(dataList, data)
                     firstTeamId = PvpModule.currentPair[1]
                     secondTeamId = PvpModule.currentPair[2]
                  end
                end

                
                for nTempPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                  if PlayerResource:IsValidPlayer(nTempPlayerID) and (nTempPlayerID == PvpModule.currentSinglePair[1] or nTempPlayerID ==PvpModule.currentSinglePair[2]) then
                     local data = {}
                     data.playerID = nTempPlayerID
                     data.teamID = PlayerResource:GetTeam( nTempPlayerID )
                     table.insert(dataList, data)
                     firstTeamId = PlayerResource:GetTeam(PvpModule.currentSinglePair[1])
                     secondTeamId = PlayerResource:GetTeam(PvpModule.currentSinglePair[2])
                  end
                end

                CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBrief", {players=dataList,firstTeamId=firstTeamId,secondTeamId=secondTeamId, betMap=PvpModule.betMap, bonusPool=math.floor(PvpModule.nBetBonus) })
              
             end

             
             hHero:RemoveModifierByName("modifier_hero_refreshing")
             Util:MoveHeroToLocation( nPlayerID,vCenter )

          end
          
          if not bTeamPvpFlag then
            self.spanwers[nTeamNumber] = Spawner()
            self.spanwers[nTeamNumber]:Init(nTeamNumber,self)
            CustomNetTables:SetTableValue( "spawner_info",tostring(nTeamNumber),{})
          end
       end
       
       if false==bAlive then

           local dataList={}
           for nTempPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
              if PlayerResource:IsValidPlayer(nTempPlayerID) and (PlayerResource:GetTeam( nTempPlayerID ) == PvpModule.currentPair[1] or PlayerResource:GetTeam( nTempPlayerID )==PvpModule.currentPair[2]) then
                 local data = {}
                 data.playerID = nTempPlayerID
                 data.teamID = PlayerResource:GetTeam( nTempPlayerID )
                 table.insert(dataList, data)
              end
           end
           for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
             local hPlayer = PlayerResource:GetPlayer(nPlayerID)
             if hPlayer and PlayerResource:IsValidPlayer(nPlayerID) then
                CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBrief", {players=dataList,firstTeamId=PvpModule.currentPair[1],secondTeamId=PvpModule.currentPair[2], betMap=PvpModule.betMap, bonusPool=math.floor(PvpModule.nBetBonus) })
             end
           end

       end
    end
    
    
    CustomGameEventManager:Send_ServerToAllClients("CreateQuest", { name = "RoundTimeLimit", text = "#round_time_limit", svalue = nRoundLimitTime, evalue = nRoundLimitTime, text_value=self.nRoundNumber })
    
    
    Timers:CreateTimer(1, function()
            
          if true == self.bEnd then
             return nil
          end 

          
          local bResult,nResult=xpcall(
            function()
          

for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
    local bTeamPvpFlag = false 

    for nPlayerIndex,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
        local bPlayerPvpFlag = false
        local vCenter = GameMode.vTeamLocationMap[nTeamNumber]
        local hPlayer = PlayerResource:GetPlayer(nPlayerID)
        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)  

        for i,pvpTeamID in ipairs(PvpModule.currentPair) do
           if pvpTeamID == nTeamNumber then
            for team_count = 0, 20 do
              if nTeamNumber ~= team_count then
                  if hHero and not hHero:IsNull() then
                    AddFOWViewer(team_count, hHero:GetAbsOrigin(), 600, 1, false)
                  end
                end
            end
           end
        end

        for i,nPvpPlayerID in ipairs(PvpModule.currentSinglePair) do
            if nPvpPlayerID == nPlayerID then
                local nTeamNumber = PlayerResource:GetTeam(nPvpPlayerID)
                for team_count = 0, 20 do
                  if nTeamNumber ~= team_count then
                    if hHero and not hHero:IsNull() then
                        AddFOWViewer(team_count, hHero:GetAbsOrigin(), 600, 1, false)
                    end
                  end
                end
            end
        end
    end
end

           
           for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
              if bAlive then
                  local bTeamAlive = false
                  for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                     
                     local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                     

                     if hHero:IsAlive() or hHero:IsReincarnating() then
                         hHero.nDeathTime =0
                         bTeamAlive=true
                     else
                         if hHero.nDeathTime == nil then
                            hHero.nDeathTime =0 
                         end
                         hHero.nDeathTime = hHero.nDeathTime+1
                     end
                     
                     if hHero.nDeathTime<=6 then
                        bTeamAlive=true
                     end
                  end
                  
                  if bTeamAlive==false then
                     GameMode:TeamLose(nTeamNumber)
                  end
              end
           end
           
           local bAllTeamFinish =  true
           
           local bNoAliveTeam = true

           for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
              if bAlive then
                  bNoAliveTeam = false
                  
                  if self.spanwers[nTeamNumber] and self.spanwers[nTeamNumber].bProgressFinished==false then
                     bAllTeamFinish=false
                  end
                  
                  if PvpModule.bEnd==false then
                     bAllTeamFinish=false
                  end
              end
           end
           
           if GameMode.nValidTeamNumber >= 3 and bNoAliveTeam  and  (GameMode.bRetry==nil) then
              GameMode.bRetry = true
              if  DOTA_GAMERULES_STATE_GAME_IN_PROGRESS == GameRules:State_Get() then 
                  if GameMode.rankMap[1] then
                       print("че?")
                  else
                       print("че звал сларк?")
                  end 
              end
           end

           
           if bAllTeamFinish then
             GameMode:FinishRound()
             CustomGameEventManager:Send_ServerToAllClients("RemoveQuest", {name = "RoundTimeLimit"})
             return nil
           end

          self.nTimeLimit = self.nTimeLimit - 1
          if self.nTimeLimit > 0 then
              CustomGameEventManager:Send_ServerToAllClients("RefreshQuest", { name = "RoundTimeLimit", text = "#round_time_limit", svalue =self.nTimeLimit, evalue = nRoundLimitTime,text_value=self.nRoundNumber })
          end

          
          if self.nTimeLimit==0 then
              self:RoundTimeOver()
          end

          if self.nTimeLimit<0 then
              self:RoundTimeExceeded()
          end

          return 1

          

          end,
            function(e)
                print(e)
                Server:UploadErrorLog(e)
          end)         
          

          
          if bResult then
             return nResult
          else
             return 1
          end

    end)
    
end




function Round:RoundTimeOver()
   
   for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
       if bAlive==true then
          if  self.spanwers[nTeamNumber] and self.spanwers[nTeamNumber].bProgressFinished==false then
              for i, hCreep in ipairs( self.spanwers[nTeamNumber].vCurrentCreeps ) do
                  if hCreep and (not hCreep:IsNull()) and hCreep:IsAlive() then
                     hCreep:AddNewModifier(hCreep, nil, "modifier_creature_berserk", {})
                  end
              end            
          end
       end
   end
   CustomGameEventManager:Send_ServerToAllClients("RefreshQuest", { name = "RoundTimeLimit", text = "#round_time_expire", svalue = 0, evalue = nRoundLimitTime })
end



function Round:RoundTimeExceeded()

   
   if PvpModule.bEnd == false and PvpModule.currentPair[1] and PvpModule.currentPair[2]  then
      local nTeamID1 = PvpModule.currentPair[1]
      local nTeamID2 = PvpModule.currentPair[2]
      
      local flPercentage1 = 0
      local flTotalHeath1 = 0
      for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID1) do
        local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID1, i)
        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
        if hHero then
          flPercentage1 =  flPercentage1 + hHero:GetHealthPercent()
          flTotalHeath1 =  flTotalHeath1 + hHero:GetHealth()
        end
      end

      local flPercentage2 = 0
      local flTotalHeath2 = 0
      for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID2) do
        local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID2, i)
        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
        if hHero then
          flPercentage2 =  flPercentage2 + hHero:GetHealthPercent()
          flTotalHeath2 =  flTotalHeath2 + hHero:GetHealth()
        end
      end
    
      
      if flPercentage1==flPercentage2 then
         if flTotalHeath1>flTotalHeath2 then
            PvpModule:EndPvp(nTeamID1,nTeamID2)
         else
            PvpModule:EndPvp(nTeamID2,nTeamID1)
         end
      else
         if flPercentage1>flPercentage2 then
            PvpModule:EndPvp(nTeamID1,nTeamID2)
         else
            PvpModule:EndPvp(nTeamID2,nTeamID1)
         end
      end
   end


   
   if PvpModule.bEnd == false and PvpModule.currentSinglePair[1] and PvpModule.currentSinglePair[2]  then
      local nPlayerID1 = PvpModule.currentSinglePair[1]
      local nPlayerID2 = PvpModule.currentSinglePair[2]
      
      local flPercentage1 = 0
      local flHeath1 = 0

      local hHero1 = PlayerResource:GetSelectedHeroEntity(nPlayerID1)
      if hHero1 then
          flPercentage1 =   hHero1:GetHealthPercent()
          flHeath1 =   hHero1:GetHealth()
      end


      local flPercentage2 = 0
      local flHeath2 = 0

      local hHero2 = PlayerResource:GetSelectedHeroEntity(nPlayerID2)
      if hHero2 then
          flPercentage2 =   hHero2:GetHealthPercent()
          flHeath2 =   hHero2:GetHealth()
      end

      
      if flPercentage1==flPercentage2 then
         if flHeath1>flHeath2 then
            PvpModule:EndSinglePvp(nPlayerID1,nPlayerID2)
         else
            PvpModule:EndSinglePvp(nPlayerID2,nPlayerID1)
         end
      else
         if flPercentage1>flPercentage2 then
            PvpModule:EndSinglePvp(nPlayerID1,nPlayerID2)
         else
            PvpModule:EndSinglePvp(nPlayerID2,nPlayerID1)
         end
      end
   end

end




function Round:End()
  self.bEnd = true
  PvpModule.currentPair ={}
  PvpModule.currentSinglePair ={}
  if self.nRoundNumber and compensateRoundNumber[self.nRoundNumber] then
     Round:CompensateRelearnBook(self.nRoundNumber)
  end
  
  
  Util:CleanFurArmySoldier()
end


function Round:CompensateRelearnBook(nRoundNumber) 

    local dataList= {}
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
      if bAlive then
         for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do          
            
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            
            if hHero  and  PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED   then
                print(hHero:IsTempestDouble(), "Проверка на темпест")
                local data = {}
                local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
                nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
                data.nGold = nGold
                data.nPlayerID = nPlayerID
                table.insert(dataList, data)
            end
         end
      end
    end

    if #dataList>=2 then
      table.sort(dataList, function(a, b) return a.nGold < b.nGold end)
      if dataList[1] and dataList[1].nPlayerID then
         local hHero = PlayerResource:GetSelectedHeroEntity(dataList[1].nPlayerID)
         if hHero then
            for _,nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
                if nPlayerIDInTeam then
                    local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
                    if hHeroInTeam then
                      if GetMapName()=="random_1x8" then
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")  
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")  
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")  
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")  
                      else
                         local hRelearnBook = hHeroInTeam:AddItemByName("item_relearn_book_lua")           
                         local hTornPage = hHeroInTeam:AddItemByName("item_relearn_torn_page_lua")
                         
                         if hTornPage and hTornPage.SetPurchaseTime then
                           hTornPage:SetPurchaseTime(0)
                         end
                         if hRelearnBook and hRelearnBook.SetPurchaseTime then
                           hRelearnBook:SetPurchaseTime(0)
                         end

                         local vData={}
                         vData.type = "compensate_relearn_book"
                         vData.round_number = tostring(nRoundNumber)
                         vData.playerId = dataList[1].nPlayerID
                         vData.book_type = 3
                         Barrage:FireBullet(vData)
                      end
                   end
                end
             end
         end
      end
      
      if #dataList>2 and dataList[2] and dataList[2].nPlayerID then
         local hHero = PlayerResource:GetSelectedHeroEntity(dataList[2].nPlayerID)
         if hHero then

            for _,nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
                if nPlayerIDInTeam then
                    local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
                    if hHeroInTeam then
                      if GetMapName()=="random_1x8" then
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")  
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")   
                      else
                         local hRelearnBook = hHeroInTeam:AddItemByName("item_relearn_book_lua")
                         if hRelearnBook and hRelearnBook.SetPurchaseTime then
                           hRelearnBook:SetPurchaseTime(0)
                         end
                         local vData={}
                         vData.type = "compensate_relearn_book"
                         vData.round_number = tostring(nRoundNumber)
                         vData.playerId = dataList[2].nPlayerID
                         vData.book_type = 2
                         Barrage:FireBullet(vData)
                      end
                   end
                end
             end
         end
      end
      
      if #dataList>3 and dataList[3] and dataList[3].nPlayerID then
         local hHero = PlayerResource:GetSelectedHeroEntity(dataList[3].nPlayerID)
         if hHero then


              for _,nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
                if nPlayerIDInTeam then
                    local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
                    if hHeroInTeam then
                      if GetMapName()=="random_1x8" then
                         hHeroInTeam:AddItemByName("item_chaos_scroll_lua")  
                      else
                         local hTornPage = hHeroInTeam:AddItemByName("item_relearn_torn_page_lua")
                         
                         if hTornPage and hTornPage.SetPurchaseTime then
                           hTornPage:SetPurchaseTime(0)
                         end
                         local vData={}
                         vData.type = "compensate_relearn_book"
                         vData.round_number = tostring(nRoundNumber)
                         vData.playerId = dataList[3].nPlayerID
                         vData.book_type = 1
                         Barrage:FireBullet(vData)
                      end
                   end
                end
             end
         end
      end
    end

end



function Round:PlayerReady(keys)

   local nPlayerID = keys.PlayerID
   if not nPlayerID then 
     return 
   end
   local hPlayer = PlayerResource:GetPlayer(nPlayerID)

   if hPlayer then

     self.readyPlayers[nPlayerID] = true
     CustomGameEventManager:Send_ServerToAllClients("UpdatePlayerReadyList", { readyPlayers = self.readyPlayers })
     CustomGameEventManager:Send_ServerToPlayer(hPlayer, "UpdateReadyButton", { visible = false })

   end

end