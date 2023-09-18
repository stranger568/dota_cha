LinkLuaModifier("modifier_skill_kraken_shell_buff", "modifiers/skills/modifier_skill_kraken_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_kraken_shell_buff_cooldown", "modifiers/skills/modifier_skill_kraken_shell", LUA_MODIFIER_MOTION_NONE)

modifier_skill_kraken_shell = class({})

function modifier_skill_kraken_shell:IsHidden() return true end
function modifier_skill_kraken_shell:IsPurgable() return false end
function modifier_skill_kraken_shell:IsPurgeException() return false end
function modifier_skill_kraken_shell:RemoveOnDeath() return false end
function modifier_skill_kraken_shell:AllowIllusionDuplicate() return true end

function modifier_skill_kraken_shell:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_skill_kraken_shell:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.attacker:GetPlayerOwner() then return end
	if self:GetParent():HasModifier("modifier_skill_kraken_shell_buff_cooldown") then return end
	self:SetStackCount(self:GetStackCount() + params.damage)
	if self:GetStackCount() >= 1000 then
		self:GetParent():Purge(false, true, false, true, true)
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_kraken_shell_buff", {duration = 5})
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_kraken_shell_buff_cooldown", {duration = 12})
	end
end

modifier_skill_kraken_shell_buff_cooldown = class({})
function modifier_skill_kraken_shell_buff_cooldown:IsPurgable() return false end
function modifier_skill_kraken_shell_buff_cooldown:IsPurgeException() return false end
function modifier_skill_kraken_shell_buff_cooldown:IsDebuff() return true end

modifier_skill_kraken_shell_buff = class({})
function modifier_skill_kraken_shell_buff:IsPurgable() return false end
function modifier_skill_kraken_shell_buff:IsPurgeException() return false end
function modifier_skill_kraken_shell_buff:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_skill_kraken_shell_buff:GetModifierMagicalResistanceBonus()
	return 15
end

function modifier_skill_kraken_shell_buff:GetModifierStatusResistanceStacking()
	return 15
end