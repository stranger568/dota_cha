modifier_skill_zoo_director = class({})

function modifier_skill_zoo_director:IsHidden() return true end
function modifier_skill_zoo_director:IsPurgable() return false end
function modifier_skill_zoo_director:IsPurgeException() return false end
function modifier_skill_zoo_director:RemoveOnDeath() return false end
function modifier_skill_zoo_director:AllowIllusionDuplicate() return true end

modifier_skill_zoo_director_buff = class({})

function modifier_skill_zoo_director_buff:IsPurgable() return false end
function modifier_skill_zoo_director_buff:IsHidden() return false end
function modifier_skill_zoo_director_buff:IsDebuff() return false end
function modifier_skill_zoo_director_buff:GetTexture() return "modifier_skill_zoo_director" end

function modifier_skill_zoo_director_buff:OnCreated()
	if not IsServer() then return end

	Timers:CreateTimer(FrameTime(), function()
		self:GetParent():SetModelScale(self:GetParent():GetModelScale() * 1.1)
	end)
end

function modifier_skill_zoo_director_buff:GetEffectName()
    return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf"
end

function modifier_skill_zoo_director_buff:DeclareFunctions()
    local funcs = 
    {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE,
	}
	return funcs
end

function modifier_skill_zoo_director_buff:GetModifierDamageOutgoing_Percentage()
   	return 50
end

function modifier_skill_zoo_director_buff:GetModifierMoveSpeedBonus_Percentage()
   	return 10
end

function modifier_skill_zoo_director_buff:GetModifierExtraHealthPercentage()
	if self:GetParent():GetBaseMaxHealth() >= 700000000 then
		return 0
	end
	return 50
end

function modifier_skill_zoo_director_buff:GetModifierStatusResistance()
	return 15
end

function modifier_skill_zoo_director_buff:GetModifierMagicalResistanceDirectModification()
	return 15
end

function modifier_skill_zoo_director_buff:GetModifierPhysicalArmorTotal_Percentage()
	return 15
end