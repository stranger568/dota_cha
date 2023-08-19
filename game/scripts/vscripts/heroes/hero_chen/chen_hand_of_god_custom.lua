LinkLuaModifier("modifier_chen_hand_of_god_custom", "heroes/hero_chen/chen_hand_of_god_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chen_hand_of_god_custom_black_king_bar", "heroes/hero_chen/chen_hand_of_god_custom", LUA_MODIFIER_MOTION_NONE)

chen_hand_of_god_custom = class({})

function chen_hand_of_god_custom:OnSpellStart()
	if not IsServer() then return end
	local heal_amount = self:GetSpecialValueFor("heal_amount") / 100
	local hot_duration = self:GetSpecialValueFor("hot_duration")
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

	for _, unit in pairs(units) do
		local health = unit:GetMaxHealth()
		local heal = health * heal_amount
		unit:Heal(heal, self)
		unit:AddNewModifier(self:GetCaster(), self, "modifier_chen_hand_of_god_custom", {duration = hot_duration})
        unit:AddNewModifier(self:GetCaster(), self, "modifier_chen_hand_of_god_custom_black_king_bar", {duration = hot_duration})
		if self:GetCaster():HasTalent("special_bonus_unique_chen_12") then
			unit:Purge(false, true, false, true, false)
		end
		unit:EmitSound("chen_chen_ability_handgod_02")
		if unit:IsRealHero() then
			unit:EmitSound("Hero_Chen.HandOfGodHealHero")
		elseif unit:IsCreep() then
			unit:EmitSound("Hero_Chen.HandOfGodHealCreep")
		end
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

modifier_chen_hand_of_god_custom = class({})

function modifier_chen_hand_of_god_custom:IsPurgable() return true end
function modifier_chen_hand_of_god_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chen_hand_of_god_custom:OnCreated()
	if not IsServer() then return end
	self.heal_per_second = self:GetAbility():GetSpecialValueFor("heal_per_second") / 100
	self:StartIntervalThink(1)
end

function modifier_chen_hand_of_god_custom:OnIntervalThink()
	if not IsServer() then return end
	local health = self:GetParent():GetMaxHealth()
	local heal = health * self.heal_per_second
	self:GetParent():Heal(heal, self:GetAbility())
end

modifier_chen_hand_of_god_custom_black_king_bar = class({})
function modifier_chen_hand_of_god_custom_black_king_bar:IsPurgable() return false end
function modifier_chen_hand_of_god_custom_black_king_bar:IsPurgeException() return false end
function modifier_chen_hand_of_god_custom_black_king_bar:DeclareFunctions()
	return
	{
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_chen_hand_of_god_custom_black_king_bar:GetModifierIncomingDamage_Percentage(params)
	if not IsServer() then return end
	if not params.attacker then return end
	if not params.inflictor then return end
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then 
		return -100 
	end
	local behavior = params.inflictor:GetAbilityTargetFlags()
	if bit.band(behavior, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES) == 0 then
    	if params.damage_type == DAMAGE_TYPE_MAGICAL then 
        	return -80
    	end
    	if params.damage_type == DAMAGE_TYPE_PURE then 
        	return -100
   		end
	end
end
function modifier_chen_hand_of_god_custom_black_king_bar:GetModifierMagicalResistanceBonus()
	if not IsClient() then return end
	return 80
end
function modifier_chen_hand_of_god_custom_black_king_bar:CheckState()
 	return 
 	{
 		[MODIFIER_STATE_DEBUFF_IMMUNE] = true
	}
end

function modifier_chen_hand_of_god_custom_black_king_bar:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end