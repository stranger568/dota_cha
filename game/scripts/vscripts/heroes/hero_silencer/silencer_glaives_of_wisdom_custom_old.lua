LinkLuaModifier("modifier_silencer_glaives_of_wisdom_custom_buff",  "heroes/hero_silencer/silencer_glaives_of_wisdom_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_glaives_of_wisdom_custom_debuff", "heroes/hero_silencer/silencer_glaives_of_wisdom_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_glaives_of_wisdom_custom", "heroes/hero_silencer/silencer_glaives_of_wisdom_custom", LUA_MODIFIER_MOTION_NONE)

silencer_glaives_of_wisdom_custom = class({})

silencer_glaives_of_wisdom_custom.force_glaive = false

function silencer_glaives_of_wisdom_custom:GetIntrinsicModifierName()
	return "modifier_silencer_glaives_of_wisdom_custom"
end

function silencer_glaives_of_wisdom_custom:GetCastRange(vLocation, hTarget)
	return self:GetCaster():Script_GetAttackRange()
end

function silencer_glaives_of_wisdom_custom:OnSpellStart()
	if not IsServer() then return end
	self.force_glaive = true
	self:GetCaster():MoveToTargetToAttack(self:GetCursorTarget())
	self:RefundManaCost()
	print(self.force_glaive, "cast ability")
end

modifier_silencer_glaives_of_wisdom_custom = class({})

function modifier_silencer_glaives_of_wisdom_custom:IsHidden() return self:GetStackCount() == 0 end
function modifier_silencer_glaives_of_wisdom_custom:IsPurgable() return false end
function modifier_silencer_glaives_of_wisdom_custom:IsDebuff() return false end

