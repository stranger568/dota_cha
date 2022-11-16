if BotAI == nil then BotAI = class({}) end


function BotAI:Init()
   
   if not IsInToolsMode() then return end

   ListenToGameEvent("npc_spawned", Dynamic_Wrap(BotAI, "OnNPCSpawned"), self)

   BotAI.bFakeClientAI = false

   GameRules.itemKV = LoadKeyValues("scripts/npc/items.txt")
   GameRules.customItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
   
   
   GameRules.allItemKV= {}
   for k,v in pairs(GameRules.itemKV) do
      GameRules.allItemKV[k] = v
   end
   
   for k,v in pairs(GameRules.customItemKV) do
      GameRules.allItemKV[k] = v
   end
   
   Timers:CreateTimer(0, function()
	   for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		   local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
       local nTeamNumber = PlayerResource:GetTeam(nPlayerID)
		   
		   if hHero and PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_ABANDONED  and GameMode.vAliveTeam and nTeamNumber and GameMode.vAliveTeam[nTeamNumber] then 
	          if not hHero.bTakenOverByBot then
                
               
               if GameMode.currentRound and  GameMode.currentRound.nRoundNumber and GameMode.currentRound.nRoundNumber<=8 then
                  local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
                  if nPlayerSteamId then
                    GameRules.sEarlyLeavePlayerSteamIds=GameRules.sEarlyLeavePlayerSteamIds..nPlayerSteamId..","
                  end
               end

	          	 hHero.bTakenOverByBot=true
               
               local vData={}
               vData.type = "bot_take_over"
               vData.playerId = nPlayerID
               Barrage:FireBullet(vData)
               
               BotAI:StartMainThinker(hHero)   
               
               
               if hHero.bSelectingAbility then
                  hHero.bSelectingAbility = false
                  BotAI:AddAbilityInBuild(hHero)
               end
	          end
		   end
       
       
       
       
       if hHero and PlayerResource:IsFakeClient(nPlayerID) then 
            if not hHero.bTakenOverByBot then
               hHero.bTakenOverByBot=true              
               BotAI:StartMainThinker(hHero)           
            end
       end
	   end
	   return 0.5
    end)

    BotAI.builds={}

    BotAI.builds["summon"] = {}
    
    
    BotAI.builds["summon"]["score_abilities"] = {"furion_force_of_nature","undying_tombstone_lua","lone_druid_spirit_bear","shadow_shaman_mass_serpent_ward","witch_doctor_death_ward","brewmaster_primal_split","warlock_rain_of_chaos","visage_summon_familiars"}
    BotAI.builds["summon"]["build_abilities"] = {"furion_force_of_nature","undying_tombstone_lua","lone_druid_spirit_bear","abaddon_borrowed_time","shadow_shaman_mass_serpent_ward","skeleton_king_reincarnation"}
    BotAI.builds["summon"]["items"] = {"item_summoner_crown_2","item_blade_mail","item_vladmir","item_summoner_crown_2","item_recipe_summoner_crown_3","item_octarine_core","item_ethereal_blade","item_heart","item_paragon_book","item_aegis_lua","item_aegis_lua"}

    BotAI.builds["magic"] = {}
    BotAI.builds["magic"]["score_abilities"] = {"beastmaster_wild_axes","frostivus2018_dark_willow_bedlam","earthshaker_aftershock","dazzle_bad_juju","death_prophet_spirit_siphon","rubick_arcane_supremacy","ogre_magi_multicast_lua"}
    BotAI.builds["magic"]["build_abilities"] = {"beastmaster_wild_axes","frostivus2018_dark_willow_bedlam","earthshaker_aftershock","dazzle_bad_juju","death_prophet_spirit_siphon","abaddon_borrowed_time","rubick_arcane_supremacy"}
    BotAI.builds["magic"]["items"] =  {"item_kaya_2_lua","item_heart","item_kaya_2_lua","item_recipe_kaya_3_lua","item_bloodstone_2","item_ethereal_blade","item_ultimate_scepter","item_recipe_ultimate_scepter_2","item_aghanims_shard","item_lotus_orb","item_sheepstick","item_paragon_book","item_aegis_lua","item_aegis_lua"}

    BotAI.builds["physical"] = {}
    BotAI.builds["physical"]["score_abilities"] = {"doom_bringer_infernal_blade","frostivus2018_dark_willow_bedlam","drow_ranger_marksmanship","ursa_fury_swipes","life_stealer_feast","slardar_bash","alchemist_chemical_rage"}
    BotAI.builds["physical"]["build_abilities"] = {"doom_bringer_infernal_blade","frostivus2018_dark_willow_bedlam","drow_ranger_marksmanship","ursa_fury_swipes","life_stealer_feast","slardar_bash","alchemist_chemical_rage"}
    BotAI.builds["physical"]["items"] =  {"item_butterfly","item_blade_mail","item_ultimate_scepter","item_satanic","item_assault","item_moon_shard","item_dark_moon_shard","item_recipe_ultimate_scepter_2","item_aghanims_shard","item_bloodthorn","item_silver_edge","item_paragon_book","item_aegis_lua","item_aegis_lua"}

    BotAI.builds["tank"] = {}
    BotAI.builds["tank"]["score_abilities"] = {"spectre_dispersion","mars_bulwark","abaddon_borrowed_time","ursa_enrage","life_stealer_feast","skeleton_king_reincarnation","troll_warlord_fervor"}
    BotAI.builds["tank"]["build_abilities"] = {"spectre_dispersion","mars_bulwark","abaddon_borrowed_time","ursa_enrage","life_stealer_feast","skeleton_king_reincarnation","troll_warlord_fervor"}
    BotAI.builds["tank"]["items"] = {"item_blade_mail","item_heart","item_assault","item_butterfly","item_moon_shard","item_dark_moon_shard","item_satanic","item_ultimate_scepter","item_recipe_ultimate_scepter_2","item_silver_edge","item_aghanims_shard","item_paragon_book","item_aegis_lua","item_aegis_lua"}

    BotAI.builds["dot"] = {}
    BotAI.builds["dot"]["score_abilities"] = {"jakiro_macropyre","viper_nethertoxin","frostivus2018_huskar_burning_spear","dark_seer_ion_shell","disruptor_static_storm","venomancer_poison_nova","doom_bringer_doom","jakiro_dual_breath"}
    BotAI.builds["dot"]["build_abilities"] = {"frostivus2018_huskar_burning_spear","jakiro_macropyre","viper_nethertoxin","abaddon_borrowed_time","dazzle_bad_juju","dark_seer_ion_shell"}
    BotAI.builds["dot"]["items"] = {"item_blade_mail","item_torture_pipe_2_datadriven","item_kaya_2_lua","item_bloodstone_2","item_heart","item_kaya_2_lua","item_recipe_kaya_3_lua","item_ultimate_scepter","item_recipe_ultimate_scepter_2","item_shivas_guard","item_paragon_book","item_aegis_lua","item_aegis_lua"}

    
    BotAI.abilityException={"mars_bulwark","lone_druid_spirit_bear_return","nyx_assassin_burrow","nyx_assassin_unburrow"}
    
    BotAI.consumableItem={"item_aghanims_shard","item_dark_moon_shard","item_moon_shard","item_paragon_book","item_aegis_lua","item_book_of_strength","item_book_of_agility","item_book_of_intelligence","item_ultimate_scepter_2"}
    
