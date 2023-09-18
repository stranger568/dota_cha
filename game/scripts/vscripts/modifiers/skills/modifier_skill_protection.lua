LinkLuaModifier("modifier_skill_protection_buff", "modifiers/skills/modifier_skill_protection", LUA_MODIFIER_MOTION_NONE)

modifier_skill_protection = class({})

function modifier_skill_protection:IsHidden() return true end
function modifier_skill_protection:IsPurgable() return false end
function modifier_skill_protection:IsPurgeException() return false end
function modifier_skill_protection:RemoveOnDeath() return false end
function modifier_skill_protection:AllowIllusionDuplicate() return true end

function modifier_skill_protection:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(0)
    self:StartIntervalThink(0.1)
end

function modifier_skill_protection:OnIntervalThink()
    if not IsServer() then return end
    if self:GetStackCount() >= 30 then
        local modifier_skill_protection_buff = self:GetParent():FindModifierByName("modifier_skill_protection_buff")
        if modifier_skill_protection_buff and modifier_skill_protection_buff:GetStackCount() >= 8 then
            self:SetStackCount(0)
            return
        end
        self:SetStackCount(self:GetStackCount() - 30)
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_protection_buff", {duration = 10})
    end
end

function modifier_skill_protection:TakeDamageScriptModifier(params)
    if params.unit == self:GetParent() then
        if modifier_skill_protection_buff and modifier_skill_protection_buff:GetStackCount() >= 8 then
            return
        end
        self:SetStackCount(self:GetStackCount() + params.damage)
    end
end

modifier_skill_protection_buff = class({})
function modifier_skill_protection_buff:IsPurgable() return false end
function modifier_skill_protection_buff:IsPurgeException() return false end
function modifier_skill_protection_buff:GetTexture() return "skill_protection" end
function modifier_skill_protection_buff:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(1)
end
function modifier_skill_protection_buff:OnRefresh()
    if not IsServer() then return end
    if self:GetStackCount() < 8 then
        self:IncrementStackCount()
    end
end
function modifier_skill_protection_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end
function modifier_skill_protection_buff:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * 3
end
function modifier_skill_protection_buff:GetModifierMagicalResistanceBonus()
    return self:GetStackCount() * 3
end