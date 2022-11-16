
item_ranged_cleave_3 = class({})

LinkLuaModifier("modifier_item_ranged_cleave_3", "item_ability/item_ranged_cleave_3", LUA_MODIFIER_MOTION_NONE)


function item_ranged_cleave_3:GetIntrinsicModifierName()
	return "modifier_item_ranged_cleave_3"
end



modifier_item_ranged_cleave_3 = class({})

function modifier_item_ranged_cleave_3:IsDebuff() return false end
function modifier_item_ranged_cleave_3:IsHidden() return true end
function modifier_item_ranged_cleave_3:IsPurgable() return false end
function modifier_item_ranged_cleave_3:IsPurgeException() return false end
function modifier_item_ranged_cleave_3:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_ranged_cleave_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_ranged_cleave_3:OnCreated()

	local ability = self:GetAbility()
	self.cleave_dmg = ability:GetSpecialValueFor("cleave_dmg")
	self.cleave_radius = ability:GetSpecialValueFor("cleave_radius")
	
end


function modifier_item_ranged_cleave_3:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_ranged_cleave_3:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_ranged_cleave_3:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_ranged_cleave_3:GetModifierAttackRangeBonusUnique()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("bonus_range")
	end
end

function modifier_item_ranged_cleave_3:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("attack_speed")
	end
end

if not IsServer() then return end

function modifier_item_ranged_cleave_3:GetModifierProcAttack_Feedback(keys)
	if not keys.attacker:IsRealHero() or not keys.attacker:IsRangedAttacker() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	if keys.target:IsBuilding() then return end
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
	
	local ability = self:GetAbility()
	local target_loc = keys.target:GetAbsOrigin()
	local fury_swipes_damage = 0
	
	if keys.attacker:HasAbility("ursa_fury_swipes") and keys.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
		local ursa_swipes = keys.attacker:FindAbilityByName("ursa_fury_swipes")
		if ursa_swipes and not ursa_swipes:IsNull() then
			local stacks = keys.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", keys.attacker)
			fury_swipes_damage = stacks * ursa_swipes:GetSpecialValueFor("damage_per_stack")
		end
	end
	
	if not keys.no_attack_cooldown then
		Timers:CreateTimer(0.06, function()
			local blast_pfx = ParticleManager:CreateParticle("particles/custom/shrapnel_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(blast_pfx, 0, target_loc)
			ParticleManager:ReleaseParticleIndex(blast_pfx)
		end)
		local blast_pfx = ParticleManager:CreateParticle("particles/weapon_3.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, target_loc)
		ParticleManager:ReleaseParticleIndex(blast_pfx)
	end



	local percentage_damage = keys.target:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("damage_percent") / 100)

	if self:GetParent().split_attack then
		percentage_damage = percentage_damage * 0.5
	end

	local splash_damage = keys.original_damage + fury_swipes_damage

	if self:GetParent():FindAllModifiersByName("modifier_item_ranged_cleave_3")[1] == self and not keys.target:IsHero() and not keys.target:IsAncient() and not self:GetParent():PassivesDisabled() then
		ApplyDamage({ victim = keys.target, attacker = keys.attacker, damage = percentage_damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = ability })
	end

	if not self:GetParent():PassivesDisabled() then
		if self:GetParent():FindAllModifiersByName("modifier_item_ranged_cleave_3")[1] == self then
			splash_damage = splash_damage + percentage_damage
		end
	end

	splash_damage = splash_damage * self.cleave_dmg * 0.01

	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), target_loc, nil, self.cleave_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= keys.target then
			ApplyDamage({
				victim 			= enemy,
				attacker 		= keys.attacker,
				damage 			= splash_damage,
				damage_type 	= ability:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability 		= ability,
			})
		end
	end
end