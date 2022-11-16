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

			--移除技能
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
    
   --添加道具与删除道具留一个间隔，修复虚无主义在分身不显示的问题 
   Timers:CreateTimer(0.1, function()
		for index = 0 , 16 do
			if index<=8 or index==16 then
				local hCaster_item = hCaster:GetItemInSlot(index)
				if hCaster_item and not hCaster_item:IsNull() then
					local clonable = hCaster_item:GetKeyValue("IsTempestDoubleClonable") ~= 0
					--诡计之雾不能复制
	            if hCaster_item.GetName and hCaster_item:GetName() and hCaster_item:GetName()=="item_smoke_of_deceit" then
	               clonable = false
	            end
					if clonable then
						local hItem = self.hClone:AddItemByName(hCaster_item:GetAbilityName())
						--风暴双雄锁定合成
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
	--避免幻象与风暴双雄本身触发风暴双雄
	if self:GetCaster():IsIllusion() then return end
    if self:GetCaster():IsTempestDouble() then return end
    if not self:GetCaster():IsRealHero() then return end

	self:GetHerohClone()
end


function arc_warden_tempest_double_lua:OnSpellStart()
	if not IsServer() then return end

	local hCaster = self:GetCaster()
	if not hCaster or hCaster:IsNull() then return end

    --超新星会激活复制体的风暴双雄，此处加入判断 避免此情况
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

	--先复活
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
    

    --移除本体没有的技能
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

    --添加技能
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
			          --英雄正在抓树 赠一个抓树 不重复给予
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
	            --有技能，补全等级
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

	--关闭腐烂  修复腐烂无限叠加
   hClone:RemoveModifierByName("modifier_pudge_rot")
   --关闭脉冲新星
   hClone:RemoveModifierByName("modifier_leshrac_pulse_nova")
   --关闭血雾
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