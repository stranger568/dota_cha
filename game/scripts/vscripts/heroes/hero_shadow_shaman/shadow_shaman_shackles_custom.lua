LinkLuaModifier( "modifier_shadow_shaman_shackles_custom", "heroes/hero_shadow_shaman/shadow_shaman_shackles_custom", LUA_MODIFIER_MOTION_NONE )

shadow_shaman_shackles_custom = class({})

function shadow_shaman_shackles_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function shadow_shaman_shackles_custom:GetChannelTime()
	return self:GetSpecialValueFor("channel_time") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_2")
end

function shadow_shaman_shackles_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("channel_time") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_2")

	self.targets = {}
	
	if target ~= nil then
		if not target:TriggerSpellAbsorb(self) then
			target:AddNewModifier(self:GetCaster(), self, "modifier_shadow_shaman_shackles_custom", {duration = duration})
			table.insert(self.targets, target)
		end

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				table.insert(self.targets, enemy)
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_shadow_shaman_shackles_custom", {duration = duration})
			end
		end
	else
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			table.insert(self.targets, enemy)
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_shadow_shaman_shackles_custom", {duration = duration})
		end
	end

	self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")
end

function shadow_shaman_shackles_custom:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	if self.targets then
		for _, hero in pairs(self.targets) do
			if hero then
				hero:RemoveModifierByName("modifier_shadow_shaman_shackles_custom")
			end
		end
	end
	self.targets = nil
end

function shadow_shaman_shackles_custom:SummonWard(position, enemy)
	local shadow_shaman_mass_serpent_ward = self:GetCaster():FindAbilityByName("shadow_shaman_mass_serpent_ward")
	local duration = 7

	if shadow_shaman_mass_serpent_ward:GetLevel() > 0 then
	
		local ward = CreateUnitByName("npc_dota_shadow_shaman_ward_"..math.min(shadow_shaman_mass_serpent_ward:GetLevel(), 3), position, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		ward:SetForwardVector((enemy:GetAbsOrigin() - ward:GetAbsOrigin():Normalized()))
		ward:MoveToTargetToAttack(enemy)
		ward:AddNewModifier(self:GetCaster(), shadow_shaman_mass_serpent_ward, "modifier_shadow_shaman_serpent_ward", {duration = duration})
		ward:AddNewModifier(self:GetCaster(), shadow_shaman_mass_serpent_ward, "modifier_kill", {duration = duration})
		
		if self:GetCaster().GetPlayerID then
			ward:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		elseif self:GetCaster():GetOwner() and self:GetCaster():GetOwner().GetPlayerID then
			ward:SetControllableByPlayer(self:GetCaster():GetOwner():GetPlayerID(), true)
		end

		ward:SetBaseDamageMin(shadow_shaman_mass_serpent_ward:GetSpecialValueFor("damage_tooltip") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_4"))
		ward:SetBaseDamageMax(shadow_shaman_mass_serpent_ward:GetSpecialValueFor("damage_tooltip") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_4"))
	end
end

modifier_shadow_shaman_shackles_custom = class({})

function modifier_shadow_shaman_shackles_custom:IgnoreTenacity()		return true end
function modifier_shadow_shaman_shackles_custom:IsPurgable()			return false end
function modifier_shadow_shaman_shackles_custom:IsPurgeException()	return true end
function modifier_shadow_shaman_shackles_custom:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shadow_shaman_shackles_custom:OnCreated()
	if not IsServer() then return end
	local shackle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
	
	self.tick_interval			= self:GetAbility():GetSpecialValueFor("tick_interval")
	self.total_damage			= self:GetAbility():GetSpecialValueFor("total_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_6")
	self.channel_time			= self:GetAbility():GetSpecialValueFor("channel_time") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_2")
	self.damage_per_tick	= self.total_damage / (self.channel_time / self.tick_interval)
	self:StartIntervalThink(self.tick_interval * (1 - self:GetParent():GetStatusResistance()))


	if self:GetCaster():HasShard() then
		if self:GetCaster():HasAbility("shadow_shaman_mass_serpent_ward") then
			local shard_ward_duration = self:GetAbility():GetSpecialValueFor("shard_ward_duration")
			local shard_ward_spawn_distance = self:GetAbility():GetSpecialValueFor("shard_ward_spawn_distance")
			local shard_ward_count = self:GetAbility():GetSpecialValueFor("shard_ward_count")
			local formation_vectors = {}
			for i = 1, shard_ward_count do
				table.insert(formation_vectors, Vector(math.cos(math.rad(((360 / shard_ward_count) * i))), math.sin(math.rad(((360 / shard_ward_count) * i))), 0) * shard_ward_spawn_distance)
			end
			for i = 1, shard_ward_count do
				self:GetAbility():SummonWard(self:GetParent():GetAbsOrigin() + formation_vectors[i], self:GetParent())
			end
		end
	end
end

function modifier_shadow_shaman_shackles_custom:OnIntervalThink()
	if not IsServer() then return end
	
	if not self:GetAbility():IsChanneling() then
		self:Destroy()
	else
		self:GetCaster():Heal(self.damage_per_tick, self:GetAbility())
		ApplyDamage({ victim = self:GetParent(), damage = self.damage_per_tick, damage_type = self:GetAbility():GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self:GetAbility() })
	end
end

function modifier_shadow_shaman_shackles_custom:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_shadow_shaman_shackles_custom:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_shadow_shaman_shackles_custom:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_shadow_shaman_shackles_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_shaman_shackle.vpcf"
end

function modifier_shadow_shaman_shackles_custom:StatusEffectPriority()
	return 10
end