end


function BotAI:StartMainThinker(hHero)

    Timers:CreateTimer(0.05, function()

	    if GameRules:IsGamePaused() then
	  		return 0.05
	  	end

	    if not hHero:IsAlive() then
	  		return 0.1
	  	end

	    if hHero:IsChanneling() then
	  		return 0.1
	  	end
       
       local bResult,nResult=xpcall(
        function()
       
    	    if hHero:HasModifier("modifier_hero_refreshing") then
    	        return BotAI:HomeThink(hHero) 
    	    else
    	    	return BotAI:BattleThink(hHero) 
    	    end
        
        end,
        function(e)
            print(e)
        end)         
        
        
        
        if bResult then
            return nResult
        else
            return 0.1
        end

	end)

end


function BotAI:HomeThink(hHero) 
    
  
  Timers:CreateTimer(0.05, function()
	  BotAI:Untoggle(hHero)
  end)

  if hHero:GetAbilityPoints() > 0 then
	  Timers:CreateTimer(0.1, function()
		  BotAI:TrainAbility(hHero)
	  end)
  end

  Timers:CreateTimer(0.15, function()

   
    xpcall(
    function()
   
	    BotAI:Shopping(hHero)
    
    end,
    function(e)
        print(e)
    end)         
    

  end)

  Timers:CreateTimer(0.2, function()
    
    BotAI:ArrangeInventory(hHero)
  end)

  local flRearm = BotAI:HomeRearm(hHero)
  if flRearm then
  	return flRearm
  end
  
  return 1
