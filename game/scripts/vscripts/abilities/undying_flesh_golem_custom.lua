LinkLuaModifier("modifier_undying_flesh_golem_custom_fly", "abilities/undying_flesh_golem_custom", LUA_MODIFIER_MOTION_NONE)

undying_flesh_golem_custom = class({})

function undying_flesh_golem_custom:OnToggle() 
	if not IsServer() then return end
	
	local modifier_undying_flesh_golem = self:GetCaster():FindModifierByName("modifier_undying_flesh_golem")

	if not self:GetToggleState() then
		if modifier_undying_flesh_golem then
			modifier_undying_flesh_golem:Destroy()
		end
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_undying_flesh_golem", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_undying_flesh_golem_custom_fly", {})
	end

	self:EndCooldown()
	self:StartCooldown(1) 
end

function undying_flesh_golem_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then 
        if IsClient() then return 15 end
		return 0
	end
	return self.BaseClass.GetManaCost(self,level)
end

function undying_flesh_golem_custom:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return 0
	end
	return self.BaseClass.GetCooldown(self, iLevel) 
end

function undying_flesh_golem_custom:GetBehavior()
  	if self:GetCaster():HasScepter() then
    	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
   	end
 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

function undying_flesh_golem_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_undying_flesh_golem", {duration = self:GetSpecialValueFor("duration")})
end

modifier_undying_flesh_golem_custom_fly = class({})

function modifier_undying_flesh_golem_custom_fly:IsHidden() return true end
function modifier_undying_flesh_golem_custom_fly:IsPurgable() return false end
function modifier_undying_flesh_golem_custom_fly:IsPurgeException() return false end

function modifier_undying_flesh_golem_custom_fly:OnCreated()
	if not IsServer() then return end
    self.caster = self:GetCaster()
	self:StartIntervalThink(0.5)
end

function modifier_undying_flesh_golem_custom_fly:OnIntervalThink()
	if not IsServer() then return end
    self.caster:SpendMana(15*0.5, self:GetAbility())
    if self.caster:GetMana() <= 14 then
        self.caster:RemoveModifierByName("modifier_undying_flesh_golem")
        return
    end
	if not self.caster:HasModifier("modifier_undying_flesh_golem") then
		self:Destroy()
        return
	end
    if not self.caster:HasScepter() then
        self.caster:RemoveModifierByName("modifier_undying_flesh_golem")
        return
    end
end

function modifier_undying_flesh_golem_custom_fly:CheckState()
	if not self.caster:HasScepter() then return end
	return 
	{
		[MODIFIER_STATE_FLYING] = true
	}
end