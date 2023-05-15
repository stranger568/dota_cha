LinkLuaModifier("modifier_zuus_arc_lightning_custom", "abilities/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_arc_lightning_custom = class({})

function zuus_arc_lightning_custom:OnSpellStart(new_target)
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if new_target then 
		target = new_target
	end

	if target:TriggerSpellAbsorb(self) then return end

	self:StartArc(target, self:GetSpecialValueFor("jump_count"), false)
end

function zuus_arc_lightning_custom:StartArc(target, bounces, not_cast, shard_cast)
	if not IsServer() then return end
	if not not_cast then
		self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
		local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(head_particle)
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_custom", {shard_cast = shard_cast, not_cast = not_cast, starting_unit_entindex = target:entindex(), bounces = bounces })
end

modifier_zuus_arc_lightning_custom = class({})

function modifier_zuus_arc_lightning_custom:IsHidden() return true end
function modifier_zuus_arc_lightning_custom:IsPurgable() return false end
function modifier_zuus_arc_lightning_custom:RemoveOnDeath()	return false end
function modifier_zuus_arc_lightning_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_arc_lightning_custom:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end
	self.arc_damage			= self:GetAbility():GetSpecialValueFor("arc_damage")
	self.total_damage = 1
	self.shard_cast = keys.shard_cast

	if self.shard_cast == 1 then 
		local ability = self:GetParent():FindAbilityByName("zuus_lightning_hands_custom")
		self.total_damage = ability:GetSpecialValueFor("arc_lightning_damage_pct")/100
		if self:GetParent():IsIllusion() then 
			self.total_damage = ability:GetSpecialValueFor("arc_lightning_damage_illusion_pct")/100
		end
	end

	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.jump_count = keys.bounces
	self.jump_delay = self:GetAbility():GetSpecialValueFor("jump_delay")
	self.starting_unit_entindex	= keys.starting_unit_entindex
	self.units_affected = {}
	self.max_per_target = 1
	self.not_cast = keys.not_cast

	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit = EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1
		self:DoDamage(self.current_unit, self.not_cast, self.total_damage)
	else
		self:Destroy()
		return
	end

	self.unit_counter			= 0
	self:StartIntervalThink(self.jump_delay)
end


function modifier_zuus_arc_lightning_custom:DoDamage(target, not_cast, damage_k)
	if not IsServer() then return end
	local damage = self.arc_damage
	damage = damage + (target:GetHealth() / 100 * self:GetAbility():GetSpecialValueFor("damage_health_pct") )
	damage = damage * damage_k
	ApplyDamage({ victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self:GetAbility() })
	if not_cast == 0 then
		target:EmitSound("Hero_Zuus.ArcLightning.Target")
	end
end

function modifier_zuus_arc_lightning_custom:OnIntervalThink()
	self.zapped = false
	
	local team = DOTA_UNIT_TARGET_TEAM_ENEMY

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		if (not self.units_affected[enemy] or self.units_affected[enemy] < self.max_per_target) and enemy ~= self.current_unit then

			if self.not_cast == 0 then
				self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.lightning_particle)
			end

			self.unit_counter = self.unit_counter + 1
			self.previous_unit = self.current_unit
			self.current_unit = enemy
			
			local k = self.total_damage

			if self.units_affected[self.current_unit] then
				self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
				k = self:GetAbility().legendary_damage
			else
				self.units_affected[self.current_unit]	= 1
			end
			self.zapped								= true
			self:DoDamage(enemy, self.not_cast, k)
			break
		end
	end

	if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

LinkLuaModifier("modifier_zuus_lightning_hands_custom_tracker", "abilities/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_lightning_hands_custom = class({})

function zuus_lightning_hands_custom:GetIntrinsicModifierName()
	return "modifier_zuus_lightning_hands_custom_tracker"
end

modifier_zuus_lightning_hands_custom_tracker = class({})

function modifier_zuus_lightning_hands_custom_tracker:IsHidden() return false end
function modifier_zuus_lightning_hands_custom_tracker:IsPurgable() return false end

function modifier_zuus_lightning_hands_custom_tracker:OnCreated(table)
	self.damage = self:GetAbility():GetSpecialValueFor("arc_lightning_damage_pct")
	self.damage_illusions = self:GetAbility():GetSpecialValueFor("arc_lightning_damage_illusion_pct")
end

function modifier_zuus_lightning_hands_custom_tracker:DeclareFunctions()
	return
	{
	    MODIFIER_PROPERTY_TOOLTIP,
	    MODIFIER_PROPERTY_TOOLTIP2,
	    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_zuus_lightning_hands_custom_tracker:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("attack_range_bonus")
end

function modifier_zuus_lightning_hands_custom_tracker:AttackLandedModifier(params)
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if not params.target:IsHero() and not params.target:IsCreep() then return end
	if params.target:IsMagicImmune() then return end
	local arc = self:GetParent():FindAbilityByName("zuus_arc_lightning_custom")
	if not arc then return end
	arc:StartArc(params.target, arc:GetSpecialValueFor("jump_count"), true, 1)
end


function modifier_zuus_lightning_hands_custom_tracker:OnTooltip()
	return self.damage
end

function modifier_zuus_lightning_hands_custom_tracker:OnTooltip2()
	return self.damage_illusions
end