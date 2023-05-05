LinkLuaModifier("modifier_duel_buff", "heroes/hero_legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_damage", "heroes/hero_legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)

custom_legion_commander_duel = class({})

custom_legion_commander_duel.bRoundDueled = false

function custom_legion_commander_duel:GetCooldown(iLevel)
	local upgrade_cooldown = 0
	if self:GetCaster():HasScepter() then 
    	upgrade_cooldown = -20
	end
	return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end

function custom_legion_commander_duel:GetCastRange( vLocation, hTarget )
  	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end

function custom_legion_commander_duel:OnSpellStart()
  	if not IsServer() then return end

  	local target = self:GetCursorTarget()

  	local duration = self:GetSpecialValueFor("duration")

  	if target:TriggerSpellAbsorb(self) then return end

  	if self:GetCaster():HasScepter() then 
    	duration = self:GetSpecialValueFor("duration_scepter")
  	end
 
  	local duration = (1 - target:GetStatusResistance()) * duration

    self:GetCaster():EmitSound("Hero_LegionCommander.Duel.Cast")

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_duel_buff", {duration = duration, target = target:entindex()})
    target:AddNewModifier(self:GetCaster(), self, "modifier_duel_buff", {duration = duration, target = self:GetCaster():entindex()})
end

function custom_legion_commander_duel:WinDuel(winner, loser)
  	if not IsServer() then return end

  	ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
  	winner:EmitSound("Hero_LegionCommander.Duel.Victory")

  	if winner:IsHero() then
  		winner:AddNewModifier(winner, self, "modifier_duel_damage", {})
  		local mod = winner:FindModifierByName("modifier_duel_damage")
  		local damage = self:GetSpecialValueFor("reward_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_legion_commander")

  		if not loser:IsHero() then
  			if self.bRoundDueled == false then
  				self.bRoundDueled = true
  				if mod then
  					mod:SetStackCount(mod:GetStackCount() + damage)
  				end
  			end
  		else
  			if not loser:IsIllusion() then
				if mod then
  					mod:SetStackCount(mod:GetStackCount() + damage)
  				end
  			end
  		end

  		if winner == self:GetCaster() and self:GetCaster():HasShard() then
  			local ability = winner:FindAbilityByName("legion_commander_press_the_attack")
  			if ability and ability:GetLevel() > 0 then
  				local duration = ability:GetSpecialValueFor("duration")
  				winner:Purge(false, true, false, false, false )
      			winner:AddNewModifier(self:GetCaster(), ability, "modifier_legion_commander_press_the_attack", {duration = duration})
      			winner:EmitSound("Hero_LegionCommander.PressTheAttack")
  			end
  		end
  	end
end

modifier_duel_buff = class({})

function modifier_duel_buff:IsPurgable() return false end
function modifier_duel_buff:IsDebuff() return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() end
function modifier_duel_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_duel_buff:OnCreated(table)
 	if not IsServer() then return end	

  	self.target = EntIndexToHScript(table.target)
  	self:GetParent():SetForceAttackTarget(self.target)
  	self:GetParent():MoveToTargetToAttack(self.target)

  	self.duel_end = false

  	if self:GetCaster() == self:GetParent() then 
  		self:GetCaster().particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		self:GetCaster():EmitSound("Hero_LegionCommander.Duel")
    	local center_point = self.target:GetAbsOrigin() + ((self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()) / 1)
    	ParticleManager:SetParticleControl(self:GetCaster().particle, 0, center_point)
    	ParticleManager:SetParticleControl(self:GetCaster().particle, 7, center_point)
  	end

  	self:StartIntervalThink(FrameTime())
end

function modifier_duel_buff:DeclareFunctions()
  	return
  	{
    	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  	}
end

function modifier_duel_buff:CheckState()
	return 
	{
  		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  		[MODIFIER_STATE_TAUNTED] = true, 
  		[MODIFIER_STATE_SILENCED] = true
	}
end

function modifier_duel_buff:GetModifierIncomingDamage_Percentage(params)
	if not IsServer() then return end
	if not self:GetCaster():HasScepter() then return end
	if params.attacker == self.target then return end
	return -50
end

function modifier_duel_buff:OnDeathEvent(params)
    if params.unit == self.target then
    	if not self.duel_end then
	    	self.duel_end = true
	        self:GetAbility():WinDuel(self:GetParent(), self.target)
	        self:Destroy()
	    end
    end
end

function modifier_duel_buff:OnIntervalThink()
	if not IsServer() then return end	
  	self:GetParent():SetForceAttackTarget(self.target)
  	self:GetParent():MoveToTargetToAttack(self.target)

  	if not self.target:IsAlive() then
  		if not self.duel_end then
  			self.duel_end = true
	       	self:GetAbility():WinDuel(self:GetParent(), self.target)
	       	self:Destroy()
         	return
      	end
  	end

  	if not self.target:HasModifier("modifier_duel_buff") then
  		if not self.duel_end then
	      	self.duel_end = true
	      	self:Destroy()
	      	return
	    end
 	 end

  	if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("victory_range") then 
      	self:Destroy()
  	end
end

function modifier_duel_buff:OnDestroy()
  	if not IsServer() then return end

 	  self:GetCaster():StopSound("Hero_LegionCommander.Duel")

  	if self:GetCaster().particle then 
  		ParticleManager:DestroyParticle(self:GetCaster().particle, false)
  	end

  	self:GetParent():SetForceAttackTarget(nil)
  	self:GetParent():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
    local parent = self:GetParent()
    Timers:CreateTimer(0.25, function()
      print("dada lk")
      parent:SetForceAttackTarget(nil)
    end)
end

-----------

modifier_duel_damage = class({})

function modifier_duel_damage:IsPurgable() return false end
function modifier_duel_damage:RemoveOnDeath() return false end
function modifier_duel_damage:GetTexture() return "legion_commander_duel" end

function modifier_duel_damage:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_duel_damage:GetModifierPreAttack_BonusDamage() 
	return self:GetStackCount() 
end