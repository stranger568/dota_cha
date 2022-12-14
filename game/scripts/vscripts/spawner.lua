if Spawner == nil then Spawner = class({}) end
LinkLuaModifier( "modifier_creature_true_sight", "creature_ability/modifier_creature_true_sight", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_spell_amplify", "creature_ability/modifier_creature_spell_amplify", LUA_MODIFIER_MOTION_NONE )


function Spawner:Init(nTeamNumber,round)
      
    self.round=round
    self.nTeamNumber =nTeamNumber
    self.vCurrentCreeps={}
    self.nEntityKilledEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( Spawner, 'OnEntityKilled' ), self )
    self.nKillProgress = 0
    
    self.nExtraCreatureNumber = 0
    self.bProgressFinished = false
    
    self.bForceStop = false


    local nRandomRange = RandomInt(450, 550)

     
    if GetMapName()=="2x6" then
      nRandomRange = RandomInt(400, 600)
    end

    if GetMapName()=="5v5" then
      nRandomRange = RandomInt(700, 1300)
    end
    
    
    local nTotalTrueSightNumber = math.floor(round.nRoundNumber/15)
    
    self.nLootLevel = math.ceil(round.nRoundNumber/10)

    local nTrueSightNumber = 0

    
    for k,vData in pairs(GameMode.vRoundData[round.sRoundName]) do
       local sUnitName = vData.UnitName
       local nUnitNumber = tonumber(vData.UnitNumber)
       local flSpawnInterval = tonumber(vData.SpawnInterval)
      
       
       if GetMapName()=="2x6" then
          flSpawnInterval = flSpawnInterval/1.2
       end

       if GetMapName()=="5v5" then
          flSpawnInterval = flSpawnInterval/3
       end

       local nTrueSight

       local nCurrentNumber = 0
       Timers:CreateTimer(function()

         nCurrentNumber = nCurrentNumber+1

         local vRandomPos=GameMode.vTeamLocationMap[nTeamNumber]+RandomVector(nRandomRange)

         local hUnit = CreateUnitByName(sUnitName, vRandomPos, true, nil, nil, DOTA_TEAM_NEUTRALS)
         local bonus = self:GetTeamPlaceBonusGold(nTeamNumber)

         self:CreaturePowerUp(hUnit,round.nRoundNumber-1,bonus)

         if nTrueSightNumber< nTotalTrueSightNumber then
             self:AddTrueSightForUnit(hUnit)
             nTrueSightNumber = nTrueSightNumber+1
         end

         
         hUnit.nSpawnerTeamNumber = nTeamNumber
         
         table.insert(self.vCurrentCreeps, hUnit)

         if (nCurrentNumber==nUnitNumber) or (self.bForceStop)  then
            return nil
         else
            return flSpawnInterval
         end
       end)
    end

    
    for nCreatureMapTeamNumber,list in pairs(ExtraCreature.teamCreatureMap) do
        
        if nCreatureMapTeamNumber~=nTeamNumber then
            for _,sExtraCreatureName in ipairs(list) do
                local vRandomPos=GameMode.vTeamLocationMap[nTeamNumber]+RandomVector(nRandomRange)
                local hUnit = CreateUnitByName(sExtraCreatureName, vRandomPos, true, nil, nil, DOTA_TEAM_NEUTRALS)

                local bonus = self:GetTeamPlaceBonusGold(nTeamNumber)

                self:CreaturePowerUp(hUnit,round.nRoundNumber-1,bonus)

                
                hUnit.nSpawnerTeamNumber = nTeamNumber
                self.nExtraCreatureNumber = self.nExtraCreatureNumber + 1
                
                table.insert(self.vCurrentCreeps, hUnit)
            end
        end
    end

    CustomGameEventManager:Send_ServerToTeam(nTeamNumber,"CreateQuest", { unique = 1, name = "RoundProgress", text = "#round_progress", svalue = 0, text_value=round.nRoundNumber, text_value_2="#"..round.sRoundName, evalue = (self.round.nCreatureNumber+self.nExtraCreatureNumber) })
end



function Spawner:GetTeamPlaceBonusGold(teamcheck) 

    local dataList= {}

    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive then
          for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if hHero  and  PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED   then
                local data = {}
                local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
                nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
                data.nGold = nGold
                data.team = hHero:GetTeamNumber()
                table.insert(dataList, data)
            end
         end
      end
    end

    if #dataList > 2 then
        table.sort(dataList, function(a, b) return a.nGold < b.nGold end)
        if dataList[1] and dataList[1].team == teamcheck then
            return 50
        elseif dataList[2] and dataList[2].team == teamcheck then
            return 30
        elseif dataList[3] and dataList[3].team == teamcheck then
            return 20
        end
    end

    return 0
end



