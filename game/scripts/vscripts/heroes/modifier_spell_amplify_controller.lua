--法强处理器
modifier_spell_amplify_controller = class({})

function modifier_spell_amplify_controller:IsHidden() return true end
function modifier_spell_amplify_controller:IsDebuff() return false end
function modifier_spell_amplify_controller:IsPurgable() return false end
function modifier_spell_amplify_controller:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_spell_amplify_controller:RemoveOnDeath() return false end

function modifier_spell_amplify_controller:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end


function modifier_spell_amplify_controller:OnCreated()
	self:SetHasCustomTransmitterData(true)
	if IsClient() then return end
	Timers:CreateTimer(0.05, function()
		self:OnRefresh()
		return 0.05
	end)
	self:OnRefresh()
end


function modifier_spell_amplify_controller:OnRefresh()
	if IsClient() then return end
	if self:IsNull() then return end
	
	self:SetValues()
	self:SendBuffRefreshToClients()
end

function modifier_spell_amplify_controller:SetValues()

    if self and (not self:IsNull()) and self:GetParent() and (not self:GetParent():IsNull()) and self:GetParent().GetIntellect and self:GetParent().flSP then
       self.spell_amplify = self:GetParent().flSP * self:GetParent():GetIntellect()
    else
       self.spell_amplify = 0
    end
    --print("self.spell_amplify"..self.spell_amplify)
end

function modifier_spell_amplify_controller:AddCustomTransmitterData()
	return {
		spell_amplify = self.spell_amplify,
	}
end

function modifier_spell_amplify_controller:HandleCustomTransmitterData(data)
	self.spell_amplify = tonumber(data.spell_amplify)
end



if IsClient() then 
	function modifier_spell_amplify_controller:GetModifierSpellAmplify_Percentage(params)	
      return self.spell_amplify
	end 
end

if IsServer() then

local percentage_abilities = {
	["abyssal_underlord_firestorm_custom"] = true,
	["elder_titan_earth_splitter"] = true,
	["winter_wyvern_arctic_burn"] = true,
	["doom_bringer_infernal_blade"] = true,
	["enigma_midnight_pulse_custom"] = true,
	["enigma_black_hole"] = true,
	["zeus_static_field_lua"] = true,
	["huskar_life_break"] = true,
	["phoenix_sun_ray"] = true,
	["spectre_dispersion"] = true,
	["death_prophet_spirit_siphon"] = true,
	["custom_phantom_assassin_fan_of_knives"] = true,
	["bloodseeker_rupture"] = true,
	["item_spirit_vessel"] = true,
	["terrorblade_reflection_lua"] = true,
	["venomancer_poison_nova"] = true,
	["necrolyte_reapers_scythe_datadriven"] = true,
	["necrolyte_heartstopper_aura_lua"] = true,
	["zuus_static_field"] = true,
	["item_blade_mail"] = true,
	["item_iron_talon"] = true,
	["sandking_caustic_finale"] = true,
	["sandking_caustic_finale_lua"] = true,
	["jakiro_liquid_ice"] = true,
	["jakiro_liquid_ice_lua"] = true,
	["witch_doctor_maledict"] = true,
	["bloodseeker_blood_mist_custom"] = true,
	["witch_doctor_voodoo_restoration"] = true,
	["item_shivas_guard_2"] = true,
	["meepo_ransack_custom"] = true,
	["shadow_demon_disseminate"] = true,
	["dragon_knight_elder_dragon_form_custom"] = true,
}


