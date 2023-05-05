modifier_skill_master_chifu = class({})

function modifier_skill_master_chifu:IsHidden() return true end
function modifier_skill_master_chifu:IsPurgable() return false end
function modifier_skill_master_chifu:IsPurgeException() return false end
function modifier_skill_master_chifu:RemoveOnDeath() return false end
function modifier_skill_master_chifu:AllowIllusionDuplicate() return true end

function modifier_skill_master_chifu:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
    return funcs
end

function modifier_skill_master_chifu:GetModifierPreAttack_CriticalStrike( params )
	if not IsServer() then return end
    if RollPercentage(35) then
    	self:GetParent():RemoveGesture(ACT_DOTA_ATTACK_EVENT)
    	self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, self:GetParent():GetAttackSpeed())
    	return 250
    end
end