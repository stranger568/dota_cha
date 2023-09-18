modifier_skill_creephater = class({})
function modifier_skill_creephater:IsHidden() return true end
function modifier_skill_creephater:IsPurgable() return false end
function modifier_skill_creephater:IsPurgeException() return false end
function modifier_skill_creephater:RemoveOnDeath() return false end
function modifier_skill_creephater:AllowIllusionDuplicate() return true end
function modifier_skill_creephater:OnCreated()
    if not IsServer() then return end
    self.activated = true
end
function modifier_skill_creephater:OnDeathEvent(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.unit:IsHero() then return end
    if params.target and params.unit.buy_creep ~= nil then
        local gold = params.unit:GetMaximumGoldBounty()
        self:GetParent():ModifyGold(gold*10, true, 0)
    elseif self.activated == true then
        local gold = params.unit:GetMaximumGoldBounty()
        self:GetParent():ModifyGold(gold*10, true, 0)
        self.activated = false
    end
end
