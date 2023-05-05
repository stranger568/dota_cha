modifier_skill_armored = class({})

function modifier_skill_armored:IsHidden() return true end
function modifier_skill_armored:IsPurgable() return false end
function modifier_skill_armored:IsPurgeException() return false end
function modifier_skill_armored:RemoveOnDeath() return false end
function modifier_skill_armored:AllowIllusionDuplicate() return true end

function modifier_skill_armored:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_skill_armored:GetModifierPhysicalArmorBonus()
	return 10
end