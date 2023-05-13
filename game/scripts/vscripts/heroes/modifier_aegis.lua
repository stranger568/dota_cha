LinkLuaModifier("modifier_skill_second_life_cooldown", "modifiers/skills/modifier_skill_second_life", LUA_MODIFIER_MOTION_NONE)

modifier_aegis = class({})

function modifier_aegis:IsHidden()
	return (self:GetStackCount()<=0)
end

function modifier_aegis:GetTexture()
	return "item_aegis"
end

function modifier_aegis:IsPermanent()
	return true
end

function modifier_aegis:IsPurgable()
	return false
end


function modifier_aegis:DeclareFunctions()
	local funcs = 
	{
		--MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_aegis:OnCreated()
	if IsServer() then
       self.reincarnate_time = 5.0
       self.reincarnate_buff_time = 14.0
    end
end

--PVP无效 断线队伍无效
function modifier_aegis:ReincarnateTime()
	
	local nPlayerID
    if self:GetParent().GetPlayerOwnerID then
       nPlayerID = self:GetParent():GetPlayerOwnerID()
    end

    local nTeamID = PlayerResource:GetTeam(nPlayerID)
    
    if nPlayerID  and nTeamID and PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_ABANDONED and GameRules.teamAbandonMap[nTeamID] then
        return nil
    end

    if (self:GetParent():HasModifier("modifier_skill_second_life") and not self:GetParent():HasModifier("modifier_skill_second_life_cooldown")) and not self:GetParent():HasModifier("modifier_duel_curse_cooldown") then
		local parent = self:GetParent()
	    Timers:CreateTimer(0, function()
			if parent and not parent:IsAlive() then return 0.1 end
			parent:AddNewModifier(parent, nil, "modifier_skill_second_life_cooldown", {duration = 300})
		end)
		return 5
    end

    --如果层数不够就不触发了
    if self:GetStackCount()<=0  then
       return nil
    end

	if true~=self:GetParent().bJoiningPvp then
	   return self.reincarnate_time
	else
	   return nil
	end
end

-- 断线队伍收到伤害增加
function modifier_aegis:GetModifierIncomingDamage_Percentage(params)
    
    local nPlayerID
    if self:GetParent().GetPlayerOwnerID then
       nPlayerID = self:GetParent():GetPlayerOwnerID()
    end

    local nTeamID = PlayerResource:GetTeam(nPlayerID)
    
	if nPlayerID  and nTeamID and PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_ABANDONED and GameRules.teamAbandonMap[nTeamID] then
       return 5000
    else
       return 0
    end
end




function modifier_aegis:OnDeathEvent(keys)
	if IsServer() then
	   if keys.unit == self:GetParent() then
	      
	      --没有触发重生技能，并且不参与PVP才消耗层数
          if not Util:IsReincarnationWork(self:GetParent()) and true~=self:GetParent().bJoiningPvp and (self:GetStackCount()>=1) then
          	  local hCaster = self:GetParent()
          	  local hAbility = self:GetAbility()
          	  local flReincarnateTime = self.reincarnate_time
          	  local flReincarnateBuffTime = self.reincarnate_buff_time

          	  if self:GetParent():HasModifier("modifier_skill_rebirth") then
          	  		flReincarnateBuffTime = flReincarnateBuffTime + 20
          	  end

		      Timers:CreateTimer({ endTime = flReincarnateTime, 
				        callback = function()
				          local nParticle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
						  ParticleManager:SetParticleControl(nParticle, 1, Vector(0, 0, 0))
						  ParticleManager:SetParticleControl(nParticle, 3, hCaster:GetAbsOrigin())
						  ParticleManager:ReleaseParticleIndex(nParticle)
				    end
			  })

		      Util:RefreshAbilityAndItem( hCaster,{skeleton_king_reincarnation=true} )

			  Timers:CreateTimer({ endTime = flReincarnateTime+0.3, 
				        callback = function()
						  hCaster:AddNewModifier(hCaster, hAbility, "modifier_aegis_buff", {duration=flReincarnateBuffTime})
				   end
			  })
			  --削减层数
			  local nStackCount = self:GetStackCount()
              self:SetStackCount(nStackCount-1)
              CustomNetTables:SetTableValue("aegis_count", tostring(self:GetParent():GetPlayerOwnerID()), {count = nStackCount-1})
		  end
	   end
	end
end