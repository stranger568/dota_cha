LinkLuaModifier("modifier_ninja_gear_custom", "items/item_ninja_gear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ninja_gear_custom_passive", "items/item_ninja_gear_custom", LUA_MODIFIER_MOTION_NONE)

item_ninja_gear_custom = class({})

function item_ninja_gear_custom:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.SmokeOfDeceit.Activate")
    local particle = ParticleManager:CreateParticle("particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(800, 1, 800))
    ParticleManager:ReleaseParticleIndex(particle)
    local area = FindUnitsInRadius( self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
    if area[1] then return end
    local duration = self:GetSpecialValueFor("duration")
    ProjectileManager:ProjectileDodge(self:GetCaster())
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ninja_gear_custom", {duration = duration})
end

function item_ninja_gear_custom:GetIntrinsicModifierName()
    return "modifier_ninja_gear_custom_passive"
end

modifier_ninja_gear_custom_passive = class({})

function modifier_ninja_gear_custom_passive:IsHidden() return true end
function modifier_ninja_gear_custom_passive:IsPurgable() return false end
function modifier_ninja_gear_custom_passive:RemoveOnDeath() return false end

function modifier_ninja_gear_custom_passive:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_ninja_gear_custom_passive:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("passive_movement_bonus")
end

function modifier_ninja_gear_custom_passive:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

modifier_ninja_gear_custom = class({})
function modifier_ninja_gear_custom:IsPurgable() return false end
function modifier_ninja_gear_custom:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_ninja_gear_custom:HeroEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_ninja_gear_custom:GetTexture() return "item_ninja_gear" end

function modifier_ninja_gear_custom:OnCreated(args)
    if not IsServer() then return end
    self.radius = 1200
    self.parent = self:GetParent()
    self:StartIntervalThink(FrameTime())
end

function modifier_ninja_gear_custom:OnIntervalThink()
    if not IsServer() then return end
    self.parent:RemoveModifierByName("modifier_gem_active_truesight")
    self.parent:RemoveModifierByName("modifier_truesight")
    self.parent:RemoveModifierByName("modifier_item_dustofappearance")
    local area = FindUnitsInRadius( self.parent:GetTeam(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
    if area[1] then self:Destroy() end
end

function modifier_ninja_gear_custom:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
    }
end

function modifier_ninja_gear_custom:GetEffectName()
    return "particles/items2_fx/smoke_of_deceit_buff.vpcf"
end

function modifier_ninja_gear_custom:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ninja_gear_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ALWAYS_AUTOATTACK_WHILE_HOLD_POSITION,
        MODIFIER_PROPERTY_INVISIBILITY_ATTACK_BEHAVIOR_EXCEPTION,
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_ninja_gear_custom:GetModifierInvisibilityLevel()
    return 1
end

function modifier_ninja_gear_custom:GetModifierInvisibilityAttackBehaviorException()
    return 1
end

function modifier_ninja_gear_custom:GetModifierPersistentInvisibility()
    return 1
end

function modifier_ninja_gear_custom:GetAlwaysAutoAttackWhileHoldPosition()
    return 1
end

function modifier_ninja_gear_custom:GetModifierMoveSpeedBonus_Constant()
    return 25
end

function modifier_ninja_gear_custom:GetModifierTotalDamageOutgoing_Percentage()
    if not self.parent:HasModifier("modifier_skill_hookah_master") then return end
    return 20
end

function modifier_ninja_gear_custom:AttackLandedModifier(params)
    if not IsServer() then return end
    if params.attacker ~= self.parent then return end
    self:Destroy()
end