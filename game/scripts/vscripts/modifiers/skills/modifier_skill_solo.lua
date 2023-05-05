modifier_skill_solo = class({})

function modifier_skill_solo:IsHidden() return true end
function modifier_skill_solo:IsPurgable() return false end
function modifier_skill_solo:IsPurgeException() return false end
function modifier_skill_solo:RemoveOnDeath() return false end
function modifier_skill_solo:AllowIllusionDuplicate() return true end

function modifier_skill_solo:OnCreated()
	if not IsServer() then return end
	self.bonus_gold_min = 322 / 60
	self:StartIntervalThink(1)
end

function modifier_skill_solo:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsRealHero() then
		self:GetParent():ModifyGold(self.bonus_gold_min, true, DOTA_ModifyXP_Outpost)
	end
end