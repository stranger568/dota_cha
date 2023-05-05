item_aeon_disk_lua = class({})

LinkLuaModifier("modifier_item_aeon_disk_lua", "item_ability/item_aeon_disk_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_aeon_disk_lua_buff", "item_ability/item_aeon_disk_lua", LUA_MODIFIER_MOTION_NONE)

function item_aeon_disk_lua:GetIntrinsicModifierName()
	return "modifier_item_aeon_disk_lua"
end

modifier_item_aeon_disk_lua = class({})

function modifier_item_aeon_disk_lua:IsHidden() return true end
function modifier_item_aeon_disk_lua:IsDebuff() return false end
function modifier_item_aeon_disk_lua:IsPurgable() return false end
function modifier_item_aeon_disk_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_aeon_disk_lua:OnCreated(keys)
	if IsServer() and self:GetParent() and self:GetParent():IsIllusion() then self:Destroy() return end

	self:OnRefresh(keys)
end

function modifier_item_aeon_disk_lua:OnRefresh(keys)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if (not self.parent) or (not self.ability) or self.parent:IsNull() or self.ability:IsNull() then return end

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health") or 0
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana") or 0

	if IsServer() then
		self.health_threshold_pct = 0.01 * self.ability:GetSpecialValueFor("health_threshold_pct") or 0
		self.buff_duration = self.ability:GetSpecialValueFor("buff_duration") or 0
	end
end

function modifier_item_aeon_disk_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end

function modifier_item_aeon_disk_lua:GetModifierHealthBonus()
	return self.bonus_health or 0
end

function modifier_item_aeon_disk_lua:GetModifierManaBonus()
	return self.bonus_mana or 0
end

function modifier_item_aeon_disk_lua:GetModifierTotal_ConstantBlock(keys)
	local parent = self:GetParent()
	local health_threshold = parent:GetMaxHealth() * self.health_threshold_pct

	if IsValidEntity(self.ability) and self.ability:IsCooldownReady() and parent:GetHealth() - keys.damage <= (health_threshold + 1) then
		self.ability:UseResources(true, false, true, true)

		parent:EmitSound("DOTA_Item.ComboBreaker")

		parent:Purge(false, true, false, true, true)
		parent:AddNewModifier(parent, self.ability, "modifier_item_aeon_disk_lua_buff", {duration = self.buff_duration})

		if parent:GetHealth() > health_threshold then
			parent:SetHealth(health_threshold)
		end

		return keys.damage * 10
	end
end

modifier_item_aeon_disk_lua_buff = class({})

function modifier_item_aeon_disk_lua_buff:IsHidden() return false end
function modifier_item_aeon_disk_lua_buff:IsDebuff() return false end
function modifier_item_aeon_disk_lua_buff:IsPurgable() return true end

function modifier_item_aeon_disk_lua_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_combo_breaker.vpcf"
end

function modifier_item_aeon_disk_lua_buff:StatusEffectPriority()
	return 10
end

function modifier_item_aeon_disk_lua_buff:OnCreated(keys)
	self.status_resistance = self:GetAbility():GetSpecialValueFor("status_resistance") 
	self.health_threshold_pct = 0.01 * self:GetAbility():GetSpecialValueFor("health_threshold_pct") 

	if IsClient() then return end

	self.buff_pfx = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.buff_pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)

	self:AddParticle(self.buff_pfx, false, false, 255, true, false)
end

function modifier_item_aeon_disk_lua_buff:OnDestroy()
	if self.buff_pfx then ParticleManager:ReleaseParticleIndex(self.buff_pfx) end
end

function modifier_item_aeon_disk_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_aeon_disk_lua_buff:GetModifierIncomingDamage_Percentage(keys)
	return -99999999
end

function modifier_item_aeon_disk_lua_buff:GetModifierStatusResistanceStacking()
	return self.status_resistance or 0
end

function modifier_item_aeon_disk_lua_buff:GetModifierTotalDamageOutgoing_Percentage()
	return -100
end

function modifier_item_aeon_disk_lua_buff:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_aeon_disk_lua_buff:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_item_aeon_disk_lua_buff:GetAbsoluteNoDamagePure()
	return 1
end
