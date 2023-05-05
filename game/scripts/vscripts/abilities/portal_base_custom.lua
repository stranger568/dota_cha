LinkLuaModifier("modifier_portal_base_custom_cd", "abilities/portal_base_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_portal_base_custom_cast", "abilities/portal_base_custom", LUA_MODIFIER_MOTION_BOTH)

portal_base_custom = class ({})

function portal_base_custom:GetChannelTime() return 1.5 end

function portal_base_custom:OnSpellStart(target)
	if not IsServer() then return end
	local hero = self:GetCaster()
	local tp_point = {0,0,0}
	if self.portal and self.portal == "npc_dota_teleport_base_custom_red" then
		self.point = Vector(-946.366, -953.918, 256)
		tp_point = {1130.96, 1848.67, 256}
		local modifier_stranger_think = hero:FindModifierByName("modifier_stranger_think")
		if modifier_stranger_think then
			modifier_stranger_think.current_portal = "blue"
		end
	end
	if self.portal and self.portal == "npc_dota_teleport_base_custom_blue" then
		self.point = Vector(961.924, 1742.87, 256)
		tp_point = {-1103.08, -1086.68, 248.712}
		local modifier_stranger_think = hero:FindModifierByName("modifier_stranger_think")
		if modifier_stranger_think then
			modifier_stranger_think.current_portal = "red"
		end
	end
	hero:AddNewModifier(hero, nil, "modifier_portal_base_custom_cast", {x = tp_point[1], y = tp_point[2]})
	self:GetCaster():EmitSound("Hero_Underlord.Portal.In")
end

function portal_base_custom:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	self:GetCaster():RemoveModifierByName("modifier_portal_base_custom_cast")
	local modifier_stranger_think = self:GetCaster():FindModifierByName("modifier_stranger_think")
	if modifier_stranger_think then
		modifier_stranger_think.think_to_portal = false
		modifier_stranger_think.cast_portal = false
	end
	if bInterrupted then 
		local hero = self:GetCaster()
		for i = 0,34 do
			local ability_search = hero:GetAbilityByIndex(i)
			if ability_search ~= nil then
				if ability_search:GetAbilityName() == "portal_base_custom" then 
					hero:RemoveAbility("portal_base_custom")	
				end
			end
		end
		return 
	end
	local hero = self:GetCaster()
	self:GetCaster():StopSound("Hero_Underlord.Portal.In")
	local point = self.point

	for i = 0,34 do
		local ability_search = hero:GetAbilityByIndex(i)
		if ability_search ~= nil then
			if ability_search:GetAbilityName() == "portal_base_custom" then 
				hero:RemoveAbility("portal_base_custom")	
			end
		end
	end

	PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero) 
	hero:SetAbsOrigin(point)
	FindClearSpaceForUnit(hero, point, true)

	hero:Stop()
	hero:Interrupt()

	EmitSoundOnLocationWithCaster( point, "Hero_Underlord.Portal.Out", hero )

	Timers:CreateTimer({ endTime = FrameTime(), callback = function()
        PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
    end})

    hero:RemoveModifierByName("modifier_portal_base_custom_cast")
end

modifier_portal_base_custom_cd = class({})
function modifier_portal_base_custom_cd:IsHidden() return true end
function modifier_portal_base_custom_cd:IsPurgable() return false end

modifier_portal_base_custom_cast = class({})
function modifier_portal_base_custom_cast:IsHidden() return true end
function modifier_portal_base_custom_cast:IsPurgable() return false end

function modifier_portal_base_custom_cast:OnCreated(params)
	if not IsServer() then return end
	self.point = Vector(params.x, params.y, 0)
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_black_hole_scepter_pull_debuff.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	ParticleManager:SetParticleControl( particle, 1, self:GetCaster():GetAbsOrigin() )
	self:AddParticle( particle, false, false, -1, false, false )

	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_portal_base_custom_cast:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_portal_base_custom_cast:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_portal_base_custom_cast:OnDestroy()
	if not IsServer() then return end
end

function modifier_portal_base_custom_cast:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	local distance = self.point - me:GetOrigin()
	if distance:Length2D() > 100 then
		me:SetOrigin( me:GetOrigin() + distance:Normalized() * 45 * dt )
	end
end

function modifier_portal_base_custom_cast:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end