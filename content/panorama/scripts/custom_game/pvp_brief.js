victoryParticleID = 0
victoryLocateTimes = 0

function SetCameraFocus(data) {
    GameUI.SetCameraTargetPosition(data.vector, 0.1)
}

function ShowPvpBrief(data) {

    var maxBetValue
    var heroNumber = 0

    for (var index in data.players) {
        var playerId = data.players[index].playerID;
        var teamId = data.players[index].teamID;
        heroNumber = heroNumber + 1
        for (var i in data.betMap[teamId]) {
            if (maxBetValue == undefined) {
                maxBetValue = data.betMap[teamId][i].nValue;
            } else {
                if (maxBetValue < data.betMap[teamId][i].nValue) {
                    maxBetValue = data.betMap[teamId][i].nValue;
                }
            }
        }
    }

    var mainBriefPvpPanel = $("#PvPMain")

    if (Game.GetMapInfo().map_display_name == "2x6") {
        mainBriefPvpPanel.RemoveClass("PvPMain")
        mainBriefPvpPanel.AddClass("PvPMain2x6")
    } else {
        mainBriefPvpPanel.RemoveClass("PvPMain2x6")
        mainBriefPvpPanel.AddClass("PvPMain")
    }

    var firstTeamId = data.firstTeamId
    var secondTeamId = data.secondTeamId

    var currentPanel = null
    var currentBetInfo = null
    var positionOnScreen = null

    if (data.bonusPool) {
        $("#GoldValue").text = data.bonusPool
    }

    var firstTeamPanel = $.CreatePanel("Panel", mainBriefPvpPanel, "FirstTeamBrief");
    firstTeamPanel.AddClass("TeamBriefPvpPanel");

    var vsImageSrc = $.CreatePanel("Image", mainBriefPvpPanel, "VsLogo");
    vsImageSrc.SetImage("file://{resources}/images/custom_game/duel_bg.png")

    var secondTeamPanel = $.CreatePanel("Panel", mainBriefPvpPanel, "SecondTeamBrief");
    secondTeamPanel.AddClass("TeamBriefPvpPanel");

    var secondBetInfo = null
    var firstBetInfo = null

    for (var index in data.players) {
        var playerId = data.players[index].playerID;
        var playerInfo = Game.GetPlayerInfo(playerId);
        var teamId = data.players[index].teamID;
        var heroIndex = Players.GetPlayerHeroEntityIndex(playerId)

        if (teamId == firstTeamId) {
            currentPanel = firstTeamPanel
            positionOnScreen = "top"
        } else {
            currentPanel = secondTeamPanel
            positionOnScreen = "bottom"
        }

        var playermainpanelwithbg = $.CreatePanel("Panel", currentPanel, "playermainpanelwithbg_" + index);
        playermainpanelwithbg.AddClass("playermainpanelwithbg");

        var playermainpanelbg = $.CreatePanel("Panel", playermainpanelwithbg, "");
        playermainpanelbg.AddClass("playermainpanelbg");
        playermainpanelbg.style.backgroundImage = 'url( "file://{images}/heroes/' + playerInfo.player_selected_hero + '.png" )';
        playermainpanelbg.style.backgroundSize = "100% 220px"

        var playerAbilityPanel = $.CreatePanel("Panel", playermainpanelwithbg, "PlayerAbilityPanel_" + index);
        playerAbilityPanel.AddClass("PlayerAbilityPanel");
        playerAbilityPanel.positionOnScreen = positionOnScreen
        playerAbilityPanel.teamId = teamId
        

        var heroInfo = $.CreatePanel("Panel", playerAbilityPanel, "");
        heroInfo.AddClass("HeroInfo");
        var heroInfoPlayer = $.CreatePanel("Label", heroInfo, "");
        heroInfoPlayer.AddClass("PlayerName");
        heroInfoPlayer.text = playerInfo.player_name;
 
        // Цвет никнейма
        var player_information_battlepass = CustomNetTables.GetTableValue("cha_server_data", String(playerId));
        if (player_information_battlepass) {
            if (heroInfoPlayer) {
                if (player_information_battlepass.nickname == 1) {
                    if (GameUI.CustomUIConfig().team_colors) {
                        var teamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];
                        if (teamColor) {
                            heroInfoPlayer.style.color = teamColor
                        }
                    }
                } else if (player_information_battlepass.nickname == 2) {
                    heroInfoPlayer.SetHasClass("rainbow_nickname", true)
                    heroInfoPlayer.style.color = "gradient( linear, 100% 0%, 0% 0%, from( rgb(0, 183, 255)), color-stop( 0.5, rgb(0, 255, 85)), to( rgb(255, 196, 0)))"
                } else if (player_information_battlepass.nickname == 3) {
                    heroInfoPlayer.SetHasClass("rainbow_nickname_animate", true)
                }
            }
        }

        var HeroRank = $.CreatePanel("Panel", heroInfo, "HeroRank" + index);
        HeroRank.AddClass("HeroRank");

        var rank_number = $.CreatePanel("Label", HeroRank, "rank_number" + index);
        rank_number.AddClass("rank_number");

        var HeroInfoRating = $.CreatePanel("Panel", heroInfo, "HeroInfoRating" + index);
        HeroInfoRating.AddClass("HeroInfoRating");

        var HeroInfoRatingLabel = $.CreatePanel("Label", HeroInfoRating, "HeroInfoRatingLabel" + index);
        HeroInfoRatingLabel.AddClass("HeroInfoRatingLabel");
        HeroInfoRatingLabel.text = ""

        var HeroIconAndHealthAndMana = $.CreatePanel("Image", playerAbilityPanel, "HeroIconAndHealthAndMana" + index);
        HeroIconAndHealthAndMana.AddClass("HeroIconAndHealthAndMana");

        var heroBriefIcon = $.CreatePanel("Image", HeroIconAndHealthAndMana, "HeroIcon_" + index);
        heroBriefIcon.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png")
        heroBriefIcon.AddClass("HeroIcon");
        heroBriefIcon.playerId = playerId;
        HeroIconEvent(heroBriefIcon, index)

        var heroInfoHeroName = $.CreatePanel("Label", HeroIconAndHealthAndMana, "");
        heroInfoHeroName.AddClass("HeroName");
        heroInfoHeroName.text = $.Localize("#" + playerInfo.player_selected_hero);

        var LevelLabel = $.CreatePanel("Label", HeroIconAndHealthAndMana, "LevelLabel" + index);
        LevelLabel.AddClass("LevelLabel");
        LevelLabel.text = playerInfo.player_level + $.Localize("#duel_level")

        var GoldInfoIcon = $.CreatePanel("Panel", HeroIconAndHealthAndMana, "GoldInfoIcon" + index);
        GoldInfoIcon.AddClass("GoldInfoIcon");

        var GoldInfoLabelText = $.CreatePanel("Label", HeroIconAndHealthAndMana, "GoldInfoLabelText" + index);
        GoldInfoLabelText.AddClass("GoldInfoLabelText");

        var goldData = CustomNetTables.GetTableValue("player_info", playerId)

        if (goldData != undefined) {
            GoldInfoLabelText.text = goldData.gold
        }
        else {
            GoldInfoLabelText.text = 600
        }

        var localPlayerId = Game.GetLocalPlayerInfo().player_id;

        var pass_info = CustomNetTables.GetTableValue("player_info", "pass_data_" + localPlayerId);
        var rank_info_duel = CustomNetTables.GetTableValue("cha_server_data", String(playerId));
        if (rank_info_duel) {
            HeroInfoRatingLabel.text = $.Localize("#score") + ": " + (rank_info_duel.mmr[6] || 0) + "  " + $.Localize("#games_duel") + ": " + (rank_info_duel.games[6] || 0);
            if ((rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0" && rank_info_duel.rating_number_in_top <= 10) && (rank_info_duel.mmr[6] || 2500) >= 5420) {
                HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
            } else {
                HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rank_info_duel.mmr[6] || 2500) + '.png")';
            }
            HeroRank.style.backgroundSize = "100%"
            if (rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0") {
                rank_number.text = rank_info_duel.rating_number_in_top
            }
        }

        var HealthAndManaPanelWitchScepter = $.CreatePanel("Panel", playerAbilityPanel, "HealthAndManaPanel" + index);
        HealthAndManaPanelWitchScepter.AddClass("HealthAndManaPanelWitchScepter");

        var HealthAndManaPanel = $.CreatePanel("Panel", HealthAndManaPanelWitchScepter, "HealthAndManaPanel" + index);
        HealthAndManaPanel.AddClass("HealthAndManaPanel");

        var itemPanel = $.CreatePanel("Panel", playerAbilityPanel, "ItemPanel_" + index);
        itemPanel.AddClass("ItemPanel");

        var abilityPanel = $.CreatePanel("Panel", playerAbilityPanel, "AbilityPanel_" + index);
        abilityPanel.AddClass("AbilityPanel");

        var SkillPanel = $.CreatePanel("Panel", playerAbilityPanel, "SkillBlock" + index);
        SkillPanel.AddClass("SkillPanelBlock");

        var healthContainer = $.CreatePanel("Panel", HealthAndManaPanel, "HealthContainer_" + index);
        healthContainer.AddClass("HealthContainer");
        healthContainer.positionOnScreen = positionOnScreen
        healthContainer.teamId = teamId

        var healthLabel = $.CreatePanel("Label", healthContainer, "HealthLabel_" + index);
        healthLabel.AddClass("HealthLabel");

        var healthProgress = $.CreatePanel("ProgressBar", healthContainer, "HealthProgress_" + index);
        healthProgress.AddClass("HealthProgress");

        var healthProgressLeft = $("#HealthProgress_" + index + "_Left")
        healthProgressLeft.AddClass("HealthProgressLeft");

        var healthProgressRight = $("#HealthProgress_" + index + "_Right")
        healthProgressRight.AddClass("HealthProgressRight");

        var manaContainer = $.CreatePanel("Panel", HealthAndManaPanel, "ManaContainer_" + index);
        manaContainer.AddClass("ManaContainer");
        manaContainer.positionOnScreen = positionOnScreen
        manaContainer.teamId = teamId

        var manaLabel = $.CreatePanel("Label", manaContainer, "ManaLabel_" + index);
        manaLabel.AddClass("ManaLabel");

        var manaProgress = $.CreatePanel("ProgressBar", manaContainer, "ManaProgress_" + index);
        manaProgress.AddClass("ManaProgress");

        var manaProgressLeft = $("#ManaProgress_" + index + "_Left")
        manaProgressLeft.AddClass("ManaProgressLeft");

        var manaProgressRight = $("#ManaProgress_" + index + "_Right")
        manaProgressRight.AddClass("ManaProgressRight");

        let shard_and_scepter_upgrade_panel = $.CreatePanel("Panel", HealthAndManaPanelWitchScepter, "shard_and_scepter_upgrade_panel_" + index)
        shard_and_scepter_upgrade_panel.style.width = "28px"
        shard_and_scepter_upgrade_panel.style.height = "100%"
        shard_and_scepter_upgrade_panel.style.marginLeft = "5px"
        shard_and_scepter_upgrade_panel.style.flowChildren = "down"

        let scepter_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "scepter_upgrade_panel")
        scepter_upgrade_panel.style.width = "28px"
        scepter_upgrade_panel.style.height = "28px"
        scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
        scepter_upgrade_panel.style.backgroundSize = "100%"

        let shard_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "shard_upgrade_panel")
        shard_upgrade_panel.style.width = "28px"
        shard_upgrade_panel.style.height = "16px"
        shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
        shard_upgrade_panel.style.backgroundSize = "100%"

        $("#HealthLabel_" + index).text = Entities.GetHealth(heroIndex) + " / " + Entities.GetMaxHealth(heroIndex);
        $("#ManaLabel_" + index).text = Entities.GetMana(heroIndex) + " / " + Entities.GetMaxMana(heroIndex);

        var healthPercent = Entities.GetHealth(heroIndex) / Entities.GetMaxHealth(heroIndex);
        $("#HealthProgress_" + index).value = healthPercent;

        var manaPercent = Entities.GetMana(heroIndex) / Entities.GetMaxMana(heroIndex);
        $("#ManaProgress_" + index).value = manaPercent;

        if (teamId == firstTeamId) 
        {
            firstBetInfo = $.CreatePanel("Panel", playerAbilityPanel, "BetInfoContainer_1");
            firstBetInfo.AddClass("BetInfoContainer");
        } else {
            secondBetInfo = $.CreatePanel("Panel", playerAbilityPanel, "BetInfoContainer_2");
            secondBetInfo.AddClass("BetInfoContainer");
        }
    }

    // СОЗДАНИЕ СТАВОЧЕК////////////////////////////////////////////////////////////////////////////////////////

    if (maxBetValue != undefined) {
        if (Game.GetMapInfo().map_display_name == "2x6") {

            for (var i in data.betMap[firstTeamId]) {
                var betData = data.betMap[firstTeamId][i]

                let teambetline = firstBetInfo.FindChildTraverse("teambetline_" + Players.GetTeam(betData.nPlayerId))
                if (!teambetline) {
                    teambetline = $.CreatePanel("Panel", firstBetInfo, "teambetline_" + Players.GetTeam(betData.nPlayerId));
                    teambetline.BLoadLayoutSnippet("PlayerBetLine");
                    let percent = betData.nValue / maxBetValue;
                    teambetline.FindChildTraverse("BetValueProgressBar").value = percent;
                    teambetline.FindChildTraverse("BetValue").text = betData.nValue;
                    if (GameUI.CustomUIConfig().team_icons) {
                        var teamIcon = GameUI.CustomUIConfig().team_icons[Players.GetTeam(betData.nPlayerId)];
                        if (teamIcon) {
                            teambetline.FindChildTraverse("HeroIcon").SetImage(teamIcon);
                        }
                    }
                } else {
                    let percent = betData.nValue / maxBetValue;
                    teambetline.FindChildTraverse("BetValueProgressBar").value = Number(teambetline.FindChildTraverse("BetValueProgressBar").value) + percent;
                    teambetline.FindChildTraverse("BetValue").text = Number(teambetline.FindChildTraverse("BetValue").text) + betData.nValue;
                }
            }

        } else {
            for (var i in data.betMap[firstTeamId]) {
                var betData = data.betMap[firstTeamId][i]
                var playerBetLine = $.CreatePanel("Panel", firstBetInfo, "PlayerBetLine_" + i);
                playerBetLine.BLoadLayoutSnippet("PlayerBetLine");
                var percent = betData.nValue / maxBetValue;
                playerBetLine.FindChildTraverse("BetValueProgressBar").value = percent;
                playerBetLine.FindChildTraverse("BetValue").text = betData.nValue;
                var heroName = Players.GetPlayerSelectedHero(betData.nPlayerId)
                playerBetLine.FindChildTraverse("HeroIcon").SetImage("file://{images}/heroes/icons/" + heroName + ".png");
            }
        }
    }

    if (maxBetValue != undefined) {
        if (Game.GetMapInfo().map_display_name == "2x6") {
            for (var i in data.betMap[secondTeamId]) {
                var betData = data.betMap[secondTeamId][i]

                let teambetline = firstBetInfo.FindChildTraverse("teambetline_" + Players.GetTeam(betData.nPlayerId))
                if (!teambetline) {
                    teambetline = $.CreatePanel("Panel", firstBetInfo, "teambetline_" + Players.GetTeam(betData.nPlayerId));
                    teambetline.BLoadLayoutSnippet("PlayerBetLine");
                    let percent = betData.nValue / maxBetValue;
                    teambetline.FindChildTraverse("BetValueProgressBar").value = percent;
                    teambetline.FindChildTraverse("BetValue").text = betData.nValue;
                    if (GameUI.CustomUIConfig().team_icons) {
                        var teamIcon = GameUI.CustomUIConfig().team_icons[Players.GetTeam(betData.nPlayerId)];
                        if (teamIcon) {
                            teambetline.FindChildTraverse("HeroIcon").SetImage(teamIcon);
                        }
                    }
                } else {
                    let percent = betData.nValue / maxBetValue;
                    teambetline.FindChildTraverse("BetValueProgressBar").value = Number(teambetline.FindChildTraverse("BetValueProgressBar").value) + percent;
                    teambetline.FindChildTraverse("BetValue").text = Number(teambetline.FindChildTraverse("BetValue").text) + betData.nValue;
                }
            }
        } else {
            for (var i in data.betMap[secondTeamId]) {
                var betData = data.betMap[secondTeamId][i]
                var playerBetLine = $.CreatePanel("Panel", secondBetInfo, "PlayerBetLine_" + i);
                playerBetLine.BLoadLayoutSnippet("PlayerBetLine");
                var percent = betData.nValue / maxBetValue;
                playerBetLine.FindChildTraverse("BetValueProgressBar").value = percent;
                playerBetLine.FindChildTraverse("BetValue").text = betData.nValue;
                var heroName = Players.GetPlayerSelectedHero(betData.nPlayerId)

                playerBetLine.FindChildTraverse("HeroIcon").SetImage("file://{images}/heroes/icons/" + heroName + ".png");
            }
        }

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

    $("#PvPMain").AddClass("PvPMainBackground");
    $("#PvPMain").RemoveClass("Hidden");
    $("#VsLogo").RemoveClass("Hidden");
    $("#PvPMainHeader").RemoveClass("Hidden");
    //If the main interface is minimized, at least the buttons are displayed
    if ($("#PvPMain").BHasClass("PvPMainHidden")) {
        $("#PvPMainHeaderShowPanel").RemoveClass("Hidden");
    }

    $.Schedule(0.5, function() {
        UpdatePvpBrief(heroNumber)
    });
}