end

function BotAI:BattleThink(hHero) 

   if hHero.GetAbilityPoints and hHero:GetAbilityPoints() > 0 then
		Timers:CreateTimer(0.1, function()
			BotAI:TrainAbility(hHero)
		end)
   end
    
   local hTarget

   
   if hHero.hTarget and not hHero.hTarget:IsNull() and hHero.hTarget:IsAlive() and CalcDistanceBetweenEntityOBB(hHero,hHero.hTarget)<1500 and CalcDistanceBetweenEntityOBB(hHero,hHero.hTarget)>=0 then
       hTarget=hHero.hTarget
   else
     local vEnemies = FindUnitsInRadius(hHero:GetTeam(), hHero:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
     
     
     for _,hEnemy in pairs(vEnemies) do
         if hEnemy and not hEnemy:IsNull() and hEnemy:IsAlive() and (not hEnemy:IsUnselectable()) then                      
            hTarget =  hEnemy
            hHero.hTarget = hEnemy
            break
         end
     end

     
     if nil==hTarget then
     	  
     	  hHero.hTarget=nil
     	  ExecuteOrderFromTable({
          UnitIndex = hHero:entindex(),
          OrderType = DOTA_UNIT_ORDER_HOLD_POSITION,
        })
     	  return 0.5
     end
   end
   
   local flAbilityCastTime = BotAI:TryCastAbility(hHero,hTarget)

   
   if flAbilityCastTime then
  	 return flAbilityCastTime
   else
     
     local flItemCastTime = BotAI:TryCastItem(hHero,hTarget)
     if flItemCastTime then
        return flItemCastTime
     else
         if not hHero:IsAttacking() then
            
            if hHero:HasMovementCapability() then
          	  ExecuteOrderFromTable({
                  UnitIndex = hHero:entindex(),
                  OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                  Position = hTarget:GetOrigin()
              })
            else
              ExecuteOrderFromTable({
                  UnitIndex = hHero:entindex(),
                  OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                  TargetIndex = hTarget:entindex()
              })
            end
         end
     end

   end

   return 0.5
end


function BotAI:Untoggle(hHero)

	for i = 0, 17 do
		hAbility = hHero:GetAbilityByIndex(i)
		if hAbility ~= nil and hAbility:GetLevel() > 0 then
			if hAbility:IsToggle() then
				if hAbility:GetToggleState() then
					hAbility:ToggleAbility()
				end
			end
		end
	end
end


function BotAI:HomeRearm(hHero)
	
	for i = 0, 17 do
		hAbility = hHero:GetAbilityByIndex(i)
		if hAbility ~= nil and hAbility:GetLevel() > 0 then
			if (hAbility:GetName() == "tinker_rearm_datadriven") and hHero:GetMana() >= hAbility:GetManaCost(hAbility:GetLevel()) then
				local newOrder = {
					UnitIndex = hHero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hAbility:entindex(),
					Queue = 0
				}
				ExecuteOrderFromTable(newOrder)
				return hAbility:GetChannelTime()
			end
		end
	end
	return nil
end



function BotAI:TrainAbility(hHero)
	for i = 0, 23 do
		local hAbility = hHero:GetAbilityByIndex(i)
		if hAbility and  hAbility:CanAbilityBeUpgraded() and hAbility:GetHeroLevelRequiredToUpgrade() <= hHero:GetLevel() and hAbility:GetLevel() < hAbility:GetMaxLevel() and hHero:GetAbilityPoints()>=1 then
			local newOrder = {
				UnitIndex = hHero:entindex(), 
				OrderType = DOTA_UNIT_ORDER_TRAIN_ABILITY,
				TargetIndex = 0,
				AbilityIndex = hAbility:entindex(),
				Position = nil,
				Queue = 0,
			}
			ExecuteOrderFromTable(newOrder)
		end
	end
end


function BotAI:Shopping(hHero)
    
    
    if hHero.bBotItemInit ==nil then
       hHero.bBotItemInit = true

       if hHero.nBotSpendGold ==nil then
          hHero.nBotSpendGold = 0
       end
       
       for i=1,30 do
          local hItem=hHero:GetItemInSlot(i-1)
          if  hItem then              
              local hContainner = hItem:GetContainer()
              UTIL_Remove(hItem)
              if hContainner then
                 UTIL_Remove(hContainner)
              end
          end 
       end
       local sBuildName = BotAI:GetHeroBuild(hHero)
       
       hHero.shoppingCart= table.deepcopy(BotAI.builds[sBuildName]["items"])
       
       
       if hHero:HasModifier("modifier_item_moon_shard_consumed") then
           table.pop_back_item(hHero.shoppingCart,"item_moon_shard")
       end

       if hHero:HasModifier("modifier_item_dark_moon_shard") then
          table.pop_back_item(hHero.shoppingCart,"item_dark_moon_shard")
       end
       
       if hHero:HasModifier("modifier_item_ultimate_scepter_consumed") then
          table.pop_back_item(hHero.shoppingCart,"item_ultimate_scepter")
          table.pop_back_item(hHero.shoppingCart,"item_recipe_ultimate_scepter_2")
       end

       if hHero:HasModifier("modifier_item_aghanims_shard") then
          table.pop_back_item(hHero.shoppingCart,"item_aghanims_shard")
       end
       
       if hHero.bUsedParagon then
          table.pop_back_item(hHero.shoppingCart,"item_paragon_book")
       end
       
       
       hHero.shoppingCart=BotAI:DisassembleItem(hHero.shoppingCart)

    end

    
    for i=1,30 do
        local hItem=hHero:GetItemInSlot(i-1)
        if  hItem and (hItem:GetAbilityName()=="item_relearn_book_lua" or  hItem:GetAbilityName()=="item_relearn_torn_page_lua" ) then
            local nCost = GetItemCost(hItem:GetAbilityName())
            PlayerResource:ModifyGold(hHero:GetPlayerID(), nCost, true, DOTA_ModifyGold_GameTick)           
            local hContainner = hItem:GetContainer()
            UTIL_Remove(hItem)
            if hContainner then
               UTIL_Remove(hContainner)
            end
        end
    end
    
    
    
    if #hHero.shoppingCart>0 then
        local sItemName = hHero.shoppingCart[1]
    	  if Util:GetBotEarnedGold(hHero:GetPlayerID())- hHero.nBotSpendGold >= GetItemCost(sItemName) then
            hHero.nBotSpendGold = hHero.nBotSpendGold + GetItemCost(sItemName)
			      hHero:AddItemByName(sItemName)
            table.remove(hHero.shoppingCart, 1)
    	  end
    end

    

end




function BotAI:TryCastAbility(hHero,hTarget)

 	local flAbilityCastTime = BotAI:CastAbility(hHero,hTarget)
 	if flAbilityCastTime then
 		return flAbilityCastTime
 	end
	return nil

end



function BotAI:TryCastItem(hHero,hTarget)

    local flItemCastTime = BotAI:CastItem(hHero,hTarget)
    if flItemCastTime then
        return flItemCastTime
    end
    return nil

end




function ContainsValue(sum,nValue)
  
  if type(sum) == "userdata" then
     sum = tonumber(tostring(sum))
  end

  if bit:_and(sum,nValue)==nValue then
        return true
  else
      	return false
  end

end




function BotAI:CastAbility(hHero,hTarget)
    
    for i=1,20 do
        local hAbility=hHero:GetAbilityByIndex(i-1)
        if  hAbility and not hAbility:IsPassive() and not hAbility:IsHidden() and hAbility:IsFullyCastable() and not table.contains(BotAI.abilityException,hAbility:GetAbilityName()) then
        	
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and not ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_ATTACK) then
        		
            
          	if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_ENEMY) or ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_CUSTOM) then
  					    
                local bCondition = true
                
                
                if hTarget:IsRealHero() and hAbility:GetAbilityName()=="life_stealer_infest" then
                   bCondition = false
                end
                
                if hTarget:HasModifier("modifier_death_prophet_spirit_siphon_slow") and  hAbility:GetAbilityName()=="death_prophet_spirit_siphon" then
                   bCondition = false
                end

                if bCondition then
                   ExecuteOrderFromTable({
      							UnitIndex = hHero:entindex(),
      							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
      							AbilityIndex = hAbility:entindex(),
      					        TargetIndex = hTarget:entindex()
      						 })
      						 return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
            end
 
            
            if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
  					    ExecuteOrderFromTable({
  							UnitIndex = hHero:entindex(),
  							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
  							AbilityIndex = hAbility:entindex(),
  					        TargetIndex = hHero:entindex()
  						})
  				    return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
            end
        	end

        	
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_POINT) then
        		    
				      local vLeadingOffset = hTarget:GetForwardVector() * RandomInt( 25, 75 )
              local vTargetPos = hTarget:GetOrigin() + vLeadingOffset
              local bCondition = true
              
              if hAbility:GetAbilityName()=="furion_force_of_nature" then
                 local trees = GridNav:GetAllTreesAroundPoint(hHero:GetOrigin(), 1000, true)
                 
                 if #trees>0 then
                    local flMinDistance =  (hHero:GetOrigin() - trees[1]:GetOrigin()):Length2D()
                    local vTreePosition = trees[1]:GetOrigin()
                    for _,hTree in ipairs(trees) do
                        if (hHero:GetOrigin() - hTree:GetOrigin()):Length2D()< flMinDistance then                       
                             flMinDistance = (hHero:GetOrigin() - hTree:GetOrigin()):Length2D()
                             vTreePosition =  hTree:GetOrigin()
                        end
                    end
                    vTargetPos = vTreePosition
                 else
                    bCondition = false
                 end
              end

              
              if hAbility:GetAbilityName()=="beastmaster_wild_axes" then
                 vTargetPos = hTarget:GetOrigin() + (vTargetPos-hHero:GetOrigin()):Normalized() * (hAbility:GetCastRange()-30)
              end

              if bCondition then
          			ExecuteOrderFromTable({
          					UnitIndex = hHero:entindex(),
          					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
          					Position =  vTargetPos,
          					AbilityIndex = hAbility:entindex(),
          		  })
  				      return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
              end
        	end

        	
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_NO_TARGET) and not ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST)  and not ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_TOGGLE)    then
    			
			    ExecuteOrderFromTable({
					UnitIndex = hHero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        	
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST) then   		    
    		   if not hAbility:GetAutoCastState() then
                  hAbility:ToggleAutoCast()
    		   end
        	end

            
            if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_TOGGLE) then            
               if not hAbility:GetToggleState() then
                    hAbility:ToggleAbility()
                end
            end
        end
    end

