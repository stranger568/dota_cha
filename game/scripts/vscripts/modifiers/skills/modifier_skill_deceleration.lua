LinkLuaModifier("modifier_skill_deceleration_debuff", "modifiers/skills/modifier_skill_deceleration", LUA_MODIFIER_MOTION_NONE)

modifier_skill_deceleration = class({})

function modifier_skill_deceleration:IsHidden() return true end
function modifier_skill_deceleration:IsPurgable() return false end
function modifier_skill_deceleration:IsPurgeException() return false end
function modifier_skill_deceleration:RemoveOnDeath() return false end
function modifier_skill_deceleration:AllowIllusionDuplicate() return true end

function modifier_skill_deceleration:GetAuraRadius()
	return 900
end

function modifier_skill_deceleration:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_skill_deceleration:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_deceleration:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_skill_deceleration:GetModifierAura()
	return "modifier_skill_deceleration_debuff"
end

function modifier_skill_deceleration:IsAura()
	return true
end

modifier_skill_deceleration_debuff = class({})

function modifier_skill_deceleration_debuff:GetTexture()
  	return "modifier_skill_deceleration"
end

function modifier_skill_deceleration_debuff:IsHidden() return false end
function modifier_skill_deceleration_debuff:IsPurgable() return false end
function modifier_skill_deceleration_debuff:IsDebuff() return true end

function modifier_skill_deceleration_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_skill_deceleration_debuff:GetModifierAttackSpeedBonus_Constant()
	return -45
end

function modifier_skill_deceleration_debuff:GetModifierMoveSpeedBonus_Constant()
	return -40
end