function UpdatePvpBrief(heroNumber) 
{
    if ($("#FirstTeamBrief") != null) 
    {
        if (!$("#PvPMain").BHasClass("Hidden")) 
        {
            $.Schedule(0.5, function() 
            {
                UpdatePvpBrief(heroNumber)
            });
        }

        for (var index = 1; index <= heroNumber; index++) 
        {
            if ($("#HeroIcon_" + index) != undefined) 
            {
                var playerId = $("#HeroIcon_" + index).playerId;
                var playerInfo = Game.GetPlayerInfo(playerId);
                var heroIndex = Players.GetPlayerHeroEntityIndex(playerId);
                var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);
                var EntityAbilities = [];
                var EntityAbilitiesNames = [];
                var EntityItems = [];
                var EntityItemsNames = [];
                var NeutralItem
                var NeutralItemindex

                for (var i = 0; i <= Entities.GetAbilityCount(playerHeroIndex); i++)
                {
                    var ability = Entities.GetAbility(playerHeroIndex, i);

                    if (ability !== -1 && IsValidAbilityDuel(ability))
                    {
                        EntityAbilities.push(ability);
                        EntityAbilitiesNames.push(Abilities.GetAbilityName(ability));
                    }
                }

                UpdateHeroHudBuffs(index);

                for (var i = 0; i <= 5; i++) 
                {
                    var item = Entities.GetItemInSlot(playerHeroIndex, i);
                    if (item !== -1)
                    {
                        EntityItems.push(item);
                        EntityItemsNames.push(Abilities.GetAbilityName(item));
                    } else {
                        EntityItems.push(-1);
                        EntityItemsNames.push(""); 
                    }
                }

                NeutralItem = Abilities.GetAbilityName(Entities.GetItemInSlot(playerHeroIndex, 16));
                NeutralItemindex = Entities.GetItemInSlot(playerHeroIndex, 16)

                if (Game.GetMapInfo().map_display_name != "5v5") 
                {
                    let ability_panel = $("#AbilityPanel_" + index)
                    let item_panel = $("#ItemPanel_" + index)

                    if (!isEqual(EntityAbilitiesNames, ability_panel.EntityAbilitiesNames) || ability_panel.GetChildCount() <= 0) 
                    {
                        ability_panel.RemoveAndDeleteChildren()
                        for (k in EntityAbilities)
                        {
                            var ability = EntityAbilities[k];
                            let ability_box = $.CreatePanel("Panel", ability_panel, "");
                            ability_box.abilityId = ability;
                            ability_box.BLoadLayoutSnippet("AbilityItem")
                            let Cooldown = $.CreatePanel("Panel", ability_box, "Cooldown");
                            let CooldownOverlay = $.CreatePanel("Panel", ability_box, "CooldownOverlay");
                            let CooldownTimer = $.CreatePanel("Label", ability_box, "CooldownTimer");
                            Cooldown.AddClass("CooldownItem")
                            CooldownOverlay.AddClass("CooldownOverlayItem")
                            CooldownTimer.AddClass("CooldownTimerItem")
                            let abilityImage = ability_box.GetChild(0)
                            abilityImage.abilityname = Abilities.GetAbilityName(ability);
                            ability_box.SetPanelEvent("onmouseover", ShowAbilityTooltip(abilityImage));
                            ability_box.SetPanelEvent("onmouseout", HideAbilityTooltip(abilityImage));
                            ability_box.SetHasClass("Passive", Abilities.IsPassive(ability))
                            ability_box.SetHasClass("Unlearned", Abilities.GetLevel(ability) == 0)

                            var pass_info_local = CustomNetTables.GetTableValue("player_info", "pass_data_" + Players.GetLocalPlayer());
                            //if (pass_info_local && (pass_info_local.pass_level_1_days > 0 || pass_info_local.pass_level_2_days > 0 || pass_info_local.pass_level_3_days > 0)) 
                            //{
                                let ability_levelbox = $.CreatePanel("Panel", ability_box, "ability_levelbox");
                                ability_levelbox.AddClass("ability_levelbox")

                                for (var ability_level = 1; ability_level <= Abilities.GetMaxLevel(ability); ability_level++) 
                                {
                                    let ability_level_quad = $.CreatePanel("Panel", ability_levelbox, "ability_level_quad" + ability_level);
                                    if (Abilities.GetLevel(ability) >= ability_level) 
                                    {
                                        ability_level_quad.AddClass("ability_level_quad")
                                    } else {
                                        ability_level_quad.AddClass("ability_level_quad_not_learn")
                                    }
                                }
                            //}
                        }
                        let hidden_abil_spawn = 6 - EntityAbilities.length
                        if (hidden_abil_spawn > 0) {
                            for (var ddd = 0; ddd < hidden_abil_spawn; ddd++) {
                                let ability_box = $.CreatePanel("Panel", ability_panel, "");
                                ability_box.AddClass("hidden_ab_spawn")
                            }
                        }
                    }

                    ability_panel.EntityAbilities = EntityAbilities;
                    ability_panel.EntityAbilitiesNames = EntityAbilitiesNames;

                    for (var i = 0; i < ability_panel.GetChildCount(); i++) 
                    {
                        var abilityPanel = ability_panel.GetChild(i);
                        let ability = abilityPanel.abilityId
                        if (ability)
                        {
                            var cooldown = Abilities.GetCooldownTimeRemaining(ability);
                            if (cooldown > 0) 
                            {
                                abilityPanel.FindChildTraverse("CooldownTimer").text = Math.ceil(cooldown);
                                abilityPanel.FindChildTraverse("CooldownOverlay").RemoveClass("Hidden");
                                var cooldownLength = Abilities.GetCooldown(ability);
                                var angle = cooldown / cooldownLength * -360;
                                if (cooldownLength > 0) 
                                {
                                    var angle = cooldown / cooldownLength * -360;
                                    abilityPanel.FindChildTraverse("CooldownOverlay").style.clip = "radial( 50.0% 50.0%, 0.0deg, " + angle + "deg)";
                                }
                            } 
                            else 
                            {
                                abilityPanel.FindChildTraverse("CooldownTimer").text = "";
                                abilityPanel.FindChildTraverse("CooldownOverlay").AddClass("Hidden");
                                abilityPanel.FindChildTraverse("CooldownOverlay").style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";
                            }
                            for (var ability_level = 1; ability_level <= Abilities.GetMaxLevel(ability); ability_level++) 
                            {
                                let ability_level_quad = abilityPanel.FindChildTraverse("ability_level_quad" + ability_level)
                                if (ability_level_quad)
                                {
                                    if (Abilities.GetLevel(ability) >= ability_level) 
                                    {
                                        ability_level_quad.RemoveClass("ability_level_quad_not_learn")
                                        ability_level_quad.AddClass("ability_level_quad")
                                    } 
                                    else 
                                    {
                                        ability_level_quad.RemoveClass("ability_level_quad")
                                        ability_level_quad.AddClass("ability_level_quad_not_learn")
                                    }
                                }
                            }
                        }   
                    }

                    if (!isEqual(EntityItemsNames, item_panel.EntityItemsNames) || item_panel.GetChildCount() <= 0 || NeutralItem !== item_panel.NeutralItem) 
                    {
                        item_panel.RemoveAndDeleteChildren()

                        for (k in EntityItems)
                        {
                            var item = EntityItems[k];
                            var itemName = Abilities.GetAbilityName(item);
                            let itemImage = $.CreatePanel("DOTAItemImage", item_panel, "");
                            itemImage.abilityId = item;
                            itemImage.itemname = itemName;
                            itemImage.SetPanelEvent("onmouseover", ShowItemTooltip(itemImage));
                            itemImage.SetPanelEvent("onmouseout", HideItemTooltip(itemImage));
                            let Cooldown = $.CreatePanel("Panel", itemImage, "CooldownItem");
                            let CooldownOverlay = $.CreatePanel("Panel", itemImage, "CooldownOverlayItem");
                            let CooldownTimer = $.CreatePanel("Label", itemImage, "CooldownTimerItem");
                            Cooldown.AddClass("CooldownItem")
                            CooldownOverlay.AddClass("CooldownOverlayItem")
                            CooldownTimer.AddClass("CooldownTimerItem")
                        }

                        item_panel.EntityItems = EntityItems;
                        item_panel.EntityItemsNames = EntityItemsNames;

                        let neutral_item_panel = $.CreatePanel("DOTAItemImage", item_panel, "");
                        neutral_item_panel.AddClass("NeutralItem");
                        neutral_item_panel.abilityId = NeutralItemindex
                        let Cooldown = $.CreatePanel("Panel", neutral_item_panel, "CooldownItem");
                        let CooldownOverlay = $.CreatePanel("Panel", neutral_item_panel, "CooldownOverlayItem");
                        let CooldownTimer = $.CreatePanel("Label", neutral_item_panel, "CooldownTimerItem");
                        Cooldown.AddClass("CooldownItem")
                        CooldownOverlay.AddClass("CooldownOverlayItem")
                        CooldownTimer.AddClass("CooldownTimerItem")
                        neutral_item_panel.style.width = "28px"

                        if (NeutralItemindex != -1) 
                        {
                            var neutral_itemName = Abilities.GetAbilityName(NeutralItemindex);
                            neutral_item_panel.itemname = neutral_itemName
                            neutral_item_panel.SetHasClass("empty_item", false)
                        } 
                        else 
                        {
                            neutral_item_panel.SetImage("");
                            neutral_item_panel.SetHasClass("empty_item", true)
                        }

                        item_panel.NeutralItem = NeutralItem;
                    }

                    let scepter_upgrade_panel_new = $("#shard_and_scepter_upgrade_panel_" + index).FindChildTraverse("scepter_upgrade_panel")
                    if (scepter_upgrade_panel_new)
                    {
                        if (Entities.HasScepter(playerHeroIndex)) 
                        {
                            scepter_upgrade_panel_new.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_on_psd.vtex")';
                            scepter_upgrade_panel_new.style.backgroundSize = "100%"
                        } 
                        else 
                        {
                            scepter_upgrade_panel_new.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
                            scepter_upgrade_panel_new.style.backgroundSize = "100%"
                        }
                    }

                    let shard_upgrade_panel_new = $("#shard_and_scepter_upgrade_panel_" + index).FindChildTraverse("shard_upgrade_panel")
                    if (shard_upgrade_panel_new)
                    {
                        if (HasModifier(playerHeroIndex, "modifier_item_aghanims_shard")) 
                        {
                            shard_upgrade_panel_new.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_on_psd.vtex")';
                            shard_upgrade_panel_new.style.backgroundSize = "100%"
                        } 
                        else 
                        {
                            shard_upgrade_panel_new.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
                            shard_upgrade_panel_new.style.backgroundSize = "100%"
                        }
                    }

                    for (var i = 0; i < item_panel.GetChildCount(); i++) 
                    {
                        var abilityPanel = item_panel.GetChild(i);
                        let ability = abilityPanel.abilityId
                        if (ability)
                        {
                            var cooldown = Abilities.GetCooldownTimeRemaining(ability);
                            if (cooldown > 0) 
                            {
                                abilityPanel.FindChildTraverse("CooldownTimerItem").text = Math.ceil(cooldown);
                                abilityPanel.FindChildTraverse("CooldownOverlayItem").RemoveClass("Hidden");
                                var cooldownLength = Abilities.GetCooldown(ability);
                                var angle = cooldown / cooldownLength * -360;
                                if (cooldownLength > 0) 
                                {
                                    var angle = cooldown / cooldownLength * -360;
                                    abilityPanel.FindChildTraverse("CooldownOverlayItem").style.clip = "radial( 50.0% 50.0%, 0.0deg, " + angle + "deg)";
                                }
                            } 
                            else 
                            {
                                abilityPanel.FindChildTraverse("CooldownTimerItem").text = "";
                                abilityPanel.FindChildTraverse("CooldownOverlayItem").AddClass("Hidden");
                                abilityPanel.FindChildTraverse("CooldownOverlayItem").style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";
                            }
                        }
                    }

                    $("#HealthLabel_" + index).text = Entities.GetHealth(heroIndex) + " / " + Entities.GetMaxHealth(heroIndex);
                    $("#ManaLabel_" + index).text = Entities.GetMana(heroIndex) + " / " + Entities.GetMaxMana(heroIndex);
                    var healthPercent = Entities.GetHealth(heroIndex) / Entities.GetMaxHealth(heroIndex);
                    $("#HealthProgress_" + index).value = healthPercent;
                    var manaPercent = Entities.GetMana(heroIndex) / Entities.GetMaxMana(heroIndex);
                    $("#ManaProgress_" + index).value = manaPercent;
                }
            }       
        }
    }
}

