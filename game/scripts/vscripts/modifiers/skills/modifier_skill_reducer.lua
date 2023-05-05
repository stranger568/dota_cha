LinkLuaModifier("modifier_skill_reducer_debuff", "modifiers/skills/modifier_skill_reducer", LUA_MODIFIER_MOTION_NONE)

modifier_skill_reducer = class({})

function modifier_skill_reducer:IsHidden() return true end
function modifier_skill_reducer:IsPurgable() return false end
function modifier_skill_reducer:IsPurgeException() return false end
function modifier_skill_reducer:RemoveOnDeath() return false end
function modifier_skill_reducer:AllowIllusionDuplicate() return true end

function modifier_skill_reducer:GetAuraRadius()
	return 800
end

function modifier_skill_reducer:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_skill_reducer:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_reducer:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_skill_reducer:GetModifierAura()
	return "modifier_skill_reducer_debuff"
end

function modifier_skill_reducer:IsAura()
	return not self:GetParent():PassivesDisabled()
end

modifier_skill_reducer_debuff = class({})

function modifier_skill_reducer_debuff:GetTexture()
  	return "modifier_skill_reducer"
end

function modifier_skill_reducer_debuff:IsHidden() return false end
function modifier_skill_reducer_debuff:IsPurgable() return false end
function modifier_skill_reducer_debuff:IsDebuff() return true end

function modifier_skill_reducer_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_skill_reducer_debuff:GetModifierDamageOutgoing_Percentage()
	return -60
end