function modifier_silencer_glaives_of_wisdom_custom:DeclareFunctions()
	return
	{
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_silencer_glaives_of_wisdom_custom:OnCreated()
	if not IsServer() then return end
	self.attack_with_glaive = {}
	self.shard_attack_count = 0
end

function modifier_silencer_glaives_of_wisdom_custom:OnAttackStart(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker:IsIllusion() then return end
	if attacker ~= self:GetParent() then return end

	self.auto_cast = self:GetAbility():GetAutoCastState()
	self.current_mana = self:GetParent():GetMana()
	self.mana_cost = self:GetAbility():GetManaCost(-1)

	if self.auto_cast then
		self:GetAbility().force_glaive = true
	end

	print(self:GetAbility().force_glaive)

	if self:GetParent():IsSilenced() then self:GetAbility().force_glaive = false end
	if target:IsMagicImmune() then self:GetAbility().force_glaive = false end
	if self.current_mana < self.mana_cost then self:GetAbility().force_glaive = false end

	print(self:GetAbility().force_glaive)

	if self:GetAbility().force_glaive then
		SetGlaiveAttackProjectile(self:GetParent(), true)
	else
		SetGlaiveAttackProjectile(self:GetParent(), false)
	end
end

function modifier_silencer_glaives_of_wisdom_custom:AttackModifier(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker ~= self:GetParent() then return end
	if target:IsMagicImmune() then return end
	if not self:GetAbility().force_glaive then return end
	attacker:SpendMana(self.mana_cost, self:GetAbility())
end

function modifier_silencer_glaives_of_wisdom_custom:AttackLandedModifier(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker ~= self:GetParent() then return end
	if target:IsMagicImmune() then return end
	if not self:GetAbility().force_glaive then return end
	self:GetAbility().force_glaive = false

	local glaive_pure_damage = attacker:GetIntellect() * self:GetAbility():GetSpecialValueFor("intellect_damage_pct") / 100
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, glaive_pure_damage, nil)
	ApplyDamage( { victim = target, attacker = attacker, damage = glaive_pure_damage, damage_type = self:GetAbility():GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self:GetAbility() } )

	if self:GetParent().anchor_attack_talent then print("СОРРИ ПАССИВКА ТАЙДА") return end

	local frostivus2018_clinkz_searing_arrows = self:GetParent():FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		print("чекаем абилку", frostivus2018_clinkz_searing_arrows:GetAutoCastState())
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if keys.no_attack_cooldown then
				print("СТОЯТЬ ДРУЖИЩЕ")
				return
			end
		end
	end

	local modifier_buff = self:GetParent():FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_buff")
	if not modifier_buff then
		modifier_buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_silencer_glaives_of_wisdom_custom_buff", {duration = self:GetAbility():GetSpecialValueFor("int_steal_duration") }):SetStackCount(self:GetAbility():GetSpecialValueFor("int_steal"))
	else
		if modifier_buff and not modifier_buff:IsNull() then
			modifier_buff:AddIndependentStack(self:GetAbility():GetSpecialValueFor("int_steal_duration"), nil, true, {stacks=self:GetAbility():GetSpecialValueFor("int_steal")})
		end
	end
				
	if target:IsAlive() then
		local modifier_debuff = target:FindModifierByName("modifier_silencer_glaives_of_wisdom_custom_debuff")
		if not modifier_debuff then
			modifier_debuff = target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_silencer_glaives_of_wisdom_custom_debuff", {duration = self:GetAbility():GetSpecialValueFor("int_steal_duration") }):SetStackCount(self:GetAbility():GetSpecialValueFor("int_steal"))
		else
			modifier_debuff:SetStackCount(modifier_debuff:GetStackCount() + self:GetAbility():GetSpecialValueFor("int_steal"))
		end
	else
		if target:IsRealHero() and not target:HasModifier("modifier_silencer_glaives_of_wisdom_custom_debuff") then
			target:SetBaseIntellect( math.max(1, target:GetBaseIntellect() - self:GetAbility():GetSpecialValueFor("permanent_int_steal_amount") ) )
			self:SetStackCount(self:GetStackCount() + self:GetAbility():GetSpecialValueFor("permanent_int_steal_amount"))
		end
	end

	if self:GetParent():HasShard() then
		self.shard_attack_count = self.shard_attack_count + 1
		if self.shard_attack_count >= self:GetAbility():GetSpecialValueFor("stacks_for_silence") then
			self.shard_attack_count = 0
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_silence", {duration = self:GetAbility():GetSpecialValueFor("silence_duration")})
		end
	end

	if keys.no_attack_cooldown then return end

	if self:GetParent():HasTalent("special_bonus_unique_silencer_glaives_bounces") then
		local number_of_bounces = self:GetAbility():GetSpecialValueFor("bounce_count")
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("bounce_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
		if #enemies > 0 and number_of_bounces > 0 then
			for _, enemy in ipairs(enemies) do
				if enemy and enemy ~= target and not enemy:IsAttackImmune() then
  					local projectile_info = {
   						Target = enemy,
   						Source = target,
   						Ability = self:GetAbility(),
   						EffectName = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf",
   						bDodgable = true,
   						bProvidesVision = false,
   						bVisibleToEnemies = true,
   						bReplaceExisting = false,
   						iMoveSpeed = self:GetParent():GetProjectileSpeed(),
   						bIsAttack = false,
   						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
   						ExtraData = {
      					bounces_left = number_of_bounces - 1,
      					physical_damage = keys.damage,
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

function modifier_silencer_glaives_of_wisdom_custom:OnOrder(keys)
	if keys.unit == self:GetParent() then
		local order_type = keys.order_type
		if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and self.ability then
			self.ability.force_glaive = nil
		end
	end
end

function SetGlaiveAttackProjectile(caster, is_glaive_attack)
	local base_attack = "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf"
	local glaive_attack = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"

	if is_glaive_attack then
		caster:SetRangedProjectileName(glaive_attack)
		return
	else
		caster:SetRangedProjectileName(base_attack)
		return
	end
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

function modifier_silencer_glaives_of_wisdom_custom_debuff:OnDestroy()
	if not IsServer() then return end
	if self:GetParent():IsRealHero() and not self:GetParent():IsAlive() then
		self:GetParent():SetBaseIntellect( math.max(1, self:GetParent():GetBaseIntellect() - self:GetAbility():GetSpecialValueFor("permanent_int_steal_amount") ) )
		local modifier_silencer_glaives_of_wisdom_custom = self:GetCaster():FindModifierByName("modifier_silencer_glaives_of_wisdom_custom")
		if modifier_silencer_glaives_of_wisdom_custom then
			modifier_silencer_glaives_of_wisdom_custom:SetStackCount(modifier_silencer_glaives_of_wisdom_custom:GetStackCount() + self:GetAbility():GetSpecialValueFor("permanent_int_steal_amount"))
		end
	end
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_silencer_glaives_of_wisdom_custom_debuff:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * (-1)
end