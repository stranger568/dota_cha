modifier_skill_retraining = class({})

function modifier_skill_retraining:IsHidden() return true end
function modifier_skill_retraining:IsPurgable() return false end
function modifier_skill_retraining:IsPurgeException() return false end
function modifier_skill_retraining:RemoveOnDeath() return false end
function modifier_skill_retraining:AllowIllusionDuplicate() return true end

function modifier_skill_retraining:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:StartIntervalThink(1)
end

function modifier_skill_retraining:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount() == 5 then
		self:SetStackCount(0)
		local hItem = CreateItem("item_relearn_book_lua", self:GetParent(), self:GetParent())
        self:GetParent():AddItem(hItem)
        hItem:SetPurchaseTime(0)
	end
end