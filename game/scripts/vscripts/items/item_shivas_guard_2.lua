LinkLuaModifier("modifier_item_shivas_guard_2", "items/item_shivas_guard_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_guard_2_aura", "items/item_shivas_guard_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_guard_2_debuff", "items/item_shivas_guard_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_guard_2_discord_debuff", "items/item_shivas_guard_2", LUA_MODIFIER_MOTION_NONE)

item_shivas_guard_2 = class({})

function item_shivas_guard_2:GetIntrinsicModifierName()
	return "modifier_item_shivas_guard_2"
end

function item_shivas_guard_2:OnSpellStart()
	if not IsServer() then return end

	local blast_radius = self:GetSpecialValueFor("blast_radius")
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local blast_duration = blast_radius / blast_speed
	local current_loc = self:GetCaster():GetAbsOrigin()

	self:GetCaster():EmitSound("DOTA_Item.ShivasGuard.Activate")

	local blast_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(blast_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(blast_pfx)

	local targets_hit = {}
	local current_radius = 0
	local tick_interval = 0.1

	Timers:CreateTimer(tick_interval, function()
		AddFOWViewer(self:GetCaster():GetTeamNumber(), current_loc, current_radius, 0.1, false)
		current_radius = current_radius + blast_speed * tick_interval
		current_loc = self:GetCaster():GetAbsOrigin()
		local nearby_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do

			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			if not enemy_has_been_hit then
				Quests_arena:QuestProgress(self:GetCaster():GetPlayerOwnerID(), 30, 1)
				Quests_arena:QuestProgress(self:GetCaster():GetPlayerOwnerID(), 72, 2)
				local hit_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)
				--enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_shivas_guard_2_discord_debuff", {duration = self:GetSpecialValueFor("discord_duration")})
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_shivas_guard_2_debuff", {duration = self:GetSpecialValueFor("blast_debuff_duration")})
				local damage = self:GetSpecialValueFor("blast_damage")
				ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				targets_hit[#targets_hit + 1] = enemy
			end
		end
		if current_radius < blast_radius then
			return tick_interval
		end
	end)
end

modifier_item_shivas_guard_2 = class({})

function modifier_item_shivas_guard_2:IsHidden() return true end
function modifier_item_shivas_guard_2:IsPurgable() return false end
function modifier_item_shivas_guard_2:RemoveOnDeath() return false end

function modifier_item_shivas_guard_2:OnCreated()
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_shivas_guard_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_item_shivas_guard_2:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_shivas_guard_2:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_shivas_guard_2:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_attribute_agi")
end

function modifier_item_shivas_guard_2:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_attribute_str")
end

function modifier_item_shivas_guard_2:GetModifierPercentageCooldown()
	if self:GetParent():HasItemInInventory("item_octarine_core") then return 0 end
	return self:GetAbility():GetSpecialValueFor("bonus_cooldown")
end

function modifier_item_shivas_guard_2:GetModifierCastRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_castrange")
end

function modifier_item_shivas_guard_2:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_shivas_guard_2:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_shivas_guard_2:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_manaregen")
end

function modifier_item_shivas_guard_2:GetEffectName()
	return "particles/items_fx/aura_shivas.vpcf"
end

function modifier_item_shivas_guard_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_shivas_guard_2:IsAura() return true end
function modifier_item_shivas_guard_2:IsAuraActiveOnDeath()	return false end

function modifier_item_shivas_guard_2:GetAuraRadius() return self.aura_radius end
function modifier_item_shivas_guard_2:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_item_shivas_guard_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_shivas_guard_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_shivas_guard_2:GetModifierAura()	return "modifier_item_shivas_guard_2_aura" end
function modifier_item_shivas_guard_2:GetAuraEntityReject(target)
	if target:HasModifier("modifier_item_shivas_guard_aura") then
		return true
	end
	return false
end


modifier_item_shivas_guard_2_aura = class({})

function modifier_item_shivas_guard_2_aura:IsHidden() return false end

function modifier_item_shivas_guard_2_aura:OnCreated()
	self.aura_attack_speed = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.hp_regen_degen_aura = self:GetAbility():GetSpecialValueFor("hp_regen_degen_aura")
end

function modifier_item_shivas_guard_2_aura:DeclareFunctions()
return  {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
			MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        }
end

function modifier_item_shivas_guard_2_aura:GetModifierAttackSpeedBonus_Constant()
    return self.aura_attack_speed
end

function modifier_item_shivas_guard_2_aura:GetModifierLifestealRegenAmplify_Percentage()
	return self.hp_regen_degen_aura
end

function modifier_item_shivas_guard_2_aura:GetModifierHealAmplify_PercentageTarget()
	return self.hp_regen_degen_aura
end

function modifier_item_shivas_guard_2_aura:GetModifierHPRegenAmplify_Percentage()
	return self.hp_regen_degen_aura
end

modifier_item_shivas_guard_2_discord_debuff = class({})

function modifier_item_shivas_guard_2_discord_debuff:IsPurgable() return false end

function modifier_item_shivas_guard_2_discord_debuff:DeclareFunctions()
	return 
	{ 
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, 
	} 
end

function modifier_item_shivas_guard_2_discord_debuff:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_item_shivas_guard_2_discord_debuff:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_item_veil_of_discord_debuff") then
		self:GetParent():RemoveModifierByName("modifier_item_veil_of_discord_debuff")
	end
end

function modifier_item_shivas_guard_2_discord_debuff:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return self:GetAbility():GetSpecialValueFor("discord_effect")
	end
end

modifier_item_shivas_guard_2_debuff = class({})

function modifier_item_shivas_guard_2_debuff:OnCreated()
	if not IsServer() then return end
	self.damage = self:GetAbility():GetSpecialValueFor("persentage_damage")
	self:StartIntervalThink(1)
end

function modifier_item_shivas_guard_2_debuff:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetParent():IsAncient() then
		--local damage = self:GetParent():GetHealth() / 100 * self.damage
		--ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		if self:GetParent():HasModifier("modifier_item_shivas_guard_blast") then
			self:GetParent():RemoveModifierByName("modifier_item_shivas_guard_blast")
		end
	end
end

function modifier_item_shivas_guard_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_item_shivas_guard_2_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("blast_movement_speed")
end