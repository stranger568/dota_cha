LinkLuaModifier( "modifier_rubick_spell_steal_custom_buff", "heroes/hero_rubick/rubick_spell_steal_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_spell_steal_custom", "heroes/hero_rubick/rubick_spell_steal_custom", LUA_MODIFIER_MOTION_NONE )

rubick_spell_steal_custom = class({})
rubick_spell_steal_custom_slot1 = class({})
rubick_spell_steal_custom_slot2 = class({})

--- Переменные

-- Информация о последнем использованном скилле у врага
rubick_spell_steal_custom.heroesData = {}

-- Информация о сворованном скилле у рубика
rubick_spell_steal_custom.stolenSpell = nil

rubick_spell_steal_custom.currentSpell = nil
rubick_spell_steal_custom.currentSpell_2 = nil

-- Абилки для слотов

rubick_spell_steal_custom.slot1 = "rubick_empty1"
rubick_spell_steal_custom.slot2 = "rubick_empty2"

function rubick_spell_steal_custom:GetIntrinsicModifierName()
	return "modifier_rubick_spell_steal_custom"
end

function rubick_spell_steal_custom:Spawn()
	if not IsServer() then return end
	Timers:CreateTimer(0.1, function()
		if self:GetCaster():IsAlive() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rubick_spell_steal_custom", {})
		else
			return 0.1
		end
	end)
end

function rubick_spell_steal_custom:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function rubick_spell_steal_custom:CastFilterResultTarget( hTarget )
	if IsServer() then
		if self:GetLastSpell( hTarget )==nil then
			return UF_FAIL_OTHER
		end
		if self:GetLastSpell( hTarget ):GetAbilityName() == "rubick_spell_steal_custom" then
			return UF_FAIL_OTHER
		end
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)

	if hTarget == self:GetCaster() then
		return UF_FAIL_OTHER
	end

	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

rubick_spell_steal_custom.activate_ability = nil

function rubick_spell_steal_custom:OnAbilityPhaseStart()

end

function rubick_spell_steal_custom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	self.activate_ability = true

	self.stolenSpell = {}
	self.stolenSpell.lastSpell = self:GetLastSpell( target )

	local info = {
		Target = caster,
		Source = target,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf",
		iMoveSpeed = 1200,
		vSourceLoc = target:GetAbsOrigin(),             
		bDrawsOnMinimap = false,                         
		bDodgeable = false,                               
		bVisibleToEnemies = true,                        
		bReplaceExisting = false,                         
	}

	ProjectileManager:CreateTrackingProjectile(info)

	target:EmitSound("Hero_Rubick.SpellSteal.Target")
end

function rubick_spell_steal_custom:OnProjectileHit( target, location )
	if target == nil then return end
	if not target:IsAlive() then return end

	local useless = false
	
	for i=0, 32 do
		local ability = self:GetCaster():GetAbilityByIndex(i)
		if ability and ability:GetAbilityName() == self.stolenSpell.lastSpell:GetAbilityName() then
			if ability ~= self.currentSpell then
				useless = true
			end
		end
	end

	if useless then
		return
	end

	self:SetStolenSpell( self.stolenSpell )
	self.stolenSpell = nil
	local steal_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier( self:GetCaster(), self, "modifier_rubick_spell_steal_custom_buff", { duration = steal_duration } )
	target:EmitSound("Hero_Rubick.SpellSteal.Complete")
end


-- Устанавливаем последнюю использованную способность героем
function rubick_spell_steal_custom:SetLastSpell( hHero, hSpell )
	local heroData = nil
	for _,data in pairs(rubick_spell_steal_custom.heroesData) do
		if data.handle==hHero then
			heroData = data
			break
		end
	end

	if heroData then
		heroData.lastSpell = hSpell
	else
		local newData = {}
		newData.handle = hHero
		newData.lastSpell = hSpell
		table.insert( rubick_spell_steal_custom.heroesData, newData )
	end
