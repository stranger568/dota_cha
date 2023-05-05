LinkLuaModifier( "modifier_item_desolator_2_custom", "items/item_desolator_2_custom", LUA_MODIFIER_MOTION_NONE )

item_desolator_2_custom = class({})

function item_desolator_2_custom:GetIntrinsicModifierName()
	return "modifier_item_desolator_2_custom"
end

modifier_item_desolator_2_custom = class({})

function modifier_item_desolator_2_custom:IsHidden() return true end
function modifier_item_desolator_2_custom:IsPurgable() return false end
function modifier_item_desolator_2_custom:IsPurgeException() return false end
function modifier_item_desolator_2_custom:RemoveOnDeath() return false end
function modifier_item_desolator_2_custom:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_2_custom:DeclareFunctions()
	return 
    {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_item_desolator_2_custom:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
end

function modifier_item_desolator_2_custom:GetModifierProjectileName()
    return "particles/items_fx/desolator_projectile.vpcf"
end

function modifier_item_desolator_2_custom:AttackModifier(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.target:IsWard() then return end
    if self:GetParent():FindAllModifiersByName("modifier_item_desolator_2_custom")[1] ~= self then return end
    if self:GetParent():IsIllusion() then return end
    params.target:EmitSound("Item_Desolator.Target")
end

function modifier_item_desolator_2_custom:AttackLandedModifier(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.target:IsWard() then return end
    if self:GetParent():FindAllModifiersByName("modifier_item_desolator_2_custom")[1] ~= self then return end
    if self:GetParent():IsIllusion() then return end
    params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_desolator_2_buff", {duration = self:GetAbility():GetSpecialValueFor("corruption_duration")})
    params.target:EmitSound("Item_Desolator.Target")
end

function modifier_item_desolator_2_custom:AttackModifier(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.attacker:IsIllusion() then return end
	if params.target == self:GetParent() then return end
	if not self:GetAbility():IsFullyCastable() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.no_attack_cooldown then return end

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	local attacks = 0

	for i, enemy in pairs(enemies) do
		if attacks >= self:GetAbility():GetSpecialValueFor("arrow_count") then break end
		attacks = attacks + 1
		Timers:CreateTimer(0.07 * i, function()
			if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsAttackImmune() and not enemy:IsInvulnerable() then
				self:GetParent():PerformAttack(enemy, true, true, true, false, true, false, false) 
			end
		end)
	end

	self:GetAbility():UseResources(false, false, false, true)
end

