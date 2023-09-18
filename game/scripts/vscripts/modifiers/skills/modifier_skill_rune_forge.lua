modifier_skill_rune_forge = class({})
function modifier_skill_rune_forge:IsHidden() return true end
function modifier_skill_rune_forge:IsPurgable() return false end
function modifier_skill_rune_forge:IsPurgeException() return false end
function modifier_skill_rune_forge:RemoveOnDeath() return false end
function modifier_skill_rune_forge:AllowIllusionDuplicate() return true end
function modifier_skill_rune_forge:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(15)
end
function modifier_skill_rune_forge:OnIntervalThink()
    if not IsServer() then return end
    local runes = {"haste", "dd", "shield", "arcane", "bounty"}
    local current = runes[RandomInt(1, #runes)]
    if current == "bounty" then
        local rune = CreateRune(self:GetParent():GetAbsOrigin(), 5)
        self:GetParent():PickupRune(rune)
    elseif current == "haste" then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_rune_haste", {duration = 20})
    elseif current == "dd" then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_rune_doubledamage", {duration = 20})
    elseif current == "shield" then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_rune_shield", {duration = 20})
    elseif current == "arcane" then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_rune_arcane", {duration = 20})
    end
end