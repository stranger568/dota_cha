modifier_anchor_smash_lua = class({})

function modifier_anchor_smash_lua:IsHidden() return true end
function modifier_anchor_smash_lua:IsPurgable() return false end

if not IsServer() then return end

function modifier_anchor_smash_lua:OnCreated()
	self.ability = self:GetAbility()

	self.parent = self:GetParent()

	self.bonus_damage = self.ability:GetSpecialValueFor("attack_damage")
	self.talent_chance = self.ability:GetSpecialValueFor("talent_activation_chance")

	if IsServer() then
		self:StartIntervalThink(self.ability:GetSpecialValueFor("talent_cooldown"))
	end
end

function modifier_anchor_smash_lua:OnRefresh()
	self:OnCreated()
end

function modifier_anchor_smash_lua:OnIntervalThink()
	if self.parent:GetTalentValue("special_bonus_unique_tidehunter_8") ~= 1 then return end
	self.talent_active = true
end

function modifier_anchor_smash_lua:GetModifierProcAttack_Feedback(keys)
	if not self.talent_active then return end
	if not self.ability or self.ability:IsNull() then return end
	
	if keys.no_attack_cooldown then return end

	if RollPercentage(self.talent_chance) then
		self.ability:OnSpellStart("talent")
		self.talent_active = false
	end
end

function modifier_anchor_smash_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_anchor_smash_lua:GetModifierPreAttack_BonusDamage()
	if self.parent.anchor_attack then return self.bonus_damage end
end
