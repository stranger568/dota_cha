LinkLuaModifier( "modifier_faceless_void_time_lock_custom_scepter", "heroes/hero_void/faceless_void_time_lock_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necrophos_scythe_creep", "heroes/modifier_necrophos_scythe_creep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_hunter_track_creep", "heroes/modifier_bounty_hunter_track_creep", LUA_MODIFIER_MOTION_NONE )

function GameMode:ModifierGainedFilter(keys)
    if keys and keys.name_const and (keys.name_const == "modifier_item_ultimate_scepter" or keys.name_const == "modifier_item_ultimate_scepter_consumed") then
        local hHero = EntIndexToHScript(keys.entindex_parent_const)
        HeroBuilder:AddScepterAbility(hHero)
        HeroBuilder:AddScepterLinkAbilities(hHero)
        HeroBuilder:RegisterScepterOwner(hHero)
        EventDriver:Dispatch("Hero:ScepterReceived", {hero = hHero})
    end
    if keys and keys.name_const and keys.name_const == "modifier_item_aghanims_shard" then
        local hHero = EntIndexToHScript(keys.entindex_parent_const)
        HeroBuilder:AddShardLinkAbilities(hHero)
        HeroBuilder:AddScepterShardAbility(keys.entindex_parent_const)
    end
    if keys and keys.name_const and keys.name_const == "modifier_skywrath_mage_shard" then
        local hHero = EntIndexToHScript(keys.entindex_parent_const)
        if hHero then
            local hModifier = hHero:FindModifierByName("modifier_skywrath_mage_shard")
            if hModifier and not hModifier:IsNull() then
                hHero:RemoveModifierByName("modifier_skywrath_mage_shard")
                hHero:AddNewModifier(hHero, nil, "modifier_skywrath_mage_shard_lua", {})
            end
        end
    end
    if keys and keys.name_const and keys.name_const == "modifier_necrolyte_reapers_scythe" then
        local hUnit = EntIndexToHScript(keys.entindex_parent_const)
        local hModifier = hUnit:FindModifierByName("modifier_necrolyte_reapers_scythe")
        if hModifier and not hUnit:IsHero() then
            local hCaster = hModifier:GetCaster()
            local hAbility = hModifier:GetAbility()
            local flDuration = hModifier:GetDuration()
            if hCaster and hAbility then
                hUnit:RemoveModifierByName("modifier_necrolyte_reapers_scythe")
                hUnit:AddNewModifier(hCaster, hAbility, "modifier_necrophos_scythe_creep", {duration = flDuration})
            end
        end
    end
    if keys and keys.name_const and keys.name_const == "modifier_lycan_summon_wolves_crit_maim" then
        local hUnit = EntIndexToHScript(keys.entindex_parent_const)
        if hUnit then
            local modifier_lycan_summon_wolves_crit_maim_modifiers = hUnit:FindAllModifiersByName("modifier_lycan_summon_wolves_crit_maim")
            local last_modifier = modifier_lycan_summon_wolves_crit_maim_modifiers[#modifier_lycan_summon_wolves_crit_maim_modifiers]
            for _, modifier in pairs (modifier_lycan_summon_wolves_crit_maim_modifiers) do
                if modifier ~= last_modifier then
                   modifier:Destroy()
                end
            end
        end
    end
    if keys and keys.name_const and keys.name_const == "modifier_bounty_hunter_track" then
        local hUnit = EntIndexToHScript(keys.entindex_parent_const)
        local hModifier = hUnit:FindModifierByName("modifier_bounty_hunter_track")
        if hModifier and not hUnit:IsHero() then
            local hCaster = hModifier:GetCaster()
            local hAbility = hModifier:GetAbility()
            local flDuration = hModifier:GetDuration()

            if hCaster and hAbility then
                hUnit:AddNewModifier(hCaster, hAbility, "modifier_bounty_hunter_track_creep", {duration = flDuration})
                if hModifier then
                    hModifier:Destroy()
                end
            end
        end
    end
    if keys and keys.name_const and keys.name_const == "modifier_faceless_void_time_walk" then
        local hHero = EntIndexToHScript(keys.entindex_parent_const)
        if hHero then
            local hModifier = hHero:FindModifierByName("modifier_faceless_void_time_walk")
            if hModifier and not hModifier:IsNull() then
                if hHero:HasScepter() then
                    if hModifier:GetAbility():GetAbilityName() == "faceless_void_time_walk" then
                        local bash = hHero:FindAbilityByName("faceless_void_time_lock_custom")
                        if bash and bash:GetLevel() > 0 then
                            hHero:AddNewModifier(hHero, bash, "modifier_faceless_void_time_lock_custom_scepter", {})
                        end
                    end
                end
            end
        end
    end

    if keys.name_const and HeroBuilder.attackCapabilityModifiers[keys.name_const] and keys.entindex_parent_const then
    	local hParent = EntIndexToHScript(keys.entindex_parent_const)
    	if hParent then
    		HeroBuilder:RegisterAttackCapabilityChanged(hParent)
    	end
	end

    return true
end