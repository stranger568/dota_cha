LinkLuaModifier("modifier_skill_armorless_debuff", "modifiers/skills/modifier_skill_armorless", LUA_MODIFIER_MOTION_NONE)

modifier_skill_armorless = class({})

function modifier_skill_armorless:IsHidden() return true end
function modifier_skill_armorless:IsPurgable() return false end
function modifier_skill_armorless:IsPurgeException() return false end
function modifier_skill_armorless:RemoveOnDeath() return false end
function modifier_skill_armorless:AllowIllusionDuplicate() return true end

function modifier_skill_armorless:GetAuraRadius()
	return 800
end

function modifier_skill_armorless:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_skill_armorless:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_armorless:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_skill_armorless:GetModifierAura()
	return "modifier_skill_armorless_debuff"
end

function modifier_skill_armorless:IsAura()
	return true
end

modifier_skill_armorless_debuff = class({})

function modifier_skill_armorless_debuff:GetTexture()
  	return "modifier_skill_armorless"
end

function modifier_skill_armorless_debuff:IsHidden() return true end
function modifier_skill_armorless_debuff:IsPurgable() return false end
function modifier_skill_armorless_debuff:IsDebuff() return true end

function modifier_skill_armorless_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_skill_armorless_debuff:GetModifierPhysicalArmorBonus()
	return -7
end