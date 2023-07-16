LinkLuaModifier("modifier_stranger_think", "abilities/stranger_think", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_portal_custom_passive", "abilities/stranger_think", LUA_MODIFIER_MOTION_NONE)

stranger_think = class({})

function stranger_think:GetIntrinsicModifierName()
	return "modifier_stranger_think"
end

modifier_stranger_think = class({})

function modifier_stranger_think:IsHidden() return true end
function modifier_stranger_think:IsPurgable() return false end
function modifier_stranger_think:IsPurgeException() return false end

function modifier_stranger_think:OnCreated()
	if not IsServer() then return end
	self.think_to_portal = false
	self.attacks = 0
	self.cast_portal = false
	self.current_portal = "red"
    self.parent = self:GetParent()
	self:StartIntervalThink(0.5)
end

function modifier_stranger_think:TakeDamageScriptModifier(params)
	if not IsServer() then return end
	if params.unit ~= self.parent then return end
	
	if self.think_to_portal then return end
	if self.cast_portal then return end

	self.attacks = self.attacks + 1
	
	if self.attacks >= 50 then
		self.attacks = 0
		self.think_to_portal = true
		return
	end

	self.parent:MoveToPosition(self.parent:GetAbsOrigin() + RandomVector(200))
end

function modifier_stranger_think:OnIntervalThink()
	if not IsServer() then return end
	if not self.think_to_portal then return end
	if self.cast_portal then return end

	local portal_blue = Entities:FindByName(nil, "portal_blue")
	local portal_red = Entities:FindByName(nil, "portal_red")
	local distance_blue = 0
	local distance_red = 0

	if portal_blue then
		distance_blue = (self.parent:GetAbsOrigin() - portal_blue:GetAbsOrigin()):Length2D()
	end
	
	if portal_red then
		distance_red = (self.parent:GetAbsOrigin() - portal_red:GetAbsOrigin()):Length2D()
	end

	if self.current_portal == "red" then
		self.parent:MoveToPosition(portal_red:GetAbsOrigin())
		if distance_red <= 550 then
			self.cast_portal = true
	        self.parent:Interrupt() 
	        self.parent:Stop()
	        self.parent:AddAbility("portal_base_custom")
	        local ability = self.parent:FindAbilityByName("portal_base_custom")
	        ability:SetLevel(1)
	        ability.portal = "npc_dota_teleport_base_custom_red"
	        self.parent:CastAbilityNoTarget(ability, -1)
		end
	else
		self.parent:MoveToPosition(portal_blue:GetAbsOrigin())
		if distance_blue <= 550 then
			self.cast_portal = true
			self.parent:Interrupt() 
            self.parent:Stop()
            self.parent:AddAbility("portal_base_custom")
            local ability = self.parent:FindAbilityByName("portal_base_custom")
            ability:SetLevel(1)
            ability.portal = "npc_dota_teleport_base_custom_blue"
            self.parent:CastAbilityNoTarget(ability, -1)
		end
	end
end

function modifier_stranger_think:CheckState()
	return
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DEBUFF_IMMUNE] = true,
	}
end

function modifier_stranger_think:DeclareFunctions()
    local funcs = 
    {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

function modifier_stranger_think:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_stranger_think:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_stranger_think:GetAbsoluteNoDamagePure()
	return 1
end

portal_custom_passive = class({})

function portal_custom_passive:GetIntrinsicModifierName()
	return "modifier_portal_custom_passive"
end

function portal_custom_passive:Spawn()
	if not IsServer() then return end
	self:SetLevel(1)
end

modifier_portal_custom_passive = class({})

function modifier_portal_custom_passive:IsHidden() return false end
function modifier_portal_custom_passive:IsPurgable() return false end
function modifier_portal_custom_passive:IsPurgeException() return false end

function modifier_portal_custom_passive:DeclareFunctions()
    local funcs = 
    {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_portal_custom_passive:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_portal_custom_passive:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_portal_custom_passive:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_portal_custom_passive:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_portal_custom_passive:CheckState()
	return
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DEBUFF_IMMUNE] = true,
	}
end