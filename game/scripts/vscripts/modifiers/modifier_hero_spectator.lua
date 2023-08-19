modifier_hero_spectator = class({})

function modifier_hero_spectator:IsHidden() return true end
function modifier_hero_spectator:IsPurgable() return false end
function modifier_hero_spectator:IsPurgeException() return false end

function modifier_hero_spectator:OnCreated()
	if not IsServer() then return end
	self:GetParent():AddNoDraw()
end

function modifier_hero_spectator:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

function modifier_hero_spectator:IsAura()
    return true
end

function modifier_hero_spectator:GetAuraRadius()
    return -1
end

function modifier_hero_spectator:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_hero_spectator:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_hero_spectator:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_hero_spectator:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_hero_spectator:GetAuraDuration()
    return 0.1
end