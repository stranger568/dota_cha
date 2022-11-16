item_wraith_dominator = class({})

LinkLuaModifier("modifier_item_wraith_dominator", "items/item_wraith_dominator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wraith_dominator_aura_buff", "items/item_wraith_dominator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wraith_dominator_active", "items/item_wraith_dominator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wraith_dominator_active_debuff", "items/item_wraith_dominator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summoner_crown_buff_agi", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summoner_crown_buff_int", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summoner_crown_model_size", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)

function item_wraith_dominator:GetIntrinsicModifierName()
	return "modifier_item_wraith_dominator"
end

function item_wraith_dominator:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():EmitSound("Item.WraithTotem.Cast")
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_wraith_dominator_active", {duration = duration})
end

modifier_item_wraith_dominator = class({})

function modifier_item_wraith_dominator:IsDebuff() return false end
function modifier_item_wraith_dominator:IsHidden() return true end
function modifier_item_wraith_dominator:IsPurgable() return false end
function modifier_item_wraith_dominator:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_wraith_dominator:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

function modifier_item_wraith_dominator:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_wraith_dominator:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_wraith_dominator:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_wraith_dominator:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_wraith_dominator:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_wraith_dominator:IsAura()
	return true
end

function modifier_item_wraith_dominator:GetModifierAura()
	return "modifier_item_wraith_dominator_aura_buff"
end

function modifier_item_wraith_dominator:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_wraith_dominator:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_wraith_dominator:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_wraith_dominator:GetAuraDuration()
	return 0.5
end

function modifier_item_wraith_dominator:GetAuraEntityReject(target)
    if target:HasModifier("modifier_item_vladmir_aura") then
        return true
    else
        return false
    end
end

modifier_item_wraith_dominator_aura_buff = class({})

function modifier_item_wraith_dominator_aura_buff:IsPurgable() return false end

function modifier_item_wraith_dominator_aura_buff:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
	self.current_attack = 0

	if not IsServer() then return end
	self.ranged = self:GetParent():IsRangedAttacker()
end

function modifier_item_wraith_dominator_aura_buff:OnRefresh()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")

	if not IsServer() then return end
	self.ranged = self:GetParent():IsRangedAttacker()
end

function modifier_item_wraith_dominator_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
		--MODIFIER_EVENT_ON_ATTACK_LANDED, 
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_item_wraith_dominator_aura_buff:GetModifierConstantManaRegen()
	return self.mana_regen_aura
end

function modifier_item_wraith_dominator_aura_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_aura
end

function modifier_item_wraith_dominator_aura_buff:GetModifierPhysicalArmorBonus()
	return self.armor_aura
end

function modifier_item_wraith_dominator_aura_buff:AttackLandedModifier(params)
	if IsServer() then
		local no_heal_target = {
			["npc_dota_phoenix_sun"] = true,
			["npc_dota_grimstroke_ink_creature"] = true,
			["npc_dota_juggernaut_healing_ward"] = true,
			["npc_dota_healing_campfire"] = true,
			["npc_dota_pugna_nether_ward_1"] = true,
			["npc_dota_item_wraith_pact_totem"] = true,
			["npc_dota_pugna_nether_ward_2"] = true,
			["npc_dota_pugna_nether_ward_3"] = true,
			["npc_dota_pugna_nether_ward_4"] = true,
			["npc_dota_templar_assassin_psionic_trap"] = true,
			["npc_dota_weaver_swarm"] = true,
			["npc_dota_venomancer_plague_ward_1"] = true,
			["npc_dota_venomancer_plague_ward_2"] = true,
			["npc_dota_venomancer_plague_ward_3"] = true,
			["npc_dota_venomancer_plague_ward_4"] = true,
			["npc_dota_shadow_shaman_ward_1"] = true,
			["npc_dota_shadow_shaman_ward_2"] = true,
			["npc_dota_shadow_shaman_ward_3"] = true,
			["npc_dota_unit_tombstone1"] = true,
			["npc_dota_unit_tombstone2"] = true,
			["npc_dota_unit_tombstone3"] = true,
			["npc_dota_unit_tombstone4"] = true,
			["npc_dota_unit_undying_zombie"] = true,
			["npc_dota_unit_undying_zombie_torso"] = true,
			["npc_dota_clinkz_skeleton_archer"] = true,
			["npc_dota_techies_land_mine"] = true,
			["npc_dota_zeus_cloud"] = true,
			["npc_dota_rattletrap_cog"] = true,
		}
		if params.attacker == self:GetParent() then
			if params.damage <= 0 then return end
			if no_heal_target[params.target:GetUnitName()] then return end
			local lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal_aura") / 100
			self:GetParent():Heal(params.damage * lifesteal, nil)
		end
	end
