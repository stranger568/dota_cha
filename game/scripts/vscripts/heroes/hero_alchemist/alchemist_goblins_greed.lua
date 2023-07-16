LinkLuaModifier( "modifier_alchemist_goblins_greed_custom", "heroes/hero_alchemist/alchemist_goblins_greed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_stack", "heroes/hero_alchemist/alchemist_goblins_greed", LUA_MODIFIER_MOTION_NONE )

alchemist_goblins_greed_custom = class({})

function alchemist_goblins_greed_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
	self:EndCooldown()
	self:GetCaster():EmitSound("SeasonalConsumable.TI9.Shovel.Dig")
	self.point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*120
	self.particle = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_dig.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle, 0, self.point)
end

function alchemist_goblins_greed_custom:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self:GetCaster():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	self:GetCaster():RemoveModifierByName("modifier_alchemist_goblins_greed_custom_anim")

	self:UseResources(false, false, false, true)

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
	end

	if bInterrupted then return end

	local particle = 4

	CreateRune(self.point, DOTA_RUNE_BOUNTY)
end

function alchemist_goblins_greed_custom:GetIntrinsicModifierName()
	return "modifier_alchemist_goblins_greed_custom"
end

modifier_alchemist_goblins_greed_custom = class({})

function modifier_alchemist_goblins_greed_custom:IsPurgable()
	return false
end

function modifier_alchemist_goblins_greed_custom:AllowIllusionDuplicate()
	return false
end

function modifier_alchemist_goblins_greed_custom:OnCreated( kv )
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.base_gold = self.ability:GetSpecialValueFor( "bonus_gold" )
	self.bonus_gold = self.ability:GetSpecialValueFor( "bonus_bonus_gold" )
	self.max_gold = self.ability:GetSpecialValueFor( "bonus_gold_cap" )
	self.duration = self.ability:GetSpecialValueFor( "duration" )
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.actual_stack = 0
	if not IsServer() then return end
end

function modifier_alchemist_goblins_greed_custom:OnRefresh( kv )
	self.base_gold = self.ability:GetSpecialValueFor( "bonus_gold" )
	self.bonus_gold = self.ability:GetSpecialValueFor( "bonus_bonus_gold" )
	self.max_gold = self.ability:GetSpecialValueFor( "bonus_gold_cap" )
	self.duration = self.ability:GetSpecialValueFor( "duration" )
	self.damage = self.ability:GetSpecialValueFor("damage")
	if not IsServer() then return end
	self:CalculateStack()
end

function modifier_alchemist_goblins_greed_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_alchemist_goblins_greed_custom:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.damage
end

function modifier_alchemist_goblins_greed_custom:OnDeathEvent( params )
	if not IsServer() then return end
	if params.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end
	if self.parent:GetTeamNumber()==params.unit:GetTeamNumber() then return end
	if not self.parent:IsAlive() then return end
	local gold = self:GetStackCount()
	PlayerResource:ModifyGold( self.parent:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	self:AddStack()
end

function modifier_alchemist_goblins_greed_custom:AddStack()
	if self.actual_stack * self.bonus_gold < self.max_gold then
		self.actual_stack = self.actual_stack + 1
		self:CalculateStack()
		local modifier = self.parent:AddNewModifier( self:GetCaster(), self.ability, "modifier_alchemist_goblins_greed_custom_stack", {} )
		modifier.parent_modifier = self
	end
end

function modifier_alchemist_goblins_greed_custom:RemoveStack()
	self.actual_stack = self.actual_stack - 1
	self:CalculateStack()
end

function modifier_alchemist_goblins_greed_custom:CalculateStack()
	local max_gold_bonus = self.max_gold
	local stack = math.min( self.base_gold + self.actual_stack*self.bonus_gold, max_gold_bonus )
	self:SetStackCount( stack )
end

modifier_alchemist_goblins_greed_custom_stack = class({})

function modifier_alchemist_goblins_greed_custom_stack:IsHidden()
	return true
end

function modifier_alchemist_goblins_greed_custom_stack:IsPurgable()
	return false
end

function modifier_alchemist_goblins_greed_custom_stack:RemoveOnDeath()
	return true
end

function modifier_alchemist_goblins_greed_custom_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alchemist_goblins_greed_custom_stack:OnDestroy()
	if not IsServer() then return end
	self.parent_modifier:RemoveStack()
end