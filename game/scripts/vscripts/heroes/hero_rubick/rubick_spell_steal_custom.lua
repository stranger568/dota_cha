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
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function rubick_spell_steal_custom:CastFilterResultTarget( hTarget )
	if IsServer() then
		if self:GetLastSpell( hTarget )==nil then
			return UF_FAIL_OTHER
		end
		if self:GetCaster():HasAbility(self:GetLastSpell( hTarget ):GetAbilityName()) then
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

function rubick_spell_steal_custom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	--if target:TriggerSpellAbsorb( self ) then
	--	return
	--end

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

	if self:GetCaster():HasScepter() then
		if self:GetAutoCastState() then
			self:SetStolenSpellScepter( self.stolenSpell )
			self.stolenSpell = nil
		else
			self:SetStolenSpell( self.stolenSpell )
			self.stolenSpell = nil
			local steal_duration = self:GetSpecialValueFor("duration")
			target:AddNewModifier( self:GetCaster(), self, "modifier_rubick_spell_steal_custom_buff", { duration = steal_duration } )
		end
	else
		self:SetStolenSpell( self.stolenSpell )
		self.stolenSpell = nil
		local steal_duration = self:GetSpecialValueFor("duration")
		target:AddNewModifier( self:GetCaster(), self, "modifier_rubick_spell_steal_custom_buff", { duration = steal_duration } )
	end

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

	if self.currentSpell~=nil then 
		if self.currentSpell_2 ~= nil and self.currentSpell_2:GetAbilityName() == self.currentSpell:GetAbilityName() then
			self:ForgetSpellScepter()
		end
		if self.currentSpell:GetAbilityName() ~= spell:GetAbilityName() then
			self:ForgetSpell()
		else
			return
		end
	end

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

-- Функция кражи способности AGHANIM
function rubick_spell_steal_custom:SetStolenSpellScepter( spellData )
	local spell = spellData.lastSpell

	if self.currentSpell_2~=nil then 
		if self.currentSpell ~= nil and self.currentSpell_2:GetAbilityName() == self.currentSpell:GetAbilityName() then
			self:ForgetSpell()
		end
		if self.currentSpell_2:GetAbilityName() ~= spell:GetAbilityName() then
			self:ForgetSpellScepter()
		else
			return
		end
	end

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
        self.currentSpell_2 = self:GetCaster():FindAbilityByName(spell:GetAbilityName())
    else
        self.currentSpell_2 = self:GetCaster():AddAbility( spell:GetAbilityName() )
        self.currentSpell_2.rubick_spell = true
        self.currentSpell_2:SetStolen(true)
        self.currentSpell_2:SetRefCountsModifiers(true)
    end

    self.currentSpell_2:SetHidden(false)
	self.currentSpell_2:SetLevel( spell:GetLevel() )
	self:GetCaster():SwapAbilities( self.slot2, self.currentSpell_2:GetAbilityName(), false, true )
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

-- Функция удаления способности Scepter
function rubick_spell_steal_custom:ForgetSpellScepter()
	if self.currentSpell_2~=nil then
		self.currentSpell_2:SetRefCountsModifiers(true)
		table.insert(self:GetCaster().spell_steal_history, self.currentSpell_2)
		self.currentSpell_2:SetHidden(true)
		self:GetCaster():SwapAbilities( self.currentSpell_2:GetAbilityName(), self.slot2, false, true )
		self.currentSpell_2 = nil
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
	return false
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
					if params.ability == self:GetAbility().currentSpell or params.ability == self:GetAbility().currentSpell_2 then
						if params.ability:GetCooldownTimeRemaining() > 0 then
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

		self:GetAbility():SetLastSpell( params.unit, params.ability )
	end
end

function modifier_rubick_spell_steal_custom:GetModifierTotalDamageOutgoing_Percentage(params)
	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
		if params.inflictor ~= nil then
			if params.inflictor == self:GetAbility().currentSpell or params.inflictor == self:GetAbility().currentSpell_2 then
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
	if params.added_buff:GetAbility() ~= self:GetAbility().currentSpell and params.added_buff:GetAbility() ~= self:GetAbility().currentSpell_2 then return end
	local new_duration = params.added_buff:GetDuration() + (params.added_buff:GetDuration() / 100 * self:GetAbility():GetSpecialValueFor("stolen_debuff_amp"))
	params.added_buff:SetDuration(new_duration, true)
end