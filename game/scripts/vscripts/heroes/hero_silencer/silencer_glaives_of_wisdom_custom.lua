LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_custom_orb", "heroes/hero_silencer/silencer_glaives_of_wisdom_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_custom_buff",  "heroes/hero_silencer/silencer_glaives_of_wisdom_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_custom_debuff", "heroes/hero_silencer/silencer_glaives_of_wisdom_custom", LUA_MODIFIER_MOTION_NONE)

silencer_glaives_of_wisdom_custom = class({})
silencer_glaives_of_wisdom_custom.shard_attack_count = 0

function silencer_glaives_of_wisdom_custom:GetIntrinsicModifierName()
	return "modifier_silencer_glaives_of_wisdom_custom_orb"
end

function silencer_glaives_of_wisdom_custom:OnOrbFire( params )
	
end

function silencer_glaives_of_wisdom_custom:GetCastRange(vLocation, hTarget)
	return self:GetCaster():Script_GetAttackRange() + 50
end

function silencer_glaives_of_wisdom_custom:OnOrbImpact( params )
	local target = params.target
	if target:IsMagicImmune() then return end
	if target:GetUnitName() == "npc_dota_stranger" then return end
	if target:GetUnitName() == "npc_dota_teleport_base_custom_red" then return end
	if target:GetUnitName() == "npc_dota_teleport_base_custom_blue" then return end

	local glaive_pure_damage = self:GetCaster():GetIntellect() * self:GetSpecialValueFor("intellect_damage_pct") / 100
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, glaive_pure_damage, nil)
	ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = glaive_pure_damage, damage_type = self:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self } )

	if self:GetCaster().anchor_attack_talent then print("СОРРИ ПАССИВКА ТАЙДА") return end

	local frostivus2018_clinkz_searing_arrows = self:GetCaster():FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		print("чекаем абилку", frostivus2018_clinkz_searing_arrows:GetAutoCastState())
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if params.no_attack_cooldown then
				print("СТОЯТЬ ДРУЖИЩЕ")
				return
			end
		end
	end

	local modifier_buff = self:GetCaster():FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_buff")
	if not modifier_buff then
		modifier_buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_silencer_glaives_of_wisdom_custom_buff", {duration = self:GetSpecialValueFor("int_steal_duration") }):SetStackCount(self:GetSpecialValueFor("int_steal"))
	else
		if modifier_buff and not modifier_buff:IsNull() then
			modifier_buff:AddIndependentStack(self:GetSpecialValueFor("int_steal_duration"), nil, true, {stacks=self:GetSpecialValueFor("int_steal")})
			if modifier_buff:GetStackCount() >= 500 then
				Quests_arena:QuestProgress(self:GetCaster():GetPlayerOwnerID(), 92, 3)
			end
		end
	end
				
	if target:IsAlive() then
		local modifier_debuff = target:FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_debuff")
		if not modifier_debuff then
			modifier_debuff = target:AddNewModifier(self:GetCaster(), self, "modifier_silencer_glaives_of_wisdom_custom_debuff", {duration = self:GetSpecialValueFor("int_steal_duration") }):SetStackCount(self:GetSpecialValueFor("int_steal"))
		else
			modifier_debuff:SetStackCount(modifier_debuff:GetStackCount() + self:GetSpecialValueFor("int_steal"))
		end
	end

	if self:GetCaster():HasShard() then
		self.shard_attack_count = self.shard_attack_count + 1
		if self.shard_attack_count >= self:GetSpecialValueFor("stacks_for_silence") then
			self.shard_attack_count = 0
			target:AddNewModifier(self:GetCaster(), self, "modifier_silence", {duration = self:GetSpecialValueFor("silence_duration")})
		end
	end

	if params.no_attack_cooldown then return end

	if self:GetCaster():HasTalent("special_bonus_unique_silencer_glaives_bounces") then
		local number_of_bounces = self:GetSpecialValueFor("bounce_count")
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("bounce_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
		if #enemies > 0 and number_of_bounces > 0 then
			for _, enemy in ipairs(enemies) do
				if enemy and enemy ~= target and not enemy:IsAttackImmune() then
  					local projectile_info = {
   						Target = enemy,
   						Source = target,
   						Ability = self,
   						EffectName = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf",
   						bDodgable = true,
   						bProvidesVision = false,
   						bVisibleToEnemies = true,
   						bReplaceExisting = false,
   						iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
   						bIsAttack = false,
   						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
   						ExtraData = {
      					bounces_left = number_of_bounces - 1,
      					physical_damage = params.damage,
      					spell_damage = glaive_pure_damage
    					}
 					 }
  					ProjectileManager:CreateTrackingProjectile(projectile_info)
  					break
				end
			end
		end
	end
end

function silencer_glaives_of_wisdom_custom:OnProjectileHit_ExtraData(target, location, data)
  	local caster = self:GetCaster()

  	if not self:GetCaster():HasTalent("special_bonus_unique_silencer_glaives_bounces") then return end
  	if not target or not data then
    	return
  	end

  	local bounces_left = data.bounces_left
  	local bounce_radius = self:GetSpecialValueFor("bounce_range")

	if IsServer() then
		
		self:GetCaster():PerformAttack(target, true, true, true, false, false, false, false)

		if self:GetCaster():HasTalent("special_bonus_unique_silencer_glaives_bounces") then
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("bounce_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
			if #enemies > 0 and bounces_left > 0 then
  				for _, enemy in ipairs(enemies) do
    				if enemy and enemy ~= target and not enemy:IsAttackImmune() then
      					local projectile_info = {
       						Target = enemy,
       						Source = target,
       						Ability = self,
       						EffectName = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf",
       						bDodgable = true,
       						bProvidesVision = false,
       						bVisibleToEnemies = true,
       						bReplaceExisting = false,
       						iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
       						bIsAttack = false,
       						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
       						ExtraData = {
          					bounces_left = bounces_left - 1,
          					physical_damage = data.damage,
          					spell_damage = glaive_pure_damage
        					}
     					 }
      					ProjectileManager:CreateTrackingProjectile(projectile_info)
      					break
    				end
  				end
			end
		end
		EmitSoundOn("Hero_Silencer.GlaivesOfWisdom.Damage", target)
	end
end

modifier_silencer_glaives_of_wisdom_custom_orb = class({})

function modifier_silencer_glaives_of_wisdom_custom_orb:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_silencer_glaives_of_wisdom_custom_orb:IsDebuff()
	return false
end

function modifier_silencer_glaives_of_wisdom_custom_orb:IsPurgable()
	return false
end

function modifier_silencer_glaives_of_wisdom_custom_orb:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_silencer_glaives_of_wisdom_custom_orb:OnCreated( kv )
	self.ability = self:GetAbility()
	self.cast = false
	self.records = {}
end

function modifier_silencer_glaives_of_wisdom_custom_orb:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_silencer_glaives_of_wisdom_custom_orb:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

function modifier_silencer_glaives_of_wisdom_custom_orb:AttackModifier( params )
	if params.attacker~=self:GetParent() then return end
	if self:ShouldLaunch( params.target ) then
		self.ability:UseResources( true, false, false, true )
		self.records[params.record] = true
		if self.ability.OnOrbFire then self.ability:OnOrbFire( params ) end
	end

	self.cast = false
end

function modifier_silencer_glaives_of_wisdom_custom_orb:GetModifierProcAttack_Feedback( params )
	if self.records[params.record] then
		if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
	end
end
function modifier_silencer_glaives_of_wisdom_custom_orb:OnAttackFail( params )
	if self.records[params.record] then
		if self.ability.OnOrbFail then self.ability:OnOrbFail( params ) end
	end
end
function modifier_silencer_glaives_of_wisdom_custom_orb:OnAttackRecordDestroy( params )
	self.records[params.record] = nil
end

function modifier_silencer_glaives_of_wisdom_custom_orb:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.ability then
		if params.ability==self:GetAbility() then
			self.cast = true
			return
		end
		local pass = false
		local behavior = params.ability:GetBehaviorInt()
		if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true -- do nothing
		end

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

function modifier_silencer_glaives_of_wisdom_custom_orb:GetModifierProjectileName()
	if self:ShouldLaunch( self:GetCaster():GetAggroTarget() ) then
		return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
	end

	return "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf"
end

function modifier_silencer_glaives_of_wisdom_custom_orb:ShouldLaunch( target )
	if self.ability:GetAutoCastState() then
		if self.ability.CastFilterResultTarget~=CDOTA_Ability_Lua.CastFilterResultTarget then
			if self.ability:CastFilterResultTarget( target )==UF_SUCCESS then
				self.cast = true
			end
		else
			local nResult = UnitFilter(
				target,
				self.ability:GetAbilityTargetTeam(),
				self.ability:GetAbilityTargetType(),
				self.ability:GetAbilityTargetFlags(),
				self:GetCaster():GetTeamNumber()
			)
			if nResult == UF_SUCCESS then
				self.cast = true
			end
		end
	end

	if self.cast and self.ability:IsFullyCastable() and (not self:GetParent():IsSilenced()) then
		return true
	end

	return false
end

function modifier_silencer_glaives_of_wisdom_custom_orb:FlagExist(a,b)
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

modifier_silencer_glaives_of_wisdom_custom_buff = class({})

function modifier_silencer_glaives_of_wisdom_custom_buff:IsPurgable()	return false end
function modifier_silencer_glaives_of_wisdom_custom_buff:IsHidden() return false end
function modifier_silencer_glaives_of_wisdom_custom_buff:IsDebuff() return false end

function modifier_silencer_glaives_of_wisdom_custom_buff:OnCreated(params)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() end
	self.duration = self:GetAbility():GetSpecialValueFor("int_steal_duration")
	self.stack_table = {}
	self:StartIntervalThink(1)
end

function modifier_silencer_glaives_of_wisdom_custom_buff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		self:ForceRefresh()
		if not self:GetParent():IsRealHero() then return end
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_silencer_glaives_of_wisdom_custom_buff:OnIntervalThink()	
	local repeat_needed = true
	while repeat_needed do
		local item_time = self.stack_table[1]
		if GameRules:GetGameTime() - item_time >= self.duration then
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				table.remove(self.stack_table, 1)
				self:DecrementStackCount()
			end
		else
			repeat_needed = false
		end
	end
end

function modifier_silencer_glaives_of_wisdom_custom_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_silencer_glaives_of_wisdom_custom_buff:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

modifier_silencer_glaives_of_wisdom_custom_debuff = class({})

function modifier_silencer_glaives_of_wisdom_custom_debuff:IsPurgable() return false end
function modifier_silencer_glaives_of_wisdom_custom_debuff:IsHidden() return false end
function modifier_silencer_glaives_of_wisdom_custom_debuff:IsDebuff() return true end

function modifier_silencer_glaives_of_wisdom_custom_debuff:OnCreated(params)
	if not IsServer() then return end	
	if not self:GetAbility() then self:Destroy() end
	self.duration = self:GetAbility():GetSpecialValueFor("int_steal_duration")
	self.stack_table = {}
	self:StartIntervalThink(1)
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		self:ForceRefresh()
		if not self:GetParent():IsRealHero() then return end
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:OnIntervalThink()	
	local repeat_needed = true
	while repeat_needed do
		local item_time = self.stack_table[1]
		if GameRules:GetGameTime() - item_time >= self.duration then
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				table.remove(self.stack_table, 1)
				self:DecrementStackCount()
			end
		else
			repeat_needed = false
		end
	end
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:OnDeathEvent(params)
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	if not params.unit:IsRealHero() then return end
	self:GetParent():SetBaseIntellect( math.max(1, self:GetParent():GetBaseIntellect() - self:GetAbility():GetSpecialValueFor("permanent_int_steal_amount") ) )
	local modifier_silencer_glaives_of_wisdom_custom = self:GetCaster():FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_orb")
	if modifier_silencer_glaives_of_wisdom_custom then
		modifier_silencer_glaives_of_wisdom_custom:SetStackCount(modifier_silencer_glaives_of_wisdom_custom:GetStackCount() + self:GetAbility():GetSpecialValueFor("permanent_int_steal_amount"))
	end
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * (-1)
end