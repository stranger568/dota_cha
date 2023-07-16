modifier_aegis_buff_rebirth = class({})

function modifier_aegis_buff_rebirth:IsDebuff()
	return false
end
function modifier_aegis_buff_rebirth:GetTexture()
	return "omniknight_repel"
end

function modifier_aegis_buff_rebirth:IsPurgable()
  return false
end

function modifier_aegis_buff_rebirth:OnCreated(table)
     local nWingsParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
     ParticleManager:SetParticleControl(nWingsParticleIndex, 0, self:GetParent():GetAbsOrigin())
     ParticleManager:SetParticleControlEnt(nWingsParticleIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
     self:AddParticle(nWingsParticleIndex, false, false, -1, false, false)    

    -- Halo particle
    local nHaloParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(nHaloParticleIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)    
    self:AddParticle(nHaloParticleIndex, false, false, -1, false, false)    
end

function modifier_aegis_buff_rebirth:DeclareFunctions()
  local funcs = 
  {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  }

  return funcs
end


function modifier_aegis_buff_rebirth:GetModifierIncomingDamage_Percentage()
     return -65
end

function modifier_aegis_buff_rebirth:GetModifierTotalDamageOutgoing_Percentage()
     return 40
end