end
-- Получить последнюю способность
function rubick_spell_steal_custom:GetLastSpell( hHero )
	local heroData = nil
	for _,data in pairs(rubick_spell_steal_custom.heroesData) do
		if data.handle==hHero then
			heroData = data
			break
		end
	end

	if heroData then
		return heroData.lastSpell
	end

	return nil
end


-- Функция кражи способности
function rubick_spell_steal_custom:SetStolenSpell( spellData )
	local spell = spellData.lastSpell

	-- Удаление старой способности

	if self.currentSpell ~= nil then
		self:ForgetSpell()
		print("delte 2")
	end

	-------------------------------------------------------------------------------------------------------

    local old_spell = false
    for _,hSpell in pairs(self:GetCaster().spell_steal_history) do
        if hSpell ~= nil and hSpell:GetAbilityName() == spell:GetAbilityName() then
            old_spell = true
            break
        end
    end

    if old_spell then
	    for id,hSpell in pairs(self:GetCaster().spell_steal_history) do
	        if hSpell ~= nil and hSpell:GetAbilityName() == spell:GetAbilityName() then
	            table.remove(self:GetCaster().spell_steal_history, id)
	        end
	    end
        self.currentSpell = self:GetCaster():FindAbilityByName(spell:GetAbilityName())
    else
        self.currentSpell = self:GetCaster():AddAbility( spell:GetAbilityName() )
        self.currentSpell.rubick_spell = true
        self.currentSpell:SetStolen(true)
        self.currentSpell:SetRefCountsModifiers(true)
    end

    self.currentSpell:SetHidden(false)
	self.currentSpell:SetLevel( spell:GetLevel() )
	self:GetCaster():SwapAbilities( self.slot1, self.currentSpell:GetAbilityName(), false, true )
end

-- Функция удаления способности
function rubick_spell_steal_custom:ForgetSpell()
	if self.currentSpell~=nil then
		self.currentSpell:SetRefCountsModifiers(true)
		table.insert(self:GetCaster().spell_steal_history, self.currentSpell)
		self.currentSpell:SetHidden(true)
		self:GetCaster():SwapAbilities( self.currentSpell:GetAbilityName(), self.slot1, false, true )
		self.currentSpell = nil
	end
end

function rubick_spell_steal_custom:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function rubick_spell_steal_custom:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function rubick_spell_steal_custom:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function rubick_spell_steal_custom:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
	return ret
end

function rubick_spell_steal_custom:DisplayAT()
	local table = self:GetAT()
	for k,v in pairs(table) do
		print(k,v)
	end
end

function rubick_spell_steal_custom:FlagExist(a,b)
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

function rubick_spell_steal_custom:FlagAdd(a,b)
	if FlagExist(a,b) then
		return a
	else
		return a+b
	end
end

function rubick_spell_steal_custom:FlagMin(a,b)
	if FlagExist(a,b) then
		return a-b
	else
		return a
	end
end

