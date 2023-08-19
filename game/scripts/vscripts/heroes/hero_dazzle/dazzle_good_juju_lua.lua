dazzle_good_juju_lua = class({}) 

LinkLuaModifier("modifier_dazzle_good_juju_lua", "heroes/hero_dazzle/dazzle_good_juju_lua", LUA_MODIFIER_MOTION_NONE)

dazzle_good_juju_lua.restricted_items = {
	item_refresher = true,
	item_ex_machina = true,
	item_refresher_custom = true,
	item_ex_machina_custom = true,
}

function dazzle_good_juju_lua:GetIntrinsicModifierName()
	return "modifier_dazzle_good_juju_lua"
end

function dazzle_good_juju_lua:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function dazzle_good_juju_lua:GetManaCost(level)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor("scepter_mana_cost", level)
	end
end

function dazzle_good_juju_lua:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor("scepter_cooldown", level)
	end
end

function dazzle_good_juju_lua:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if not target then return end

	for i = 0, DOTA_ITEM_INVENTORY_SIZE - 1 do
		local item = target:GetItemInSlot(i)
		if item and item.GetAbilityName then
			--如果物品存在购买者必须，则必须与施法者是同一人
			if  (not item.GetPurchaser) or (not item:GetPurchaser()) or item:GetPurchaser():GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
			    if not self.restricted_items[item:GetAbilityName()] then
                    item:EndCooldown()
                    item:RefreshCharges()
			    end
			end	
		end
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_lucky_charm.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	target:EmitSound("DOTA_Item.Refresher.Activate")
end


modifier_dazzle_good_juju_lua = class({})

modifier_dazzle_good_juju_lua.restricted_abilities = {
	["dark_willow_shadow_realm"] = true,
	["huskar_burning_spear"] = true,
	["drow_ranger_frost_arrows_custom"] = true,
	["kunkka_tidebringer"] = true,
	["viper_poison_attack"] = true,
	["clinkz_searing_arrows"] = true,
	["enchantress_impetus"] = true,
	["bounty_hunter_jinada_custom"] = true,
	["weaver_geminate_attack"] = true,
	["jakiro_liquid_fire"] = true,
	["jakiro_liquid_ice"] = true,
	["ancient_apparition_chilling_touch"] = true,
	["silencer_glaives_of_wisdom_custom"] = true,
	["obsidian_destroyer_arcane_orb"] = true,
	["tusk_walrus_punch"] = true,
	["frostivus2018_huskar_burning_spear"] = true,
	["frostivus2018_clinkz_searing_arrows"] = true,
}

function modifier_dazzle_good_juju_lua:IsHidden() return true end
function modifier_dazzle_good_juju_lua:IsPurgable() return false end
function modifier_dazzle_good_juju_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_dazzle_good_juju_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
end

function modifier_dazzle_good_juju_lua:OnCreated()
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	self.item_cooldown_reduction = self:GetAbility():GetSpecialValueFor("item_cooldown_reduction")
end

function modifier_dazzle_good_juju_lua:OnRefresh()
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	self.item_cooldown_reduction = self:GetAbility():GetSpecialValueFor("item_cooldown_reduction")
end

function modifier_dazzle_good_juju_lua:CanReduceCooldown(ability)
	return ability 
		and not ability:IsItem()
		and not ability:IsToggle() 
		and not self.restricted_abilities[ability:GetAbilityName()]
end

function modifier_dazzle_good_juju_lua:OnSpentMana(params)
	if not IsServer() then return end

	if not self:GetParent() then
		return
	end

	if self:GetParent():IsNull() then
		return
	end

	if params.unit ~= self:GetParent() then
		return
	end

	local hAbility = params.ability

	if not hAbility then return end

	if hAbility:GetAbilityName() ~= "dazzle_bad_juju" then
		if params.cost == nil or params.cost == 0 then
			return 
		end
	end

	if hAbility == self:GetAbility() then return end
	if hAbility:IsItem() then return end
	if hAbility:IsPassive() then return end
	if hAbility:HasBehavior(DOTA_ABILITY_BEHAVIOR_PASSIVE) 
	or hAbility:HasBehavior(DOTA_ABILITY_BEHAVIOR_TOGGLE) then return end

	if modifier_dazzle_good_juju_lua.restricted_abilities[hAbility:GetAbilityName()] then return end

	if hAbility:GetAbilityName() ~= "dazzle_bad_juju" then
	    if params.cost< hAbility:GetManaCost(hAbility:GetLevel()-1)*0.2 then
	       	return
	    end
	end
    
    --遍历技能 减少CD
	for i = 0, 34 do
		local hLoopAbility = self:GetParent():GetAbilityByIndex(i)
		if hLoopAbility and self:CanReduceCooldown(hLoopAbility) then
			local flCurrentCooldown = hLoopAbility:GetCooldownTimeRemaining()
			local flReducedCooldown = flCurrentCooldown - self.cooldown_reduction
			hLoopAbility:EndCooldown()
			if flReducedCooldown > 0 then
				hLoopAbility:StartCooldown(flReducedCooldown)
			end
		end
	end

	return 0
end


function modifier_dazzle_good_juju_lua:GetModifierCooldownReduction_Constant(params)
	if IsClient() then return end

	if self.lock then return end

	self.lock = true
	if params.ability:GetEffectiveCooldown(-1) <= self.cooldown_reduction then return end
	self.lock = false

	if self:CanReduceCooldown(params.ability) then
		return self.cooldown_reduction
	end
end

function modifier_dazzle_good_juju_lua:GetModifierPercentageCooldown(params)
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not params.ability or not caster:HasScepter() then return end

	local can_refresh = (not params.ability.GetPurchaser) or (not params.ability:GetPurchaser())
	                    or (params.ability:GetPurchaser():IsNull())
	                    or params.ability:GetPurchaser():GetPlayerOwnerID() == caster:GetPlayerOwnerID()

	if params.ability and params.ability:IsItem() and can_refresh then
		return self.item_cooldown_reduction
	end
end

