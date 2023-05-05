LinkLuaModifier("modifier_skill_goldgainer_cooldown", "modifiers/skills/modifier_skill_goldgainer", LUA_MODIFIER_MOTION_NONE)

modifier_skill_goldgainer = class({})

function modifier_skill_goldgainer:IsHidden() return true end
function modifier_skill_goldgainer:IsPurgable() return false end
function modifier_skill_goldgainer:IsPurgeException() return false end
function modifier_skill_goldgainer:RemoveOnDeath() return false end
function modifier_skill_goldgainer:AllowIllusionDuplicate() return true end

function modifier_skill_goldgainer:AttackLandedModifier(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.target == self:GetParent() then return end
	if params.attacker:IsIllusion() then return end
	if params.attacker:HasModifier("modifier_skill_goldgainer_cooldown") then return end
	if params.attacker:HasModifier("modifier_hero_refreshing") then return end
	if params.target:IsRealHero() then
		local gold = 70 + (params.target:GetLevel() * 2)
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_goldgainer_cooldown", {duration = 3})
		self:GetParent():ModifyGold(gold, true, 0)
	end
end

modifier_skill_goldgainer_cooldown = class({})
function modifier_skill_goldgainer_cooldown:GetTexture() return "modifier_skill_goldgainer" end
function modifier_skill_goldgainer_cooldown:IsHidden() return false end
function modifier_skill_goldgainer_cooldown:IsDebuff() return true end
function modifier_skill_goldgainer_cooldown:IsPurgable() return false end
function modifier_skill_goldgainer_cooldown:IsPurgeException() return false end
function modifier_skill_goldgainer_cooldown:RemoveOnDeath() return false end
function modifier_skill_goldgainer_cooldown:AllowIllusionDuplicate() return true end