function Spawner:OnEntityKilled(keys)

    local hKilledUnit = EntIndexToHScript( keys.entindex_killed )

    local hKiller
    if keys.entindex_attacker then
       hKiller = EntIndexToHScript( keys.entindex_attacker )
    end
    
    if not hKilledUnit:IsHero() then
       
       if hKilledUnit.nSpawnerTeamNumber == self.nTeamNumber then

        local round_count = self.round.nRoundNumber

        if hKiller and (hKiller:IsHero() or hKiller:GetOwner() ~= nil) then

            if round_count >= 1 and round_count <= 5 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][1] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 1, 1)
                end
            end

            if round_count >= 5 and round_count <= 10 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][5] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 1, 5 )
                  if GetMapName() == "2x6" then
                    ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 1, 5 )
                  end
                end
            end

            if round_count >= 10 and round_count <= 11 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][10] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 1, 10 )
                end
            end

            if round_count >= 11 and round_count <= 15 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][11] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 2, 11 )
                end
            end

            if round_count >= 15 and round_count <= 20 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][15] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 2, 15 )
                  if GetMapName() == "2x6" then
                    ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 2, 15 )
                  end
                end
            end

            if round_count >= 20 and round_count <= 21 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][20] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 2, 20 )
                end
            end

            if round_count >= 21 and round_count <= 25 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][21] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 3, 21 )
                end
            end

            if round_count >= 25 and round_count <= 30 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][25] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 3, 25 )
                  if GetMapName() == "2x6" then
                    ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 3, 25 )
                  end
                end
            end

            if round_count >= 30 and round_count <= 31 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][30] == nil then
                    ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 3, 30 )
                end
            end

            if round_count >= 31 and round_count <= 35 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][31] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 4, 31 )
                end
            end

            if round_count >= 35 and round_count <= 40 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][35] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 4, 35)
                  if GetMapName() == "2x6" then
                      ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 4, 35)
                  end
                end
            end

            if round_count >= 40 and round_count <= 41 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][40] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 4, 40)
                end
            end

            if round_count >= 41 and round_count <= 45 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][41] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 5, 41)
                end
            end

            if round_count >= 45 and round_count <= 50 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][45] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 5, 45)
                    if GetMapName() == "2x6" then
                      ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 5, 45)
                    end
                end
            end

            if round_count >= 50 then
                if ItemLoot.TeamHasNeutralItems[hKiller:GetTeamNumber()][50] == nil then
                  ItemLoot:DropItem(hKilledUnit, hKiller:GetTeamNumber(), hKiller, 5, 50)
                end
            end
        end

         
         for i, hCreep in ipairs( self.vCurrentCreeps ) do
            if hKilledUnit == hCreep then
              table.remove( self.vCurrentCreeps, i )
              
              self.nKillProgress = self.nKillProgress +1 

              CustomGameEventManager:Send_ServerToTeam(self.nTeamNumber, "RefreshQuest", { unique = 1, name = "RoundProgress", text = "#round_progress", svalue =self.nKillProgress, text_value=self.round.nRoundNumber, text_value_2="#"..self.round.sRoundName, evalue = (self.round.nCreatureNumber+self.nExtraCreatureNumber) })
              
              if self.nKillProgress == self.round.nCreatureNumber +self.nExtraCreatureNumber then
                  self:Finish()
              end
            end
         end 
       end
    end
end


function Spawner:Finish()
   
   
   self.round.nPlayerRank = self.round.nPlayerRank + 1


   self.bProgressFinished = true
   StopListeningToGameEvent( self.nEntityKilledEvent )

   

   local flReducePerRank = 0
   if  self.round.nAliveTeamNumber >= 1 then
     flReducePerRank = 1 / self.round.nAliveTeamNumber
   end
   
   if GetMapName()=="5v5" then
      flReducePerRank = 0.2
   end

   local nBonusGold = math.ceil(self.round.flBonus * (1-(self.round.nPlayerRank-1) *flReducePerRank))
   
   for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[self.nTeamNumber]) do

       local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)  
       
       
       if GetMapName()~="halloween_1x8" then
       
         
         local vBulletData = {}
         vBulletData.type = "round_finish"
         vBulletData.gold_value =tostring(nBonusGold)
         vBulletData.playerId = nPlayerID
         Barrage:FireBullet(vBulletData)

         
         SendOverheadEventMessage(hHero, OVERHEAD_ALERT_GOLD, hHero, nBonusGold, nil)
         PlayerResource:ModifyGold(nPlayerID,nBonusGold, true, DOTA_ModifyGold_GameTick)

       end

       
       if not (GetMapName()=="5v5" and hHero.bJoiningPvp) then         
            
           if not hHero:IsAlive() then
              hHero:RespawnHero(false, false)
           end

           
           Timers:CreateTimer({ endTime = 0.5, 
              callback = function()
                Util:MoveHeroToCenter(nPlayerID)             
                
                if not hHero:IsAlive() then
                   hHero:RespawnHero(false, false)
                end
                hHero:AddNewModifier(hHero, nil, "modifier_hero_refreshing", {})
              end
           })
       end

   end

   
   CustomGameEventManager:Send_ServerToTeam(self.nTeamNumber, "RemoveQuest", {name = "RoundProgress"})
