LinkLuaModifier("modifier_skill_dracarys_debuff", "modifiers/skills/modifier_skill_dracarys", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_dracarys_debuff_cooldown", "modifiers/skills/modifier_skill_dracarys", LUA_MODIFIER_MOTION_NONE)

modifier_skill_dracarys = class({})

function modifier_skill_dracarys:IsHidden() return true end
function modifier_skill_dracarys:IsPurgable() return false end
function modifier_skill_dracarys:IsPurgeException() return false end
function modifier_skill_dracarys:RemoveOnDeath() return false end
function modifier_skill_dracarys:AllowIllusionDuplicate() return true end

function modifier_skill_dracarys:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then
    	local target = params.target
        if not target:IsHero() then return end
        if self:GetParent():HasModifier("modifier_skill_dracarys_debuff_cooldown") then return end
        if target:IsCustomHasDebuffImmune() then return end
        if target:IsMagicImmune() then return end
    	if not self:GetParent():IsIllusion() then
            self:GetCaster():AddNewModifier(self:GetParent(), nil, "modifier_skill_dracarys_debuff_cooldown", {duration = 5})
			target:AddNewModifier(self:GetParent(), nil, "modifier_skill_dracarys_debuff", {duration = 5 * (1 - target:GetStatusResistance())})
		end
    end
end

modifier_skill_dracarys_debuff_cooldown = class({})
function modifier_skill_dracarys_debuff_cooldown:IsHidden() return true end
function modifier_skill_dracarys_debuff_cooldown:IsPurgable() return false end
function modifier_skill_dracarys_debuff_cooldown:RemoveOnDeath() return false end


modifier_skill_dracarys_debuff = class({})
function modifier_skill_dracarys_debuff:GetTexture() return "skill_dracarys" end
function modifier_skill_dracarys_debuff:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1)
end
function modifier_skill_dracarys_debuff:OnIntervalThink()
    if not IsServer() then return end
    ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = 30, damage_type = DAMAGE_TYPE_MAGICAL})
end
function modifier_skill_dracarys_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
function modifier_skill_dracarys_debuff:GetModifierAttackSpeedBonus_Constant()
    return -20
end
function modifier_skill_dracarys_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -10
end