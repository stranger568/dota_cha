modifier_skill_soul_cleanse = class({})

function modifier_skill_soul_cleanse:IsHidden() return true end
function modifier_skill_soul_cleanse:IsPurgable() return false end
function modifier_skill_soul_cleanse:IsPurgeException() return false end
function modifier_skill_soul_cleanse:RemoveOnDeath() return false end
function modifier_skill_soul_cleanse:AllowIllusionDuplicate() return true end

function modifier_skill_soul_cleanse:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(3)
end

function modifier_skill_soul_cleanse:OnIntervalThink()
	if not IsServer() then return end
	self:GetParent():Purge(false, true, false, true, true)
end