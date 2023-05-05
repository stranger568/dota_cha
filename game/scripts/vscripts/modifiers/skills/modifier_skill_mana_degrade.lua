modifier_skill_mana_degrade = class({})

function modifier_skill_mana_degrade:IsHidden() return true end
function modifier_skill_mana_degrade:IsPurgable() return false end
function modifier_skill_mana_degrade:IsPurgeException() return false end
function modifier_skill_mana_degrade:RemoveOnDeath() return false end
function modifier_skill_mana_degrade:AllowIllusionDuplicate() return true end

function modifier_skill_mana_degrade:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_skill_mana_degrade:GetModifierProcAttack_BonusDamage_Physical( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	local target = params.target
	if not target then return end
	if target:GetMaxMana() == 0 then return end
	if target:IsMagicImmune() then return end
	if self:GetParent():IsIllusion() then return end

	local reduce_mana_full = 50 + (target:GetMaxMana() / 100 * 2)
	local mana_burn =  math.min( target:GetMana(), reduce_mana_full )
	target:Script_ReduceMana(mana_burn, self:GetAbility()) 
	target:EmitSound("Hero_Antimage.ManaBreak")

	return mana_burn / 100 * 50
end