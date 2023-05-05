LinkLuaModifier("modifier_skill_radioactive_debuff", "modifiers/skills/modifier_skill_radioactive", LUA_MODIFIER_MOTION_NONE)

modifier_skill_radioactive = class({})

function modifier_skill_radioactive:IsHidden() return true end
function modifier_skill_radioactive:IsPurgable() return false end
function modifier_skill_radioactive:IsPurgeException() return false end
function modifier_skill_radioactive:RemoveOnDeath() return false end
function modifier_skill_radioactive:AllowIllusionDuplicate() return true end

function modifier_skill_radioactive:OnCreated()
	if not IsServer() then return end
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(600, 0, 0))
    self:AddParticle(particle, false, false, -1, false, false)

    self.particle = ParticleManager:CreateParticle("particles/doom_bringer_doom_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_skill_radioactive:IsAura() return true end

function modifier_skill_radioactive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_skill_radioactive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_skill_radioactive:GetModifierAura()
	return "modifier_skill_radioactive_debuff"
end

function modifier_skill_radioactive:GetAuraRadius()
	return 600
end

function modifier_skill_radioactive:GetAuraDuration()
	return 0.5
end

modifier_skill_radioactive_debuff = class({})

function modifier_skill_radioactive_debuff:IsDebuff() return true end
function modifier_skill_radioactive_debuff:IsPurgable() return false end
function modifier_skill_radioactive_debuff:GetTexture() return "modifier_skill_radioactive" end

function modifier_skill_radioactive_debuff:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_skill_radioactive_debuff:OnIntervalThink()
	if not IsServer() then return end

	local damage = 120

	local distance = (self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D()
	
	if distance <= 300 then
		damage = damage + 130
	end

	if self:GetCaster():HasModifier("modifier_item_kaya_2_lua") or self:GetCaster():HasModifier("modifier_item_kaya_3_lua") then
		damage = damage / 2
	end
	
	ApplyDamage({victim = self:GetParent(), attacker = self:GetAuraOwner(), ability = nil, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end