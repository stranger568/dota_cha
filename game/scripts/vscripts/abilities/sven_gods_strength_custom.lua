LinkLuaModifier("modifier_sven_gods_strength_custom_fly", "abilities/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE)

sven_gods_strength_custom = class({})

function sven_gods_strength_custom:OnToggle() 
	if not IsServer() then return end

	local modifier_sven_gods_strength = self:GetCaster():FindModifierByName("modifier_sven_gods_strength")

	if not self:GetToggleState() then
		if modifier_sven_gods_strength then
			modifier_sven_gods_strength:Destroy()
		end
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength_custom_fly", {})
	end

	self:EndCooldown()
	self:StartCooldown(1) 
end

function sven_gods_strength_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then 
		return 0
	end
	return self.BaseClass.GetManaCost(self,level)
end

function sven_gods_strength_custom:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return 0
	end
	return self.BaseClass.GetCooldown(self, iLevel) 
end

function sven_gods_strength_custom:GetBehavior()
  	if self:GetCaster():HasScepter() then
    	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
   	end
 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

function sven_gods_strength_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength", {duration = self:GetSpecialValueFor("duration")})
end

modifier_sven_gods_strength_custom_fly = class({})

function modifier_sven_gods_strength_custom_fly:IsHidden() return true end
function modifier_sven_gods_strength_custom_fly:IsPurgable() return false end
function modifier_sven_gods_strength_custom_fly:IsPurgeException() return false end

function modifier_sven_gods_strength_custom_fly:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_sven_gods_strength_custom_fly:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_sven_gods_strength") then
		self:Destroy()
	end
end

function modifier_sven_gods_strength_custom_fly:CheckState()
	if not self:GetCaster():HasScepter() then return end
	return 
	{
		[MODIFIER_STATE_FLYING] = true
	}
end