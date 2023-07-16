LinkLuaModifier("modifier_item_bloodstone_2", "item_ability/item_bloodstone_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_modifier_item_bloodstone_2_active", "item_ability/item_bloodstone_2", LUA_MODIFIER_MOTION_NONE )
require( "utils/bit" )

item_bloodstone_2 							= class({})
modifier_item_bloodstone_2 					= class({})
modifier_modifier_item_bloodstone_2_active 	= class({})

function item_bloodstone_2:GetIntrinsicModifierName()
	return "modifier_item_bloodstone_2"
end

function item_bloodstone_2:GetManaCost()
	-- There's like one server-tick where the caster is nil so add this conditional to prevent random error
	if self and not self:IsNull() and self.GetCaster and self:GetCaster() ~= nil then
		return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_cost_percentage") / 100)
	end
end

function item_bloodstone_2:OnSpellStart()
	self.caster	= self:GetCaster()
	self.restore_duration			= self:GetSpecialValueFor("restore_duration")

	if not IsServer() then return end
	--self.caster:EmitSound("shamp_cast")	
	self.caster:EmitSound("DOTA_Item.Bloodstone.Cast")
	--self.caster:EmitSound("beer_cast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_modifier_item_bloodstone_2_active", {duration = self.restore_duration})
end

function modifier_modifier_item_bloodstone_2_active:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	self.restore_duration			= self.ability:GetSpecialValueFor("restore_duration")
	self.mana_cost					= self.ability:GetManaCost()
	
	if not IsServer() then return end
	
	self.cooldown_remaining			= math.max(self:GetAbility():GetCooldownTimeRemaining() - self:GetRemainingTime(), 0)

	self.particle = ParticleManager:CreateParticle("particles/items_fx/bloodstone_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)

end


function modifier_modifier_item_bloodstone_2_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_modifier_item_bloodstone_2_active:GetModifierConstantHealthRegen()
    return self.mana_cost / self.restore_duration
end

function modifier_modifier_item_bloodstone_2_active:OnTooltip()
    return self.mana_cost
end

--------------------------------------
-- BLOODSTONE PASSIVE MODIFIER 7.20 --
--------------------------------------

function modifier_item_bloodstone_2:IsHidden()		return true end
function modifier_item_bloodstone_2:IsPurgable()	return false end
function modifier_item_bloodstone_2:RemoveOnDeath()	return false end

function modifier_item_bloodstone_2:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	self.bonus_health				= self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana					= self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_intellect			= self.ability:GetSpecialValueFor("bonus_intellect")
	self.mana_regen_multiplier	    = self.ability:GetSpecialValueFor("mana_regen_multiplier")
	self.spell_amp					= self.ability:GetSpecialValueFor("spell_amp")
	self.regen_per_charge			= self.ability:GetSpecialValueFor("regen_per_charge")
	self.amp_per_charge				= self.ability:GetSpecialValueFor("amp_per_charge")
	self.death_charges				= self.ability:GetSpecialValueFor("death_charges")
	self.kill_charges				= self.ability:GetSpecialValueFor("kill_charges")
	self.charge_range				= self.ability:GetSpecialValueFor("charge_range")
	self.initial_charges_tooltip	= self.ability:GetSpecialValueFor("initial_charges_tooltip")
			
	if not IsServer() then return end
	
	-- Need to do this instead of using the "ItemInitialCharges" KV because the latter messes with sell prices
	if not self.ability.initialized then
		self.ability:SetCurrentCharges(self.initial_charges_tooltip)
		self.ability.initialized = true
	end
	
	self:SetStackCount(self.ability:GetCurrentCharges())
	
	-- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiple Bloodstones
	for _, mod in pairs(self:GetCaster():FindAllModifiersByName(self:GetName())) do
		mod:GetAbility():SetSecondaryCharges(_)
	end
end

function modifier_item_bloodstone_2:OnDestroy()
	if not IsServer() then return end
	
	for _, mod in pairs(self:GetCaster():FindAllModifiersByName(self:GetName())) do
		mod:GetAbility():SetSecondaryCharges(_)
	end
end


function modifier_item_bloodstone_2:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,	
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_bloodstone_2:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_bloodstone_2:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_bloodstone_2:GetModifierTotalPercentageManaRegen()
	return self.mana_regen_multiplier / 100
end

function modifier_item_bloodstone_2:GetModifierSpellAmplify_PercentageUnique()
	return self.spell_amp
end

function modifier_item_bloodstone_2:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_bloodstone_2:GetModifierConstantManaRegen()
	return self.regen_per_charge * self:GetStackCount()
end

function modifier_item_bloodstone_2:GetModifierSpellAmplify_Percentage()
	return self.amp_per_charge * self:GetStackCount()
end

function modifier_item_bloodstone_2:OnDeathEvent(keys)
	if keys.unit:IsRealHero() and keys.attacker:GetTeamNumber() == self.parent:GetTeamNumber() then
		if self.parent:GetTeam() ~= keys.unit:GetTeam() and ((keys.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.charge_range or self.parent == keys.attacker) and self.parent:IsAlive() then
			if self == self.parent:FindAllModifiersByName(self:GetName())[1] then
				for itemSlot = 0, 5 do
					local item = self.parent:GetItemInSlot(itemSlot)
				
					if item and item:GetName() == self.ability:GetName() then
						local bonus = 0
						if self.parent:HasModifier("modifier_skill_bloodmage") then
							bonus = 1
						end
						item:SetCurrentCharges(item:GetCurrentCharges() + self.kill_charges + bonus)
						break
					end
				end
			end
		elseif self.parent == keys.unit and (not keys.unit.IsReincarnating or (keys.unit.IsReincarnating and not keys.unit:IsReincarnating())) then
			--self.ability:SetCurrentCharges(math.max(self.ability:GetCurrentCharges() - self.death_charges, 0))
		end
		self:SetStackCount(self.ability:GetCurrentCharges())	
	end
end

function GetReductionFromArmor(armor)
	return (0.06 * armor) / (1 + 0.06 * math.abs(armor))
end

function modifier_item_bloodstone_2:TakeDamageScriptModifier( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and not self:GetParent():IsIllusion() then		
		if keys.inflictor == nil then return end
		local table_skills = 
		{
			["doom_bringer_devour_custom"] = true,
			["mirana_arrow"] = true,
			["life_stealer_infest"] = true,
			["life_stealer_consume"] = true,
			["night_stalker_hunter_in_the_night_custom"] = true,
			["snapfire_mortimer_kisses"] = true,
			["snapfire_gobble_up"] = true,
			["snapfire_spit_creep"] = true,
			["silencer_glaives_of_wisdom_custom"] = true,
			["pudge_meat_hook"] = true,
			["enigma_demonic_conversion_custom"] = true,
			["item_hand_of_midas"] = true,
		}
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and (keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL or table_skills[keys.inflictor:GetAbilityName()]) and keys.inflictor and bit:_and(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.Script_GetMagicalArmorValue then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:Script_GetMagicalArmorValue(false, nil)))
				elseif keys.damage_type == DAMAGE_TYPE_PURE then
					keys.damage = keys.original_damage
				end
			end
			
			if keys.unit:IsCreep() then
				keys.attacker:Heal(math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("creep_lifesteal") * 0.01, keys.attacker)
			else
				keys.attacker:Heal(math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("hero_lifesteal") * 0.01, keys.attacker)
			end
		end
	end
end
