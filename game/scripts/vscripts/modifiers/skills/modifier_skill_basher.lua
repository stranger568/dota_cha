LinkLuaModifier("modifier_skill_basher_cooldown", "modifiers/skills/modifier_skill_basher", LUA_MODIFIER_MOTION_NONE)

modifier_skill_basher = class({})

function modifier_skill_basher:IsHidden() return true end
function modifier_skill_basher:IsPurgable() return false end
function modifier_skill_basher:IsPurgeException() return false end
function modifier_skill_basher:RemoveOnDeath() return false end
function modifier_skill_basher:AllowIllusionDuplicate() return true end

function modifier_skill_basher:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then
    	if self:GetParent():HasModifier("modifier_skill_basher_cooldown") then return end
        if self:GetParent():HasModifier("modifier_item_cranium_basher") then return end
    	local target = params.target
    	local chance = 10
    	local cooldown_bash = 2
    	local stun_duration = 1.3

    	if RollPercentage(chance) and not self:GetParent():IsIllusion() then
    		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_basher_cooldown", {duration = cooldown_bash})
    		self:GetParent():EmitSound("DOTA_Item.SkullBasher")
			params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = stun_duration * (1 - params.target:GetStatusResistance())})
		end
    end
end

modifier_skill_basher_cooldown = class({})

function modifier_skill_basher_cooldown:IsHidden() return true end
function modifier_skill_basher_cooldown:IsPurgable() return false end
function modifier_skill_basher_cooldown:RemoveOnDeath() return false end