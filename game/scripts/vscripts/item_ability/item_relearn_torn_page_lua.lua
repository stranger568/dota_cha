item_relearn_torn_page_lua = class({})

function item_relearn_torn_page_lua:OnSpellStart()
	if not IsServer() then return end
	local hCaster = self:GetCaster()
	local hPlayer = hCaster:GetPlayerOwner()

	if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then

            print(hCaster.bRemovingAbility)

	        if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility then
	        	print("ошибка 1")
	           	return
	        end

	        if hCaster.abilitiesList ==nil or #hCaster.abilitiesList==0 then
	        	print("ошибка 2")
	           	return
	        end

	        local tempList = table.deepcopy(hCaster.abilitiesList)
               
			for sAbilityName,_ in pairs(unremovableAbilities) do         
			    table.remove_item(tempList,sAbilityName)
			end

			if tempList ==nil or #tempList==0 then
				print("ошибка 3")
	           	return
	        end

		    self:SpendCharge()

            local nRandomIndex= RandomInt(1, #tempList)
            local sRemovingAbility = tempList[nRandomIndex]
            hCaster.bRemovingAbility=true
            hCaster.sUISecret = CreateSecretKey()
            HeroBuilder:RelearnBookAbilitySelected({ability_name=sRemovingAbility,player_id=hPlayer:GetPlayerID(),ui_secret=hCaster.sUISecret,torn_page=true})
	        EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)
	        Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_relearn_torn_page_lua")
		end
	else
		print("Ошибка 4")
	end
end

