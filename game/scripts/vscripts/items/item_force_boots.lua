LinkLuaModifier( "modifier_item_force_boots_custom", "items/item_force_boots", LUA_MODIFIER_MOTION_NONE )

item_force_boots_custom = class({})

function item_force_boots_custom:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_force_boots_active', {push_length = self:GetSpecialValueFor("push_length"), duration = self:GetSpecialValueFor("push_duration")})
    self:GetCaster():RemoveGesture(ACT_DOTA_DISABLED)
    self:GetCaster():Purge(false, true, false, false, false)
    EmitSoundOn('DOTA_Item.ForceStaff.Activate', self:GetCaster())
end

function item_force_boots_custom:GetIntrinsicModifierName() 
    return "modifier_item_force_boots_custom"
end

modifier_item_force_boots_custom = class({})

function modifier_item_force_boots_custom:IsHidden()
    return true
end

function modifier_item_force_boots_custom:IsPurgable()
    return false
end

function modifier_item_force_boots_custom:DeclareFunctions()
return  {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
            MODIFIER_PROPERTY_HEALTH_BONUS,
            MODIFIER_PROPERTY_MOVESPEED_MAX,
            MODIFIER_PROPERTY_MOVESPEED_LIMIT,
            MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        }
end

function modifier_item_force_boots_custom:GetModifierHealthBonus()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor('hp_regen')
    end
end

function modifier_item_force_boots_custom:GetModifierMoveSpeedBonus_Special_Boots()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
    end
end

function modifier_item_force_boots_custom:GetModifierMoveSpeed_Max( params )
    return 30000
end

function modifier_item_force_boots_custom:GetModifierMoveSpeed_Limit( params )
    return 30000
end

function modifier_item_force_boots_custom:GetModifierIgnoreMovespeedLimit( params )
    return 1
end