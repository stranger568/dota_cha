LinkLuaModifier("modifier_item_bfury_2", "items/item_bfury_2", LUA_MODIFIER_MOTION_NONE)

item_bfury_2 = class({})
modifier_item_bfury_2 = class({})

function item_bfury_2:CastFilterResultTarget(hTarget)
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

function item_bfury_2:GetCustomCastErrorTarget(hTarget)
	if not IsServer() then return end
	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
		if hTarget:IsOther() and not (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")) then
			return "Ability Can't Target This Ward-Type Unit"
		end
	end
end

function item_bfury_2:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end

function item_bfury_2:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level)
end

function item_bfury_2:GetIntrinsicModifierName()
	return "modifier_item_bfury_2"
end

function item_bfury_2:OnSpellStart()
	if not IsServer() then return end
	if self:GetCursorTarget().CutDown then
		self:GetCursorTarget():CutDown(self:GetCaster():GetTeamNumber())
	end
	GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), 10, true)
end

function modifier_item_bfury_2:AllowIllusionDuplicate()	return false end
function modifier_item_bfury_2:IsPurgable()	return false end
function modifier_item_bfury_2:RemoveOnDeath() return false end
function modifier_item_bfury_2:IsHidden() return true end
function modifier_item_bfury_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_bfury_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end

function modifier_item_bfury_2:GetModifierPreAttack_BonusDamage(keys)
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_bfury_2:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end
end

function modifier_item_bfury_2:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_item_bfury_2:GetModifierAttackRangeBonus()
	if self:GetAbility() then
		if self:GetParent():IsRangedAttacker() then return 0 end
		return self:GetAbility():GetSpecialValueFor("attack_range")
	end
end

function modifier_item_bfury_2:GetModifierProcAttack_BonusDamage_Physical( keys )
	if not IsServer() then return end
	if (self:GetParent():FindAllModifiersByName("modifier_item_bfury_2")[1] == self) and keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and not string.find(keys.target:GetUnitName(), "npc_dota_lone_druid_bear") and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor("quelling_bonus")
		else
			return self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
		end
	end
end

function modifier_item_bfury_2:AttackLandedModifier(keys)
	if not IsServer() then return end
	if keys.attacker:IsIllusion() then return end
	if keys.attacker:IsRangedAttacker() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	if keys.target:IsBuilding() then return end
	if self:GetParent().anchor_attack_talent then return end
	if self:GetParent().bCanTriggerLock then return end
	if keys.no_attack_cooldown then return end
	if self:GetParent():HasModifier("modifier_muerta_pierce_the_veil_buff") then return end
	if self:GetParent():IsTempestDouble() or self:GetParent():HasModifier("modifier_arc_warden_tempest_double_lua") then return end

	local frostivus2018_clinkz_searing_arrows = self:GetParent():FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if keys.no_attack_cooldown then
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

	local damage = keys.original_damage + fury_swipes_damage

	local cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	local cleave_damage_percent_creep = self:GetAbility():GetSpecialValueFor("cleave_damage_percent_creep")
	if self:GetParent():HasModifier("modifier_skill_splash") then
		cleave_damage_percent = cleave_damage_percent + 40
		cleave_damage_percent_creep = cleave_damage_percent_creep + 40
	end

	if keys.target:IsHero() then
		damage = damage * (cleave_damage_percent / 100)
	else
		damage = damage * (cleave_damage_percent_creep / 100)
	end

	local modifier_dragon_knight_elder_dragon_form_custom = self:GetParent():FindModifierByName("modifier_dragon_knight_elder_dragon_form_custom")
	if modifier_dragon_knight_elder_dragon_form_custom then
		damage = damage + (keys.damage * modifier_dragon_knight_elder_dragon_form_custom.splash_pct)
	end

	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), target_loc, nil, self:GetAbility():GetSpecialValueFor("cleave_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= keys.target then
			ApplyDamage({ victim = enemy, attacker = keys.attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = ability })
			if modifier_dragon_knight_elder_dragon_form_custom then
				modifier_dragon_knight_elder_dragon_form_custom:Corrosive( enemy )
			end
		end
	end
end



