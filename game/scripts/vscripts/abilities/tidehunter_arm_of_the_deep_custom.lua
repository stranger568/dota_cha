 LinkLuaModifier( "modifier_generic_arc_lua", "abilities/tidehunter_arm_of_the_deep_custom", LUA_MODIFIER_MOTION_BOTH )

tidehunter_arm_of_the_deep_custom = class({})

function tidehunter_arm_of_the_deep_custom:OnSpellStart()
	if not IsServer() then return end
	local point = self:GetCursorPosition()
	if point == self:GetCaster():GetAbsOrigin() then
		point = point + self:GetCaster():GetForwardVector()
	end
	local direction = point - self:GetCaster():GetAbsOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self:StartMiniRavage(direction)
end

function tidehunter_arm_of_the_deep_custom:StartMiniRavage(direction)
	if not IsServer() then return end
	local speed = self:GetSpecialValueFor("speed_scepter")
	local radius = self:GetSpecialValueFor("aoe_scepter")
	local tidehunter_ravage_custom = self:GetCaster():FindAbilityByName("tidehunter_ravage_custom")
	if tidehunter_ravage_custom and tidehunter_ravage_custom:GetLevel() > 0 then
		local info = {
			Source = self:GetCaster(),
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			bDeleteOnHit = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_arm_of_the_deep_projectile.vpcf",
			fDistance = tidehunter_ravage_custom:GetSpecialValueFor("radius") / 100 * self:GetSpecialValueFor("range_pct"),
			fStartRadius = 150,
			fEndRadius = 150,
			vVelocity = direction * 725,
			ExtraData = 
			{
				scepter = 1,
			}
		}
		self:GetCaster():EmitSound("Hero_Tidehunter.ArmsOfTheDeep")
		ProjectileManager:CreateLinearProjectile( info )
	else
		local info = 
		{
			Source = self:GetCaster(),
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			bDeleteOnHit = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_arm_of_the_deep_projectile.vpcf",
			fDistance = self:GetSpecialValueFor("radius") / 100 * self:GetSpecialValueFor("range_pct"),
			fStartRadius = 150,
			fEndRadius = 150,
			vVelocity = direction * 725,
			ExtraData = 
			{
				scepter = 1,
			}
		}
		self:GetCaster():EmitSound("Hero_Tidehunter.ArmsOfTheDeep")
		ProjectileManager:CreateLinearProjectile( info )
	end
end

