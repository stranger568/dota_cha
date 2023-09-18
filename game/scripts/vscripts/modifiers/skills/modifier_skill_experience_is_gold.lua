modifier_skill_experience_is_gold = class({})
function modifier_skill_experience_is_gold:IsHidden() return true end
function modifier_skill_experience_is_gold:IsPurgable() return false end
function modifier_skill_experience_is_gold:IsPurgeException() return false end
function modifier_skill_experience_is_gold:RemoveOnDeath() return false end
function modifier_skill_experience_is_gold:AllowIllusionDuplicate() return true end
function modifier_skill_experience_is_gold:RoundEnd()
    if not IsServer() then return end
    local gold = self:GetParent():GetLevel() * 15
    self:GetParent():ModifyGold(gold, true, 0)
end