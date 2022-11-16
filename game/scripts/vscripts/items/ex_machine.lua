LinkLuaModifier("modifier_item_ex_machina_custom", "items/ex_machine", LUA_MODIFIER_MOTION_NONE)

item_ex_machina_custom = class({})

item_ex_machina_custom.NotRefresh = {
    ["item_refresher_custom"] = true,
    ["item_refresher"] = true,
    ["item_refresher_shard"] = true,
    ["item_ex_machina_custom"] = true,
    ["item_black_king_bar"] = true,
}

function item_ex_machina_custom:NotRefresher( item )
    return self.NotRefresh[item:GetName()]
end

function item_ex_machina_custom:GetIntrinsicModifierName()
    return "modifier_item_ex_machina_custom"
end

function item_ex_machina_custom:IsRefreshable()
    return false
end

function item_ex_machina_custom:OnSpellStart()
    for i=0,8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if not self:NotRefresher( item ) then
                item:EndCooldown()
            end
        end
    end

    local item_neutral = self:GetCaster():GetItemInSlot(16)
    if item_neutral then
        if not self:NotRefresher( item_neutral ) then
            item_neutral:EndCooldown()
        end
    end

    self:GetCaster():EmitSound("DOTA_Item.ExMachina.Cast")

    local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
end

modifier_item_ex_machina_custom = class({})

function modifier_item_ex_machina_custom:IsHidden() return true end
function modifier_item_ex_machina_custom:IsPurgable() return false end
function modifier_item_ex_machina_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_item_ex_machina_custom:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end