function isEqual(a, b)
{
    if (a instanceof Array && b instanceof Array)
    {
        if (a.length !== b.length) {
            return false;
        }
 
        for (var i = 0; i < a.length; i++)
        {
            if (!isEqual(a[i], b[i])) {
                return false;
            }
        }
 
        return true;
    }
 
    return a === b;
}


function HidePvpBrief() {

    $("#PvPMain").AddClass("Hidden");
    $("#PvPMainHeaderShowPanel").AddClass("Hidden");
}

function ResetPvpBrief() {
    if ($("#FirstTeamBrief") != null) {
        $("#FirstTeamBrief").DeleteAsync(0)
    }
    if ($("#SecondTeamBrief") != null) {
        $("#SecondTeamBrief").DeleteAsync(0)
    }
    if ($("#VsLogo") != null) {
        $("#VsLogo").DeleteAsync(0)
    }
    if ($("#BetInfoContainer_1") != null) {
        $("#BetInfoContainer_1").DeleteAsync(0)
    }
    if ($("#BetInfoContainer_2") != null) {
        $("#BetInfoContainer_2").DeleteAsync(0)
    }
}




// Не трогать

function LocateVictoryParticle() {

    victoryLocateTimes = victoryLocateTimes + 1
    if (victoryLocateTimes > 500) {
        return;
    }
    var location = Game.ScreenXYToWorld(580, 655)
    location[2] = 1000;

    Particles.SetParticleControl(victoryParticleID, 3, location)

    $.Schedule(0.1, LocateVictoryParticle);
}

