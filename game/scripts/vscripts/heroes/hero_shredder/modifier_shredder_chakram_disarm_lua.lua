modifier_shredder_chakram_disarm_lua = class({})

function modifier_shredder_chakram_disarm_lua:IsDebuff() return false end
function modifier_shredder_chakram_disarm_lua:IsPurgable() return false end
function modifier_shredder_chakram_disarm_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shredder_chakram_disarm_lua:OnCreated()
	if not IsServer() then return end
	
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_disarm.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
	ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
	self:AddParticle(particle, false, false, -1, false, true)
end

function modifier_shredder_chakram_disarm_lua:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end
