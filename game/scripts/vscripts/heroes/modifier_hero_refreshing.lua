LinkLuaModifier( "modifier_hero_refreshing", "heroes/modifier_hero_refreshing", LUA_MODIFIER_MOTION_NONE )

modifier_hero_refreshing = class({})


function modifier_hero_refreshing:GetTexture()
	return "rune_regen"
end


function modifier_hero_refreshing:IsHidden()
	return false
end

function modifier_hero_refreshing:IsDebuff()
	return false
end

function modifier_hero_refreshing:IsPurgable()
	return false
end

function modifier_hero_refreshing:OnCreated( kv )
	if IsServer() then

		self:GetParent():RemoveModifierByName("modifier_razor_static_link")

		if not self:GetParent():IsRealHero() then return end
		self.flInterval=0.1
		self.nParticleIndex = ParticleManager:CreateParticle("particles/items_fx/bottle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink( self.flInterval )
		--禁用技能表
		self.disableAbilityList={"furion_teleportation", "rubick_spell_steal_custom", "muerta_pierce_the_veil", "pangolier_gyroshell", "life_stealer_infest", "lion_finger_of_death_custom", "lina_laguna_blade_custom", "bounty_hunter_track", "ursa_earthshock", "ursa_enrage", "doom_bringer_doom", "chen_holy_persuasion_custom", "doom_bringer_doom", "abyssal_underlord_firestorm_custom", "pudge_meat_hook", "monkey_king_tree_dance", "oracle_false_promise_custom", "enigma_midnight_pulse_custom", "wisp_relocate","phoenix_supernova","shredder_timber_chain","ancient_apparition_ice_blast","brewmaster_primal_split","life_stealer_infest","axe_berserkers_call","rattletrap_hookshot","magnataur_reverse_polarity","treant_overgrowth","faceless_void_chronosphere","medusa_stone_gaze","venomancer_poison_nova_custom","enigma_black_hole","puck_dream_coil","queenofpain_sonic_wave","warlock_rain_of_chaos","elder_titan_earth_splitter","dawnbreaker_fire_wreath","bristleback_quill_spray","earth_spirit_magnetize"}

	    self:OnIntervalThink()
	end
end

function modifier_hero_refreshing:OnDestroy( kv )
	if IsServer() then
		if not self:GetParent():IsRealHero() then return end
		for _,sAbilityName in ipairs(self.disableAbilityList) do
		   if self:GetParent():HasAbility(sAbilityName) then
		      self:GetParent():FindAbilityByName(sAbilityName):SetActivated(true)
		   end
		end
		ParticleManager:DestroyParticle(self.nParticleIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nParticleIndex)
		for _, unit in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
            if unit:GetOwner() == self:GetCaster() and (unit:GetUnitName() == "npc_dota_lone_druid_bear1" or unit:GetUnitName() == "npc_dota_lone_druid_bear2" or unit:GetUnitName() == "npc_dota_lone_druid_bear3" or unit:GetUnitName() == "npc_dota_lone_druid_bear4") then
                local modifier_heal = unit:FindModifierByName("modifier_hero_refreshing")     
                if modifier_heal then modifier_heal:Destroy() end
                print("delete mod", unit)   
            end
	    end
	    if self:GetParent().tempest_double_hClone then
	    	local modifier_heal = self:GetParent().tempest_double_hClone:FindModifierByName("modifier_hero_refreshing")     
            if modifier_heal then modifier_heal:Destroy() end
            print("delete mod", unit)  
	    end
	end
end


--遍历全部的技能 加速其CD
function modifier_hero_refreshing:OnIntervalThink()
	if IsServer() then

		local save_modifier = {
			["modifier_item_veil_of_discord_debuff"] = true,
			["modifier_item_dustofappearance"] = true,
			["modifier_truesight"] = true,
			["modifier_silencer_global_silence"] = true,
			["modifier_sniper_assassinate"] = true,
			["modifier_sven_stormbolt_hide"] = true,
			["modifier_oracle_fortunes_end_channel_target"] = true,
			["modifier_oracle_fortunes_end_purge"] = true,
			["modifier_item_nullifier_mute"] = true,
			["modifier_item_nullifier_slow"] = true,

		}

		for _, modifier in pairs( self:GetParent():FindAllModifiers() ) do
            if modifier and modifier:GetCaster() ~= self:GetParent() and modifier:IsDebuff() and save_modifier[modifier:GetName()] == nil then
            	local ability_name = ""
            	if modifier:GetAbility() then
            		ability_name = modifier:GetAbility():GetAbilityName()
            	end

            	if ability_name ~= "item_nullifier" then
	            	if modifier:GetDuration() > 1 then
	               		modifier:Destroy()
	               	end
	            end
            end
        end

		if self:GetParent():IsRealHero() then
			for _, unit in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
	            if unit:GetOwner() == self:GetCaster() and (unit:GetUnitName() == "npc_dota_lone_druid_bear1" or unit:GetUnitName() == "npc_dota_lone_druid_bear2" or unit:GetUnitName() == "npc_dota_lone_druid_bear3" or unit:GetUnitName() == "npc_dota_lone_druid_bear4") and not unit:HasModifier("modifier_hero_refreshing") then
	                unit:AddNewModifier(self:GetParent(), nil, "modifier_hero_refreshing", {})  
	                print("add mod", unit)           
	            end
		    end
		    if self:GetParent().tempest_double_hClone then
		    	self:GetParent().tempest_double_hClone:AddNewModifier(self:GetParent(), nil, "modifier_hero_refreshing", {})  
		    end
		end

       for _,sAbilityName in ipairs(self.disableAbilityList) do
		   if self:GetParent():HasAbility(sAbilityName) then
		      self:GetParent():FindAbilityByName(sAbilityName):SetActivated(false)
		   end
	   end
	   
	   if self:GetParent():HasModifier("modifier_ice_blast") then
		  self:GetParent():RemoveModifierByName("modifier_ice_blast")
	   end
	   if self:GetParent():HasModifier("modifier_dazzle_weave_armor") then
		  self:GetParent():RemoveModifierByName("modifier_dazzle_weave_armor")
	   end
	   for i = 1, 30 do
            local hAbility = self:GetParent():GetAbilityByIndex(i - 1)
            if hAbility and hAbility.GetCooldownTimeRemaining then
            	local flRemaining = hAbility:GetCooldownTimeRemaining()
            	if self.flInterval <  flRemaining then
            	   --加快冷却速度 --先结束 再设置 这样UI上比较平滑
            	   hAbility:EndCooldown()
                   hAbility:StartCooldown(flRemaining-self.flInterval)
            	end
            end
            --重置决斗状态
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="custom_legion_commander_duel" then
               hAbility.bRoundDueled=false
            end
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="necrolyte_reapers_scythe" then
               hAbility.bRoundDueled=false
            end
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="lion_finger_of_death_custom" then
               hAbility.bRoundDueled=false
            end
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="bounty_hunter_track" then
               hAbility.bRoundDueled=false
            end
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="lina_laguna_blade_custom" then
               hAbility.bRoundDueled=false
            end
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="axe_culling_blade_custom" then
               hAbility.bRoundDueled=false
            end
            if hAbility and hAbility.GetAbilityName and hAbility:GetAbilityName()=="doom_bringer_devour_custom" then
               hAbility.bRoundDueled=false
            end
        end

        --灌瓶
        if self:GetParent() and self:GetParent():IsRealHero() then
	        for i=0,32 do
		       local hItem=self:GetParent():GetItemInSlot(i)
		       if hItem and not hItem:IsNull() and hItem.GetAbilityName and  "item_bottle"==hItem:GetAbilityName() then
		          local nCurrentCharges = hItem:GetCurrentCharges()
		          -- 0 1 2三种充能
		          if nCurrentCharges<3 and nCurrentCharges>=0 then
		          	 hItem:SetCurrentCharges(nCurrentCharges+1)
		          end
		       end
		    end
		end
		
	end
end

function modifier_hero_refreshing:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end


function modifier_hero_refreshing:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
	}
	return funcs
end

function modifier_hero_refreshing:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_hero_refreshing:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_hero_refreshing:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_hero_refreshing:GetModifierHealthRegenPercentage(params)
	return 4
end

function modifier_hero_refreshing:GetModifierTotalPercentageManaRegen(params)
	return 4
end

 function modifier_hero_refreshing:GetModifierCastRangeBonusStacking(params)
	if params.ability then
		if params.ability.GetCastRange then
			local new = params.ability:GetCastRange(params.ability:GetCaster():GetAbsOrigin(), params.ability:GetCaster()) + self:GetParent():GetCastRangeBonus()
			if new > 0 then
				return (new * 0.5) * -1
			end
		end
	end
end