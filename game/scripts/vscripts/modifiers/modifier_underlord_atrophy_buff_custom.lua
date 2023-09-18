modifier_underlord_atrophy_buff_custom = class({})
function modifier_underlord_atrophy_buff_custom:IsHidden() return false end
function modifier_underlord_atrophy_buff_custom:IsPurgeException() return false end
function modifier_underlord_atrophy_buff_custom:IsPurgable() return false end
function modifier_underlord_atrophy_buff_custom:RemoveOnDeath() return false end
function modifier_underlord_atrophy_buff_custom:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(FrameTime())
end
function modifier_underlord_atrophy_buff_custom:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetParent():HasAbility("abyssal_underlord_atrophy_aura") then
        self:Destroy()
    end
end
function modifier_underlord_atrophy_buff_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end
function modifier_underlord_atrophy_buff_custom:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end
function modifier_underlord_atrophy_buff_custom:OnDeathEvent(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if not params.unit:IsHero() then
        self:SetStackCount(self:GetStackCount() + self:GetAbility():GetSpecialValueFor("bonus_damage_from_creep_unique"))
    end
end