LinkLuaModifier("modifier_skill_fearful_debuff", "modifiers/skills/modifier_skill_fearful", LUA_MODIFIER_MOTION_NONE)

modifier_skill_fearful = class({})

function modifier_skill_fearful:IsHidden() return true end
function modifier_skill_fearful:IsPurgable() return false end
function modifier_skill_fearful:IsPurgeException() return false end
function modifier_skill_fearful:RemoveOnDeath() return false end
function modifier_skill_fearful:AllowIllusionDuplicate() return true end

function modifier_skill_fearful:IsAura() return true end

function modifier_skill_fearful:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_fearful:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_fearful:GetModifierAura()
	return "modifier_skill_fearful_debuff"
end

function modifier_skill_fearful:GetAuraRadius()
	return 500
end

function modifier_skill_fearful:GetAuraDuration()
	return 1
end

modifier_skill_fearful_debuff = class({})

function modifier_skill_fearful_debuff:IsDebuff() return true end
function modifier_skill_fearful_debuff:IsPurgable() return false end
function modifier_skill_fearful_debuff:GetTexture() return "modifier_skill_fearful" end

function modifier_skill_fearful_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_skill_fearful_debuff:GetModifierIncomingDamage_Percentage(params)
	if self:GetParent():HasModifier("modifier_loser_curse") then return end
	if params.damage_type == DAMAGE_TYPE_PURE then return end
	return 20
end