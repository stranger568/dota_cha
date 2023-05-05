LinkLuaModifier("modifier_skill_swiftness_buff", "modifiers/skills/modifier_skill_swiftness", LUA_MODIFIER_MOTION_NONE)

modifier_skill_swiftness = class({})

function modifier_skill_swiftness:IsHidden() return true end
function modifier_skill_swiftness:IsPurgable() return false end
function modifier_skill_swiftness:IsPurgeException() return false end
function modifier_skill_swiftness:RemoveOnDeath() return false end
function modifier_skill_swiftness:AllowIllusionDuplicate() return true end

function modifier_skill_swiftness:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.01)
end

function modifier_skill_swiftness:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_item_dark_moon_shard") then
		self:GetParent():RemoveModifierByName("modifier_skill_swiftness_buff")
	else
		if not self:GetParent():HasModifier("modifier_skill_swiftness_buff") then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_swiftness_buff", {})
		end
	end
end

modifier_skill_swiftness_buff = class({})

function modifier_skill_swiftness_buff:IsHidden() return true end
function modifier_skill_swiftness_buff:IsPurgable() return false end
function modifier_skill_swiftness_buff:IsPurgeException() return false end
function modifier_skill_swiftness_buff:RemoveOnDeath() return false end
function modifier_skill_swiftness_buff:AllowIllusionDuplicate() return true end

function modifier_skill_swiftness_buff:OnCreated()
	local flBaseAttackTime = self:GetParent():GetBaseAttackTime()
    if self:GetParent():HasModifier('modifier_item_dark_moon_shard') then
    	self.flBaseAttackTime = (flBaseAttackTime* (100-23)/100) - 0.2
    else
    	self.flBaseAttackTime = flBaseAttackTime - 0.2
    end
end

function modifier_skill_swiftness_buff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end

function modifier_skill_swiftness_buff:GetModifierBaseAttackTimeConstant()
	if self.flBaseAttackTime then
        return self.flBaseAttackTime
    end
end