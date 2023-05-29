item_extra_creature_ogreseal = class({})

function item_extra_creature_ogreseal:IsRefreshable() return false end

function item_extra_creature_ogreseal:OnAbilityPhaseStart()
	if not IsServer() then return end
	if GameMode.currentRound.nRoundNumber < 90 then 
	 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#aviable_70_round"})
		return false
	end
end

function item_extra_creature_ogreseal:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then
	       	   ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_ogreseal_big")
	       	   self:SpendCharge()
	       end
		end
	end
end

