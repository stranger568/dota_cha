
if not Wearable then
    Wearable = {}
    Wearable.__index = Wearable
    _G.Wearable = Wearable
end

local attach_map = {
    customorigin = PATTACH_CUSTOMORIGIN,
    PATTACH_CUSTOMORIGIN = PATTACH_CUSTOMORIGIN,
    point_follow = PATTACH_POINT_FOLLOW,
    PATTACH_POINT_FOLLOW = PATTACH_POINT_FOLLOW,
    absorigin_follow = PATTACH_ABSORIGIN_FOLLOW,
    PATTACH_ABSORIGIN_FOLLOW = PATTACH_ABSORIGIN_FOLLOW,
    rootbone_follow = PATTACH_ROOTBONE_FOLLOW,
    PATTACH_ROOTBONE_FOLLOW = PATTACH_ROOTBONE_FOLLOW,
    renderorigin_follow = PATTACH_RENDERORIGIN_FOLLOW,
    PATTACH_RENDERORIGIN_FOLLOW = PATTACH_RENDERORIGIN_FOLLOW,
    absorigin = PATTACH_ABSORIGIN,
    PATTACH_ABSORIGIN = PATTACH_ABSORIGIN,
    customorigin_follow = PATTACH_CUSTOMORIGIN_FOLLOW,
    PATTACH_CUSTOMORIGIN_FOLLOW = PATTACH_CUSTOMORIGIN_FOLLOW,
    worldorigin = PATTACH_WORLDORIGIN,
    PATTACH_WORLDORIGIN = PATTACH_WORLDORIGIN
}

local PrismaticParticles = {}

local DefaultPrismatic = {}

local EtherealParticles = {}

local EtherealParticle2Names = {}

function Wearable:Init()
    local npc_heroes = LoadKeyValues("scripts/npc/npc_heroes.txt")
    local items_game = LoadKeyValues("scripts/items/items_game.txt")

    Wearable.asset_modifier = LoadKeyValues("scripts/items/asset_modifier.txt")
    Wearable.control_points = LoadKeyValues("scripts/items/control_points.txt")

    ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(Wearable, "OnHeroLearnAbility"), self)

    Wearable.heroes = {} 
    Wearable.Index2Name = {}
    for heroname, hero in pairs(npc_heroes) do
        if heroname ~= "Version" then
            Wearable.heroes[heroname] = {}
            Wearable.heroes[heroname]["bundles"] = {}
            Wearable.heroes[heroname]["ModelScale"] = hero["ModelScale"]

            Wearable.Index2Name[heroname] = {}

            local heroSlots = Wearable.heroes[heroname]
            if hero.ItemSlots then
                for SlotID, Slot in pairs(hero.ItemSlots) do
                    heroSlots[Slot.SlotName] = {}
                    local heroSlot = heroSlots[Slot.SlotName]
                    heroSlot.SlotIndex = Slot.SlotIndex 

                    Wearable.Index2Name[heroname][Slot.SlotIndex] = Slot.SlotName

                    heroSlot.SlotText = Slot.SlotText
                    heroSlot.ItemDefs = {}
                    if Slot.DisplayInLoadout then
                        heroSlot.DisplayInLoadout = Slot.DisplayInLoadout
                    end
                end
            end
        end
    end

    local items = items_game.items
    local name2itemdef_Map = {}
    Wearable.items = items 
    Wearable.bundles = {} 
    Wearable.couriers = {} 
    Wearable.wards = {} 

    for itemDef, item in pairs(items) do
        local used_by_heroes = item.used_by_heroes
        local item_slot = item.item_slot
        if not item_slot then
            item_slot = "weapon"
        end

        if item.prefab == "wearable" and used_by_heroes then
            
            for heroname, activated in pairs(used_by_heroes) do
                if activated == 1 then
                    local heroSlot = Wearable.heroes[heroname][item_slot]
                    if heroSlot then
                        table.insert(heroSlot.ItemDefs, itemDef)
                        
                        if item.visuals and item.visuals.styles then
                            if not heroSlot.styles then
                                heroSlot.styles = {}
                            end
                            heroSlot.styles[itemDef] = {}
                            local style_table = item.visuals.styles
                            for style, style_table in pairs(item.visuals.styles) do
                                heroSlot.styles[itemDef][style] = {}
                                heroSlot.styles[itemDef][style].name = style_table.name
                                if
                                    style_table.alternate_icon and item.visuals.alternate_icons and
                                        item.visuals.alternate_icons[tostring(style_table.alternate_icon)]
                                 then
                                    heroSlot.styles[itemDef][style].icon_path =
                                        item.visuals.alternate_icons[tostring(style_table.alternate_icon)].icon_path
                                end
                            end
                        elseif item.visuals and item_slot == "shapeshift" then
                            
                            if not heroSlot.styles then
                                heroSlot.styles = {}
                            end
                            if not heroSlot.styles[itemDef] then
                                heroSlot.styles[itemDef] = {}
                                for style = 1, 3 do
                                    heroSlot.styles[itemDef][style - 1] = {}
                                    heroSlot.styles[itemDef][style - 1].name = tostring(style)
                                end
                            end
                        end
                    end
                end
            end

            name2itemdef_Map[item.name] = itemDef
        elseif item.prefab == "taunt" and used_by_heroes then
            
            for heroname, activated in pairs(used_by_heroes) do
                if activated == 1 then
                    item_slot = "taunt"
                    local heroSlot = Wearable.heroes[heroname][item_slot]
                    if heroSlot then
                        table.insert(heroSlot.ItemDefs, itemDef)
                    end
                end
            end
        elseif item.prefab == "default_item" and used_by_heroes then
            
            for heroname, activated in pairs(used_by_heroes) do
                if activated == 1 then
                    if Wearable.heroes[heroname] then
                        local heroSlot = Wearable.heroes[heroname][item_slot]
                        if heroSlot then
                            heroSlot.DefaultItem = itemDef
                            table.insert(heroSlot.ItemDefs, itemDef)
                        end
                        if item_slot == "shapeshift" then
                            
                            if not heroSlot.styles then
                                heroSlot.styles = {}
                            end
                            if not heroSlot.styles[itemDef] then
                                heroSlot.styles[itemDef] = {}
                                for style = 1, 3 do
                                    heroSlot.styles[itemDef][style - 1] = {}
                                    heroSlot.styles[itemDef][style - 1].name = tostring(style)
                                end
                            end
                        end
                    elseif heroname == "all" then
                        for heroname2, hero in pairs(Wearable.heroes) do
                            local heroSlot = hero[item_slot]
                            if heroSlot then
                                heroSlot.DefaultItem = itemDef
                                table.insert(heroSlot.ItemDefs, itemDef)
                            end
                        end
                    end
                end
            end
        end
    end

    
    for itemDef, item in pairs(items) do
        local used_by_heroes = item.used_by_heroes
        if item.prefab == "bundle" and type(used_by_heroes) == "table" then
            for heroname, activated in pairs(used_by_heroes) do
                if activated == 1 then
                    table.insert(Wearable.heroes[heroname]["bundles"], itemDef)
                    Wearable.bundles[itemDef] = {}
                    for subItemName, subItem_activated in pairs(item.bundle) do
                        if subItem_activated == 1 then
                            local subItemDef = name2itemdef_Map[subItemName]
                            table.insert(Wearable.bundles[itemDef], subItemDef)
                        end
                    end
                end
            end
        end
    end

    
    Wearable.prismatics = {}
    for color_key, color_table in pairs(items_game.colors) do
        if string.sub(color_key, 1, 8) == "unusual_" then
            Wearable.prismatics[color_key] = color_table
        end
    end

    
    CustomGameEventManager:RegisterListener("SwitchWearable",function(_, keys)
        Wearable:SwitchWearable(keys)
   end)

    CustomGameEventManager:RegisterListener("Taunt",function(_, keys)
        Wearable:Taunt(keys)
   end)