end

function modifier_item_wraith_dominator_aura_buff:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end
	if self:GetParent():IsHero() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	if keys.target:IsBuilding() then return end
	if self:GetParent().anchor_attack_talent then return end
	if self:GetParent().bCanTriggerLock then print("СОРРИ ПАССИВКА ВОЙДА") return end

	if self.current_attack < self.attack_count then
		self.current_attack = self.current_attack + 1
		return
	end

	if self:GetParent():GetUnitName() == "npc_dota_creature_tombstone_zombie" then return end
	if self:GetParent():GetUnitName() == "npc_dota_creature_tombstone_zombie_torso" then return end
	if self:GetParent():GetUnitName() == "npc_dota_unit_undying_zombie" then return end
	if self:GetParent():GetUnitName() == "npc_dota_unit_undying_zombie_torso" then return end

	if self:GetParent():GetUnitName() == "npc_dota_shadow_shaman_ward_1" then return end
	if self:GetParent():GetUnitName() == "npc_dota_shadow_shaman_ward_2" then return end
	if self:GetParent():GetUnitName() == "npc_dota_shadow_shaman_ward_3" then return end

	self.current_attack = 0

	if self.ranged then
		local damage = keys.original_damage * self:GetAbility():GetSpecialValueFor("ranged_splash") * 0.01
		local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("ranged_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				ApplyDamage({ victim = enemy, attacker = keys.attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = self:GetAbility() })
			end
		end
	else
		local damage = keys.original_damage * self:GetAbility():GetSpecialValueFor("melee_splash") * 0.01
		DoCleaveAttack( keys.attacker, keys.target, self:GetAbility(), damage, self:GetAbility():GetSpecialValueFor("melee_radius"), self:GetAbility():GetSpecialValueFor("melee_radius"), self:GetAbility():GetSpecialValueFor("melee_radius"), "" )
	end
end

modifier_item_wraith_dominator_active = class({})

function modifier_item_wraith_dominator_active:IsPurgable() return false end

function modifier_item_wraith_dominator_active:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("pact_aura_radius")
	self.damage = self:GetAbility():GetSpecialValueFor("damage_penalty_aura")
	if not IsServer() then return end
	--local particle = ParticleManager:CreateParticle("particles/items5_fx/wraith_pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	--ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	--ParticleManager:SetParticleControl(particle, 1, Vector(self.radius,0,0))
	--self:AddParticle(particle, false, false, -1, false, false)
	self:StartIntervalThink(1)
end

function modifier_item_wraith_dominator_active:OnIntervalThink()
	if not IsServer() then return end

	local particle = ParticleManager:CreateParticle("particles/items5_fx/wraith_pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius,0,0))
	self:GetParent():EmitSound("Item.WraithTotem.Pulse")

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	for _, enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
end

function modifier_item_wraith_dominator_active:IsAura()
	return true
end

function modifier_item_wraith_dominator_active:GetModifierAura()
	return "modifier_item_wraith_dominator_active_debuff"
end

function modifier_item_wraith_dominator_active:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_wraith_dominator_active:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_wraith_dominator_active:GetAuraRadius()
	return self.radius
end

function modifier_item_wraith_dominator_active:GetAuraDuration()
	return 0.5
end

function modifier_item_wraith_dominator_active:GetAuraEntityReject(target)
    if target:HasModifier("modifier_item_wraith_pact_death_aura") then
        return true
    else
        return false
    end
end

modifier_item_wraith_dominator_active_debuff = class({})

function modifier_item_wraith_dominator_active_debuff:IsPurgable() return false end

function modifier_item_wraith_dominator_active_debuff:OnCreated()
	self.damage_reduce = self:GetAbility():GetSpecialValueFor("damage_penalty_aura")
end

function modifier_item_wraith_dominator_active_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_item_wraith_dominator_active_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage_reduce
end