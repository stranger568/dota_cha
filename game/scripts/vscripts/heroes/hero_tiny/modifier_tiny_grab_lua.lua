modifier_tiny_grab_lua = class({})

function modifier_tiny_grab_lua:IsPurgable() return false end
function modifier_tiny_grab_lua:RemoveOnDeath() return true end

function modifier_tiny_grab_lua:OnCreated( ... )
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then self:Destroy() return end

	self.attack_range_override = ability:GetSpecialValueFor("attack_range")
	self.speed_reduction = -ability:GetSpecialValueFor("speed_reduction")
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")

	self.splash_pct 	= ability:GetSpecialValueFor("splash_pct") / 100.0
	self.splash_width 	= ability:GetSpecialValueFor("splash_width")
	self.splash_range 	= ability:GetSpecialValueFor("splash_range")

	self.ability = ability
	self.parent = self:GetParent()

end

function modifier_tiny_grab_lua:OnRefresh( ... )
	self:OnCreated()
end



function modifier_tiny_grab_lua:DeclareFunctions( ... )
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, -- GetActivityTranslationModifiers
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND, -- GetAttackSound
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, -- GetModifierProcAttack_Feedback
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- GetModifierMoveSpeedBonus_Constant
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE, -- GetModifierAttackRangeOverride,
	    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, -- GetModifierPreAttack_BonusDamage
	    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, -- Grow tree damage bonus
	}
end

function modifier_tiny_grab_lua:GetActivityTranslationModifiers()
	return "tree"
end

function modifier_tiny_grab_lua:GetAttackSound()
	return "Hero_Tiny_Tree.Attack"
end

function modifier_tiny_grab_lua:GetModifierMoveSpeedBonus_Constant()
	return self.speed_reduction
end

function modifier_tiny_grab_lua:GetModifierAttackRangeOverride()
	return self.attack_range_override
end

function modifier_tiny_grab_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	local parent = self.parent
	if not parent or parent:IsNull() then return end
	if not params.target or params.target:IsNull() then return end
	if parent:GetTeam() == params.target:GetTeam() then return end
	if self:GetParent().anchor_attack_talent then print("СОРРИ ПАССИВКА ТАЙДА") return end
	if self:GetParent().bCanTriggerLock then print("СОРРИ ПАССИВКА ВОЙДА") return end

	local ability = self:GetAbility()

	local damage = params.original_damage
	local fury_swipes_damage = 0

	if params.attacker:HasAbility("ursa_fury_swipes") and params.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
		local ursa_swipes = params.attacker:FindAbilityByName("ursa_fury_swipes")
		if ursa_swipes and not ursa_swipes:IsNull() then
			local stacks = params.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", params.attacker)
			fury_swipes_damage = stacks * ursa_swipes:GetSpecialValueFor("damage_per_stack")
		end
	end

	local splash_damage = (damage + fury_swipes_damage) * self.splash_pct




	local target_origin = params.target:GetAbsOrigin()
	local direction = (target_origin - parent:GetAbsOrigin()):Normalized()

	-- custom cleave implementation since original DoCleaveAttack is somehow bricked
	-- throws AttackRecord warnings and doesn't display particles in a right way

	local enemies = FindUnitsInLine(
		parent:GetTeamNumber(),
		target_origin,
		target_origin + direction * self.splash_range,
		nil,
		self.splash_width,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	)

	damage_table = {
		attacker = parent,
		ability = self.ability,
		victim = nil,
		damage = splash_damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
	}

	for i, unit in pairs(enemies) do
		if unit ~= params.target then
			damage_table.victim = unit
			ApplyDamage(damage_table)
		end
	end

	if parent:HasShard() then
    	self:SetStackCount(-1)
    else
    	local nCount=self:GetStackCount()
    	if nCount and nCount>1 then
    		self:SetStackCount(nCount-1)
    	else
    		self:Destroy()
    	end
    end

    self:SendBuffRefreshToClients()

end

function modifier_tiny_grab_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_tiny_grab_lua:GetModifierBaseAttack_BonusDamage()
	local grow = self:GetParent():FindAbilityByName("tiny_grow")
	
	if grow and grow:GetLevel()>=1 then
		return grow:GetSpecialValueFor("tree_bonus_damage_pct") * 0.01 * grow:GetSpecialValueFor("bonus_damage")
	end
end

function modifier_tiny_grab_lua:OnRemoved()
	if not IsServer() then return end
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end
	parent:SwapAbilities("tiny_tree_grab_lua", "tiny_tree_throw_lua", true, false)

	local tree_grab_ability = parent:FindAbilityByName("tiny_tree_grab_lua")
	if tree_grab_ability then
		tree_grab_ability:UseResources(false, false, true)
	end
end
