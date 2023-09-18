function ShowPvpBet(data) 
{
    var mainBetPanel = $("#BetMain")

    if (Game.GetMapInfo().map_display_name == "2x6") 
    {
        mainBetPanel.RemoveClass("BetMain")
        mainBetPanel.AddClass("BetMain2x6")
    } 
    else 
    {
        mainBetPanel.RemoveClass("BetMain2x6")
        mainBetPanel.AddClass("BetMain")
    }

    var firstTeamBetConfirn = null
    var secondTeamBetConfirn = null
    var firstTeamId = data.firstTeamId
    var secondTeamId = data.secondTeamId
    var currentPanel = null

    var firstTeamPanel = $.CreatePanel("Panel", mainBetPanel, "FirstTeam");
    firstTeamPanel.AddClass("TeamPanel");
    var firstTeamPanelLeft = $.CreatePanel("Panel", firstTeamPanel, "FirstTeamPanelLeft");
    firstTeamPanelLeft.AddClass("TeamPanelLeft");

    var vsImage = $.CreatePanel("Panel", mainBetPanel, "VsLogo");
    var panel_info_322 = $.CreatePanel("Panel", vsImage, "panel_info_322");
    var label_ban = $.CreatePanel("Label", panel_info_322, "label_ban");
    label_ban.text = $.Localize("#ban_duel_info_1")
    var image_ban = $.CreatePanel("Panel", panel_info_322, "image_ban");
    SetShowText(image_ban, $.Localize("#ban_duel_info_2"))

    var secondTeamPanel = $.CreatePanel("Panel", mainBetPanel, "SecondTeam");
    secondTeamPanel.AddClass("TeamPanel");
    var secondTeamPanelLeft = $.CreatePanel("Panel", secondTeamPanel, "SecondTeamPanelLeft");
    secondTeamPanelLeft.AddClass("TeamPanelLeft");
    var heroNumber = 0

    for (var index in data.players) 
    {
        var playerId = data.players[index].playerID;
        var playerInfo = Game.GetPlayerInfo(playerId);
        var teamId = data.players[index].teamID;
        heroNumber = heroNumber + 1

        if (teamId == firstTeamId) 
        {
            currentPanelLeft = firstTeamPanelLeft;
            currentPanel = firstTeamPanel;
        } 
        else 
        {
            currentPanelLeft = secondTeamPanelLeft;
            currentPanel = secondTeamPanel;
        }

        var playerPanel = $.CreatePanel("Panel", currentPanelLeft, "");
        playerPanel.AddClass("PlayerPanel");

        var playermainpanelwithbg = $.CreatePanel("Panel", playerPanel, "");
        playermainpanelwithbg.AddClass("playermainpanelwithbg");

        var playermainpanelbg = $.CreatePanel("Panel", playermainpanelwithbg, "");
        playermainpanelbg.AddClass("playermainpanelbg");
        playermainpanelbg.style.backgroundImage = 'url( "file://{images}/heroes/' + playerInfo.player_selected_hero + '.png" )';
        playermainpanelbg.style.backgroundSize = "100% 220px"

        var playerPanelShow = $.CreatePanel("Panel", playermainpanelwithbg, "");
        playerPanelShow.AddClass("PvpPlayerShowPanel");

        var playerPanelBet = $.CreatePanel("Panel", currentPanel, "BetPanel_" + index);
        playerPanelBet.AddClass("BetPanel");

        //var round_timer = $.CreatePanel("Label", playerPanelBet, "round_timer_"+index);
        //round_timer.html = true
        //round_timer.AddClass("round_timer");

        var BetBegins = $.CreatePanel("Label", playerPanelBet, "");
        BetBegins.html = true
        BetBegins.AddClass("BetBegins");
        BetBegins.text = $.Localize("#BetBegins")

        var playerPanelBetInput = $.CreatePanel("Panel", playerPanelBet, "");
        playerPanelBetInput.AddClass("BetPanelInput");

        var PlayerBetSetPercentageMain = $.CreatePanel("Panel", playerPanelBet, "");
        PlayerBetSetPercentageMain.AddClass("PlayerBetSetPercentageMain");

        playerPanelBetTextPanel = $.CreatePanel("Panel", playerPanelBetInput, "BetTextEntryPanel_" + index);
        playerPanelBetTextPanel.BLoadLayoutSnippet("BetTextEntry")
        playerPanelBetTextPanel.FindChild("BetTextEntry").teamId = teamId;

        var playerPanelBetText = playerPanelBetTextPanel.FindChild("BetTextEntry");
        playerPanelBetText.teamId = teamId;
        BetTextChangedEvent(playerPanelBetTextPanel.FindChild("BetTextEntry"), index)

        var playerPanelBetAdjust = $.CreatePanel("Panel", playerPanelBetInput, "");
        playerPanelBetAdjust.AddClass("BetAdjustPanel");

        var playerPanelBetAdjustUp = $.CreatePanel("Button", playerPanelBetAdjust, "BetAdjustUp_" + index);
        playerPanelBetAdjustUp.AddClass("BetAdjustUp");

        var playerPanelBetAdjustDown = $.CreatePanel("Button", playerPanelBetAdjust, "BetAdjustDown_" + index);
        playerPanelBetAdjustDown.AddClass("BetAdjustDown");


        var arrow_up = $.CreatePanel("Panel", playerPanelBetAdjustUp, "");
        arrow_up.AddClass("arrow_up");
        var arrow_down = $.CreatePanel("Panel", playerPanelBetAdjustDown, "");
        arrow_down.AddClass("arrow_down");


        var playerPanelBetAlert = $.CreatePanel("Label", playerPanelBet, "BetAlertLabel_" + index);
        playerPanelBetAlert.AddClass("BetAlertLabel");
        playerPanelBetAlert.AddClass("Hidden");

        updateAdjuctEvent(playerPanelBetAdjustUp, playerPanelBetAdjustDown, playerPanelBetText, playerPanelBetAlert)

        var playerPanelBetConfirn = $.CreatePanel("Button", playerPanelBet, "BetConfirmButton_" + index);
        playerPanelBetConfirn.AddClass("BetConfirmButton");

        var BetConfirmButton_visual = $.CreatePanel("Panel", playerPanelBetConfirn, "BetConfirmButton_visual_" + index);
        BetConfirmButton_visual.AddClass("BetConfirmButton_visual");

        ConfirmBetEvent(playerPanelBetConfirn, teamId, index)

        var playerPanelBetConfirnText = $.CreatePanel("Label", playerPanelBetConfirn, "BetConfirmButtonLabel_" + index);
        playerPanelBetConfirnText.html = true
        playerPanelBetConfirnText.AddClass("BetConfirmButtonLabel");
        playerPanelBetConfirnText.text = $.Localize("#confirm")



        //////////////////////////////////////////////////////

        var PlayerBetSetPercentageButton_20 = $.CreatePanel("Panel", PlayerBetSetPercentageMain, "");
        PlayerBetSetPercentageButton_20.AddClass("PlayerBetSetPercentageButton");
        MaxBetEventCurrent(PlayerBetSetPercentageButton_20, teamId, index, playerPanelBetText, 10)

        var PlayerBetSetPercentageButton_20_label = $.CreatePanel("Label", PlayerBetSetPercentageButton_20, "");
        PlayerBetSetPercentageButton_20_label.AddClass("PlayerBetSetPercentageButton_10_label");
        PlayerBetSetPercentageButton_20_label.text = "10%"

        var PlayerBetSetPercentageButton_30 = $.CreatePanel("Panel", PlayerBetSetPercentageMain, "");
        PlayerBetSetPercentageButton_30.AddClass("PlayerBetSetPercentageButton");
        MaxBetEventCurrent(PlayerBetSetPercentageButton_30, teamId, index, playerPanelBetText, 20)

        var PlayerBetSetPercentageButton_30_label = $.CreatePanel("Label", PlayerBetSetPercentageButton_30, "");
        PlayerBetSetPercentageButton_30_label.AddClass("PlayerBetSetPercentageButton_10_label");
        PlayerBetSetPercentageButton_30_label.text = "20%"

        var PlayerBetSetPercentageButton_40 = $.CreatePanel("Panel", PlayerBetSetPercentageMain, "");
        PlayerBetSetPercentageButton_40.AddClass("PlayerBetSetPercentageButton");
        MaxBetEventCurrent(PlayerBetSetPercentageButton_40, teamId, index, playerPanelBetText, 30)

        var PlayerBetSetPercentageButton_40_label = $.CreatePanel("Label", PlayerBetSetPercentageButton_40, "");
        PlayerBetSetPercentageButton_40_label.AddClass("PlayerBetSetPercentageButton_10_label");
        PlayerBetSetPercentageButton_40_label.text = "30%"

        var PlayerBetSetPercentageButton_50 = $.CreatePanel("Panel", PlayerBetSetPercentageMain, "");
        PlayerBetSetPercentageButton_50.AddClass("PlayerBetSetPercentageButton");
        MaxBetEventCurrent(PlayerBetSetPercentageButton_50, teamId, index, playerPanelBetText, 40)

        var PlayerBetSetPercentageButton_50_label = $.CreatePanel("Label", PlayerBetSetPercentageButton_50, "");
        PlayerBetSetPercentageButton_50_label.AddClass("PlayerBetSetPercentageButton_10_label");
        PlayerBetSetPercentageButton_50_label.text = "40%"

        var PlayerBetSetPercentageButton_Max = $.CreatePanel("Panel", PlayerBetSetPercentageMain, "");
        PlayerBetSetPercentageButton_Max.AddClass("PlayerBetSetPercentageButtonMax");
        MaxBetEvent(PlayerBetSetPercentageButton_Max, teamId, index, playerPanelBetText)

        var PlayerBetSetPercentageButton_Max_Label = $.CreatePanel("Label", PlayerBetSetPercentageButton_Max, "");
        PlayerBetSetPercentageButton_Max_Label.AddClass("PlayerBetSetPercentageButton_10_label");
        PlayerBetSetPercentageButton_Max_Label.style.textTransform = "uppercase"
        PlayerBetSetPercentageButton_Max_Label.text = $.Localize("#max_bet")

        var heroInfo = $.CreatePanel("Panel", playerPanelShow, "");
        heroInfo.AddClass("HeroInfo");

        var heroInfoPlayer = $.CreatePanel("Label", heroInfo, "");
        heroInfoPlayer.AddClass("PlayerName");

        var HeroRank = $.CreatePanel("Panel", heroInfo, "HeroRank" + index);
        HeroRank.AddClass("HeroRank");

        var rank_number = $.CreatePanel("Label", HeroRank, "rank_number" + index);
        rank_number.AddClass("rank_number");

        var HeroInfoRating = $.CreatePanel("Panel", heroInfo, "HeroInfoRating" + index);
        HeroInfoRating.AddClass("HeroInfoRating");

        var HeroInfoRatingLabel = $.CreatePanel("Label", HeroInfoRating, "HeroInfoRatingLabel" + index);
        HeroInfoRatingLabel.AddClass("HeroInfoRatingLabel");
        HeroInfoRatingLabel.text = ""

        var rank_info_duel = CustomNetTables.GetTableValue("cha_server_data", String(playerId));
        if (rank_info_duel) {
            HeroInfoRatingLabel.text = $.Localize("#score") + ": " + (rank_info_duel.mmr[7] || 0) + "  " + $.Localize("#games_duel") + ": " + (rank_info_duel.games[7] || 0);

            if ((rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0" && rank_info_duel.rating_number_in_top <= 10) && (rank_info_duel.mmr[7] || 2500) >= 5420) {
                HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
            } else {
                HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rank_info_duel.mmr[7] || 0) + '.png")';
            }

            HeroRank.style.backgroundSize = "100%"

            if (rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0") {
                rank_number.text = rank_info_duel.rating_number_in_top
            }
            HeroInfoRatingLabel.style.opacity = "1"
            HeroRank.style.opacity = "1"
        }

        var logoAndHeroPanel = $.CreatePanel("Panel", playerPanelShow, "");
        logoAndHeroPanel.AddClass("LogoAndHeroPanel");

        LogoAndHeroPanelEvent(logoAndHeroPanel, index)

        var BonusPlayerInformation = $.CreatePanel("Panel", logoAndHeroPanel, "BonusPlayerInformation" + index);
        BonusPlayerInformation.AddClass("BonusPlayerInformation");

        var heroInfoHeroName = $.CreatePanel("Label", BonusPlayerInformation, "");
        heroInfoHeroName.AddClass("HeroName");

        var LevelLabel = $.CreatePanel("Label", BonusPlayerInformation, "LevelLabel" + index);
        LevelLabel.AddClass("LevelLabel");
        LevelLabel.text = playerInfo.player_level + $.Localize("#duel_level")

        var GoldInfoIcon = $.CreatePanel("Panel", BonusPlayerInformation, "GoldInfoIcon" + index);
        GoldInfoIcon.AddClass("GoldInfoIcon");

        var GoldInfoLabelText = $.CreatePanel("Label", BonusPlayerInformation, "GoldInfoLabelText" + index);
        GoldInfoLabelText.AddClass("GoldInfoLabelText");

        var goldData = CustomNetTables.GetTableValue("player_info", playerId)

        if (goldData != undefined) 
        {
            GoldInfoLabelText.text = goldData.gold
        } 
        else 
        {
            GoldInfoLabelText.text = 600
        }

        var HealthAndManaPanelWitchScepter = $.CreatePanel("Panel", playerPanelShow, "HealthAndManaPanel" + index);
        HealthAndManaPanelWitchScepter.AddClass("HealthAndManaPanelWitchScepter");

        var HealthAndManaPanel = $.CreatePanel("Panel", HealthAndManaPanelWitchScepter, "HealthAndManaPanel" + index);
        HealthAndManaPanel.AddClass("HealthAndManaPanel");

        var healthContainer = $.CreatePanel("Panel", HealthAndManaPanel, "HealthContainer_" + index);
        healthContainer.AddClass("HealthContainer");
        healthContainer.playerId = playerId

        var healthLabel = $.CreatePanel("Label", healthContainer, "HealthLabel_" + index);
        healthLabel.AddClass("HealthLabel");

        var healthProgress = $.CreatePanel("ProgressBar", healthContainer, "HealthProgress_" + index);
        healthProgress.AddClass("HealthProgress");

        var manaContainer = $.CreatePanel("Panel", HealthAndManaPanel, "ManaContainer_" + index);
        manaContainer.AddClass("ManaContainer");
        manaContainer.playerId = playerId

        var manaLabel = $.CreatePanel("Label", manaContainer, "ManaLabel_" + index);
        manaLabel.AddClass("ManaLabel");

        var manaProgress = $.CreatePanel("ProgressBar", manaContainer, "ManaProgress_" + index);
        manaProgress.AddClass("ManaProgress");

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

        var localPlayerId = Game.GetLocalPlayerInfo().player_id;

        var heroIcon = $.CreatePanel("Image", logoAndHeroPanel, "HeroIcon_" + index);
        heroIcon.AddClass("HeroIconInBet");
        heroIcon.playerId = playerId;

        var playerHeroIndexHealth = Players.GetPlayerHeroEntityIndex(playerId);

        $("#HealthLabel_" + index).text = Entities.GetHealth(playerHeroIndexHealth) + " / " + Entities.GetMaxHealth(playerHeroIndexHealth);
        $("#ManaLabel_" + index).text = Entities.GetMana(playerHeroIndexHealth) + " / " + Entities.GetMaxMana(playerHeroIndexHealth);

        var itemPanel = $.CreatePanel("Panel", playerPanelShow, "ItemPanel_" + index);
        itemPanel.AddClass("ItemPanel");

        var abilityPanel = $.CreatePanel("Panel", playerPanelShow, "AbilityPanel_" + index);
        abilityPanel.AddClass("AbilityPanel");

        var SkillPanel = $.CreatePanel("Panel", playerPanelShow, "SkillBlock" + index);
        SkillPanel.AddClass("SkillPanelBlock");

        var localTeamId = Game.GetPlayerInfo(Players.GetLocalPlayer()).player_team_id;

        if (localTeamId == firstTeamId || localTeamId == secondTeamId) {
            playerPanelBet.AddClass("BetPanelHide")
            if (playerId == Game.GetLocalPlayerID()) 
            {
                heroInfoPlayer.text = playerInfo.player_name + GetEarlyLeaver(playerId) + " " + $.Localize("#you");
            } else {
                heroInfoPlayer.text = playerInfo.player_name + GetEarlyLeaver(playerId);
            }
        } else {
            heroInfoPlayer.text = playerInfo.player_name + GetEarlyLeaver(playerId);
        }

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

        if (firstTeamBetConfirn == null && (teamId == firstTeamId)) 
        {
            firstTeamBetConfirn = playerPanelBet
        } else if (firstTeamBetConfirn != null && (teamId == firstTeamId)) 
        {
            firstTeamBetConfirn.AddClass("BetPanelHide")
        }

        if (secondTeamBetConfirn == null && (teamId == secondTeamId)) 
        {
            secondTeamBetConfirn = playerPanelBet
        } else if (secondTeamBetConfirn != null && (teamId == secondTeamId)) 
        {
            secondTeamBetConfirn.AddClass("BetPanelHide")
        }

        heroIcon.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png");
        heroIcon.playerId = playerId;
        heroInfoHeroName.text = $.Localize("#" + playerInfo.player_selected_hero);

        var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);

        let abilityIndex = 0;
    }

    $.Schedule(0.5, function() 
    {
        UpdatePVPPanel(heroNumber)
    });

    $("#BetMain").RemoveClass("Hidden");
}

