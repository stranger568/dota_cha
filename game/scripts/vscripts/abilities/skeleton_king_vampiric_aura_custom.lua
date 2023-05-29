LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom", "abilities/skeleton_king_vampiric_aura_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", "abilities/skeleton_king_vampiric_aura_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skelet_reincarnation", "abilities/skeleton_king_vampiric_aura_custom.lua", LUA_MODIFIER_MOTION_NONE )

skeleton_king_vampiric_aura_custom = class({})

function skeleton_king_vampiric_aura_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_vampiric_aura_custom"
end

function skeleton_king_vampiric_aura_custom:OnSpellStart()
	if not IsServer() then return end
	local modifier = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
	if modifier == nil then return end
	local delay = self:GetSpecialValueFor("spawn_interval")
	self:GetCaster():EmitSound("Hero_SkeletonKing.MortalStrike.Cast")

	for i=1, self:GetSpecialValueFor("min_skeleton_spawn") do
		Timers:CreateTimer(delay * i, function ()
			self:CreateSkeleton(self:GetCaster():GetOrigin()+RandomVector(300), nil, nil, true, "npc_dota_wraith_king_skeleton_warrior")
		end)
	end
end

function skeleton_king_vampiric_aura_custom:CreateSkeleton(origin, target, duration_custom, reincarnation, name_unit)
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor("skeleton_duration")
	local skelet = CreateUnitByName( name_unit, origin, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, skelet ) )
	skelet:SetOwner( self:GetCaster() )
	skelet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	skelet:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})
	local modifier = skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", {target = target_enemy, duration = duration})
	if reincarnation then
		skelet:AddNewModifier(self:GetCaster(), self, "modifier_skelet_reincarnation", {})
	end
	skelet.owner = self:GetCaster()
	skelet.skelet = true
	skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom", {})
	skelet:EmitSound("n_creep_Skeleton.Spawn")
	skelet:EmitSound("n_creep_TrollWarlord.RaiseDead")

	skelet:SetBaseDamageMin(self:GetSpecialValueFor("skeleton_damage_tooltip"))
	skelet:SetBaseDamageMax(self:GetSpecialValueFor("skeleton_damage_tooltip"))
end

modifier_skeleton_king_vampiric_aura_custom = class({})

function modifier_skeleton_king_vampiric_aura_custom:IsHidden() return self:GetStackCount() == 0 end
function modifier_skeleton_king_vampiric_aura_custom:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_skeleton_king_vampiric_aura_custom:OnCreated(params)
	self:SetStackCount(0)
	self.creeps_killed = 0
	self.creeps_killed_to_charge = 2
end

function modifier_skeleton_king_vampiric_aura_custom:OnTakeDamage(params)
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.unit:IsBuilding() then return end
	self.heal = self:GetAbility():GetSpecialValueFor("vampiric_aura") / 100
	self.heal = self.heal
	if params.inflictor == nil then 
		local heal = params.damage*self.heal
		self:GetParent():Heal(heal, self:GetAbility())
	end
end 

modifier_skeleton_king_vampiric_aura_custom_skeleton_ai = class({})

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:RemoveOnDeath() return false end
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsHidden() return true end
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnCreated(table)
	if not IsServer() then return end
	self:GetParent():SetBaseMaxHealth(self:GetAbility():GetSpecialValueFor("skeleton_health_tooltip"))
	self:GetParent():SetMaxHealth(self:GetAbility():GetSpecialValueFor("skeleton_health_tooltip"))
	self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
end

modifier_skelet_reincarnation = class({})

function modifier_skelet_reincarnation:IsHidden()
    return true
end

function modifier_skelet_reincarnation:RemoveOnDeath()
    return true
end

function modifier_skelet_reincarnation:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_skelet_reincarnation:OnDeath( params )
    if not IsServer() then return end
    if params.attacker == nil then return end
    if params.unit ~= self:GetParent() then return end
    if params.attacker == self:GetParent() then return end
 	local point = self:GetParent():GetAbsOrigin()
  	local team = self:GetParent():GetTeamNumber()
  	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local duration = 0
	local modifier_kill = self:GetParent():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai")
	local delay_reincarnation = 3

	if modifier_kill then
		duration = modifier_kill:GetRemainingTime()
	end

	local name = self:GetParent():GetUnitName()

	Timers:CreateTimer(delay_reincarnation, function()
		if caster ~= nil and not caster:IsNull() then 
			ability:CreateSkeleton(point, nil, duration, false, name)
		end
	end)
end