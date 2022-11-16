function CDOTA_BaseNPC:IsMonkeyClone()
	return (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_wukongs_command_warrior"))
end

function CDOTA_BaseNPC:IsMainHero()
	return self and (not self:IsNull()) and self:IsRealHero() and (not self:IsTempestDouble()) and (not self:IsMonkeyClone())
end


-- Has Aghanim's Shard
function CDOTA_BaseNPC:HasShard()
	if not self or self:IsNull() then return end
	return self:HasModifier("modifier_item_aghanims_shard")
end

-- Talent handling
function CDOTA_BaseNPC:HasTalent(talent_name)
	if not self or self:IsNull() then return end

	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() > 0 then return true end
end


function CDOTA_BaseNPC:FindTalentValue(talent_name, key)
	if self:HasTalent(talent_name) then
		local value_name = key or "value"
		return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
	end
	return 0
end


function CDOTA_BaseNPC:GetTalentValue(talent_name)
	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() >= 1 then return talent:GetSpecialValueFor("value") end

	return 0
end


--删除技能保留快捷键
function CDOTA_BaseNPC:RemoveAbilityForEmpty(ability_name)
	local ability = self:FindAbilityByName(ability_name)
	if not ability then return end
	local index = ability:GetAbilityIndex()
	ability:Disable()
	if index <= 5 then
		self:SwapAbilities(ability_name, "empty_"..index, false, false)
	end
	ability:SetRemovalTimer()
end


--重新排序，不保留快捷键
function CDOTA_BaseNPC:RemoveAbilityWithRestructure(ability_name)
	local ability = self:FindAbilityByName(ability_name)
	if not ability then return end

	ability:Disable()
	
	local index = ability:GetAbilityIndex()
	local placeholder_name = "empty_"..index

	self:SwapAbilities(ability_name, placeholder_name, false, false)

	print("Потеря абилки")

	ability:SetRemovalTimer()

	if index > 5 then return end
	Timers:CreateTimer(function()
		--reindexing entire ability tree 
		for i = index, 25 do
			local next_ability = self:GetAbilityByIndex(i + 1)
			if next_ability and not next_ability.placeholder and not next_ability:IsHidden() then
				local next_ability_name = next_ability:GetAbilityName()
				if not next_ability_name:find("special_bonus") then
					self:SwapAbilities(placeholder_name, next_ability_name, false, true)
				end
			end
		end
	end)
end


--给新技能指定快捷键
function CDOTA_BaseNPC:FindHotKeyForAbility(sAbilityName)
   
	Timers:CreateTimer(function()
		for i = 0, 25 do
			local hPlaceholderAability = self:GetAbilityByIndex(i)
			if hPlaceholderAability and hPlaceholderAability:GetAbilityName()	 then
				local sPlaceholderAbilityName = hPlaceholderAability:GetAbilityName()	
				--如果占位的技能 跳出循环
				if sPlaceholderAbilityName == sAbilityName then
					break  
			   end
			   --是占位技能
			   if hPlaceholderAability.nPlaceholder then		
				    self:SwapAbilities(sPlaceholderAbilityName, sAbilityName, false, true)
				    break
				end
			end
		end
	end)

end