LinkLuaModifier( "modifier_hero_refreshing", "heroes/modifier_hero_refreshing", LUA_MODIFIER_MOTION_NONE )

if Util == nil then Util = class({}) end

function Util:MoveHeroToCenter( nPlayerID )
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local nTeamNumber =  hHero:GetTeamNumber()
    local vTargetLocation = GameMode.vTeamStartLocationMap[nTeamNumber]
    local hObservingTarget = Util:ChooseObservingTarget(nPlayerID)
    Util:MoveHeroToLocation(nPlayerID,vTargetLocation,hObservingTarget)
end

function Util:ChooseObservingTarget(nPlayerID)
    if GetMapName()=="5v5" and GameMode.autoDuelMap[nPlayerID] and (not PvpModule.bEnd) then
        for _,nPvpPlayerID in ipairs(PvpModule.currentSinglePair) do
            if PlayerResource:GetTeam(nPvpPlayerID) == PlayerResource:GetTeam(nPlayerID) then
                local hTempTargetHero =  PlayerResource:GetSelectedHeroEntity(nPvpPlayerID)
                if hTempTargetHero and (hTempTargetHero:IsAlive() or hTempTargetHero:IsReincarnating()) then
                    return hTempTargetHero
                end
            end
        end
    end
    if PvpModule.nHomeTeamID and GameMode.autoDuelMap[nPlayerID] and (not PvpModule.bEnd)  then          
        for i=1,PlayerResource:GetPlayerCountForTeam(PvpModule.nHomeTeamID) do
            local nTempPlayerID = PlayerResource:GetNthPlayerIDOnTeam(PvpModule.nHomeTeamID, i)
            local hTempTargetHero =  PlayerResource:GetSelectedHeroEntity(nTempPlayerID)
            if hTempTargetHero and (hTempTargetHero:IsAlive() or hTempTargetHero:IsReincarnating()) then
                return hTempTargetHero
            end
        end
    end
    if GameMode.autoCreepMap[nPlayerID] and GameMode.currentRound and (not GameMode.currentRound.bEnd)  then
        local nKillProgress = 100
        local nTargetTeamNumber
        for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
            if bAlive  and GameMode.currentRound.spanwers[nTeamNumber] and false == GameMode.currentRound.spanwers[nTeamNumber].bProgressFinished then          
                if nKillProgress > GameMode.currentRound.spanwers[nTeamNumber].nKillProgress then
                    nTargetTeamNumber = nTeamNumber
                end 
            end
        end
        if nTargetTeamNumber then
            for i=1,PlayerResource:GetPlayerCountForTeam(nTargetTeamNumber) do
                local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTargetTeamNumber, i)
                local hTempTargetHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
                if hTempTargetHero and (hTempTargetHero:IsAlive() or hTempTargetHero:IsReincarnating()) then
                    return hTempTargetHero
                end
            end
        end
    end
    return PlayerResource:GetSelectedHeroEntity(nPlayerID)
end

function Util:MoveHeroToLocation( nPlayerID,vLocation,hObservingTarget)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hHero then 
        Util:RemoveMovemenModifier(hHero)
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hHero)
        if Util.supposedLocations == nil then
            Util.supposedLocations = {}
        end
        Util.supposedLocations[nPlayerID] = vLocation
        FindClearSpaceForUnit(hHero, vLocation, true)
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
        hHero:EmitSound("DOTA_Item.BlinkDagger.Activate") 
        if hObservingTarget==nil then
            hObservingTarget = hHero
        end
        if PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED then 
            PlayerResource:SetCameraTarget(nPlayerID, hHero)
            Timers:CreateTimer({ endTime = 0.3, callback = function()
                PlayerResource:SetCameraTarget(nPlayerID,nil) 
            end})
        end
    end
end

function Util:RefreshAbilityAndItem( hHero,exceptions)
    if exceptions==nil then
        exceptions={}
    end

    for i = 0, hHero:GetAbilityCount() - 1 do
        local hAbility = hHero:GetAbilityByIndex(i)
        if hAbility and hAbility:GetAbilityType() ~= DOTA_ABILITY_TYPE_ATTRIBUTES then
            if exceptions[hAbility:GetAbilityName()]==nil then
                hAbility:RefreshCharges()
                hAbility:EndCooldown()
            end
        end
    end

    for i = 0, 20 do
        local hItem = hHero:GetItemInSlot(i)
        if hItem then
            hItem:EndCooldown()
        end
    end

    local hItem = hHero:GetItemInSlot(16)

    if hItem then
        hItem:EndCooldown()
    end

    if hHero.tempest_double_hClone ~= nil and not hHero.tempest_double_hClone:IsNull() and hHero.tempest_double_hClone:IsAlive() then
        for i = 0, hHero.tempest_double_hClone:GetAbilityCount() - 1 do
            local hAbility = hHero.tempest_double_hClone:GetAbilityByIndex(i)
            if hAbility and hAbility:GetAbilityType() ~= DOTA_ABILITY_TYPE_ATTRIBUTES then
                if exceptions[hAbility:GetAbilityName()]==nil then
                    hAbility:RefreshCharges()
                    hAbility:EndCooldown()
                end
            end
        end
        for i = 0, 20 do
            local hItem = hHero.tempest_double_hClone:GetItemInSlot(i)
            if hItem then
                hItem:EndCooldown()
            end
        end
        local hItem = hHero.tempest_double_hClone:GetItemInSlot(16)
        if hItem then
            hItem:EndCooldown()
        end
    end