function UpdatePVPPanel(heroNumber) 
{
    if ($("#FirstTeam") != null) 
    {
        if (!$("#BetMain").BHasClass("Hidden")) 
        {
            $.Schedule(0.5, function() 
            {
                UpdatePVPPanel(heroNumber)
            });
        }

        for (var index = 1; index <= heroNumber; index++) 
        {
            if ($("#HeroIcon_" + index) != undefined) 
            {
                var playerId = $("#HeroIcon_" + index).playerId;
                var heroIndex = Players.GetPlayerHeroEntityIndex(playerId);
                var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);
                var playerInfo = Game.GetPlayerInfo(playerId);
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

                UpdateHeroHudBuffs(index);

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
                            ability_box.BLoadLayoutSnippet("AbilityBox")
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
                        }
                        let hidden_abil_spawn = 6 - EntityAbilities.length
                        if (hidden_abil_spawn > 0)
                        {
                            for (var ddd = 0; ddd < hidden_abil_spawn; ddd++) 
                            {
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

                                $.Msg(cooldownLength, " ", cooldown)

                                if (cooldownLength > 0) 
                                {
                                    let angle = cooldown / cooldownLength * -360;
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
                }
            }
        }
    }
}

function HidePvpBet() 
{
    $("#BetMain").AddClass("Hidden");

    for (var k in $("#BetMain").Children()) 
    {
        var panel = $("#BetMain").Children()[k];
        panel.DeleteAsync(0.0)
    }

    for (var x = 1; x < 20; x++) 
    {
        var aPanel = $("#AbilityPanel_" + x)
        if (aPanel != null) {
            aPanel.RemoveAndDeleteChildren()
        }
        var iPanel = $("#ItemPanel_" + x)
        if (iPanel != null) {
            iPanel.RemoveAndDeleteChildren()
        }
    }
}

