item_chaos_scroll_lua = class({})


function item_chaos_scroll_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then

	       	   --如果正在选技能 不起作用
	           if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility then
	           	   return
	           end
	           if hCaster.abilitiesList ==nil or #hCaster.abilitiesList==0 then
	           	   return
	           end

	           if GetMapName()~="random_1x8" then
	               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_only_random_map"} )
	           	   return
	           end

	           local tempList = table.deepcopy(hCaster.abilitiesList)
               
               --不可移除的技能 不能被删除
			   for sAbilityName,_ in pairs(unremovableAbilities) do         
			       table.remove_item(tempList,sAbilityName)
			   end

			   if tempList ==nil or #tempList==0 then
	           	   return
	           end

		       self:SpendCharge()
               local nRandomIndex= RandomInt(1, #tempList)
               local sRemovingAbility = tempList[nRandomIndex]
               hCaster.bRemovingAbility=true
               hCaster.sUISecret = CreateSecretKey()
               HeroBuilder:RelearnBookAbilitySelected({ability_name=sRemovingAbility,player_id=hPlayer:GetPlayerID(),chaos_scroll=true,ui_secret=hCaster.sUISecret,torn_page=true})
	           EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)
               

	           Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_chaos_scroll_lua")
	       end
		end
	end
end

