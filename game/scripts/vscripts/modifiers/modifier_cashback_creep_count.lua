modifier_cashback_creep_count = class({})

function modifier_cashback_creep_count:IsHidden() return not self:GetParent():HasModifier("modifier_skill_cashback") end
function modifier_cashback_creep_count:IsPurgable() return false end
function modifier_cashback_creep_count:RemoveOnDeath() return false end
function modifier_cashback_creep_count:AllowIllusionDuplicate() return true end

function modifier_cashback_creep_count:OnCreated()
	if not IsServer() then return end
    self.damage = 0
    self.amp = 0
	self:SetStackCount(0)
    self:SetHasCustomTransmitterData(true)
    self:SendBuffRefreshToClients()
end

function modifier_cashback_creep_count:Upgrade(cost)
    if not IsServer() then return end
    self.damage = self.damage + (cost / 1000 * 7)
    self.amp = self.amp + (cost / 1000 * 0.2)
    self:SendBuffRefreshToClients()
end

function modifier_cashback_creep_count:AddCustomTransmitterData()
    return 
    {
        damage = self.damage,
        amp = self.amp,
    }
end

function modifier_cashback_creep_count:HandleCustomTransmitterData( data )
    self.damage = data.damage
    self.amp = data.amp
end

function modifier_cashback_creep_count:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_cashback_creep_count:GetModifierPreAttack_BonusDamage()
    if not self:GetParent():HasModifier("modifier_skill_cashback") then return end
    return self.damage
end

function modifier_cashback_creep_count:GetModifierSpellAmplify_Percentage()
    if not self:GetParent():HasModifier("modifier_skill_cashback") then return end
    return self.amp
end