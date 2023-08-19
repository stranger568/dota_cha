LinkLuaModifier("modifier_lina_flame_cloak_custom", "abilities/lina_flame_cloak_custom", LUA_MODIFIER_MOTION_NONE)

lina_flame_cloak_custom = class({})

function lina_flame_cloak_custom:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_flame_cloak", {duration = self:GetSpecialValueFor("flame_cloak_duration")})
end

function lina_flame_cloak_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then 
        if IsClient() then return 15 end
		return 0
	end
	return self.BaseClass.GetManaCost(self,level)
end

function lina_flame_cloak_custom:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return 0
	end
	return self.BaseClass.GetCooldown(self, iLevel) 
end

function lina_flame_cloak_custom:GetBehavior()
  	if self:GetCaster():HasScepter() then
    	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
   	end
 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

function lina_flame_cloak_custom:OnToggle() 
	if not IsServer() then return end
	
	local modifier_lina_flame_cloak = self:GetCaster():FindModifierByName("modifier_lina_flame_cloak")

	if not self:GetToggleState() then
		if modifier_lina_flame_cloak then
			modifier_lina_flame_cloak:Destroy()
		end
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_flame_cloak", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_flame_cloak_custom", {})
	end

	self:EndCooldown()
	self:StartCooldown(1) 
end

modifier_lina_flame_cloak_custom = class({})

function modifier_lina_flame_cloak_custom:IsHidden() return true end
function modifier_lina_flame_cloak_custom:IsPurgable() return false end
function modifier_lina_flame_cloak_custom:IsPurgeException() return false end

function modifier_lina_flame_cloak_custom:OnCreated()
	if not IsServer() then return end
    self.caster = self:GetCaster()
	self:StartIntervalThink(0.5)
end

function modifier_lina_flame_cloak_custom:OnIntervalThink()
	if not IsServer() then return end
    self.caster:SpendMana(15*0.5, self:GetAbility())
    if self.caster:GetMana() <= 14 then
        self.caster:RemoveModifierByName("modifier_lina_flame_cloak")
        return
    end
	if not self.caster:HasModifier("modifier_lina_flame_cloak") then
		self:Destroy()
        return
	end
    if not self.caster:HasScepter() then
        self.caster:RemoveModifierByName("modifier_lina_flame_cloak")
        return
    end
end