local dot_abilities=
{
	["venomancer_venomous_gale"] = true,
	["venomancer_poison_sting"] = true,
	["viper_poison_attack"] = true,
	["viper_corrosive_skin"] = true,
	["viper_viper_strike"] = true,
	["viper_nethertoxin"] = true,
	["crystal_maiden_frostbite_custom"] = true,
	["axe_battle_hunger_custom"] = true,
	["doom_bringer_doom"] = true,
	["earth_spirit_magnetize"] = true,
	["huskar_burning_spear"] = true,
	["frostivus2018_huskar_burning_spear"] = true,
	["phoenix_icarus_dive"] = true,
	["phoenix_fire_spirits"] = true,
	["pudge_rot"] = true,
	["alchemist_acid_spray"] = true,
	["treant_natures_grasp"] = true,
	["treant_leech_seed_custom"] = true,
	["treant_overgrowth"] = true,
	["ember_spirit_searing_chains"] = true,
	["bane_fiends_grip"] = true,
	["bane_nightmare"] = true,
	["dazzle_poison_touch"] = true,
	["disruptor_thunder_strike"] = true,
	["disruptor_static_storm"] = true,
	["jakiro_dual_breath"] = true,
	["jakiro_liquid_fire_lua"] = true,
	["ogre_magi_ignite_custom"] = true,
	["shadow_demon_shadow_poison"] = true,
	["silencer_curse_of_the_silent"] = true,
	["warlock_shadow_word"] = true,
	["skeleton_king_hellfire_blast"] = true,
	["queenofpain_shadow_strike"] = true,
	["shredder_chakram_lua"] = true,
	["shredder_chakram_2_lua"] = true,
	["sniper_shrapnel"] = true,
	["ancient_apparition_cold_feet_custom"] = true,
	["item_meteor_hammer"] = true,
	["item_urn_of_shadows"] = true,
	["item_fallen_sky"] = true,
	["item_radiance"] = true,
	["dark_seer_ion_shell"] = true,
	["jakiro_macropyre"] = true,
	["batrider_flamebreak"] = true,
	["batrider_flaming_lasso"] = true,
	["templar_assassin_psionic_trap"] = true,
	["brewmaster_cinder_brew"] = true,
	["dark_willow_bramble_maze"] = true,
	["shadow_shaman_shackles_custom"] = true,
	["invoker_ice_wall_lod"] = true,
	["batrider_firefly"] = true,
	["sandking_sand_storm"] = true,
	["sandking_epicenter"] = true,
	["broodmother_silken_bola"] = true,
	["item_cloak_of_flames"] = true,
	["dragon_knight_fireball"] = true,
	["ancient_apparition_ice_vortex"] = true,
	["dawnbreaker_celestial_hammer"] = true,
	["dawnbreaker_solar_guardian"] = true,
	["shredder_flamethrower"] = true,
	["grimstroke_spirit_walk"] = true,
	["pugna_life_drain"]= true,
	["pugna_life_drain_custom"]= true,
	["doom_bringer_scorched_earth"]= true,
	["warlock_upheaval"] = true,
	["slark_dark_pact"] = true,
	["item_giants_ring"]= true,
	["ember_spirit_flame_guard_custom"]= true,
	["viper_viper_strike_custom"]= true,
	["meepo_ransack_custom"] = true,
	["furion_curse_of_the_forest"] = true,
	["witch_doctor_voodoo_restoration"] = true,
}


function modifier_spell_amplify_controller:GetModifierSpellAmplify_Percentage(params)	
   
   
	local inflictor = params.inflictor
	local target = params.target

	if inflictor and not inflictor:IsNull() then
		local ability_name = inflictor:GetAbilityName()
		local parent = self:GetParent()

		if percentage_abilities[ability_name] and (ability_name ~= "enigma_black_hole" or parent:HasScepter()) 
		   and (ability_name ~= "witch_doctor_voodoo_restoration" or parent:HasTalent("special_bonus_unique_witch_doctor_2"))  then
			return 0
		end
    
		local bHeroTarget = false
      
		if target and not target:IsNull() then
			if target.IsRealHero and target:IsRealHero() and target.GetUnitName and string.find(target:GetUnitName(),"npc_dota_hero") == 1 then
             bHeroTarget = true
			end
		end

		if dot_abilities[ability_name] and parent.GetIntellect and parent.flDotSP then
			if bHeroTarget then
				return 0.35 * parent.flDotSP * (parent:GetIntellect()+parent:GetStrength()+parent:GetAgility()) + self.spell_amplify * 0.2
			else
				return parent.flDotSP * (parent:GetIntellect()+parent:GetStrength()+parent:GetAgility()) + self.spell_amplify
			end
		end
      
      	if bHeroTarget then
	      	if inflictor and inflictor:GetAbilityName() == "silencer_glaives_of_wisdom_custom" then
	      		return self.spell_amplify * 0.02
	      	end

      		return self.spell_amplify * 0.2
      	end

	end

	return self.spell_amplify

end

end