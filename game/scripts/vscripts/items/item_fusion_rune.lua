item_fusion_rune_custom = class({})

function item_fusion_rune_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), nil, "modifier_rune_arcane", {duration = 50})
	caster:AddNewModifier(self:GetCaster(), nil, "modifier_rune_doubledamage", {duration = 45})
	caster:AddNewModifier(self:GetCaster(), nil, "modifier_rune_haste", {duration = 22})
	caster:AddNewModifier(self:GetCaster(), nil, "modifier_rune_illusion", {duration = FrameTime()})
	caster:AddNewModifier(self:GetCaster(), nil, "modifier_rune_invis", {duration = 45})
	caster:AddNewModifier(self:GetCaster(), nil, "modifier_rune_regen", {duration = 30})
	self:SpendCharge()
end







