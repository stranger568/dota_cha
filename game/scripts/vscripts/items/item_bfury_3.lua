LinkLuaModifier("modifier_item_bfury_3", "items/item_bfury_3", LUA_MODIFIER_MOTION_NONE)

item_bfury_3				= class({})

modifier_item_bfury_3	= class({})

function item_bfury_3:CastFilterResultTarget(hTarget)
	if not IsServer() then return end
	if hTarget:IsOther() then
		if hTarget:GetName() == "npc_dota_ward_base" or hTarget:GetName() == "npc_dota_ward_base_truesight" then
			return UF_SUCCESS
		end
	end
	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if (hTarget:IsCreep() or (hTarget:IsOther() and (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")))) and
		not hTarget:IsRoshan() then
			return UF_SUCCESS
		elseif hTarget:IsOther() and not (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")) then
			return UF_FAIL_CUSTOM
		end
	end
	local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	return nResult
end

function item_bfury_3:GetCustomCastErrorTarget(hTarget)
	if not IsServer() then return end
	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
		if hTarget:IsOther() and not (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")) then
			return "Ability Can't Target This Ward-Type Unit"
		end
	end
end

function item_bfury_3:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end

function item_bfury_3:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level)
end

function item_bfury_3:GetIntrinsicModifierName()
	return "modifier_item_bfury_3"
end

function item_bfury_3:OnSpellStart()
	if not IsServer() then return end
	local target = self:GetCursorTarget()

	if self:GetCursorTarget().CutDown then
		self:GetCursorTarget():CutDown(self:GetCaster():GetTeamNumber())
	end

	GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), 10, true)
end

function modifier_item_bfury_3:AllowIllusionDuplicate()	return false end
function modifier_item_bfury_3:IsPurgable()		return false end
function modifier_item_bfury_3:RemoveOnDeath()	return false end
function modifier_item_bfury_3:IsHidden()	return true end
function modifier_item_bfury_3:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_bfury_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_item_bfury_3:GetModifierPreAttack_BonusDamage(keys)
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_bfury_3:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end
end

function modifier_item_bfury_3:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_item_bfury_3:GetModifierAttackRangeBonus()
	if self:GetAbility() then
		if self:GetParent():IsRangedAttacker() then return 0 end
		return self:GetAbility():GetSpecialValueFor("attack_range")
	end
end

function modifier_item_bfury_3:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("attack_speed")
	end
end

function modifier_item_bfury_3:GetModifierProcAttack_BonusDamage_Physical( keys )
	if not IsServer() then return end
	if (self:GetParent():FindAllModifiersByName("modifier_item_bfury_3")[1] == self) and keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and not string.find(keys.target:GetUnitName(), "npc_dota_lone_druid_bear") and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor("quelling_bonus")
		else
			return self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
		end
	end
end

function modifier_item_bfury_3:GetModifierProcAttack_Feedback(keys)
	if keys.attacker:IsIllusion() then return end
	if keys.attacker:IsRangedAttacker() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	if keys.target:IsBuilding() then return end
	if self:GetParent().anchor_attack_talent then print("?????????? ???????????????? ??????????") return end
	if self:GetParent().bCanTriggerLock then print("?????????? ???????????????? ??????????") return end

	local frostivus2018_clinkz_searing_arrows = self:GetParent():FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		print("???????????? ????????????", frostivus2018_clinkz_searing_arrows:GetAutoCastState())
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if keys.no_attack_cooldown then
				print("???????????? ??????????????")
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

	if not keys.no_attack_cooldown and self:GetParent():FindAllModifiersByName("modifier_item_bfury_3")[1] == self then
		Timers:CreateTimer(0.06, function()
			local blast_pfx = ParticleManager:CreateParticle("particles/bfury_2_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(blast_pfx, 0, target_loc)
			ParticleManager:ReleaseParticleIndex(blast_pfx)
		end)
		local blast_pfx = ParticleManager:CreateParticle("particles/bfury_3_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, target_loc)
		ParticleManager:ReleaseParticleIndex(blast_pfx)
	end

	local percentage_damage = keys.target:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("damage_percent") / 100)

	if self:GetParent().split_attack then
		percentage_damage = percentage_damage * 0.5
	end

	local splash_damage = keys.original_damage + fury_swipes_damage

	if self:GetParent():FindAllModifiersByName("modifier_item_bfury_3")[1] == self and not keys.target:IsHero() and not keys.target:IsAncient() and not self:GetParent():PassivesDisabled() then
		ApplyDamage({ victim = keys.target, attacker = keys.attacker, damage = percentage_damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = ability })
	end

	if not self:GetParent():PassivesDisabled() then
		if self:GetParent():FindAllModifiersByName("modifier_item_bfury_3")[1] == self then
			splash_damage = splash_damage + percentage_damage
		end
	end

	if keys.target:IsHero() then
		splash_damage = splash_damage * (self:GetAbility():GetSpecialValueFor("cleave_damage_percent") / 100)
	else
		splash_damage = splash_damage * (self:GetAbility():GetSpecialValueFor("cleave_damage_percent_creep") / 100)
	end

	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), target_loc, nil, self:GetAbility():GetSpecialValueFor("cleave_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= keys.target then
			ApplyDamage({ victim = enemy, attacker = keys.attacker, damage = splash_damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = ability })
		end
	end
end



