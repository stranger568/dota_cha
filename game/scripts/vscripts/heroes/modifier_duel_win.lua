modifier_duel_win_6sec = class({})
function modifier_duel_win_6sec:IsHidden() return true end
function modifier_duel_win_6sec:IsPurgable() return false end
function modifier_duel_win_6sec:RemoveOnDeath() return false end

modifier_duel_win_15sec = class({})
function modifier_duel_win_15sec:IsHidden() return true end
function modifier_duel_win_15sec:IsPurgable() return false end
function modifier_duel_win_15sec:RemoveOnDeath() return false end

modifier_duel_vision = class({})
function modifier_duel_vision:IsHidden() return true end
function modifier_duel_vision:IsPurgable() return false end
function modifier_duel_vision:RemoveOnDeath() return false end

function modifier_duel_vision:CheckState()
	if self:GetParent():IsInvisible() then return end
	return 
	{
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end

function modifier_duel_vision:DeclareFunctions()
    local decFuncs = 
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
    return decFuncs
end

function modifier_duel_vision:GetModifierProvidesFOWVision()
	if self:GetParent():IsInvisible() then return end
  	return 1
end
