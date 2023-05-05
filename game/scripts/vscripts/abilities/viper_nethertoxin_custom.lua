LinkLuaModifier( "modifier_viper_nethertoxin_custom", "abilities/viper_nethertoxin_custom", LUA_MODIFIER_MOTION_NONE )

viper_nethertoxin_custom = class({})

function viper_nethertoxin_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function viper_nethertoxin_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local vector = point-caster:GetOrigin()
	local projectile_name = ""
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local projectile_distance = vector:Length2D()
	local projectile_direction = vector
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	local info = 
	{
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
	self:PlayEffects( point )
end

function viper_nethertoxin_custom:OnProjectileHit( target, location )
	if target then return false end
	local duration = self:GetSpecialValueFor( "duration" )
	CreateModifierThinker( self:GetCaster(), self, "modifier_viper_nethertoxin_custom", { duration = duration }, location, self:GetCaster():GetTeamNumber(), false )
end

function viper_nethertoxin_custom:PlayEffects( point )
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_viper/viper_nethertoxin_proj.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( projectile_speed, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 5, point )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Viper.Nethertoxin.Cast", self:GetCaster() )
end

modifier_viper_nethertoxin_custom = class({})

function modifier_viper_nethertoxin_custom:IsHidden()
	return false
end

function modifier_viper_nethertoxin_custom:IsDebuff()
	return true
end

function modifier_viper_nethertoxin_custom:IsStunDebuff()
	return false
end

function modifier_viper_nethertoxin_custom:IsPurgable()
	return false
end

function modifier_viper_nethertoxin_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_viper_nethertoxin_custom:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "min_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.owner = kv.isProvidedByAura~=1
	self.think = 0
	if not IsServer() then return end
	if not self.owner then
		self.damageTable = 
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}
		self:StartIntervalThink( 1 )
	else
		self:PlayEffects()
	end
end

function modifier_viper_nethertoxin_custom:OnDestroy()
	if not IsServer() then return end
	if not self.owner then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_viper_nethertoxin_custom:CheckState()
	local state = 
	{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
	return state
end

function modifier_viper_nethertoxin_custom:OnIntervalThink()
	ApplyDamage( self.damageTable )
	self.think = self.think + 1
	if self.think == self:GetAbility():GetSpecialValueFor("max_duration") then
		self.damageTable.damage = self:GetAbility():GetSpecialValueFor("max_damage")
	end
	EmitSoundOn( "Hero_Viper.NetherToxin.Damage", self:GetParent() )
end

function modifier_viper_nethertoxin_custom:IsAura()
	return self.owner
end

function modifier_viper_nethertoxin_custom:GetModifierAura()
	return "modifier_viper_nethertoxin_custom"
end

function modifier_viper_nethertoxin_custom:GetAuraRadius()
	return self.radius
end

function modifier_viper_nethertoxin_custom:GetAuraDuration()
	return 0.5
end

function modifier_viper_nethertoxin_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_viper_nethertoxin_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_viper_nethertoxin_custom:GetEffectName()
	if not self.owner then
		return "particles/units/heroes/hero_viper/viper_nethertoxin_debuff.vpcf"
	end
end

function modifier_viper_nethertoxin_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_viper_nethertoxin_custom:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_viper/viper_nethertoxin.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
	EmitSoundOn( "Hero_Viper.NetherToxin", self:GetParent() )
end