
----------------------------------------------------------------------
spider_nethertoxin_lua = class({})
LinkLuaModifier( "modifier_spider_nethertoxin_lua", "creature_ability/modifier/modifier_spider_nethertoxin_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function spider_nethertoxin_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function spider_nethertoxin_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local vector = point-caster:GetOrigin()

	-- load data
	local projectile_name = ""
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local projectile_distance = vector:Length2D()
	local projectile_direction = vector
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = 0,
	    fEndRadius = 0,
		vVelocity = projectile_direction * projectile_speed,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- play effects
	self:PlayEffects( point )
end
--------------------------------------------------------------------------------
-- Projectile
function spider_nethertoxin_lua:OnProjectileHit( target, location )
	-- should be no target
	if target then return false end

	-- references
	local duration = self:GetSpecialValueFor( "duration" )

	-- create thinker
	CreateModifierThinker(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_spider_nethertoxin_lua", -- modifier name
		{ duration = duration }, -- kv
		location,
		self:GetCaster():GetTeamNumber(),
		false
	)
end

function spider_nethertoxin_lua:PlayEffects( point )
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_viper/viper_nethertoxin_proj.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( projectile_speed, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 5, point )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():EmitSound("Hero_Viper.Nethertoxin.Cast")
end