LinkLuaModifier("modifier_skill_goldstealer_cooldown", "modifiers/skills/modifier_skill_goldstealer", LUA_MODIFIER_MOTION_NONE)

modifier_skill_goldstealer = class({})

function modifier_skill_goldstealer:IsHidden() return true end
function modifier_skill_goldstealer:IsPurgable() return false end
function modifier_skill_goldstealer:IsPurgeException() return false end
function modifier_skill_goldstealer:RemoveOnDeath() return false end
function modifier_skill_goldstealer:AllowIllusionDuplicate() return true end

function modifier_skill_goldstealer:AttackLandedModifier(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.target == self:GetParent() then return end
	if params.attacker:IsIllusion() then return end
	if params.attacker:HasModifier("modifier_skill_goldstealer_cooldown") then return end
	if params.attacker:HasModifier("modifier_hero_refreshing") then return end

	local gold = 35 + self:GetParent():GetLevel()

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_goldstealer_cooldown", {duration = 3.5})
	self:GetParent():ModifyGold(gold, true, 0)

	if params.target:IsRealHero() then
		local gold_steal = math.min(params.target:GetGold(), gold)
		params.target:ModifyGold(gold_steal * (-1), true, 0)
	end
end

modifier_skill_goldstealer_cooldown = class({})
function modifier_skill_goldstealer_cooldown:GetTexture() return "modifier_skill_goldstealer" end
function modifier_skill_goldstealer_cooldown:IsHidden() return false end
function modifier_skill_goldstealer_cooldown:IsDebuff() return true end
function modifier_skill_goldstealer_cooldown:IsPurgable() return false end
function modifier_skill_goldstealer_cooldown:IsPurgeException() return false end
function modifier_skill_goldstealer_cooldown:RemoveOnDeath() return false end
function modifier_skill_goldstealer_cooldown:AllowIllusionDuplicate() return true end