LinkLuaModifier("modifier_wisp_overcharge_custom", "abilities/wisp_overcharge_custom", LUA_MODIFIER_MOTION_NONE)

wisp_overcharge_custom = class({})

function wisp_overcharge_custom:GetIntrinsicModifierName()
	return "modifier_wisp_overcharge_custom"
end

function wisp_overcharge_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_wisp_overcharge", {duration = self:GetSpecialValueFor("duration")})
end

modifier_wisp_overcharge_custom = class({})

function modifier_wisp_overcharge_custom:IsHidden() return true end
function modifier_wisp_overcharge_custom:IsPurgable() return false end
function modifier_wisp_overcharge_custom:IsPurgeException() return false end
function modifier_wisp_overcharge_custom:RemoveOnDeath() return false end

function modifier_wisp_overcharge_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_wisp_overcharge_custom:GetModifierProcAttack_BonusDamage_Physical( params )
	if not IsServer() then return end
	if not self:GetCaster():HasModifier("modifier_wisp_overcharge") then return end
	local leech = params.target:GetMaxHealth() / 100 * self:GetAbility():GetSpecialValueFor("damage_pct")
	return leech
end