end

function Util:CleanPvpPair(nTeamNumber)
    local i,max=1,#PvpModule.pvpPairs
    while i<=max do
        local pair = PvpModule.pvpPairs[i]
        if  nTeamNumber==pair.nFirstTeamId or nTeamNumber==pair.nSecondeTeamId  then
            table.remove(PvpModule.pvpPairs,i)
            i = i-1
            max = max-1
        end
        i= i+1
    end
    return PvpModule.pvpPairs
end

function Util:RemoveMovemenModifier(hHero)
    hHero:Stop()
    hHero:RemoveModifierByName("modifier_magnataur_skewer_movement")
    hHero:RemoveModifierByName("modifier_phoenix_icarus_dive")
    hHero:RemoveModifierByName("modifier_mirana_leap")
    hHero:RemoveModifierByName("modifier_kunkka_x_marks_the_spot")
    hHero:RemoveModifierByName("modifier_kunkka_x_marks_the_spot_thinker")
    hHero:RemoveModifierByName("modifier_riki_tricks_of_the_trade_phase")
    hHero:RemoveModifierByName("modifier_monkey_king_bounce_perch")
    hHero:RemoveModifierByName("modifier_void_spirit_dissimilate_phase")
    hHero:RemoveModifierByName("modifier_monkey_king_bounce_leap")
    hHero:RemoveModifierByName("modifier_monkey_king_tree_dance_activity")
    hHero:RemoveModifierByName("modifier_sandking_burrowstrike")
    hHero:RemoveModifierByName("modifier_phantomlancer_dopplewalk_phase")
    hHero:RemoveModifierByName("modifier_life_stealer_infest")
    hHero:RemoveModifierByName("modifier_phoenix_sun_ray")
    hHero:RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_in_progress")
    hHero:RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_caster")
    hHero:RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_caster_invulnerability")
    if hHero:HasModifier("modifier_oracle_false_promise_custom") then
        Timers:CreateTimer(1, function()
            hHero:RemoveModifierByName("modifier_oracle_false_promise_custom")
        end)
    end
    hHero:RemoveModifierByName("modifier_brewmaster_primal_split")
    hHero:RemoveModifierByName("modifier_invoker_tornado_lua")
    if hHero:HasAbility("puck_ethereal_jaunt") then
       hHero:FindAbilityByName("puck_ethereal_jaunt"):SetActivated(false)
       Timers:CreateTimer({ endTime = 3, callback = function()
            if hHero:HasAbility("puck_ethereal_jaunt") then
                hHero:FindAbilityByName("puck_ethereal_jaunt"):SetActivated(true)
            end
        end})
    end
    if hHero:HasModifier("modifier_ember_spirit_fire_remnant_remnant_tracker") then
        hHero:RemoveModifierByName("modifier_ember_spirit_fire_remnant_timer")
        hHero:RemoveModifierByName("modifier_ember_spirit_fire_remnant_remnant_tracker")
        hHero:AddNewModifier(hHero, hHero:FindAbilityByName("ember_spirit_fire_remnant"), "modifier_ember_spirit_fire_remnant_remnant_tracker", {})
    end
    if hHero:HasModifier("modifier_weaver_timelapse") then
        hHero:RemoveModifierByName("modifier_weaver_timelapse")
        hHero:AddNewModifier(hHero, hHero:FindAbilityByName("weaver_time_lapse"), "modifier_weaver_timelapse", {})
    end
end

