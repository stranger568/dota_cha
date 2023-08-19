LinkLuaModifier( "modifier_grimstroke_spirit_walk_custom", "abilities/grimstroke_spirit_walk_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_grimstroke_spirit_walk_custom_return", "abilities/grimstroke_spirit_walk_custom", LUA_MODIFIER_MOTION_NONE )

grimstroke_spirit_walk_custom = class({})

grimstroke_return_custom = class({})
function grimstroke_return_custom:OnSpellStart()
    if not IsServer() then return end
    local modifier_grimstroke_spirit_walk_custom_return = self:GetCaster():FindModifierByName("modifier_grimstroke_spirit_walk_custom_return")
    if modifier_grimstroke_spirit_walk_custom_return then
        modifier_grimstroke_spirit_walk_custom_return.mod:Destroy()
    end
end

function grimstroke_spirit_walk_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("buff_duration")
	local modifier_grimstroke_spirit_walk_custom = target:AddNewModifier( self:GetCaster(), self, "modifier_grimstroke_spirit_walk_custom", { duration = duration } )
    local modifier_grimstroke_spirit_walk_custom_return = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_grimstroke_spirit_walk_custom_return", { duration = duration } )
    modifier_grimstroke_spirit_walk_custom_return.mod = modifier_grimstroke_spirit_walk_custom
	self:PlayEffects()
end

function grimstroke_spirit_walk_custom:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_cast_ink_swell.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Grimstroke.InkSwell.Cast", self:GetCaster() )
end

modifier_grimstroke_spirit_walk_custom_return = class({})
function modifier_grimstroke_spirit_walk_custom_return:IsHidden() return true end
function modifier_grimstroke_spirit_walk_custom_return:IsPurgable() return false end
function modifier_grimstroke_spirit_walk_custom_return:OnCreated()
    if not IsServer() then return end
    local grimstroke_return_custom = self:GetCaster():FindAbilityByName("grimstroke_return_custom")
    if grimstroke_return_custom then
        grimstroke_return_custom:SetLevel(1)
    end
    self:GetCaster():SwapAbilities("grimstroke_spirit_walk_custom", "grimstroke_return_custom", false, true)
end
function modifier_grimstroke_spirit_walk_custom_return:OnDestroy()
    if not IsServer() then return end
    self:GetCaster():SwapAbilities("grimstroke_return_custom", "grimstroke_spirit_walk_custom", false, true)
end

modifier_grimstroke_spirit_walk_custom = class({})

function modifier_grimstroke_spirit_walk_custom:IsHidden()
	return false
end

function modifier_grimstroke_spirit_walk_custom:IsDebuff()
	return false
end

function modifier_grimstroke_spirit_walk_custom:IsPurgable()
	return false
end

function modifier_grimstroke_spirit_walk_custom:OnCreated( kv )
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.interval = self.ability:GetSpecialValueFor( "tick_rate" )
	local damage = self.ability:GetSpecialValueFor( "damage_per_tick" )
	self.speed = self.ability:GetSpecialValueFor( "movespeed_bonus_pct" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.base_damage = self.ability:GetSpecialValueFor( "max_damage" )
	self.base_stun = self.ability:GetSpecialValueFor( "max_stun" )
	self.shard_bonus_damage_pct = self.ability:GetSpecialValueFor("shard_bonus_damage_pct")
	self.shard_heal_pct = self.ability:GetSpecialValueFor("shard_heal_pct")
	if IsServer() then
		self.damageTable = 
		{
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability,
		}
		self:StartIntervalThink( self.interval )
		self:PlayEffects1()
	end
end

function modifier_grimstroke_spirit_walk_custom:OnRefresh( kv )
	self.interval = self.ability:GetSpecialValueFor( "tick_rate" )
	local damage = self.ability:GetSpecialValueFor( "damage_per_tick" )
	self.speed = self.ability:GetSpecialValueFor( "movespeed_bonus_pct" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.base_damage = self.ability:GetSpecialValueFor( "max_damage" )
	self.base_stun = self.ability:GetSpecialValueFor( "max_stun" )
	if IsServer() then
		self.damageTable.damage = damage
	end
end

function modifier_grimstroke_spirit_walk_custom:OnDestroy( kv )
	if IsServer() then
        self:GetCaster():RemoveModifierByName("modifier_grimstroke_spirit_walk_custom_return")
		local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		local stun = self.base_stun
		self.damageTable.damage = self.base_damage
		if self.caster:HasShard() then
			self.damageTable.damage = (self.damageTable.damage + self.damageTable.damage / 100 * self.shard_bonus_damage_pct)
		end
		
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			local dmg = ApplyDamage( self.damageTable )
			if self.caster:HasShard() then
				if dmg > 0 then
					self.caster:Heal(dmg / 100 * self.shard_heal_pct, self.ability)
				end
				self.caster:Purge(false, true, false, true, true)
			end
			enemy:AddNewModifier( self.caster, self.ability, "modifier_stunned", { duration = stun } )
		end

		self:PlayEffects3()
	end
end

function modifier_grimstroke_spirit_walk_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_grimstroke_spirit_walk_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end

function modifier_grimstroke_spirit_walk_custom:OnIntervalThink()
	local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)
		self:PlayEffects2( enemy )
	end
end

function modifier_grimstroke_spirit_walk_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf"
end

function modifier_grimstroke_spirit_walk_custom:PlayEffects1()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:SetParticleControlEnt( effect_cast, 3, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetOrigin(), true )
	self:AddParticle( effect_cast, false, false, -1, false, true )
	EmitSoundOn( "Hero_Grimstroke.InkSwell.Target", self.parent )
end

function modifier_grimstroke_spirit_walk_custom:PlayEffects2( target )
    if target:IsHero() then
	    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_tick_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	    ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	    ParticleManager:SetParticleControlEnt( effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	    ParticleManager:ReleaseParticleIndex( effect_cast )
    end
	EmitSoundOn( "Hero_Grimstroke.InkSwell.Damage", target )
end

function modifier_grimstroke_spirit_walk_custom:PlayEffects3()
	StopSoundOn( "Hero_Grimstroke.InkSwell.Target", self.parent )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Grimstroke.InkSwell.Stun", self.parent )
end