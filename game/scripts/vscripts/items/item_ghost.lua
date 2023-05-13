LinkLuaModifier("modifier_item_ghost", "items/item_ghost.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ghost_active", "items/item_ghost.lua", LUA_MODIFIER_MOTION_NONE)

item_ghost_custom = class({})

function item_ghost_custom:GetIntrinsicModifierName()
    return "modifier_item_ghost"
end

function item_ghost_custom:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.GhostScepter.Activate")
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_ghost_active", {duration = duration})
end

modifier_item_ghost = class({})

function modifier_item_ghost:IsHidden()       return true end
function modifier_item_ghost:IsPurgable()     return false end
function modifier_item_ghost:RemoveOnDeath()  return false end

function modifier_item_ghost:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_item_ghost:GetModifierBonusStats_Strength()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    end
end

function modifier_item_ghost:GetModifierBonusStats_Agility()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    end
end

function modifier_item_ghost:GetModifierBonusStats_Intellect()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    end
end

modifier_item_ghost_active = class({})

function modifier_item_ghost_active:IsPurgable() return true end
function modifier_item_ghost_active:IsPurgeException() return true end

function modifier_item_ghost_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ghost_active:OnCreated()
    self.ability                    = self:GetAbility()
    self.caster                     = self:GetCaster()
    self.parent                     = self:GetParent()
    self.extra_spell_damage_percent      = self.ability:GetSpecialValueFor("extra_spell_damage_percent")
end

function modifier_item_ghost_active:OnRefresh()
    self:OnCreated()
end

function modifier_item_ghost_active:CheckState()
    local state = {
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_DISARMED] = true
    }
    
    return state
end

function modifier_item_ghost_active:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    }
    
    return decFuncs
end

function modifier_item_ghost_active:GetModifierMagicalResistanceDecrepifyUnique()
    return self.extra_spell_damage_percent
end

function modifier_item_ghost_active:GetAbsoluteNoDamagePhysical()
    return 1
end