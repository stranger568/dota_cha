LinkLuaModifier( "modifier_grimstroke_ink_creature_custom_thinker", "abilities/grimstroke_ink_creature_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_grimstroke_ink_creature_custom_target", "abilities/grimstroke_ink_creature_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_grimstroke_ink_creature_custom_debuff", "abilities/grimstroke_ink_creature_custom", LUA_MODIFIER_MOTION_NONE )

grimstroke_ink_creature_custom = class({})

function grimstroke_ink_creature_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function grimstroke_ink_creature_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local cursor_target = self:GetCursorTarget()
	if cursor_target:TriggerSpellAbsorb(self) then return end
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	for _, target in pairs(enemies) do
		local modifier = target:AddNewModifier( caster, self, "modifier_grimstroke_ink_creature_custom_target", {} )
		local spawnPos = caster:GetOrigin() + caster:GetForwardVector()*150
		local phantom = CreateUnitByName( "npc_dota_grimstroke_ink_creature", spawnPos, true, nil, nil, self:GetCaster():GetTeamNumber() )
		phantom:AddNewModifier( caster, self, "modifier_grimstroke_ink_creature_custom_thinker", { target = target:entindex() } )
		self:PlayEffects()
	end
end

function grimstroke_ink_creature_custom:OnProjectileHit( target, location )
	self:EndCooldown()
	EmitSoundOn( "Hero_Grimstroke.InkCreature.Returned", self:GetCaster() )
end

function grimstroke_ink_creature_custom:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_cast_phantom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Grimstroke.InkCreature.Cast", self:GetCaster() )
end

modifier_grimstroke_ink_creature_custom_debuff = class({})

function modifier_grimstroke_ink_creature_custom_debuff:IsHidden()
	return false
end

function modifier_grimstroke_ink_creature_custom_debuff:IsDebuff()
	return true
end

function modifier_grimstroke_ink_creature_custom_debuff:IsStunDebuff()
	return false
end

function modifier_grimstroke_ink_creature_custom_debuff:IsPurgable()
	return false
end

function modifier_grimstroke_ink_creature_custom_debuff:OnCreated( kv )
	if IsServer() then
		self:SetStackCount( 1 )
	end
end

function modifier_grimstroke_ink_creature_custom_debuff:OnRefresh( kv )
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_grimstroke_ink_creature_custom_debuff:OnStackCountChanged( oldStack )
	if IsServer() then
		if self:GetStackCount()<1 then
			self:Destroy()
		end
	end
end

