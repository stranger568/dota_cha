item_extra_creature_ogreseal = class({})

function item_extra_creature_ogreseal:IsRefreshable() return false end

function item_extra_creature_ogreseal:OnAbilityPhaseStart()
	if not IsServer() then return end
    if GetMapName() == "1x8_old" then
        if GameMode.currentRound.nRoundNumber < 70 then 
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#aviable_70_round_old"})
           return false
       end
    end
	if GameMode.currentRound.nRoundNumber < 80 then 
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
                if hCaster:HasModifier("modifier_skill_zoo_enjoyer") and self:GetCost() >= 10000 then
                    if RollPercentage(20) then
                        ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_ogreseal_big")
                    end
                end
                local modifier_cashback_creep_count = hCaster:FindModifierByName("modifier_cashback_creep_count")
                if modifier_cashback_creep_count then
                    modifier_cashback_creep_count:Upgrade(self:GetCost())
                end
	       	   ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_ogreseal_big")
	       	   self:SpendCharge()
	       end
		end
	end
end

