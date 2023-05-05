LinkLuaModifier( "modifier_abaddon_borrowed_time_custom", "heroes/hero_abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_buff", "heroes/hero_abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )

abaddon_borrowed_time_custom = class({})

function abaddon_borrowed_time_custom:GetIntrinsicModifierName()
	if self:GetCaster():IsRealHero() then
		return "modifier_abaddon_borrowed_time_custom"
	end
end

function abaddon_borrowed_time_custom:OnSpellStart()
	if not IsServer() then return end
	local buff_duration = self:GetSpecialValueFor("duration")
	self:GetCaster():Purge(false, true, false, true, false)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_abaddon_borrowed_time_custom_buff", { duration = buff_duration })
end

modifier_abaddon_borrowed_time_custom = class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
})

function modifier_abaddon_borrowed_time_custom:_CheckHealth(damage)
	local target = self:GetParent()
	local ability = self:GetAbility()
	if not ability:IsHidden() and ability:IsCooldownReady() and not target:PassivesDisabled() and target:IsAlive() then
		local hp_threshold = self.hp_threshold
		local current_hp = target:GetHealth()
		if current_hp <= hp_threshold then
			target:CastAbilityImmediately(ability, target:GetPlayerID())
		end
	end
end

function modifier_abaddon_borrowed_time_custom:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		if target:IsIllusion() then
			self:Destroy()
		else
			self.hp_threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")
			self:_CheckHealth(0)
		end
	end
end

function modifier_abaddon_borrowed_time_custom:DeclareFunctions()
	local funcs = {
		--MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function modifier_abaddon_borrowed_time_custom:TakeDamageScriptModifier(kv)
	if IsServer() then
		local target = self:GetParent()
		if target == kv.unit then
			self:_CheckHealth(kv.original_damage)
		end
	end
end

function modifier_abaddon_borrowed_time_custom:OnStateChanged(kv)
	if IsServer() then
		local target = self:GetParent()
		if target == kv.unit then
			self:_CheckHealth(0)
		end
	end
end

modifier_abaddon_borrowed_time_custom_buff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
	GetStatusEffectName		= function(self) return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end,
	StatusEffectPriority	= function(self) return 15 end,
})

function modifier_abaddon_borrowed_time_custom_buff:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_abaddon_borrowed_time_custom_buff:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		self.target_current_health = target:GetHealth()
		target._borrowed_time_buffed_allies = {}
		target:EmitSound("Hero_Abaddon.BorrowedTime")
		target:Purge(false, true, false, true, false)
		for _, mod in pairs(self:GetParent():FindAllModifiers()) do
			print(mod:GetName())
		end
	end
end

function modifier_abaddon_borrowed_time_custom_buff:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_abaddon_borrowed_time_custom_buff:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_abaddon_borrowed_time_custom_buff:GetAbsoluteNoDamagePure()
	return 1
end

--function modifier_abaddon_borrowed_time_custom_buff:GetModifierIncomingDamage_Percentage(kv)
--	if IsServer() then
--		local target 	= self:GetParent()
--		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
--		local target_vector = target:GetAbsOrigin()
--		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
--		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
--		ParticleManager:ReleaseParticleIndex(heal_particle)
--		target:Heal(kv.original_damage, target)
--		return -9999999
--	end
--end

function modifier_abaddon_borrowed_time_custom_buff:GetModifierTotal_ConstantBlock(params)
    if not IsServer() then return end
    if params.original_damage <= 0 then return end

    if self:GetParent():GetHealth() <= self:GetParent():GetMaxHealth() then
    	local heal = params.original_damage
    	if heal > self:GetParent():GetMaxHealth() then
    		heal = self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()
    	end
    	self:GetParent():Heal(heal, self:GetAbility())
    end

    print(params.damage, params.original_damage)

    return params.original_damage
end


