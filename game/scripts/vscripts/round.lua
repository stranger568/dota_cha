LinkLuaModifier( "modifier_creature_berserk", "creature_ability/modifier_creature_berserk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_cha_resistance", "creature_ability/modifier_creature_berserk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_berserk_debuff", "creature_ability/modifier_creature_berserk_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_win_6sec", "heroes/modifier_duel_win", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_win_15sec", "heroes/modifier_duel_win", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_vision", "heroes/modifier_duel_win", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_damage_check", "modifiers/modifier_duel_damage_check", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aegis_buff_rebirth", "modifiers/modifier_aegis_buff_rebirth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_curse", "modifiers/modifier_duel_curse", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_curse_cooldown", "modifiers/modifier_duel_curse", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_ninja_gear_custom", "items/item_ninja_gear_custom", LUA_MODIFIER_MOTION_NONE)

if Round == nil then Round = class({}) end

nBasePrepareTotalTime=15
if IsInToolsMode() then
    nBasePrepareTotalTime=8
end
nRoundLimitTime=50
if IsInToolsMode() then
    nRoundLimitTime=50
end
nRoundBaseBonus=300
_G.creeps_random_60 = {}
_G.creeps_big_random = 
{
    {
        ["UnitName"] = "npc_dota_centaur_khan",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_big_thunder_lizard",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_siltbreaker_red",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_spider_range",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_granite_golem",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_satyr_hellcaller",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_black_dragon",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_dark_troll_warlord",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_dark_troll",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_roshling_big",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_polar_furbolg_ursa_warrior",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_prowler_shaman",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
    {
        ["UnitName"] = "npc_dota_enraged_wildkin",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.3,
    },
}
_G.creeps_small_random = 
{
    {
        ["UnitName"] = "npc_dota_timber_spider",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_satyr_trickster",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_warpine_cone_custom",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_elf_wolf",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_explode_spider",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
}

_G.creeps_small_random_special = 
{
    {
        ["UnitName"] = "npc_dota_ogre_warlord",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_black_dragon",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_frostbitten_gaint",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_mud_golem",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_ogreseal_big",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_ogre_warlord",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_black_dragon",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_frostbitten_gaint",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_mud_golem",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_ogreseal_big",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_ogre_warlord",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_black_dragon",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_frostbitten_gaint",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_mud_golem",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
    {
        ["UnitName"] = "npc_dota_ogreseal_big",
        ["UnitNumber"] = 1,
        ["SpawnInterval"] = 0.1,
    },
}

local big_ra = table.random_some(creeps_big_random, 2)
local small_ra = table.random_some(creeps_small_random, 5)
creeps_random_60=table.join(creeps_random_60,big_ra)
creeps_random_60=table.join(creeps_random_60,small_ra)

compensateRoundNumber = {}

if GetMapName() == "1x8_old" then
    compensateRoundNumber[10]=true
    compensateRoundNumber[20]=true
    compensateRoundNumber[30]=true
    compensateRoundNumber[40]=true   
else
    compensateRoundNumber[10]=true
    compensateRoundNumber[20]=true
    compensateRoundNumber[30]=true
    compensateRoundNumber[40]=true
    compensateRoundNumber[50]=true    
end

if IsInToolsMode() then

end

abilitySelectionRoundNumber = {}
abilitySelectionRoundNumber[3]=true
abilitySelectionRoundNumber[6]=true
abilitySelectionRoundNumber[9]=true

SkillRoundNumber = {}
SkillRoundNumber[11]=true
SkillRoundNumber[21]=true
SkillRoundNumber[31]=true
SkillRoundNumber[41]=true
SkillRoundNumber[51]=true
SkillRoundNumber[71]=true

if IsInToolsMode() then
    abilitySelectionRoundNumber = {}
    abilitySelectionRoundNumber[2]=true
    abilitySelectionRoundNumber[3]=true
    abilitySelectionRoundNumber[4]=true
    --SkillRoundNumber = {}
    --SkillRoundNumber[1]=true
    --SkillRoundNumber[2]=true
    --SkillRoundNumber[3]=true
    --SkillRoundNumber[4]=true
    --SkillRoundNumber[5]=true
end

function Round:Prepare(nRoundNumber, bonus_time)
    self.spanwers={}
    self.bEnd = false
    self.nCreatureNumber = 0
    self.nRoundNumber=nRoundNumber
    
    if nRoundNumber >= 1 then
        GameRules:SetSafeToLeave(true)
    end

    if GetMapName() == "1x8_pve" then
        if nRoundNumber > 500 then
            ChaServerData.PostDataPVE()
            return
        end
    end

    self.nPlayerRank = 0
    self.nPrepareTotalTime = nBasePrepareTotalTime
    if bonus_time then
        self.nPrepareTotalTime = nBasePrepareTotalTime + bonus_time
    end
    self.readyPlayers = {}

    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive then
            for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
                    self.readyPlayers[nPlayerID] = false
                end
            end
        end
    end

    if abilitySelectionRoundNumber[nRoundNumber] then
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
            HeroBuilder.totalAbilityNumber[nPlayerID] = HeroBuilder.totalAbilityNumber[nPlayerID]+1
        end
        if IsInToolsMode() then
            self.nPrepareTotalTime = nBasePrepareTotalTime + 1
        else
            self.nPrepareTotalTime = nBasePrepareTotalTime + 15
        end
    end

    if SkillRoundNumber[nRoundNumber] then
        if IsInToolsMode() then
            self.nPrepareTotalTime = nBasePrepareTotalTime + 1
        else
            self.nPrepareTotalTime = nBasePrepareTotalTime + 15
        end
    end
    
    self.nAliveTeamNumber = 0 

    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive then
            self.nAliveTeamNumber = self.nAliveTeamNumber+1
        
            if abilitySelectionRoundNumber[nRoundNumber] then
                for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                    HeroBuilder:ShowRandomAbilitySelection(nPlayerID)
                end
            end

            if SkillRoundNumber[nRoundNumber] then
                for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                    local tier = 1
                    if nRoundNumber == 11 or (IsInToolsMode() and nRoundNumber == 1) then
                        tier = 1
                    elseif nRoundNumber == 21 then
                        tier = 2
                    elseif nRoundNumber == 31 then
                        tier = 3
                    elseif nRoundNumber == 41 then
                        tier = 4
                    elseif nRoundNumber == 51 then
                        tier = 5
                    elseif nRoundNumber == 71 then
                        tier = 5
                    end
                    Skills:CreateRandomSkillsForPlayer(nPlayerID, tier)
                end
            end
        end
    end

    if GetMapName()=="2x6" then
        nRoundBaseBonus = 320
    end

    if GetMapName()=="5v5" then
        nRoundBaseBonus = 350
    end
    
    if tonumber(nRoundNumber) < 65 then
        self.flBonus = nRoundBaseBonus * math.pow(1.031, (tonumber(nRoundNumber)-1))
    else
        self.flBonus = nRoundBaseBonus * math.pow(1.031, 65)
    end
    
    local nPhase = math.ceil(nRoundNumber / 10)

    if GameMode.vRoundList[nPhase] == nil then
        local nRandomPhase = RandomInt(5, 49)
        GameMode.vRoundList[nPhase] = table.deepcopy(GameMode.vRoundListFull[nRandomPhase])
    end

    ------------------------чистка раундов с рошаном и нианом---------------------------

    local phase_has_roshan = false
    local phase_has_nian = false

    for i,v in ipairs(GameMode.vRoundList[nPhase]) do
        if v == "Round_Roshan" then
            phase_has_roshan = true
        end
        if v == "Round_Nian" then
            phase_has_nian = true
        end
    end

    if phase_has_roshan and phase_has_nian then
        if RollPercentage(50) then
            for i,v in ipairs(GameMode.vRoundList[nPhase]) do
                if v == "Round_Roshan" then
                    table.remove(GameMode.vRoundList[nPhase], i)
                end
            end
        else
            for i,v in ipairs(GameMode.vRoundList[nPhase]) do
                if v == "Round_Nian" then
                    table.remove(GameMode.vRoundList[nPhase], i)
                end
            end
        end

        local bonus_random = 
        {
            "Round_Skeleton",
            "Round_Kobold",
            "Round_Troll",
            "Round_Troll_And_Kobold",
            "Round_Gnoll_Assassin",
            "Round_Ghost",
            "Round_Harpy",
            "Round_Crocodilian",
            "Round_Chameleon",
            "Round_Greevil",
            "Round_Centaur",
            "Round_Wolf",
            "Round_Satyr",
            "Round_Ogre",
            "Round_Golem",
            "Round_Centaur_Big",
            "Round_Satyr_Big",
            "Round_Hellbear",
            "Round_Wild",
            "Round_Dark_Troll",
            "Round_Ogreseal",
            "Round_Ogre_Warlord",
            "Round_Explode_Spider",
            "Round_Elf_Wolf",
            "Round_warpine",
            "Round_Roshling",
            "Round_Dragon",
            "Round_Large_Golem",
            "Round_Thunder_Lizard",
            "Round_Prowler",
            "Round_Frostbitten",
            "Round_Spider",
            "Round_Siltbreaker",
            "Round_Timber_Spider",
        }

        for d, l in pairs(bonus_random) do
            for i,v in ipairs(GameMode.vRoundList[nPhase]) do
                if l == v then
                    table.remove(bonus_random, d)
                end
            end
        end

        table.insert(GameMode.vRoundList[nPhase], bonus_random[RandomInt(1, #bonus_random)])
    end
    
    ----------------------------------------------------------------

    if GameMode.vRoundList[nPhase] and #GameMode.vRoundList[nPhase] <= 0 then
       local bonus_random = 
        {
            "Round_Skeleton",
            "Round_Kobold",
            "Round_Troll",
            "Round_Troll_And_Kobold",
            "Round_Gnoll_Assassin",
            "Round_Ghost",
            "Round_Harpy",
            "Round_Crocodilian",
            "Round_Chameleon",
            "Round_Greevil",
            "Round_Centaur",
            "Round_Wolf",
            "Round_Satyr",
            "Round_Ogre",
            "Round_Golem",
            "Round_Centaur_Big",
            "Round_Satyr_Big",
            "Round_Hellbear",
            "Round_Wild",
            "Round_Dark_Troll",
            "Round_Ogreseal",
            "Round_Ogre_Warlord",
            "Round_Explode_Spider",
            "Round_Elf_Wolf",
            "Round_warpine",
            "Round_Roshling",
            "Round_Dragon",
            "Round_Large_Golem",
            "Round_Thunder_Lizard",
            "Round_Prowler",
            "Round_Frostbitten",
            "Round_Spider",
            "Round_Siltbreaker",
            "Round_Timber_Spider",
        }

        table.insert(GameMode.vRoundList[nPhase], bonus_random[RandomInt(1, #bonus_random)])
    end

    self.sRoundName = table.random(GameMode.vRoundList[nPhase])

    --------------------------Дополнительный фикс на всякий случай -----------------

    if self.sRoundName == nil then
        local bonus_random = 
        {
            "Round_Skeleton",
            "Round_Kobold",
            "Round_Troll",
            "Round_Troll_And_Kobold",
            "Round_Gnoll_Assassin",
            "Round_Ghost",
            "Round_Harpy",
            "Round_Crocodilian",
            "Round_Chameleon",
            "Round_Greevil",
            "Round_Centaur",
            "Round_Wolf",
            "Round_Satyr",
            "Round_Ogre",
            "Round_Golem",
            "Round_Centaur_Big",
            "Round_Satyr_Big",
            "Round_Hellbear",
            "Round_Wild",
            "Round_Dark_Troll",
            "Round_Ogreseal",
            "Round_Ogre_Warlord",
            "Round_Explode_Spider",
            "Round_Elf_Wolf",
            "Round_warpine",
            "Round_Roshling",
            "Round_Dragon",
            "Round_Large_Golem",
            "Round_Thunder_Lizard",
            "Round_Prowler",
            "Round_Frostbitten",
            "Round_Spider",
            "Round_Siltbreaker",
            "Round_Timber_Spider",
        }
        self.sRoundName = bonus_random[RandomInt(1, #bonus_random)]
    end

    ---- CREEP WAVE 60 --------------------------------------------
    if nRoundNumber == 51 and GetMapName() ~= "1x8_old" then
        self.sRoundName = "Round_RandomCreeps"
    end
    ----------------------------------------------------------------

    for i,v in ipairs(GameMode.vRoundList[nPhase]) do
        if v == self.sRoundName then
            table.remove(GameMode.vRoundList[nPhase], i)
        end
    end

    for k,vData in pairs(GameMode.vRoundData[self.sRoundName]) do
        self.nCreatureNumber = tonumber(vData.UnitNumber) +self.nCreatureNumber
    end
    
    ------------- Boss WAVE -----------
    ---------------------------------------------------------------
    if self.sRoundName == "Round_RandomCreeps" then
        if GameMode.vRoundData["Round_RandomCreeps"] == nil then
            GameMode.vRoundData["Round_RandomCreeps"] = {}
        end
        if nRoundNumber <= 100 and nRoundNumber >= 61 then
            local big_ra = table.random_some(creeps_big_random, 1)
            creeps_random_60=table.join(creeps_random_60,big_ra)
            table.remove_item(creeps_big_random,big_ra)

            local small_ra_full = table.random_some(creeps_small_random_special, 1)
            creeps_random_60=table.join(creeps_random_60,small_ra_full)
            table.remove_item(creeps_small_random_special,small_ra_full)

            if RollPercentage(50) then
                local small_ra = table.random_some(creeps_small_random_special, 1)
                creeps_random_60=table.join(creeps_random_60,small_ra)
                table.remove_item(creeps_small_random_special,small_ra)
            end
        end

        GameMode.vRoundData["Round_RandomCreeps"] = creeps_random_60
        self.nCreatureNumber = #creeps_random_60
    end

    if self.sRoundName == "Round_Nian" then
        GameRules.nian_count = GameRules.nian_count + 1
    end

    self.flExpMulti = 1 
    
    if GetMapName()=="2x6" then
       self.flExpMulti = 2
    end

    if GetMapName()=="5v5" then
       self.flExpMulti = 5
    end

    if self.nRoundNumber - PvpModule.nLastPvpRound >= PvpModule.nInterval then
       if self.sRoundName~="Round_Roshan" and self.sRoundName~="Round_Nian" and self.sRoundName~="Round_RandomCreeps" then
            if string.find(GetMapName(),"1x8") then
                self.nPrepareTotalTime = self.nPrepareTotalTime + 2
            end
            if GetMapName()=="2x6" then
                self.nPrepareTotalTime = self.nPrepareTotalTime + 5
            end
            PvpModule:RoundPrepare(self.nRoundNumber)
        end
    end

    if self.nRoundNumber>=40 then
       self.nPrepareTotalTime  = self.nPrepareTotalTime +2
    end

    if self.nRoundNumber>=50 then
       self.nPrepareTotalTime  = self.nPrepareTotalTime +2
    end
    
    if self.nRoundNumber>=60 then
       self.nPrepareTotalTime  = self.nPrepareTotalTime +2
    end

    self.nPrepareTime = 0

    CustomGameEventManager:Send_ServerToAllClients("RefreshPrepare", { name = "RoundPrepare", text = "#round_prepare", svalue = 0, evalue = self.nPrepareTotalTime, text_value=self.nRoundNumber, text_value_2="#"..self.sRoundName, abilities = GameMode.vRoundDataAbilities[self.sRoundName] })
    CustomGameEventManager:Send_ServerToAllClients("UpdateReadyButton", {visible=true})
    CustomGameEventManager:RegisterListener("PlayerReady",function(_, keys) self:PlayerReady(keys) end)

    Timers:CreateTimer(1, function()
        self.nPrepareTime = self.nPrepareTime+1
        CustomGameEventManager:Send_ServerToAllClients("RefreshPrepare", { name = "RoundPrepare", text = "#round_prepare", svalue =self.nPrepareTime, evalue = self.nPrepareTotalTime, text_value=self.nRoundNumber,text_value_2="#"..self.sRoundName })
        CustomGameEventManager:Send_ServerToAllClients("UpdateConfirmButton", { currentTime =self.nPrepareTime, totalTime = self.nPrepareTotalTime })
           
        if self.bEnd then
            return nil
        end

        local bAllReady = true
           
        for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
            if bAlive then
                for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                    if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                        if false==self.readyPlayers[nPlayerID] then
                            bAllReady = false
                        end
                    end
                end
            end
        end

        if bAllReady or (self.nPrepareTime >= self.nPrepareTotalTime) then
            xpcall(function()
                self:Begin()
        end,
            function(e)
                  print(e)
            end)        
            return nil
        else
            return 1
        end
    end)
end

function Round:Begin()
    if self.nRoundNumber==1 then
        HeroBuilder:ForceFinishHeroBuild()
    end

    self.nTimeLimit = nRoundLimitTime
    self.berserk_stack = 0

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
        if PlayerResource:IsValidPlayer(nPlayerID) then
            local hPlayer = PlayerResource:GetPlayer(nPlayerID)
            if hPlayer then
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "HidePvpBet", {})
            end
        end
    end

    CustomGameEventManager:Send_ServerToAllClients("ResetPlayerReadyList", {})
    PvpModule:SummarizeBetInfo()
    CustomGameEventManager:Send_ServerToAllClients("UpdateReadyButton", {visible=false})

    local spawn_coin = true 

    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive==true then
            local bTeamPvpFlag = false 
            for nPlayerIndex,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                if ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID] then
                    ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage = {}
                    CustomNetTables:SetTableValue("spell_damage", tostring(nPlayerID), ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage)
                    ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage_income = {}
                    CustomNetTables:SetTableValue("spell_damage_income", tostring(nPlayerID), ChaServerData.PLAYERS_GLOBAL_INFORMATION[nPlayerID].spell_damage)
                    CustomGameEventManager:Send_ServerToAllClients( "remove_damage_units", {} )
                end

                local bPlayerPvpFlag = false
                local vCenter = GameMode.vTeamLocationMap[nTeamNumber]
                local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)  

                if hHero:HasModifier("modifier_skill_overclocking") then
                    local modifier_skill_overclocking = hHero:FindModifierByName("modifier_skill_overclocking")
                    if modifier_skill_overclocking then
                        modifier_skill_overclocking:SetStackCount(0)
                    end
                end

                if hHero:HasModifier("modifier_skill_smoker") then
                    hHero:AddNewModifier(hHero, nil, "modifier_ninja_gear_custom", {duration = 5})
                    if hHero.tempest_double_hClone and not hHero.tempest_double_hClone:IsNull() and hHero.tempest_double_hClone:IsAlive() then
                        hHero.tempest_double_hClone:AddNewModifier(hHero, nil, "modifier_ninja_gear_custom", {duration = 5})
                    end
                end

                hHero:RemoveModifierByName("modifier_duel_damage_check")

                if self.nRoundNumber == 50 then
                    GameRules:IncreaseItemStock(hHero:GetTeamNumber(), "item_reroll_neutral_book", 1, hHero:GetPlayerID())
                end
             
                for i,pvpTeamID in ipairs(PvpModule.currentPair) do
                    if pvpTeamID == nTeamNumber then

                        vCenter = PvpModule.vHomeCenter - Vector( (3-i*2)*550,0,0)

                        if spawn_coin and GetMapName() ~= "1x8_old" then
                            spawn_coin = false
                            local newItem = CreateItem( "item_bag_of_gold", nil, nil )
                            local drop = CreateItemOnPositionForLaunch( PvpModule.vHomeCenter, newItem )
                            newItem:LaunchLootInitialHeight( false, 0, 200, 0.25, PvpModule.vHomeCenter )
                        end

                        if GetMapName()=="2x6" then
                            vCenter = vCenter + Vector(0,(3-nPlayerIndex*2)*350,0)
                        end

                        if GetMapName()=="5v5" then
                            local wayPoint = Entities:FindByName(nil, "center_pvp_"..nTeamNumber)
                            vCenter = wayPoint:GetOrigin()+RandomVector(300)
                        end

                        bTeamPvpFlag =true
                        bPlayerPvpFlag= true
                   
                        local nPvpParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_start_ring_arcana.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControl(nPvpParticle, 0, vCenter)  
                        ParticleManager:SetParticleControl(nPvpParticle, 7, vCenter)  
                        Timers:CreateTimer({ endTime = 1, callback = function()
                            ParticleManager:DestroyParticle(nPvpParticle, false)
                            ParticleManager:ReleaseParticleIndex(nPvpParticle)
                        end})
                   
                        hHero.bJoiningPvp = true
                        hHero:AddNewModifier(hHero, nil, "modifier_duel_win_6sec", {duration = 6})
                        hHero:AddNewModifier(hHero, nil, "modifier_duel_win_15sec", {duration = 15})
                        hHero:AddNewModifier(hHero, nil, "modifier_duel_damage_check", {})
                        hHero:RemoveModifierByName("modifier_skill_last_chance_cooldown")
                        hHero:RemoveModifierByName("modifier_skill_second_life_cooldown")

                        EmitSoundOn("Hero_LegionCommander.Duel",hHero)

                        Timers:CreateTimer({ endTime = 1.5, callback = function()
                            StopSoundOn("Hero_LegionCommander.Duel",hHero)
                        end})
                    end
                end

                for i,nPvpPlayerID in ipairs(PvpModule.currentSinglePair) do
                    if nPvpPlayerID == nPlayerID then
                    local nTeamNumber = PlayerResource:GetTeam(nPvpPlayerID)
                    local wayPoint = Entities:FindByName(nil, "center_single_pvp")
                    vCenter = wayPoint:GetOrigin() - Vector( (5-nTeamNumber*2)*550,0,0)

                    bPlayerPvpFlag= true      
                               
                    local nPvpParticle = ParticleManager:CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_start_ring_arcana.vpcf", PATTACH_CUSTOMORIGIN, nil)
                    ParticleManager:SetParticleControl(nPvpParticle, 0, vCenter)  
                    ParticleManager:SetParticleControl(nPvpParticle, 7, vCenter)  
                    Timers:CreateTimer({ endTime = 1, callback = function()
                            ParticleManager:DestroyParticle(nPvpParticle, false)
                            ParticleManager:ReleaseParticleIndex(nPvpParticle)
                        end
                    })
                   
                    hHero.bJoiningPvp = true
                    hHero:RemoveModifierByName("modifier_skill_last_chance_cooldown")
                    hHero:RemoveModifierByName("modifier_skill_second_life_cooldown")
                    EmitSoundOn("Hero_LegionCommander.Duel",hHero)
                    Timers:CreateTimer({ endTime = 1.5, callback = function()
                        StopSoundOn("Hero_LegionCommander.Duel",hHero)
                        end
                    })
                    end
                end

                 
                if hPlayer and (not bPlayerPvpFlag) and (not PvpModule.bEnd) then
                
                    hHero.bJoiningPvp = false
                
                    local dataList={}
                    local firstTeamId
                    local secondTeamId

                    for nTempPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                        if PlayerResource:IsValidPlayer(nTempPlayerID) and (PlayerResource:GetTeam( nTempPlayerID ) == PvpModule.currentPair[1] or PlayerResource:GetTeam( nTempPlayerID )==PvpModule.currentPair[2]) then
                            local data = {}
                            data.playerID = nTempPlayerID
                            data.teamID = PlayerResource:GetTeam( nTempPlayerID )
                            table.insert(dataList, data)
                            firstTeamId = PvpModule.currentPair[1]
                            secondTeamId = PvpModule.currentPair[2]
                        end
                    end

                    for nTempPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                        if PlayerResource:IsValidPlayer(nTempPlayerID) and (nTempPlayerID == PvpModule.currentSinglePair[1] or nTempPlayerID ==PvpModule.currentSinglePair[2]) then
                            local data = {}
                            data.playerID = nTempPlayerID
                            data.teamID = PlayerResource:GetTeam( nTempPlayerID )
                            table.insert(dataList, data)
                            firstTeamId = PlayerResource:GetTeam(PvpModule.currentSinglePair[1])
                            secondTeamId = PlayerResource:GetTeam(PvpModule.currentSinglePair[2])
                        end
                    end

                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBrief", {players=dataList,firstTeamId=firstTeamId,secondTeamId=secondTeamId, betMap=PvpModule.betMap, bonusPool=math.floor(PvpModule.nBetBonus) })
                end

                if hHero:HasModifier("modifier_skill_rebirth") and not bTeamPvpFlag and not bPlayerPvpFlag then
                    hHero:AddNewModifier(hHero, nil, "modifier_aegis_buff_rebirth", {duration = 10})
                end

                hHero:RemoveModifierByName("modifier_hero_refreshing")
                Util:MoveHeroToLocation( nPlayerID,vCenter )
            end
          
            if not bTeamPvpFlag then
                self.spanwers[nTeamNumber] = Spawner()
                self.spanwers[nTeamNumber]:Init(nTeamNumber,self)
                CustomNetTables:SetTableValue( "spawner_info",tostring(nTeamNumber),{})
            end
        end
       
        if false == bAlive then
            local dataList={}
            for nTempPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                if PlayerResource:IsValidPlayer(nTempPlayerID) and (PlayerResource:GetTeam( nTempPlayerID ) == PvpModule.currentPair[1] or PlayerResource:GetTeam( nTempPlayerID )==PvpModule.currentPair[2]) then
                    local data = {}
                    data.playerID = nTempPlayerID
                    data.teamID = PlayerResource:GetTeam( nTempPlayerID )
                    table.insert(dataList, data)
                end
            end
            for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                if hPlayer and PlayerResource:IsValidPlayer(nPlayerID) then
                    CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ShowPvpBrief", {players=dataList,firstTeamId=PvpModule.currentPair[1],secondTeamId=PvpModule.currentPair[2], betMap=PvpModule.betMap, bonusPool=math.floor(PvpModule.nBetBonus) })
                end
            end
        end
    end

    CustomGameEventManager:Send_ServerToAllClients("UpdateRoundTimer", { name = "RoundTimeLimit", text = "#round_time_limit", svalue = nRoundLimitTime, evalue = nRoundLimitTime, text_value=self.nRoundNumber })
    
    Timers:CreateTimer(1, function()
        if true == self.bEnd then return nil end 

          local bResult,nResult=xpcall(function()
            local max_health = 0
            local damage_one = 0
            local damage_two = 0
            local hero_1_name = ""
            local hero_2_name = ""

            for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
                local bTeamPvpFlag = false 
                for nPlayerIndex,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                    local bPlayerPvpFlag = false
                    local vCenter = GameMode.vTeamLocationMap[nTeamNumber]
                    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
                    local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)  

                    for i,pvpTeamID in ipairs(PvpModule.currentPair) do
                        if pvpTeamID == nTeamNumber then
                            if hHero and not hHero:IsNull() then
                                hHero:AddNewModifier(hHero, nil, "modifier_duel_vision", {duration = 2})
                            end
                        end
                    end

                    for i,nPvpPlayerID in ipairs(PvpModule.currentSinglePair) do
                        if nPvpPlayerID == nPlayerID then
                            local nTeamNumber = PlayerResource:GetTeam(nPvpPlayerID)
                            if hHero and not hHero:IsNull() then
                                hHero:AddNewModifier(hHero, nil, "modifier_duel_vision", {duration = 2})
                            end
                        end
                    end

                    if PvpModule.currentSinglePair[1] then
                        if PvpModule.currentSinglePair[1] == nPlayerID then
                            if hHero and not hHero:IsNull() then
                                max_health = max_health + hHero:GetMaxHealth()
                                local modifier_duel_damage_check = hHero:FindModifierByName("modifier_duel_damage_check")
                                if modifier_duel_damage_check then
                                    damage_one = modifier_duel_damage_check:GetStackCount()
                                end
                                hero_1_name = hHero:GetUnitName()
                            end
                        end
                    end

                    if PvpModule.currentSinglePair[2] then
                        if PvpModule.currentSinglePair[2] == nPlayerID then
                            if hHero and not hHero:IsNull() then
                                max_health = max_health + hHero:GetMaxHealth()
                                local modifier_duel_damage_check = hHero:FindModifierByName("modifier_duel_damage_check")
                                if modifier_duel_damage_check then
                                    damage_two = modifier_duel_damage_check:GetStackCount()
                                end
                                hero_2_name = hHero:GetUnitName()
                            end
                        end
                    end

                    if PvpModule.currentPair[1] then
                        if PvpModule.currentPair[1] == nTeamNumber then
                            if hHero and not hHero:IsNull() then
                                max_health = max_health + hHero:GetMaxHealth()
                                local modifier_duel_damage_check = hHero:FindModifierByName("modifier_duel_damage_check")
                                if modifier_duel_damage_check then
                                    damage_one = modifier_duel_damage_check:GetStackCount()
                                end
                                hero_2_name = hHero:GetUnitName()
                            end
                        end
                    end

                    if PvpModule.currentPair[2] then
                        if PvpModule.currentPair[2] == nTeamNumber then
                            if hHero and not hHero:IsNull() then
                                max_health = max_health + hHero:GetMaxHealth()
                                local modifier_duel_damage_check = hHero:FindModifierByName("modifier_duel_damage_check")
                                if modifier_duel_damage_check then
                                    damage_two = modifier_duel_damage_check:GetStackCount()
                                end
                                hero_1_name = hHero:GetUnitName()
                            end
                        end
                    end

                    CustomGameEventManager:Send_ServerToAllClients("UpdateTopInfo", {full_hp = max_health, hero_1_hp = damage_two, hero_2_hp = damage_one, hero_1_name = hero_1_name, hero_2_name = hero_2_name})
                end
            end

            for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
                if bAlive then
                    local bTeamAlive = false
                    for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
                        local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                        if hHero:IsAlive() or hHero:IsReincarnating() then
                            hHero.nDeathTime =0
                            bTeamAlive=true
                        else
                            if hHero.nDeathTime == nil then
                                hHero.nDeathTime =0 
                            end
                             hHero.nDeathTime = hHero.nDeathTime+1
                        end
                        if hHero.nDeathTime<=6 then
                            bTeamAlive=true
                        end
                    end
                  
                    if bTeamAlive==false then
                        GameMode:TeamLose(nTeamNumber)
                    end
                end
            end

            local bAllTeamFinish =  true
            local bNoAliveTeam = true

            for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
                if bAlive then
                    bNoAliveTeam = false
                    if self.spanwers[nTeamNumber] and self.spanwers[nTeamNumber].bProgressFinished==false then
                        bAllTeamFinish=false
                    end
                  
                    if PvpModule.bEnd==false then
                        bAllTeamFinish=false
                    end
                end
            end
           
            if bAllTeamFinish then
                GameMode:FinishRound()
                return nil
            end

            self.nTimeLimit = self.nTimeLimit - 1

            if self.nTimeLimit > 0 then
                CustomGameEventManager:Send_ServerToAllClients("UpdateRoundTimer", { name = "RoundTimeLimit", text = "#round_time_limit", svalue =self.nTimeLimit, evalue = nRoundLimitTime,text_value=self.nRoundNumber })
            end

          
            if self.nTimeLimit<=0 then
                self:RoundTimeOver()
            end

            if self.nTimeLimit < 0 then
                self:RoundTimeExceeded()
            elseif self.nTimeLimit - 5 < 0 then
                self:RoundTimeStartCooldownDuel()
            end

            return 1
        end,
            function(e)
            print(e)
        end)         

        if bResult then
            return nResult
        else
            return 1
        end
    end)  
end

function Round:RoundTimeOver()
   for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive==true then
            if  self.spanwers[nTeamNumber] and self.spanwers[nTeamNumber].bProgressFinished==false then
                for i, hCreep in ipairs( self.spanwers[nTeamNumber].vCurrentCreeps ) do
                    if hCreep and (not hCreep:IsNull()) and hCreep:IsAlive() then
                        hCreep:AddNewModifier(hCreep, nil, "modifier_creature_berserk", {})
                        if self.nRoundNumber >= 70 then
                            hCreep:AddNewModifier(hCreep, nil, "modifier_creep_cha_resistance", {})
                        end
                    end
                end            
            end
        end
    end
    self.berserk_stack = self.berserk_stack + 1
    CustomGameEventManager:Send_ServerToAllClients("UpdateRoundTimer", { name = "RoundTimeLimit", text = "#round_time_expire", svalue = 0, evalue = nRoundLimitTime, berserk = self.berserk_stack })
end

function Round:RoundTimeExceededOldCHC()
    if PvpModule.bEnd == false and PvpModule.currentPair[1] and PvpModule.currentPair[2]  then
        local nTeamID1 = PvpModule.currentPair[1]
        local nTeamID2 = PvpModule.currentPair[2]
        local flPercentage1 = 0
        local flTotalHeath1 = 0

        for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID1) do
            local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID1, i)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if hHero then
                flPercentage1 =  flPercentage1 + hHero:GetHealthPercent()
                flTotalHeath1 =  flTotalHeath1 + hHero:GetHealth()
            end
        end

        local flPercentage2 = 0
        local flTotalHeath2 = 0
        for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID2) do
            local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID2, i)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if hHero then
                flPercentage2 =  flPercentage2 + hHero:GetHealthPercent()
                flTotalHeath2 =  flTotalHeath2 + hHero:GetHealth()
            end
        end
  
        if flPercentage1==flPercentage2 then
            if flTotalHeath1>flTotalHeath2 then
                PvpModule:EndPvp(nTeamID1,nTeamID2)
            else
                PvpModule:EndPvp(nTeamID2,nTeamID1)
            end
        else
            if flPercentage1>flPercentage2 then
                PvpModule:EndPvp(nTeamID1,nTeamID2)
            else
                PvpModule:EndPvp(nTeamID2,nTeamID1)
            end
        end
    end

    if PvpModule.bEnd == false and PvpModule.currentSinglePair[1] and PvpModule.currentSinglePair[2]  then
        local nPlayerID1 = PvpModule.currentSinglePair[1]
        local nPlayerID2 = PvpModule.currentSinglePair[2]
        local flPercentage1 = 0
        local flHeath1 = 0

        local hHero1 = PlayerResource:GetSelectedHeroEntity(nPlayerID1)
        if hHero1 then
            flPercentage1 =   hHero1:GetHealthPercent()
            flHeath1 =   hHero1:GetHealth()
        end
        local flPercentage2 = 0
        local flHeath2 = 0

        local hHero2 = PlayerResource:GetSelectedHeroEntity(nPlayerID2)
        if hHero2 then
            flPercentage2 =   hHero2:GetHealthPercent()
            flHeath2 =   hHero2:GetHealth()
        end

        if flPercentage1==flPercentage2 then
            if flHeath1>flHeath2 then
                PvpModule:EndSinglePvp(nPlayerID1,nPlayerID2)
            else
                PvpModule:EndSinglePvp(nPlayerID2,nPlayerID1)
            end
        else
            if flPercentage1>flPercentage2 then
                PvpModule:EndSinglePvp(nPlayerID1,nPlayerID2)
            else
                PvpModule:EndSinglePvp(nPlayerID2,nPlayerID1)
            end
        end
    end
 end

function Round:RoundTimeExceeded()
    if GetMapName() == "1x8_old" then
        Round:RoundTimeExceededOldCHC()
    else
        if PvpModule.bEnd == false and PvpModule.currentPair[1] and PvpModule.currentPair[2]  then
            local nTeamID1 = PvpModule.currentPair[1]
            local nTeamID2 = PvpModule.currentPair[2]
            
            for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID1) do
                local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID1, i)
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                if GetMapName() ~= "1x8_old" then
                    if hHero and hHero:IsAlive() then
                        hHero:AddNewModifier(hHero, nil, "modifier_duel_curse", {})
                        for _, summon in pairs(Round:FindAllOwnedUnits(hHero:GetPlayerID())) do
                            summon:AddNewModifier(hHero, nil, "modifier_duel_curse", {})
                        end
                    end
                end
            end

            for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID2) do
                local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID2, i)
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                if GetMapName() ~= "1x8_old" then
                    if hHero and hHero:IsAlive() then
                        hHero:AddNewModifier(hHero, nil, "modifier_duel_curse", {})
                        for _, summon in pairs(Round:FindAllOwnedUnits(hHero:GetPlayerID())) do
                            summon:AddNewModifier(hHero, nil, "modifier_duel_curse", {})
                        end
                    end
                end
            end
        end

        if PvpModule.bEnd == false and PvpModule.currentSinglePair[1] and PvpModule.currentSinglePair[2]  then
            local nPlayerID1 = PvpModule.currentSinglePair[1]
            local nPlayerID2 = PvpModule.currentSinglePair[2]
            local flPercentage1 = 0
            local flHeath1 = 0

            local hHero1 = PlayerResource:GetSelectedHeroEntity(nPlayerID1)
            if hHero1 and hHero1:IsAlive() then
                if GetMapName() ~= "1x8_old" then
                    hHero1:AddNewModifier(hHero1, nil, "modifier_duel_curse", {})
                    for _, summon in pairs(Round:FindAllOwnedUnits(hHero1:GetPlayerID())) do
                        summon:AddNewModifier(hHero1, nil, "modifier_duel_curse", {})
                    end
                end
            end

            local hHero2 = PlayerResource:GetSelectedHeroEntity(nPlayerID2)
            if hHero2 and hHero2:IsAlive() then
                if GetMapName() ~= "1x8_old" then
                    hHero2:AddNewModifier(hHero2, nil, "modifier_duel_curse", {})
                    for _, summon in pairs(Round:FindAllOwnedUnits(hHero2:GetPlayerID())) do
                        summon:AddNewModifier(hHero2, nil, "modifier_duel_curse", {})
                    end
                end
            end
        end
    end
