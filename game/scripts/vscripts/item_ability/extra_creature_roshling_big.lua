item_extra_creature_roshling_big = class({})

function item_extra_creature_roshling_big:OnSpellStart()
	if IsServer() then
		print("alloo")
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then
	       	   ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_roshling_big")
	       	   self:SpendCharge()
	       end
		end
	end
end