end






function Spawner:CreaturePowerUp(hUnit,nlevel,bonus)
     
     local flMultiple= 1

     if GetMapName()=="random_1x8" then
        nlevel =  math.ceil(nlevel/1.5)
     end

     if nlevel<=10 then
        flMultiple= math.pow(1.196, nlevel)
     elseif nlevel>10 and nlevel<=20 then
        flMultiple= math.pow(1.196, 10) * math.pow(1.145, nlevel-10)
     elseif nlevel>20 and nlevel<=30 then
        flMultiple= math.pow(1.196, 10) *math.pow(1.145, 10)*math.pow(1.125, nlevel-20)
     elseif nlevel>30 then
        flMultiple= math.pow(1.196, 10) *math.pow(1.145, 10)*math.pow(1.125, 10)*math.pow(1.145, nlevel-30)
     end

     local flMaxHealth = hUnit:GetMaxHealth()*flMultiple
     
     if flMaxHealth>1800000000 then
         flMaxHealth = 1800000000
     end

     hUnit:SetAcquisitionRange(1500)
     hUnit:SetBaseMaxHealth(flMaxHealth)
     hUnit:SetMaxHealth(flMaxHealth)
     hUnit:SetHealth(flMaxHealth)

     local flGoldBountyMultiple = 0.75
     local bonus_gold = 0
     if nlevel >= 10 then
        bonus_gold = bonus
     end

     hUnit:SetMinimumGoldBounty(math.floor(hUnit:GetMinimumGoldBounty()* flGoldBountyMultiple ) + bonus_gold)
     hUnit:SetMaximumGoldBounty(math.floor(hUnit:GetMaximumGoldBounty()* flGoldBountyMultiple ) + bonus_gold)

     local flDamageMultiple=1
     
     if nlevel<=10 then
        flDamageMultiple= math.pow(1.165, nlevel)
     elseif nlevel>10 and nlevel<=20 then
        flDamageMultiple= math.pow(1.165, 10) * math.pow(1.124, nlevel-10)
     elseif nlevel>20 and nlevel<=30 then
        flDamageMultiple= math.pow(1.165, 10) *math.pow(1.124, 10)*math.pow(1.113, nlevel-20)
     elseif nlevel>30 then
        flDamageMultiple= math.pow(1.165, 10) *math.pow(1.124, 10)*math.pow(1.113, 10)*math.pow(1.1345, nlevel-30)
     end

     local flDamageMin = hUnit:GetBaseDamageMin()*flDamageMultiple
     if flDamageMin>1800000000 then
         flDamageMin = 1800000000
     end
     hUnit:SetBaseDamageMin(flDamageMin)

     local flDamageMax = hUnit:GetBaseDamageMax()*flDamageMultiple
     if flDamageMax>1800000000 then
         flDamageMax = 1800000000
     end
     hUnit:SetBaseDamageMax(flDamageMax)

     
     if self.round and self.round.nCreatureNumber and self.round.flExpMulti then
       hUnit:SetDeathXP( math.floor( (GameRules.xpTable[nlevel+1] -GameRules.xpTable[nlevel]) / self.round.nCreatureNumber * self.round.flExpMulti ))
     end

     
     local flSpeedMultiple = math.pow(1.058, nlevel)
     hUnit:SetBaseAttackTime(hUnit:GetBaseAttackTime()/flSpeedMultiple)
     
     
     if nlevel>60 then
        hUnit:SetBaseMagicalResistanceValue(hUnit:GetBaseMagicalResistanceValue()+(nlevel-60)*1)
     end
     
     if nlevel>100 then
        local hAbility = hUnit:AddAbility("creature_tear_armor")
        local nAbilityLevel = math.floor(nlevel/100)
        if nAbilityLevel>10 then
           nAbilityLevel = 10
        end
        hAbility:SetLevel(nAbilityLevel)
     end
     
     if nlevel>60 then
        hUnit:SetPhysicalArmorBaseValue(hUnit:GetPhysicalArmorBaseValue()+math.floor((nlevel-60)*0.65))
     end

     
     if nlevel>1 then
       local hMagicModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_creature_spell_amplify", {})
       hMagicModifier:SetStackCount(nlevel)
     end

end



function Spawner:AddTrueSightForUnit(hUnit)
    
     hUnit:AddNewModifier(hUnit, nil, "modifier_creature_true_sight", {})

end