end

function Round:RoundTimeStartCooldownDuel()
    if PvpModule.bEnd == false and PvpModule.currentPair[1] and PvpModule.currentPair[2]  then
        local nTeamID1 = PvpModule.currentPair[1]
        local nTeamID2 = PvpModule.currentPair[2]
        
        for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID1) do
            local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID1, i)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if GetMapName() ~= "1x8_old" then
                if hHero and hHero:IsAlive() then
                    hHero:AddNewModifier(hHero, nil, "modifier_duel_curse_cooldown", {})
                    for _, summon in pairs(Round:FindAllOwnedUnits(hHero:GetPlayerID())) do
                        summon:AddNewModifier(hHero, nil, "modifier_duel_curse_cooldown", {})
                    end
                end
            end
        end

        for i=1,PlayerResource:GetPlayerCountForTeam(nTeamID2) do
            local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam(nTeamID2, i)
            local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
            if GetMapName() ~= "1x8_old" then
                if hHero and hHero:IsAlive() then
                    hHero:AddNewModifier(hHero, nil, "modifier_duel_curse_cooldown", {})
                    for _, summon in pairs(Round:FindAllOwnedUnits(hHero:GetPlayerID())) do
                        summon:AddNewModifier(hHero, nil, "modifier_duel_curse_cooldown", {})
                    end
                end
            end
        end
    end

    if PvpModule.bEnd == false and PvpModule.currentSinglePair[1] and PvpModule.currentSinglePair[2]  then
        local nPlayerID1 = PvpModule.currentSinglePair[1]
        local nPlayerID2 = PvpModule.currentSinglePair[2]
        local flPercentage1 = 0
        local flHeath1 = 0

        local hHero1 = PlayerResource:GetSelectedHeroEntity(nPlayerID1)
        if hHero1 and hHero1:IsAlive() then
            if GetMapName() ~= "1x8_old" then
                hHero1:AddNewModifier(hHero1, nil, "modifier_duel_curse_cooldown", {})
                for _, summon in pairs(Round:FindAllOwnedUnits(hHero1:GetPlayerID())) do
                    summon:AddNewModifier(hHero1, nil, "modifier_duel_curse_cooldown", {})
                end
            end
        end

        local hHero2 = PlayerResource:GetSelectedHeroEntity(nPlayerID2)
        if hHero2 and hHero2:IsAlive() then
            if GetMapName() ~= "1x8_old" then
                hHero2:AddNewModifier(hHero2, nil, "modifier_duel_curse_cooldown", {})
                for _, summon in pairs(Round:FindAllOwnedUnits(hHero2:GetPlayerID())) do
                    summon:AddNewModifier(hHero2, nil, "modifier_duel_curse_cooldown", {})
                end
            end
        end
    end
