LinkLuaModifier("modifier_meepo_ransack_custom", "heroes/hero_meepo/meepo_ransack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meepo_ransack_custom_debuff", "heroes/hero_meepo/meepo_ransack", LUA_MODIFIER_MOTION_NONE)

meepo_ransack_custom = class({})

function meepo_ransack_custom:GetIntrinsicModifierName()
	return "modifier_meepo_ransack_custom"
end

modifier_meepo_ransack_custom = class({})

function modifier_meepo_ransack_custom:IsHidden() return true end

function modifier_meepo_ransack_custom:DeclareFunctions()
	return {
		--MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_meepo_ransack_custom:TakeDamageScriptModifier( params )
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.attacker:PassivesDisabled() then return end
	if params.attacker:IsIllusion() then return end

	local abilitieslist = {
		["item_ranged_cleave"] = true,
		["item_ranged_cleave_2"] = true,
		["item_ranged_cleave_3"] = true,
		["item_bfury"] = true,
		["sven_great_cleave"] = true,
		["tiny_tree_grab_lua"] = true,
		["luna_moon_glaive"] = true,
		["luna_moon_glaive"] = true,
		["luna_moon_glaive"] = true,
		["magnataur_empower_custom"] = true,
		["templar_assassin_psi_blades"] = true,
		["silencer_glaives_of_wisdom_custom"] = true,
		["frostivus2018_clinkz_searing_arrows"] = true,
		["void_spirit_astral_step"] = true,
		["item_bfury_2"] = true,
		["item_bfury_3"] = true,
	}

	if params.inflictor == nil or abilitieslist[params.inflictor:GetAbilityName()] then
		if params.original_damage <= 0 then return end

		local physical_damage_bonus = self:GetAbility():GetSpecialValueFor("damage_physical") / 100
		local bonus_damage = params.unit:GetMaxHealth() * physical_damage_bonus
		local duration = self:GetAbility():GetSpecialValueFor("duration_debuff")

		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "luna_moon_glaive" then
			local percent_damage = params.original_damage / self:GetParent():GetAverageTrueAttackDamage(nil)
			percent_damage = math.min(percent_damage, 1)
			bonus_damage = bonus_damage * percent_damage
		end

		if self:GetParent().split_attack then
			bonus_damage = bonus_damage * 0.5
		end

		if params.inflictor ~= nil and (params.inflictor:GetAbilityName() == "item_ranged_cleave" or params.inflictor:GetAbilityName() == "item_ranged_cleave_2" or params.inflictor:GetAbilityName() == "item_ranged_cleave_3" or params.inflictor:GetAbilityName() == "item_bfury" or params.inflictor:GetAbilityName() == "item_bfury_2" or params.inflictor:GetAbilityName() == "item_bfury_3") then
			bonus_damage = bonus_damage * 0.5
		end

		local damage_table = {}
	    damage_table.attacker = self:GetParent()
	    damage_table.victim = params.unit
	    damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	    damage_table.ability = self:GetAbility()
	    damage_table.damage = bonus_damage
	    damage_table.damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS

	    local heal = ApplyDamage(damage_table)
	    
	    if params.inflictor == nil and params.unit:IsHero() then
	    	self:GetParent():Heal(heal, self:GetAbility())
	    	params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_meepo_ransack_custom_debuff", {duration = duration})
	    end
	end
end

modifier_meepo_ransack_custom_debuff = class({})

function modifier_meepo_ransack_custom_debuff:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
	self.minus_regen = self:GetAbility():GetSpecialValueFor("minus_regen")
end

function modifier_meepo_ransack_custom_debuff:OnRefresh()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
	self.minus_regen = self:GetAbility():GetSpecialValueFor("minus_regen")
end

function modifier_meepo_ransack_custom_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE

	}
end

function modifier_meepo_ransack_custom_debuff:GetModifierLifestealRegenAmplify_Percentage()
	return self.minus_regen
end

function modifier_meepo_ransack_custom_debuff:GetModifierHealAmplify_PercentageTarget()
	return self.minus_regen
end

function modifier_meepo_ransack_custom_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.minus_regen
end

function modifier_meepo_ransack_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end