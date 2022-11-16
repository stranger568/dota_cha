LinkLuaModifier("modifier_item_hellmask", "items/item_hellmask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hellmask_aura_buff", "items/item_hellmask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hellmask_aura_debuff", "items/item_hellmask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hellmask_buff", "items/item_hellmask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hellmask_debuff", "items/item_hellmask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hellmask_active", "items/item_hellmask", LUA_MODIFIER_MOTION_NONE)

item_hellmask = class({})

function item_hellmask:OnSpellStart()
	if not IsServer() then return end
	local duration_satanic = self:GetSpecialValueFor("unholy_duration")
	self:GetCaster():Purge(false, true, false, false, false)
	self:GetCaster():EmitSound("DOTA_Item.Satanic.Activate")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hellmask_active", {duration = duration_satanic})
end

function item_hellmask:GetIntrinsicModifierName() return "modifier_item_hellmask" end

modifier_item_hellmask_active = class({})

function modifier_item_hellmask_active:IsPurgable() return false end

function modifier_item_hellmask_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_item_hellmask_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_item_hellmask = class({})

function modifier_item_hellmask:IsPurgable() return false end
function modifier_item_hellmask:IsHidden() return self:GetAbility():GetSecondaryCharges() == 1 end

function modifier_item_hellmask:OnCreated()
	if not IsServer() then return end
	if not self:GetCaster():HasModifier("modifier_item_cuirass_2_aura_buff") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hellmask_aura_buff", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hellmask_aura_debuff", {})
	end
	self:StartIntervalThink(FrameTime())
end

function modifier_item_hellmask:OnDestroy()
	if not IsServer() then return end
	if not self:GetCaster():HasModifier("modifier_item_hellmask") then
		self:GetCaster():RemoveModifierByName("modifier_item_hellmask_aura_buff")
		self:GetCaster():RemoveModifierByName("modifier_item_hellmask_aura_debuff")
	end
end

function modifier_item_hellmask:OnIntervalThink()
	if not IsServer() then return end
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	if #units>0 and not self:GetParent():HasModifier("modifier_hero_refreshing") then
		self:GetAbility():SetSecondaryCharges(1)
	else
		self:GetAbility():SetSecondaryCharges(0)
	end
	self:SetStackCount(self:GetAbility():GetCurrentCharges() * self:GetAbility():GetSpecialValueFor("bonus_armor_per_stack"))
end

function modifier_item_hellmask:DeclareFunctions()
    return {
        --MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        --MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hellmask:OnTooltip()
	return self:GetAbility():GetCurrentCharges() * self:GetAbility():GetSpecialValueFor("bonus_armor_per_stack")
end

function modifier_item_hellmask:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_item_hellmask:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_hellmask:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		local bonus_unique = self:GetAbility():GetCurrentCharges() * self:GetAbility():GetSpecialValueFor("bonus_armor_per_stack")
		if self:GetAbility():GetSecondaryCharges() == 1 then bonus_unique = 0 end
		return self:GetAbility():GetSpecialValueFor("bonus_armor") + bonus_unique
	end
end

function modifier_item_hellmask:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_item_hellmask:AttackLandedModifier(params)
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
			if params.target:IsWard() or params.target:IsHeroWard() then return end
			local lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal_percent") / 100
			if self:GetParent():HasModifier("modifier_item_hellmask_active") then
				lifesteal = self:GetAbility():GetSpecialValueFor("unholy_lifesteal_total_tooltip") / 100
			end
			self:GetParent():Heal(params.original_damage * lifesteal, nil)
		end
	end
end

function modifier_item_hellmask:OnDeathEvent(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then return end
	if params.unit:IsHero() then return end
	if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
	if params.unit:IsOther() then return end
	if (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 1500 then return end
	self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
	if params.attacker:IsTempestDouble() then
		local owner = params.attacker.owner
		if owner then
			local mod = owner:FindModifierByName("modifier_item_hellmask")
			if mod then
				mod:GetAbility():SetCurrentCharges(mod:GetAbility():GetCurrentCharges() + 1)
			end
		end
	end
end

modifier_item_hellmask_aura_buff = class({})

function modifier_item_hellmask_aura_buff:IsDebuff() return false end
function modifier_item_hellmask_aura_buff:AllowIllusionDuplicate() return true end
function modifier_item_hellmask_aura_buff:IsHidden() return true end
function modifier_item_hellmask_aura_buff:IsPurgable() return false end

function modifier_item_hellmask_aura_buff:GetAuraRadius()
	return 1200
end

function modifier_item_hellmask_aura_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_hellmask_aura_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_hellmask_aura_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_hellmask_aura_buff:GetModifierAura()
	return "modifier_item_hellmask_buff"
end

function modifier_item_hellmask_aura_buff:IsAura()
	return true
end

modifier_item_hellmask_buff = class({})

function modifier_item_hellmask_buff:GetTexture()
  	return "item_hellmask"
end

function modifier_item_hellmask_buff:OnCreated()
	self.aura_as_ally = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.aura_armor_ally = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
end

function modifier_item_hellmask_buff:IsHidden() return false end
function modifier_item_hellmask_buff:IsPurgable() return false end
function modifier_item_hellmask_buff:IsDebuff() return false end

function modifier_item_hellmask_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_hellmask_buff:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end

function modifier_item_hellmask_buff:GetModifierPhysicalArmorBonus()
	return self.aura_armor_ally
end

function modifier_item_hellmask_buff:GetEffectName()
	return "particles/items_fx/aura_assault.vpcf"
end

function modifier_item_hellmask_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_item_hellmask_aura_debuff = class({})

function modifier_item_hellmask_aura_debuff:IsDebuff() return false end
function modifier_item_hellmask_aura_debuff:AllowIllusionDuplicate() return true end
function modifier_item_hellmask_aura_debuff:IsHidden() return true end
function modifier_item_hellmask_aura_debuff:IsPurgable() return false end

function modifier_item_hellmask_aura_debuff:GetAuraRadius()
	return 1200
end

function modifier_item_hellmask_aura_debuff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_hellmask_aura_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_hellmask_aura_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_hellmask_aura_debuff:GetModifierAura()
	return "modifier_item_hellmask_debuff"
end

function modifier_item_hellmask_aura_debuff:IsAura()
	return true
end

modifier_item_hellmask_debuff = class({})

function modifier_item_hellmask_debuff:GetTexture()
  	return "item_hellmask"
end

function modifier_item_hellmask_debuff:OnCreated()
	self.aura_armor_enemy = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
end

function modifier_item_hellmask_debuff:IsHidden() return false end
function modifier_item_hellmask_debuff:IsPurgable() return false end
function modifier_item_hellmask_debuff:IsDebuff() return true end

function modifier_item_hellmask_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_hellmask_debuff:GetModifierPhysicalArmorBonus()
	return self.aura_armor_enemy
end