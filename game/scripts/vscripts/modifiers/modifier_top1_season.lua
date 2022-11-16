modifier_top1_season = class({})

function modifier_top1_season:IsHidden() return true end
function modifier_top1_season:IsPurgable() return false end
function modifier_top1_season:RemoveOnDeath() return false end
function modifier_top1_season:AllowIllusionDuplicate() return true end

function modifier_top1_season:OnCreated()
	if not IsServer() then return end
	local particle = ParticleManager:CreateParticle("particles/top_1_season.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle, false, false, -1, false, false)
end


