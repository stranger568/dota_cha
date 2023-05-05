LinkLuaModifier("modifier_phantom_lancer_juxtapose_custom", "heroes/hero_phantom_lancer/phantom_lancer_juxtapose_custom", LUA_MODIFIER_MOTION_NONE)

phantom_lancer_juxtapose_custom = class({})

function phantom_lancer_juxtapose_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function phantom_lancer_juxtapose_custom:OnSpellStart()
	if not IsServer() then return end

	local max_illusions = self:GetSpecialValueFor("max_illusions")

	if self:GetCaster():HasScepter() then
		max_illusions = max_illusions +1
	end

	local illusion_damage_out_pct = self:GetSpecialValueFor("damage") - 100
	local illusion_damage_in_pct = 0

	local illusion_duration = self:GetSpecialValueFor("duration")

	for i = 1, max_illusions do
		local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), 
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
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_custom", {})
			illusion:MoveToPositionAggressive(illusion:GetAbsOrigin())
			illusion:SetMinimumGoldBounty(5)
			illusion:SetMaximumGoldBounty(5)
		end
	end
end

modifier_phantom_lancer_juxtapose_custom = class({})

function modifier_phantom_lancer_juxtapose_custom:IsHidden() return true end
function modifier_phantom_lancer_juxtapose_custom:IsPurgable() return false end

function modifier_phantom_lancer_juxtapose_custom:CheckState()
	return 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end

function modifier_phantom_lancer_juxtapose_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

function modifier_phantom_lancer_juxtapose_custom:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_phantom_lancer_juxtapose_custom:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_phantom_lancer_juxtapose_custom:GetAbsoluteNoDamagePure()
	return 1
end