LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom", "heroes/hero_drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_debuff", "heroes/hero_drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_effect", "heroes/hero_drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )

drow_ranger_marksmanship_custom = class({})

function drow_ranger_marksmanship_custom:GetIntrinsicModifierName()
	return "modifier_drow_ranger_marksmanship_custom"
end

function drow_ranger_marksmanship_custom:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end

	local proc = false

	if data.ultimate == 1 or data.ultimate == true then
		proc = true
		local modifier = target:AddNewModifier( self:GetCaster(), self, "modifier_drow_ranger_marksmanship_custom_debuff", { duration = 0.5 } )
	end

	self:GetCaster().split_attack = true
	self.split = true

	self:GetCaster():PerformAttack( target, true, true, true, true, false, false, proc )

	self.split = false

	self:GetCaster().split_attack = false
end

modifier_drow_ranger_marksmanship_custom = class({})

function modifier_drow_ranger_marksmanship_custom:IsHidden()
	return true
end

function modifier_drow_ranger_marksmanship_custom:IsDebuff()
	return false
end

function modifier_drow_ranger_marksmanship_custom:IsPurgable()
	return false
end

function modifier_drow_ranger_marksmanship_custom:GetPriority()
	return MODIFIER_PRIORITY_LOW
end

function modifier_drow_ranger_marksmanship_custom:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.disable = self:GetAbility():GetSpecialValueFor( "disable_range" )
	self.radius = self:GetAbility():GetSpecialValueFor( "agility_range" )
	self.split_range = self:GetAbility():GetSpecialValueFor( "scepter_range" )
	self.split_count = self:GetAbility():GetSpecialValueFor( "split_count_scepter" )
	self.split_damage = self:GetAbility():GetSpecialValueFor( "damage_reduction_scepter" )
	self.active = true

	if not IsServer() then return end
	self.records = {}
	self.procs = false
	self.procs_miss = false
	self.info = 
	{
		Ability = self:GetAbility(),	
		EffectName = self:GetParent():GetRangedProjectileName(),
		iMoveSpeed = self:GetParent():GetProjectileSpeed(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,		
		bDodgeable = true,
		bIsAttack = true,
		ExtraData = {},
	}

	self:StartIntervalThink( 0.1 )
end

function modifier_drow_ranger_marksmanship_custom:OnRefresh( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.disable = self:GetAbility():GetSpecialValueFor( "disable_range" )
	self.radius = self:GetAbility():GetSpecialValueFor( "agility_range" )	
end

function modifier_drow_ranger_marksmanship_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
	return funcs
end

function modifier_drow_ranger_marksmanship_custom:OnAttackStart( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker~=self:GetParent() then return end
	if not self.active then return end
	local rand = RandomInt( 0, 100 )
	if rand>self.chance then return end
	self.procs = true
	self.procs_miss = true
end

function modifier_drow_ranger_marksmanship_custom:CheckState(kv)
	return 
	{
		[MODIFIER_STATE_CANNOT_MISS] = self.procs_miss
	}
end

function modifier_drow_ranger_marksmanship_custom:AttackModifier( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker~=self:GetParent() then return end
	if self:GetAbility().split and self:GetAbility().split_procs then
		self.procs = true
		self.procs_miss = true
	end
	if not self.procs then return end
	self.procs = false
	self.procs_miss = false
	self.records[params.record] = true
end

function modifier_drow_ranger_marksmanship_custom:AttackLandedModifier( params )
	if self:GetParent():PassivesDisabled() then return end
	if not self.records[params.record] then return end
	local modifier = params.target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_drow_ranger_marksmanship_custom_debuff", { duration = 0.5 } )
	self.records[params.record] = modifier
end

function modifier_drow_ranger_marksmanship_custom:GetModifierProcAttack_BonusDamage_Physical( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not self.records[params.record] then return end
	return self.damage
end

function modifier_drow_ranger_marksmanship_custom:OnAttackRecordDestroy( params )
	if not self.records[params.record] then return end
	if self:GetParent():PassivesDisabled() then return end
	local modifier = self.records[params.record]
	if type(modifier)=='table' and not modifier:IsNull() then modifier:Destroy() end
	self.records[params.record] = nil
end

function modifier_drow_ranger_marksmanship_custom:GetModifierProjectileName( params )
	if not IsServer() then return end
	if not self.procs then return end
	if self:GetParent():PassivesDisabled() then return end
	return "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
end

function modifier_drow_ranger_marksmanship_custom:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not self:GetParent():HasScepter() then return end
	if params.no_attack_cooldown then return end

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), params.target:GetOrigin(), nil, self.split_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	local count = 0
	for i,enemy in pairs(enemies) do
		if enemy~=params.target and count<self.split_count then
			local procs = false
			local rand = RandomInt( 0, 100 )
			if self.active and rand<=self.chance then
				procs = true
			end

			Timers:CreateTimer(0.07 * i, function()
				if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsAttackImmune() and not enemy:IsInvulnerable() then
					self.info.Target = enemy
					self.info.Source = params.target
					if procs then
						self.info.EffectName = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
						self.info.ExtraData = { ultimate = true }
					else
						self.info.EffectName = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
						self.info.ExtraData = { ultimate = false }
					end
					ProjectileManager:CreateTrackingProjectile( self.info )
				end
			end)

			count = count+1
		end
	end
end

function modifier_drow_ranger_marksmanship_custom:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if self:GetAbility().split then
		return -self.split_damage
	end
end

function modifier_drow_ranger_marksmanship_custom:OnIntervalThink()
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.disable, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false )
	local no_enemies = #enemies==0

	if self.active ~= no_enemies then
		self.active = no_enemies
	end
end

function modifier_drow_ranger_marksmanship_custom:IsAura()
	return self.active
end

function modifier_drow_ranger_marksmanship_custom:GetModifierAura()
	return "modifier_drow_ranger_marksmanship_custom_effect"
end

function modifier_drow_ranger_marksmanship_custom:GetAuraRadius()
	return self.radius
end

function modifier_drow_ranger_marksmanship_custom:GetAuraDuration()
	return 0.5
end

function modifier_drow_ranger_marksmanship_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_drow_ranger_marksmanship_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_drow_ranger_marksmanship_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY
end

function modifier_drow_ranger_marksmanship_custom:GetAuraEntityReject( hEntity )
	return false
end

modifier_drow_ranger_marksmanship_custom_effect = class({})

function modifier_drow_ranger_marksmanship_custom_effect:OnCreated( kv )
	self.agility = self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
	if not IsServer() then return end
	self:SetHasCustomTransmitterData(true)
	self.agilityb = 0
	self:StartIntervalThink(0.1)
end

function modifier_drow_ranger_marksmanship_custom_effect:OnRefresh( kv )
	self.agility = self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
end

function modifier_drow_ranger_marksmanship_custom_effect:OnIntervalThink()
	if not IsServer() then return end
	self.agilityb = 0
	local agi = self:GetCaster():GetAgility()
	self.agilityb = self.agility*agi/100
	self:GetParent():CalculateStatBonus(true)
	self:SendBuffRefreshToClients()
end

function modifier_drow_ranger_marksmanship_custom_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_drow_ranger_marksmanship_custom_effect:AddCustomTransmitterData() 
    return 
    {
        agilityb = self.agilityb,
    } 
end

function modifier_drow_ranger_marksmanship_custom_effect:HandleCustomTransmitterData(data)
    self.agilityb = data.agilityb
end

function modifier_drow_ranger_marksmanship_custom_effect:GetModifierBonusStats_Agility()
	if self:GetParent():PassivesDisabled() then return end
	return self.agilityb
end

modifier_drow_ranger_marksmanship_custom_debuff = class({})

function modifier_drow_ranger_marksmanship_custom_debuff:IsHidden()
	return true
end

function modifier_drow_ranger_marksmanship_custom_debuff:IsDebuff()
	return true
end

function modifier_drow_ranger_marksmanship_custom_debuff:IsStunDebuff()
	return false
end

function modifier_drow_ranger_marksmanship_custom_debuff:IsPurgable()
	return false
end

function modifier_drow_ranger_marksmanship_custom_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_drow_ranger_marksmanship_custom_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE,
	}

	return funcs
end

function modifier_drow_ranger_marksmanship_custom_debuff:GetModifierPhysicalArmorBase_Percentage()
	if IsClient() then 
		return 100 
	end
	return 0
end