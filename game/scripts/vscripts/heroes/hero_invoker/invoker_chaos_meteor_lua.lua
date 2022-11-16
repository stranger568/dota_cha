invoker_chaos_meteor_lua = class({})
LinkLuaModifier("modifier_invoker_chaos_meteor_lua_thinker", "heroes/hero_invoker/modifier_invoker_chaos_meteor_lua_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_lua_burn", "heroes/hero_invoker/modifier_invoker_chaos_meteor_lua_burn", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function invoker_chaos_meteor_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- create thinker
    CreateModifierThinker(
    caster, -- player source
    self, -- ability source
    "modifier_invoker_chaos_meteor_lua_thinker", -- modifier name
    {}, -- kv
    point,
    self:GetCaster():GetTeamNumber(),
    false
    )
    --魔晶
    if caster:HasModifier("modifier_item_aghanims_shard") then
        
        local caster_point =caster:GetOrigin()
        local dir=(point-caster_point):Normalized()  --目标点到施法者的方向向量

        --修复陨石不动BUG
        if dir:Length2D()<0.5 then
           print("shard direction is zero")
           dir = self:GetCaster():GetForwardVector()
        end

        CreateModifierThinker(
            caster, -- player source
            self, -- ability source
            "modifier_invoker_chaos_meteor_lua_thinker", -- modifier name
            {},
            --拉长200距离出一个顶点，然后以施法点为原点，旋转90度
            RotatePosition(point, QAngle( 0, -90, 0 ), point+dir*200 ),
            self:GetCaster():GetTeamNumber(),
            false
        )
        
        CreateModifierThinker(
            caster, -- player source
            self, -- ability source
            "modifier_invoker_chaos_meteor_lua_thinker", -- modifier name
            {},
            RotatePosition(point, QAngle( 0, 90, 0 ), point+dir*200 ),
            self:GetCaster():GetTeamNumber(),
            false
        )
    end
end


function invoker_chaos_meteor_lua:GetCooldown(level)
   return self.BaseClass.GetCooldown(self, level)
end


function invoker_chaos_meteor_lua:GetCastAnimation()
    return ACT_DOTA_CAST_CHAOS_METEOR
end