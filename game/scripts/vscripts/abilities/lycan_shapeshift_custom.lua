LinkLuaModifier("modifier_lycan_shapeshift_custom_fly", "abilities/lycan_shapeshift_custom", LUA_MODIFIER_MOTION_NONE)

lycan_shapeshift_custom = class({})

function lycan_shapeshift_custom:OnToggle() 
	if not IsServer() then return end
	local modifier_lycan_shapeshift = self:GetCaster():FindModifierByName("modifier_lycan_shapeshift")

	if not self:GetToggleState() then
		if modifier_lycan_shapeshift then
			modifier_lycan_shapeshift:Destroy()
		end
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift_transform", {duration = FrameTime()})
		Timers:CreateTimer(FrameTime()*2, function()
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift", {duration = 99999})
		end)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift_custom_fly", {})
	end

	self:EndCooldown()
	self:StartCooldown(1) 
end

function lycan_shapeshift_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then 
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
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lycan_shapeshift_transform", {duration = FrameTime()})
end

modifier_lycan_shapeshift_custom_fly = class({})

function modifier_lycan_shapeshift_custom_fly:IsHidden() return true end
function modifier_lycan_shapeshift_custom_fly:IsPurgable() return false end
function modifier_lycan_shapeshift_custom_fly:IsPurgeException() return false end

function modifier_lycan_shapeshift_custom_fly:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_lycan_shapeshift_custom_fly:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_lycan_shapeshift_transform") then return end
	if not self:GetParent():HasModifier("modifier_lycan_shapeshift") then
		self:Destroy()
	end
end

function modifier_lycan_shapeshift_custom_fly:CheckState()
	if not self:GetCaster():HasScepter() then return end
	return 
	{
		[MODIFIER_STATE_FLYING] = true
	}
end