end

function Wearable:PostInit()
    print("PostInit")
    print(collectgarbage("count"))
    print(collectgarbage("collect"))
    print(collectgarbage("count"))
end

function Wearable:ShowItemdefs()
    local hPlayer = Convars:GetCommandClient()
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, "ShowItemdefs", {})
end


function Wearable:IsPersona(sSlotName)
    return string.sub(sSlotName, -10) == "_persona_1"
end


function Wearable:TakeOffSlot(hUnit, sSlotName)
    
    if hUnit.Slots==nil then
       hUnit.Slots={}
    end
    
    if hUnit.Slots[sSlotName] then
        for p_name, p in pairs(hUnit.Slots[sSlotName]["particles"]) do
            if p ~= false then
                ParticleManager:DestroyParticle(p, true)
                ParticleManager:ReleaseParticleIndex(p)
                hUnit.Slots[sSlotName]["particles"][p_name] = nil
            end
            if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
                hUnit["prismatic_particles"][p_name] = nil
            end
        end

        if hUnit.Slots[sSlotName]["replace_particle_names"] then
            
            for replace_p_name, _ in pairs(hUnit.Slots[sSlotName]["replace_particle_names"]) do
                for sSubSlotName, hSubWear in pairs(hUnit.Slots) do
                    for p_name, sub_p in pairs(hSubWear["particles"]) do
                        if replace_p_name == p_name then
                            Wearable:AddParticle(hUnit, hSubWear, replace_p_name, sSubSlotName)
                            break
                        end
                    end
                end
            end
        end

        if hUnit.Slots[sSlotName]["default_projectile"] then
            hUnit.new_projectile = nil
            hUnit:SetRangedProjectileName(hUnit.Slots[sSlotName]["default_projectile"])
        end

        if hUnit.Slots[sSlotName]["additional_wearable"] then
            for _, prop in pairs(hUnit.Slots[sSlotName]["additional_wearable"]) do
                if prop and IsValidEntity(prop) then
                    prop:RemoveSelf()
                end
            end
        end
        if hUnit.Slots[sSlotName]["model"] then
            local prop = hUnit.Slots[sSlotName]["model"]
            if prop and IsValidEntity(prop) then
                prop:RemoveSelf()
            end
        end
        if hUnit.Slots[sSlotName]["bChangeSkin"] then
            hUnit:SetSkin(0)
        end
        if hUnit.Slots[sSlotName]["bChangeModel"] then
            hUnit:SetOriginalModel(hUnit.old_model)
            hUnit:SetModel(hUnit.old_model)
        end
        if hUnit.Slots[sSlotName]["bChangeSummon"] then
            for sSummonName, b in pairs(hUnit.Slots[sSlotName]["bChangeSummon"]) do
                hUnit.Slots[sSlotName]["bChangeSummon"][sSummonName] = false
                hUnit.summon_model[sSummonName] = nil
            end
        end
        if hUnit.Slots[sSlotName]["activity"] then
            ActivityModifier:RemoveWearableActivity(hUnit, hUnit.Slots[sSlotName].itemDef)
        end

        hUnit.summon_skin = nil

        if hUnit.Slots[sSlotName]["bPersona"] then
            hUnit.bPersona = nil
            hUnit.Slots[sSlotName]["bPersona"] = nil 
            Wearable:SwitchPersona(hUnit, false)
        end

        if hUnit.Slots[sSlotName]["bChangeScale"] then
            local nDefaultScale = Wearable.heroes[hUnit.sHeroName]["ModelScale"]
            hUnit:SetModelScale(nDefaultScale)
        end

        local hWear = hUnit.Slots[sSlotName]
        if hWear.model_modifiers then
            for _, tModifier in ipairs(hWear.model_modifiers) do
                for sSlotName, hSubWear in pairs(hUnit.Slots) do
                    if hSubWear ~= hWear and hSubWear.model and hSubWear.model:GetModelName() == tModifier.modifier then
                        hSubWear.model:SetModel(tModifier.asset)
                    end
                end
            end
        end

        hUnit.Slots[sSlotName] = nil
    end
