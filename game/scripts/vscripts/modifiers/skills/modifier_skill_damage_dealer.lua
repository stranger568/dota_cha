modifier_skill_damage_dealer = class({})

function modifier_skill_damage_dealer:IsHidden() return true end
function modifier_skill_damage_dealer:IsPurgable() return false end
function modifier_skill_damage_dealer:IsPurgeException() return false end
function modifier_skill_damage_dealer:RemoveOnDeath() return false end
function modifier_skill_damage_dealer:AllowIllusionDuplicate() return true end

function modifier_skill_damage_dealer:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_skill_damage_dealer:GetModifierPreAttack_BonusDamage()
	return 60
end