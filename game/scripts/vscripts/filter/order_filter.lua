
--重要逻辑不能写在这里面 因为会被恶意伪造
function GameMode:OrderFilter(orderTable)
     
    local nPlayerID = orderTable.issuer_player_id_const
    -- 玩家不能捡起或攻击 其他队伍的中立物品
    if (orderTable.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET ) and orderTable.queue == 0 then
        local hTarget = EntIndexToHScript(orderTable.entindex_target)
        --PrintTable(hTarget)
        if nPlayerID and hTarget and hTarget.nItemTeamNumber then
            if hTarget.nItemTeamNumber~= PlayerResource:GetTeam(nPlayerID) then
                return false
            end
        end
    end

    --不能扔出储物篮
    if (orderTable.order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH) and orderTable.queue == 0 then     
        return false
    end

    if (orderTable.order_type == DOTA_UNIT_ORDER_STOP or orderTable.order_type == DOTA_UNIT_ORDER_HOLD_POSITION ) and orderTable.queue == 0 then   
        if orderTable.units and orderTable.units["0"] then
            local hUnit = EntIndexToHScript(orderTable.units["0"])
            CustomGameEventManager:Send_ServerToAllClients("check_smoke_disabled", {unit = hUnit:entindex()})
        end
    end

    --不能扔圣剑
    if (orderTable.order_type == DOTA_UNIT_ORDER_DROP_ITEM) and orderTable.queue == 0 then     
        local hAbility = EntIndexToHScript(orderTable.entindex_ability)
        if hAbility and hAbility:IsItem() then
           if hAbility:GetName() and "item_rapier_custom" == hAbility:GetName() then
              return false
           end
        end
    end

    if orderTable.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then 
      if orderTable.shop_item_name == "item_gem_shard" then 
        local unit = nil
        if orderTable.units and orderTable.units["0"] then
            unit = EntIndexToHScript(orderTable.units["0"])
        end
        if unit ~= nil and unit:HasModifier("modifier_item_gem_shard") then
            local player = PlayerResource:GetPlayer(unit:GetPlayerOwnerID())
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "SendHudError", {message="dota_hud_error_item_already_purchased"})
            end
            return false
        end
      end
    end

    if (orderTable.order_type == DOTA_UNIT_ORDER_CAST_TARGET) and orderTable.queue == 0 then
        if orderTable.entindex_target~=nil then     
            local hAbility = EntIndexToHScript(orderTable.entindex_ability)
            if hAbility and hAbility.IsItem and hAbility:IsItem() then
               if hAbility:GetName() and "item_moon_shard" == hAbility:GetName() then
                  local hUnit
                  if orderTable.units and orderTable.units["0"] then
                     hUnit = EntIndexToHScript(orderTable.units["0"])
                  end
                  if hUnit and hUnit:IsTempestDouble() then
                     local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                     if hPlayer then 
                       CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_ability_inactive"} )   
                     end
                     return false
                  end
               end
            end
            if orderTable.entindex_target then
              local hUnit
                  if orderTable.units and orderTable.units["0"] then
                     hUnit = EntIndexToHScript(orderTable.units["0"])
                  end
                  local target = EntIndexToHScript(orderTable.entindex_target)
                if hUnit and hUnit:GetTeamNumber() ~= target:GetTeamNumber() and target:HasModifier("modifier_hero_refreshing") then
                  local hAbility = EntIndexToHScript(orderTable.entindex_ability)
                  if hAbility and hAbility.GetAbilityName then
                     if "item_nullifier" ~= hAbility:GetAbilityName() and "rubick_spell_steal_custom" ~= hAbility:GetAbilityName() then
                        
                      return false
                    end
                end
              end
            end
        end
    end

     --打断技能拖拽换位
    if orderTable.queue == 0 then
       if nPlayerID then
           local hPlayer = PlayerResource:GetPlayer(nPlayerID)
           if hPlayer then
               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ReorderInterrupt",{state=false} )   
           end
       end
    end

    --不能使用
    if (orderTable.order_type == DOTA_UNIT_ORDER_CAST_TARGET) and orderTable.queue == 0 then     
        local hAbility = EntIndexToHScript(orderTable.entindex_ability)
        if hAbility and hAbility.GetAbilityName then
           if "life_stealer_infest" == hAbility:GetAbilityName() or "doom_bringer_devour" == hAbility:GetAbilityName() or "night_stalker_hunter_in_the_night" == hAbility:GetAbilityName() then
              --PrintTable(orderTable)
              if orderTable.entindex_target then
                 local hTarget =  EntIndexToHScript(orderTable.entindex_target)
                 if hTarget and hTarget.GetUnitName and (hTarget:GetUnitName()=="npc_dota_roshan" or hTarget:GetUnitName()=="npc_dota_pumpkin_king")  then
                    if nPlayerID then
                      local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                      if hPlayer then
                           CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_cant_cast_on_roshan"} )
                      end
                    end
                    return false
                 end
              end
           end

           if "phoenix_supernova" == hAbility:GetAbilityName() then
              if orderTable.entindex_target then
                local hTarget =  EntIndexToHScript(orderTable.entindex_target)
                  if hTarget then
                    local hCaster =  EntIndexToHScript(orderTable.units["0"])
                    if hCaster and (hTarget:IsTempestDouble() or hCaster:IsTempestDouble()) then
                        if nPlayerID then
                          local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                          if hPlayer then
                               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_cant_cast_on_ally"} )
                          end
                        end
                        return false
                    end
                  end
              end
           end

           --风暴双雄肢解不能吞英雄，英雄也不能吞风暴双雄
           if "pudge_dismember" == hAbility:GetAbilityName() then
              if orderTable.entindex_target then
                 local hTarget =  EntIndexToHScript(orderTable.entindex_target)

                 if hTarget then
                    local hCaster =  EntIndexToHScript(orderTable.units["0"])
                    if hCaster and hCaster:GetTeamNumber()==hTarget:GetTeamNumber() and hTarget:IsTempestDouble() then
                        if nPlayerID then
                          local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                          if hPlayer then
                               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_cant_cast_on_ally"} )
                          end
                        end
                        return false
                    end
                 end          
              end
           end
        end


    end
    return true
end