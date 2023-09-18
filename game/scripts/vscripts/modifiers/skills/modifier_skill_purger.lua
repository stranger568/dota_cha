LinkLuaModifier("modifier_skill_purger_debuff", "modifiers/skills/modifier_skill_purger", LUA_MODIFIER_MOTION_NONE)

modifier_skill_purger = class({})
function modifier_skill_purger:IsHidden() return true end
function modifier_skill_purger:IsPurgable() return false end
function modifier_skill_purger:IsPurgeException() return false end
function modifier_skill_purger:RemoveOnDeath() return false end
function modifier_skill_purger:AllowIllusionDuplicate() return true end
function modifier_skill_purger:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(3)
    local particle = ParticleManager:CreateParticle("particles/aura_purger_skill_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(800,800,800))
end
function modifier_skill_purger:OnIntervalThink()
    if not IsServer() then return end
    local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
        enemy:Purge(true, false, false, false, false)
    end
end

function modifier_skill_purger:IsAura() return true end

function modifier_skill_purger:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_purger:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_purger:GetModifierAura()
	return "modifier_skill_purger_debuff"
end

function modifier_skill_purger:GetAuraRadius()
	return 800
end

function modifier_skill_purger:GetAuraDuration()
	return 1
end

modifier_skill_purger_debuff = class({})
function modifier_skill_purger_debuff:IsDebuff() return true end
function modifier_skill_purger_debuff:IsPurgable() return false end
function modifier_skill_purger_debuff:GetTexture() return "skill_purger" end
function modifier_skill_purger_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function modifier_skill_purger_debuff:GetModifierPercentageCooldown()
	return -20
end