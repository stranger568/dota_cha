LinkLuaModifier("modiifer_bloodseeker_bloodrage_custom", "heroes/hero_bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_bloodrage_custom = class({})

function bloodseeker_bloodrage_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():EmitSound("hero_bloodseeker.bloodRage")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modiifer_bloodseeker_bloodrage_custom", {duration = duration})
end

modiifer_bloodseeker_bloodrage_custom = class({})

function modiifer_bloodseeker_bloodrage_custom:IsHidden()
	return false
end

function modiifer_bloodseeker_bloodrage_custom:IsDebuff()
	return self.debuff
end

function modiifer_bloodseeker_bloodrage_custom:IsPurgable()
	return false
end

function modiifer_bloodseeker_bloodrage_custom:OnCreated( kv )
	self.debuff = self:GetCaster()~=self:GetParent()
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
	self.shard_max_health_dmg_pct = self:GetAbility():GetSpecialValueFor("shard_max_health_dmg_pct")
	if not IsServer() then return end
	self:StartIntervalThink(0.5)
end

function modiifer_bloodseeker_bloodrage_custom:OnRefresh( kv )
	self.debuff = self:GetCaster()~=self:GetParent()
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
	self.shard_max_health_dmg_pct = self:GetAbility():GetSpecialValueFor("shard_max_health_dmg_pct")
	if not IsServer() then return end
	self:StartIntervalThink(0.5)
end

function modiifer_bloodseeker_bloodrage_custom:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsInvulnerable() then return end
	if self:GetParent():GetHealth() <= 1 then return end
	local self_damage = self:GetParent():GetMaxHealth() * 0.01
	local damage_table = {}
    damage_table.attacker = self:GetCaster()
    damage_table.victim = self:GetParent()
    damage_table.damage_type = DAMAGE_TYPE_MAGICAL
    damage_table.ability = self:GetAbility()
    damage_table.damage = self_damage
    damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL
    ApplyDamage(damage_table)
end

function modiifer_bloodseeker_bloodrage_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		--MODIFIER_EVENT_ON_TAKEDAMAGE,
		--MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modiifer_bloodseeker_bloodrage_custom:GetModifierSpellAmplify_Percentage(params)
	return self.spell_amp
end

function modiifer_bloodseeker_bloodrage_custom:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modiifer_bloodseeker_bloodrage_custom:TakeDamageScriptModifier( params )
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker ~= self:GetParent() then return end
	if not self:GetParent():HasShard() then return end
	if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "item_blade_mail" then return end
	if params.attacker:PassivesDisabled() then return end

	local abilitieslist = 
	{
		["item_ranged_cleave"] = true,
		["item_ranged_cleave_2"] = true,
		["item_ranged_cleave_3"] = true,
		["item_bfury"] = true,
		["sven_great_cleave"] = true,
		["tiny_tree_grab_lua"] = true,
		["luna_moon_glaive"] = true,
		["magnataur_empower_custom"] = true,
		["templar_assassin_psi_blades"] = true,
		["silencer_glaives_of_wisdom_custom"] = true,
		["frostivus2018_clinkz_searing_arrows"] = true,
		["item_bfury_2"] = true,
		["item_bfury_3"] = true,
	}

	if params.inflictor == nil or abilitieslist[params.inflictor:GetAbilityName()] then
		if params.original_damage <= 0 then return end

		local bonus_pure_damage = params.unit:GetMaxHealth() * 0.015

		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "luna_moon_glaive" then
			local percent_damage = params.original_damage / self:GetParent():GetAverageTrueAttackDamage(nil)
			percent_damage = math.min(percent_damage, 1)
			bonus_pure_damage = bonus_pure_damage * percent_damage
		end

		if self:GetParent().split_attack then
			bonus_pure_damage = bonus_pure_damage * 0.5
		end

		if params.inflictor ~= nil and ( params.inflictor:GetAbilityName() == "item_ranged_cleave" or params.inflictor:GetAbilityName() == "item_ranged_cleave_2" or params.inflictor:GetAbilityName() == "item_ranged_cleave_3" or params.inflictor:GetAbilityName() == "item_bfury" or params.inflictor:GetAbilityName() == "item_bfury_2" or params.inflictor:GetAbilityName() == "item_bfury_3" ) then
			bonus_pure_damage = bonus_pure_damage * 0.5
		end

		local damage_table = {}
	    damage_table.attacker = self:GetParent()
	    damage_table.victim = params.unit
	    damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	    damage_table.ability = self:GetAbility()
	    damage_table.damage = bonus_pure_damage
	    damage_table.damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
	    ApplyDamage(damage_table)
	end
end

function modiifer_bloodseeker_bloodrage_custom:AttackLandedModifier(params)
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
			if not self:GetParent():HasShard() then return end
			if no_heal_target[params.target:GetUnitName()] then return end
			if params.attacker:PassivesDisabled() then return end
			local bonus_pure_damage = params.target:GetMaxHealth() * 0.015
			SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), bonus_pure_damage, nil)
			self:GetParent():Heal(bonus_pure_damage, self:GetAbility())
		end
	end
end

function modiifer_bloodseeker_bloodrage_custom:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modiifer_bloodseeker_bloodrage_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--function modiifer_bloodseeker_bloodrage_custom:PlayEffects()
--	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
--	ParticleManager:ReleaseParticleIndex( effect_cast )
--end