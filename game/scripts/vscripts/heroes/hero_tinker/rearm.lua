--[[
	Author: kritth
	Date: 7.1.2015.
	Put modifier to override animation on cast
]]
function rearm_start( keys )
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_rearm_level_" .. abilityLevel .. "_datadriven", {} )
end

--[[
	Author: kritth
	Date: 7.1.2015.
	Refresh cooldown
]]
function rearm_refresh_cooldown( keys )
	local caster = keys.caster

	local ability_exempt_table = {}
    ability_exempt_table["phoenix_supernova"]=true
    ability_exempt_table["arc_warden_tempest_double"]=true
    ability_exempt_table["arc_warden_tempest_double_lua"]=true
    ability_exempt_table["zuus_thundergods_wrath"]=true
    ability_exempt_table["furion_wrath_of_nature"]=true
    ability_exempt_table["ancient_apparition_ice_blast"]=true
    ability_exempt_table["spectre_haunt"]=true
    ability_exempt_table["silencer_global_silence"]=true
    ability_exempt_table["skeleton_king_reincarnation"]=true
    ability_exempt_table["abaddon_borrowed_time_custom"]=true
    ability_exempt_table["oracle_false_promise_custom"]=true
    ability_exempt_table["dazzle_shallow_grave"]=true
    ability_exempt_table["slark_shadow_dance"]=true
    ability_exempt_table["dark_willow_shadow_realm"]=true
    ability_exempt_table["slark_depth_shroud"]=true
    ability_exempt_table["undying_tombstone_lua"]=true
    ability_exempt_table["shadow_shaman_mass_serpent_ward"]=true
    ability_exempt_table["warlock_rain_of_chaos"]=true
    ability_exempt_table["rattletrap_overclocking"]=true
    ability_exempt_table["rattletrap_jetpack"]=true
    ability_exempt_table["dazzle_good_juju_lua"]=true
    ability_exempt_table["dazzle_good_juju"]=true
    ability_exempt_table["alchemist_goblins_greed_custom"]=true
    ability_exempt_table["slark_depth_shroud_custom"]=true
    ability_exempt_table["slark_shadow_dance_custom"]=true
    ability_exempt_table["chen_holy_persuasion_custom"]=true
    ability_exempt_table["razor_static_link"]=true
    ability_exempt_table["puck_phase_shift_custom"]=true
    ability_exempt_table["muerta_pierce_the_veil"]=true

    local ability_discount_table = {}
    ability_discount_table["faceless_void_chronosphere"]= 0.4
    ability_discount_table["zuus_cloud"]= 0.5
    ability_discount_table["mirana_arrow"]= 0.5
    ability_discount_table["night_stalker_hunter_in_the_night_custom"]= 0.5
    ability_discount_table["doom_bringer_devour_custom"]= 0.5

	for i = 0, caster:GetAbilityCount() - 1 do
		local hAbility = caster:GetAbilityByIndex( i )
		if hAbility
		and not ability_exempt_table[hAbility:GetAbilityName()] 
		and not (caster:HasModifier("modifier_hero_refreshing") and "razor_eye_of_the_storm"==hAbility:GetAbilityName())   then

			local flRatio = 1
		    if ability_discount_table[hAbility:GetAbilityName()]~=nil then
	           flRatio = ability_discount_table[hAbility:GetAbilityName()]
	        end

	        local flEffectiveCooldown = hAbility:GetEffectiveCooldown(hAbility:GetLevel()-1)
	        local flCurrentCooldown = hAbility:GetCooldownTimeRemaining()

	        --如果100%刷新
	        if flRatio>0.99 then
	           hAbility:EndCooldown()
	        else
		        if flCurrentCooldown - flEffectiveCooldown*flRatio<=0 then
		        	hAbility:EndCooldown()
		        else
		            hAbility:EndCooldown()
		            hAbility:StartCooldown(flCurrentCooldown-flEffectiveCooldown*flRatio)
		        end
		    end

		end
	end
	
	-- Put item exemption in here
	local exempt_table = {}
	exempt_table["item_hand_of_midas"]=true
    exempt_table["item_refresher"]=true
    exempt_table["item_black_king_bar"]=true
    exempt_table["item_arcane_boots"]=true
    exempt_table["item_guardian_greaves"]=true
    exempt_table["item_sphere"]=true
    exempt_table["item_aeon_disk"]=true
    exempt_table["item_demonicon"]=true
    exempt_table["item_aeon_disk_lua"]=true
    exempt_table["item_refresher_custom"]=true
    exempt_table["item_ex_machina_custom"]=true
    


	-- Reset cooldown for items
	for i = 0, 5 do
		local item = caster:GetItemInSlot( i )
		if item and not exempt_table[item:GetAbilityName()] then
			item:EndCooldown()
		end
	end
end