function modifier_grimstroke_ink_creature_custom_debuff:CheckState()
	local state = 
	{
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	return state
end

function modifier_grimstroke_ink_creature_custom_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_grimstroke_ink_creature_custom_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_grimstroke_ink_creature_custom_target = class({})

function modifier_grimstroke_ink_creature_custom_target:IsHidden()
	return false
end

function modifier_grimstroke_ink_creature_custom_target:IsDebuff()
	return true
end

function modifier_grimstroke_ink_creature_custom_target:IsStunDebuff()
	return false
end

function modifier_grimstroke_ink_creature_custom_target:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_grimstroke_ink_creature_custom_target:IsPurgable()
	return false
end

function modifier_grimstroke_ink_creature_custom_target:OnCreated( kv )
	if IsServer() then
		self.silence = false
	end
end

function modifier_grimstroke_ink_creature_custom_target:CheckState()
	local state = 
	{
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	return state
end

function modifier_grimstroke_ink_creature_custom_target:GetEffectName()
	return "particles/units/heroes/hero_grimstroke/grimstroke_phantom_marker.vpcf"
end

function modifier_grimstroke_ink_creature_custom_target:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_grimstroke_ink_creature_custom_thinker = class({})

function modifier_grimstroke_ink_creature_custom_thinker:IsHidden()
	return true
end

function modifier_grimstroke_ink_creature_custom_thinker:IsDebuff()
	return false
end

function modifier_grimstroke_ink_creature_custom_thinker:IsPurgable()
	return false
end

function modifier_grimstroke_ink_creature_custom_thinker:OnCreated( kv )
	if IsServer() then
		self.target = EntIndexToHScript(kv.target)
		self.target_modifier = self.target:FindModifierByName("modifier_grimstroke_ink_creature_custom_target")
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
		self.latch_offset = self:GetAbility():GetSpecialValueFor( "latched_unit_offset" )
		self.latch_duration = self:GetAbility():GetSpecialValueFor( "latch_duration" )
		self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
		local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.pop_damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
		self.return_projectile = "particles/units/heroes/hero_grimstroke/grimstroke_phantom_return.vpcf"
		self.health = self:GetAbility():GetSpecialValueFor( "destroy_attacks" )
		self.hero_attack = self.health/self:GetAbility():GetSpecialValueFor( "hero_attack_multiplier" )
		self.max_health = self.health
		self.latching = false
		self.damageTable = 
		{
			victim = self.target,
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
		self:PlayEffects1()
	end
end

function modifier_grimstroke_ink_creature_custom_thinker:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
		if not self.latching then
			if not self.target_modifier:IsNull() then
				self.target_modifier:Destroy()
			end
		else
			if not self.modifier:IsNull() then
				self.modifier:DecrementStackCount()
			end
		end
		if self:GetParent():IsAlive() and not self.forcedKill then
			local info = {
				Target = self:GetCaster(),
				Source = self:GetParent(),
				Ability = self:GetAbility(),	
				EffectName = self.return_projectile,
				iMoveSpeed = self.speed,
				bDodgeable = true,		
			}
			ProjectileManager:CreateTrackingProjectile(info)
			self.damageTable.damage = self.pop_damage
			ApplyDamage( self.damageTable )
			EmitSoundOn( "Hero_Grimstroke.InkCreature.Damage", self:GetParent() )
			UTIL_Remove( self:GetParent() )
			return
		end
		self:PlayEffects3()
		self:GetParent():ForceKill( false )
	end
end

function modifier_grimstroke_ink_creature_custom_thinker:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
    	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_grimstroke_ink_creature_custom_thinker:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_grimstroke_ink_creature_custom_thinker:OnAttacked( params )
	if params.target~=self:GetParent() then return end
	if params.attacker:IsHero() then
		self.health = math.max(self.health - self.hero_attack, 0)
	else
		self.health = math.max(self.health - 1, 0)
	end

    local new_health = self.health/self.max_health * self:GetParent():GetMaxHealth()
    if math.floor(new_health) > 0 then
	    self:GetParent():SetHealth( math.floor(new_health) )
    else
        self:GetParent():Kill(self:GetAbility(), params.attacker)
    end
    
	self:PlayEffects2()
end

function modifier_grimstroke_ink_creature_custom_thinker:GetOverrideAnimation()
	if self.latching then
	    return ACT_DOTA_CAPTURE
	else
	    return ACT_DOTA_RUN
	end
end

function modifier_grimstroke_ink_creature_custom_thinker:CheckState()
	local state = 
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end

function modifier_grimstroke_ink_creature_custom_thinker:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetAbility() then
        self:GetParent():Destroy()
        return
    end
    if self.target:IsNull() then
        self:GetParent():Destroy()
        return
    end
    if not self.target:IsAlive() then
        self:GetParent():Destroy()
        return
    end
    print(self.damageTable)
	ApplyDamage( self.damageTable )
	EmitSoundOn( "Hero_Grimstroke.InkCreature.Attack", self:GetParent() )
end

function modifier_grimstroke_ink_creature_custom_thinker:UpdateHorizontalMotion( me, dt )
	if self.target:IsInvisible() or self.target:IsMagicImmune() or self.target:IsInvulnerable() then
		self.forcedKill = true
		self:Destroy()
		return
	end
	if not self.latching then
		if (self.target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()<self.latch_offset then
			self:SetLatching()
		end
		self:Charge( me, dt )
	else
		self:Latch( me, dt )
	end
end

function modifier_grimstroke_ink_creature_custom_thinker:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_grimstroke_ink_creature_custom_thinker:Charge( me, dt )
	local parent = self:GetParent()
	local pos = self:GetParent():GetOrigin()
	local targetpos = self.target:GetOrigin()
	local direction = targetpos-pos
	direction.z = 0		
	local target = pos + direction:Normalized() * (self.speed*dt)
	parent:SetOrigin( target )
	parent:FaceTowards( targetpos )
end

function modifier_grimstroke_ink_creature_custom_thinker:Latch( me, dt )
	local target = self.target:GetOrigin() + self.target:GetForwardVector()*self.latch_offset
	self:GetParent():SetOrigin( target )
	self:GetParent():FaceTowards(self.target:GetOrigin())
end

function modifier_grimstroke_ink_creature_custom_thinker:SetLatching()
	self.latching = true
	self:SetStackCount( 1 )
	self.target_modifier:Destroy()
	self.modifier = self.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_grimstroke_ink_creature_custom_debuff", { duration = self.latch_duration } )
	self:SetDuration( self.latch_duration, false )
	self:StartIntervalThink( self.tick_interval )
	EmitSoundOn( "Hero_Grimstroke.InkCreature.Attach", self:GetParent() )
end

function modifier_grimstroke_ink_creature_custom_thinker:OnStackCountChanged( oldCount )
	if IsClient() then
		self.latching = true
	end
end

function modifier_grimstroke_ink_creature_custom_thinker:PlayEffects1()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_phantom_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false)
	EmitSoundOn( "Hero_Grimstroke.InkCreature.Spawn", self:GetParent() )
end

function modifier_grimstroke_ink_creature_custom_thinker:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_phantom_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_grimstroke_ink_creature_custom_thinker:PlayEffects3()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_phantom_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Grimstroke.InkCreature.Death", self:GetParent() )
end