function tidehunter_arm_of_the_deep_custom:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end

	local tidehunter_ravage_custom = self:GetCaster():FindAbilityByName("tidehunter_ravage_custom")
	if tidehunter_ravage_custom then
		local knockback = target:AddNewModifier( self:GetCaster(), self, "modifier_generic_arc_lua", { duration = 0.5, height = 350 } )

		local damage = tidehunter_ravage_custom:GetAbilityDamage() / 100 * self:GetSpecialValueFor("damage_pct")

		knockback:SetEndCallback( function()
			ApplyDamage({ victim = target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			target:EmitSound("Hero_Tidehunter.RavageDamage")
		end)

		target:EmitSound("Hero_Tidehunter.ArmsOfTheDeep.Stun")

		target:AddNewModifier( self:GetC aster(), self, "modifier_stunned", { duration = tidehunter_ravage_custom:GetSpecialValueFor("duration") / 100 * self:GetSpecialValueFor("duration_pct") } )
	else
		local knockback = target:AddNewModifier( self:GetCaster(), self, "modifier_generic_arc_lua", { duration = 0.5, height = 350 } )

		local damage = 250 / 100 * self:GetSpecialValueFor("damage_pct")

		knockback:SetEndCallback( function()
			ApplyDamage({ victim = target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			target:EmitSound("Hero_Tidehunter.RavageDamage")
		end)

		target:EmitSound("Hero_Tidehunter.ArmsOfTheDeep.Stun")

		target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("duration") / 100 * self:GetSpecialValueFor("duration_pct") } )
	end
	
	return false
end


------------------

-- Created by Elfansoer
--[[
	Generic Jump Arc
	kv data (default):
	-- direction, provide just one (or none for default):
		dir_x/y (forward), for direction
		target_x/y (forward), for target point
	-- horizontal motion, provide 2 of 3, duration-only (for vertical arc), or all 3
		speed (0)
		duration (0)
		distance (0): zero means no horizontal motion
	-- vertical motion.
		height (0): max height. zero means no vertical motion
		start_offset (0), height offset from ground at start of jump
		end_offset (0), height offset from ground at end of jump
	-- arc types
		fix_end (true): if true, landing z-pos is the same as jumping z-pos, not respecting on landing terrain height (Pounce)
		fix_duration (true): if false, arc ends when unit touches ground, not respecting duration (Shield Crash)
		fix_height (true): if false, arc max height depends on jump distance, height provided is max-height (Tree Dance)
	-- other
		isStun (false), parent is stunned
		isRestricted (false), parent is command restricted
		isForward (false), lock parent forward facing
		activity (none), activity when leaping
]] 
--------------------------------------------------------------------------------
modifier_generic_arc_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_arc_lua:IsHidden()
	return true
end

function modifier_generic_arc_lua:IsDebuff()
	return false
end

function modifier_generic_arc_lua:IsStunDebuff()
	return false
end

function modifier_generic_arc_lua:IsPurgable()
	return true
end

function modifier_generic_arc_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_arc_lua:OnCreated( kv )
	if not IsServer() then return end
	self.interrupted = false
	self:SetJumpParameters( kv )
	self:Jump()
end

function modifier_generic_arc_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_generic_arc_lua:OnRemoved()
end

function modifier_generic_arc_lua:OnDestroy()
	if not IsServer() then return end

	-- preserve height
	local pos = self:GetParent():GetOrigin()

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	-- preserve height if has end offset
	if self.end_offset~=0 then
		self:GetParent():SetOrigin( pos )
	end

	if self.endCallback then
		self.endCallback( self.interrupted )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_arc_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
	end

	return funcs
end

function modifier_generic_arc_lua:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end
function modifier_generic_arc_lua:GetOverrideAnimation()
	return self:GetStackCount()
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_arc_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_generic_arc_lua:UpdateHorizontalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end

	-- set relative position
	local pos = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( pos )
end

function modifier_generic_arc_lua:UpdateVerticalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end

	local pos = me:GetOrigin()
	local time = self:GetElapsedTime()

	-- set relative position
	local height = pos.z
	local speed = self:GetVerticalSpeed( time )
	pos.z = height + speed * dt
	me:SetOrigin( pos )

	if not self.fix_duration then
		local ground = GetGroundHeight( pos, me ) + self.end_offset
		if pos.z <= ground then

			-- below ground, set height as ground then destroy
			pos.z = ground
			me:SetOrigin( pos )
			self:Destroy()
		end
	end
end

function modifier_generic_arc_lua:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_generic_arc_lua:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Motion Helper
function modifier_generic_arc_lua:SetJumpParameters( kv )
	self.parent = self:GetParent()

	-- load types
	self.fix_end = true
	self.fix_duration = true
	self.fix_height = true
	if kv.fix_end then
		self.fix_end = kv.fix_end==1
	end
	if kv.fix_duration then
		self.fix_duration = kv.fix_duration==1
	end
	if kv.fix_height then
		self.fix_height = kv.fix_height==1
	end

	-- load other types
	self.isStun = kv.isStun==1
	self.isRestricted = kv.isRestricted==1
	self.isForward = kv.isForward==1
	self.activity = kv.activity or 0
	self:SetStackCount( self.activity )

	-- load direction
	if kv.target_x and kv.target_y then
		local origin = self.parent:GetOrigin()
		local dir = Vector( kv.target_x, kv.target_y, 0 ) - origin
		dir.z = 0
		dir = dir:Normalized()
		self.direction = dir
	end
	if kv.dir_x and kv.dir_y then
		self.direction = Vector( kv.dir_x, kv.dir_y, 0 ):Normalized()
	end
	if not self.direction then
		self.direction = self.parent:GetForwardVector()
	end

	-- load horizontal data
	self.duration = kv.duration
	self.distance = kv.distance
	self.speed = kv.speed
	if not self.duration then
		self.duration = self.distance/self.speed
	end
	if not self.distance then
		self.speed = self.speed or 0
		self.distance = self.speed*self.duration
	end
	if not self.speed then
		self.distance = self.distance or 0
		self.speed = self.distance/self.duration
	end

	-- load vertical data
	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0

	-- calculate height positions
	local pos_start = self.parent:GetOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
	local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
	local height_max

	-- determine jumping height if not fixed
	if not self.fix_height then
	
		-- ideal height is proportional to max distance
		self.height = math.min( self.height, self.distance/4 )
	end

	-- determine height max
	if self.fix_end then
		height_end = height_start
		height_max = height_start + self.height
	else
		-- calculate height
		local tempmin, tempmax = height_start, height_end
		if tempmin>tempmax then
			tempmin,tempmax = tempmax, tempmin
		end
		local delta = (tempmax-tempmin)*2/3

		height_max = tempmin + delta + self.height
	end

	-- set duration
	if not self.fix_duration then
		self:SetDuration( -1, false )
	else
		self:SetDuration( self.duration, true )
	end

	-- calculate arc
	self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_generic_arc_lua:Jump()
	-- apply horizontal motion
	if self.distance>0 then
		if not self:ApplyHorizontalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end

	-- apply vertical motion
	if self.height>0 then
		if not self:ApplyVerticalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
end

function modifier_generic_arc_lua:InitVerticalArc( height_start, height_max, height_end, duration )
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	-- fail-safe1: height_max cannot be smaller than height delta
	if height_max<height_end then
		height_max = height_end+0.01
	end

	-- fail-safe2: height-max must be positive
	if height_max<=0 then
		height_max = 0.01
	end

	-- math magic
	local duration_end = ( 1 + math.sqrt( 1 - height_end/height_max ) )/2
	self.const1 = 4*height_max*duration_end/duration
	self.const2 = 4*height_max*duration_end*duration_end/(duration*duration)
end

function modifier_generic_arc_lua:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_generic_arc_lua:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

--------------------------------------------------------------------------------
-- Helper
function modifier_generic_arc_lua:SetEndCallback( func )
	self.endCallback = func
end

-- Created by Elfansoer
--[[
	Usage parameters
		kv.start_radius (0)
		kv.end_radius (0)
		kv.width (100)
		kv.speed (0)
		kv.target_team
		kv.target_type
		kv.target_flags
		kv.IsCircle (1) -- 0: expanding radius, 1: expanding donut with width (hollow inside)
	Callback set after creating modifier:
		modifier:SetCallback( function( unit ) ... end ) -- MANDATORY
		modifier:SetEndCallback( function() ... end )
]]
--------------------------------------------------------------------------------
modifier_generic_ring_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_ring_lua:IsHidden()
	return true
end

function modifier_generic_ring_lua:IsDebuff()
	return false
end

function modifier_generic_ring_lua:IsStunDebuff()
	return false
end

function modifier_generic_ring_lua:IsPurgable()
	return false
end

function modifier_generic_ring_lua:RemoveOnDeath()
	return false
end

function modifier_generic_ring_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_ring_lua:OnCreated( kv )

	if not IsServer() then return end

	-- references
	self.start_radius = kv.start_radius or 0
	self.end_radius = kv.end_radius or 0
	self.width = kv.width or 100
	self.speed = kv.speed or 0
	self.outward = self.end_radius>=self.start_radius
	if not self.outward then
		self.speed = -self.speed
	end

	self.target_team = kv.target_team or 0
	self.target_type = kv.target_type or 0
	self.target_flags = kv.target_flags or 0

	self.IsCircle = kv.IsCircle or 1

	self.targets = {}
end

function modifier_generic_ring_lua:OnRemoved()
end

function modifier_generic_ring_lua:OnDestroy()
	if self.EndCallback then
		self.EndCallback()
	end
	if not IsServer() then return end

	-- kill if thinker
	if self:GetParent():GetClassname()=="npc_dota_thinker" then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_generic_ring_lua:SetCallback( callback )
	self.Callback = callback

	-- Start interval
	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()
end

function modifier_generic_ring_lua:SetEndCallback( callback )
	self.EndCallback = callback
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_ring_lua:OnIntervalThink()
	local radius = self.start_radius + self.speed * self:GetElapsedTime()
	if not self.outward and radius<self.end_radius then
		self:Destroy()
		return
	elseif self.outward and radius>self.end_radius then
		self:Destroy()
		return
	end

	-- Find targets in ring
	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.target_team,	-- int, team filter
		self.target_type,	-- int, type filter
		self.target_flags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,target in pairs(targets) do

		-- only unaffected unit
		if not self.targets[target] then

			-- check if it is within circle/chakram
			if (not self.IsCircle) or (target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()>(radius-self.width) then

				self.targets[target] = true

				-- do something
				self.Callback( target )
			end
		end

	end
end