innateExceptions = 
{
	modifier_faceless_void_time_walk_tracker = true,
	modifier_weaver_timelapse = true,
	modifier_ember_spirit_fire_remnant_charge_counter = true,
	modifier_ember_spirit_fire_remnant_thinker = true,
	modifier_ember_spirit_fire_remnant_timer = true,
}

delayForDanger = 
{
	morphling_waveform = 5.0,
	huskar_life_break = 3.0,
	tusk_snowball = 5.0,
	ember_spirit_fire_remnant = 5.0,
	rattletrap_hookshot = 3.0,
	faceless_void_time_walk = 5.0,
	faceless_void_time_walk_reverse = 5.0,
	batrider_sticky_napalm = 12.0,
}

function CDOTABaseAbility:ClearInnateModifiers()
	for _,hModifier in ipairs(self:GetCaster():FindAllModifiers()) do
		if hModifier and not hModifier:IsNull() and hModifier:GetAbility() == self then
			if not innateExceptions[hModifier:GetName()] then
				hModifier:Destroy()
			end
		end
	end
end

function CDOTABaseAbility:Disable()
	if self:IsChanneling() then
		self:SetChanneling(false)
	end
	if self:GetToggleState() then
		self:ToggleAbility()
	end
	if self:GetAutoCastState() then
		self:ToggleAutoCast()
	end
	self:ClearInnateModifiers()
	self:SetLevel(0)
	self:ClearInnateModifiers()
	self:SetHidden(true)
	self:OnChannelFinish(true)
end

function CDOTABaseAbility:SetRemovalTimer()
    local flDelay = FrameTime()

    if self and self:GetAbilityName() then
       	if delayForDanger[self:GetAbilityName()] then
          	flDelay = delayForDanger[self:GetAbilityName()]   
       	end
    end

	self.sRemovalTimer=Timers:CreateTimer(flDelay, function()
		if self and not self:IsNull() then
			if self:NumModifiersUsingAbility() <= 0 and not self:IsChanneling() then
				self.sRemovalTimer = nil
				self:ClearInnateModifiers()
				self:RemoveSelf()
			else
				self:Disable()
				return FrameTime()
			end
		else
			self.sRemovalTimer = nil
			return nil
		end
	end)
end


function CDOTABaseAbility:HasBehavior(behavior)
	if not self or self:IsNull() then return end
	local abilityBehavior = tonumber(tostring(self:GetBehaviorInt()))
	return bit:_and(abilityBehavior, behavior) == behavior
end