function ShowVictoryParticle() {

    var location = Game.ScreenXYToWorld(580, 655)
    location[2] = 1000;
    victoryParticleID = Particles.CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_commander_duel_victories.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, 0);
    victoryLocateTimes = 0
    Particles.SetParticleControl(victoryParticleID, 3, location)
    LocateVictoryParticle()
}

function TeamWin(data) {

    if ($("#BetInfoContainer_1") != null) {
        $("#BetInfoContainer_1").DeleteAsync(0)
    }
    if ($("#BetInfoContainer_2") != null) {
        $("#BetInfoContainer_2").DeleteAsync(0)
    }

    if ($("#VsLogo") != null) {
        $("#VsLogo").AddClass("Hidden")
        $("#PvPMain").RemoveClass("PvPMainBackground")
        $("#PvPMainHeader").AddClass("Hidden")
        for (var index = 1; index <= 4; index++) {
            if ($("#PlayerAbilityPanel_" + index) != undefined) {

                var barTeamId = $("#PlayerAbilityPanel_" + index).teamId
                if (barTeamId == data.winnerTeamID) {
                    var positionOnScreen = $("#PlayerAbilityPanel_" + index).positionOnScreen
                    if (positionOnScreen == "top") {
                        $("#FirstTeamBrief").AddClass("MoveDown")
                    } else {
                        $("#SecondTeamBrief").AddClass("MoveUp")
                    }
                }

                if (barTeamId == data.loserTeamID) {
                    if ($("#PlayerAbilityPanel_" + index) == undefined) {
                        return;
                    }
                    var positionOnScreen = $("#PlayerAbilityPanel_" + index).positionOnScreen
                    if (positionOnScreen == "top") 
                    {
                        $("#FirstTeamBrief").AddClass("Hidden")
                    } else {
                        $("#SecondTeamBrief").AddClass("Hidden")
                    }
                    $("#playermainpanelwithbg_" + index).AddClass("Hidden");
                    $("#PlayerAbilityPanel_" + index).AddClass("Hidden");
                    $("#HealthContainer_" + index).AddClass("Hidden");
                    $("#ManaContainer_" + index).AddClass("Hidden");
                }
            }
        }

        //为非参与者播放胜利特效
        if (Players.GetTeam(Players.GetLocalPlayer()) != data.nWinnerTeamID && Players.GetTeam(Players.GetLocalPlayer()) != data.nLoserTeamID) {
            ShowVictoryParticle()
        }

        $.Schedule(3.2, HidePvpBrief);
        $.Schedule(5, ResetPvpBrief);
    }
}

