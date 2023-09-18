terrorblade_reflection_lua = class({})
LinkLuaModifier("modifier_terrorblade_reflection_creep_damage_lua", "heroes/hero_terrorblade/terrorblade_reflection_lua", LUA_MODIFIER_MOTION_NONE)

function terrorblade_reflection_lua:GetAOERadius()
	return self:GetSpecialValueFor("range")
end

function terrorblade_reflection_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local ability_level = self:GetLevel() - 1
	local target_loc = self:GetCursorPosition()

	local illusion_duration = self:GetSpecialValueFor("illusion_duration") --+ caster:FindTalentValue("special_bonus_unique_terrorblade_2")	-- +2s reflection duration
	local range = self:GetSpecialValueFor("range")
	local illusion_outgoing_damage = self:GetLevelSpecialValueFor("illusion_outgoing_damage", ability_level)
	local max_creep_affect = self:GetSpecialValueFor("max_creep_affect")
	self.creep_affect_counter = 0

	local enemies = FindUnitsInRadius(caster:GetTeam(), target_loc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do

		if enemy and not enemy:IsNull() and enemy:IsAlive() then
			
			local modifier_apply_flag = false		-- checks if particles and slow modifier should be applied to this enemy
			-- reflect the hero
			-- always spawn hero illusions
			if enemy:IsRealHero() then
				local reflection_loc = enemy:GetAbsOrigin() + RandomVector(200)
				local illusions = CreateIllusions(caster, enemy, {}, 1, enemy:GetHullRadius(), false, true)
				local reflection = illusions[1]
				reflection:AddNewModifier( caster, self, "modifier_terrorblade_reflection_invulnerability", { duration = illusion_duration } )
				FindClearSpaceForUnit(reflection, reflection_loc, true)
				reflection:AddNewModifier( caster, self, "modifier_illusion", { duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = 0 } )
				reflection:SetForceAttackTarget(enemy)
				modifier_apply_flag = true

			else	-- just damage over time the creeps for performance reasons
				-- max number of affected creeps
				if self.creep_affect_counter < max_creep_affect then
					enemy:AddNewModifier( caster, self, "modifier_terrorblade_reflection_creep_damage_lua", { duration = illusion_duration } )
					modifier_apply_flag = true
					self.creep_affect_counter = self.creep_affect_counter + 1
				end
			end

			if modifier_apply_flag then
				-- apply to both heroes and creeps
				enemy:AddNewModifier( caster, self, "modifier_terrorblade_reflection_slow", { duration = illusion_duration } )
	
				-- particles
				local particle_cast = "particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf"
				local particle_fx = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, caster )
				ParticleManager:SetParticleControl(particle_fx, 3, Vector(1,0,0))
				ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle_fx)
			end

		end
	end

	EmitSoundOn("Hero_Terrorblade.Reflection", caster)	

end

modifier_terrorblade_reflection_creep_damage_lua = class({})
function modifier_terrorblade_reflection_creep_damage_lua:IsHidden() return true end
function modifier_terrorblade_reflection_creep_damage_lua:IsDebuff() return true end
function modifier_terrorblade_reflection_creep_damage_lua:IsPurgable() return false end
function modifier_terrorblade_reflection_creep_damage_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

if not IsServer() then return end

function modifier_terrorblade_reflection_creep_damage_lua:OnCreated(keys)
	local parent = self:GetParent()
	local bat = parent:GetBaseAttackTime()
	bat = math.max(bat,0.28)
	self:StartIntervalThink(bat)
end

function modifier_terrorblade_reflection_creep_damage_lua:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	local ability_level = ability:GetLevel() - 1
	local illusion_outgoing_tooltip = ability:GetLevelSpecialValueFor("illusion_outgoing_tooltip", ability_level)
	local base_damage_min = parent:GetBaseDamageMin()
	local base_damage_max = parent:GetBaseDamageMax()
	local average_damage = ( base_damage_min + base_damage_max ) / 2
	ApplyDamage({
		attacker = caster, 
		victim = parent, 
		damage_type = DAMAGE_TYPE_PHYSICAL, 
		damage = average_damage * illusion_outgoing_tooltip / 100, 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	})
end