modifier_skill_disregarding = class({})

function modifier_skill_disregarding:IsHidden() return true end
function modifier_skill_disregarding:IsPurgable() return false end
function modifier_skill_disregarding:IsPurgeException() return false end
function modifier_skill_disregarding:RemoveOnDeath() return false end
function modifier_skill_disregarding:AllowIllusionDuplicate() return true end

function modifier_skill_disregarding:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_skill_disregarding:GetModifierTotal_ConstantBlock(kv)
    if IsServer() then
        local target = self:GetParent()
        if kv.damage > 0 and RollPercentage(30) then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
            return kv.damage
        end
    end
end