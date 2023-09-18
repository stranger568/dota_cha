LinkLuaModifier("modifier_skill_berserker_debuff", "modifiers/skills/modifier_skill_berserker", LUA_MODIFIER_MOTION_NONE)

modifier_skill_berserker = class({})

function modifier_skill_berserker:IsHidden() return true end
function modifier_skill_berserker:IsPurgable() return false end
function modifier_skill_berserker:IsPurgeException() return false end
function modifier_skill_berserker:RemoveOnDeath() return false end
function modifier_skill_berserker:AllowIllusionDuplicate() return true end

function modifier_skill_berserker:IsAura() return true end

function modifier_skill_berserker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_berserker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_berserker:GetModifierAura()
	return "modifier_skill_berserker_debuff"
end

function modifier_skill_berserker:GetAuraRadius()
	return 1500
end

function modifier_skill_berserker:GetAuraDuration()
	return 1
end

function modifier_skill_berserker:DeclareFunctions()
	return 
    {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_skill_berserker:GetModifierTotalDamageOutgoing_Percentage()
	return 40
end

function modifier_skill_berserker:GetModifierIncomingDamage_Percentage()
	return 15
end

modifier_skill_berserker_debuff = class({})

function modifier_skill_berserker_debuff:IsDebuff() return true end
function modifier_skill_berserker_debuff:IsPurgable() return false end
function modifier_skill_berserker_debuff:GetTexture() return "modifier_skill_berserker" end

function modifier_skill_berserker_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_skill_berserker_debuff:GetModifierIncomingDamage_Percentage(params)
    if self:GetParent():IsDebuffImmune() then
        return 40 / 2
    end
	return 40
end