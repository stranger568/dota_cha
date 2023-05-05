modifier_skill_craggy_man = class({})

function modifier_skill_craggy_man:IsHidden() return true end
function modifier_skill_craggy_man:IsPurgable() return false end
function modifier_skill_craggy_man:IsPurgeException() return false end
function modifier_skill_craggy_man:RemoveOnDeath() return false end
function modifier_skill_craggy_man:AllowIllusionDuplicate() return true end

function modifier_skill_craggy_man:AttackLandedModifier(params)
    if params.target == self:GetParent() then
    	if RollPercentage(20) and not params.target:PassivesDisabled() and params.attacker:IsHero() then
    		if params.attacker:IsMagicImmune() then return end
        	params.attacker:AddNewModifier(self:GetParent(), nil, "modifier_stunned", {duration = 1})
        end
    end
end