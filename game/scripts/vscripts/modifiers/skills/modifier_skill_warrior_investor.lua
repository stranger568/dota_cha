LinkLuaModifier("modifier_skill_damage_investor", "modifiers/skills/modifier_skill_damage_investor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_armor_investor", "modifiers/skills/modifier_skill_armor_investor.lua", LUA_MODIFIER_MOTION_NONE)

modifier_skill_warrior_investor = class({})

function modifier_skill_warrior_investor:IsHidden() return true end
function modifier_skill_warrior_investor:IsPurgable() return false end
function modifier_skill_warrior_investor:IsPurgeException() return false end
function modifier_skill_warrior_investor:RemoveOnDeath() return false end
function modifier_skill_warrior_investor:AllowIllusionDuplicate() return true end

function modifier_skill_warrior_investor:OnCreated()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_skill_damage_investor", {})
	self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_skill_armor_investor", {})
end