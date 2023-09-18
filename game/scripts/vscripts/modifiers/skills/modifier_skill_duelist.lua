LinkLuaModifier("modifier_skill_duelist_debuff", "modifiers/skills/modifier_skill_duelist", LUA_MODIFIER_MOTION_NONE)

modifier_skill_duelist = class({})

function modifier_skill_duelist:IsHidden() return true end
function modifier_skill_duelist:IsPurgable() return false end
function modifier_skill_duelist:IsPurgeException() return false end
function modifier_skill_duelist:RemoveOnDeath() return false end
function modifier_skill_duelist:AllowIllusionDuplicate() return true end

function modifier_skill_duelist:IsAura() return true end

function modifier_skill_duelist:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_duelist:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_duelist:GetModifierAura()
	return "modifier_skill_duelist_debuff"
end

function modifier_skill_duelist:GetAuraRadius()
	return 1500
end

function modifier_skill_duelist:GetAuraDuration()
	return 1
end

function modifier_skill_duelist:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_skill_duelist:GetModifierTotalDamageOutgoing_Percentage(params)
    if params.target and not params.target:IsHero() and true~=self:GetParent().bJoiningPvp then
        return -15
    end
end

function modifier_skill_duelist:GetAuraEntityReject(target)
	if IsServer() then
		if target and not target:IsHero() and target:GetOwner() == nil then
			return true
		else
			return false
		end
	end
end

modifier_skill_duelist_debuff = class({})

function modifier_skill_duelist_debuff:IsDebuff() return true end
function modifier_skill_duelist_debuff:IsPurgable() return false end
function modifier_skill_duelist_debuff:GetTexture() return "skill_duelist" end

function modifier_skill_duelist_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_skill_duelist_debuff:GetModifierIncomingDamage_Percentage(params)
    if self:GetParent():IsDebuffImmune() then
        return 35 / 2
    end
	return 35
end