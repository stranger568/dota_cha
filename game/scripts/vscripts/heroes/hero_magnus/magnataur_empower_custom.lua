LinkLuaModifier( "modifier_magnataur_empower_custom", "heroes/hero_magnus/magnataur_empower_custom", LUA_MODIFIER_MOTION_NONE )

magnataur_empower_custom = class({})

function magnataur_empower_custom:OnSpellStart()
	if not IsServer() then return end
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "empower_duration" ) + self:GetCaster():FindTalentValue("special_bonus_unique_magnus_4")
	target:AddNewModifier( self:GetCaster(), self, "modifier_magnataur_empower_custom", { duration = duration } )
	self:GetCaster():EmitSound("Hero_Magnataur.Empower.Cast")
	target:EmitSound("Hero_Magnataur.Empower.Target")
end

modifier_magnataur_empower_custom = class({})

function modifier_magnataur_empower_custom:IsPurgable()
	return false
end

function modifier_magnataur_empower_custom:OnCreated( kv )
	self.ability = self:GetAbility()

	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" ) + self:GetCaster():FindTalentValue("special_bonus_unique_magnus_2")
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" ) + self:GetCaster():FindTalentValue("special_bonus_unique_magnus_2")
	self.self_multiplier = self:GetAbility():GetSpecialValueFor( "self_multiplier" )

	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )

	if self:GetParent()==self:GetCaster() then
		self.damage = self.damage + ( self.damage / 100 * self.self_multiplier)
		self.cleave = self.cleave + ( self.cleave / 100 * self.self_multiplier)
	end
end

function modifier_magnataur_empower_custom:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_magnataur_empower_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_magnataur_empower_custom:OnTooltip()
	return self.cleave
end

function modifier_magnataur_empower_custom:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self:GetParent().anchor_attack_talent then return end
	if self:GetParent().bCanTriggerLock then print("СОРРИ ПАССИВКА ВОЙДА") return end

	local frostivus2018_clinkz_searing_arrows = self:GetParent():FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		print("чекаем абилку", frostivus2018_clinkz_searing_arrows:GetAutoCastState())
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if keys.no_attack_cooldown then
				print("СТОЯТЬ ДРУЖИЩЕ")
				return
			end
		end
	end

	local damage = params.damage * self.cleave / 100

	if params.attacker:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		DoCleaveAttack( params.attacker, params.target, self.ability, self.cleave, self.radius_start, self.radius_end, self.radius_dist, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf" )
	else
		local enemies = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.target:GetAbsOrigin(), nil, self.radius_end, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= params.target then
				ApplyDamage({ victim = enemy, attacker = params.attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = self.ability })
			end
		end
		local blast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, params.target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(blast_pfx)
	end
end

function modifier_magnataur_empower_custom:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage
end

function modifier_magnataur_empower_custom:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end

function modifier_magnataur_empower_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
