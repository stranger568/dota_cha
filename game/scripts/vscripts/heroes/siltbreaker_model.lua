LinkLuaModifier("modifier_siltbreaker_model", "heroes/siltbreaker_model", LUA_MODIFIER_MOTION_NONE)

siltbreaker_model = class({})

function siltbreaker_model:GetIntrinsicModifierName()
	return "modifier_siltbreaker_model"
end

modifier_siltbreaker_model = class({})

function modifier_siltbreaker_model:IsHidden() return true end

function modifier_siltbreaker_model:OnCreated()
	if not IsServer() then return end
	self:GetParent():SetMaterialGroup("2")
end