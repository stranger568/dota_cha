LinkLuaModifier( "modifier_dawnbreaker_luminosity_custom", "heroes/hero_dawnbreaker/dawnbreaker_luminosity_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dawnbreaker_luminosity_custom_buff", "heroes/hero_dawnbreaker/dawnbreaker_luminosity_custom", LUA_MODIFIER_MOTION_NONE )

dawnbreaker_luminosity_custom = class({})

function dawnbreaker_luminosity_custom:GetIntrinsicModifierName()
	return "modifier_dawnbreaker_luminosity_custom"
end

modifier_dawnbreaker_luminosity_custom = class({})

function modifier_dawnbreaker_luminosity_custom:IsHidden()
	return self:GetStackCount()<1
end

function modifier_dawnbreaker_luminosity_custom:IsDebuff()
	return false
end

function modifier_dawnbreaker_luminosity_custom:IsPurgable()
	return false
end

function modifier_dawnbreaker_luminosity_custom:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not IsServer() then return end
end

function modifier_dawnbreaker_luminosity_custom:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_dawnbreaker_luminosity_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_dawnbreaker_luminosity_custom:GetModifierProcAttack_Feedback( params )
	if self.parent:HasModifier( "modifier_starbreaker_fire_wreath_caster" ) then return end
	self:Increment()
end

function modifier_dawnbreaker_luminosity_custom:Increment()
	if self.parent:PassivesDisabled() then return end
	if self:GetStackCount()>=(self:GetAbility():GetSpecialValueFor( "attack_count" ) - self:GetCaster():FindTalentValue("special_bonus_unique_dawnbreaker_luminosity_attack_count")) then return end
	self:IncrementStackCount()
	if self:GetStackCount()<(self:GetAbility():GetSpecialValueFor( "attack_count" ) - self:GetCaster():FindTalentValue("special_bonus_unique_dawnbreaker_luminosity_attack_count")) then return end
	local mod = self.parent:AddNewModifier( self.parent, self.ability, "modifier_dawnbreaker_luminosity_custom_buff", {} )
	mod.modifier = self
end

modifier_dawnbreaker_luminosity_custom_buff = class({})

function modifier_dawnbreaker_luminosity_custom_buff:IsHidden()
	return false
end

function modifier_dawnbreaker_luminosity_custom_buff:IsDebuff()
	return false
end

function modifier_dawnbreaker_luminosity_custom_buff:IsPurgable()
	return true
end

function modifier_dawnbreaker_luminosity_custom_buff:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.heal = self:GetAbility():GetSpecialValueFor( "heal_pct" )
	self.radius = self:GetAbility():GetSpecialValueFor( "heal_radius" )
	self.crit = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.allyheal = self:GetAbility():GetSpecialValueFor( "allied_healing_pct" )
	self.creepheal = self:GetAbility():GetSpecialValueFor( "heal_from_creeps" )
	if not IsServer() then return end
	self.passive = false
	self.total_heal = 0
	self.allies = {}
	self:PlayEffects1()
end

function modifier_dawnbreaker_luminosity_custom_buff:OnDestroy()
	if not IsServer() then return end
	if not self.passive then
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_HEAL,
			self.parent,
			self.total_heal,
			self.parent:GetPlayerOwner()
		)
		local allyheal = self.total_heal * self.allyheal/100
		for ally,_ in pairs(self.allies) do
			SendOverheadEventMessage(
				nil,
				OVERHEAD_ALERT_HEAL,
				ally,
				allyheal,
				self.parent:GetPlayerOwner()
			)
		end
	end

	self.passive = false
	self.total_heal = 0
	self.allies = {}
	self.modifier:SetStackCount( 0 )
end

function modifier_dawnbreaker_luminosity_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_dawnbreaker_luminosity_custom_buff:GetModifierPreAttack_CriticalStrike()
	return self.crit 
end

function modifier_dawnbreaker_luminosity_custom_buff:GetModifierProcAttack_Feedback( params )
	if self.parent:PassivesDisabled() then
		self.passive = true
		if self.parent:HasModifier( "modifier_starbreaker_fire_wreath_caster" ) then return end
		self:Destroy()
		return
	end

	local heal = params.damage * self.heal/100

	if params.target:IsCreep() then
		heal = heal * self.creepheal/100
	end

	self.parent:Heal( heal, self.ability )
	self.total_heal = self.total_heal + heal

	local allies = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )

	heal = heal * self.allyheal/100

	for _,ally in pairs(allies) do
		if ally~=self.parent then
			ally:Heal( heal, self.ability )
			self.allies[ally] = true
			self:PlayEffects2( params.target, ally )
		end
	end

	self:PlayEffects2( params.target, self.parent )
	params.target:EmitSound("Hero_Dawnbreaker.Luminosity.Strike")
	if self.parent:HasModifier( "modifier_starbreaker_fire_wreath_caster" ) then return end
	self:Destroy()
end

function modifier_dawnbreaker_luminosity_custom_buff:PlayEffects1()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity_attack_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( effect_cast, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
	self.parent:EmitSound("Hero_Dawnbreaker.Luminosity.PowerUp")
end

function modifier_dawnbreaker_luminosity_custom_buff:PlayEffects2( target, ally )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity.vpcf", PATTACH_POINT_FOLLOW, ally )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	ally:EmitSound("Hero_Dawnbreaker.Luminosity.Heal")
end
