LinkLuaModifier( "modifier_item_magilys_custom", "items/item_magilys_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_magilys_custom_cooldown", "items/item_magilys_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_gleipnir_magic_custom_debuff", "items/item_magilys_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_gleipnir_magic_custom_debuff_rooted", "items/item_magilys_custom", LUA_MODIFIER_MOTION_NONE )

item_magilys_custom = class({})

function item_magilys_custom:GetIntrinsicModifierName() 
    return "modifier_item_magilys_custom"
end

modifier_item_magilys_custom = class({})

modifier_item_magilys_custom.percentage_abilities = 
{
    ["abyssal_underlord_firestorm_custom"] = true,
    ["elder_titan_earth_splitter"] = true,
    ["winter_wyvern_arctic_burn"] = true,
    ["doom_bringer_infernal_blade"] = true,
    ["enigma_midnight_pulse_custom"] = true,
    ["enigma_black_hole"] = true,
    ["zeus_static_field_lua"] = true,
    ["huskar_life_break"] = true,
    ["phoenix_sun_ray"] = true,
    ["spectre_dispersion"] = true,
    ["death_prophet_spirit_siphon"] = true,
    ["custom_phantom_assassin_fan_of_knives"] = true,
    ["bloodseeker_rupture"] = true,
    ["item_spirit_vessel"] = true,
    ["terrorblade_reflection_lua"] = true,
    ["venomancer_poison_nova_custom"] = true,
    ["necrolyte_reapers_scythe_datadriven"] = true,
    ["necrolyte_heartstopper_aura_lua"] = true,
    ["zuus_static_field"] = true,
    ["item_blade_mail"] = true,
    ["item_iron_talon"] = true,
    ["sandking_caustic_finale"] = true,
    ["sandking_caustic_finale_lua"] = true,
    ["jakiro_liquid_ice"] = true,
    ["jakiro_liquid_ice_lua"] = true,
    ["witch_doctor_maledict"] = true,
    ["bloodseeker_blood_mist_custom"] = true,
    ["witch_doctor_voodoo_restoration"] = true,
    ["item_shivas_guard_2"] = true,
    ["meepo_ransack_custom"] = true,
    ["shadow_demon_disseminate"] = true,
    ["dragon_knight_elder_dragon_form_custom"] = true,
    ["muerta_pierce_the_veil"] = true,
    ["zuus_arc_lightning"] = true,
    ["venomancer_noxious_plague"] = true,
}

function modifier_item_magilys_custom:IsHidden() return true end
function modifier_item_magilys_custom:IsPurgable() return false end
function modifier_item_magilys_custom:IsPurgeException() return false end

function modifier_item_magilys_custom:DeclareFunctions()
    return  
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_item_magilys_custom:GetModifierBonusStats_Strength()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_magilys_custom:GetModifierBonusStats_Agility()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_magilys_custom:GetModifierBonusStats_Intellect()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_magilys_custom:PercentAbility(ability)
    if self.percentage_abilities[ability] == nil then
        return false
    end
    return true
end

function modifier_item_magilys_custom:FlagExist(a,b)
    local p,c,d=1,0,b
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c==d
end

function modifier_item_magilys_custom:GetModifierTotalDamageOutgoing_Percentage(params)
    if params.damage_type == DAMAGE_TYPE_MAGICAL then 
        if params.target == nil then return end
        if params.inflictor == nil then return end
        if self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS ) then return end
        if self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ) then return end

        local chance = self:GetAbility():GetSpecialValueFor("chance")

        if params.target:HasModifier("modifier_item_gleipnir_magic_custom_debuff") and not params.target:IsHero() then
            chance = chance + self:GetAbility():GetSpecialValueFor("bonus_crit_creep")
        end

        if RollPercentage(chance) then
            local critical_damage = self:GetAbility():GetSpecialValueFor("critical_damage")
            if self:GetParent():HasModifier("modifier_item_magilys_custom_cooldown") then
                if params.target:HasModifier("modifier_item_gleipnir_magic_custom_debuff") and not params.target:IsHero() then
                    if self:PercentAbility(params.inflictor:GetAbilityName()) then
                        return
                    end
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, params.original_damage + (params.original_damage / 100 * (critical_damage - 100)), nil)
                    return critical_damage - 100
                end
            else
                if self:PercentAbility(params.inflictor:GetAbilityName()) then
                    return
                end
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_magilys_custom_cooldown", {duration = self:GetAbility():GetSpecialValueFor("cooldown_crit")})
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, params.original_damage + (params.original_damage / 100 * (critical_damage - 100)), nil)
                return critical_damage - 100
            end
        end
    end
end

modifier_item_magilys_custom_cooldown = class({})
function modifier_item_magilys_custom_cooldown:IsHidden() return true end
function modifier_item_magilys_custom_cooldown:IsPurgable() return false end
function modifier_item_magilys_custom_cooldown:IsPurgeException() return false end

----------------------------------------------------------------------------------

item_gleipnir_magic_custom = class({})

function item_gleipnir_magic_custom:GetIntrinsicModifierName() 
    return "modifier_item_magilys_custom"
end

function item_gleipnir_magic_custom:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function item_gleipnir_magic_custom:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("radius")
    self:GetCaster():EmitSound("Item.Gleipnir.Cast")
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    for _, target in pairs(enemies) do
        local info = {Target = target,Source = self:GetCaster(),Ability = self,EffectName = "particles/items3_fx/gleipnir_projectile_custom.vpcf",iMoveSpeed = 1900,vSourceLoc= self:GetCaster():GetAbsOrigin(),bDodgeable = true}
        ProjectileManager:CreateTrackingProjectile(info)
    end
end

function item_gleipnir_magic_custom:OnProjectileHit(target, vLocation)
    if target == nil then return end
    target:EmitSound("Item.Gleipnir.Target")
    target:AddNewModifier(self:GetCaster(), self, "modifier_item_gleipnir_magic_custom_debuff", {duration = self:GetSpecialValueFor("debuff_duration") * (1-target:GetStatusResistance())})
    target:AddNewModifier(self:GetCaster(), self, "modifier_item_gleipnir_magic_custom_debuff_rooted", {duration = self:GetSpecialValueFor("duration") * (1-target:GetStatusResistance())})
end

modifier_item_gleipnir_magic_custom_debuff = class({})

function modifier_item_gleipnir_magic_custom_debuff:IsPurgable() return true end

function modifier_item_gleipnir_magic_custom_debuff:DeclareFunctions()
    return 
    { 
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, 
    } 
end

function modifier_item_gleipnir_magic_custom_debuff:GetModifierIncomingDamage_Percentage(keys)
    if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
        return self:GetAbility():GetSpecialValueFor("spell_amplify")
    end
end

modifier_item_gleipnir_magic_custom_debuff_rooted = class({})
function modifier_item_gleipnir_magic_custom_debuff_rooted:IsPurgable() return true end
function modifier_item_gleipnir_magic_custom_debuff_rooted:CheckState()
    if not self:GetParent():IsHero() then
        return
        {
            [MODIFIER_STATE_ROOTED] = true,
            [MODIFIER_STATE_SILENCED] = true
        }
    end
    return
    {
        [MODIFIER_STATE_ROOTED] = true
    }
end

function modifier_item_gleipnir_magic_custom_debuff_rooted:GetEffectName() return "particles/items3_fx/gleipnir__custom_root.vpcf" end