end

function Wearable:SwitchPersona(hUnit, bPersona)
    print("SwitchPersona", bPersona)
    for sSlotName, hSlot in pairs(hUnit.Slots) do
        Wearable:TakeOffSlot(hUnit, sSlotName)
    end
    if bPersona then
        Wearable:WearDefaultsPersona(hUnit)
    else
        Wearable:WearDefaults(hUnit)
    end
end

function Wearable:WearDefaults(hUnit)
    local hHeroSlots = Wearable.heroes[hUnit.sHeroName]
    hUnit.Slots = {}

    
    
    
    
    

    for sSlotName, hSlot in pairs(hHeroSlots) do
        if type(hSlot) == "table" and hSlot.DefaultItem and (not Wearable:IsPersona(sSlotName)) then
            Wearable:Wear(hUnit, hSlot.DefaultItem)
        end
    end
    local unit_index = hUnit:GetEntityIndex()
    CustomNetTables:SetTableValue("hero_info", "wearables_"..tostring(unit_index), hUnit.Slots)
end

function Wearable:WearDefaultsPersona(hUnit)
    print("WearDefaultsPersona")
    local hHeroSlots = Wearable.heroes[hUnit.sHeroName]
    hUnit.Slots = {}

    
    
    
    
    

    for sSlotName, hSlot in pairs(hHeroSlots) do
        if type(hSlot) == "table" and hSlot.DefaultItem and Wearable:IsPersona(sSlotName) then
            Wearable:Wear(hUnit, hSlot.DefaultItem)
        end
    end
    local unit_index = hUnit:GetEntityIndex()
    CustomNetTables:SetTableValue("hero_info", "wearables_"..tostring(unit_index), hUnit.Slots)
end

function Wearable:GetSlotName(sItemDef)
    if type(sItemDef) ~= "string" then
        sItemDef = tostring(sItemDef)
    end

    local hItem = Wearable.items[sItemDef]
    local sSlotName = hItem.item_slot
    if hItem.prefab == "taunt" then
        sSlotName = "taunt"
    elseif not sSlotName then
        sSlotName = "weapon"
    end
    return sSlotName
end

function Wearable:GetSlotNameBySlotIndex(hUnit, nSlotIndex)
    local sHeroName = ""
    if type(hUnit) == "string" then
        sHeroName = hUnit
    else
        sHeroName = hUnit.sHeroName
    end
    local sSlotName = Wearable.Index2Name[sHeroName][nSlotIndex]
    return sSlotName
end

function Wearable:GetSlotIndex(hUnit, sItemDef)
    if type(sItemDef) ~= "string" then
        sItemDef = tostring(sItemDef)
    end

    local sHeroName = hUnit.sHeroName
    local hItem = Wearable.items[sItemDef]
    local sSlotName = hItem.item_slot

    if hItem.prefab == "taunt" then
        sSlotName = "taunt"
    elseif not sSlotName then
        sSlotName = "weapon"
    end
    return Wearable.heroes[sHeroName][sSlotName].SlotIndex
end

function Wearable:IsDisplayInLoadout(sHeroName, sSlotName)
    
    
    local heroSlots = Wearable.heroes[sHeroName]
    local Slot = heroSlots[sSlotName]
    if (not Slot) or Slot.DisplayInLoadout == 0 then
        return false
    end
    return true
end


function Wearable:RefreshSpectreArcana(hUnit, sStyle)
    if hUnit:GetModelName() == "models/items/spectre/spectre_arcana/spectre_arcana_base.vmdl" then
        
        hUnit:SetBodygroupByName("blade_01", 1)
        hUnit:SetBodygroupByName("blade_02", 1)
        hUnit:SetBodygroupByName("blade_03", 1)
        hUnit:SetBodygroupByName("blade_04", 1)
        hUnit:SetBodygroupByName("blade_05", 1)
    end

    for sSlotName, hWear in pairs(hUnit.Slots) do
        if hWear["model"] then
            if sStyle == "1" then
                hWear["model"]:SetBodygroupByName("arcana", 2)
            else
                hWear["model"]:SetBodygroupByName("arcana", 0)
            end
        end
    end
end

function Wearable:RefreshSpecial(hUnit)
    for sSlotName, hWear in pairs(hUnit.Slots) do
        if hWear.itemDef == "9662" then
            Wearable:RefreshSpectreArcana(hUnit, hWear.style)
            return
        end
    end
end


