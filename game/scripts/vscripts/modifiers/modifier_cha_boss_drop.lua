modifier_cha_boss_drop_roshan = class({})

function modifier_cha_boss_drop_roshan:IsHidden() return true end
function modifier_cha_boss_drop_roshan:IsPurgable() return false end
function modifier_cha_boss_drop_roshan:IsPurgeException() return false end

function modifier_cha_boss_drop_roshan:OnCreated()
	if not IsServer() then return end
	self.kill_10_sec = true
	self.kill_20_sec = true
	self.timer = 20
	self:StartIntervalThink(1)
end

function modifier_cha_boss_drop_roshan:OnIntervalThink()
	if not IsServer() then return end
	if self.timer > 0 then
		self.timer = self.timer - 1
	end
	if self.timer <= 10 then
		self.kill_10_sec = false
	end
	if self.timer <= 0 then
		self.kill_20_sec = false
	end
end

function modifier_cha_boss_drop_roshan:OnDeathEvent(params)
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	if params.attacker == nil then return end
	if params.attacker == self:GetParent() then return end

	if self.kill_10_sec then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 95, 3)
	end
	if self.kill_20_sec then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 65, 2)
	end

	if RollPercentage(65) then
		local allHeroes = HeroList:GetAllHeroes()
		for _, hero in pairs(allHeroes) do
	        if hero:IsRealHero() and not hero:IsIllusion() and not hero:IsTempestDouble() and not hero:HasModifier("modifier_arc_warden_tempest_double_lua") then
	        	if hero:GetTeamNumber() == params.unit.team then
	        		local neutral_item_name = ItemLoot:GetUniqueNeutralItem(5, params.unit.team )
				  	local item = DropNeutralItemAtPositionForHero(neutral_item_name, params.unit:GetAbsOrigin(), hero, -1, true )

				  	item.nItemTeamNumber = params.unit.team

					--Timers:CreateTimer(15, function()
					--    if item and (not item:IsNull()) and item.GetContainedItem and item:GetContainedItem() and item:GetContainedItem():IsNeutralDrop() then
				    --  		local hContainedItem = item:GetContainedItem()
				    --  		PlayerResource:AddNeutralItemToStash( 0, item.nItemTeamNumber, hContainedItem )
				    --  		local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/neutralitem_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil )
				    --  		ParticleManager:SetParticleControl( nFXIndex, 0, item:GetAbsOrigin() )
				    --  		ParticleManager:ReleaseParticleIndex( nFXIndex )
				    --  		EmitSoundOn( "NeutralItem.TeleportToStash", item )
				    --  		UTIL_Remove( item )
					--   	end
					--end)
	        	end
	        end
	    end
	end
end

modifier_cha_boss_drop_nian = class({})

function modifier_cha_boss_drop_nian:IsHidden() return true end
function modifier_cha_boss_drop_nian:IsPurgable() return false end
function modifier_cha_boss_drop_nian:IsPurgeException() return false end

function modifier_cha_boss_drop_nian:OnCreated(params)
	if not IsServer() then return end
	self.kill_10_sec = true
	self.kill_20_sec = true
	self.timer = 20
	self:StartIntervalThink(1)
end

function modifier_cha_boss_drop_nian:OnIntervalThink()
	if not IsServer() then return end
	if self.timer > 0 then
		self.timer = self.timer - 1
	end
	if self.timer <= 10 then
		self.kill_10_sec = false
	end
	if self.timer <= 0 then
		self.kill_20_sec = false
	end
end

function modifier_cha_boss_drop_nian:OnDeathEvent(params)
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	if params.attacker == nil then return end
	if params.attacker == self:GetParent() then return end

	if self.kill_10_sec then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 95, 3)
	end
	
	if self.kill_20_sec then
		Quests_arena:QuestProgress(params.attacker:GetPlayerOwnerID(), 65, 2)
	end

	if self.round_count and self.nian_count then
		local allHeroes = HeroList:GetAllHeroes()
	    for _, hero in pairs(allHeroes) do
	        if hero:IsRealHero() and not hero:IsIllusion() and not hero:IsTempestDouble() and not hero:HasModifier("modifier_arc_warden_tempest_double_lua") then
	        	if hero:GetTeamNumber() == params.unit.team then
	        		if self.nian_count <= 1 then
		        		--if hero:HasModifier("modifier_aegis") then
			            --   local hModifierAegis = hero:FindModifierByName("modifier_aegis")
			            --   local nCurrentStack = hModifierAegis:GetStackCount()
			            --   hModifierAegis:SetStackCount(nCurrentStack+1)
					    --else
			            --    local hModifierAegis = hero:AddNewModifier(hero, nil, "modifier_aegis", {})
			            --    hModifierAegis:SetStackCount(1)
					    --end
					    local bonus_gold = 75 * self.round_count
						hero:ModifyGold(bonus_gold, true, 0)
					else
						local bonus_gold = (self.nian_count-1) * 75 * self.round_count
						hero:ModifyGold(bonus_gold, true, 0)
					end
	        	end
	        end
	    end
	end
end