item_summon_book_lua = class({})


function item_summon_book_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then
	       	   --如果正在选技能 不起作用
	           if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook  or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility   then
	           	   return
	           end
	           if hCaster.abilitiesList ==nil or #hCaster.abilitiesList==0 then
	           	   return
	           end

		       if GetMapName()=="random_1x8" then
	               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_random_map_can_not_use"} )
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

	           --第二次排除
               local tempList2 = table.deepcopy(tempList)
            
			   --排除召唤类技能
			   for _,sAbilityName in ipairs(HeroBuilder.summonAbilities) do         
			       table.remove_item(tempList2,sAbilityName)
			   end
               
               -- 如果排除召唤后 不剩下技能
			   if tempList2 ==nil or #tempList2==0 then
	           	  tempList2 = table.deepcopy(tempList)
	           end

	           if tempList2 ==nil or #tempList2==0 then
	           	   return
	           end

		       self:SpendCharge()
               local nRandomIndex= RandomInt(1, #tempList2)
               local sRemovingAbility = tempList2[nRandomIndex]
               hCaster.bRemovingAbility=true
               hCaster.sUISecret = CreateSecretKey()
               HeroBuilder:RelearnBookAbilitySelected({ability_name=sRemovingAbility,player_id=hPlayer:GetPlayerID(),summon_book=true,ui_secret=hCaster.sUISecret})
	           EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)


	           Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_summon_book_lua")
	       end
		end
	end
end