function HeroIconEvent(heroIcon, index) {
    heroIcon.SetPanelEvent("onactivate", function() {
        HeroIconClicked(index, false)
    })
    heroIcon.SetPanelEvent("ondblclick", function() {
        HeroIconClicked(index, true)
    })
}

function HeroIconEvent_double(heroIcon, id) {
    heroIcon.SetPanelEvent("onactivate", function() {
        HeroIconClicked_double(id, false)
    })
    heroIcon.SetPanelEvent("ondblclick", function() {
        HeroIconClicked_double(id, true)
    })
}

function HeroIconClicked(index, bDoubleClick) {

    var targetPlayerId = $("#HeroIcon_" + index).playerId;
    var targetHero = Players.GetPlayerHeroEntityIndex(targetPlayerId)
    if (targetHero != undefined) {
        GameUI.SelectUnit(targetHero, false)
    }
    GameEvents.SendCustomGameEventToServer('HeroIconClicked', {
        playerId: Players.GetLocalPlayer(),
        targetPlayerId: targetPlayerId,
        doubleClick: bDoubleClick,
        controldown: GameUI.IsControlDown()
    })
}

function HeroIconClicked_double(id, bDoubleClick) {
    var targetHero = Players.GetPlayerHeroEntityIndex(id)
    if (targetHero != undefined) {
        GameUI.SelectUnit(targetHero, false)
    }
    GameEvents.SendCustomGameEventToServer('HeroIconClicked', {
        playerId: Players.GetLocalPlayer(),
        targetPlayerId: id,
        doubleClick: bDoubleClick,
        controldown: GameUI.IsControlDown()
    })
}

