bounty_hunter_jinada_custom = class({})

LinkLuaModifier( "modifier_bounty_hunter_jinada_custom_passive", "heroes/hero_bounty/bounty_hunter_jinada_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_hunter_jinada_custom_crit", "heroes/hero_bounty/bounty_hunter_jinada_custom", LUA_MODIFIER_MOTION_NONE )

function bounty_hunter_jinada_custom:GetIntrinsicModifierName()
    return "modifier_bounty_hunter_jinada_custom_passive"
end

modifier_bounty_hunter_jinada_custom_passive = class({})

function modifier_bounty_hunter_jinada_custom_passive:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_bounty_hunter_jinada_custom_passive:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(FrameTime())
end

function modifier_bounty_hunter_jinada_custom_passive:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if ability:IsFullyCastable() then
        if not caster:HasModifier("modifier_bounty_hunter_jinada_custom_crit") then
            caster:AddNewModifier(caster, ability, "modifier_bounty_hunter_jinada_custom_crit", {})
        end
    else
        self:GetParent():RemoveModifierByName("modifier_bounty_hunter_jinada_custom_crit")
    end
end

function modifier_bounty_hunter_jinada_custom_passive:IsHidden()
    return true
end

function modifier_bounty_hunter_jinada_custom_passive:IsPurgable()
    return false
end

function modifier_bounty_hunter_jinada_custom_passive:IsDebuff()
    return false
end

modifier_bounty_hunter_jinada_custom_crit = class({})

function modifier_bounty_hunter_jinada_custom_crit:IsPurgable() return false end
function modifier_bounty_hunter_jinada_custom_crit:IsHidden() return true end

function modifier_bounty_hunter_jinada_custom_crit:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.particle_glow_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_l.vpcf", PATTACH_ABSORIGIN, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle_glow_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon1", self.parent:GetAbsOrigin(), true)
        self:AddParticle(self.particle_glow_fx, false, false, -1, false, false)
        self.particle_glow_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_l.vpcf", PATTACH_ABSORIGIN, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle_glow_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon2", self.parent:GetAbsOrigin(), true)
        self:AddParticle(self.particle_glow_fx, false, false, -1, false, false)
    end
end

function modifier_bounty_hunter_jinada_custom_crit:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_bounty_hunter_jinada_custom_crit:AttackLandedModifier( params )
    if not IsServer() then return end
    local parent = self:GetParent()
    local target = params.target
    if parent == params.attacker and target:GetTeamNumber() ~= parent:GetTeamNumber() then
        self:GetParent():EmitSound("Hero_BountyHunter.Jinada")
        self.particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(self.particle_hit_fx, 0, target:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(self.particle_hit_fx)
        self:GetAbility():UseResources(false, false, false, true)

        if target:IsRealHero() then
            self.money_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinada.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt(self.money_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(self.money_particle)
            local gold = self:GetAbility():GetSpecialValueFor("gold_steal")
            self:GetParent():ModifyGold(gold, true, 0)
            params.target:SpendGold(gold, 0)
            SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_GOLD, self:GetParent(), gold, nil)
        end
        
        self:Destroy()
    end
end

function modifier_bounty_hunter_jinada_custom_crit:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end