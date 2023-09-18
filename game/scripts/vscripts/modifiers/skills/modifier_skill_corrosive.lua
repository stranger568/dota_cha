LinkLuaModifier("modifier_skill_corrosive_debuff", "modifiers/skills/modifier_skill_corrosive", LUA_MODIFIER_MOTION_NONE)

modifier_skill_corrosive = class({})

function modifier_skill_corrosive:IsHidden() return true end
function modifier_skill_corrosive:IsPurgable() return false end
function modifier_skill_corrosive:IsPurgeException() return false end
function modifier_skill_corrosive:RemoveOnDeath() return false end
function modifier_skill_corrosive:AllowIllusionDuplicate() return true end

function modifier_skill_corrosive:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then
    	local target = params.target
        if target:IsCustomHasDebuffImmune() then return end
        if target:IsMagicImmune() then return end
    	if not self:GetParent():IsIllusion() then
            target:AddNewModifier(self:GetParent(), nil, "modifier_skill_corrosive_debuff", {duration = 4 * (1 - target:GetStatusResistance())})
		end
    end
end

modifier_skill_corrosive_debuff = class({})
function modifier_skill_corrosive_debuff:GetTexture() return "skill_corrosive" end
function modifier_skill_corrosive_debuff:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(1)
end
function modifier_skill_corrosive_debuff:OnRefresh()
    if not IsServer() then return end
    if self:GetStackCount() < 7 then
        self:IncrementStackCount()
    end
end
function modifier_skill_corrosive_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    }
end
function modifier_skill_corrosive_debuff:GetModifierStatusResistanceStacking()
    return self:GetStackCount() * -3
end