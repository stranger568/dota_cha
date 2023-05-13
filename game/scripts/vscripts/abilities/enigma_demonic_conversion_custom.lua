LinkLuaModifier("modifier_enigma_demonic_conversion_custom_creep", "abilities/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE)

enigma_demonic_conversion_custom = class({})

function enigma_demonic_conversion_custom:CastFilterResultTarget( target )

	if target:IsAncient() then
		return UF_FAIL_ANCIENT
	end

	if target:GetLevel() > self:GetSpecialValueFor("creep_max_level") and not target:IsHero() then
		return UF_FAIL_ANCIENT
	end

	local nResult = UnitFilter(
		target,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)

	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function enigma_demonic_conversion_custom:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local location = target:GetAbsOrigin()

	EmitSoundOn("Hero_Enigma.Demonic_Conversion",target)

	if not target:IsHero() then
		target:Kill(ability, caster)
		target = nil
	end

	local eidolon_count = ability:GetSpecialValueFor("spawn_count")
	if eidolon_count > 0 then
		for i=1, eidolon_count do
			ability:CreateEidolon(target, location)
		end
	end
end

function enigma_demonic_conversion_custom:CreateEidolon(hParent, vLocation)
	local typs = 
	{
		[1] = "npc_dota_lesser_eidolon",
		[2] = "npc_dota_eidolon",
		[3] = "npc_dota_greater_eidolon",
		[4] = "npc_dota_dire_eidolon",
	}

	local eidolon = CreateUnitByName(typs[self:GetLevel()], vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	eidolon:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 40})
	eidolon:SetOwner(self:GetCaster())
	eidolon:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	FindClearSpaceForUnit(eidolon, vLocation, true)
	eidolon:AddNewModifier(self:GetCaster(), self, "modifier_demonic_conversion", {duration = 40, allowsplit = 6})
	eidolon:AddNewModifier(self:GetCaster(), self, "modifier_enigma_demonic_conversion_custom_creep", {})
end

modifier_enigma_demonic_conversion_custom_creep = class({})

function modifier_enigma_demonic_conversion_custom_creep:IsHidden() return true end
function modifier_enigma_demonic_conversion_custom_creep:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_creep:IsPurgeException() return false end

function modifier_enigma_demonic_conversion_custom_creep:OnCreated()
	if not IsServer() then return end
	self:GetParent():SetBaseDamageMin(self:GetAbility():GetSpecialValueFor("eidolon_dmg_tooltip"))
	self:GetParent():SetBaseDamageMax(self:GetAbility():GetSpecialValueFor("eidolon_dmg_tooltip"))
	self:GetParent():SetBaseMaxHealth(self:GetAbility():GetSpecialValueFor("eidolon_hp_tooltip"))
	self:GetParent():SetMaxHealth(self:GetAbility():GetSpecialValueFor("eidolon_hp_tooltip"))
	self:GetParent():SetHealth(self:GetAbility():GetSpecialValueFor("eidolon_hp_tooltip"))
end