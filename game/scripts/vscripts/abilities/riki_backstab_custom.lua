LinkLuaModifier("modifier_riki_backstab_custom", "abilities/riki_backstab_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_backstab_custom_invis", "abilities/riki_backstab_custom.lua", LUA_MODIFIER_MOTION_NONE)

riki_backstab_custom = class({})

function riki_backstab_custom:GetIntrinsicModifierName()
    return "modifier_riki_backstab_custom"
end

function riki_backstab_custom:GetCooldown(level)
    return self:GetSpecialValueFor("fade_delay")
end

modifier_riki_backstab_custom = class({})

function modifier_riki_backstab_custom:IsHidden()
    return true
end

function modifier_riki_backstab_custom:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(FrameTime())
end

function modifier_riki_backstab_custom:OnIntervalThink()
    if self:GetAbility():IsFullyCastable() then
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_riki_backstab_custom_invis", {duration = duration})
    else
        self:GetParent():RemoveModifierByName("modifier_riki_backstab_custom_invis")
    end
end

function modifier_riki_backstab_custom:DeclareFunctions()
    local declfuncs = {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}
    return declfuncs
end

function modifier_riki_backstab_custom:GetModifierProcAttack_BonusDamage_Physical(params)
    if not IsServer() then return end
    if self:GetParent():PassivesDisabled() then return end
    if params.target:IsWard() then return end
    if params.no_attack_cooldown then return end

    if not self:GetCaster():HasShard() then
        if self:GetParent():IsIllusion() then return end
    end

    self:GetAbility():UseResources(false,false,false,true)

    local agility_damage_multiplier = self:GetAbility():GetSpecialValueFor("damage_multiplier")
    local victim_angle = params.target:GetAnglesAsVector().y
    local origin_difference = params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()
    local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
    origin_difference_radian = origin_difference_radian * 180
    local attacker_angle = origin_difference_radian / math.pi
    attacker_angle = attacker_angle + 180.0
    local result_angle = attacker_angle - victim_angle
    result_angle = math.abs(result_angle)
    params.target:EmitSound("Hero_Riki.Backstab")
    if target:IsHero() then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target) 
        ParticleManager:SetParticleControlEnt(particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)
    end
    local end_damage = params.attacker:GetAgility() * agility_damage_multiplier
    if not params.target:IsHero() then
        end_damage = end_damage * 2
    end
    return end_damage
end

modifier_riki_backstab_custom_invis = class({})

function modifier_riki_backstab_custom_invis:IsHidden()
    return true
end

function modifier_riki_backstab_custom_invis:OnCreated()
    if not IsServer() then return end
    local particle = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_riki_backstab_custom_invis:DeclareFunctions()
    return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
end

function modifier_riki_backstab_custom_invis:GetModifierInvisibilityLevel()
    return 1
end

function modifier_riki_backstab_custom_invis:CheckState()
    local state = { [MODIFIER_STATE_INVISIBLE] = true}
    return state
end