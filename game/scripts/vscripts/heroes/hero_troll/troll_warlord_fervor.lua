LinkLuaModifier("modifier_troll_warlord_fervor_custom", "heroes/hero_troll/troll_warlord_fervor", LUA_MODIFIER_MOTION_NONE)

troll_warlord_fervor_custom = class({})

function troll_warlord_fervor_custom:GetIntrinsicModifierName()
	return "modifier_troll_warlord_fervor_custom"
end

modifier_troll_warlord_fervor_custom = class({})

function modifier_troll_warlord_fervor_custom:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom:RemoveOnDeath() return false end
function modifier_troll_warlord_fervor_custom:IsHidden() return false end

function modifier_troll_warlord_fervor_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_troll_warlord_fervor_custom:OnCreated()
	if not IsServer() then return end
	self.current_target = nil
end

function modifier_troll_warlord_fervor_custom:AttackLandedModifier( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if params.no_attack_cooldown then return end
	if self:GetParent():PassivesDisabled() then return end

    if self.current_target ~= nil and self.current_target ~= params.target then
        self:SetStackCount(self:GetStackCount() / 2)
    end

    local max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")

    if self.current_target == params.target then
    	if self:GetStackCount() < max_stacks then
        	self:SetStackCount(self:GetStackCount() + 1)
        end
    end

    self.current_target = params.target
end

function modifier_troll_warlord_fervor_custom:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then return end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attack_speed")
end
