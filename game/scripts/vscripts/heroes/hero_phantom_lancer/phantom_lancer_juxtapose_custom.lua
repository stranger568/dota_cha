LinkLuaModifier("modifier_phantom_lancer_juxtapose_custom", "heroes/hero_phantom_lancer/phantom_lancer_juxtapose_custom", LUA_MODIFIER_MOTION_NONE)

phantom_lancer_juxtapose_custom = class({})

function phantom_lancer_juxtapose_custom:GetIntrinsicModifierName()
	return "modifier_phantom_lancer_juxtapose_custom"
end

function phantom_lancer_juxtapose_custom:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function phantom_lancer_juxtapose_custom:OnSpellStart()
	if not IsServer() then return end

	local modifier = self:GetCaster():FindModifierByName("modifier_phantom_lancer_juxtapose_custom")

	local max_illusions = self:GetSpecialValueFor("max_illusions") + 1
	local illusion_duration = self:GetSpecialValueFor("illusion_duration") + 10
	local illusion_damage_out_pct = self:GetSpecialValueFor("illusion_damage_out_pct")
	local illusion_damage_in_pct = self:GetSpecialValueFor("illusion_damage_in_pct")

	if modifier then

		for ill = #modifier.owner.juxtapose_table, 1, -1 do
			local illusion_entity = EntIndexToHScript(modifier.owner.juxtapose_table[ill])
			if illusion_entity then
				illusion_entity:ForceKill(false)
			end
			table.remove(modifier.owner.juxtapose_table, ill)
		end

		for i = 1, max_illusions do
			local illusions = CreateIllusions(modifier.owner, self:GetCaster(), 
			{
				outgoing_damage = illusion_damage_out_pct,
				incoming_damage	= illusion_damage_in_pct,
				bounty_base		= 5,
				bounty_growth	= 0,
				outgoing_damage_structure	= 0,
				outgoing_damage_roshan		= 0,
				duration		= illusion_duration
			}
			, 1, 72, false, true)
			
			for _, illusion in pairs(illusions) do
				self.spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 0, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 1, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.spawn_particle)
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
				illusion:MoveToPositionAggressive(illusion:GetAbsOrigin())
				illusion:SetMinimumGoldBounty(5)
				illusion:SetMaximumGoldBounty(5)
				table.insert(modifier.owner.juxtapose_table, illusion:entindex())
			end
		end
	end
end

modifier_phantom_lancer_juxtapose_custom = class({})

function modifier_phantom_lancer_juxtapose_custom:IsHidden() return true end
function modifier_phantom_lancer_juxtapose_custom:IsPurgable() return false end

function modifier_phantom_lancer_juxtapose_custom:OnCreated()
	self.duration = 0
	
	self.directional_vectors = {
		Vector(72, 0, 0),
		Vector(0, -72, 0),
		Vector(-72, 0, 0),
		Vector(0, 72, 0)
	}
	
	if not IsServer() then return end
	
	if self:GetParent():IsRealHero() then
		self.owner = self:GetParent()
		
		self.owner.juxtapose_table = {}
	elseif not self:GetParent():IsRealHero() and self:GetParent():GetOwner() and self:GetParent():GetOwner():GetAssignedHero() then
		self.owner = self:GetParent():GetOwner():GetAssignedHero()
	end
end

function modifier_phantom_lancer_juxtapose_custom:DeclareFunctions()
	return {
		--MODIFIER_EVENT_ON_ATTACK_LANDED,
		--MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_phantom_lancer_juxtapose_custom:AttackLandedModifier(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() and self.owner and self.owner.juxtapose_table and not self.owner:PassivesDisabled() then

		if keys.no_attack_cooldown then return end
		if self:GetParent():IsIllusion() then return end

		if self:GetParent():IsRealHero() and RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance_pct")) then
			self.duration = self:GetAbility():GetSpecialValueFor("illusion_duration")
		elseif not self:GetParent():IsRealHero() and RollPercentage(self:GetAbility():GetSpecialValueFor("illusion_proc_chance_pct")) then
			self.duration = self:GetAbility():GetSpecialValueFor("illusion_from_illusion_duration")
		end

		local max_illusions = self:GetAbility():GetSpecialValueFor("max_illusions")

		if self:GetParent():HasScepter() then
			self.duration = self.duration + 10
			max_illusions = max_illusions + 1
		end
		
		if #(self.owner.juxtapose_table) < max_illusions and self.duration > 0 and self.owner.juxtapose_table then
			local illusions = CreateIllusions(self.owner, self:GetParent(), 
			{
				outgoing_damage = self:GetAbility():GetSpecialValueFor("illusion_damage_out_pct"),
				incoming_damage	= self:GetAbility():GetSpecialValueFor("illusion_damage_in_pct"),
				bounty_base		= 5,
				bounty_growth	= 0,
				outgoing_damage_structure	= 0,
				outgoing_damage_roshan		= 0,
				duration		= self.duration
			}
			, 1, 72, false, true)
			
			for _, illusion in pairs(illusions) do
				self.spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 0, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 1, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.spawn_particle)
			
				illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_phantom_lancer_juxtapose_illusion", {})
				illusion:SetAggroTarget(keys.target)

				illusion:SetMinimumGoldBounty(5)
				illusion:SetMaximumGoldBounty(5)
				
				table.insert(self.owner.juxtapose_table, illusion:entindex())
			end
		end
		self.duration = 0
	end
end

function modifier_phantom_lancer_juxtapose_custom:OnDeathEvent(keys)
	if keys.unit == self:GetParent() and self.owner and not self.owner:IsNull() and self.owner.juxtapose_table then
		Custom_ArrayRemove(self.owner.juxtapose_table, function(i, j)
			return self.owner.juxtapose_table[i] ~= self:GetParent():entindex()
		end)
	end
end

function Custom_ArrayRemove(t, fnKeep)
	local j, n = 1, #t;

	for i=1,n do
		if (fnKeep(i, j)) then
			if (i ~= j) then
				t[j] = t[i];
				t[i] = nil;
			end
			j = j + 1;
		else
			t[i] = nil;
		end
	end

	return t;
end