LinkLuaModifier( "modifier_item_guardian_greaves_custom", "items/item_guardian_greaves_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_guardian_greaves_custom_buff", "items/item_guardian_greaves_custom", LUA_MODIFIER_MOTION_NONE )

item_guardian_greaves_custom = class({})

function item_guardian_greaves_custom:GetIntrinsicModifierName()
	return "modifier_item_guardian_greaves_custom"
end

function item_guardian_greaves_custom:OnSpellStart()
	if not IsServer() then return end
	
	self:GetCaster():EmitSound("Item.GuardianGreaves.Activate")

	local particle_1 = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle_1)

	self:GetCaster():Purge(false, true, false, false, false)

	local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

    for _, hero in pairs(heroes) do
		local heal_amount = self:GetSpecialValueFor("replenish_health") * hero:GetMaxHealth() / 100
		local mana_amount = self:GetSpecialValueFor("replenish_mana") * hero:GetMaxMana() / 100
		hero:GiveMana(mana_amount)
	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, hero, mana_amount, nil)
		hero:Heal(heal_amount, self)
	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hero, heal_amount, nil)
	
		hero:EmitSound("Item.GuardianGreaves.Target")
	
		local particle_2 = ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
		ParticleManager:SetParticleControl(particle_2, 0, hero:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_2)
    end
end

modifier_item_guardian_greaves_custom = class({})

function modifier_item_guardian_greaves_custom:IsHidden()
	return true
end

function modifier_item_guardian_greaves_custom:IsPurgable() return false end
function modifier_item_guardian_greaves_custom:IsPurgeException() return false end
function modifier_item_guardian_greaves_custom:RemoveOnDeath()	return false end
function modifier_item_guardian_greaves_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_guardian_greaves_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_guardian_greaves_custom:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_movement")
end

function modifier_item_guardian_greaves_custom:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_guardian_greaves_custom:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") 
end

function modifier_item_guardian_greaves_custom:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("aura_health_regen")
end

function modifier_item_guardian_greaves_custom:IsAura() return true end

function modifier_item_guardian_greaves_custom:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_item_guardian_greaves_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_item_guardian_greaves_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_guardian_greaves_custom:GetModifierAura()
    return "modifier_item_guardian_greaves_custom_buff"
end

function modifier_item_guardian_greaves_custom:GetAuraRadius()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("replenish_radius")
    end
end

function modifier_item_guardian_greaves_custom:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

modifier_item_guardian_greaves_custom_buff = class({})

function modifier_item_guardian_greaves_custom_buff:IsPurgable()
    return false
end

function modifier_item_guardian_greaves_custom_buff:IsHidden()
	return self:GetParent():GetHealthPercent() > self:GetAbility():GetSpecialValueFor("aura_bonus_threshold")
end

function modifier_item_guardian_greaves_custom_buff:OnCreated()
    self:StartIntervalThink(FrameTime())
end

function modifier_item_guardian_greaves_custom_buff:OnIntervalThink()
    if self:GetParent():GetHealthPercent() > self:GetAbility():GetSpecialValueFor("aura_bonus_threshold") then
        self.bonus_regen = 0
        self.bonus_armor = 0
    else
        self.bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_hp_regen_threshold")
        self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor_threshold")
    end
end

function modifier_item_guardian_greaves_custom_buff:DeclareFunctions()
return  {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        }
end

function modifier_item_guardian_greaves_custom_buff:GetModifierConstantHealthRegen()
    return self.bonus_regen 
end

function modifier_item_guardian_greaves_custom_buff:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end




