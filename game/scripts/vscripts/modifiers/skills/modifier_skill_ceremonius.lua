LinkLuaModifier("modifier_skill_ceremonius_debuff", "modifiers/skills/modifier_skill_ceremonius", LUA_MODIFIER_MOTION_NONE)

modifier_skill_ceremonius = class({})

function modifier_skill_ceremonius:IsHidden() return true end
function modifier_skill_ceremonius:IsPurgable() return false end
function modifier_skill_ceremonius:IsPurgeException() return false end
function modifier_skill_ceremonius:RemoveOnDeath() return false end
function modifier_skill_ceremonius:AllowIllusionDuplicate() return true end

function modifier_skill_ceremonius:GetAuraRadius()
	return 800
end

function modifier_skill_ceremonius:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_skill_ceremonius:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_ceremonius:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_skill_ceremonius:GetModifierAura()
	return "modifier_skill_ceremonius_debuff"
end

function modifier_skill_ceremonius:IsAura()
	return true
end

modifier_skill_ceremonius_debuff = class({})

function modifier_skill_ceremonius_debuff:GetTexture()
  	return "modifier_skill_ceremonius"
end

function modifier_skill_ceremonius_debuff:IsHidden() return true end
function modifier_skill_ceremonius_debuff:IsPurgable() return false end
function modifier_skill_ceremonius_debuff:IsDebuff() return true end

function modifier_skill_ceremonius_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function modifier_skill_ceremonius_debuff:GetModifierMagicalResistanceBonus()
	return -15
end

function modifier_skill_ceremonius_debuff:GetModifierStatusResistanceStacking()
	return -10
end