modifier_skill_retraining = class({})

function modifier_skill_retraining:IsHidden() return true end
function modifier_skill_retraining:IsPurgable() return false end
function modifier_skill_retraining:IsPurgeException() return false end
function modifier_skill_retraining:RemoveOnDeath() return false end
function modifier_skill_retraining:AllowIllusionDuplicate() return true end

function modifier_skill_retraining:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:StartIntervalThink(1)
end

function modifier_skill_retraining:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount() == 5 then
		self:SetStackCount(0)
		self:CompensateRelearnBook(self:GetParent()) 
	end
end

function modifier_skill_retraining:CompensateRelearnBook(owner_skill) 
    local dataList = {}

    for nTeamNumber, bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive then
            for _, nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do          
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                if hHero and PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED then
                    local data = {}
                    local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
                    nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
                    data.nGold = nGold
                    data.nPlayerID = nPlayerID
                    table.insert(dataList, data)
                end
            end
        end
    end

    if #dataList >= 4 then
        table.sort(dataList, function(a, b) return a.nGold > b.nGold end)
        for dat_list = 4, #dataList do
	        if dataList[dat_list] and dataList[dat_list].nPlayerID then
	        	local hHero = PlayerResource:GetSelectedHeroEntity(dataList[dat_list].nPlayerID)
	            if hHero then
	                for _, nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
	                    if nPlayerIDInTeam then
	                        local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
	                        if hHeroInTeam and hHeroInTeam == owner_skill then
								local hItem = CreateItem("item_relearn_book_lua", self:GetParent(), self:GetParent())
	        					self:GetParent():AddItem(hItem)
	        					hItem:SetPurchaseTime(0)
	                        end
	                    end
	                end
	            end
	        end
	    end
    end
end