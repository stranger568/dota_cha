LinkLuaModifier("modifier_lycan_shapeshift_custom_fly", "abilities/lycan_shapeshift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_custom", "abilities/lycan_shapeshift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_custom_speed", "abilities/lycan_shapeshift_custom", LUA_MODIFIER_MOTION_NONE)

lycan_shapeshift_custom = class({})

function lycan_shapeshift_custom:OnToggle() 
	if not IsServer() then return end
	local modifier_lycan_shapeshift = self:GetCaster():FindModifierByName("modifier_lycan_shapeshift_custom")

	if not self:GetToggleState() then
		if modifier_lycan_shapeshift then
			modifier_lycan_shapeshift:Destroy()
		end
	else
		self:GetCaster():RemoveModifierByName("modifier_lycan_shapeshift_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift_custom", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift_custom_fly", {})
	end

	self:EndCooldown()
	self:StartCooldown(1) 
end

function lycan_shapeshift_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then
        if IsClient() then return 15 end
		return 0
	end
	return self.BaseClass.GetManaCost(self,level)
end

function lycan_shapeshift_custom:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return 0
	end
	return self.BaseClass.GetCooldown(self, iLevel) 
end

function lycan_shapeshift_custom:GetBehavior()
  	if self:GetCaster():HasScepter() then
    	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
   	end
 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

function lycan_shapeshift_custom:OnSpellStart()
	if not IsServer() then return end
	if self:GetCaster():HasScepter() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift_custom", {duration = self:GetSpecialValueFor("duration")})
end

modifier_lycan_shapeshift_custom_fly = class({})

function modifier_lycan_shapeshift_custom_fly:IsHidden() return true end
function modifier_lycan_shapeshift_custom_fly:IsPurgable() return false end
function modifier_lycan_shapeshift_custom_fly:IsPurgeException() return false end

function modifier_lycan_shapeshift_custom_fly:OnCreated()
	if not IsServer() then return end
    self.parent = self:GetParent()
	self:StartIntervalThink(0.5)
end

function modifier_lycan_shapeshift_custom_fly:OnIntervalThink()
	if not IsServer() then return end
	if self.parent:HasModifier("modifier_lycan_shapeshift_transform") then return end
    self.parent:SpendMana(15*0.5, self:GetAbility())
    if self.parent:GetMana() <= 14 then
        self.parent:RemoveModifierByName("modifier_undying_flesh_golem")
        return
    end
	if not self.parent:HasModifier("modifier_lycan_shapeshift_custom") then
		self:Destroy()
	end
    if not self.parent:HasScepter() then
        self.parent:RemoveModifierByName("modifier_lycan_shapeshift_custom")
    end
end

function modifier_lycan_shapeshift_custom_fly:CheckState()
	if not self.parent:HasScepter() then return end
	return 
	{
		[MODIFIER_STATE_FLYING] = true
	}
end

modifier_lycan_shapeshift_custom = class({})

function modifier_lycan_shapeshift_custom:IsPurgable() return false end

function modifier_lycan_shapeshift_custom:DeclareFunctions()  
    local decFuncs = 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return decFuncs 
end

function modifier_lycan_shapeshift_custom:GetModifierModelChange()
    return "models/heroes/lycan/lycan_wolf.vmdl"
end

function modifier_lycan_shapeshift_custom:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
    self.crit_damage = self.ability:GetSpecialValueFor("crit_multiplier")
    self.health_bonus = self.ability:GetSpecialValueFor("health_bonus")
end

function modifier_lycan_shapeshift_custom:GetModifierHealthBonus()
	return self.health_bonus
end

function modifier_lycan_shapeshift_custom:OnRefresh()
    self:OnCreated()
end

function modifier_lycan_shapeshift_custom:GetModifierPreAttack_CriticalStrike()
    if not IsServer() then return end                  
    if RollPercentage(self.crit_chance) then        
        return self.crit_damage
    end
    return nil
end

function modifier_lycan_shapeshift_custom:IsAura() return true end
function modifier_lycan_shapeshift_custom:GetAuraDuration() return 0 end
function modifier_lycan_shapeshift_custom:GetAuraRadius() return -1 end
function modifier_lycan_shapeshift_custom:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end
function modifier_lycan_shapeshift_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_lycan_shapeshift_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_lycan_shapeshift_custom:GetModifierAura() return "modifier_lycan_shapeshift_custom_speed" end

function modifier_lycan_shapeshift_custom:GetAuraEntityReject(hTarget)
    if not IsServer() then return end
    if hTarget == self.caster or hTarget:GetOwner() == self.caster then
        return false
    end
    return true
end

modifier_lycan_shapeshift_custom_speed = class({})

function modifier_lycan_shapeshift_custom_speed:OnCreated()
    self.ability = self:GetAbility()
    self.speed = self.ability:GetSpecialValueFor("speed")
    self.bonus_night_vision = self.ability:GetSpecialValueFor("bonus_night_vision")
end

function modifier_lycan_shapeshift_custom_speed:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }

    return funcs
end

function modifier_lycan_shapeshift_custom_speed:GetModifierMoveSpeedOverride()
    return self.speed
end

function modifier_lycan_shapeshift_custom_speed:GetBonusNightVision()
    return self.bonus_night_vision
end

function modifier_lycan_shapeshift_custom_speed:CheckState()
	return
	{
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}
end

function modifier_lycan_shapeshift_custom_speed:IsHidden()
    return true
end

function modifier_lycan_shapeshift_custom_speed:IsPurgable() return false end