modifier_creature_berserk = class({})

function modifier_creature_berserk:GetTexture()
	return "ogre_magi_bloodlust"
end

function modifier_creature_berserk:IsHidden()
	return false
end

function modifier_creature_berserk:IsDebuff()
	return false
end

function modifier_creature_berserk:IsPurgable()
	return false
end

function modifier_creature_berserk:GetEffectName()
    return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_creature_berserk:OnCreated( kv )
    self.parent = self:GetParent()
    self.name = self.parent:GetUnitName()
	if IsServer() then
		self.parent:AddNewModifier(self.parent, nil, "modifier_tower_truesight_aura", {})
		self:StartIntervalThink( 1 )
        self:SetStackCount(1)
		self.parent:EmitSound("Hero_OgreMagi.Bloodlust.Target")
    	self.parent:EmitSound("Hero_OgreMagi.Bloodlust.Target.FP")
	end
end

function modifier_creature_berserk:OnIntervalThink()
	if IsServer() then
	    self:SetStackCount(self:GetStackCount()+1)
        if self:GetStackCount()>60 then
            local flRadius = 350 + (self:GetStackCount()-60)*5
            local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self.parent:GetOrigin(), self.parent,flRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
            for _,hEnemy in ipairs(enemies) do
                if hEnemy and (not hEnemy:HasModifier("modifier_hero_refreshing")) then
                    local damage_table = {}
                    damage_table.attacker = self.parent
                    damage_table.victim = hEnemy
                    damage_table.damage_type = DAMAGE_TYPE_PURE
                    damage_table.damage = hEnemy:GetMaxHealth() * 0.005 * (self:GetStackCount()-60)
                    local curse_ability = nil
                    local empty_0 = hEnemy:FindAbilityByName("empty_0")
                    if empty_0 then
                        curse_ability = empty_0
                    end
                    if curse_ability then
                        damage_table.ability = curse_ability
                    end
                    damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
                    ApplyDamage(damage_table)
                end
            end
        end
	end
end


function modifier_creature_berserk:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS 
	}
	return funcs
end

function modifier_creature_berserk:GetModifierStatusResistanceStacking()
    if not self.parent:HasModifier("modifier_creep_cha_resistance") then
        if self.name == "npc_dota_roshan" then return 0 end
        if self.name == "npc_dota_nian" then return 0 end
        if self.name == "npc_dota_granite_golem" then return 0 end
    end
    return 25
end

function modifier_creature_berserk:GetModifierMagicalResistanceBonus()
    if not self.parent:HasModifier("modifier_creep_cha_resistance") then
        if self.name == "npc_dota_roshan" then return 0 end
        if self.name == "npc_dota_nian" then return 0 end
        if self.name == "npc_dota_granite_golem" then return 0 end
    end
    return 25
end

function modifier_creature_berserk:CheckState()
	local state =
	{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_CANNOT_MISS] = true,
	}
	return state
end

function modifier_creature_berserk:AttackLandedModifier(params)
    if IsServer() then
        if self.parent == params.attacker then
            local hTarget = params.target
            if hTarget ~= nil then
                local hDebuff = hTarget:FindModifierByName("modifier_creature_berserk_debuff")
                if hDebuff == nil then
                    hDebuff = hTarget:AddNewModifier(self.parent, nil, "modifier_creature_berserk_debuff", { duration = 12.0 })
                    if hDebuff ~= nil then
                        hDebuff:SetStackCount(0)
                    end
                end
                if hDebuff ~= nil then
                    hDebuff:SetStackCount(hDebuff:GetStackCount() + 1)
                    hDebuff:SetDuration(12.0, true)
                end
            end
        end
    end
    return 0
end

function modifier_creature_berserk:GetModifierAttackSpeedBonus_Constant(params)
    return self:GetStackCount() *5
end

function modifier_creature_berserk:GetModifierDamageOutgoing_Percentage(params)
    return self:GetStackCount() *15
end

function modifier_creature_berserk:GetModifierMoveSpeed_AbsoluteMin(params)
    return self.parent:GetBaseMoveSpeed()+math.floor(self.parent:GetBaseMoveSpeed() * self:GetStackCount() * 0.05)
end

function modifier_creature_berserk:GetModifierModelScale(params)
    return 55
end

modifier_creep_cha_resistance = class({})
function modifier_creep_cha_resistance:IsHidden() return true end
function modifier_creep_cha_resistance:IsPurgable() return false end
function modifier_creep_cha_resistance:IsPurgeException() return false end