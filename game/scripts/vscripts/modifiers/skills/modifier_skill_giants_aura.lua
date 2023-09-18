LinkLuaModifier("modifier_skill_giants_aura_debuff", "modifiers/skills/modifier_skill_giants_aura", LUA_MODIFIER_MOTION_NONE)

modifier_skill_giants_aura = class({})
function modifier_skill_giants_aura:IsHidden() return true end
function modifier_skill_giants_aura:IsPurgable() return false end
function modifier_skill_giants_aura:IsPurgeException() return false end
function modifier_skill_giants_aura:RemoveOnDeath() return false end
function modifier_skill_giants_aura:AllowIllusionDuplicate() return true end
function modifier_skill_giants_aura:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(3)
    local particle = ParticleManager:CreateParticle("particles/particle_giants_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
end

function modifier_skill_giants_aura:IsAura() return true end

function modifier_skill_giants_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_skill_giants_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skill_giants_aura:GetModifierAura()
	return "modifier_skill_giants_aura_debuff"
end

function modifier_skill_giants_aura:GetAuraRadius()
	return 800
end

function modifier_skill_giants_aura:GetAuraDuration()
	return 1
end

modifier_skill_giants_aura_debuff = class({})
function modifier_skill_giants_aura_debuff:IsDebuff() return true end
function modifier_skill_giants_aura_debuff:IsPurgable() return false end
function modifier_skill_giants_aura_debuff:GetTexture() return "skill_giants_aura" end
function modifier_skill_giants_aura_debuff:OnCreated()
    if not IsServer() then return end
    self.status = self:GetParent():GetStatusResistance()*100 * -1
    self:SetHasCustomTransmitterData(true)
    self:StartIntervalThink(1)
    self:SendBuffRefreshToClients()
end

function modifier_skill_giants_aura_debuff:OnIntervalThink()
    if not IsServer() then return end
    self.status = 0
    self.status = self:GetParent():GetStatusResistance()*100 * -1
    self:SendBuffRefreshToClients()
end

function modifier_skill_giants_aura_debuff:AddCustomTransmitterData()
    return 
    {
        status = self.status,
    }
end

function modifier_skill_giants_aura_debuff:HandleCustomTransmitterData( data )
    self.status = data.status
end

function modifier_skill_giants_aura_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION
	}
end
function modifier_skill_giants_aura_debuff:GetModifierStatusResistanceStacking()
    if self:GetParent():IsDebuffImmune() then return end
	return self.status
end
function modifier_skill_giants_aura_debuff:GetModifierMagicalResistanceDirectModification()
    if self:GetParent():IsDebuffImmune() then return end
	return -20
end