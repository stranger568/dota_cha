modifier_skill_unbreakble = class({})
function modifier_skill_unbreakble:GetTexture() return "modifier_skill_unbreakble" end
function modifier_skill_unbreakble:IsHidden() return false end
function modifier_skill_unbreakble:IsPurgable() return false end
function modifier_skill_unbreakble:IsPurgeException() return false end
function modifier_skill_unbreakble:RemoveOnDeath() return false end
function modifier_skill_unbreakble:AllowIllusionDuplicate() return true end

function modifier_skill_unbreakble:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_skill_unbreakble:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(15)
	self:StartIntervalThink(FrameTime())
end

function modifier_skill_unbreakble:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then self:SetStackCount(0) return end
	local count_modifiers_old = 0
    for _, modifier in pairs(self:GetParent():FindAllModifiers()) do
        if modifier and modifier:IsDebuff() then
            count_modifiers_old = count_modifiers_old + 1
        end
    end
    local new = 15 + (math.min(5,count_modifiers_old) * 7)
    self:SetStackCount( new )
end

function modifier_skill_unbreakble:GetModifierStatusResistanceStacking()
	return self:GetStackCount()
end