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