end


function BotAI:AddAbilityInBuild(hHero)
    
    local nPlayerID = hHero:GetPlayerID()

    local sBuild = BotAI:GetHeroBuild(hHero)

    local sAbilityName = ""
    
    
    for _,v in ipairs(BotAI.builds[sBuild]["build_abilities"]) do
    	if not table.contains(hHero.abilitiesList, v) then
           sAbilityName = v
           break
    	end
    end
    
    if not hHero.nAbilityNumber then
       hHero.nAbilityNumber = 0
    end

    hHero.nAbilityNumber = hHero.nAbilityNumber+1

    table.insert(hHero.abilitiesList, sAbilityName)
    
    HeroBuilder:AddAbility(nPlayerID, sAbilityName)

    if hHero.nAbilityNumber<HeroBuilder.totalAbilityNumber[nPlayerID] then
        HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
    end

end


function BotAI:CastItem(hHero,hTarget)
    
    for i=1,17 do
        local hItem=hHero:GetItemInSlot(i-1)
        
        if  (i<=6 or i==17) and  hItem and not hItem:IsPassive() and hItem:IsFullyCastable() and not hItem:IsNull() and (not (hItem:RequiresCharges() and hItem:GetCurrentCharges()==0)) and hItem.GetAbilityName and (hItem:GetAbilityName()~="item_vambrace" and hItem:GetAbilityName()~="item_power_treads" and hItem:GetAbilityName()~="item_bfury" and hItem:GetAbilityName()~="item_tpscroll") then
            
            
            if ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and not ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_ATTACK) then
              
              local bCondition = true                      
              
              if ContainsValue(hItem:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_ENEMY) or ContainsValue(hItem:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_CUSTOM) then
                      
                    
                    if hItem:GetAbilityTargetType()==DOTA_UNIT_TARGET_HERO and not hTarget:IsRealHero() then
                        bCondition = false
                    end                       
                    
                    if bCondition then
                        ExecuteOrderFromTable({
                            UnitIndex = hHero:entindex(),
                            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                            AbilityIndex = hItem:entindex(),
                            TargetIndex = hTarget:entindex()
                        })
                        return hItem:GetCastPoint()+RandomFloat(0.05, 0.1)
                    end
              end

              
              if ContainsValue(hItem:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
                  
                  
                  if hItem:GetAbilityName()=="item_royal_jelly" and hHero:HasModifier("modifier_royal_jelly") then
                     bCondition=false
                  end

                  if hItem:GetAbilityName()=="item_moon_shard" and hHero:HasModifier("modifier_item_moon_shard_consumed") then
                     bCondition=false
                  end

                  if hItem:GetAbilityName()=="item_dark_moon_shard" and hHero:HasModifier("modifier_item_dark_moon_shard") then
                     bCondition=false
                  end

                  if bCondition then
                      local flResult = hItem:GetCastPoint()+RandomFloat(0.05, 0.1)
                      ExecuteOrderFromTable({
                              UnitIndex = hHero:entindex(),
                              OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                              AbilityIndex = hItem:entindex(),
                              TargetIndex = hHero:entindex()
                      })
                      return flResult
                  end
              end

            end

            
            if ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_POINT) then
                
                local vLeadingOffset = hTarget:GetForwardVector() * RandomInt( 25, 75 )
                local vTargetPos = hTarget:GetOrigin() + vLeadingOffset
                ExecuteOrderFromTable({
                    UnitIndex = hHero:entindex(),
                    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
                    Position =  vTargetPos,
                    AbilityIndex = hItem:entindex(),
                })
                return hItem:GetCastPoint()+RandomFloat(0.05, 0.1)
            end

            
            if ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_NO_TARGET) and not ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST)  and not ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_TOGGLE)    then
                
                
                local bCondition = true
                if hItem:GetAbilityName()=="item_blade_mail" or hItem:GetAbilityName()=="item_satanic" or hItem:GetAbilityName()=="item_shivas_guard" then
                   if hHero:GetHealth()/hHero:GetMaxHealth()>0.9 then
                      bCondition=false
                   end
                end

                if hItem:GetAbilityName()=="item_dark_moon_shard" and hHero:HasModifier("modifier_item_dark_moon_shard") then
                   bCondition=false
                end

                if hItem:GetAbilityName()=="item_moon_shard" and hHero:HasModifier("modifier_item_moon_shard_consumed") then
                   bCondition=false
                end
               
                
                if  hItem:GetAbilityName()=="item_relearn_torn_page_lua" or  hItem:GetAbilityName()=="item_relearn_book_lua" or hItem:GetAbilityName()=="item_summon_book_lua" or hItem:GetAbilityName()=="item_spell_book_empty_lua"  or hItem:GetAbilityName()=="item_swap_essence" then
                   bCondition=false
                end
                
                if bCondition then
                    if hItem then
                        local flResult = hItem:GetCastPoint()+RandomFloat(0.05, 0.1)
                        ExecuteOrderFromTable({
                            UnitIndex = hHero:entindex(),
                            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                            AbilityIndex = hItem:entindex(),
                        })
                        return flResult
                    end
                end
            end

            
            if ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST) then            
               if not hItem:GetAutoCastState() then
                  hItem:ToggleAutoCast()
               end
            end

            
            if ContainsValue(hItem:GetBehavior(),DOTA_ABILITY_BEHAVIOR_TOGGLE) then
                 if not hItem:GetToggleState() then
                    hItem:ToggleAbility()
                 end
            end
        end
    end