function Wearable:_WearProp(hUnit, sItemDef, sSlotName, sStyle)
    if (not sItemDef) or sItemDef == "nil" then
        print("sItemDef nil")
        return
    end

    if type(sItemDef) ~= "string" then
        sItemDef = tostring(sItemDef)
    end

    if not sStyle then
        sStyle = "0"
    elseif type(sStyle) ~= "string" then
        sStyle = tostring(sStyle)
    end

    local hItem = Wearable.items[sItemDef]
    local sHeroName = hUnit.sHeroName

    if sHeroName == "npc_dota_hero_tiny" then               
        hUnit.Particles1 = {}
        hUnit.Particles2 = {}
        hUnit.Particles3 = {}
        hUnit.Particles4 = {}
        Wearable:SetTinyDefaultModel(hUnit, sItemDef)
    end
    local nModelIndex = -1

    
    local sModel_player = hItem.model_player
    local hWear = {}
    hWear["itemDef"] = sItemDef
    hWear["particles"] = {}

    
    Wearable:TakeOffSlot(hUnit, sSlotName)

    hWear["style"] = sStyle


    for sSlotName, hOtherWear in pairs(hUnit.Slots) do
        if hOtherWear.model_modifiers then
            for _, tModelModifier in ipairs(hOtherWear.model_modifiers) do
                if sModel_player == tModelModifier.asset then
                    sModel_player = tModelModifier.modifier
                end
            end
        end
    end

    
    if sModel_player then
        local sPropClass = Wearable:GetPropClass(hUnit, sItemDef)
        local sDefaultAnim = Wearable:SpecialFixAnim(hUnit, sItemDef)
        local hModel = nil
        if sDefaultAnim then
            hModel =
                SpawnEntityFromTableSynchronous(
                sPropClass,
                {
                    model = sModel_player,
                    DefaultAnim = sDefaultAnim
                }
            )
        else
            hModel = SpawnEntityFromTableSynchronous(sPropClass, {model = sModel_player})
        end
        hModel:SetOwner(hUnit)
        hModel:SetParent(hUnit, "")
        hModel:FollowEntity(hUnit, true)
        hWear["model"] = hModel
        if hItem.visuals and hItem.visuals.skin then
            hModel:SetSkin(hItem.visuals.skin)
        end
    end

    local asset_modifiers = Wearable.asset_modifier[sItemDef]
    if asset_modifiers then
        for am_name, am_table in pairs(asset_modifiers) do
            if type(am_table) == "table" and am_table.type == "persona" and am_table.persona == 1 then
                Wearable:SwitchPersona(hUnit, true)
                hWear["bPersona"] = true
                hUnit.bPersona = true
            end
        end
        for am_name, am_table in pairs(asset_modifiers) do
            if am_name == "styles" then
                
                local style_table = am_table[sStyle]
                if style_table and style_table.model_player and style_table.model_player ~= sModel_player then
                    hWear["model"]:SetModel(style_table.model_player)
                end
                if style_table and style_table.skin and hWear["model"] then
                    hWear["model"]:SetSkin(style_table.skin)
                end
                if style_table and style_table.skin and not hWear["model"] then
                    
                    hUnit.summon_skin = style_table.skin
                end
            elseif type(am_table) == "table" and am_table.type == "additional_wearable" then
                
                
                if not hWear["additional_wearable"] then
                    hWear["additional_wearable"] = {}
                end
                local sModel = am_table.asset
                local hModel = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
                hModel:SetOwner(hUnit)
                hModel:SetParent(hUnit, "")
                hModel:FollowEntity(hUnit, true)
                table.insert(hWear["additional_wearable"], hModel)
            elseif type(am_table) == "table" and am_table.type == "entity_model" then
                
                print("entity_model", am_table.asset)

                if sHeroName == am_table.asset then
                    local sNewModel = am_table.modifier
                    if not hUnit.old_model then
                        hUnit.old_model = hUnit:GetModelName()
                    end
                    hUnit:SetOriginalModel(sNewModel)
                    hUnit:SetModel(sNewModel)
                    hWear["bChangeModel"] = true
                elseif sHeroName == "npc_dota_hero_tiny" then
                    local sModelIndex = string.sub(am_table.asset, -1, -1)
                    nModelIndex = tonumber(sModelIndex) + 1
                    hUnit["Model" .. nModelIndex] = am_table.modifier                                        
                    hUnit.nModelIndex = 1
                    if hUnit:FindAbilityByName("tiny_grow") then
                       hUnit.nModelIndex = hUnit:FindAbilityByName("tiny_grow"):GetLevel()+1
                    end

                    if nModelIndex == hUnit.nModelIndex then
                        hUnit:SetOriginalModel(am_table.modifier)
                        hUnit:SetModel(am_table.modifier)
                    end
                else
                    
                    hUnit.summon_model = hUnit.summon_model or {}
                    hUnit.summon_model[am_table.asset] = am_table.modifier
                    hWear["bChangeSummon"] = hWear["bChangeSummon"] or {}
                    hWear["bChangeSummon"][am_table.asset] = true

                    
                    local nSkin = asset_modifiers["skin"]
                    if nSkin ~= nil then
                        hUnit.summon_skin = nSkin
                    end
                end
            elseif type(am_table) == "table" and am_table.type == "hero_model_change" then
                
                
                if ((not am_table.style) or tostring(am_table.style) == sStyle) then
                    hUnit.hero_model_change = am_table
                end
            elseif type(am_table) == "table" and am_table.type == "model" then
                
                
                if ((not am_table.style) or tostring(am_table.style) == sStyle) then
                    hWear.model_modifiers = hWear.model_modifiers or {}
                    table.insert(hWear.model_modifiers, am_table)

                    for sSlotName, hSubWear in pairs(hUnit.Slots) do
                        if hSubWear ~= hWear and hSubWear.model and hSubWear.model:GetModelName() == am_table.asset then
                            hSubWear.model:SetModel(am_table.modifier)
                        end
                    end
                end
            end
        end

        
        for _, am_table in pairs(asset_modifiers) do
            if type(am_table) == "table" and am_table.type == "particle_create" then
                
                if ((not am_table.style) or tostring(am_table.style) == sStyle) and (not am_table.spawn_in_loadout_only) then
                    
                    local particle_name = am_table.modifier
                    local bReplaced = false
                    if not Wearable:IsDisplayInLoadout(sHeroName, sSlotName) then
                        
                        for sSubSlotName, hSubWear in pairs(hUnit.Slots) do
                            if hSubWear["replace_particle_names"] and hSubWear["replace_particle_names"][particle_name] then
                                bReplaced = true
                                hWear["particles"][particle_name] = false
                                break
                            end
                        end
                    end
                    if not bReplaced then
                        Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
                    end
                end
            elseif type(am_table) == "table" and am_table.type == "particle_replace" then
                
                if ((not am_table.style) or tostring(am_table.style) == sStyle) and (not am_table.spawn_in_loadout_only) then
                    local default_particle_name = am_table.asset
                    local particle_name = am_table.modifier
                    for sSubSlotName, hSubWear in pairs(hUnit.Slots) do
                        for p_name, sub_p in pairs(hSubWear["particles"]) do
                            if default_particle_name == p_name then
                                if sub_p ~= false then
                                    ParticleManager:DestroyParticle(sub_p, true)
                                    ParticleManager:ReleaseParticleIndex(sub_p)
                                    hSubWear["particles"][p_name] = false
                                end
                                break
                            end
                        end
                    end
                    local p = Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
                    hWear["replace_particle_names"] = hWear["replace_particle_names"] or {}
                    hWear["replace_particle_names"][default_particle_name] = true
                    if sHeroName == "npc_dota_hero_tiny" and nModelIndex > 0 then
                        hUnit["Particles" .. nModelIndex][particle_name] = {
                            pid = p,
                            hWearParticles = hWear["particles"],
                            recreate = function()
                                return Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
                            end
                        }
                    end
                end
            elseif type(am_table) == "table" and am_table.type == "particle_projectile" then
                
                print("particle_projectile", am_table.modifier)
                if ((not am_table.style) or tostring(am_table.style) == sStyle) and (not am_table.spawn_in_loadout_only) then
                    local default_projectile = am_table.asset
                    local new_projectile = am_table.modifier
                    if hUnit:GetRangedProjectileName() == default_projectile then
                        
                        hWear["default_projectile"] = default_projectile
                    else
                        hWear["default_projectile"] = am_table.asset
                    end
                    hUnit:SetRangedProjectileName(new_projectile)
                    hUnit.new_projectile = new_projectile
                    print(hUnit, "new_projectile", hUnit.new_projectile)
                end
            elseif type(am_table) == "table" and am_table.type == "model_skin" then
                
                
                if not am_table.style or tostring(am_table.style) == sStyle then
                    hUnit:SetSkin(am_table.skin)
                    hWear["bChangeSkin"] = true
                end
            elseif type(am_table) == "table" and am_table.type == "activity" then
                
                
                if not am_table.style or tostring(am_table.style) == sStyle then
                    ActivityModifier:AddWearableActivity(hUnit, am_table.modifier, sItemDef)
                    hWear["activity"] = true
                end
            elseif type(am_table) == "table" and am_table.type == "entity_scale" then
                
                
                if (not am_table.style or tostring(am_table.style) == sStyle) and (not am_table.asset) then
                    hUnit:SetModelScale(am_table.scale_size)
                    hWear["bChangeScale"] = true
                end
            end
        end
    end

    
    hUnit.Slots[sSlotName] = hWear
    
    Wearable:SpecialFixParticles(hUnit, sItemDef, hWear, sSlotName, sStyle)
    Wearable:RefreshSpecial(hUnit)
    
    if nModelIndex > 0 then
        Wearable:SwitchTinyParticles(hUnit)
    end

    if DefaultPrismatic and DefaultPrismatic[sItemDef] and not hUnit.prismatic then
        local sPrismaticName = DefaultPrismatic[sItemDef]
        Wearable:SwitchPrismatic(hUnit, sPrismaticName)
    end

    local unit_id = hUnit:GetEntityIndex()
    if Wearable:IsDisplayInLoadout(hUnit.sHeroName, sSlotName) then
        CustomGameEventManager:Send_ServerToAllClients(
            "UpdateWearable",
            {unit = unit_id, itemDef = sItemDef, itemStyle = sStyle, slotName = sSlotName}
        )
    end

    CustomNetTables:SetTableValue("hero_info", "wearables_"..tostring(unit_id), hUnit.Slots)