function TogglePvPMain() {
    $("#PvPMain").ToggleClass("PvPMainHidden");
    $("#PvPMainHeaderShowPanel").ToggleClass("Hidden");
}

function HasModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier) {
            return Entities.GetBuff(unit, i)
        }
    }
    return false
}

function _ShowTooltip(panel, abilityName, heroIndex) {
    return () => {
        $.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", panel, abilityName, heroIndex);
    }
}

function _HideTooltip(panel) {
    return () => {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    }
}

function _Ping(ability_entindex) {
    return () => {
        Abilities.PingAbility(ability_entindex)
    }
}

function _ShowTalentsTooltip(panel, heroIndex) {
    return () => {
        $.DispatchEvent("DOTAHUDShowHeroStatBranchTooltip", panel, heroIndex);
    }
}

function _HideTalentsTooltip(panel) {
    return () => {
        $.DispatchEvent("DOTAHUDHideStatBranchTooltip");
    }
}

function OpenTopInfo(data) {

    let players = data.players

    if (players[1] && players[2]) {
        var playerInfo1 = Game.GetPlayerInfo(players[1]["playerID"]);
        var playerInfo2 = Game.GetPlayerInfo(players[2]["playerID"]);

        if (playerInfo1) {
            $("#PortraitTopDuelHero_1").hero = playerInfo1.player_selected_hero
            HeroIconEvent_double($("#PortraitTopDuelHero_1"), players[1]["playerID"])
            $("#PortraitTopDuelHero_1").style.backgroundImage = 'url("file://{images}/heroes/' + playerInfo1.player_selected_hero + '.png")'
        }

        if (playerInfo2) {
            $("#PortraitTopDuelHero_2").hero = playerInfo2.player_selected_hero
            HeroIconEvent_double($("#PortraitTopDuelHero_2"), players[2]["playerID"])
            $("#PortraitTopDuelHero_2").style.backgroundImage = 'url("file://{images}/heroes/' + playerInfo2.player_selected_hero + '.png")'
        }

        $("#PortraitTopDuelHero_1").style.backgroundSize = "100%"
        $("#PortraitTopDuelHero_2").style.backgroundSize = "100%"
        $("#DamageTopInfo_1").text = "0"
        $("#DamageTopInfo_2").text = "0"
        $("#LineTopPvPInfoTeam2").style.width = "0%"
        $("#LineTopPvPInfoTeam1").style.width = "0%"
        $("#PvpCenterInformation").style.visibility = "visible"
    }
}

