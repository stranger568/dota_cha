invoker_sun_strike_lua = class({})
LinkLuaModifier("modifier_invoker_sun_strike_lua_thinker", "heroes/hero_invoker/modifier_invoker_sun_strike_lua_thinker", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV

function invoker_sun_strike_lua:GetCastAnimation()
    return ACT_DOTA_CAST_SUN_STRIKE
end

function invoker_sun_strike_lua:GetAOERadius()
    return self:GetSpecialValueFor("area_of_effect")
end

function invoker_sun_strike_lua:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    end
    return self.BaseClass.GetBehavior(self)
end

-- Commented out for Cataclysm talent when available
--------------------------------------------------------------------------------
function invoker_sun_strike_lua:GetCooldown(level)
    if self.bCataclysm then
        return self:GetSpecialValueFor("cataclysm_cooldown")
    end
    return self.BaseClass.GetCooldown(self, level)
end
--------------------------------------------------------------------------------
-- Ability Cast Filter
function invoker_sun_strike_lua:CastFilterResultLocation(vLocation)
    self.bCataclysm = false
    return UF_SUCCESS
end

function invoker_sun_strike_lua:CastFilterResultTarget(hTarget)
    self.bCataclysm = false
    if self:GetCaster() == hTarget then
        if not hTarget:HasScepter() then
            return UF_FAIL_OTHER
        end
        self.bCataclysm = true
    end
    return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function invoker_sun_strike_lua:OnSpellStart()
    -- unit identifier
    -- get values
    self.delay = self:GetSpecialValueFor("delay")
    self.vision_distance = self:GetSpecialValueFor("vision_distance")
    self.vision_duration = self:GetSpecialValueFor("vision_duration")
    ListModifiers(self:GetCaster())
    if self.bCataclysm then

        local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

        if units and #units > 0 then
            local cataclysm_minimum_distance = self:GetSpecialValueFor("cataclysm_minimum_distance")
            local cataclysm_maximum_distance = self:GetSpecialValueFor("cataclysm_maximum_distance")
            local cataclysm_limits = self:GetSpecialValueFor("cataclysm_limits")

            local nSunStrike = math.min(#units * 2, cataclysm_limits)

            for _, unit in pairs(units) do
                if nSunStrike == 0 then
                    break
                end
                nSunStrike = nSunStrike - 2
                local pos = unit:GetOrigin()
                self:CastSunStrikeAtPoint(pos + RandomVector(RandomFloat(cataclysm_minimum_distance, cataclysm_maximum_distance)))
                self:CastSunStrikeAtPoint(pos + RandomVector(RandomFloat(cataclysm_minimum_distance, cataclysm_maximum_distance)))
            end
        end

    else
        self:CastSunStrikeAtPoint(self:GetCursorPosition())
    end
end


function invoker_sun_strike_lua:CastSunStrikeAtPoint(point)

    local caster = self:GetCaster()

    -- create modifier thinker
    CreateModifierThinker(
    caster,
    self,
    "modifier_invoker_sun_strike_lua_thinker",
    { duration = self.delay, cataclysm = self.bCataclysm },
    point,
    caster:GetTeamNumber(),
    false
    )

    -- create vision
    AddFOWViewer(caster:GetTeamNumber(), point, self.vision_distance, self.vision_duration, false)
end