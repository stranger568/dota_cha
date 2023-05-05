modifier_duel_damage_check = class({})

function modifier_duel_damage_check:IsHidden() return true end
function modifier_duel_damage_check:IsPurgable() return false end
function modifier_duel_damage_check:IsPurgeException() return false end
function modifier_duel_damage_check:RemoveOnDeath() return false end

function modifier_duel_damage_check:TakeDamageScriptModifier(params)
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	self:SetStackCount(math.max(0, self:GetStackCount() + params.damage))
end