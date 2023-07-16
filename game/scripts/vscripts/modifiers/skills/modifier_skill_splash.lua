modifier_skill_splash = class({})

function modifier_skill_splash:IsHidden() return true end
function modifier_skill_splash:IsPurgable() return false end
function modifier_skill_splash:IsPurgeException() return false end
function modifier_skill_splash:RemoveOnDeath() return false end
function modifier_skill_splash:AllowIllusionDuplicate() return true end

function modifier_skill_splash:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_skill_splash:OnCreated()
    self.parent = self:GetParent()
end

function modifier_skill_splash:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end
	if not keys.attacker:IsRealHero() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	if keys.target:IsBuilding() then return end
	if self.parent.anchor_attack_talent then return end
	if self.parent.bCanTriggerLock then return end
	if keys.no_attack_cooldown then return end

	local frostivus2018_clinkz_searing_arrows = self.parent:FindAbilityByName("frostivus2018_clinkz_searing_arrows")
	if frostivus2018_clinkz_searing_arrows then
		if frostivus2018_clinkz_searing_arrows:GetAutoCastState() then
			if keys.no_attack_cooldown then
				return
			end
		end
	end

	if self.parent:HasModifier("modifier_item_bfury_2") then return end
	if self.parent:HasModifier("modifier_item_bfury_3") then return end
	if self.parent:HasModifier("modifier_item_ranged_cleave") then return end
	if self.parent:HasModifier("modifier_item_ranged_cleave_2") then return end
	if self.parent:HasModifier("modifier_item_ranged_cleave_3") then return end
	
	local target_loc = keys.target:GetAbsOrigin()
	local fury_swipes_damage = 0
	
	if keys.attacker:HasAbility("ursa_fury_swipes") and keys.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
		local ursa_swipes = keys.attacker:FindAbilityByName("ursa_fury_swipes")
		if ursa_swipes and not ursa_swipes:IsNull() then
			local stacks = keys.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", keys.attacker)
			fury_swipes_damage = stacks * ursa_swipes:GetSpecialValueFor("damage_per_stack")
		end
	end

	local cleave_dmg = 30
	local damage = (keys.original_damage + fury_swipes_damage) * cleave_dmg * 0.01

	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), target_loc, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= keys.target then
			ApplyDamage({
				victim 			= enemy,
				attacker 		= keys.attacker,
				damage 			= damage,
				damage_type 	= DAMAGE_TYPE_PHYSICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability 		= nil,
			})
		end
	end
end