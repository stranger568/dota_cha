LinkLuaModifier("modifier_storm_spirit_overload_custom", "abilities/storm_spirit_overload_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_overload_custom_buff", "abilities/storm_spirit_overload_custom", LUA_MODIFIER_MOTION_NONE)

storm_spirit_overload_custom = class({})

function storm_spirit_overload_custom:GetIntrinsicModifierName()
	return "modifier_storm_spirit_overload_custom"
end

modifier_storm_spirit_overload_custom = class({})

function modifier_storm_spirit_overload_custom:IsPurgable() return false end
function modifier_storm_spirit_overload_custom:IsHidden() return true end
function modifier_storm_spirit_overload_custom:IsPurgeException() return false end

function modifier_storm_spirit_overload_custom:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_storm_spirit_overload_custom:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_storm_spirit_overload_custom_buff") and self:GetAbility():IsFullyCastable() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_storm_spirit_overload_custom_buff", {})
	end
end

modifier_storm_spirit_overload_custom_buff = class({})

function modifier_storm_spirit_overload_custom_buff:IsPurgable() return false end
function modifier_storm_spirit_overload_custom_buff:IsPurgeException() return false end

function modifier_storm_spirit_overload_custom_buff:OnCreated( kv )
	if not IsServer() then return end
	self.records = {}
	self.duration = 0.8
	self.radius = self:GetAbility():GetSpecialValueFor( "overload_aoe" )
	local damage = self:GetAbility():GetSpecialValueFor( "overload_damage" )
	self.damageTable = 
	{
		attacker = self:GetParent(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
	}
	self:PlayEffects()
end

function modifier_storm_spirit_overload_custom_buff:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
end

function modifier_storm_spirit_overload_custom_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_storm_spirit_overload_custom_buff:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end
	self.records[params.record] = true
end

function modifier_storm_spirit_overload_custom_buff:OnAttackRecordDestroy( params )
	if not IsServer() then return end
	if not self.records[params.record] then return end
	self.records[params.record] = nil
end

function modifier_storm_spirit_overload_custom_buff:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if not self.records[params.record] then return end

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), params.target:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_storm_spirit_overload_debuff", { duration = self.duration } )
	end

	self:PlayEffects2( params.target )

	self:GetAbility():UseResources(false, false, false, true)
	self:Destroy()
end

function modifier_storm_spirit_overload_custom_buff:PlayEffects2( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
	EmitSoundOn( "Hero_StormSpirit.Overload", target )
end