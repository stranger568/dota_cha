modifier_skill_golden_warrior = class({})

function modifier_skill_golden_warrior:IsHidden() return true end
function modifier_skill_golden_warrior:IsPurgable() return false end
function modifier_skill_golden_warrior:IsPurgeException() return false end
function modifier_skill_golden_warrior:RemoveOnDeath() return false end
function modifier_skill_golden_warrior:AllowIllusionDuplicate() return true end

function modifier_skill_golden_warrior:OnDeathEvent(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.unit:IsHero() then return end

	local gold = params.unit:GetMaximumGoldBounty()
	
	if gold > 0 then
		local bonus = gold + ( gold * 0.7)
		self:GetParent():ModifyGold(bonus, true, 0)
	end
end