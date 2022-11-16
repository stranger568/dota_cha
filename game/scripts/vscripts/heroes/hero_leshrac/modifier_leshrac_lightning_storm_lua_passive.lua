modifier_leshrac_lightning_storm_lua_passive = class({})

function modifier_leshrac_lightning_storm_lua_passive:IsHidden()
	return true
end

function modifier_leshrac_lightning_storm_lua_passive:IsDebuff()
	return false
end

function modifier_leshrac_lightning_storm_lua_passive:IsPurgable()
	return false
end


function modifier_leshrac_lightning_storm_lua_passive:OnCreated()
	if IsServer() then
		--self.interval_scepter = self:GetAbility():GetSpecialValueFor( "interval_scepter" )
		self.radius_scepter = self:GetAbility():GetSpecialValueFor( "radius_scepter" )
		self.duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
		self:StartIntervalThink( 1.75 )
    end
end

function modifier_leshrac_lightning_storm_lua_passive:OnRefresh()
	if IsServer() then
		self.radius_scepter = self:GetAbility():GetSpecialValueFor( "radius_scepter" )
		self.duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
    end
end


function modifier_leshrac_lightning_storm_lua_passive:OnIntervalThink()
    
    if IsServer() then
	    if self:GetParent():HasScepter() and self:GetParent():HasModifier("modifier_leshrac_pulse_nova") then
            
			local enemies = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),	

				self:GetParent():GetOrigin(),
				nil,
				self.radius_scepter,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
				FIND_CLOSEST,
				false
			)

			if #enemies>0 then
				print("123")
	           local hTarget = table.random(enemies)

	           if hTarget then
	              print(hTarget:GetUnitName())
	           	  local damageTable = {
	                    victim = hTarget,
						attacker = self:GetParent(),
						damage = self:GetAbility():GetAbilityDamage(),
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility(),
				  }
			      ApplyDamage(damageTable)
	              hTarget:AddNewModifier(
						self:GetParent(),
						self:GetAbility(),
						"modifier_leshrac_lightning_storm_lua",
						{
							duration = self.duration,
							slow = self.slow,
						}
				  )
				 -- Create Particle
				 local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
				 ParticleManager:SetParticleControl( effect_cast, 0, hTarget:GetOrigin() + Vector( 0, 0, 800 ) )
				 ParticleManager:SetParticleControlEnt(
					effect_cast,
					1,
					hTarget,
					PATTACH_POINT_FOLLOW,
					"attach_hitloc",
					Vector(0,0,0),
					true
				 )
				 ParticleManager:ReleaseParticleIndex( effect_cast )
				 EmitSoundOn( "Hero_Leshrac.Lightning_Storm", hTarget )
	           end
			end
	    end
	end

end