function Util:RemoveAbilityClean(hHero,sAbilityName)
    if sAbilityName=="slark_shadow_dance" then
        Util:CleanSlark(hHero)
    end
    if sAbilityName=="slark_depth_shroud" then
        Util:CleanSlark(hHero)
    end
    if sAbilityName=="broodmother_spin_web" then
        Util:CleanWeb(hHero)
    end
    if sAbilityName=="witch_doctor_death_ward" then
        Util:CleanDeathWard(hHero)
    end
    if sAbilityName=="visage_summon_familiars" then
        Util:CleanFamiliar(hHero)
    end
    if sAbilityName=="furion_sprout" then
        Util:CleanFurion(hHero)
    end
    if sAbilityName=="pudge_meat_hook" or sAbilityName=="marci_grapple" or sAbilityName=="rattletrap_hookshot" or sAbilityName=="bane_nightmare" then
        Util:CleanBugAbilities(hHero)
    end
end

function Util:CleanBugAbilities(hHero)
    local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

    local modifiers_table = 
    {
        "modifier_marci_grapple_victim_motion",
        "modifier_followthrough",
        "modifier_pudge_meat_hook",
        "modifier_pudge_meat_hook_pathingfix",
        "modifier_rattletrap_hookshot",
        "modifier_bane_nightmare",
        "modifier_bane_nightmare_invulnerable",
    }

    for _,thinker in pairs(thinkers) do 
        for id, mod_name in pairs(modifiers_table) do
            if thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier(mod_name) then 
                print("удаляется thinker", mod_name)
                UTIL_Remove(thinker)
            end
        end
    end

    local allHeroes = HeroList:GetAllHeroes()

    for _, hero in pairs(allHeroes) do
        if hero and not hero:IsNull() then
            for id, mod_name in pairs(modifiers_table) do
                local modifier_find = hero:FindModifierByName(mod_name)
                if modifier_find then
                    modifier_find:Destroy()
                end
            end
        end
    end

    local units = Entities:FindAllInSphere(hHero:GetAbsOrigin(), 5000)

    for _, unit in pairs(units) do
        if unit and not unit:IsNull() then
            for id, mod_name in pairs(modifiers_table) do
                if unit.FindModifierByName then
                    local modifier_find = unit:FindModifierByName(mod_name)
                    if modifier_find then
                        modifier_find:Destroy()
                        if not unit:IsHero() then
                            unit:Destroy()
                        end
                    end
                end
            end
        end
    end
end

function Util:CleanFurion(hHero)
    local thinkers = Entities:FindAllByClassname("npc_dota_thinker")
    for _,thinker in pairs(thinkers) do 
        if thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_blind") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        elseif thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_blind_aura") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        elseif thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_entangle") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        elseif thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_marker") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        elseif thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_shard") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        elseif thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_tether") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        elseif thinker and not thinker:IsNull() and thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:HasModifier("modifier_furion_sprout_tether_aura") then 
            GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 320, true)
            UTIL_Remove(thinker)
        end
    end
end

function Util:CleanSlark(hHero)
    local thinkers = Entities:FindAllByClassname("npc_dota_thinker")
    for _,thinker in pairs(thinkers) do 
        if thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:GetOwner() == hHero and thinker:HasModifier("modifier_slark_depth_shroud") then 
            UTIL_Remove(thinker)
        elseif thinker:GetTeamNumber() == hHero:GetTeamNumber() and thinker:GetOwner() == hHero and thinker:HasModifier("modifier_slark_depth_shroud_thinker") then 
            UTIL_Remove(thinker)
        end
    end
end

function Util:CleanWeb(hHero)
    local vWebs = Entities:FindAllByName("npc_dota_broodmother_web")
    for _, hWeb in pairs(vWebs) do
        if hWeb:GetOwner() == hHero then
            UTIL_Remove(hWeb)
        end
    end
end

function Util:CleanDeathWard(hHero)
    local vWards = Entities:FindAllByName("npc_dota_witch_doctor_death_ward")
    for _, vWard in pairs(vWards) do
        if vWard:GetOwner() == hHero then
            UTIL_Remove(vWard)
        end
    end
end

function Util:CleanFamiliar(hHero)
    local vFamiliars = Entities:FindAllByName("npc_dota_visage_familiar")
    for _, hFamiliar in pairs(vFamiliars) do
        if hFamiliar:GetOwner() == hHero then
            hFamiliar:ForceKill(false)
        end
    end
end