end



function BotAI:GetHeroBuild(hHero)

    if hHero.sBuild then 
       return hHero.sBuild
    end
   
    local sBuild = "magic"
    
    
    if hHero.nAbilityNumber==nil or hHero.nAbilityNumber==0 then
        sBuild= BotAI:GetRawHeroBuild(hHero)
    else
        local builds = {}
        
        for k,_ in pairs(BotAI.builds) do
            
            local build = {}
            build.sName= k
            build.nScore= 0
            
            for _,sAbilityName in ipairs(BotAI.builds[k]["score_abilities"]) do
                if hHero:HasAbility(sAbilityName) then
                    build.nScore = build.nScore +1
                end
            end
            table.insert(builds, build)
        end
        
        table.sort(builds,function(a, b) return a.nScore > b.nScore end)

        
        if builds[1].nScore>0 then
           sBuild = builds[1].sName
        else
           sBuild= BotAI:GetRawHeroBuild(hHero)
        end
    end 
    
    
    hHero.sBuild = sBuild

    return sBuild  
    
end



function BotAI:GetRawHeroBuild(hHero)
    
    local sBuild = "magic"
  
    if hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
         sBuild="physical"
    end
    
    if hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
         sBuild="tank"
    end

    if hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
         sBuild="magic"
    end

    if hHero:GetUnitName()=="npc_dota_hero_furion" or hHero:GetUnitName()=="npc_dota_hero_undying" or hHero:GetUnitName()=="npc_dota_hero_venomancer" then
       sBuild="summon"
    end

    local nRandom = RandomInt(1, 100)
    
    if nRandom<=8 then
       sBuild="summon"
    end

    
    if nRandom>8 and nRandom<=16 then
       sBuild="dot"
    end
    
    if IsInToolsMode() then
       
    end

    return sBuild  
    
