invoker_alacrity_lua = class({})

LinkLuaModifier("modifier_invoker_alacrity_lua", "heroes/hero_invoker/modifier_invoker_alacrity_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_alacrity_talent", "heroes/hero_invoker/modifier_invoker_alacrity_talent", LUA_MODIFIER_MOTION_NONE)

function invoker_alacrity_lua:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    target:AddNewModifier( caster, self, "modifier_invoker_alacrity_lua", { duration = duration } )
end

function invoker_alacrity_lua:GetCastAnimation()
    return ACT_DOTA_CAST_ALACRITY
end