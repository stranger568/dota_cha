if ItemLoot == nil then ItemLoot = class({}) end

function ItemLoot:Init()
    ItemLoot.TeamHasNeutralItems = {}
    for i = 1, 20 do
        ItemLoot.TeamHasNeutralItems[i] = {}
        for d = 1, 50 do
            ItemLoot.TeamHasNeutralItems[i][d] = nil
        end
    end
end

function ItemLoot:DropItem(hUnit, team, hKiller, tier, round)
    local neutral_item_name = "item_tier"..tier.."_token" --ItemLoot:GetUniqueNeutralItem(tier, team)
    ItemLoot.TeamHasNeutralItems[team][round] = neutral_item_name
    local item = DropNeutralItemAtPositionForHero(neutral_item_name, hUnit:GetAbsOrigin(), hKiller, -1, true )
    if item then
        item.nItemTeamNumber = team
    end
    Timers:CreateTimer(15, function()
        if item and (not item:IsNull()) and item.GetContainedItem and item:GetContainedItem() and item:GetContainedItem():IsNeutralDrop() then
            local hContainedItem = item:GetContainedItem()
            PlayerResource:AddNeutralItemToStash( 0, item.nItemTeamNumber, hContainedItem )
            local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/neutralitem_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0, item:GetAbsOrigin() )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
            EmitSoundOn( "NeutralItem.TeleportToStash", item )
            UTIL_Remove( item )
        end
    end)
end

function ItemLoot:GetUniqueNeutralItem(tier, team)
    local item

    repeat 
        item = GetPotentialNeutralItemDrop( tier, team )
    until not ItemLoot:check_used(ItemLoot.TeamHasNeutralItems[team], item) 

    return item
end

function ItemLoot:check_used( t , n ) 
    if #t == 0 then return false end
    for i = 1,#t do
        if t[i] == n then return true end
    end 
    return false
end 