function CloseTopInfo(data) {
    $("#PvpCenterInformation").style.visibility = "collapse"
}

function UpdateTopInfo(data) {
    if ($("#PortraitTopDuelHero_2").hero == data.hero_2_name) {
        let full_stats = data.full_hp
        let stats_agility = data.hero_1_hp
        let stats_strenth = data.hero_2_hp

        if (stats_agility >= 0) {
            var percent = ((full_stats - stats_strenth) * 100) / full_stats
            if (percent >= 0) {
                $("#LineTopPvPInfoTeam1").style['width'] = (100 - percent) + '%';
            } else {
                $("#LineTopPvPInfoTeam1").style['width'] = '0%';
            }
        }
        if (stats_strenth >= 0) {
            var percent = ((full_stats - stats_agility) * 100) / full_stats
            if (percent >= 0) {
                $("#LineTopPvPInfoTeam2").style['width'] = (100 - percent) + '%';
            } else {
                $("#LineTopPvPInfoTeam2").style['width'] = '0%';
            }
        }

        if (stats_strenth > stats_agility) {
            $("#LineTopPvPInfoTeam1").SetHasClass("PlayerLoseColor", false)
            $("#LineTopPvPInfoTeam2").SetHasClass("PlayerLoseColor", true)
        } else if (stats_strenth < stats_agility) {
            $("#LineTopPvPInfoTeam1").SetHasClass("PlayerLoseColor", true)
            $("#LineTopPvPInfoTeam2").SetHasClass("PlayerLoseColor", false)
        } else {
            $("#LineTopPvPInfoTeam1").SetHasClass("PlayerLoseColor", false)
            $("#LineTopPvPInfoTeam2").SetHasClass("PlayerLoseColor", false)
        }

        $("#DamageTopInfo_1").text = CheckStringDamage(stats_strenth)
        $("#DamageTopInfo_2").text = CheckStringDamage(stats_agility)
    } else {
        let full_stats = data.full_hp
        let stats_agility = data.hero_1_hp
        let stats_strenth = data.hero_2_hp

        if (stats_agility >= 0) {
            var percent = ((full_stats - stats_strenth) * 100) / full_stats
            if (percent >= 0) {
                $("#LineTopPvPInfoTeam2").style['width'] = (100 - percent) + '%';
            } else {
                $("#LineTopPvPInfoTeam2").style['width'] = '0%';
            }
        }
        if (stats_strenth >= 0) {
            var percent = ((full_stats - stats_agility) * 100) / full_stats
            if (percent >= 0) {
                $("#LineTopPvPInfoTeam1").style['width'] = (100 - percent) + '%';
            } else {
                $("#LineTopPvPInfoTeam1").style['width'] = '0%';
            }
        }

        if (stats_strenth > stats_agility) {
            $("#LineTopPvPInfoTeam2").SetHasClass("PlayerLoseColor", false)
            $("#LineTopPvPInfoTeam1").SetHasClass("PlayerLoseColor", true)
        } else if (stats_strenth < stats_agility) {
            $("#LineTopPvPInfoTeam2").SetHasClass("PlayerLoseColor", true)
            $("#LineTopPvPInfoTeam1").SetHasClass("PlayerLoseColor", false)
        } else {
            $("#LineTopPvPInfoTeam2").SetHasClass("PlayerLoseColor", false)
            $("#LineTopPvPInfoTeam1").SetHasClass("PlayerLoseColor", false)
        }

        $("#DamageTopInfo_2").text = CheckStringDamage(stats_strenth)
        $("#DamageTopInfo_1").text = CheckStringDamage(stats_agility)
    }
}

