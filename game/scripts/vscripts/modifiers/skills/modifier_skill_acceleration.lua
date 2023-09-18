LinkLuaModifier("modifier_skill_acceleration_buff", "modifiers/skills/modifier_skill_acceleration", LUA_MODIFIER_MOTION_NONE)

modifier_skill_acceleration = class({})

function modifier_skill_acceleration:IsHidden() return true end
function modifier_skill_acceleration:IsPurgable() return false end
function modifier_skill_acceleration:IsPurgeException() return false end
function modifier_skill_acceleration:RemoveOnDeath() return false end
function modifier_skill_acceleration:AllowIllusionDuplicate() return true end

function modifier_skill_acceleration:OnAbilityfullCastCustom(params)
    if params.unit == self:GetParent() then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_acceleration_buff", {duration = 10})
    end
end

modifier_skill_acceleration_buff = class({})
function modifier_skill_acceleration_buff:IsPurgable() return false end
function modifier_skill_acceleration_buff:IsPurgeException() return false end
function modifier_skill_acceleration_buff:GetTexture() return "skill_acceleration" end
function modifier_skill_acceleration_buff:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(1)
end
function modifier_skill_acceleration_buff:OnRefresh()
    if not IsServer() then return end
    if self:GetStackCount() < 5 then
        self:IncrementStackCount()
    end
end
function modifier_skill_acceleration_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end
function modifier_skill_acceleration_buff:GetModifierAttackSpeedBonus_Constant()
    return self:GetStackCount() * 20
end
function modifier_skill_acceleration_buff:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount() * 10
end