// Не трогать

function MaxBetEvent(playerPanelBetMax, teamId, index, playerPanelBetText) {
    playerPanelBetMax.SetPanelEvent("onactivate", function() {
        var playerId = Game.GetLocalPlayerID();
        var maxGold = Math.floor(Players.GetGold(playerId) / 2);
        playerPanelBetText.text = maxGold;
    })
}

function MaxBetEventCurrent(playerPanelBetMax, teamId, index, playerPanelBetText, current) {
    playerPanelBetMax.SetPanelEvent("onactivate", function() {
        var playerId = Game.GetLocalPlayerID();
        var maxGold = Math.floor(Players.GetGold(playerId) / 100 * current);
        playerPanelBetText.text = maxGold;
    })
}

function BetTextChangedEvent(textEntry, index) {
    textEntry.SetPanelEvent("ontextentrychange", function() {
        BetTextChanged(index)
    })
}

function BetTextChanged(index) {

    var playerId = Game.GetLocalPlayerID();
    var maxGold = Math.floor(Players.GetGold(playerId) / 2);

    var panel = $("#BetTextEntryPanel_" + index).FindChild("BetTextEntry")
    var alertPanel = $("#BetAlertLabel_" + index)

    var text = panel.text

    for (var i = 1; i <= 4; i++) {
        if ((i + "") != index && text != "") {
            if ($("#BetTextEntryPanel_" + i) != undefined) {
                $("#BetTextEntryPanel_" + i).FindChild("BetTextEntry").text = ""
            }
        }
    }

    if (text.indexOf(".") != -1) {
        text = text.replace(".", "");
        panel.text = text;
        alertPanel.RemoveClass("Hidden");
        alertPanel.text = $.Localize("#bet_must_positive_integer");
        return
    }

    if (text.indexOf("-") != -1) {
        panel.text = "";
        alertPanel.RemoveClass("Hidden");
        alertPanel.text = $.Localize("#bet_must_positive_integer");
        return
    }

    if (parseInt(text) > maxGold) {
        panel.text = maxGold;
        alertPanel.RemoveClass("Hidden");
        alertPanel.text = $.Localize("#bet_max_gold");
        return
    }

    alertPanel.AddClass("Hidden");
}

