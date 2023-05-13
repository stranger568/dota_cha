modifier_skill_fervor = class({})

function modifier_skill_fervor:IsHidden() return false end
function modifier_skill_fervor:IsPurgable() return false end
function modifier_skill_fervor:IsPurgeException() return false end
function modifier_skill_fervor:RemoveOnDeath() return false end
function modifier_skill_fervor:AllowIllusionDuplicate() return true end

function modifier_skill_fervor:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_skill_fervor:OnCreated()
	if not IsServer() then return end
	self.current_target = nil
end

function modifier_skill_fervor:AttackLandedModifier( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if params.no_attack_cooldown then return end
	if self:GetParent():PassivesDisabled() then return end

    if self.current_target ~= nil and self.current_target ~= params.target then
        self:SetStackCount(self:GetStackCount() / 2)
    end

    if self.current_target == params.target then
    	if self:GetStackCount() < 12 then
        	self:SetStackCount(self:GetStackCount() + 1)
        end
    end

    self.current_target = params.target
end

function modifier_skill_fervor:GetModifierDamageOutgoing_Percentage()
	if self:GetParent():PassivesDisabled() then return end
	return self:GetStackCount() * 2.5
end
