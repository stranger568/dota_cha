function GameMode:OrderFilter(orderTable)
    local nPlayerID = orderTable.issuer_player_id_const
    local unit
	if orderTable.units and orderTable.units["0"] then
		unit = EntIndexToHScript(orderTable.units["0"])
	end
	local target = orderTable.entindex_target ~= 0 and EntIndexToHScript(orderTable.entindex_target) or nil
	local orderType = orderTable["order_type"]

    if unit and unit:IsHero() and nPlayerID and nPlayerID ~= -1 then
        if (orderType == DOTA_UNIT_ORDER_PICKUP_ITEM or orderType == DOTA_UNIT_ORDER_ATTACK_TARGET ) and orderTable.queue == 0 then
            if nPlayerID and target and target.nItemTeamNumber then
                if target.nItemTeamNumber ~= PlayerResource:GetTeam(nPlayerID) then
                    return false
                end
            end
        end
        if (orderType == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH) and orderTable.queue == 0 then     
            return false
        end
        if (orderType == DOTA_UNIT_ORDER_STOP or orderType == DOTA_UNIT_ORDER_HOLD_POSITION ) and orderTable.queue == 0 then   
            CustomGameEventManager:Send_ServerToAllClients("check_smoke_disabled", {unit = unit:entindex()})
        end
        if orderType == DOTA_UNIT_ORDER_PICKUP_ITEM then
            local item = EntIndexToHScript(orderTable["entindex_target"])
            if item then
                local pickedItem = item:GetContainedItem()
                if not pickedItem then return true end
                if pickedItem:IsNeutralDrop() then
                    if (pickedItem.owner ~= nil and pickedItem.owner ~= unit) then
                        local player = PlayerResource:GetPlayer(unit:GetPlayerOwnerID())
                        if player then
                            CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#wrong_item", time=""})
                        end
                        return false
                    end
                else
                    if (pickedItem:GetPurchaser() ~= nil and pickedItem:GetPurchaser() ~= unit) then
                        local player = PlayerResource:GetPlayer(unit:GetPlayerOwnerID())
                        if player then
                            CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#wrong_item", time=""})
                        end
                        return false
                    end
                end
            end
        end
        if (orderType == DOTA_UNIT_ORDER_DROP_ITEM) and orderTable.queue == 0 then     
            local hAbility = EntIndexToHScript(orderTable.entindex_ability)
            if hAbility and hAbility:IsItem() then
                if hAbility:GetName() and "item_rapier_custom" == hAbility:GetName() then
                    return false
                end
            end
        end
        if orderType == DOTA_UNIT_ORDER_PURCHASE_ITEM then 
            if orderTable.shop_item_name == "item_gem_shard" then 
                if unit:HasModifier("modifier_item_gem_shard") then
                    local player = PlayerResource:GetPlayer(unit:GetPlayerOwnerID())
                    if player then
                        CustomGameEventManager:Send_ServerToPlayer(player, "SendHudError", {message="dota_hud_error_item_already_purchased"})
                    end
                    return false
                end
            end
        end
        if (orderType == DOTA_UNIT_ORDER_CAST_TARGET) and orderTable.queue == 0 then
            if target then     
                local hAbility = EntIndexToHScript(orderTable.entindex_ability)
                if hAbility and hAbility.IsItem and hAbility:IsItem() then
                    if hAbility:GetName() and "item_moon_shard" == hAbility:GetName() then
                        if unit:IsTempestDouble() then
                            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                            if hPlayer then 
                                CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_ability_inactive"} )   
                            end
                            return false
                        end
                    end
                end
                if target then
                    if unit:GetTeamNumber() ~= target:GetTeamNumber() and target:HasModifier("modifier_hero_refreshing") then
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

        if orderTable.queue == 0 then
            if nPlayerID then
                local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                if hPlayer then
                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ReorderInterrupt",{state=false} )   
                end
            end
        end

        if (orderType == DOTA_UNIT_ORDER_CAST_TARGET) and orderTable.queue == 0 then     
            local hAbility = EntIndexToHScript(orderTable.entindex_ability)
            if hAbility and hAbility.GetAbilityName then
                local ability_name = hAbility:GetAbilityName()
                if "life_stealer_infest" == ability_name or "doom_bringer_devour_custom" == ability_name or "night_stalker_hunter_in_the_night_custom" == ability_name then
                    if target then
                        if target and target.GetUnitName and (target:GetUnitName()=="npc_dota_roshan" or target:GetUnitName()=="npc_dota_nian")  then
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
                if "phoenix_supernova" == ability_name then
                    if target then
                        if unit and (target:IsTempestDouble() or unit:IsTempestDouble()) then
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
                if "pudge_dismember" == ability_name then
                    if target then
                        if unit and unit:GetTeamNumber()==target:GetTeamNumber() and target:IsTempestDouble() then
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

        

        if unit and unit:HasModifier("modifier_portal_base_custom_cast") and orderType ~= DOTA_UNIT_ORDER_HOLD_POSITION and orderType ~= DOTA_UNIT_ORDER_PURCHASE_ITEM and orderType ~= DOTA_UNIT_ORDER_MOVE_ITEM and orderType ~= DOTA_UNIT_ORDER_SELL_ITEM then 
            return false 
        end

        if orderType == DOTA_UNIT_ORDER_PICKUP_ITEM then
            local item = target
            if item then
                local pickedItem = item:GetContainedItem()
                if not pickedItem then return true end
                if unit and (unit:IsTempestDouble() or unit:HasModifier("modifier_tempest_double_illusion")) then
                    if pickedItem:IsNeutralDrop() then
                        return false 
                    end
                end
            end
        end

        if orderType == DOTA_UNIT_ORDER_ATTACK_TARGET or orderType == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
            if target and not target:IsNull() and target:IsBaseNPC() and (target:GetUnitName() == "npc_dota_teleport_base_custom_red" or target:GetUnitName() == "npc_dota_teleport_base_custom_blue") and unit:IsRealHero() then
                if 550 >= ( unit:GetOrigin() - target:GetOrigin() ):Length2D() then 
                    if not unit:HasModifier("modifier_portal_base_custom_cd") then
                        unit:Interrupt() 
                        unit:Stop()
                        unit:AddAbility("portal_base_custom")
                        local ability = unit:FindAbilityByName("portal_base_custom")
                        ability:SetLevel(1)
                        ability.portal = target:GetUnitName()
                        unit:CastAbilityNoTarget(ability, unit:GetPlayerOwnerID())
                    else 
                        local player = PlayerResource:GetPlayer(nPlayerID)
                        if player then
                            CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = ""})
                        end
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

        if orderType == DOTA_UNIT_ORDER_CAST_TARGET  then
            if target:GetUnitName() == "npc_dota_teleport_base_custom_red" or target:GetUnitName() == "npc_dota_teleport_base_custom_blue" or target:GetUnitName() == "npc_dota_stranger" then 
                return false
            end
        end
    end

    return true
end