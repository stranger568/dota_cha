silencer_last_word_custom = class({})

function silencer_last_word_custom:GetAOERadius()
	return self:GetSpecialValueFor("scepter_radius")
end

function silencer_last_word_custom:OnSpellStart()
	if not IsServer() then return end
	local point = self:GetCursorPosition()
	local cursor_target = self:GetCursorTarget()
	if cursor_target:TriggerSpellAbsorb(self) then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("scepter_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	for _, target in pairs(enemies) do
		target:AddNewModifier(self:GetCaster(), self, "modifier_silencer_last_word", {duration = self:GetSpecialValueFor("duration")})
		self:PlayEffects( target )
	end
end

function silencer_last_word_custom:PlayEffects( target )
	local direction = target:GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_silencer/silencer_last_word_status_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Silencer.LastWord.Cast", self:GetCaster() )
end
