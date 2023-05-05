modifier_skill_deposit = class({})

function modifier_skill_deposit:IsHidden() return true end
function modifier_skill_deposit:IsPurgable() return false end
function modifier_skill_deposit:IsPurgeException() return false end
function modifier_skill_deposit:RemoveOnDeath() return false end
function modifier_skill_deposit:AllowIllusionDuplicate() return true end

function modifier_skill_deposit:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:StartIntervalThink(1)
end

function modifier_skill_deposit:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount() == 5 then
		self:SetStackCount(0)
		local gold = math.min(self:GetParent():GetGold(), 20000)
		local bonus_gold = gold / 100 * 20
		self:GetParent():ModifyGold(bonus_gold, true, 0)
	end
end