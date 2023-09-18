modifier_skill_solo = class({})

function modifier_skill_solo:IsHidden() return true end
function modifier_skill_solo:IsPurgable() return false end
function modifier_skill_solo:IsPurgeException() return false end
function modifier_skill_solo:RemoveOnDeath() return false end
function modifier_skill_solo:AllowIllusionDuplicate() return true end

function modifier_skill_solo:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_skill_solo:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsRealHero() then
        local gold = 322 / 60
        if GameMode.currentRound and GameMode.currentRound.nRoundNumber > 90 then
            gold = 640 / 60
        end
		self:GetParent():ModifyGold(math.ceil(gold), true, DOTA_ModifyXP_Outpost)
	end
end