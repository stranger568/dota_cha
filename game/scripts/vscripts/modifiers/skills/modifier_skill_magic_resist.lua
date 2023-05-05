modifier_skill_magic_resist = class({})

function modifier_skill_magic_resist:IsHidden() return true end
function modifier_skill_magic_resist:IsPurgable() return false end
function modifier_skill_magic_resist:IsPurgeException() return false end
function modifier_skill_magic_resist:RemoveOnDeath() return false end
function modifier_skill_magic_resist:AllowIllusionDuplicate() return true end

function modifier_skill_magic_resist:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_skill_magic_resist:GetModifierMagicalResistanceBonus()
	return 15
end