end

function Wearable:Wear(hUnit, sItemDef, sStyle)
    if type(sItemDef) ~= "string" then
        sItemDef = tostring(sItemDef)
    end

    local hItem = Wearable.items[sItemDef]
    

    local sSlotName = Wearable:GetSlotName(sItemDef)
    
    if hUnit.bPersona and (not Wearable:IsPersona(sSlotName)) and (sSlotName ~= "persona_selector") then
        return
    end

    if hItem.prefab == "bundle" then
        
        for _, sSubItemDef in pairs(Wearable.bundles[sItemDef]) do
            Wearable:Wear(hUnit, sSubItemDef)
        end
        return
    end

    if not sStyle then
        sStyle = "0"
    elseif type(sStyle) ~= "string" then
        sStyle = tostring(sStyle)
    end

    Wearable:_WearProp(hUnit, sItemDef, sSlotName, sStyle)

end

function Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
    
    local particle_list_delete = {
        "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_death_arcana.vpcf",
        "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_death.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_souls.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_double.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_triple.vpcf",
        "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf",
        "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7.vpcf",
        "particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_ring_arcana.vpcf",
        "particles/econ/items/techies/techies_arcana/techies_remote_mine_arcana.vpcf",
        "particles/econ/items/techies/techies_arcana/techies_land_mine_arcana.vpcf ",
        "particles/econ/items/techies/techies_arcana/techies_stasis_trap_arcana.vpcf ",
        "particles/econ/items/techies/techies_arcana/techies_remote_mine_plant_arcana.vpcf ",
        "particles/econ/items/techies/techies_arcana/techies_remote_mines_detonate_arcana.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_null.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_impact_dagger_arcana.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_eyes_l.vpcf",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_impact_dagger_mechanical_arcana.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_debuff_arcana.vpcf",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_mechanical_arcana_swoop.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf ",
        "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_screen_blood_splatter.vpcf",
        "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf",
        "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf",
        "particles/econ/items/zeus/arcana_chariot/zeus_arcana_kill_remnant.vpcf",
        "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath.vpcf",
        "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omnislash_light.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_blade_fury.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_end.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf",
        "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf",
        "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_cast_staff_fire_rubick.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_acorn_shot_tracking.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arc_kunkka_ghost_ship.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_acorn_shot_initial.vpcf",
        "particles/units/heroes/hero_rubick/rubick_macropyre.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_snapfire_impact.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arc_venomancer_poison_nova.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_espirit_magnetize_target.vpcf",
        "particles/units/heroes/hero_rubick/rubick_doom.vpcf",
        "particles/units/heroes/hero_rubick/rubick_chaos_meteor_fly.vpcf",
        "particles/units/heroes/hero_windrunner/windrunner_spell_powershot_rubick.vpcf",
        "particles/units/heroes/hero_rubick/rubick_chaos_meteor.vpcf",
        "particles/units/heroes/hero_rubick/rubick_blackhole.vpcf",
        "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash_rubick.vpcf",
        "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail_rubick.vpcf",
        "particles/units/heroes/hero_rubick/rubick_spell_ravage.vpcf",
        "particles/units/heroes/hero_ember_spirit/ember_spirit_rubick_fire_remnant.vpcf",
        "particles/units/heroes/hero_rubick/rubick_golem_ambient.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_void_spirit_dissimilate_exit.vpcf",
        "particles/units/heroes/hero_rubick/rubick_rain_of_chaos.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_lines.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_void_spirit_dissimilate_dmg.vpcf",
        "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally_rubick.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_ultimate_linger.vpcf",
        "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf",
        "particles/units/heroes/hero_rubick/rubick_finger_of_death.vpcf",
        "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni_rubick.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arc_snapfire_lizard_blobs_arced.vpcf",
        "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_cast_rubick.vpcf",
        "particles/units/heroes/hero_rubick/rubick_thundergods_wrath.vpcf",
        "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff_rubick.vpcf",
        "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_rubick.vpcf",
        "particles/units/heroes/hero_rubick/rubick_thundergods_wrath_start.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast.vpcf",
        "particles/units/heroes/hero_rubick/rubick_freezing_field_snow.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient.vpcf",
        "particles/units/heroes/hero_rubick/rubick_supernova_egg.vpcf",
        "particles/units/heroes/hero_shadowshaman/shadow_shaman_ward_base_attack_rubick.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arcana_void_spirit_dissimilate.vpcf",
        "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull_rubick.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_default.vpcf",
        "particles/econ/items/rubick/rubick_arcana/rbck_arc_sandking_epicenter.vpcf",
        "particles/units/heroes/hero_rubick/rubick_freezing_field_explosion.vpcf",
        "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack_rubick.vpcf",
        "particles/units/heroes/hero_lich/lich_chain_frost_rubick.vpcf",
        "particles/units/heroes/hero_rubick/rubick_rain_of_chaos_start.vpcf",
        "particles/units/heroes/hero_rubick/rubick_spell_ravage_hit.vpcf",
        "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike.vpcf",
        "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike.vpcf",
        "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike_cast.vpcf",
        "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike_cast.vpcf",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_cast.vpcf",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite.vpcf",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast_cast.vpcf ",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_hand_of_midas.vpcf",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast.vpcf ",
        "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_shard_hypothermia_death.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_crossbow_start.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_msg_deny.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_null.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silence_wave.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_lifesteal.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silence_impact_dust.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silence_wave_wide.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_status_effect_frost_arrow.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_buff.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_item_force_staff.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_shard_hypothermia_projectile.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_attack.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_arrow.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow_debuff.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_base.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_powershot_channel.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_windrun.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_tgt_death.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_start.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_hit.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_death.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_item_cyclone.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_monkey_king_bar_tgt.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_loadout.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_javelin_tgt.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_attack.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_shackleshot.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_taunt_kiss_heart.vpcf",
        "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_item_force_staff.vpcf",
        "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_tombstone.vpcf",
        "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_slow_debuff.vpcf",
        "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn.vpcf",
        "particles/econ/items/wraith_king/arcana/high_five_wk_arcana_travel.vpcf",
        "particles/econ/items/wraith_king/arcana/high_five_wk_arcana_overhead.vpcf",
        "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast.vpcf",
        "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff.vpcf",
        "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf",
        "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf ",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_ground.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_buff.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_stunned.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_counter.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_proj.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_target_death.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_heatingup.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_screen.vpcf",
        "particles/status_fx/status_effect_earthshaker_echo.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_damage.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_counter_update.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_debut_loadout.vpcf",
        "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_linear_proj.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_proj.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_melee_hit.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_avalanche_projectile.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_loadout.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_avalanche.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_transform.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_death.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl2_death.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_death.vpcf",
        "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl4_death.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_boost.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint_creep.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_cullingblade_sprint_axe.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_hero_effect.vpcf",
        "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_loadout.vpcf",
        "particles/econ/items/lion/fish_stick_retro/lion_fish_stick_retro.vpcf",
        "particles/econ/items/lion/fish_stick_retro/fish_stick_spell_fish_retro.vpcf",
        "particles/econ/items/lion/fish_stick/lion_fish_stick.vpcf",
        "particles/econ/items/lion/fish_stick/fish_stick_spell_fish.vpcf",
        "particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8.vpcf",
        "particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_overhead_ti8_counter.vpcf",
        "particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_overhead_ti8.vpcf",
        "particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_charge_ti8.vpcf",
        "particles/econ/items/lion/lion_ti8/lion_spell_finger_death_arcana.vpcf",
        "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf",
        "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_marker.vpcf",
        "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf",
        "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf",
        "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf",
        "particles/units/heroes/hero_invoker_kid/invoker_kid_death.vpcf",
        "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
        "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
        "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
        "particles/econ/items/mirana/mirana_persona/mirana_persona_spell_arrow.vpcf",
        "particles/econ/items/mirana/mirana_persona/mirana_starstorm_moonray.vpcf",
        "particles/econ/items/mirana/mirana_persona/mirana_starstorm.vpcf",
        "particles/econ/items/pudge/pudge_arcana/status_effect_pudge_arcana_dismember_null.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_wood.vpcf",
        "particles/econ/items/pudge/pudge_arcana/status_effect_pudge_arcana_dismember_null.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_stone.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_ice.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_fire.vpcf",
        "particles/status_fx/status_effect_pudge_dismember_default.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_motor.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_ethereal.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_red_hook_streak.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_goo.vpcf",
        "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_electric.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_shard_hypothermia_death_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_msg_deny_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silenced_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_v2_multishot_linear_proj_base.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow_debuff_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_v2_crossbow_start.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_shard_v2_hypothermia_projectile.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_v2_arcana_revenge_kill_effect_caster.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_item_force_staff_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silence_wave_v2_wide.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silence_wave_v2.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_v2_marksmanship_frost_arrow.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_v2_arcana_revenge_kill_effect_target.vpcf",
        "particles/econ/items/drow/drow_arcana/drow_arcana_silence_impact_v2_dust.vpcf",
        "particles/econ/items/puck/puck_ti10_immortal/puck_ti10_ult.vpcf",
        "particles/econ/items/puck/puck_ti10_immortal/puck_ti10_tether.vpcf",
        "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf",
        "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_crosshair.vpcf",
        "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_shrapnel.vpcf",
        "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_shrapnel_launch.vpcf",
        "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_head.vpcf",
        "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_jetpack.vpcf",
        "particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_stone.vpcf",
        "particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder.vpcf",
    }

    print(particle_name)

    for _, particlenamedelte in pairs(particle_list_delete) do
        if particle_name == particlenamedelte then
            print("delete particle")
            return
        end
    end
    
    local attach_type = PATTACH_CUSTOMORIGIN
    local attach_entity = hUnit
    if hWear and hWear["model"] then
        attach_entity = hWear["model"]
    end
    local p_table = Wearable.control_points[particle_name]
    if p_table then
        if p_table.attach_type then
            attach_type = attach_map[p_table.attach_type]
        end
        if p_table.attach_entity == "parent" then
            attach_entity = hUnit
        end
    end

    local p = ParticleManager:CreateParticle(particle_name, attach_type, attach_entity)

    if p_table and p_table["control_points"] then
        local cps = p_table["control_points"]
        for _cpi, cp_table in pairs(cps) do
            if (not cp_table.style) or tostring(cp_table.style) == sStyle then
                local control_point_index = cp_table.control_point_index
                attach_type = cp_table.attach_type
                if attach_type == "vector" then
                    
                    local vPosition = String2Vector(cp_table.cp_position)
                    
                    ParticleManager:SetParticleControl(p, control_point_index, vPosition)
                else
                    
                    local inner_attach_entity = attach_entity
                    local attachment = cp_table.attachment
                    if cp_table.attach_entity == "parent" then
                        inner_attach_entity = hUnit
                    elseif cp_table.attach_entity == "self" and hWear and hWear["model"] then
                        inner_attach_entity = hWear["model"]
                    end
                    local position = hUnit:GetAbsOrigin()
                    if cp_table.position then
                        position = String2Vector(cp_table.position)
                    end
                    attach_type = attach_map[attach_type]

                    
                    if cp_table.attach_entity ~= "self" or attachment then
                        
                        if p and control_point_index and inner_attach_entity and attach_type then
                            ParticleManager:SetParticleControlEnt(
                                p,
                                control_point_index,
                                inner_attach_entity,
                                attach_type,
                                attachment,
                                position,
                                true
                            )
                        end
                    end
                end
            end
        end
    end

    if PrismaticParticles[particle_name] then
        hUnit["prismatic_particles"] = hUnit["prismatic_particles"] or {}
        if hUnit["prismatic_particles"][particle_name] then
            hUnit["prismatic_particles"][particle_name].particle_index = p
        else
            hUnit["prismatic_particles"][particle_name] = {
                particle_index = p,
                slot_name = sSlotName,
                style = sStyle
            }
        end

    end

    
    
    if hWear then
        hWear["particles"][particle_name] = p
    end
    return p
