LinkLuaModifier( "modifier_sand_king_caustic_finale_lua_debuff", "heroes/hero_sandking/modifier_sand_king_caustic_finale_lua_debuff", LUA_MODIFIER_MOTION_NONE )

function GameMode:DamageFilter(damageTable)
    if damageTable.entindex_attacker_const == nil then return true end
    local hAttacker = EntIndexToHScript(damageTable.entindex_attacker_const)
    local hVictim = EntIndexToHScript(damageTable.entindex_victim_const)

    -- Дополнинения к абилкам и на базе
    if damageTable.entindex_inflictor_const ~= nil then
        local hAbility = EntIndexToHScript(damageTable.entindex_inflictor_const)
        if hAbility and hAbility.GetAbilityName and "oracle_false_promise_custom" == hAbility:GetAbilityName() then
            if hVictim:HasModifier("modifier_hero_refreshing") then
                return false
            end
        end
        if hAbility and hAbility.GetAbilityName and "sandking_burrowstrike"==hAbility:GetAbilityName() then
            if hAttacker and hAttacker.HasScepter and hAttacker:HasScepter() then
                local hCausticFinale = hAttacker:FindAbilityByName("sandking_caustic_finale_lua")
                if hCausticFinale and hCausticFinale:GetLevel()>=1 and hVictim then
                    local nDuration = hCausticFinale:GetSpecialValueFor( "caustic_finale_duration" )
                    hVictim:AddNewModifier(hAttacker,hCausticFinale,"modifier_sand_king_caustic_finale_lua_debuff",{duration = nDuration})
                end
            end
        end
        if hAbility and hAbility.GetAbilityName and ("item_blade_mail"==hAbility:GetAbilityName() or "spectre_dispersion"==hAbility:GetAbilityName() or "shadow_demon_disseminate"==hAbility:GetAbilityName() or "item_force_field"==hAbility:GetAbilityName()) then
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

    -- Донатная таблица урона
    if hAttacker and hAttacker.GetPlayerOwnerID and hAttacker:GetPlayerOwnerID() and hAttacker:GetOwner() and not hAttacker:IsHero() and damageTable.damage > 0 then
        local no_found = true
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerOwnerID()] then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerOwnerID()].spell_damage then
                local ability_type = "unit"
                for _, hero_table in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerOwnerID()].spell_damage) do
                    if hero_table.name == hAttacker:GetUnitName() then
                        no_found = false
                        if hero_table.damage then
                            hero_table.damage = hero_table.damage + damageTable.damage
                        else
                            hero_table.damage = damageTable.damage
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

    if hVictim and hVictim:IsRealHero() and damageTable.damage > 0 then
        local no_found = true
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hVictim:GetPlayerID()] then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hVictim:GetPlayerID()].spell_damage_income then
                local ability_name = nil
                local ability_type = "attack"
                if damageTable.entindex_inflictor_const ~= nil then
                    ability_name = EntIndexToHScript(damageTable.entindex_inflictor_const):GetAbilityName()
                else
                    ability_name = "attack"
                end
                for _, hero_table in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hVictim:GetPlayerID()].spell_damage_income) do
                    if hero_table.name == ability_name then
                        no_found = false
                        if hero_table.damage then
                            hero_table.damage = hero_table.damage + damageTable.damage
                        else
                            hero_table.damage = damageTable.damage
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
                    table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hVictim:GetPlayerID()].spell_damage_income, {name = ability_name, damage = damageTable.damage, index = hVictim:entindex(), damage_type = damageTable.damagetype_const, type = ability_type})
                end
            end
        end
    end

    if hAttacker and hAttacker:IsHero() and damageTable.damage > 0 then
        local no_found = true
        if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerID()] then
            if ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerID()].spell_damage then
                local ability_name = nil
                local ability_type = "attack"

                if damageTable.entindex_inflictor_const ~= nil then
                    ability_name = EntIndexToHScript(damageTable.entindex_inflictor_const):GetAbilityName()
                else
                    ability_name = "attack"
                end

                for _, hero_table in pairs(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerID()].spell_damage) do
                    if hero_table.name == ability_name then
                        no_found = false
                        if hero_table.damage then
                            hero_table.damage = hero_table.damage + damageTable.damage
                        else
                            hero_table.damage = damageTable.damage
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
                    table.insert(ChaServerData.PLAYERS_GLOBAL_INFORMATION[hAttacker:GetPlayerID()].spell_damage, {name = ability_name, damage = damageTable.damage, index = hAttacker:entindex(), damage_type = damageTable.damagetype_const, type = ability_type})
                end
            end
        end
    end

    return true
end