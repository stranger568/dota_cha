LinkLuaModifier("modifier_skill_enervation_debuff", "modifiers/skills/modifier_skill_enervation", LUA_MODIFIER_MOTION_NONE)

modifier_skill_enervation = class({})

function modifier_skill_enervation:IsHidden() return true end
function modifier_skill_enervation:IsPurgable() return false end
function modifier_skill_enervation:IsPurgeException() return false end
function modifier_skill_enervation:RemoveOnDeath() return false end
function modifier_skill_enervation:AllowIllusionDuplicate() return true end

function modifier_skill_enervation:GetAuraRadius()
	return 1500
end

function modifier_skill_enervation:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_skill_enervation:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_enervation:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_skill_enervation:GetModifierAura()
	return "modifier_skill_enervation_debuff"
end

function modifier_skill_enervation:IsAura()
	return true
end

modifier_skill_enervation_debuff = class({})

function modifier_skill_enervation_debuff:GetTexture()
  	return "modifier_skill_enervation"
end

function modifier_skill_enervation_debuff:IsHidden() return false end
function modifier_skill_enervation_debuff:IsPurgable() return false end
function modifier_skill_enervation_debuff:IsDebuff() return true end

function modifier_skill_enervation_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

	}
end

function modifier_skill_enervation_debuff:OnCreated()
	self.reduce = self:GetParent():Script_GetAttackRange() * 0.4
end

function modifier_skill_enervation_debuff:GetModifierAttackRangeBonus()
	return -self.reduce
end

function modifier_skill_enervation_debuff:GetModifierCastRangeBonusStacking(params)
    if not self:GetParent():IsHero() then return end
	if params.ability then
		if params.ability.GetCastRange then
			local new = params.ability:GetCastRange(params.ability:GetCaster():GetAbsOrigin(), params.ability:GetCaster()) + self:GetParent():GetCastRangeBonus()
			if new > 0 then
				return (new * 0.5) * -1
			end
		end
	end
end