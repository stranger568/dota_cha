LinkLuaModifier("modifier_skill_intimidation_debuff_cooldown", "modifiers/skills/modifier_skill_intimidation", LUA_MODIFIER_MOTION_NONE)

modifier_skill_intimidation = class({})

function modifier_skill_intimidation:IsHidden() return true end
function modifier_skill_intimidation:IsPurgable() return false end
function modifier_skill_intimidation:IsPurgeException() return false end
function modifier_skill_intimidation:RemoveOnDeath() return false end
function modifier_skill_intimidation:AllowIllusionDuplicate() return true end

function modifier_skill_intimidation:AttackLandedModifier(params)
    if params.attacker ~= self:GetParent() and params.target == self:GetParent() then
    	local target = params.attacker
        if not target:IsHero() then return end
        if self:GetParent():HasModifier("modifier_skill_intimidation_debuff_cooldown") then return end
        if self:GetParent():PassivesDisabled() then return end
        if target:IsCustomHasDebuffImmune() then return end
        if target:IsMagicImmune() then return end
    	if not self:GetParent():IsIllusion() then
            self:GetCaster():AddNewModifier(self:GetParent(), nil, "modifier_skill_intimidation_debuff_cooldown", {duration = 6})
			target:AddNewModifier(self:GetParent(), nil, "modifier_nevermore_requiem_fear", {duration = 1.5 * (1 - target:GetStatusResistance())})
		end
    end
end

modifier_skill_intimidation_debuff_cooldown = class({})
function modifier_skill_intimidation_debuff_cooldown:IsHidden() return true end
function modifier_skill_intimidation_debuff_cooldown:IsPurgable() return false end
function modifier_skill_intimidation_debuff_cooldown:RemoveOnDeath() return false end