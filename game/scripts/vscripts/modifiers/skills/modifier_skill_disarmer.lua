LinkLuaModifier("modifier_skill_disarmer_debuff", "modifiers/skills/modifier_skill_disarmer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_disarmer_debuff_cooldown", "modifiers/skills/modifier_skill_disarmer", LUA_MODIFIER_MOTION_NONE)

modifier_skill_disarmer = class({})

function modifier_skill_disarmer:IsHidden() return true end
function modifier_skill_disarmer:IsPurgable() return false end
function modifier_skill_disarmer:IsPurgeException() return false end
function modifier_skill_disarmer:RemoveOnDeath() return false end
function modifier_skill_disarmer:AllowIllusionDuplicate() return true end

function modifier_skill_disarmer:TakeDamageScriptModifier(params)
    if params.attacker == self:GetParent() then
    	local target = params.unit
        if not target:IsHero() then return end
        if target == self:GetParent() then return end
        if self:GetParent():HasModifier("modifier_skill_disarmer_debuff_cooldown") then return end
        if self:GetParent():PassivesDisabled() then return end
        if target:IsCustomHasDebuffImmune() then return end
        if target:IsMagicImmune() then return end
    	if not self:GetParent():IsIllusion() then
            self:GetCaster():AddNewModifier(self:GetParent(), nil, "modifier_skill_disarmer_debuff_cooldown", {duration = 7})
			target:AddNewModifier(self:GetParent(), nil, "modifier_skill_disarmer_debuff", {duration = 3 * (1 - target:GetStatusResistance())})
		end
    end
end

modifier_skill_disarmer_debuff_cooldown = class({})
function modifier_skill_disarmer_debuff_cooldown:IsHidden() return true end
function modifier_skill_disarmer_debuff_cooldown:IsPurgable() return false end
function modifier_skill_disarmer_debuff_cooldown:RemoveOnDeath() return false end


modifier_skill_disarmer_debuff = class({})
function modifier_skill_disarmer_debuff:GetTexture() return "skill_disarmer" end
function modifier_skill_disarmer_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_DISARMED] = true,
    }
end
function modifier_skill_disarmer_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"	
end

function modifier_skill_disarmer_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW	
end