end



function Wearable:UICacheAvailableItems(sHeroName)
    if not CustomNetTables:GetTableValue("hero_info", "available_items_"..sHeroName) then
        if Wearable.heroes then
          CustomNetTables:SetTableValue("hero_info", "available_items_"..sHeroName, Wearable.heroes[sHeroName])
        end
    end
end


function Wearable:HideWearables(hUnit)
    
    for sSlotName, hWear in pairs(hUnit.Slots) do
        if hWear["model"] then
            hWear["model"]:AddEffects(EF_NODRAW)
        end
        for p_name, p in pairs(hWear["particles"]) do
            if p ~= false then
                ParticleManager:DestroyParticle(p, true)
                ParticleManager:ReleaseParticleIndex(p)
            end
            if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
                hUnit["prismatic_particles"][p_name].hidden = true
            end
        end
        if hWear["additional_wearable"] then
            for _, prop in pairs(hWear["additional_wearable"]) do
                if prop and IsValidEntity(prop) then
                    prop:AddEffects(EF_NODRAW)
                end
            end
        end
    end
end


function Wearable:ShowWearables(hUnit)
    
    for sSlotName, hWear in pairs(hUnit.Slots) do
        if hWear["model"] then
            hWear["model"]:RemoveEffects(EF_NODRAW)
        end
        for p_name, p in pairs(hWear["particles"]) do
            if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
                hUnit["prismatic_particles"][p_name].hidden = false
            end
            local new_p = Wearable:AddParticle(hUnit, hWear, p_name, sSlotName, hWear["style"])
        end
        if hWear["additional_wearable"] then
            for _, prop in pairs(hWear["additional_wearable"]) do
                if prop and IsValidEntity(prop) then
                    prop:RemoveEffects(EF_NODRAW)
                end
            end
        end
    end
