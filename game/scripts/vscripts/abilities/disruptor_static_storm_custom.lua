LinkLuaModifier( "modifier_disruptor_static_storm_custom", "abilities/disruptor_static_storm_custom", LUA_MODIFIER_MOTION_NONE )

disruptor_static_storm_custom = class({})

function disruptor_static_storm_custom:OnSpellStart()
	if not IsServer() then return end
	local point = self:GetCursorPosition()
	CreateModifierThinker( self:GetCaster(), self, "modifier_disruptor_static_storm_custom", {}, point, self:GetCaster():GetTeamNumber(), false )
	self:GetCaster():EmitSound("Hero_Disruptor.StaticStorm.Cast")
end

function disruptor_static_storm_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

modifier_disruptor_static_storm_custom = class({})

function modifier_disruptor_static_storm_custom:OnCreated( kv )
	if not IsServer() then return end
	self.owner = kv.isProvidedByAura~=1
	if not self.owner then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.pulses = self:GetAbility():GetSpecialValueFor( "pulses" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage_max" )
	self.interval = duration/self.pulses
	local max_tick_damage = damage * self.interval
	self.tick_damage = max_tick_damage / self.pulses
	self.pulse = 0
	self.dmg_interval = 0
	self.damageTable = 
	{
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
	}
	self:StartIntervalThink( self.interval )
	self:PlayEffects1( duration )
	self:GetParent():EmitSound("Hero_Disruptor.StaticStorm")
end

function modifier_disruptor_static_storm_custom:OnDestroy()
	if not IsServer() then return end
	if self.owner then
		self:GetParent():StopSound("Hero_Disruptor.StaticStorm")
		self:GetParent():EmitSound("Hero_Disruptor.StaticStorm.End")
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_disruptor_static_storm_custom:CheckState()
	local state = 
	{
		[MODIFIER_STATE_SILENCED] = true,
	}
	if self:GetCaster():HasScepter() then
		state = 
		{
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true,
		}
	end
	return state
end

function modifier_disruptor_static_storm_custom:OnIntervalThink()
	self.dmg_interval = self.dmg_interval + self.interval
	if self.dmg_interval >= 1 then
		self.dmg_interval = 0
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			self:PlayEffects2(enemy)
		end
	end
	self.pulse = self.pulse + 1
	self.damageTable.damage = self.tick_damage * self.pulse
	if self.pulse >= self.pulses then
		self:Destroy()
	end
end

function modifier_disruptor_static_storm_custom:IsAura()
	return self.owner
end

function modifier_disruptor_static_storm_custom:GetModifierAura()
	return "modifier_disruptor_static_storm_custom"
end

function modifier_disruptor_static_storm_custom:GetAuraRadius()
	return self.radius
end

function modifier_disruptor_static_storm_custom:GetAuraDuration()
	return 0.3
end

function modifier_disruptor_static_storm_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_disruptor_static_storm_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_disruptor_static_storm_custom:PlayEffects1( duration )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_disruptor_static_storm_custom:PlayEffects2( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm_bolt_hero.vpcf", PATTACH_OVERHEAD_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end