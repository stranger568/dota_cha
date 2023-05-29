LinkLuaModifier("modifier_broodmother_insatiable_hunger_custom", "abilities/broodmother_insatiable_hunger_custom", LUA_MODIFIER_MOTION_NONE)

broodmother_insatiable_hunger_custom = class({})

function broodmother_insatiable_hunger_custom:GetIntrinsicModifierName()
	return "modifier_broodmother_insatiable_hunger_custom"
end

function broodmother_insatiable_hunger_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():EmitSound("Hero_Broodmother.InsatiableHunger")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_broodmother_insatiable_hunger", {duration = self:GetSpecialValueFor("duration")})
end

modifier_broodmother_insatiable_hunger_custom = class({})
function modifier_broodmother_insatiable_hunger_custom:IsHidden() return true end
function modifier_broodmother_insatiable_hunger_custom:IsPurgable() return false end
function modifier_broodmother_insatiable_hunger_custom:IsPurgeException() return false end
function modifier_broodmother_insatiable_hunger_custom:RemoveOnDeath() return false end

function modifier_broodmother_insatiable_hunger_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_broodmother_insatiable_hunger_custom:GetModifierPreAttack_BonusDamage(params)
	if not IsServer() then return end
	if not self:GetCaster():HasModifier("modifier_broodmother_insatiable_hunger") then return end
	if self:GetCaster():PassivesDisabled() then return end
	if params.target == nil then return end
	local leech = params.target:GetMaxHealth() / 100 * self:GetAbility():GetSpecialValueFor("damage_pct")
	return leech
end
