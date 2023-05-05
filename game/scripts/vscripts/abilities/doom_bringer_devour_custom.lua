LinkLuaModifier("modifier_doom_bringer_devour_custom", "abilities/doom_bringer_devour_custom", LUA_MODIFIER_MOTION_NONE)

doom_bringer_devour_custom = class({})

doom_bringer_devour_custom.bRoundDueled = false

function doom_bringer_devour_custom:CastFilterResultTarget( target )

	if target:IsAncient() then
		return UF_FAIL_ANCIENT
	end

	if target:GetLevel() > self:GetSpecialValueFor("creep_level") then
		return UF_FAIL_ANCIENT
	end

	local nResult = UnitFilter(
		target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)

	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function doom_bringer_devour_custom:OnSpellStart()
	if not IsServer() then return end
	local target = self:GetCursorTarget()

	if not target:IsAlive() then
		self:EndCooldown()
        self:RefundManaCost()
		return
	end
	
	local duration = self:GetSpecialValueFor( "duration" )

	if self.bRoundDueled == false then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_doom_bringer_devour_custom", { duration = self:GetCooldown(self:GetLevel()) } )
		self.bRoundDueled = true
	end

	self:PlayEffects( target )
	target:SetOrigin( target:GetOrigin() + Vector( 0, 0, -200 ) )
	target:Kill(self, self:GetCaster())
end

function doom_bringer_devour_custom:PlayEffects( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():EmitSound("Hero_DoomBringer.Devour")
	target:EmitSound("Hero_DoomBringer.DevourCast")
end

modifier_doom_bringer_devour_custom = class({})

function modifier_doom_bringer_devour_custom:IsPurgable()
	return false
end

function modifier_doom_bringer_devour_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_doom_bringer_devour_custom:RemoveOnDeath()
	return false
end

function modifier_doom_bringer_devour_custom:OnCreated( kv )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_doom_bringer_devour_custom:OnDestroy()
	if not IsServer() then return end
	if self:GetParent():IsAlive() then
		PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )
	end
end

function modifier_doom_bringer_devour_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
	return funcs
end

function modifier_doom_bringer_devour_custom:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_doom_bringer_devour_custom:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end