end

function Round:FindAllOwnedUnits(player)
    local summons = {}
    local pid = type(player) == "number" and player or player:GetPlayerID()
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    local units = FindUnitsInRadius(PlayerResource:GetTeam(pid), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
    for _,v in ipairs(units) do
        if type(player) == "number" and ((v.GetPlayerID ~= nil and v:GetPlayerID() or v:GetPlayerOwnerID()) == pid) or v:GetPlayerOwner() == player then
            if not v:HasModifier("modifier_dummy_unit") and v ~= hero then
                table.insert(summons, v)
            end
        end
    end
    return summons
end

function Round:End()
    self.bEnd = true
    PvpModule.currentPair ={}
    PvpModule.currentSinglePair ={}
    if self.nRoundNumber and compensateRoundNumber[self.nRoundNumber] then
        Round:CompensateRelearnBook(self.nRoundNumber)
    end
    Util:CleanFurArmySoldier()
end

function Round:CompensateRelearnBook(nRoundNumber) 
    local dataList= {}

    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
        if bAlive then
            for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do          
                local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
                if hHero  and  PlayerResource:GetConnectionState(nPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED then
                    local data = {}
                    local nGold =math.ceil(PlayerResource:GetGoldPerMin(nPlayerID) * (GameRules:GetGameTime() - GameRules.nGameStartTime)/60)+600-PvpModule.betValueSum[nPlayerID]
                    nGold = math.max(nGold, PlayerResource:GetNetWorth(nPlayerID))
                    data.nGold = nGold
                    data.nPlayerID = nPlayerID
                    table.insert(dataList, data)
                end
                GameMode:UpdatePlayerGold(nPlayerID)
            end
        end
    end

    if #dataList>=2 then
        table.sort(dataList, function(a, b) return a.nGold < b.nGold end)
        if dataList[1] and dataList[1].nPlayerID then
        local hHero = PlayerResource:GetSelectedHeroEntity(dataList[1].nPlayerID)
            if hHero then
                for _,nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
                    if nPlayerIDInTeam then
                        local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
                        if hHeroInTeam then
                            local hRelearnBook = hHeroInTeam:AddItemByName("item_relearn_book_lua")           
                            local hTornPage = hHeroInTeam:AddItemByName("item_relearn_torn_page_lua")
                     
                            if hTornPage and hTornPage.SetPurchaseTime then
                                hTornPage:SetPurchaseTime(0)
                            end
                            if hRelearnBook and hRelearnBook.SetPurchaseTime then
                                hRelearnBook:SetPurchaseTime(0)
                            end
                            local vData={}
                            vData.type = "compensate_relearn_book"
                            vData.round_number = tostring(nRoundNumber)
                            vData.playerId = dataList[1].nPlayerID
                            vData.book_type = 3
                            Barrage:FireBullet(vData)
                        end
                    end
                end
            end
        end
    end
      
    if #dataList>2 and dataList[2] and dataList[2].nPlayerID then
        local hHero = PlayerResource:GetSelectedHeroEntity(dataList[2].nPlayerID)
        if hHero then
            for _,nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
                if nPlayerIDInTeam then
                    local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
                    if hHeroInTeam then
                        local hRelearnBook = hHeroInTeam:AddItemByName("item_relearn_book_lua")
                        if hRelearnBook and hRelearnBook.SetPurchaseTime then
                            hRelearnBook:SetPurchaseTime(0)
                        end
                        local vData={}
                        vData.type = "compensate_relearn_book"
                        vData.round_number = tostring(nRoundNumber)
                        vData.playerId = dataList[2].nPlayerID
                        vData.book_type = 2
                        Barrage:FireBullet(vData)
                    end
                end
            end
        end
    end
      
    if #dataList>3 and dataList[3] and dataList[3].nPlayerID then
        local hHero = PlayerResource:GetSelectedHeroEntity(dataList[3].nPlayerID)
        if hHero then
            for _,nPlayerIDInTeam in ipairs(GameMode.vTeamPlayerMap[hHero:GetTeamNumber()]) do
                if nPlayerIDInTeam then
                    local hHeroInTeam = PlayerResource:GetSelectedHeroEntity(nPlayerIDInTeam)
                    if hHeroInTeam then
                        local hTornPage = hHeroInTeam:AddItemByName("item_relearn_torn_page_lua")
                        if hTornPage and hTornPage.SetPurchaseTime then
                            hTornPage:SetPurchaseTime(0)
                        end
                        local vData={}
                        vData.type = "compensate_relearn_book"
                        vData.round_number = tostring(nRoundNumber)
                        vData.playerId = dataList[3].nPlayerID
                        vData.book_type = 1
                        Barrage:FireBullet(vData)
                    end
                end
            end
        end
    end
end

function Round:PlayerReady(keys)
    local nPlayerID = keys.PlayerID
    if not nPlayerID then return end
    local hPlayer = PlayerResource:GetPlayer(nPlayerID)
    if hPlayer then
        self.readyPlayers[nPlayerID] = true
        CustomGameEventManager:Send_ServerToAllClients("UpdatePlayerReadyList", { readyPlayers = self.readyPlayers })
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "UpdateReadyButton", { visible = false })
    end
end