function CheckStringDamage(damage) 
{
    if (damage > 999999) {
        return String((damage / 1000000).toFixed(2)) + "M"
    } else if (damage > 999) {
        return String((damage / 1000).toFixed(2)) + "K"
    } else {
        return damage.toFixed(0)
    }
}

function UpdateHeroHudBuffs(index) 
{
    if ($("#SkillBlock" + index) == null) {
        return
    }

    var playerId = $("#HeroIcon_" + index).playerId;
    let hero = Players.GetPlayerHeroEntityIndex(playerId);

    let skills_1 = CustomNetTables.GetTableValue("skills_table", "tier_1")
    if (skills_1 && skills_1.skills) {
        for (var i = 1; i <= Object.keys(skills_1.skills).length; i++) {
            if (HasModifier(hero, skills_1.skills[i][1])) {
                CreateSkill(skills_1.skills[i], 1, index)
            }
        }
    }
    let skills_2 = CustomNetTables.GetTableValue("skills_table", "tier_2")
    if (skills_2 && skills_2.skills) {
        for (var i = 1; i <= Object.keys(skills_2.skills).length; i++) {
            if (HasModifier(hero, skills_2.skills[i][1])) {
                CreateSkill(skills_2.skills[i], 2, index)
            }
        }
    }
    let skills_3 = CustomNetTables.GetTableValue("skills_table", "tier_3")
    if (skills_3 && skills_3.skills) {
        for (var i = 1; i <= Object.keys(skills_3.skills).length; i++) {
            if (HasModifier(hero, skills_3.skills[i][1])) {
                CreateSkill(skills_3.skills[i], 3, index)
            }
        }
    }

    let skills_4 = CustomNetTables.GetTableValue("skills_table", "tier_4")
    if (skills_4 && skills_4.skills) {
        for (var i = 1; i <= Object.keys(skills_4.skills).length; i++) {
            if (HasModifier(hero, skills_4.skills[i][1])) {
                CreateSkill(skills_4.skills[i], 4, index)
            }
        }
    }

    let skills_5 = CustomNetTables.GetTableValue("skills_table", "tier_5")
    if (skills_5 && skills_5.skills) {
        for (var i = 1; i <= Object.keys(skills_5.skills).length; i++) {
            if (HasModifier(hero, skills_5.skills[i][1])) {
                CreateSkill(skills_5.skills[i], 5, index)
            }
        }
    }

    $.Schedule(3, UpdateHeroHudBuffs)
}

function CreateSkill(info, tier, index) {
    let this_skill = $("#SkillBlock" + index).FindChildTraverse(info[1])
    if (this_skill) {
        return
    }
    var Skill = $.CreatePanel("Panel", $("#SkillBlock" + index), info[1]);
    Skill.AddClass("SkillPanel" + tier);
    Skill.style.backgroundImage = 'url("file://{images}/custom_game/skills/' + info[3] + '.png")';
    Skill.style.backgroundSize = "100%"
    SetShowText(Skill, "<b>" + $.Localize("#" + info[2]) + "</b>" + "<br><br>" + $.Localize("#" + info[2] + "_desc"))
}

function SetShowText(panel, text) {
    panel.SetPanelEvent('onmouseover', function () {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text);
    });

    panel.SetPanelEvent('onmouseout', function () {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });
}

(function() {
    GameEvents.Subscribe("ShowPvpBrief", ShowPvpBrief);
    GameEvents.Subscribe("TeamWin", TeamWin);
    GameEvents.Subscribe("ShowVictoryParticle", ShowVictoryParticle);
    GameEvents.Subscribe("SetCameraFocus", SetCameraFocus);

    GameEvents.Subscribe("OpenTopInfo", OpenTopInfo);
    GameEvents.Subscribe("CloseTopInfo", CloseTopInfo);
    GameEvents.Subscribe("UpdateTopInfo", UpdateTopInfo);
})();
