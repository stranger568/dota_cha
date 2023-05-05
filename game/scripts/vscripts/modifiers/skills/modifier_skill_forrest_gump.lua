modifier_skill_forrest_gump = class({})

function modifier_skill_forrest_gump:IsHidden() return true end
function modifier_skill_forrest_gump:IsPurgable() return false end
function modifier_skill_forrest_gump:IsPurgeException() return false end
function modifier_skill_forrest_gump:RemoveOnDeath() return false end
function modifier_skill_forrest_gump:AllowIllusionDuplicate() return true end

function modifier_skill_forrest_gump:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end

function modifier_skill_forrest_gump:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_skill_forrest_gump:GetModifierMoveSpeedBonus_Constant()
	return 200
end

function modifier_skill_forrest_gump:GetModifierMoveSpeed_Max( params )
	return 10000
end

function modifier_skill_forrest_gump:GetModifierMoveSpeed_Limit( params )
	return 10000
end

function modifier_skill_forrest_gump:GetModifierIgnoreMovespeedLimit( params )
    return 1
end