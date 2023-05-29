LinkLuaModifier("modifier_meepo_ransack_custom", "heroes/hero_meepo/meepo_ransack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meepo_ransack_custom_debuff", "heroes/hero_meepo/meepo_ransack", LUA_MODIFIER_MOTION_NONE)

meepo_ransack_custom = class({})

function meepo_ransack_custom:GetIntrinsicModifierName()
	return "modifier_meepo_ransack_custom"
end

modifier_meepo_ransack_custom = class({})
function modifier_meepo_ransack_custom:IsHidden() return true end
function modifier_meepo_ransack_custom:IsPurgable() return false end
function modifier_meepo_ransack_custom:IsPurgeException() return false end
function modifier_meepo_ransack_custom:RemoveOnDeath() return false end

function modifier_meepo_ransack_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_meepo_ransack_custom:GetModifierPreAttack_BonusDamage(params)
	if not IsServer() then return end
	if params.target == nil then return end
	local leech = params.target:GetMaxHealth() / 100 * self:GetAbility():GetSpecialValueFor("damage_physical")
	return leech
end

function modifier_meepo_ransack_custom:TakeDamageScriptModifier( params )
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.attacker:PassivesDisabled() then return end
	if params.attacker:IsIllusion() then return end
	if params.no_attack_cooldown then return end
	if params.inflictor ~= nil then return end
	local leech = params.unit:GetMaxHealth() / 100 * self:GetAbility():GetSpecialValueFor("damage_physical")
	self:GetParent():Heal(leech, self:GetAbility())
	local duration = self:GetAbility():GetSpecialValueFor("duration_debuff")
    params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_meepo_ransack_custom_debuff", {duration = duration})
end

modifier_meepo_ransack_custom_debuff = class({})

function modifier_meepo_ransack_custom_debuff:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
	self.minus_regen = self:GetAbility():GetSpecialValueFor("minus_regen")
end

function modifier_meepo_ransack_custom_debuff:OnRefresh()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
	self.minus_regen = self:GetAbility():GetSpecialValueFor("minus_regen")
end

function modifier_meepo_ransack_custom_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end

function modifier_meepo_ransack_custom_debuff:GetModifierLifestealRegenAmplify_Percentage()
	return self.minus_regen
end

function modifier_meepo_ransack_custom_debuff:GetModifierHealAmplify_PercentageTarget()
	return self.minus_regen
end

function modifier_meepo_ransack_custom_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.minus_regen
end

function modifier_meepo_ransack_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end