function updateAdjuctEvent(upPanel, downPanel, focusPanel, alertPanel) {
    upPanel.SetPanelEvent("onactivate", function() {
        var playerId = Game.GetLocalPlayerID();
        var maxGold = Math.floor(Players.GetGold(playerId) / 2);
        var multiple = Math.floor(maxGold / 10 / 100);
        if (multiple < 1) {
            multiple = 1;
        }
        var slice = multiple * 100;
        var text = focusPanel.text;
        var value = 0
        if (text != "") {
            value = parseInt(text)
        }
        value = value + slice;
        if (value > maxGold) {
            alertPanel.RemoveClass("Hidden");
            alertPanel.text = $.Localize("#bet_max_gold");
            value = maxGold;
        } else {
            alertPanel.AddClass("Hidden");
        }
        focusPanel.text = value;
    })
    downPanel.SetPanelEvent("onactivate", function() {
        var playerId = Game.GetLocalPlayerID();
        var maxGold = Math.floor(Players.GetGold(playerId) / 2);
        var multiple = Math.floor(maxGold / 10 / 100);
        if (multiple < 1) {
            multiple = 1;
        }
        var slice = multiple * 100;
        var text = focusPanel.text;
        var value = 0
        if (text != "") {
            value = parseInt(text)
        }
        value = value - slice;
        if (value < 0) {
            alertPanel.RemoveClass("Hidden");
            alertPanel.text = $.Localize("#bet_must_positive_integer");
            value = 0;
        } else {
            alertPanel.AddClass("Hidden");
        }

        focusPanel.text = value;
    })
}

