LinkLuaModifier("modifier_bloodseeker_blood_mist_custom", "heroes/hero_bloodseeker/bloodseeker_blood_mist_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_bloodseeker_blood_mist_custom_slow", "heroes/hero_bloodseeker/bloodseeker_blood_mist_custom", LUA_MODIFIER_MOTION_NONE )

bloodseeker_blood_mist_custom = class({})

function bloodseeker_blood_mist_custom:OnToggle()
    local caster = self:GetCaster()
    local toggle = self:GetToggleState()
    if not IsServer() then return end
    caster:EmitSound("Hero_Boodseeker.Bloodmist")
    if toggle then
        self.modifier = caster:AddNewModifier( caster, self, "modifier_bloodseeker_blood_mist_custom", {} )
        self:UseResources(false, false, false, true)
    else
        if self.modifier and not self.modifier:IsNull() then
            self.modifier:Destroy()
        end
        caster:StopSound("Hero_Boodseeker.Bloodmist")
        self.modifier = nil
    end
end

modifier_bloodseeker_blood_mist_custom = class({})

function modifier_bloodseeker_blood_mist_custom:IsHidden() return false end
function modifier_bloodseeker_blood_mist_custom:IsPurgable() return false end
function modifier_bloodseeker_blood_mist_custom:IsPurgeException() return false end

function modifier_bloodseeker_blood_mist_custom:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.7)
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
	self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_bloodseeker_blood_mist_custom:OnIntervalThink()
	if not IsServer() then return end
	self:SelfDamage()
	self:EnemyDamage()
end

function modifier_bloodseeker_blood_mist_custom:SelfDamage()
	if not IsServer() then return end
	if self:GetParent():IsInvulnerable() then return end
	if self:GetParent():GetHealth() <= 1 then return end
	if self:GetParent():IsMagicImmune() then return end
	local hp_cost_per_second = self:GetAbility():GetSpecialValueFor("hp_cost_per_second")
	local self_damage = self:GetParent():GetMaxHealth() / 100 * hp_cost_per_second
	self_damage = self_damage * 0.7

	local damage_table = {}
    damage_table.attacker = self:GetParent()
    damage_table.victim = self:GetParent()
    damage_table.damage_type = DAMAGE_TYPE_MAGICAL
    damage_table.ability = self:GetAbility()
    damage_table.damage = self_damage
    damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL
    ApplyDamage(damage_table)
end

function modifier_bloodseeker_blood_mist_custom:EnemyDamage()
	if not IsServer() then return end
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local targets = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, 0, false )
	for _, target in pairs(targets) do
		local hp_cost_per_second = self:GetAbility():GetSpecialValueFor("hp_cost_per_second")
		local damage = target:GetMaxHealth() / 100 * hp_cost_per_second
		damage = damage * 0.7

		local damage_table = {}
	    damage_table.attacker = self:GetCaster()
	    damage_table.victim = target
	    damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	    damage_table.ability = self:GetAbility()
	    damage_table.damage = damage
	    ApplyDamage(damage_table)
	end
end

function modifier_bloodseeker_blood_mist_custom:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_bloodseeker_blood_mist_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_bloodseeker_blood_mist_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_bloodseeker_blood_mist_custom:GetAuraDuration()
	return 0.71
end

function modifier_bloodseeker_blood_mist_custom:GetModifierAura()
	return "modifier_bloodseeker_blood_mist_custom_slow"
end

function modifier_bloodseeker_blood_mist_custom:IsAura()
	return true
end

modifier_bloodseeker_blood_mist_custom_slow = class({})

function modifier_bloodseeker_blood_mist_custom_slow:IsPurgable() return true end

function modifier_bloodseeker_blood_mist_custom_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_bloodseeker_blood_mist_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor( "movement_slow" ) * -1
end