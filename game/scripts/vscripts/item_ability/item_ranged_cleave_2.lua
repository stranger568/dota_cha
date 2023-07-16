LinkLuaModifier("modifier_item_ranged_cleave_2", "item_ability/item_ranged_cleave_2", LUA_MODIFIER_MOTION_NONE)

item_ranged_cleave_2 = class({})

function item_ranged_cleave_2:GetIntrinsicModifierName()
	return "modifier_item_ranged_cleave_2"
end

modifier_item_ranged_cleave_2 = class({})

function modifier_item_ranged_cleave_2:IsDebuff() return false end
function modifier_item_ranged_cleave_2:IsHidden() return true end
function modifier_item_ranged_cleave_2:IsPurgable() return false end
function modifier_item_ranged_cleave_2:IsPurgeException() return false end
function modifier_item_ranged_cleave_2:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_ranged_cleave_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
	return funcs
end

function modifier_item_ranged_cleave_2:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.cleave_radius = self.ability:GetSpecialValueFor("cleave_radius")
    self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
    self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self.ability:GetSpecialValueFor("bonus_dmg")
    self.bonus_range = self.ability:GetSpecialValueFor("bonus_range")
    self.cleave_dmg = self.ability:GetSpecialValueFor("cleave_dmg")
    if not IsServer() then return end
end

function modifier_item_ranged_cleave_2:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_item_ranged_cleave_2:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_item_ranged_cleave_2:GetModifierPreAttack_BonusDamage()
	return self.bonus_dmg
end

function modifier_item_ranged_cleave_2:GetModifierAttackRangeBonusUnique()
	if self.parent:IsRangedAttacker() then
		return self.bonus_range
	else
		return 0
	end
end

function modifier_item_ranged_cleave_2:AttackLandedModifier(keys)
	if not IsServer() then return end
	if not keys.attacker:IsRealHero() or not keys.attacker:IsRangedAttacker() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	if keys.target:IsBuilding() then return end
	if self.parent.anchor_attack_talent then return end
	if self.parent.bCanTriggerLock then return end
	if keys.no_attack_cooldown then return end
	if self.parent:HasModifier("modifier_muerta_pierce_the_veil_buff") then return end
	local frostivus2018_clinkz_searing_arrows = self.parent:FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if keys.no_attack_cooldown then
				return
			end
		end
	end
	local target_loc = keys.target:GetAbsOrigin()
	local fury_swipes_damage = 0
	if keys.attacker:HasAbility("ursa_fury_swipes") and keys.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
		local ursa_swipes = keys.attacker:FindAbilityByName("ursa_fury_swipes")
		if ursa_swipes and not ursa_swipes:IsNull() then
			local stacks = keys.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", keys.attacker)
			fury_swipes_damage = stacks * ursa_swipes:GetSpecialValueFor("damage_per_stack")
		end
	end
	local cleave_dmg = self.cleave_dmg
	if self.parent:HasModifier("modifier_skill_splash") then
		cleave_dmg = cleave_dmg + 30
	end
	local damage = (keys.original_damage + fury_swipes_damage) * cleave_dmg * 0.01
	local modifier_dragon_knight_elder_dragon_form_custom = self.parent:FindModifierByName("modifier_dragon_knight_elder_dragon_form_custom")
	if modifier_dragon_knight_elder_dragon_form_custom then
		damage = damage + (keys.damage * modifier_dragon_knight_elder_dragon_form_custom.splash_pct)
	end
	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), target_loc, nil, self.cleave_radius, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= keys.target then
			ApplyDamage({ victim = enemy, attacker = keys.attacker, damage = damage, damage_type = self.ability:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = self.ability })
		end
	end
end
