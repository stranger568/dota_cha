
item_summoner_crown = class({})
item_summoner_crown_1 = item_summoner_crown
item_summoner_crown_2 = item_summoner_crown
item_summoner_crown_3 = item_summoner_crown

LinkLuaModifier("modifier_item_summoner_crown", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summoner_crown_buff_agi", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summoner_crown_buff_int", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summoner_crown_model_size", "item_ability/item_summoner_crown", LUA_MODIFIER_MOTION_NONE)


function item_summoner_crown:GetIntrinsicModifierName()
	return "modifier_item_summoner_crown"
end


modifier_item_summoner_crown = class({})

function modifier_item_summoner_crown:IsDebuff() return false end
function modifier_item_summoner_crown:IsHidden() return true end
function modifier_item_summoner_crown:IsPurgable() return false end
function modifier_item_summoner_crown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_summoner_crown:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_item_summoner_crown:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_summoner_crown:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_summoner_crown:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end





modifier_item_summoner_crown_buff_agi = class({})

function modifier_item_summoner_crown_buff_agi:IsDebuff() return false end
function modifier_item_summoner_crown_buff_agi:IsHidden() return true end
function modifier_item_summoner_crown_buff_agi:IsPurgable() return false end
function modifier_item_summoner_crown_buff_agi:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_summoner_crown_buff_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_item_summoner_crown_buff_agi:OnCreated()
	self.speed_bonus_per_agi = self:GetAbility():GetSpecialValueFor("speed_bonus_per_agi")
    self.armor_bonus_per_agi = self:GetAbility():GetSpecialValueFor("armor_bonus_per_agi")
end



function modifier_item_summoner_crown_buff_agi:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.speed_bonus_per_agi
end

function modifier_item_summoner_crown_buff_agi:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_bonus_per_agi
end



modifier_item_summoner_crown_buff_int = class({})

function modifier_item_summoner_crown_buff_int:IsDebuff() return false end
function modifier_item_summoner_crown_buff_int:IsHidden() return true end
function modifier_item_summoner_crown_buff_int:IsPurgable() return false end
function modifier_item_summoner_crown_buff_int:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_summoner_crown_buff_int:OnCreated()
	self.damage_bonus_per_int = self:GetAbility():GetSpecialValueFor("damage_bonus_per_int")
end


function modifier_item_summoner_crown_buff_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		--MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_item_summoner_crown_buff_int:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount() * self.damage_bonus_per_int
end

function modifier_item_summoner_crown_buff_int:TakeDamageScriptModifier(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.unit:IsAttackImmune() then return end
	if params.unit:IsInvulnerable() then return end
	if params.attacker:GetUnitName() == "npc_dota_witch_doctor_death_ward" then
		if params.original_damage == 90 or params.original_damage == 150 or params.original_damage == 210 or params.original_damage == 150 or params.original_damage == 210 or params.original_damage == 270 then
			ApplyDamage({ victim = params.unit, attacker = params.attacker, damage = params.attacker:GetAverageTrueAttackDamage(nil) / 2, damage_type = DAMAGE_TYPE_PHYSICAL })
			print("???????????????????????????? ???????? ???? ???????????? ??????????")
		end
	end
end

modifier_item_summoner_crown_model_size = class({})

function modifier_item_summoner_crown_model_size:IsDebuff() return false end
function modifier_item_summoner_crown_model_size:IsHidden() return true end
function modifier_item_summoner_crown_model_size:IsPurgable() return false end
function modifier_item_summoner_crown_model_size:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_summoner_crown_model_size:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_item_summoner_crown_model_size:OnCreated()
	self.model_scale = self:GetAbility():GetSpecialValueFor("model_scale")
end


function modifier_item_summoner_crown_model_size:GetModifierModelScale()
	return self.model_scale
end