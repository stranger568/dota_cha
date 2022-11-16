luna_lucent_beam_custom = class({})

function luna_lucent_beam_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function luna_lucent_beam_custom:OnAbilityPhaseStart()
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( particle, 1, Vector(0.4,0,0) )
	ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( particle )
	return true
end

function luna_lucent_beam_custom:OnSpellStart()
	if not IsServer() then return end
	
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end
	local duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("beam_damage")
	
	local radius = self:GetSpecialValueFor("radius")
	
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
	
	self:GetCaster():EmitSound("Hero_Luna.LucentBeam.Cast")

	for _, unit in pairs(units) do
		ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE })
		unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = duration})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl( particle, 0, unit:GetOrigin() )
		ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( particle, 5, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( particle, 6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
		ParticleManager:ReleaseParticleIndex( particle )
		unit:EmitSound("Hero_Luna.LucentBeam.Target")

		if self:GetCaster():HasShard() then
			if self:GetCaster():IsRangedAttacker() then
				if self:GetCaster():HasTalent("special_bonus_unique_luna_8") then
					Timers:CreateTimer(0.07, function()
						if unit and not unit:IsNull() and unit:IsAlive() and not unit:IsAttackImmune() and not unit:IsInvulnerable() then
							self:GetCaster():PerformAttack(unit, true, true, true, false, true, false, false)
						end
					end)
				end
				self:GetCaster():PerformAttack(unit, true, true, true, false, true, false, false)
			else
				if self:GetCaster():HasTalent("special_bonus_unique_luna_8") then
					Timers:CreateTimer(0.07, function()
						if unit and not unit:IsNull() and unit:IsAlive() and not unit:IsAttackImmune() and not unit:IsInvulnerable() then
							self:GetCaster():PerformAttack(unit, true, true, true, false, true, false, false)
						end
					end)
				end
				self:GetCaster():PerformAttack(unit, true, true, true, false, false, false, false)
			end
		end
	end
end