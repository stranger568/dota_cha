item_spell_book_empty_lua = class({})
	


function item_spell_book_empty_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
    if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua") then
        if hPlayer then
           local nPlayerID = hPlayer:GetPlayerID()
           --如果正在选技能 卷轴不起作用
           if hCaster.bSelectingAbility or hCaster.bRemovingAbility or hCaster.bSelectingSpellBook or hCaster.bOmniscientBookRemoving or hCaster.bOmniscientBookSelectingAbility then
           	   return
           end
           self:SpendCharge()
           hCaster.bSelectingSpellBook=true
           hCaster.sUISecret= CreateSecretKey()
           local nPlayerID = hPlayer:GetPlayerID()
           CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowSpellBookAbilitySelection",{ui_secret=hCaster.sUISecret})
           EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)

           Util:RecordConsumableItem(hPlayer:GetPlayerID(),"item_spell_book_empty_lua")
        end
    end
	end
end

