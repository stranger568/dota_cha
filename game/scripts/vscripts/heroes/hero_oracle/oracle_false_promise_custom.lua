LinkLuaModifier( "modifier_oracle_false_promise_custom", "heroes/hero_oracle/oracle_false_promise_custom", LUA_MODIFIER_MOTION_NONE )

oracle_false_promise_custom = class({})

function oracle_false_promise_custom:OnSpellStart()
	if not IsServer() then return end
	local target = self:GetCursorTarget()
	self:ApplyFalsePromise(target)
end

function oracle_false_promise_custom:ApplyFalsePromise(target)
	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	EmitSoundOnClient("Hero_Oracle.FalsePromise.FP", target:GetPlayerOwner())

	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)
	
	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)
	
	self:GetCaster():EmitSound("Hero_Oracle.FalsePromise.Cast")
	
	target:Purge(false, true, false, true, true)
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_oracle_false_promise_custom", {duration = self:GetSpecialValueFor("duration")})
end

modifier_oracle_false_promise_custom = class({})

function modifier_oracle_false_promise_custom:DestroyOnExpire()	return not self:GetParent():IsInvulnerable() end
function modifier_oracle_false_promise_custom:GetPriority()	return MODIFIER_PRIORITY_ULTRA end
function modifier_oracle_false_promise_custom:IsPurgable()	return false end

function modifier_oracle_false_promise_custom:GetTexture()
	return "oracle_false_promise"
end

function modifier_oracle_false_promise_custom:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf"
end

function modifier_oracle_false_promise_custom:OnCreated()
	if not IsServer() then return end
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)

	self.heal_counter		= 0
	self.damage_instances	= {}
	self.instance_counter	= 1
	self.damage_counter		= 0

	if self:GetCaster():HasShard() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("shard_fade_time"))
	end
end

function modifier_oracle_false_promise_custom:OnIntervalThink()
	self.invis_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invisible", {})

	if self:GetParent():GetAggroTarget() then
		self:GetParent():MoveToTargetToAttack(self:GetParent():GetAggroTarget())
	end

	self:StartIntervalThink(-1)
end

function modifier_oracle_false_promise_custom:OnDestroy()
	if not IsServer() then return end

	if self.damage_counter < self.heal_counter then
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Healed")

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)

		local heal = self.heal_counter - self.damage_counter

		if heal > self:GetParent():GetMaxHealth() then
			heal = self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()
		end
		
		self:GetParent():Heal(heal, self:GetCaster())
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), heal, nil)
	else
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")

		for _, instance in pairs(self.damage_instances) do
			if self.heal_counter > 0 then
				if self.heal_counter < instance.damage then
					instance.damage = instance.damage - self.heal_counter
					if instance.damage > self:GetParent():GetMaxHealth() then
						instance.damage = self:GetParent():GetMaxHealth() * 1.5
					end
					ApplyDamage(instance)
				end
				local subtraction_value = math.min(instance.damage, self.heal_counter)
				self.heal_counter = self.heal_counter - subtraction_value
				self.damage_counter = self.damage_counter - subtraction_value
			else
				if instance.damage > self:GetParent():GetMaxHealth() then
					instance.damage = self:GetParent():GetMaxHealth() * 1.5
				end
				ApplyDamage(instance)
				if not self:GetParent():IsAlive() then
					break
				end
			end
		end

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_counter, nil)
	end

	if self.invis_modifier and not self.invis_modifier:IsNull() then
		self.invis_modifier:Destroy()
	end
end

function modifier_oracle_false_promise_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end

function modifier_oracle_false_promise_custom:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker and self:GetRemainingTime() >= 0 then

		self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.attacked_particle)
	
		local damage_flags = keys.damage_flags
	
		self.damage_instances[self.instance_counter] = 
		{
			victim			= self:GetParent(),
			damage			= keys.damage,
			damage_type		= DAMAGE_TYPE_PURE,
			damage_flags	= damage_flags + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
			attacker		= keys.attacker,
			ability			= self:GetAbility()
		}
		
		self.instance_counter = self.instance_counter + 1
		self.damage_counter = self.damage_counter + keys.damage

		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		--self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end

	return -99999999
end

function modifier_oracle_false_promise_custom:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		self.heal_counter = self.heal_counter + (keys.gain * 2)
		
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		--self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
end

function modifier_oracle_false_promise_custom:GetDisableHealing(keys)
	return 1
end

function modifier_oracle_false_promise_custom:GetMinHealth()
	return 1
end

function modifier_oracle_false_promise_custom:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_oracle_false_promise_custom:AttackModifier(keys)
	if self:GetCaster():HasShard() and keys.attacker == self:GetParent() and not keys.no_attack_cooldown and self.invis_modifier and not self.invis_modifier:IsNull() then
		self.invis_modifier:Destroy()
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("shard_fade_time"))
	end
end

function modifier_oracle_false_promise_custom:OnAbilityfullCastCustom(keys)
	if self:GetCaster():HasShard() and keys.unit == self:GetParent() and self.invis_modifier and not self.invis_modifier:IsNull() then
		self.invis_modifier:Destroy()
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("shard_fade_time"))
	end
end