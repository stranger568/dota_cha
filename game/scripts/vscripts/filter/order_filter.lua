function GameMode:OrderFilter(orderTable)

    local nPlayerID = orderTable.issuer_player_id_const
    if (orderTable.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET ) and orderTable.queue == 0 then
        local hTarget = EntIndexToHScript(orderTable.entindex_target)
        if nPlayerID and hTarget and hTarget.nItemTeamNumber then
            if hTarget.nItemTeamNumber~= PlayerResource:GetTeam(nPlayerID) then
                return false
            end
        end
    end

    if (orderTable.order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH) and orderTable.queue == 0 then     
        return false
    end

    if (orderTable.order_type == DOTA_UNIT_ORDER_STOP or orderTable.order_type == DOTA_UNIT_ORDER_HOLD_POSITION ) and orderTable.queue == 0 then   
        if orderTable.units and orderTable.units["0"] then
            local hUnit = EntIndexToHScript(orderTable.units["0"])
            if hUnit:IsHero() then
                CustomGameEventManager:Send_ServerToAllClients("check_smoke_disabled", {unit = hUnit:entindex()})
            end
        end
    end

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

    if true then
        if nPlayerID and nPlayerID ~= -1 then
            local target = EntIndexToHScript(orderTable.entindex_target)
            local player = PlayerResource:GetPlayer(orderTable["issuer_player_id_const"])
            local unit
            if orderTable.units and orderTable.units["0"] then
                unit = EntIndexToHScript(orderTable.units["0"])
            end
            if not player then return false end
            local hero = player:GetAssignedHero()
            if not hero then return end
            if hero and hero:HasModifier("modifier_portal_base_custom_cast") and orderTable.order_type ~= DOTA_UNIT_ORDER_HOLD_POSITION and orderTable.order_type ~= DOTA_UNIT_ORDER_PURCHASE_ITEM and orderTable.order_type ~= DOTA_UNIT_ORDER_MOVE_ITEM and orderTable.order_type ~= DOTA_UNIT_ORDER_SELL_ITEM then 
                return false 
            end

            if orderTable.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
                local item = EntIndexToHScript(orderTable["entindex_target"])
                if item then
                    local pickedItem = item:GetContainedItem()
                    if not pickedItem then return true end
                    if hero and (hero:IsTempestDouble() or hero:HasModifier("modifier_tempest_double_illusion")) then
                        if pickedItem:IsNeutralDrop() then
                            return false 
                        end
                    end
                end
            end

            if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
                if target and not target:IsNull() and target:IsBaseNPC() and (target:GetUnitName() == "npc_dota_teleport_base_custom_red" or target:GetUnitName() == "npc_dota_teleport_base_custom_blue") and unit:IsRealHero() then
                    if 550 >= ( hero:GetOrigin() - target:GetOrigin() ):Length2D() then 
                        if not hero:HasModifier("modifier_portal_base_custom_cd") then
                            hero:Interrupt() 
                            hero:Stop()
                            hero:AddAbility("portal_base_custom")
                            local ability = hero:FindAbilityByName("portal_base_custom")
                            ability:SetLevel(1)
                            ability.portal = target:GetUnitName()
                            hero:CastAbilityNoTarget(ability, hero:GetPlayerOwnerID())
                        else 
                            CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = ""})
                        end
                    else 
                        local position = target:GetAbsOrigin()
                        orderTable["position_x"] = position.x
                        orderTable["position_y"] = position.y
                        orderTable["position_z"] = position.z
                        orderTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
                        return true
                    end
                    return false
                end
            end

            if orderTable.order_type == DOTA_UNIT_ORDER_CAST_TARGET  then
                if target:GetUnitName() == "npc_dota_teleport_base_custom_red" or target:GetUnitName() == "npc_dota_teleport_base_custom_blue" or target:GetUnitName() == "npc_dota_stranger" then 
                    return false
                end
            end
        end
    end

    if orderTable.queue == 0 then
        if nPlayerID then
            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
            if hPlayer then
                CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ReorderInterrupt",{state=false} )   
            end
        end
    end

    if (orderTable.order_type == DOTA_UNIT_ORDER_CAST_TARGET) and orderTable.queue == 0 then     
        local hAbility = EntIndexToHScript(orderTable.entindex_ability)
        if hAbility and hAbility.GetAbilityName then
            if "life_stealer_infest" == hAbility:GetAbilityName() or "doom_bringer_devour_custom" == hAbility:GetAbilityName() or "night_stalker_hunter_in_the_night_custom" == hAbility:GetAbilityName() then
                if orderTable.entindex_target then
                    local hTarget =  EntIndexToHScript(orderTable.entindex_target)
                    if hTarget and hTarget.GetUnitName and (hTarget:GetUnitName()=="npc_dota_roshan" or hTarget:GetUnitName()=="npc_dota_nian")  then
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