//Player gold coins change Adjust input box
function UpdateBetInput() {
    var playerId = Game.GetLocalPlayerID();
    var maxGold = Math.floor(Players.GetGold(playerId) / 2);
    for (var index = 1; index <= 10; index++) 
    {
        if ($("#BetTextEntryPanel_" + index) != null) {
            var text = $("#BetTextEntryPanel_" + index).FindChild("BetTextEntry").text;
            if (text != "") {
                if (parseInt(text) > maxGold) {
                    $("#BetTextEntryPanel_" + index).FindChild("BetTextEntry").text = maxGold;
                }
            }
        }
    }
}

function UpdateConfirmButton(keys) 
{
    let total = keys.totalTime - 1
    let cur = total - keys.currentTime
    for (var i = 1; i <= 4; i++) {
        if ($("#BetConfirmButton_visual_" + i) != undefined) 
        {
            let percent = ((total - cur) * 100) / total
            $("#BetConfirmButton_visual_" + i).style['width'] = (100 - percent) + '%';
        }
        if ($("#BetConfirmButtonLabel_" + i) != undefined) 
        {
            $("#BetConfirmButtonLabel_" + i).text = $.Localize("#confirm") + ": " + (keys.totalTime - keys.currentTime)
        }
    }
}

function LogoAndHeroPanelEvent(logoAndHeroPanel, index) {
    logoAndHeroPanel.SetPanelEvent("onactivate", function() {
        HeroIconClicked(index, false)
    })
    logoAndHeroPanel.SetPanelEvent("ondblclick", function() {
        HeroIconClicked(index, true)
    })
}

