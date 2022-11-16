if Summon == nil then Summon = class({}) end
LinkLuaModifier( "modifier_clinkz_skeletons", "heroes/hero_clinkz/modifier_clinkz_skeletons", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_ward_custom_bkb", "heroes/modifier_death_ward_custom_bkb", LUA_MODIFIER_MOTION_NONE )

function Summon:Init()
  ListenToGameEvent("npc_spawned", Dynamic_Wrap(Summon, "OnNPCSpawned"), self)
  
  Summon.efficiency = {}
  Summon.efficiency["npc_dota_lone_druid_bear1"] = 1.0
  Summon.efficiency["npc_dota_lone_druid_bear2"] = 1.0
  Summon.efficiency["npc_dota_lone_druid_bear3"] = 1.0
  Summon.efficiency["npc_dota_lone_druid_bear4"] = 1.0
  Summon.efficiency["npc_dota_venomancer_plague_ward_1"] = 1.0
  Summon.efficiency["npc_dota_venomancer_plague_ward_2"] = 1.0
  Summon.efficiency["npc_dota_venomancer_plague_ward_3"] = 1.0
  Summon.efficiency["npc_dota_venomancer_plague_ward_4"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_storm_1"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_storm_2"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_storm_3"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_fire_1"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_fire_2"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_fire_3"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_earth_1"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_earth_2"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_earth_3"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_void_1"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_void_2"] = 1.0
  Summon.efficiency["npc_dota_brewmaster_void_3"] = 1.0



  Summon.efficiency["npc_dota_clinkz_skeleton_archer_custom"] = 1.0
  Summon.efficiency["npc_dota_unit_undying_zombie"] = 1.0






  Summon.efficiency["npc_dota_witch_doctor_death_ward"] = 1.0
  Summon.efficiency["npc_dota_shadow_shaman_ward_1"] = 0.45
  Summon.efficiency["npc_dota_shadow_shaman_ward_2"] = 0.45
  Summon.efficiency["npc_dota_shadow_shaman_ward_3"] = 0.45
  
  Summon.efficiency["npc_dota_warlock_golem_1"] = 0.7
  Summon.efficiency["npc_dota_warlock_golem_2"] = 0.7
  Summon.efficiency["npc_dota_warlock_golem_3"] = 0.7
  Summon.efficiency["npc_dota_warlock_golem_scepter_1"] = 0.7
  Summon.efficiency["npc_dota_warlock_golem_scepter_2"] = 0.7
  Summon.efficiency["npc_dota_warlock_golem_scepter_3"] = 0.7

  Summon.efficiency["npc_dota_clinkz_skeleton_archer"] = 1
  Summon.efficiency["npc_dota_pugna_ward_winter_2018"] = 1

  Summon.efficiency["npc_dota_lycan_wolf1"] = 1.6
  Summon.efficiency["npc_dota_lycan_wolf2"] = 1.6
  Summon.efficiency["npc_dota_lycan_wolf3"] = 1.6
  Summon.efficiency["npc_dota_lycan_wolf4"] = 1.6

  Summon.efficiency["npc_dota_beastmaster_boar_1"] = 1.8
  Summon.efficiency["npc_dota_beastmaster_boar_2"] = 1.8
  Summon.efficiency["npc_dota_beastmaster_boar_3"] = 1.8
  Summon.efficiency["npc_dota_beastmaster_boar_4"] = 1.8

  Summon.efficiency["npc_dota_visage_familiar1"] = 1.2
  Summon.efficiency["npc_dota_visage_familiar2"] = 1.2
  Summon.efficiency["npc_dota_visage_familiar3"] = 1.2

  Summon.efficiency["npc_dota_venomancer_plague_ward_1"] = 1.1
  Summon.efficiency["npc_dota_venomancer_plague_ward_2"] = 1.1
  Summon.efficiency["npc_dota_venomancer_plague_ward_3"] = 1.1
  Summon.efficiency["npc_dota_venomancer_plague_ward_4"] = 1.1

  
  
  Summon.treant = {}
  Summon.treant["npc_dota_furion_treant_1"] = true
  Summon.treant["npc_dota_furion_treant_2"] = true
  Summon.treant["npc_dota_furion_treant_3"] = true
  Summon.treant["npc_dota_furion_treant_4"] = true
  Summon.treant["npc_dota_furion_treant_large"] = true

end



function Summon:OnNPCSpawned(event)

    local hSpawnedUnit = EntIndexToHScript(event.entindex)
    if  hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit.GetUnitName and  hSpawnedUnit:GetUnitName() and not hSpawnedUnit:IsIllusion() and not hSpawnedUnit:IsTempestDouble()  and not hSpawnedUnit:HasModifier("modifier_arc_warden_tempest_double_lua")  then

        if hSpawnedUnit:IsSummoned() or Summon.efficiency[hSpawnedUnit:GetUnitName()] then
           




           
           local flWaitTime = 0
           
           if "npc_dota_clinkz_skeleton_archer" == hSpawnedUnit:GetUnitName() then
               hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_clinkz_skeletons", {})
               flWaitTime=0.1  
           end

           Timers:CreateTimer(flWaitTime, function()               
               if not hSpawnedUnit or hSpawnedUnit:IsNull() then
                  return 
               end
               local hOwner = hSpawnedUnit:GetOwner()
               if hOwner and hOwner:IsRealHero() then
                  if hOwner:HasModifier("modifier_item_summoner_crown") or hOwner:HasModifier("modifier_item_wraith_dominator") then
                      local flEfficiency = Summon.efficiency[hSpawnedUnit:GetUnitName()] or 1.0
                      
                      
                      if hOwner:HasAbility("special_bonus_unique_furion") and Summon.treant[hSpawnedUnit:GetUnitName()] then
                          local hTalent = hOwner:FindAbilityByName("special_bonus_unique_furion")
                          if hTalent:GetLevel() > 0 then
                              flEfficiency = flEfficiency * 0.6
                          end
                      end

                      local hSourceItem = hOwner:FindItemInInventory("item_wraith_dominator") or hOwner:FindItemInInventory("item_summoner_crown_3") or hOwner:FindItemInInventory("item_summoner_crown_2") or hOwner:FindItemInInventory("item_summoner_crown_1")
                      if hSourceItem and not hSourceItem:IsNull() then

                          local hBuffAgi = hSpawnedUnit:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_buff_agi", {})
                          
                          if (not hBuffAgi) or hBuffAgi:IsNull() then
                              return nil
                          end

                          hBuffAgi:SetStackCount(hOwner:GetAgility() * flEfficiency)                          
                          local hBuffInt = hSpawnedUnit:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_buff_int", {})
                          hBuffInt:SetStackCount(hOwner:GetIntellect() * flEfficiency)
                          
                          hSpawnedUnit:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_model_size", {})
                          
                          
                          Timers:CreateTimer(FrameTime(), function()                             
                              if hSourceItem and not hSourceItem:IsNull() then
                                  if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit:IsAlive() then
                                      local nCurrentHealth = hSpawnedUnit:GetMaxHealth()                     
                                      if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then
                                         nCurrentHealth = 2000 + 75 * hSpawnedUnit:GetLevel()
                                      end
                                      
                                      if nCurrentHealth>1 then
                                        hSpawnedUnit.nOldHealth = nCurrentHealth
                                        local nNewHealth = math.floor(nCurrentHealth * (1 + 0.01 * hOwner:GetStrength() * flEfficiency * hSourceItem:GetSpecialValueFor("hp_bonus_per_str") ))
                                        if nNewHealth>1 then
                                           hSpawnedUnit:SetBaseMaxHealth(nNewHealth)
                                           hSpawnedUnit:SetMaxHealth(nNewHealth)
                                           hSpawnedUnit:SetHealth(nNewHealth)
                                        end
                                      end
                                  end
                              end
                          end)
                          
                          if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then 
                             if hOwner and hOwner:IsRealHero() and hOwner.bUsedBearDarkMoon and  not hSpawnedUnit:HasModifier("modifier_item_dark_moon_shard") then
                                hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_item_dark_moon_shard", {})
                             end
                          end     
                     end               
                  else
                      hSpawnedUnit:RemoveModifierByName("modifier_item_summoner_crown_buff_agi")
                      hSpawnedUnit:RemoveModifierByName("modifier_item_summoner_crown_buff_int")
                      hSpawnedUnit:RemoveModifierByName("modifier_item_summoner_crown_model_size")
                      Timers:CreateTimer(FrameTime(), function()
                        if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then
                           local nCurrentHealth = 2000 + 75 * hSpawnedUnit:GetLevel()
                           hSpawnedUnit:SetBaseMaxHealth(nCurrentHealth)
                           hSpawnedUnit:SetMaxHealth(nCurrentHealth)
                           hSpawnedUnit:SetHealth(nCurrentHealth)
                        end
                      end)
                  end

                  
                  if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then 
                    if hOwner and hOwner:IsRealHero() and hOwner.bUsedBearDarkMoon and  not hSpawnedUnit:HasModifier("modifier_item_dark_moon_shard") then
                        hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_item_dark_moon_shard", {})
                    end
                  end 
               end     
           end)
           
           
           if hSpawnedUnit:GetName() == "npc_dota_lone_druid_bear" then 
               Timers:CreateTimer(2.0, function()
                   if hSpawnedUnit and not hSpawnedUnit:IsNull() and hSpawnedUnit:IsAlive() then
                      Summon:RefreshBear(hSpawnedUnit)
                      return 2.0
                   else
                     return nil
                   end
               end) 
           end

        end
    end

end



function Summon:RefreshBear(hBear)

    local hOwner = hBear:GetOwner()
    if hOwner and hOwner:IsRealHero() then
        if hOwner:HasModifier("modifier_item_summoner_crown") or hOwner:HasModifier("modifier_item_wraith_dominator") then
            local flEfficiency = Summon.efficiency[hBear:GetUnitName()] or 1.0
            local hSourceItem = hOwner:FindItemInInventory("item_wraith_dominator") or hOwner:FindItemInInventory("item_summoner_crown_3") or hOwner:FindItemInInventory("item_summoner_crown_2") or hOwner:FindItemInInventory("item_summoner_crown_1")
            if hSourceItem and not hSourceItem:IsNull() then
                
                local hBuffAgi = hBear:FindModifierByName("modifier_item_summoner_crown_buff_agi")
                if not hBuffAgi or hBuffAgi:IsNull() then
                  hBuffAgi = hBear:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_buff_agi", {}) 
                end
                hBuffAgi:SetStackCount(hOwner:GetAgility() * flEfficiency)   


                local hBuffInt = hBear:FindModifierByName("modifier_item_summoner_crown_buff_int")
                if not hBuffInt or hBuffInt:IsNull() then
                   hBuffInt = hBear:AddNewModifier(hOwner, hSourceItem, "modifier_item_summoner_crown_buff_int", {}) 
                end
                hBuffInt:SetStackCount(hOwner:GetIntellect() * flEfficiency)   
                

                local nCurrentHealth = 2000 + 75 * hBear:GetLevel()
                local nNewHealth = math.floor(nCurrentHealth * (1 + 0.01 * hOwner:GetStrength() * flEfficiency * hSourceItem:GetSpecialValueFor("hp_bonus_per_str") ))
                if nNewHealth>1 then
                   hBear:SetBaseMaxHealth(nNewHealth)
                   hBear:SetMaxHealth(nNewHealth)
                end

            end
        end
    end

end







function Summon:KillSummonedCreatureAsyn(vLocation)
    
    if vLocation then
      local vCleanLocation = Vector(vLocation.x,vLocation.y,vLocation.z)
      Timers:CreateTimer({ endTime = 5,
        callback = function()
           local summonedCreature = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, vCleanLocation, nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
           for _,hUnit in ipairs(summonedCreature) do
             if hUnit and not hUnit:IsNull() and hUnit.GetUnitName and hUnit:GetUnitName() and (hUnit:IsSummoned() or Summon.efficiency[hUnit:GetUnitName()]) and not hUnit:IsIllusion() and not hUnit:IsTempestDouble() and not hUnit:HasModifier("modifier_arc_warden_tempest_double_lua") then
               if hUnit:IsAlive() then

                  
                  if string.find(hUnit:GetUnitName(),"npc_dota_lone_druid_bear") == 1 then
                    local hOwner = hUnit:GetOwner()
                    if hOwner and hOwner:IsRealHero() and hOwner:HasAbility("lone_druid_spirit_bear") then
                        local hAbility = hOwner:FindAbilityByName("lone_druid_spirit_bear")
                        hAbility:EndCooldown()
                    end
                  end

                  
                  if string.find(hUnit:GetUnitName(),"npc_dota_visage_familiar") == 1 then
                    local hOwner = hUnit:GetOwner()
                    if hOwner and hOwner:IsRealHero() and hOwner:HasAbility("visage_summon_familiars") then
                        local hAbility = hOwner:FindAbilityByName("visage_summon_familiars")
                        hAbility:EndCooldown()
                    end
                  end

                  
                  if string.find(hUnit:GetUnitName(),"npc_dota_warlock_golem") == 1 then
                    local hOwner = hUnit:GetOwner()
                    if hOwner and hOwner:IsRealHero() and hOwner:HasAbility("warlock_rain_of_chaos") then
                        local hAbility = hOwner:FindAbilityByName("warlock_rain_of_chaos")
                        hAbility:EndCooldown()
                    end
                  end

                  
                  if string.find(hUnit:GetUnitName(),"npc_dota_shadow_shaman_ward") == 1 then
                    local hOwner = hUnit:GetOwner()
                    if hOwner and hOwner:IsRealHero() and hOwner:HasAbility("shadow_shaman_mass_serpent_ward") then
                        local hAbility = hOwner:FindAbilityByName("shadow_shaman_mass_serpent_ward")
                        hAbility:EndCooldown()
                    end
                  end

                  
                  if string.find(hUnit:GetUnitName(),"npc_dota_brewmaster") == 1 then
                    local hOwner = hUnit:GetOwner()
                    if hOwner and hOwner:IsRealHero() and hOwner:HasAbility("brewmaster_primal_split") then
                        local hAbility = hOwner:FindAbilityByName("brewmaster_primal_split")
                        hAbility:EndCooldown()
                    end
                  end

                  hUnit:ForceKill(false)
               end
             end
           end
       end})
    end
end

