LinkLuaModifier("modifier_smoke_of_deceit_cha_custom", "items/smoke", LUA_MODIFIER_MOTION_NONE)

item_smoke_of_deceit_custom = class({})

function item_smoke_of_deceit_custom:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.SmokeOfDeceit.Activate")
    local particle = ParticleManager:CreateParticle("particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(800, 1, 800))
    ParticleManager:ReleaseParticleIndex(particle)

    local area = FindUnitsInRadius( self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
    if area[1] then return end

    local targets = FindUnitsInRadius( self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("application_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )

    local duration = self:GetSpecialValueFor("duration")

    if self:GetCaster():HasModifier("modifier_skill_smoker") then
        duration = duration + duration
    end

    for k, v in pairs(targets) do
        print(v:IsHero(), v:IsTempestDouble(), v:HasModifier("modifier_arc_warden_tempest_double_lua"))
       -- if v:IsHero() or (v:IsTempestDouble() and v:HasModifier("modifier_arc_warden_tempest_double_lua")) or (v:GetUnitName() == "npc_dota_lone_druid_bear1" or v:GetUnitName() == "npc_dota_lone_druid_bear2" or v:GetUnitName() == "npc_dota_lone_druid_bear3" or v:GetUnitName() == "npc_dota_lone_druid_bear4") then
            ProjectileManager:ProjectileDodge(v)
            v:AddNewModifier(self:GetCaster(), nil, "modifier_smoke_of_deceit_cha_custom", {duration = duration})
       --- end
    end

    --if self:GetCaster().tempest_double_hClone and self:GetCaster().tempest_double_hClone:IsAlive() then
    --    ProjectileManager:ProjectileDodge(self:GetCaster().tempest_double_hClone)
    --    self:GetCaster().tempest_double_hClone:AddNewModifier(self:GetCaster(), nil, "modifier_smoke_of_deceit_cha_custom", {duration = self:GetSpecialValueFor("duration")})
    --end
    
    self:SpendCharge()
end

modifier_smoke_of_deceit_cha_custom = class({})

function modifier_smoke_of_deceit_cha_custom:IsPurgable() return false end

function modifier_smoke_of_deceit_cha_custom:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_smoke_of_deceit_cha_custom:HeroEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end


function modifier_smoke_of_deceit_cha_custom:GetTexture() return "item_smoke_of_deceit" end




function modifier_smoke_of_deceit_cha_custom:OnCreated(args)
    if not IsServer() then return end
    self.radius = 1200
    self:StartIntervalThink(FrameTime())
end

function modifier_smoke_of_deceit_cha_custom:OnIntervalThink()
    local parent = self:GetParent()
    self:GetParent():RemoveModifierByName("modifier_gem_active_truesight")
    self:GetParent():RemoveModifierByName("modifier_truesight")
    self:GetParent():RemoveModifierByName("modifier_item_dustofappearance")
    local area = FindUnitsInRadius( self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
    if area[1] then self:Destroy() end
end

function modifier_smoke_of_deceit_cha_custom:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
    }
end

function modifier_smoke_of_deceit_cha_custom:GetEffectName()
    return "particles/items2_fx/smoke_of_deceit_buff.vpcf"
end

function modifier_smoke_of_deceit_cha_custom:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_smoke_of_deceit_cha_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ALWAYS_AUTOATTACK_WHILE_HOLD_POSITION,
        MODIFIER_PROPERTY_INVISIBILITY_ATTACK_BEHAVIOR_EXCEPTION,
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_smoke_of_deceit_cha_custom:GetModifierInvisibilityLevel()
    return 1
end

function modifier_smoke_of_deceit_cha_custom:GetModifierInvisibilityAttackBehaviorException()
    return 1
end

function modifier_smoke_of_deceit_cha_custom:GetModifierPersistentInvisibility()
    return 1
end

function modifier_smoke_of_deceit_cha_custom:GetAlwaysAutoAttackWhileHoldPosition()
    return 1
end

function modifier_smoke_of_deceit_cha_custom:GetModifierMoveSpeedBonus_Percentage()
    return 15
end

function modifier_smoke_of_deceit_cha_custom:GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetParent():HasModifier("modifier_skill_hookah_master") then return end
    return 20
end