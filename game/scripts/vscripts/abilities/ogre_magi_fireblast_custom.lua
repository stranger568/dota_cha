ogre_magi_fireblast_custom = class({})

function ogre_magi_fireblast_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function ogre_magi_fireblast_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor( "stun_duration" )
	local damage = self:GetSpecialValueFor( "fireblast_damage" )

	local cursor_target = self:GetCursorTarget()
	if cursor_target:TriggerSpellAbsorb(self) then return end

	self:GetCaster():EmitSound("Hero_OgreMagi.Fireblast.Cast")
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	for _, target in pairs(enemies) do
		local damageTable = 
		{
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self,
		}

		ApplyDamage( damageTable )
		target:AddNewModifier( self:GetCaster(), self,  "modifier_stunned",  {duration = duration * (1-target:GetStatusResistance())} )
		self:PlayEffects( target )
	end
end

function ogre_magi_fireblast_custom:PlayEffects( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_OgreMagi.Fireblast.Target")
end