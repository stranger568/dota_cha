
undying_tombstone_lua = class({})
LinkLuaModifier( "modifier_undying_tombstone_lua", "heroes/hero_undying/modifier_undying_tombstone_lua", LUA_MODIFIER_MOTION_NONE )
--7.30新增 攻击召唤僵尸
LinkLuaModifier( "modifier_undying_tombstone_lua_passive", "heroes/hero_undying/modifier_undying_tombstone_lua_passive", LUA_MODIFIER_MOTION_NONE )


function undying_tombstone_lua:GetIntrinsicModifierName()
    return "modifier_undying_tombstone_lua_passive"
end

--------------------------------------------------------------------------------

function undying_tombstone_lua:ProcsMagicStick()
	return false
end
--------------------------------------------------------------------------------
function undying_tombstone_lua:GetCooldown(level)
    return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_undying_7")
end

--------------------------------------------------------------------------------

function undying_tombstone_lua:OnSpellStart()
	if IsServer() then

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local hTombstone = CreateUnitByName( "npc_dota_creature_tombstone", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hTombstone ~= nil then

			local flDuration = self:GetSpecialValueFor( "tomb_duration" )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_undying_tombstone_lua", { duration = flDuration } )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = flDuration } )

			local nTombstoneFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nTombstoneFX, 0, self:GetCursorPosition() )	
			ParticleManager:SetParticleControlEnt( nTombstoneFX, 1, self:GetCaster(), flDuration, "attach_attack1", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( nTombstoneFX, 2, Vector( flDuration, flDuration, duration ) )
			ParticleManager:ReleaseParticleIndex( nTombstoneFX )

			EmitSoundOn( "Hero_Undying.Tombstone", hTombstone )
		end
	end
end

--------------------------------------------------------------------------------