end


function BotAI:ArrangeInventory(hHero)

    for i=7,16 do
      local hItem=hHero:GetItemInSlot(i-1)
      
      if hItem and  table.contains(BotAI.consumableItem,hItem:GetAbilityName()) then
         local inventoryList = {}
         for j=1,6 do
             local hInventoryItem=hHero:GetItemInSlot(j-1)
             local itemInfo = {}
             itemInfo.nSlot = j
             itemInfo.nCost = 0
             if hInventoryItem then
                if hInventoryItem:GetAbilityName() and GetItemCost(hInventoryItem:GetAbilityName()) then
                  itemInfo.nCost = GetItemCost(hInventoryItem:GetAbilityName())
                end
                if table.contains(BotAI.consumableItem,hInventoryItem:GetAbilityName()) then
                  itemInfo.nCost = 99999
                end
             end
             table.insert(inventoryList, itemInfo)
         end
         
         table.sort(inventoryList,function(a, b) return a.nCost < b.nCost end)
         local nCheapestSlot = inventoryList[1].nSlot
         hHero:SwapItems(nCheapestSlot-1, i-1)      
      end
    end

    
    for i=1,6 do
      local hItem=hHero:GetItemInSlot(i-1)
      if hItem  and table.contains(BotAI.consumableItem,hItem:GetAbilityName()) then
          ExecuteOrderFromTable({
              UnitIndex = hHero:entindex(),
              OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
              AbilityIndex = hItem:entindex(),
          })      
      end
    end

    
    for i=7,16 do
      local hItem=hHero:GetItemInSlot(i-1)
      if hItem then
         for j=1,6 do
            local hInventoryItem=hHero:GetItemInSlot(j-1)
            if hInventoryItem==nil then
              hHero:SwapItems(j-1, i-1)
            end
         end
      end
    end

