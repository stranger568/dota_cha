LinkLuaModifier("modifier_skill_breaker_debuff", "modifiers/skills/modifier_skill_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_breaker_debuff_cooldown", "modifiers/skills/modifier_skill_breaker", LUA_MODIFIER_MOTION_NONE)

modifier_skill_breaker = class({})

function modifier_skill_breaker:IsHidden() return true end
function modifier_skill_breaker:IsPurgable() return false end
function modifier_skill_breaker:IsPurgeException() return false end
function modifier_skill_breaker:RemoveOnDeath() return false end
function modifier_skill_breaker:AllowIllusionDuplicate() return true end

function modifier_skill_breaker:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then
    	local target = params.target
        if not target:IsHero() then return end
        if self:GetParent():HasModifier("modifier_skill_breaker_debuff_cooldown") then return end
        if self:GetParent():PassivesDisabled() then return end
        if target:IsCustomHasDebuffImmune() then return end
        if target:IsMagicImmune() then return end
    	if not self:GetParent():IsIllusion() then
            self:GetCaster():AddNewModifier(self:GetParent(), nil, "modifier_skill_breaker_debuff_cooldown", {duration = 9})
			target:AddNewModifier(self:GetParent(), nil, "modifier_skill_breaker_debuff", {duration = 3 * (1 - target:GetStatusResistance())})
		end
    end
end

modifier_skill_breaker_debuff_cooldown = class({})
function modifier_skill_breaker_debuff_cooldown:IsHidden() return true end
function modifier_skill_breaker_debuff_cooldown:IsPurgable() return false end
function modifier_skill_breaker_debuff_cooldown:RemoveOnDeath() return false end


modifier_skill_breaker_debuff = class({})
function modifier_skill_breaker_debuff:GetTexture() return "skill_breaker" end
function modifier_skill_breaker_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end
function modifier_skill_breaker_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_break.vpcf"	
end

function modifier_skill_breaker_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW	
end