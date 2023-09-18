modifier_skill_killgolder = class({})

function modifier_skill_killgolder:IsHidden() return true end
function modifier_skill_killgolder:IsPurgable() return false end
function modifier_skill_killgolder:IsPurgeException() return false end
function modifier_skill_killgolder:RemoveOnDeath() return false end
function modifier_skill_killgolder:AllowIllusionDuplicate() return true end

function modifier_skill_killgolder:OnDeathEvent(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.unit:IsHero() then return end

	local gold = self:GetParent():GetLevel()
	self:GetParent():ModifyGold(gold*1.3, true, 0)
end