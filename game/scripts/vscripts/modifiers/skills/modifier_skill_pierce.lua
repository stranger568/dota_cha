LinkLuaModifier("modifier_skill_pierce_debuff", "modifiers/skills/modifier_skill_pierce", LUA_MODIFIER_MOTION_NONE)

modifier_skill_pierce = class({})

function modifier_skill_pierce:IsHidden() return true end
function modifier_skill_pierce:IsPurgable() return false end
function modifier_skill_pierce:IsPurgeException() return false end
function modifier_skill_pierce:RemoveOnDeath() return false end
function modifier_skill_pierce:AllowIllusionDuplicate() return true end

function modifier_skill_pierce:OnCreated( kv )
	if not IsServer() then return end
	self.records = {}
	self.procs = false
end

function modifier_skill_pierce:DeclareFunctions()
	return 
	{
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
	}
end

function modifier_skill_pierce:OnAttackLanded( params )
	if self:GetParent():PassivesDisabled() then return end
	if not self.records[params.record] then return end
	local modifier = params.target:AddNewModifier( self:GetParent(), nil, "modifier_skill_pierce_debuff", { duration = 1 } )
	self.records[params.record] = modifier
end

function modifier_skill_pierce:OnAttackStart( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker~=self:GetParent() then return end
	local rand = RandomInt( 0, 100 )
	if RollPercentage(45) then
		self.procs = true
	end
end

function modifier_skill_pierce:OnAttack( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker~=self:GetParent() then return end
	if not self.procs then return end
	self.procs = false
	self.records[params.record] = true
end

function modifier_skill_pierce:OnAttackRecordDestroy( params )
	if not self.records[params.record] then return end
	if self:GetParent():PassivesDisabled() then return end
	local modifier = self.records[params.record]
	if type(modifier)=='table' and not modifier:IsNull() then modifier:Destroy() end
	self.records[params.record] = nil
end

modifier_skill_pierce_debuff = class({})

function modifier_skill_pierce_debuff:IsHidden()
	return false
end

function modifier_skill_pierce_debuff:IsDebuff()
	return true
end

function modifier_skill_pierce_debuff:IsStunDebuff()
	return false
end

function modifier_skill_pierce_debuff:IsPurgable()
	return false
end

function modifier_skill_pierce_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_skill_pierce_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE,
	}
	return funcs
end

function modifier_skill_pierce_debuff:GetModifierPhysicalArmorBase_Percentage()
	if IsClient() then 
		return 100 
	end
	return 0
end