item_paragon_book = class({})


function item_paragon_book:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       

       	   if GetMapName()=="random_1x8" then
               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_random_map_can_not_use"} )
           	   return
           end

	       --如果已经被AI托管,直接给一个技能
	       if hCaster.bTakenOverByBot then
	       	  hCaster.bUsedParagon = true	              
			  hCaster:EmitSound("Item.TomeOfKnowledge")
			  HeroBuilder.totalAbilityNumber[hCaster:GetPlayerID()] = HeroBuilder.totalAbilityNumber[hCaster:GetPlayerID()]+1
	       	  HeroBuilder:ShowRandomAbilitySelection(hCaster:GetPlayerID())       	  	       	  
	       	  self:SpendCharge()
           --如果是正常玩家
	       else
		      if hPlayer then
		       	  --如果正在选技能 不起作用
		          if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility then
		           	  return
		          end
		          if hCaster.bUsedParagon then
	               	  CustomGameEventManager:Send_ServerToPlayer(hPlayer,"OnlyUseOneTime",{})
		           	  return
		          end
	              hCaster.bUsedParagon = true	              
			      hCaster:EmitSound("Item.TomeOfKnowledge")
			      self:SpendCharge()
			      HeroBuilder.totalAbilityNumber[hPlayer:GetPlayerID()] = HeroBuilder.totalAbilityNumber[hPlayer:GetPlayerID()]+1
	              HeroBuilder:ShowRandomAbilitySelection(hPlayer:GetPlayerID())	             
	              Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_paragon_book")
		      end
		   end
		end
	end
end



item_paragon_book_2 = class({})

function item_paragon_book_2:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       

       	   if GetMapName()=="random_1x8" then
               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"SendHudError",{message="dota_hud_error_random_map_can_not_use"} )
           	   return
           end

	       --如果已经被AI托管,直接给一个技能
	       if hCaster.bTakenOverByBot then
	       	  hCaster.bUsedParagon_2 = true	              
			  hCaster:EmitSound("Item.TomeOfKnowledge")
			  HeroBuilder.totalAbilityNumber[hCaster:GetPlayerID()] = HeroBuilder.totalAbilityNumber[hCaster:GetPlayerID()]+1
	       	  HeroBuilder:ShowRandomAbilitySelection(hCaster:GetPlayerID())       	  	       	  
	       	  self:SpendCharge()
           --如果是正常玩家
	       else
		      if hPlayer then
		       	  --如果正在选技能 不起作用
		          if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility then
		           	  return
		          end
		          if hCaster.bUsedParagon_2 then
	               	  CustomGameEventManager:Send_ServerToPlayer(hPlayer,"OnlyUseOneTime",{})
		           	  return
		          end
	              hCaster.bUsedParagon_2 = true	              
			      hCaster:EmitSound("Item.TomeOfKnowledge")
			      self:SpendCharge()
			      HeroBuilder.totalAbilityNumber[hPlayer:GetPlayerID()] = HeroBuilder.totalAbilityNumber[hPlayer:GetPlayerID()]+1
	              HeroBuilder:ShowRandomAbilitySelection(hPlayer:GetPlayerID())	             
	              Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_paragon_book_2")
		      end
		   end
		end
	end
end