end




function Wearable:OnHeroLearnAbility(keys)
   local hHero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
   if hHero:GetUnitName()=="npc_dota_hero_tiny" then
       if "tiny_grow" ==  keys.abilityname then
           hHero.nModelIndex = 1
           if hHero:FindAbilityByName("tiny_grow") then
               hHero.nModelIndex = hHero:FindAbilityByName("tiny_grow"):GetLevel()+1
           end
           Wearable:SwitchTinyModel(hHero)
       end
   end
end


function Wearable:SwitchTinyModel(hTiny)
    if hTiny["Model" .. hTiny.nModelIndex] then
        local sModel = hTiny["Model" .. hTiny.nModelIndex]
        print("SwitchTinyModel", hTiny.nModelIndex, sModel)
        hTiny:SetOriginalModel(sModel)
        hTiny:SetModel(sModel)
        Wearable:SwitchTinyParticles(hTiny)
    end
end

function Wearable:SwitchTinyParticles(hTiny)
    local nModelIndex = hTiny.nModelIndex
    print("SwitchTinyParticles", nModelIndex)
    
    for i = 1, 4 do
        if hTiny["Particles" .. i] then
            if i == nModelIndex and hTiny["Particles" .. i] then
                for p_name, p_table in pairs(hTiny["Particles" .. i]) do
                    print("remove", i, nModelIndex, p_name)
                    ParticleManager:DestroyParticle(p_table.pid, true)
                    ParticleManager:ReleaseParticleIndex(p_table.pid)
                    if p_table.hWearParticles[p_name] then
                        print("recreate", i, p_table.pid, p_name)
                        p_table.pid = p_table.recreate()
                    end
                end
            else
                for p_name, p_table in pairs(hTiny["Particles" .. i]) do
                    print("remove", i, nModelIndex, p_table.pid)
                    ParticleManager:DestroyParticle(p_table.pid, true)
                    ParticleManager:ReleaseParticleIndex(p_table.pid)
                end
            end
        end
    end
