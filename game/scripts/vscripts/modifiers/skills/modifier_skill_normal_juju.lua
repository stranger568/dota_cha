modifier_skill_normal_juju = class({})
function modifier_skill_normal_juju:IsHidden() return true end
function modifier_skill_normal_juju:IsPurgable() return false end
function modifier_skill_normal_juju:IsPurgeException() return false end
function modifier_skill_normal_juju:RemoveOnDeath() return false end
function modifier_skill_normal_juju:AllowIllusionDuplicate() return true end

modifier_skill_normal_juju.restricted_abilities = 
{
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
    ["puck_phase_shift_custom"] = true,
}

function modifier_skill_normal_juju:DeclareFunctions()
	return 
    {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
end

function modifier_skill_normal_juju:OnCreated()
	self.cooldown_reduction = 0.75
	self.item_cooldown_reduction = 25
end

function modifier_skill_normal_juju:CanReduceCooldown(ability)
	return ability 
	and not ability:IsItem()
	and not ability:IsToggle() 
	and not self.restricted_abilities[ability:GetAbilityName()]
end

function modifier_skill_normal_juju:OnSpentMana(params)
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

	if modifier_skill_normal_juju.restricted_abilities[hAbility:GetAbilityName()] then return end

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


function modifier_skill_normal_juju:GetModifierCooldownReduction_Constant(params)
	if IsClient() then return end

	if self.lock then return end

	self.lock = true
	if params.ability:GetEffectiveCooldown(-1) <= self.cooldown_reduction then return end
	self.lock = false

	if self:CanReduceCooldown(params.ability) then
		return self.cooldown_reduction
	end
end

function modifier_skill_normal_juju:GetModifierPercentageCooldown(params)
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

