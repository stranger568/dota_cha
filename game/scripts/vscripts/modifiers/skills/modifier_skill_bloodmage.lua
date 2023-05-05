modifier_skill_bloodmage = class({})

function modifier_skill_bloodmage:IsHidden() return true end
function modifier_skill_bloodmage:IsPurgable() return false end
function modifier_skill_bloodmage:IsPurgeException() return false end
function modifier_skill_bloodmage:RemoveOnDeath() return false end
function modifier_skill_bloodmage:AllowIllusionDuplicate() return true end

function modifier_skill_bloodmage:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:StartIntervalThink(0.1)
end

function modifier_skill_bloodmage:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount() > 0 then return end
	local modifier_item_bloodstone_2 = self:GetParent():FindModifierByName("modifier_item_bloodstone_2")
	if modifier_item_bloodstone_2 then
		modifier_item_bloodstone_2:GetAbility():SetCurrentCharges(modifier_item_bloodstone_2:GetAbility():GetCurrentCharges() * 2)
		self:StartIntervalThink(-1)
		self:SetStackCount(1)
	end
end