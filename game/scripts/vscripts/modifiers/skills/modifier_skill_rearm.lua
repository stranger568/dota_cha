modifier_skill_rearm = class({})

function modifier_skill_rearm:IsHidden() return true end
function modifier_skill_rearm:IsPurgable() return false end
function modifier_skill_rearm:IsPurgeException() return false end
function modifier_skill_rearm:RemoveOnDeath() return false end
function modifier_skill_rearm:AllowIllusionDuplicate() return true end

function modifier_skill_rearm:OnAbilityfullCastCustom(params)
	local hAbility = params.ability
    if hAbility == nil or not ( hAbility:GetCaster() == self:GetParent() ) then
        return 0
    end

    if hAbility:IsToggle() or hAbility:IsItem() then
        return 0
    end

    local chance = 25

    if IsUltimateAbility(hAbility) then
    	chance = 15
    end

    if hAbility:GetAbilityName() == "phoenix_supernova" then return end

    if RollPercentage(chance) then
    	Timers:CreateTimer(FrameTime(), function()
    		hAbility:EndCooldown()
    	end)
    end
end

function IsUltimateAbility(ability)
	return bit:_and(ability:GetAbilityType(), 1) == 1
end