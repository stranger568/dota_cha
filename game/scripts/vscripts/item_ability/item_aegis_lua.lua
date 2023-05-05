item_aegis_lua = class({})
LinkLuaModifier( "modifier_item_aegis_lua", "item_ability/item_aegis_lua", LUA_MODIFIER_MOTION_NONE )

--自动使用
function item_aegis_lua:GetIntrinsicModifierName()
  return "modifier_item_aegis_lua"
end

modifier_item_aegis_lua = class({})

function modifier_item_aegis_lua:IsHidden()
	return true
end

function modifier_item_aegis_lua:OnCreated()
	if IsServer() then

		Timers:CreateTimer(0.1, function()
			if self and not self:IsNull() then
					local hCaster = self:GetParent()
					local hPlayer =  hCaster:GetPlayerOwner()
					if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua") then 
					    if hCaster:HasModifier("modifier_aegis") then
			               local hModifierAegis = hCaster:FindModifierByName("modifier_aegis")
			               local nCurrentStack = hModifierAegis:GetStackCount()
			               hModifierAegis:SetStackCount(nCurrentStack+1)
			               CustomNetTables:SetTableValue("aegis_count", tostring(hCaster:GetPlayerOwnerID()), {count = nCurrentStack+1})
					    else
			                local hModifierAegis = hCaster:AddNewModifier(hCaster, nil, "modifier_aegis", {})
			                hModifierAegis:SetStackCount(1)
			                CustomNetTables:SetTableValue("aegis_count", tostring(hCaster:GetPlayerOwnerID()), {count = 1})
					    end
					    self:GetAbility():SpendCharge()
					    EmitSoundOn("DOTA_Item.Refresher.Activate", hCaster)
					    local nParticle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
						ParticleManager:ReleaseParticleIndex( nParticle );
						Util:RecordConsumableItem(hCaster:GetPlayerOwnerID(),"item_aegis_lua")
						self:Destroy()
					end
			end
		end)
	end
end