function rubick_spell_steal_custom:BitXOR(a,b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra~=rb then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
        local ra=a%2
        if ra>0 then c=c+p end
        a,p=(a-ra)/2,p*2
    end
    return c
end

function rubick_spell_steal_custom:BitOR(a,b)
    local p,c=1,0
    while a+b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>0 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end

function rubick_spell_steal_custom:BitNOT(n)
    local p,c=1,0
    while n>0 do
        local r=n%2
        if r<1 then c=c+p end
        n,p=(n-r)/2,p*2
    end
    return c
end

function rubick_spell_steal_custom:BitAND(a,b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end

modifier_rubick_spell_steal_custom_buff = class({})

function modifier_rubick_spell_steal_custom_buff:IsHidden()
	return self:GetCaster():HasScepter()
end

function modifier_rubick_spell_steal_custom_buff:IsDebuff()
	return false
end

function modifier_rubick_spell_steal_custom_buff:IsPurgable()
	return false
end

function modifier_rubick_spell_steal_custom_buff:RemoveOnDeath()
	return false
end

function modifier_rubick_spell_steal_custom_buff:OnDestroy( kv )
	if not IsServer() then return end
	if self:GetCaster():HasScepter() then return end
	self:GetAbility():ForgetSpell()
end

modifier_rubick_spell_steal_custom = class({})

function modifier_rubick_spell_steal_custom:IsHidden()
	return true
end

function modifier_rubick_spell_steal_custom:IsDebuff()
	return false
end

function modifier_rubick_spell_steal_custom:IsPurgable()
	return false
end

function modifier_rubick_spell_steal_custom:RemoveOnDeath()
	return false
end

function modifier_rubick_spell_steal_custom:OnCreated()
    if IsServer() then
        self:GetParent().spell_steal_history = {}
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_rubick_spell_steal_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_rubick_spell_steal_custom:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        for i=#caster.spell_steal_history,1,-1 do
            local hSpell = caster.spell_steal_history[i]
            if hSpell and not hSpell:IsNull() then
	            if hSpell:NumModifiersUsingAbility() <= 0 and not hSpell:IsChanneling() then
	            	hSpell:SetHidden(true)
	            	hSpell.rubick_spell = nil
	                self:GetCaster():RemoveAbility(hSpell:GetAbilityName())
	                table.remove(caster.spell_steal_history,i)
	            end
	        end
        end
    end
end

function modifier_rubick_spell_steal_custom:OnAbilityFullyCast( params )
	if IsServer() then

		if params.unit == self:GetParent() then
			if self:GetParent():HasTalent("special_bonus_unique_rubick_6") then
				if params.ability then
					if params.ability == self:GetAbility().currentSpell then
						if params.ability:GetCooldownTimeRemaining() > 0 and params.ability:GetAbilityName() ~= "puck_phase_shift_custom" then
							if params.ability:GetCooldownTimeRemaining() - (params.ability:GetCooldown(params.ability:GetLevel() - 1) / 100 * 25) > 0 then
								local new_cooldown = params.ability:GetCooldownTimeRemaining() - (params.ability:GetCooldown(params.ability:GetLevel() - 1) / 100 * 25)
								params.ability:EndCooldown()
								params.ability:StartCooldown(new_cooldown)
							else
								params.ability:EndCooldown()
							end
						end
					end
				end
			end
		end

		if params.unit==self:GetParent() and (not params.ability:IsItem()) then
			return
		end
		if params.ability:IsItem() then
			return
		end
		if params.unit:IsIllusion() then
			return
		end

		if params.ability:IsStolen() then
			return
		end

		local useless_abilities = 
		{
			"tiny_tree_grab",
			"tiny_tree_grab_lua",
			"kunkka_x_marks_the_spot",
			"morphling_morph_agi",
			"morphling_morph_str",
			"alchemist_unstable_concoction",
			"alchemist_unstable_concoction_throw",
			"wisp_tether_break",
			"wisp_spirits_in_lua",
			"shredder_chakram_lua_return",
			"shredder_chakram_lua",
			"tusk_snowball",
			"tusk_launch_snowball",
			"elder_titan_return_spirit",
			"phoenix_icarus_dive_stop",
			"phoenix_sun_ray_toggle_move",
			"phoenix_sun_ray_stop",
			"phoenix_fire_spirits",
			"phoenix_launch_fire_spirit",
			"naga_siren_song_of_the_siren_cancel",
			"naga_siren_song_of_the_siren_cancel_custom",
			"ember_spirit_activate_fire_remnant",
			"keeper_of_the_light_illuminate_end",
			"life_stealer_consume",
			"faceless_void_time_walk_reverse",
			"bane_nightmare_end",
			"ancient_apparition_ice_blast_release",
			"ancient_apparition_ice_blast",
			"shadow_demon_shadow_poison",
			"shadow_demon_shadow_poison_release",
			"snapfire_spit_creep",
			"hoodwink_sharpshooter_release",
			"dawnbreaker_converge",
			"primal_beast_onslaught_release",
			"antimage_mana_overload",
			"kunkka_torrent_storm_custom",
			"rattletrap_overclocking",
			"enchantress_bunny_hop",
			"treant_eyes_in_the_forest",
			"ogre_magi_unrefined_fireblast",
			"earth_spirit_petrify",
			"juggernaut_swift_slash_custom",
			"snapfire_gobble_up",
			"snapfire_spit_creep",
			"nyx_assassin_burrow",
			"nyx_assassin_unburrow",
			"shredder_chakram_2_lua",
			"shredder_chakram_lua_2_return",
			"tusk_walrus_kick",
			"grimstroke_dark_portrait",
			"zuus_cloud",
			"spectre_haunt_single",
			"spectre_reality",
			"tiny_tree_channel_custom",
			"clinkz_burning_army",
			"keeper_of_the_light_will_o_wisp",
			"leshrac_greater_lightning_storm",
			"terrorblade_terror_wave",
			"templar_assassin_trap_teleport",
			"visage_silent_as_the_grave",
			"lycan_wolf_bite",
			"hoodwink_decoy",
			"broodmother_sticky_snare",
			"dark_seer_normal_punch",
			"beastmaster_drums_of_slom",
			"viper_nose_dive",
			"bloodseeker_blood_mist_custom",
			"oracle_rain_of_destiny",
			"centaur_mount",
			"lina_flame_cloak_custom",
			"brewmaster_primal_companion",
			"alchemist_berserk_potion",
			"furion_curse_of_the_forest",
			"bristleback_hairball",
			"venomancer_latent_poison",
			"enchantress_little_friends",
			"rattletrap_jetpack",
			"tidehunter_arm_of_the_deep_custom",
			"jakiro_liquid_ice_lua",
			"kunkka_tidal_wave",
			"lich_ice_spire",
			"life_stealer_open_wounds",
			"magnataur_horn_toss",
			"meepo_petrify",
			"necrolyte_death_seeker",
			"ogre_magi_smash",
			"omniknight_degen_aura_custom",
			"pangolier_rollup",
			"custom_phantom_assassin_fan_of_knives",
			"riki_poison_dart",
			"slark_depth_shroud_custom",
			"sniper_concussive_grenade",
			"storm_spirit_electric_rave",
			"shredder_flamethrower",
			"tinker_warp_grenade",
			"terrorblade_demon_zeal",
			"tiny_craggy_exterior",
			"witch_doctor_voodoo_switcheroo",
			"troll_warlord_rampage",
			"hoodwink_decoy",
			"windrunner_gale_force",
			"primal_beast_rock_throw",
			"hoodwink_hunters_boomerang",
			"skywrath_mage_shield_of_the_scion",
			"zuus_static_field",
			"spirit_breaker_planar_pocket",
		}

		local stop_please = false
		for _, useless in pairs(useless_abilities) do
			if params.ability:GetAbilityName() == useless then
				stop_please = true
				break
			end
		end
		if stop_please then
			return
		end

		self:GetAbility():SetLastSpell( params.unit, params.ability )
	end
end

function modifier_rubick_spell_steal_custom:GetModifierTotalDamageOutgoing_Percentage(params)
	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
		if params.inflictor ~= nil then
			if params.inflictor == self:GetAbility().currentSpell then
				if self:GetParent():HasTalent("special_bonus_unique_rubick_5") then
					print(params.inflictor:GetAbilityName())
					return 40
				end
			end
		end
	end
end

function modifier_rubick_spell_steal_custom:OnModifierAdded(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.added_buff:GetCaster() ~= self:GetParent() then return end
	if not params.added_buff:IsDebuff() then return end
	if params.added_buff:GetDuration() <= 0 then return end
	if params.added_buff:GetName() == "modifier_cyclone" then return end
	if params.added_buff:GetName() == "modifier_eul_cyclone" then return end
	if params.added_buff:GetName() == "modifier_eul_cyclone_thinker" then return end
	if params.added_buff:GetName() == "modifier_eul_wind_waker_thinker" then return end
	if params.added_buff:GetName() == "modifier_wind_waker" then return end
	if params.added_buff:GetAbility() ~= self:GetAbility().currentSpell then return end
	local new_duration = params.added_buff:GetDuration() + (params.added_buff:GetDuration() / 100 * self:GetAbility():GetSpecialValueFor("stolen_debuff_amp"))
	params.added_buff:SetDuration(new_duration, true)
end