modifier_top2_season = class({})

function modifier_top2_season:IsHidden() return true end
function modifier_top2_season:IsPurgable() return false end
function modifier_top2_season:RemoveOnDeath() return false end
function modifier_top2_season:AllowIllusionDuplicate() return true end

function modifier_top2_season:OnCreated()
	if not IsServer() then return end
	local particle = ParticleManager:CreateParticle("particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle, false, false, -1, false, false)
end


