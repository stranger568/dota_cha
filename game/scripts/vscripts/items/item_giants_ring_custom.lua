LinkLuaModifier("modifier_item_giants_ring_custom", "items/item_giants_ring_custom", LUA_MODIFIER_MOTION_NONE)

item_giants_ring_custom = class({})

function item_giants_ring_custom:GetIntrinsicModifierName()
	return "modifier_item_giants_ring_custom"
end

modifier_item_giants_ring_custom = class({})

function modifier_item_giants_ring_custom:IsHidden() return true end
function modifier_item_giants_ring_custom:IsPurgable() return false end
function modifier_item_giants_ring_custom:IsPurgeException() return false end
function modifier_item_giants_ring_custom:RemoveOnDeath() return false end

function modifier_item_giants_ring_custom:OnCreated(table)
    if not IsServer() then return end
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_radius = self.ability:GetSpecialValueFor("damage_radius")
    self.pct_str_damage_per_second = self.ability:GetSpecialValueFor("pct_str_damage_per_second") / 100
    self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength")
    self.movement_speed = self.ability:GetSpecialValueFor("movement_speed")
    self.model_scale = self.ability:GetSpecialValueFor("model_scale") 
    self:StartIntervalThink(0.5)
end

function modifier_item_giants_ring_custom:OnIntervalThink()
    if not IsServer() then return end
    if self.parent:IsAlive() then 
        local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
        for _,enemy in pairs(enemies) do
            local damageTable = { victim = enemy, attacker = self.parent, damage = self.parent:GetStrength() * self.pct_str_damage_per_second * 0.5 , damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability, damage_flags = DOTA_DAMAGE_FLAG_NONE }
            ApplyDamage(damageTable)
        end
    end
end

function modifier_item_giants_ring_custom:CheckState()
    return
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
    }
end

function modifier_item_giants_ring_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end

function modifier_item_giants_ring_custom:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_item_giants_ring_custom:GetModifierMoveSpeedBonus_Constant()
    return self.movement_speed
end

function modifier_item_giants_ring_custom:GetModifierModelScale() 
    return self.model_scale
end