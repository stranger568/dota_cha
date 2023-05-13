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

    var firstBetInfo = $.CreatePanel("Panel", mainBriefPvpPanel, "BetInfoContainer_1");
    firstBetInfo.AddClass("BetInfoContainer");

    var vsImageSrc = $.CreatePanel("Image", mainBriefPvpPanel, "VsLogo");
    vsImageSrc.SetImage("file://{resources}/images/custom_game/duel_bg.png")

    var secondTeamPanel = $.CreatePanel("Panel", mainBriefPvpPanel, "SecondTeamBrief");
    secondTeamPanel.AddClass("TeamBriefPvpPanel");

    var secondBetInfo = $.CreatePanel("Panel", mainBriefPvpPanel, "BetInfoContainer_2");
    secondBetInfo.AddClass("BetInfoContainer");

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

        var playerAbilityPanel = $.CreatePanel("Panel", currentPanel, "PlayerAbilityPanel_" + index);
        playerAbilityPanel.AddClass("PlayerAbilityPanel");
        playerAbilityPanel.positionOnScreen = positionOnScreen
        playerAbilityPanel.teamId = teamId

        var HeroIconAndHealthAndMana = $.CreatePanel("Image", playerAbilityPanel, "HeroIconAndHealthAndMana" + index);
        HeroIconAndHealthAndMana.AddClass("HeroIconAndHealthAndMana");

        var heroBriefIcon = $.CreatePanel("Image", HeroIconAndHealthAndMana, "HeroIcon_" + index);
        heroBriefIcon.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png")
        heroBriefIcon.AddClass("HeroIcon");
        heroBriefIcon.playerId = playerId;
        HeroIconEvent(heroBriefIcon, index)

        if (GameUI.CustomUIConfig().team_colors) {
            var teamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];
            if (teamColor) {
                heroBriefIcon.style.borderTop = "3px solid  " + teamColor;
            }
        }

        var BonusPlayerInformation = $.CreatePanel("Panel", HeroIconAndHealthAndMana, "BonusPlayerInformation" + index);
        BonusPlayerInformation.AddClass("BonusPlayerInformation");

        var HeroRank = $.CreatePanel("Panel", BonusPlayerInformation, "HeroRank" + index);
        HeroRank.AddClass("HeroRank");

        var rank_number = $.CreatePanel("Label", HeroRank, "rank_number" + index);
        rank_number.AddClass("rank_number");

        var HeroInfoAndRating = $.CreatePanel("Panel", BonusPlayerInformation, "HeroInfoAndRating" + index);
        HeroInfoAndRating.AddClass("HeroInfoAndRating");

        var HeroInfoLevel = $.CreatePanel("Panel", HeroInfoAndRating, "HeroInfoLevel" + index);
        HeroInfoLevel.AddClass("HeroInfoLevel");

        var LevelCircle = $.CreatePanel("Panel", HeroInfoLevel, "LevelCircle" + index);
        LevelCircle.AddClass("LevelCircle");

        var LevelLabel = $.CreatePanel("Label", LevelCircle, "LevelLabel" + index);
        LevelLabel.AddClass("LevelLabel");
        LevelLabel.text = playerInfo.player_level

        var GoldInfoLabel = $.CreatePanel("Panel", HeroInfoLevel, "GoldInfoLabel" + index);
        GoldInfoLabel.AddClass("GoldInfoLabel");

        var GoldInfoLabelText = $.CreatePanel("Label", HeroInfoLevel, "GoldInfoLabelText" + index);
        GoldInfoLabelText.AddClass("GoldInfoLabelText");

        var goldData = CustomNetTables.GetTableValue("player_info", playerId)
        if (goldData != undefined) {
            GoldInfoLabelText.text = goldData.gold
        } else {
            GoldInfoLabelText.text = 600
        }

        var GoldInfoIcon = $.CreatePanel("Panel", HeroInfoLevel, "GoldInfoIcon" + index);
        GoldInfoIcon.AddClass("GoldInfoIcon");

        var HeroInfoRating = $.CreatePanel("Panel", HeroInfoAndRating, "HeroInfoRating" + index);
        HeroInfoRating.AddClass("HeroInfoRating");

        var HeroInfoRatingLabel = $.CreatePanel("Label", HeroInfoRating, "HeroInfoRatingLabel" + index);
        HeroInfoRatingLabel.AddClass("HeroInfoRatingLabel");
        HeroInfoRatingLabel.text = ""

        var localPlayerId = Game.GetLocalPlayerInfo().player_id;

        var pass_info = CustomNetTables.GetTableValue("player_info", "pass_data_" + localPlayerId);

        //if (pass_info && (pass_info.pass_level_3_days > 0 || pass_info.pass_level_2_days > 0 || pass_info.pass_level_1_days > 0)) {
            var rank_info_duel = CustomNetTables.GetTableValue("cha_server_data", String(playerId));
            if (rank_info_duel) {
                HeroInfoRatingLabel.text = $.Localize("#score") + ":" + (rank_info_duel.mmr[5] || 0) + "     " + $.Localize("#games_duel") + ":" + (rank_info_duel.games[5] || 0);
                if ((rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0" && rank_info_duel.rating_number_in_top <= 10) && (rank_info_duel.mmr[5] || 2500) >= 5420) {
                    HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
                } else {
                    HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rank_info_duel.mmr[5] || 2500) + '.png")';
                }
                HeroRank.style.backgroundSize = "100%"
                if (rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0") {
                    rank_number.text = rank_info_duel.rating_number_in_top
                }
            }
        //} else {
        //    HeroInfoRatingLabel.style.opacity = "0"
        //    HeroRank.style.opacity = "0"
        //}

        var teamLogo = $.CreatePanel("Panel", heroBriefIcon, "");
        teamLogo.AddClass("TeamLogoBrief");

        var teamLogoShadow = $.CreatePanel("Image", teamLogo, "");
        teamLogoShadow.SetImage("file://{resources}/images/custom_game/team_icons/team_shield_shadow_01.psd")
        var teamLogoBorder = $.CreatePanel("Image", teamLogo, "");
        teamLogoBorder.SetImage("file://{resources}/images/custom_game/team_icons/team_shield_border_01.psd")
        var teamLogoColor = $.CreatePanel("Image", teamLogo, "");
        teamLogoColor.SetImage("file://{resources}/images/custom_game/team_icons/team_shield_color_01.psd")
        var teamLogoIcon = $.CreatePanel("Image", teamLogo, "");
        teamLogoIcon.SetImage("")
        teamLogoIcon.AddClass("TeamLogoBriefIcon")
        if (GameUI.CustomUIConfig().team_colors) {
            var teamColor = GameUI.CustomUIConfig().team_colors[teamId];
            if (teamColor) {
                teamLogoColor.style.washColor = teamColor;
            }
        }
        if (GameUI.CustomUIConfig().team_icons) {
            var teamIcon = GameUI.CustomUIConfig().team_icons[teamId];
            if (teamIcon) {
                teamLogoIcon.SetImage(teamIcon);
            }
        }

        var HealthAndManaPanel = $.CreatePanel("Image", playerAbilityPanel, "HealthAndManaPanel" + index);
        HealthAndManaPanel.AddClass("HealthAndManaPanel");

        var itemPanel = $.CreatePanel("Panel", playerAbilityPanel, "ItemPanel_" + index);
        itemPanel.AddClass("ItemPanel");

        var abilityPanel = $.CreatePanel("Panel", playerAbilityPanel, "AbilityPanel_" + index);
        abilityPanel.AddClass("AbilityPanel");

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

        var dotaSceneContainer = $.CreatePanel("Panel", healthProgressLeft, "");
        dotaSceneContainer.AddClass("DotaSceneContainer");
        var healthBarBurner = $.CreatePanel("Panel", dotaSceneContainer, "");
        healthBarBurner.BLoadLayoutSnippet("BarBurner");

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

        var dotaSceneManaContainer = $.CreatePanel("Panel", manaProgressLeft, "");
        dotaSceneManaContainer.AddClass("DotaSceneManaContainer");
        var manaBarBurner = $.CreatePanel("Panel", dotaSceneManaContainer, "");
        manaBarBurner.BLoadLayoutSnippet("BarBurner");


        $("#HealthLabel_" + index).text = Entities.GetHealth(heroIndex) + " / " + Entities.GetMaxHealth(heroIndex);
        $("#ManaLabel_" + index).text = Entities.GetMana(heroIndex) + " / " + Entities.GetMaxMana(heroIndex);

        var healthPercent = Entities.GetHealth(heroIndex) / Entities.GetMaxHealth(heroIndex);
        $("#HealthProgress_" + index).value = healthPercent;

        var manaPercent = Entities.GetMana(heroIndex) / Entities.GetMaxMana(heroIndex);
        $("#ManaProgress_" + index).value = manaPercent;
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

    $.Schedule(0.1, function() {
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
                    }

                    ability_panel.EntityAbilities = EntityAbilities;
                    ability_panel.EntityAbilitiesNames = EntityAbilitiesNames;

                    for (var i = 0; i < ability_panel.GetChildCount(); i++) 
                    {
                        var abilityPanel = ability_panel.GetChild(i);
                        let ability = abilityPanel.abilityId
                        var cooldown = Abilities.GetCooldownTimeRemaining(ability);
                        if (cooldown > 0) 
                        {
                            abilityPanel.FindChildTraverse("CooldownTimer").text = Math.ceil(cooldown);
                            abilityPanel.FindChildTraverse("CooldownOverlay").RemoveClass("Hidden");
                            var cooldownLength = Abilities.GetCooldownLength(ability);
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

                    if (!isEqual(EntityItemsNames, item_panel.EntityItemsNames) || item_panel.GetChildCount() <= 0 || NeutralItem !== item_panel.NeutralItem) 
                    {
                        item_panel.RemoveAndDeleteChildren()

                        let shard_and_scepter_upgrade_panel = $.CreatePanel("Panel", item_panel, "shard_and_scepter_upgrade_panel")
                        shard_and_scepter_upgrade_panel.style.width = "25px"
                        shard_and_scepter_upgrade_panel.style.height = "100%"
                        shard_and_scepter_upgrade_panel.style.marginRight = "3px"
                        shard_and_scepter_upgrade_panel.style.flowChildren = "down"

                        let scepter_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "scepter_upgrade_panel")
                        scepter_upgrade_panel.style.width = "40px"
                        scepter_upgrade_panel.style.height = "70%"
                        scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
                        scepter_upgrade_panel.style.backgroundSize = "100%"

                        let shard_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "shard_upgrade_panel")
                        shard_upgrade_panel.style.width = "40px"
                        shard_upgrade_panel.style.height = "30%"
                        shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
                        shard_upgrade_panel.style.backgroundSize = "100%"

                        for (k in EntityItems)
                        {
                            var item = EntityItems[k];
                            var itemName = Abilities.GetAbilityName(item);
                            let itemImage = $.CreatePanel("DOTAItemImage", item_panel, "");
                            itemImage.abilityId = item;
                            $.Msg("dadada", " ", itemImage.abilityId)
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

                    let scepter_upgrade_panel_new = item_panel.FindChildTraverse("scepter_upgrade_panel")
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

                    let shard_upgrade_panel_new = item_panel.FindChildTraverse("shard_upgrade_panel")
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
                                var cooldownLength = Abilities.GetCooldownLength(ability);
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

    $.Schedule(0.01, LocateVictoryParticle);
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

(function() {
    GameEvents.Subscribe("ShowPvpBrief", ShowPvpBrief);
    GameEvents.Subscribe("TeamWin", TeamWin);
    GameEvents.Subscribe("ShowVictoryParticle", ShowVictoryParticle);
    GameEvents.Subscribe("SetCameraFocus", SetCameraFocus);

    GameEvents.Subscribe("OpenTopInfo", OpenTopInfo);
    GameEvents.Subscribe("CloseTopInfo", CloseTopInfo);
    GameEvents.Subscribe("UpdateTopInfo", UpdateTopInfo);
})();