end




function BotAI:OnNPCSpawned(event)

    local hSpawnedUnit = EntIndexToHScript(event.entindex)
    if  hSpawnedUnit and not hSpawnedUnit:IsNull() and  (hSpawnedUnit:IsIllusion() or hSpawnedUnit:IsTempestDouble() or hSpawnedUnit:HasModifier("modifier_arc_warden_tempest_double_lua") or hSpawnedUnit:IsSummoned() or Summon.efficiency[hSpawnedUnit:GetUnitName()] ) then      
        local hOwner = hSpawnedUnit:GetOwner()
        
        if (hOwner and hOwner.bTakenOverByBot) or hSpawnedUnit:GetUnitName()=="npc_dota_creature_tombstone_zombie" or hSpawnedUnit:GetUnitName()=="npc_dota_creature_tombstone_zombie_torso" then
           BotAI:StartSummonThinker(hSpawnedUnit)        
        end
    end
end


function BotAI:StartSummonThinker(hUnit)

    Timers:CreateTimer(0.05, function()

      if GameRules:IsGamePaused() then
        return 0.05
      end

      if hUnit==nil then
         return nil
      end

      if hUnit:IsNull() then
         return nil
      end

      if not hUnit:IsAlive() then
        return 0.1
      end

      if hUnit:IsChanneling() then
        return 0.1
      end

      
      local bResult,nResult=xpcall(
        function()
       
           return BotAI:BattleThink(hUnit) 
        
        end,
        function(e)
            print(e)
        end)         
        
        
        
        if bResult then
            return nResult
        else
            return 0.1
      end

  end)

