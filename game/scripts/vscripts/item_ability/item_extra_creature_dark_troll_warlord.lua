item_extra_creature_dark_troll_warlord = class({})


function item_extra_creature_dark_troll_warlord:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then
	       	   ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_dark_troll_warlord")
	       	   self:SpendCharge()
	       end
		end
	end
end

