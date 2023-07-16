function Spawn( entityKeyValues )
	if not IsServer() then return end
	if thisEntity == nil then return end
    if thisEntity:GetTeam() ~= DOTA_TEAM_NEUTRALS then return end
    if not thisEntity:IsAlive() then return end

    for i=0,20 do
        local hAbility=thisEntity:GetAbilityByIndex(i)
        if hAbility and hAbility.IsPassive then
            if not hAbility:IsPassive() then
                hAbility:StartCooldown(0.5)
                if hAbility:GetAbilityName()=="harpy_storm_chain_lightning" then
                    Timers:CreateTimer({endTime = 0.45, callback = function()
                        if GetMapName()=="2x6" then
                            hAbility:SetLevel(2)
                        end
                        if string.find(GetMapName(),"1x8") then
                            hAbility:SetLevel(3)
                        end
                    end})
                end
                if hAbility:GetAbilityName()=="golem_anti_blademail" then
                    Timers:CreateTimer({ endTime = 0.45, callback = function()
                        if thisEntity:GetUnitName() == "npc_dota_mud_golem" then
                            hAbility:SetLevel(1)
                        end
                        if thisEntity:GetUnitName() == "npc_dota_rock_golem" then
                            hAbility:SetLevel(2)
                        end
                        if thisEntity:GetUnitName() == "npc_dota_granite_golem" then
                            hAbility:SetLevel(3)
                        end
                    end})
                end
            end
        end
    end

	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )
end

function CreepThink()
    local bResult,flResult = xpcall(
        function()
            if not thisEntity:IsAlive() then return end
          	if GameRules:IsGamePaused() then return 0.1 end

            if thisEntity:HasAbility("life_stealer_consume") then
                local  hInfest = thisEntity:FindAbilityByName("life_stealer_consume")
                if hInfest and hInfest:IsFullyCastable() then
                    ExecuteOrderFromTable({
                        UnitIndex = thisEntity:entindex(),
                        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                        AbilityIndex = hInfest:entindex(),
                    })
                end
            end

            if thisEntity:IsChanneling() then return 0.1 end

          	local hTarget

            if thisEntity.hTarget and not thisEntity.hTarget:IsNull() and thisEntity.hTarget:IsAlive() and (not thisEntity.hTarget:IsUnselectable()) then
                hTarget = thisEntity.hTarget
            else
                local vEnemies = {}               
             
                if thisEntity.nSpawnerTeamNumber~=nil then
                    vEnemies = FindUnitsInRadius(thisEntity.nSpawnerTeamNumber, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
                else
                    vEnemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
                end
             
                for _,hEnemy in pairs(vEnemies) do
                    if hEnemy and not hEnemy:IsNull() and hEnemy:IsAlive() and (not hEnemy:IsUnselectable())  then
                        hTarget = hEnemy
                        thisEntity.hTarget = hEnemy
                        break
                    end
                end

                if nil == hTarget then
             	    thisEntity.hTarget=nil
                    if not thisEntity:IsAttacking() then
                        thisEntity:MoveToPositionAggressive(thisEntity:GetOrigin())
                    end
             	    return 0.5
                end
            end
          
            local flAbilityCastTime = TryCastAbility(hTarget)
      	  
            if flAbilityCastTime then
          	    return flAbilityCastTime
            else
                if not thisEntity:IsAttacking() then
                    if thisEntity:CanEntityBeSeenByMyTeam(hTarget) then
            	       ExecuteOrderFromTable({ UnitIndex = thisEntity:entindex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE, Position = hTarget:GetOrigin() })
                    else
                        thisEntity:MoveToPositionAggressive(hTarget:GetOrigin())
                    end
                end
            end

            return 0.5
        end,
        function(e)
         print(e)
        if RandomInt(1, 100)<5 then end
    end)

    if bResult then
        return flResult
    else
        return 1
    end
end

function TryCastAbility(hTarget)
 	local flAbilityCastTime = CastAbility(hTarget)
 	if flAbilityCastTime then
 		return flAbilityCastTime
 	end
	return nil
end

function ContainsValue(sum,nValue)
    if type(sum) == "userdata" then
        sum = tonumber(tostring(sum))
    end
    if bit:_and(sum,nValue)==nValue then
        return true
    else
        return false
    end
end

function CastAbility(hTarget)
    for i=1,20 do
        local hAbility=thisEntity:GetAbilityByIndex(i-1)
        if hAbility and not hAbility:IsPassive() and hAbility:IsFullyCastable() then
        	if ContainsValue(hAbility:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and not ContainsValue(hAbility:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_ATTACK) then
        		if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_ENEMY) or ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_CUSTOM) and thisEntity:CanEntityBeSeenByMyTeam(hTarget) and not hTarget:IsInvisible() then
    			    ExecuteOrderFromTable({
    					UnitIndex = thisEntity:entindex(),
    					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
    					AbilityIndex = hAbility:entindex(),
    			        TargetIndex = hTarget:entindex()
    				})
					return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
                
                if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
					    ExecuteOrderFromTable({
							UnitIndex = thisEntity:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							AbilityIndex = hAbility:entindex(),
					        TargetIndex = thisEntity:entindex()
						})
				    return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
        	end

        	if ContainsValue(hAbility:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_POINT) and thisEntity:CanEntityBeSeenByMyTeam(hTarget) then
				local vLeadingOffset = hTarget:GetForwardVector() * RandomInt( 25, 75 )
                local vTargetPos = hTarget:GetOrigin() + vLeadingOffset
			    ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position =  vTargetPos,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        	if ContainsValue(hAbility:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_NO_TARGET) and not ContainsValue(hAbility:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_AUTOCAST) then
			    ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        	if ContainsValue(hAbility:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_AUTOCAST) then   		    
    		   if not hAbility:GetAutoCastState() then
                  hAbility:ToggleAutoCast()
    		   end
        	end
        end
    end
end