function Util:IsReincarnationWork(hHero)
    local bSkeletonKingReincarnationWork = false
    if hHero:HasAbility("skeleton_king_reincarnation") then
        local hAbility = hHero:FindAbilityByName("skeleton_king_reincarnation")
        if hAbility:GetLevel() > 0 then
            if hAbility:GetCooldownTimeRemaining() == hAbility:GetEffectiveCooldown(hAbility:GetLevel()-1) then
                bSkeletonKingReincarnationWork = true 
            end
        end
    end
    local bUndyingReincarnationWork = false
    if hHero:HasModifier("modifier_special_bonus_reincarnation") then
        local hModifier = hHero:FindModifierByName("modifier_special_bonus_reincarnation")
        if hModifier:GetElapsedTime()<FrameTime() then
            bUndyingReincarnationWork=true
        end
    end
    local bmodifier_skill_second_life = false
    --if hHero:HasModifier("modifier_skill_second_life") and not hHero:HasModifier("modifier_skill_second_life_cooldown") then
    --    bmodifier_skill_second_life = true
    --end
    return bSkeletonKingReincarnationWork or bUndyingReincarnationWork or bmodifier_skill_second_life
end

function Util:GenerateHeroInfo(nPlayerID)
    local heroInfo ={}
    local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
    if hHero then
        local sAbilities = ""
        if hHero.abilitiesList then
            for _,sAbilityName in ipairs(hHero.abilitiesList) do
                sAbilities = sAbilities .. sAbilityName ..","
            end
        end
        if string.sub(sAbilities,string.len(sAbilities))=="," then   
            sAbilities=string.sub(sAbilities,0,string.len(sAbilities)-1)
        end
        local sItems = ""
        if hHero.sConsumedItems then
            sItems = hHero.sConsumedItems
        end
        for i=0,20 do 
            local hItem = hHero:GetItemInSlot(i)
            if hItem then
                sItems = sItems..hItem:GetName()..","
            end
        end
        if string.sub(sItems,string.len(sItems))=="," then   
            sItems=string.sub(sItems,0,string.len(sItems)-1)
        end
        heroInfo.hero_name=hHero:GetUnitName()
        heroInfo.abilities=sAbilities
        heroInfo.items=sItems
   end
   return heroInfo
end

function CDOTA_BaseNPC:AddEndChannelListener(listener)
    local endChannelListeners = self.EndChannelListeners or {}
    self.EndChannelListeners = endChannelListeners
    local index = #endChannelListeners + 1
    endChannelListeners[index] = listener
end

function Util:CleanFurArmySoldier()
    Timers:CreateTimer({ endTime = 0.5, callback = function()
        local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0,0,0), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
        for _,hUnit in ipairs(units) do
            if hUnit and not hUnit:IsNull() and (hUnit:HasModifier("modifier_monkey_king_fur_army_soldier") or hUnit:HasModifier("modifier_monkey_king_fur_army_soldier_hidden")) then
                hUnit:ForceKill(false)
                UTIL_Remove(hUnit)
            end
        end
    end})
end

function Util:RecordConsumableItem(nPlayerID,sItemName)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hHero then
        if hHero.sConsumedItems==nil then
            hHero.sConsumedItems=""
        end
        hHero.sConsumedItems = hHero.sConsumedItems..sItemName..","
    end
end

function Util:GetBotEarnedGold(nPlayerID)
    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    if hHero then
        if GameRules.nGameStartTime then
            local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
            nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
            return nGold
        end             
    end
    return 600
end

function Util:InitHeroFence()
   Util.flFenceRadius = 3000
   Util.supposedLocations = {}
   Timers:CreateTimer({ endTime = 0.1, callback = function()
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidTeamPlayerID(nPlayerID) then
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                if hHero then
                    if Util.supposedLocations[nPlayerID] then
                        local flDistance = (hHero:GetOrigin() - Util.supposedLocations[nPlayerID]):Length()
                        if flDistance>Util.flFenceRadius then
                            hHero:SetAbsOrigin(Util.supposedLocations[nPlayerID])
                            FindClearSpaceForUnit(hHero, Util.supposedLocations[nPlayerID], false)
                        end
                        if hHero.tempest_double_hClone and not hHero.tempest_double_hClone:IsNull() and hHero.tempest_double_hClone:HasModifier("modifier_tempest_double_illusion") then
                            local flTempestDoubleDistance = (hHero.tempest_double_hClone:GetOrigin() - Util.supposedLocations[nPlayerID]):Length()
                            if flTempestDoubleDistance>Util.flFenceRadius then
                                hHero.tempest_double_hClone:SetAbsOrigin(Util.supposedLocations[nPlayerID])
                                FindClearSpaceForUnit(hHero.tempest_double_hClone, Util.supposedLocations[nPlayerID], false)
                            end
                        end
                    end
                end
            end
        end
        return 0.25
    end})
end

function Util:GetServerDateTimeStr()
    local strDate = GetSystemDate().." "..GetSystemTime()
    local _, _, m, d, y, hour, min, sec = string.find(strDate, "(%d+)/(%d+)/(%d+)%s*(%d+):(%d+):(%d+)");    
    return (y..m..d..hour..min..sec)
end