end

function Wearable:SetTinyDefaultModel(hTiny, sItemDef)
    local nModelIndex = -1
    if sItemDef == "679" then
        nModelIndex = 1
    elseif sItemDef == "680" then
        nModelIndex = 2
    elseif sItemDef == "681" then
        nModelIndex = 3
    elseif sItemDef == "682" then
        nModelIndex = 4
    end
    if nModelIndex > 0 then
        local sModel = "models/heroes/tiny/tiny_0" .. nModelIndex .. "/tiny_0" .. nModelIndex .. ".vmdl"
        hTiny["Model" .. nModelIndex] = sModel
        if nModelIndex == hTiny.nModelIndex then
            hTiny:SetOriginalModel(sModel)
            hTiny:SetModel(sModel)
        end
    end
end

function Wearable:SpecialFixAnim(hUnit, sItemDef)
    if sItemDef == "9972" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12412" then
        
        
        
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12414" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13530" or sItemDef == "13527" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12955" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7581" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12927" or sItemDef == "13523" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9462" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12977" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13266" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13483" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13767" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13777" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13778" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13788" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14283" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14277" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12956" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14967" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14954" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14992" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14000" or sItemDef == "13998" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14163" or sItemDef == "14165" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9747" or sItemDef == "12424" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7810" or sItemDef == "7813" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13755" or sItemDef == "14965" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9059" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9235" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7571" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7375" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9241" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7809" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9196" or sItemDef == "9452" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9971" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9970" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7910" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "12792" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9756" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9089" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9704" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14944" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "13933" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14750" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14449" or sItemDef == "14451" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9741" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7427" or sItemDef == "7508" then
        
        return "ACT_DOTA_IDLE"
    elseif hUnit.sHeroName == "npc_dota_hero_huskar" and Wearable:GetSlotName(sItemDef) == "weapon" then
        
        return "ACT_DOTA_IDLE"
    elseif hUnit.sHeroName == "npc_dota_hero_enchantress" and Wearable:GetSlotName(sItemDef) == "weapon" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "8004" or sItemDef == "8038" or sItemDef == "8010" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "7509" or sItemDef == "8376" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9740" or sItemDef == "12299" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "9662" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14242" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "19155" or sItemDef == "19152" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "18979" or sItemDef == "18974" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14900" then
        
        return "ACT_DOTA_IDLE"
    elseif sItemDef == "14960" or sItemDef == "19023" then
        
        return "ACT_DOTA_IDLE"
    end
    return nil
end

function Wearable:GetPropClass(hUnit, sItemDef)
    if sItemDef == "4810" then
        
        return "prop_physics"
    end
    return "prop_dynamic"
end


function Wearable:SpecialFixParticles(hUnit, sItemDef, hWear, sSlotName, sStyle)
    if sItemDef == "12588" then
        local particle_name = "particles/econ/items/lanaya/princess_loulan/princess_loulan_weapon.vpcf"
        Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
    end
end


function Wearable:Taunt(keys) 
    local hHero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
    if hHero then
        if hHero.taunt == nil then
            hHero.taunt = 0
        end

        if hHero.taunt > 0 then
            local player = PlayerResource:GetPlayer(keys.PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "PauseNotification", {message="#cha_taunt_cooldown", time=hHero.taunt})
            end
            return
        end

        hHero:StartGesture(ACT_DOTA_TAUNT)
        if hHero.taunt then
            hHero.taunt = 30
            Timers:CreateTimer(1, function()
                hHero.taunt = hHero.taunt - 1
                if hHero.taunt <= 0 then return end
                return 1
            end)
       end
    end
end


function Wearable:SwitchWearable(keys) 

    local hUnit = EntIndexToHScript(keys.unit)
    local sItemDef = keys.itemDef
    local sItemStyle = keys.itemStyle
    if hUnit.sHeroName==nil then
       hUnit.sHeroName=hUnit:GetUnitName()
    end
    Wearable:Wear(hUnit, sItemDef, sItemStyle)

end

if not Wearable.heroes then
    Wearable:Init()
    Wearable:PostInit()
end
