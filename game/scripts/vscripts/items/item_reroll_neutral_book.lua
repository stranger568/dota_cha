item_reroll_neutral_book = class({})

item_reroll_neutral_book.neutrals_tier_5 = 
{
	["item_force_boots_custom"] = true,
	["item_desolator_2_custom"] = true,
	["item_seer_stone_custom"] = true,
	["item_mirror_shield"] = true,
	["item_apex_custom"] = true,
	["item_ballista"] = true,
	["item_woodland_striders"] = true,
	["item_trident"] = true,
	["item_fallen_sky"] = true,
	["item_pirate_hat"] = true,
	["item_ex_machina_custom"] = true,
	["item_giants_ring_custom"] = true,
	["item_book_of_shadows"] = true,
	["item_fusion_rune_custom"] = true,
	["item_force_field"] = true,
    ["item_demonicon"] = true,
}

function item_reroll_neutral_book:OnSpellStart()
	if not IsServer() then return end
	local item = self
	local neutral_item = self:GetCaster():GetItemInSlot(16)
	if neutral_item then
		if self.neutrals_tier_5[neutral_item:GetAbilityName()] ~= nil then
			local neutral_item_name = HeroBuilder:GetUniqueNeutralItemRandom(self:GetCaster():GetPlayerOwnerID(), 5)
			if neutral_item_name then
				self:GetCaster():EmitSound("Item.TomeOfKnowledge")
				UTIL_Remove(neutral_item)
				local caster = self:GetCaster()
				item:SpendCharge()
                local neutralItem = CreateItem(neutral_item_name[1], caster, caster)
                caster:AddItem(neutralItem)
                neutralItem:SetPurchaseTime(0)
                neutralItem.owner = caster
			end
		else
			local player = PlayerResource:GetPlayer(self:GetCaster():GetPlayerID())
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#error_reroll_neutral_1", time=""})
            end
		end
	else
		local player = PlayerResource:GetPlayer(self:GetCaster():GetPlayerID())
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#error_reroll_neutral_2", time=""})
        end
	end
end