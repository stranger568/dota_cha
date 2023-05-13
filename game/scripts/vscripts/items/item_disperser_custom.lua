LinkLuaModifier("modifier_item_disperser_custom", "items/item_disperser_custom", LUA_MODIFIER_MOTION_NONE)

item_disperser_custom = class({})

function item_disperser_custom:GetIntrinsicModifierName()
	return "modifier_item_disperser_custom"
end

function item_disperser_custom:OnSpellStart()
	if not IsServer() then return end
	local target = self:GetCursorTarget()
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		target:Purge(false, true, false, false, false)
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_disperser_movespeed_buff", {duration = self:GetSpecialValueFor("ally_effect_duration")})
	else
		if target:TriggerSpellAbsorb(self) then return end
		self:GetCaster():EmitSound("DOTA_Item.DiffusalBlade.Activate")
		target:EmitSound("DOTA_Item.DiffusalBlade.Target")
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_diffusal_blade_slow", {duration = self:GetSpecialValueFor("enemy_effect_duration")})
		if not target:IsHero() then
			target:AddNewModifier(self:GetCaster(), self, "modifier_rooted", {duration = self:GetSpecialValueFor("purge_root_duration")})
		end
	end
end

modifier_item_disperser_custom = class({})

function modifier_item_disperser_custom:IsHidden()		return true end
function modifier_item_disperser_custom:IsPurgable() return false end
function modifier_item_disperser_custom:IsPurgeException() return false end
function modifier_item_disperser_custom:RemoveOnDeath()	return false end
function modifier_item_disperser_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_disperser_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_disperser_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("bonus_agility")
    end
end

function modifier_item_disperser_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
    end
end

function modifier_item_disperser_custom:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
end

function modifier_item_disperser_custom:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
    	if params.no_attack_cooldown then return end
    	if self:GetParent():PassivesDisabled() then return end
    	local target_n = params.target
    	if self:GetParent():FindAllModifiersByName("modifier_item_disperser_custom")[1] ~= self then return end
		local enemies = FindUnitsInRadius(params.attacker:GetTeamNumber(), target_n:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("burn_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)

		for _, target in pairs(enemies) do
			local manaBurn = self:GetAbility():GetSpecialValueFor("feedback_mana_burn")
			local manaDamage = self:GetAbility():GetSpecialValueFor("damage_per_burn")
			local feedback_mana_burn_illusion = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_melee")

			local damageTable = {}
			damageTable.attacker = self:GetParent()
			damageTable.victim = target
			damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
			damageTable.ability = self:GetAbility()

			if not target:IsMagicImmune() then
				if(target:GetMana() >= manaBurn) then
					damageTable.damage = manaBurn * manaDamage
					if not self:GetParent():IsIllusion() then
						target:Script_ReduceMana(manaBurn, self:GetAbility())
					else
						target:Script_ReduceMana(feedback_mana_burn_illusion, self:GetAbility())
						damageTable.damage = feedback_mana_burn_illusion * manaDamage
					end
				else
					damageTable.damage = target:GetMana() * manaDamage
					if not self:GetParent():IsIllusion() then
						target:Script_ReduceMana(manaBurn, self:GetAbility())
					else
						target:Script_ReduceMana(feedback_mana_burn_illusion, self:GetAbility())
					end
				end

				ApplyDamage(damageTable)
			end
		end
    end
end