end


function BotAI:DisassembleItem(itemList) 
    
    local result = {}
    for _,sItemName in ipairs(itemList) do
      local sItemNameSub = string.sub(sItemName,6,string.len(sItemName))
      
      if GameRules.allItemKV["item_recipe_"..sItemNameSub] then
         local itemRequirements = GameRules.allItemKV["item_recipe_"..sItemNameSub].ItemRequirements
         local itemParts = string.split( string.gsub(itemRequirements["01"], "*", ""),";")
         result=table.join(result,BotAI:DisassembleItem(itemParts))
         if GameRules.allItemKV["item_recipe_"..sItemNameSub].ItemCost and GameRules.allItemKV["item_recipe_"..sItemNameSub].ItemCost~="" and GameRules.allItemKV["item_recipe_"..sItemNameSub].ItemCost>0 then
            table.insert(result, "item_recipe_"..sItemNameSub)
         end
      
      else
         table.insert(result, sItemName)
      end
    end
    return result

end



function BotAI:PickNeutralItem(hHero) 
    
     local nTeamNumber = hHero:GetTeam()

     if #ItemLoot.droppedItemList[nTeamNumber]>0 then
        local sLastItemName = ItemLoot.droppedItemList[nTeamNumber][#ItemLoot.droppedItemList[nTeamNumber]]
        
        
        if sLastItemName=="item_mango_tree" or sLastItemName=="item_elixer" or sLastItemName=="item_ironwood_tree" then
          return
        end
        
        if sLastItemName=="item_iron_talon"  then
          return
        end

        local hCurrentItem = hHero:GetItemInSlot(16)
        local bNeedChange = true
        if hCurrentItem then
           local sCurrentItemName = hCurrentItem:GetAbilityName()
           
           if nil==ItemLoot.itemLevelMap[sCurrentItemName] or nil==ItemLoot.itemLevelMap[sLastItemName] then
               return
           end
           if ItemLoot.itemLevelMap[sCurrentItemName]>= ItemLoot.itemLevelMap[sLastItemName] then
               bNeedChange = false
           end
        end
              
        if bNeedChange then
           
           local hItem=hHero:GetItemInSlot(16)
           if hItem then              
              local hContainner = hItem:GetContainer()
              UTIL_Remove(hItem)
              if hContainner then
                 UTIL_Remove(hContainner)
              end
           end
           
           hHero:AddItemByName(sLastItemName)
        end
     end
end