arc_warden_tempest_double_lua = class({})
LinkLuaModifier("modifier_tempest_double_min_health", "heroes/hero_arc_warden/modifier_tempest_double_min_health", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tempest_double_illusion", "heroes/hero_arc_warden/modifier_tempest_double_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tempest_double_hidden", "heroes/hero_arc_warden/modifier_tempest_double_hidden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tempest_double_dying", "heroes/hero_arc_warden/modifier_tempest_double_dying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tempest_double_talent", "heroes/hero_arc_warden/arc_warden_tempest_double_lua", LUA_MODIFIER_MOTION_NONE)


local TRANSFER_PLAIN = 1 -- just add modifier to hClone
local TRANSFER_FULL = 2 -- add modifier and transfer stacks

arc_warden_tempest_double_lua.transferable_modifiers = {
    ["modifier_item_dark_moon_shard"] 		    = TRANSFER_PLAIN,
	["modifier_item_moon_shard_consumed"] 		= TRANSFER_PLAIN,
	["modifier_item_ultimate_scepter_consumed"] = TRANSFER_PLAIN,
	["modifier_item_aghanims_shard"] = TRANSFER_PLAIN,
	['modifier_channel_listener']				= TRANSFER_PLAIN,
	["modifier_book_of_strength"] 				= TRANSFER_FULL,
	["modifier_book_of_intelligence"] 			= TRANSFER_FULL,
	["modifier_book_of_agility"] 				= TRANSFER_FULL,
	["modifier_loser_curse"] 				    = TRANSFER_FULL,
	["modifier_cha_ban"] 				    = TRANSFER_FULL,
}

modifier_tempest_double_talent = class({})

function modifier_tempest_double_talent:IsHidden() return true end

function modifier_tempest_double_talent:IsPurgeException() return false end

function modifier_tempest_double_talent:RemoveOnDeath() return false end

function modifier_tempest_double_talent:IsPurgable() return false end

function modifier_tempest_double_talent:DeclareFunctions()
    local declfuncs = {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE}
    return declfuncs
end

function modifier_tempest_double_talent:GetModifierPercentageCooldown()
    local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_arc_warden_7")
    if talent and talent:GetLevel() > 0 then
        return 50
    end
    return 0
end


function arc_warden_tempest_double_lua:TransferModifiers(hCaster, hClone)
	for name, transfer_type in pairs(self.transferable_modifiers) do
		local hCaster_modifier = hCaster:FindModifierByName(name)
		if hCaster_modifier and not hCaster_modifier:IsNull() then
			local hClone_modifier = hClone:FindModifierByName(name)
			if hClone_modifier then
			else
			   hClone_modifier = hClone:AddNewModifier(hClone, nil, name, {duration = hCaster_modifier:GetDuration()})
			end
			if transfer_type == TRANSFER_FULL then
				hClone_modifier:SetStackCount(hCaster_modifier:GetStackCount())
			end
		end
	end
end


function arc_warden_tempest_double_lua:GetHerohClone()
	local hCaster = self:GetCaster()
	if not hCaster or hCaster:IsNull() then return end
	local hCaster_name = hCaster:GetUnitName()

	if not self.hClone then
		if hCaster.tempest_double_hClone then
			self.hClone = hCaster.tempest_double_hClone
		else
			local hClone = CreateUnitByName(
				hCaster_name, 
				hCaster:GetAbsOrigin(), 
				true, 
				hCaster, 
				hCaster:GetPlayerOwner(),
				hCaster:GetTeamNumber()
			)
			hClone.owner = hCaster
			hClone:AddNewModifier(hCaster, self, "modifier_tempest_double_hidden", {})
         hClone:AddNewModifier(hCaster, self, "modifier_tempest_double_min_health", {})
         hClone:AddNewModifier(hClone, nil, "modifier_spell_amplify_controller", {})
         --hClone:AddNewModifier(hClone, nil, "modifier_arc_warden_tempest_double", {})
         hClone:AddNewModifier(hCaster, nil, "modifier_tempest_double_talent", {})
         hClone:RemoveModifierByName("modifier_fountain_invulnerability")

			hClone.IsRealHero = function() return true end
			hClone.IsMainHero = function() return false end
			hClone.IsTempestDouble = function() return true end

			hClone:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
			hClone:SetRenderColor(0, 0, 190)

			--????????????
			for i=0, 24 do
			   local hAbility = hClone:GetAbilityByIndex(i)
			   if hAbility and not string.find(hAbility:GetAbilityName(), "special_bonus") then
			   	print(hAbility:GetAbilityName(), "delete")
			      hClone:RemoveAbility(hAbility:GetAbilityName())
			   end
			end

			self.hClone = hClone
		end
	end

	while self.hClone:GetLevel() < hCaster:GetLevel() do
		self.hClone:HeroLevelUp( false )
	end

	for index = 0 , 16 do
		local hClone_item = self.hClone:GetItemInSlot(index)
		if hClone_item then
			UTIL_Remove(hClone_item)
		end
	end
    
   --?????????????????????????????????????????????????????????????????????????????????????????? 
   Timers:CreateTimer(0.1, function()
		for index = 0 , 16 do
			if index<=8 or index==16 then
				local hCaster_item = hCaster:GetItemInSlot(index)
				if hCaster_item and not hCaster_item:IsNull() then
					local clonable = hCaster_item:GetKeyValue("IsTempestDoubleClonable") ~= 0
					--????????????????????????
	            if hCaster_item.GetName and hCaster_item:GetName() and hCaster_item:GetName()=="item_smoke_of_deceit" then
	               clonable = false
	            end
					if clonable then
						local hItem = self.hClone:AddItemByName(hCaster_item:GetAbilityName())
						--????????????????????????
						if hItem then
							hItem:SetCombineLocked(true)
						end
					end
				end
			end
		end
	end)
   
	return self.hClone
end


function arc_warden_tempest_double_lua:OnUpgrade()
	if not IsServer() then return end
	--???????????????????????????????????????????????????
	if self:GetCaster():IsIllusion() then return end
    if self:GetCaster():IsTempestDouble() then return end
    if not self:GetCaster():IsRealHero() then return end

	self:GetHerohClone()
end


function arc_warden_tempest_double_lua:OnSpellStart()
	if not IsServer() then return end

	local hCaster = self:GetCaster()
	if not hCaster or hCaster:IsNull() then return end

    --??????????????????????????????????????????????????????????????? ???????????????
	if hCaster:IsTempestDouble() then return end

	local hClone = self:GetHerohClone()
   
   if not hClone or hClone:IsNull() then return end

   local toggle_abilities = {}

   for i=0, 34 do
	   local ability_check_toggle = hClone:GetAbilityByIndex(i)
	   if ability_check_toggle then
	   		local toggle = ability_check_toggle:GetToggleState()
    		if toggle then
    			toggle_abilities[ability_check_toggle:GetAbilityName()] = true
    		end
    	end
	end

	--?????????
	hClone:RespawnHero(false, false)
	hClone:SetHealth(hCaster:GetHealth())
	hClone:SetMana(hCaster:GetMana())
	hClone:SetBaseAgility(hCaster:GetBaseAgility())
	hClone:SetBaseStrength(hCaster:GetBaseStrength())
	hClone:SetBaseIntellect(hCaster:GetBaseIntellect())
	hClone:Purge(true, true, false, true, true)
	hClone:SetAbilityPoints(0)
	hClone:SetHasInventory(false)
	hClone:SetCanSellItems(false)
    

    --???????????????????????????
    for i=0, 34 do
      local hAbility = hClone:GetAbilityByIndex(i)
      if hAbility and hAbility.GetAbilityName then
         local sAbilityName = hAbility:GetAbilityName()
         if not string.find(sAbilityName, "special_bonus") then
         	if not hCaster:HasAbility(sAbilityName) then
            	hClone:RemoveAbility(sAbilityName)
            	Util:RemoveAbilityClean(hClone,sAbilityName)
            end
         end
      end
    end

    --????????????
    for i=0, 34 do
       local hOriginalHeroAbility = hCaster:GetAbilityByIndex(i)
       if hOriginalHeroAbility and hOriginalHeroAbility.GetAbilityName then
          local sOriginalAbilityName = hOriginalHeroAbility:GetAbilityName()
          if not string.find(sOriginalAbilityName, "special_bonus")  and not Illusion.abilityException[sOriginalAbilityName] then
		        local nLevel = hOriginalHeroAbility:GetLevel()
		        if not hClone:HasAbility(sOriginalAbilityName) then
			        if not (sOriginalAbilityName=="tiny_tree_grab_lua" and hClone.bTreeTempGrab) then
			          local hNewAbility=hClone:AddAbility(sOriginalAbilityName)
			          hNewAbility:SetHidden(hOriginalHeroAbility:IsHidden())
			          if nLevel>0 then
			            hNewAbility:SetLevel(nLevel)
			          else
			           hClone:RemoveModifierByName('modifier_'..hNewAbility:GetAbilityName())
			           hClone:RemoveModifierByName('modifier_'..hNewAbility:GetAbilityName()..'_aura')
			          end
			          --?????????????????? ??????????????? ???????????????
			          if sOriginalAbilityName=="tiny_tree_throw_lua" and not hOriginalHeroAbility:IsHidden() then
			             hNewAbility:SetHidden(true)
			             local hTreeGrab=hClone:AddAbility("tiny_tree_grab_lua")
			             if nLevel>0 then
			               hTreeGrab:SetLevel(nLevel)
			             end
			             hClone.bTreeTempGrab=true
			          end
			          if "arc_warden_tempest_double_lua"==sOriginalAbilityName then
			          	 hNewAbility:SetActivated(false)
			          end
			          if "rubick_spell_steal_custom"==sOriginalAbilityName then
			          	 hNewAbility:SetActivated(false)
			          end
			        end
	            --????????????????????????
	            else
                   local hCloneAbility =  hClone:FindAbilityByName(sOriginalAbilityName)
                   if nLevel>0 then
			          hCloneAbility:SetLevel(nLevel)
			       end
	            end
          end
       end
    end

    for i=0, 34 do
	   local hOriginalHeroAbility = hCaster:GetAbilityByIndex(i)
	   if hOriginalHeroAbility and hOriginalHeroAbility.GetAbilityName then
	      local sOriginalAbilityName = hOriginalHeroAbility:GetAbilityName()
	      if not string.find(sOriginalAbilityName, "special_bonus") and not Illusion.abilityException[sOriginalAbilityName] then
		        if hClone:HasAbility(sOriginalAbilityName) and hClone:GetAbilityByIndex(i) and hClone:GetAbilityByIndex(i).GetAbilityName then
		        	local ability_swap = hClone:GetAbilityByIndex(i)
		        	local toggle = ability_swap:GetToggleState()
			    	hClone:SwapAbilities(sOriginalAbilityName, hClone:GetAbilityByIndex(i):GetAbilityName(), true, true)
			    	if ability_swap and string.find(sOriginalAbilityName, "empty_") then
			    		ability_swap:SetHidden(true)
			    	end
			    	--print(ability_swap:GetAbilityName())
			    	--if toggle_abilities[ability_swap:GetAbilityName()] ~= nil then
			    	--	print(ability_swap:GetAbilityName(), ability_swap:GetToggleState())
			    	--	hClone:CastAbilityToggle(ability_swap, 0)
			    	--	Timers:CreateTimer(0.25, function()
			    	--		hClone:CastAbilityToggle(ability_swap, 0)
			    	--	end)
			    	--end
			    end
	    	end
		end
	end

    for i=0, 34 do
       local hOriginalHeroAbility = hCaster:GetAbilityByIndex(i)
       if hOriginalHeroAbility and hOriginalHeroAbility.GetAbilityName then
       		local sOriginalAbilityName = hOriginalHeroAbility:GetAbilityName()
       		if string.find(sOriginalAbilityName, "special_bonus") then

       			if hOriginalHeroAbility:GetLevel() > 0 then
       				local clone_talent = hClone:FindAbilityByName(sOriginalAbilityName)
       				if clone_talent then
       					Timers:CreateTimer(0.25, function()
       						clone_talent:SetLevel(hOriginalHeroAbility:GetLevel())
       					end)
       				end
       			end
       		end
       end
    end

    Timers:CreateTimer(0.25, function()
	    for ability_name, inf in pairs(toggle_abilities) do
	    	local ability = hClone:FindAbilityByName(ability_name)
	    	if ability then
	    		ability:ToggleAbility()
	    	end
	    end
	    local modifier_item_hellmask = self:GetCaster():FindAllModifiersByName("modifier_item_hellmask")
		if #modifier_item_hellmask > 0 then
			local original_modifier_item_hellmask = modifier_item_hellmask[1]
			if original_modifier_item_hellmask then
				local original_item = original_modifier_item_hellmask:GetAbility()
				if original_item then
					local clone_item = hClone:FindItemInInventory("item_hellmask")
					if clone_item then
						clone_item:SetCurrentCharges(original_item:GetCurrentCharges())
					end
				end
			end
		end

		local rubick_empty1 = self:GetCaster():FindAbilityByName("rubick_empty1")
		if rubick_empty1 then
			print(rubick_empty1:IsHidden())
			if rubick_empty1:IsHidden() then
				local rubick_empty1_clone = hClone:FindAbilityByName("rubick_empty1")
				if rubick_empty1_clone then
					rubick_empty1_clone:SetHidden(true)
				end
			end
		end

		local rubick_empty2 = self:GetCaster():FindAbilityByName("rubick_empty2")
		if rubick_empty2 then
			print(rubick_empty2:IsHidden())
			if rubick_empty2:IsHidden() then
				local rubick_empty2_clone = hClone:FindAbilityByName("rubick_empty2")
				if rubick_empty2_clone then
					rubick_empty2_clone:SetHidden(true)
				end
			end
		end

		local modifier_lion_finger_of_death_custom_passive = self:GetCaster():FindModifierByName("modifier_lion_finger_of_death_custom_passive")
		if modifier_lion_finger_of_death_custom_passive then
			local modifier_lion_finger_of_death_custom_passive_clone = hClone:FindModifierByName("modifier_lion_finger_of_death_custom_passive")
			if modifier_lion_finger_of_death_custom_passive_clone then
				modifier_lion_finger_of_death_custom_passive_clone:SetStackCount(modifier_lion_finger_of_death_custom_passive:GetStackCount())
			end
		end

		local modifier_lina_laguna_blade_custom_passive = self:GetCaster():FindModifierByName("modifier_lina_laguna_blade_custom_passive")
		if modifier_lina_laguna_blade_custom_passive then
			local modifier_lina_laguna_blade_custom_passive_clone = hClone:FindModifierByName("modifier_lina_laguna_blade_custom_passive")
			if modifier_lina_laguna_blade_custom_passive_clone then
				modifier_lina_laguna_blade_custom_passive_clone:SetStackCount(modifier_lina_laguna_blade_custom_passive:GetStackCount())
			end
		end
    end)


	self:TransferModifiers(hCaster, hClone)
    
   hClone:RemoveModifierByName("modifier_life_stealer_infest")
   	hClone:RemoveModifierByName("modifier_life_stealer_infest_enemy_hero")
	hClone:RemoveModifierByName("modifier_life_stealer_infest_effect")
	hClone:RemoveModifierByName("modifier_life_stealer_infest_creep")
	hClone:RemoveModifierByName("modifier_fountain_invulnerability")

	local duration = self:GetSpecialValueFor("duration") + hCaster:GetTalentValue("special_bonus_unique_arc_warden_6")

	hCaster.tempest_double_hClone = hClone

	hClone:RemoveGesture(ACT_DOTA_DIE)

	FindClearRandomPositionAroundUnit(hClone, hCaster, 100)
	hClone:AddNewModifier(hCaster, self, "modifier_tempest_double_illusion", {duration=duration})
	hClone:AddNewModifier(hCaster, nil, "modifier_tempest_double_talent", {})

	while hClone:HasModifier("modifier_tempest_double_dying") do
        hClone:RemoveModifierByName("modifier_tempest_double_dying")
	end

	while hClone:HasModifier("modifier_tempest_double_hidden") do
        hClone:RemoveModifierByName("modifier_tempest_double_hidden")
	end

	--????????????  ????????????????????????
   hClone:RemoveModifierByName("modifier_pudge_rot")
   --??????????????????
   hClone:RemoveModifierByName("modifier_leshrac_pulse_nova")
   --????????????
   hClone:RemoveModifierByName("modifier_bloodseeker_blood_mist_custom")
   hClone:RemoveModifierByName("modifier_fountain_invulnerability")


	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt(particle, 0, hCaster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle, true)
		ParticleManager:ReleaseParticleIndex(particle)
	end)
	
	hCaster:EmitSound("Hero_ArcWarden.TempestDouble")
end

function close_empty_all(hero)
	for i=1,5 do
		local ability = hero:FindAbilityByName("empty_"..i)
		if ability then
			ability:SetHidden(true)
		end
	end
end