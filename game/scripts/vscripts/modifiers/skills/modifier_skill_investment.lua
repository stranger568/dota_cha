modifier_skill_investment = class({})

function modifier_skill_investment:IsHidden() return true end
function modifier_skill_investment:IsPurgable() return false end
function modifier_skill_investment:IsPurgeException() return false end
function modifier_skill_investment:RemoveOnDeath() return false end
function modifier_skill_investment:AllowIllusionDuplicate() return true end

function modifier_skill_investment:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:StartIntervalThink(1)
end

function modifier_skill_investment:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount() == 5 then
		self:SetStackCount(0)
		local gold =math.ceil(PlayerResource:GetGoldPerMin(self:GetParent():GetPlayerID()) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[self:GetParent():GetPlayerID()]
        gold = math.max(gold, PlayerResource:GetNetWorth(self:GetParent():GetPlayerID()))
        gold = math.min(gold, 200000)
		local bonus_gold = gold / 100 * 3
		self:GetParent():ModifyGold(bonus_gold, true, 0)
	end
end