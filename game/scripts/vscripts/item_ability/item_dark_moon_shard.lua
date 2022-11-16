LinkLuaModifier( "modifier_item_dark_moon_shard", "item_ability/modifier/modifier_item_dark_moon_shard", LUA_MODIFIER_MOTION_BOTH )


item_dark_moon_shard = class({})


function item_dark_moon_shard:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and ((hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")) or (string.find(hCaster:GetUnitName(),"npc_dota_lone_druid_bear") == 1) ) then 
		      if hCaster:HasModifier("modifier_item_dark_moon_shard") then
               return
            end
            if hCaster:HasModifier("modifier_alchemist_chemical_rage") then
               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"CanNotCastDuringRage",{})
               return
            end
            if hCaster:HasModifier("modifier_snapfire_lil_shredder_buff") then
               CustomGameEventManager:Send_ServerToPlayer(hPlayer,"CanNotCastDuringLil",{})
               return
            end
            hCaster:AddNewModifier(hCaster, self, "modifier_item_dark_moon_shard", {})
            self:SpendCharge()
            EmitSoundOn("Item.MoonShard.Consume", hCaster)
			   Util:RecordConsumableItem(hCaster:GetPlayerOwnerID(),"item_dark_moon_shard")
		end
      -- 如果小熊使用 记录在英雄上
      if hCaster and string.find(hCaster:GetUnitName(),"npc_dota_lone_druid_bear") == 1 then 
         local nPlayerID=hCaster:GetPlayerOwnerID()
         if nPlayerID then
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if hHero then
               hHero.bUsedBearDarkMoon = true
            end
         end
      end
	end
end