function ConfirmBetEvent(playerPanelBetConfirn, teamId, index) {
    playerPanelBetConfirn.SetPanelEvent("onactivate", function() {
        if ($("#BetTextEntryPanel_" + index).FindChild("BetTextEntry").text != "") {
            ConfirmBet(teamId, index)
        }
    })
}

function ConfirmBet(teamId, index) {
    var value = 0;
    HidePvpBet()
    var betValuePane = $("#BetTextEntryPanel_" + index).FindChild("BetTextEntry")
    value = parseInt(betValuePane.text);

    if (value > 0 && teamId != undefined) {
        GameEvents.SendCustomGameEventToServer("ConfirmBet", {
            value: value,
            wish_team_id: teamId,
            bet_ui_secret: $("#BetMain").bet_ui_secret
        });
    }
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

function UpdateHeroHudBuffs(index) 
{
    if ($("#SkillBlock"+index) == null)
    {
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
    if (this_skill) 
    {
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

function BetInit() {
    GameEvents.Subscribe("UpdateBetInput", UpdateBetInput);
    GameEvents.Subscribe("HidePvpBet", HidePvpBet);
    GameEvents.Subscribe("UpdateConfirmButton", UpdateConfirmButton);
    GameEvents.Subscribe("ShowPvpBet", ShowPvpBet);
}
BetInit()