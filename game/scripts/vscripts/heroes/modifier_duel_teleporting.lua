modifier_duel_teleporting = class({})

function modifier_duel_teleporting:IsHidden() return true end
function modifier_duel_teleporting:IsPurgable() return false end
function modifier_duel_teleporting:RemoveOnDeath() return false end
function modifier_duel_teleporting:IsPurgeException() return false end
function modifier_duel_teleporting:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function modifier_duel_teleporting:OnCreated()
	if not IsServer() then return end
	self.teleportFromEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(self.teleportFromEffect, 2, Vector(255, 255, 255))
	self:GetCaster():EmitSound("Portal.Loop_Appear")
end

function modifier_duel_teleporting:OnDestroy()
	if not IsServer() then return end
	self:GetCaster():StopSound("Portal.Loop_Appear")
	self:GetCaster():StopSound("Hero_Tinker.MechaBoots.Loop")
	if self.teleportFromEffect then
		ParticleManager:DestroyParticle(self.teleportFromEffect, true)
    	ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
    end
end