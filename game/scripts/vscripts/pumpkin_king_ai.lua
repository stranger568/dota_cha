function Spawn( entityKeyValues )
	
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	if thisEntity.vWaypoints==nil then
	    thisEntity.vWaypoints = {}
	    
	    local currentWayPoint = thisEntity:GetAbsOrigin()
		while #thisEntity.vWaypoints < 50 do
			local waypoint = currentWayPoint + RandomVector( RandomFloat( 0, 2048 ) )
			if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), waypoint ) then
				table.insert( thisEntity.vWaypoints, waypoint )
				currentWayPoint=waypoint
			end
		end		
	end

	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )

end

function CreepThink()

	if GameRules:IsGamePaused() then
		return 0.1
	end

	return RoamBetweenWaypoints()

end


function RoamBetweenWaypoints()
	if thisEntity.targetWayPoint ~= nil then
		
		if (thisEntity.targetWayPoint-thisEntity:GetAbsOrigin()):Length2D()<100 or GameRules:GetGameTime()-thisEntity.targetWayPointTime>60 then
			thisEntity.targetWayPoint = nil
		end
		
	end
	if thisEntity.targetWayPoint == nil then
	   thisEntity.targetWayPoint = thisEntity.vWaypoints[ RandomInt( 1, #thisEntity.vWaypoints ) ]
	   
	   thisEntity.targetWayPointTime = GameRules:GetGameTime()
	end
	if thisEntity.targetWayPoint then
	   thisEntity:MoveToPosition( thisEntity.targetWayPoint )
	end
	
	return 0.5
end