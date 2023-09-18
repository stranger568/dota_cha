modifier_skill_magic_shroud = class({})

function modifier_skill_magic_shroud:IsHidden() return true end
function modifier_skill_magic_shroud:IsPurgable() return false end
function modifier_skill_magic_shroud:IsPurgeException() return false end
function modifier_skill_magic_shroud:RemoveOnDeath() return false end
function modifier_skill_magic_shroud:AllowIllusionDuplicate() return true end

function modifier_skill_magic_shroud:TakeDamageScriptModifier(params)
    if params.unit == self:GetParent() then
        local attacker = params.attacker
        local damage = params.original_damage
        if self:GetParent():PassivesDisabled() then return end
        if self:GetParent():GetHealthPercent() <= 5 then return end
    	if not self:GetParent():IsIllusion() then
            if self:GetParent():GetMana() >= self:GetParent():GetMaxMana() then
                if attacker:IsHero() then
                    self:GetParent():Heal(damage/100*20, nil)
                end
            else
                self:GetParent():GiveMana(damage/100*20)
                if attacker:IsHero() then
                    self:GetParent():Heal(damage/100*10, nil)
                end
            end
		end
    end
end