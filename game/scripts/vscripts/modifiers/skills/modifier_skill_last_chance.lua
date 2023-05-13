LinkLuaModifier("modifier_skill_last_chance_cooldown", "modifiers/skills/modifier_skill_last_chance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_last_chance_buff", "modifiers/skills/modifier_skill_last_chance", LUA_MODIFIER_MOTION_NONE)

modifier_skill_last_chance = class({})

function modifier_skill_last_chance:IsHidden() return true end
function modifier_skill_last_chance:IsPurgable() return false end
function modifier_skill_last_chance:IsPurgeException() return false end
function modifier_skill_last_chance:RemoveOnDeath() return false end

function modifier_skill_last_chance:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end

function modifier_skill_last_chance:GetMinHealth()
	if self:GetParent():IsIllusion() then return end
	if self:GetParent():HasModifier("modifier_duel_curse_cooldown") then return end
	if self:GetParent():HasModifier("modifier_skill_last_chance_cooldown") then return end
	return 1
end

function modifier_skill_last_chance:TakeDamageScriptModifier(params)
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	if self:GetParent():GetHealth() > 1 then return end
	if self:GetParent():HasModifier("modifier_skill_last_chance_buff") then return end
	if self:GetParent():HasModifier("modifier_skill_last_chance_cooldown") then return end
	if self:GetParent():HasModifier("modifier_abaddon_borrowed_time_custom_buff") then return end
	if self:GetParent():HasModifier("modifier_oracle_false_promise_custom") then return end
	if self:GetParent():IsInvulnerable() then return end
	if self:GetParent():HasModifier("modifier_dazzle_shallow_grave") then return end
	if self:GetParent():HasModifier("modifier_duel_curse_cooldown") then return end
	
	self:GetParent():EmitSound("Item.Brooch.Cast")
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skill_last_chance_buff", {duration = 5})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skill_last_chance_cooldown", {duration = 180})
	self:GetParent():Purge(false, true, false, true, true)
end

modifier_skill_last_chance_buff = class({})

function modifier_skill_last_chance_buff:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf" end
function modifier_skill_last_chance_buff:IsHidden() return false end
function modifier_skill_last_chance_buff:IsPurgable() return false end

function modifier_skill_last_chance_buff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_skill_last_chance_buff:CheckState()
    return 
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
    }
end

function modifier_skill_last_chance_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_avatar.vpcf"
end

function modifier_skill_last_chance_buff:StatusEffectPriority()
    return 99999
end

function modifier_skill_last_chance_buff:GetMinHealth()
	return 1
end

function modifier_skill_last_chance_buff:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_skill_last_chance_buff:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_skill_last_chance_buff:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_skill_last_chance_buff:GetModifierMoveSpeedBonus_Percentage()
	return 50
end

function modifier_skill_last_chance_buff:GetDisableHealing()
	return 1
end

function modifier_skill_last_chance_buff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():Heal(self:GetParent():GetMaxHealth() * 0.5, nil)
end

function modifier_skill_last_chance_buff:GetTexture()
	return "modifier_skill_last_chance"
end

modifier_skill_last_chance_cooldown = class({})
function modifier_skill_last_chance_cooldown:GetTexture() return "modifier_skill_last_chance" end
function modifier_skill_last_chance_cooldown:IsHidden() return false end
function modifier_skill_last_chance_cooldown:IsDebuff() return true end
function modifier_skill_last_chance_cooldown:IsPurgable() return false end
function modifier_skill_last_chance_cooldown:IsPurgeException() return false end
function modifier_skill_last_chance_cooldown:IsDebuff() return true end
function modifier_skill_last_chance_cooldown:RemoveOnDeath() return false end