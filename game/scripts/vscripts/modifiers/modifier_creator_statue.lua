modifier_creator_statue = class({})

function modifier_creator_statue:IsHidden() return true end
function modifier_creator_statue:IsPurgable() return false end
function modifier_creator_statue:IsPurgeException() return false end

function modifier_creator_statue:CheckState()
	return {[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
}
end