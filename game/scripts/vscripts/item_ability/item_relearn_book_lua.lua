item_relearn_book_lua = class({})


function item_relearn_book_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then
	       	   --如果正在选技能 不起作用
	           if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility then
	           	   return
	           end

	           if GetMapName()=="random_1x8" then
	               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_random_map_can_not_use"} )
	           	   return
	           end
	           
	           local hook = hCaster:FindAbilityByName("pudge_meat_hook")
	           if hook then
	           		hook:SetActivated(false)
	           end

	           Quests_arena:QuestProgress(self:GetCaster():GetPlayerOwnerID(), 27, 1)
	           Quests_arena:QuestProgress(self:GetCaster():GetPlayerOwnerID(), 68, 2)

		       self:SpendCharge()
		       hCaster.bRemovingAbility = true
		       hCaster.sUISecret= CreateSecretKey()
		       local nPlayerID = hPlayer:GetPlayerID()
	           CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowRelearnBookAbilitySelection",{ui_secret=hCaster.sUISecret})
	           EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)

	           Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_relearn_book_lua")
	       end
		end
	end
end

