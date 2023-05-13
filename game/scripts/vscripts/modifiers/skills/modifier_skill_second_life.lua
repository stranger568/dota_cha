LinkLuaModifier("modifier_skill_second_life_cooldown", "modifiers/skills/modifier_skill_second_life", LUA_MODIFIER_MOTION_NONE)

modifier_skill_second_life = class({})

function modifier_skill_second_life:IsHidden() return true end
function modifier_skill_second_life:IsPurgable() return false end
function modifier_skill_second_life:IsPurgeException() return false end
function modifier_skill_second_life:RemoveOnDeath() return false end
function modifier_skill_second_life:AllowIllusionDuplicate() return true end

function modifier_skill_second_life:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_REINCARNATION,
	}
	return funcs
end

function modifier_skill_second_life:ReincarnateTime()
	if self:GetParent():HasModifier("modifier_duel_curse_cooldown") then return end
	if self:GetParent():HasModifier("modifier_skill_second_life_cooldown") then return nil end
	local parent = self:GetParent()
	Timers:CreateTimer(0, function()
		if parent and not parent:IsAlive() then return 0.1 end
		parent:AddNewModifier(parent, nil, "modifier_skill_second_life_cooldown", {duration = 300})
	end)
	return 5
end

modifier_skill_second_life_cooldown = class({})
function modifier_skill_second_life_cooldown:GetTexture() return "modifier_skill_second_life" end
function modifier_skill_second_life_cooldown:IsHidden() return false end
function modifier_skill_second_life_cooldown:IsDebuff() return true end
function modifier_skill_second_life_cooldown:IsPurgable() return false end
function modifier_skill_second_life_cooldown:IsPurgeException() return false end
function modifier_skill_second_life_cooldown:RemoveOnDeath() return false end
function modifier_skill_second_life_cooldown:AllowIllusionDuplicate() return true end