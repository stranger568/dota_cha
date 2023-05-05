modifier_skill_overcharge = class({})

function modifier_skill_overcharge:IsHidden() return true end
function modifier_skill_overcharge:IsPurgable() return false end
function modifier_skill_overcharge:IsPurgeException() return false end
function modifier_skill_overcharge:RemoveOnDeath() return false end
function modifier_skill_overcharge:AllowIllusionDuplicate() return true end

function modifier_skill_overcharge:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
end

function modifier_skill_overcharge:GetModifierPercentageCooldown()
	if self:GetParent():HasModifier("modifier_item_quickening_charm") then return end
	if self:GetParent():HasModifier("modifier_spell_prism") then return end
	if self:GetParent():HasModifier("modifier_item_seer_stone") then return end
	if self:GetParent():HasModifier("modifier_item_seer_stone_custom") then return end
	return 15
end