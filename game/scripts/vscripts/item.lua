item_filter_check = class({})

item_filter_check.direct_consumables = 
{
	["item_relearn_book_lua"] = true,
}

function item_filter_check:ItemAddedToInventoryFilter(keys)
	if not keys.item_entindex_const then return true end
	if not keys.inventory_parent_entindex_const then return true end
	local item = EntIndexToHScript( keys.item_entindex_const )
	local inventory_owner = EntIndexToHScript( keys.inventory_parent_entindex_const )
	if not item or not inventory_owner then return true end
	local item_name = item:GetAbilityName()
	local purchaser = item:GetPurchaser()
	local player_owner_id = inventory_owner:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(player_owner_id)
	if IsDirectlyConsumable(item_name) and (not purchaser or purchaser:GetPlayerOwnerID() == player_owner_id)  then
		if inventory_owner:GetClassname() == "npc_dota_lone_druid_bear" then return true end
		if not player_owner_id then return true end
		local has_stack = FindItemOfHero(inventory_owner, item_name) ~= nil
        if inventory_owner:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
            if player and not player:IsNull() then
                CustomGameEventManager:Send_ServerToPlayer(player, "immediate_purchase:key_check", {
                    item = item:entindex(),
                    has_stack = has_stack,
                    item_name = has_stack and item_name or nil,
                })
            end
        end
	end
	return true
end

function IsDirectlyConsumable(item_name)
	return item_filter_check.direct_consumables[item_name]
end

function FindItemOfHero(hero, item_name)
	for i=0, 30 do
		local item = hero:GetItemInSlot(i)
		if item and not item:IsNull() and item:GetAbilityName() == item_name then
			return item
		end
	end
	return nil
end

CustomGameEventManager:RegisterListener("immediate_purchase:response", function(_, data)
	local player_id = data.PlayerID
	if not player_id then return end
	local result = data.result
	local has_stacked_items = data.has_stack == 1 -- event sending has bools as 0/1
	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end
	local hero = player:GetAssignedHero()
	if not hero or hero:IsNull() then return end
	local item
	if not has_stacked_items then
		item = EntIndexToHScript(data.item)
	else
		if not data.item_name then return end
		item = FindItemOfHero(hero, data.item_name)
	end
	if not item or item:IsNull() or (item.GetContainer and item:GetContainer()) then return end
	if result == 1 then
		Timers:CreateTimer(0.07, function()
			if not item or item:IsNull() or item:GetContainer() then return end
			if item:IsCooldownReady() then
				hero:SetCursorCastTarget(hero)
				item:OnSpellStart()
			end
		end)
	end
end)