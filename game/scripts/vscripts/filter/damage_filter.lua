LinkLuaModifier( "modifier_sand_king_caustic_finale_lua_debuff", "heroes/hero_sandking/modifier_sand_king_caustic_finale_lua_debuff", LUA_MODIFIER_MOTION_NONE )

function GameMode:DamageFilter(damageTable)
    if damageTable.entindex_attacker_const == nil then return true end
    local hAttacker = EntIndexToHScript(damageTable.entindex_attacker_const)
    local hVictim = EntIndexToHScript(damageTable.entindex_victim_const)

    -- Дополнинения к абилкам и на базе
    if damageTable.entindex_inflictor_const ~= nil then
        local hAbility = EntIndexToHScript(damageTable.entindex_inflictor_const)
        local Ability_Name = hAbility:GetAbilityName()

        if hAbility and hAbility.GetAbilityName and "oracle_false_promise_custom" == Ability_Name then
            if hVictim:HasModifier("modifier_hero_refreshing") then
                return false
            end
        end

        if hAbility and hAbility.GetAbilityName and "sandking_burrowstrike" == Ability_Name then
            if hAttacker and hAttacker.HasScepter and hAttacker:HasScepter() then
                local hCausticFinale = hAttacker:FindAbilityByName("sandking_caustic_finale_lua")
                if hCausticFinale and hCausticFinale:GetLevel()>=1 and hVictim then
                    local nDuration = hCausticFinale:GetSpecialValueFor( "caustic_finale_duration" )
                    hVictim:AddNewModifier(hAttacker,hCausticFinale,"modifier_sand_king_caustic_finale_lua_debuff",{duration = nDuration})
                end
            end
        end

        if hAbility and hAbility.GetAbilityName and ("item_blade_mail" == Ability_Name or "spectre_dispersion_custom" == Ability_Name or "shadow_demon_disseminate" == Ability_Name or "item_force_field" == Ability_Name) then
            if hVictim and hVictim:HasAbility("golem_anti_blademail") then
                local hAntiAbility= hVictim:FindAbilityByName("golem_anti_blademail")
                if hAntiAbility then
                    if GameMode.currentRound and GameMode.currentRound.nRoundNumber >= 80 then
                        damageTable.damage = damageTable.damage *(1-hAntiAbility:GetSpecialValueFor("damage_reduction")/100)
                    end
                end
            end
        end
    end

    -- Курсы------------------------------------------------------------------------------------------------------
    if hAttacker and hAttacker:HasModifier("modifier_loser_curse") then
        local modifier_loser_curse = hAttacker:FindModifierByName("modifier_loser_curse")
        if modifier_loser_curse then
            damageTable.damage = tonumber(damageTable.damage) * (1 - (0.2 * modifier_loser_curse:GetStackCount()))
        end
    end
    if hAttacker and hAttacker:HasModifier("modifier_cha_ban") then
        damageTable.damage = tonumber(damageTable.damage) * 0.75
    end
    -------------------------------------------------------------------------------------------------------------

    if hAttacker and hAttacker:IsHero() and damageTable.damage > 0 then
        local no_found = true
        local id = hAttacker:GetPlayerOwnerID()
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id] then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage then
                local ability_name = nil
                local ability_type = "attack"
                if damageTable.entindex_inflictor_const ~= nil then
                    ability_name = EntIndexToHScript(damageTable.entindex_inflictor_const):GetAbilityName()
                else
                    ability_name = "attack"
                end
                for _, hero_table in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage) do
                    if hero_table.name == ability_name then
                        no_found = false
                        if hero_table.damage then
                            hero_table.damage = hero_table.damage + tonumber(damageTable.damage)
                        else
                            hero_table.damage = tonumber(damageTable.damage)
                        end
                    end
                end
                if damageTable.entindex_inflictor_const ~= nil then
                    if EntIndexToHScript(damageTable.entindex_inflictor_const):IsItem() then
                        ability_type = "item"
                    else
                        ability_type = "ability"
                    end
                else
                    ability_type = "attack"
                end
                if no_found then
                    table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage, {name = ability_name, damage = damageTable.damage, index = hAttacker:entindex(), damage_type = damageTable.damagetype_const, type = ability_type})
                end
            end
        end
    end

    if hVictim and hVictim:IsRealHero() and damageTable.damage > 0 then
        local no_found = true
        local id = hVictim:GetPlayerOwnerID()
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id] then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage_income then
                local ability_name = nil
                local ability_type = "attack"
                if damageTable.entindex_inflictor_const ~= nil then
                    ability_name = EntIndexToHScript(damageTable.entindex_inflictor_const):GetAbilityName()
                else
                    ability_name = "attack"
                end
                for _, hero_table in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage_income) do
                    if hero_table.name == ability_name then
                        no_found = false
                        if hero_table.damage then
                            hero_table.damage = hero_table.damage + tonumber(damageTable.damage)
                        else
                            hero_table.damage = tonumber(damageTable.damage)
                        end
                    end
                end
                if damageTable.entindex_inflictor_const ~= nil then
                    if EntIndexToHScript(damageTable.entindex_inflictor_const):IsItem() then
                        ability_type = "item"
                    else
                        ability_type = "ability"
                    end
                else
                    ability_type = "attack"
                end
                if no_found then
                    table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage_income, {name = ability_name, damage = damageTable.damage, index = hVictim:entindex(), damage_type = damageTable.damagetype_const, type = ability_type})
                end
            end
        end
    end

    if hAttacker and hAttacker.GetPlayerOwnerID and hAttacker:GetPlayerOwnerID() and hAttacker:GetOwner() and not hAttacker:IsHero() and damageTable.damage > 0 then
        local no_found = true
        local id = hAttacker:GetPlayerOwnerID()
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id] then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage then
                local ability_type = "unit"
                for _, hero_table in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION[id].spell_damage) do
                    if hero_table.name == hAttacker:GetUnitName() then
                        no_found = false
                        if hero_table.damage then
                            hero_table.damage = hero_table.damage + tonumber(damageTable.damage)
                        else
                            hero_table.damage = tonumber(damageTable.damage)
                        end
                    end
                end
                if no_found then
                    if hAttacker ~= hVictim then
                        table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerOwnerID()].spell_damage, {name = hAttacker:GetUnitName(), damage = damageTable.damage, index = hAttacker:entindex(), damage_type = damageTable.damagetype_const, type = ability_type})
                    end
                end
            end
        end
    end
    
    return true
end