function ShowPvpBet(data) {
  if (FindDotaHudElement("minimap_container").BHasClass("HUDFlipped"))
  {

  }

  var mainBetPanel = $("#BetMain")

  if (Game.GetMapInfo().map_display_name=="2x6")
  {
      mainBetPanel.RemoveClass("BetMain")
      mainBetPanel.AddClass("BetMain2x6")
  } else {
    mainBetPanel.RemoveClass("BetMain2x6")
    mainBetPanel.AddClass("BetMain")
  }

  mainBetPanel.bet_ui_secret = data.bet_ui_secret

  var firstTeamBetConfirn = null

  var secondTeamBetConfirn = null

  var firstTeamId = data.firstTeamId

  var secondTeamId = data.secondTeamId

  var currentPanel = null

  var firstTeamPanel = $.CreatePanel("Panel", mainBetPanel, "FirstTeam");
  firstTeamPanel.AddClass("TeamPanel");

  var firstTeamPanelLeft =  $.CreatePanel("Panel", firstTeamPanel, "FirstTeamPanelLeft");
  firstTeamPanelLeft.AddClass("TeamPanelLeft");

  var vsImage = $.CreatePanel("Panel", mainBetPanel, "VsLogo");

  var vsImageSrc = $.CreatePanel("Image", vsImage, "");

  vsImageSrc.SetImage("file://{resources}/images/custom_game/duel_bg.png")

  var secondTeamPanel = $.CreatePanel("Panel", mainBetPanel, "SecondTeam");
  secondTeamPanel.AddClass("TeamPanel");

  var secondTeamPanelLeft =  $.CreatePanel("Panel", secondTeamPanel, "SecondTeamPanelLeft");
  secondTeamPanelLeft.AddClass("TeamPanelLeft");

  var heroNumber = 0

  for(var index in data.players)
  {
      var playerId = data.players[index].playerID;
      var playerInfo = Game.GetPlayerInfo( playerId );
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

      var playerPanelShow = $.CreatePanel("Panel", playerPanel, "");
      playerPanelShow.AddClass("PvpPlayerShowPanel");

      var playerPanelBet = $.CreatePanel("Panel", currentPanel, "BetPanel_"+index);
      playerPanelBet.AddClass("BetPanel");

      var playerPanelBetInput = $.CreatePanel("Panel", playerPanelBet, "");
      playerPanelBetInput.AddClass("BetPanelInput");

      var PlayerBetSetPercentageMain = $.CreatePanel("Panel", playerPanelBet, "");
      PlayerBetSetPercentageMain.AddClass("PlayerBetSetPercentageMain");


      playerPanelBetTextPanel=$.CreatePanel("Panel", playerPanelBetInput, "BetTextEntryPanel_"+index);
      playerPanelBetTextPanel.BLoadLayoutSnippet("BetTextEntry")
      playerPanelBetTextPanel.FindChild("BetTextEntry").teamId = teamId;

      var playerPanelBetText = playerPanelBetTextPanel.FindChild("BetTextEntry");
      playerPanelBetText.teamId = teamId;
      BetTextChangedEvent(playerPanelBetTextPanel.FindChild("BetTextEntry"), index)

      var playerPanelBetAdjust = $.CreatePanel("Panel", playerPanelBetInput, "");
      playerPanelBetAdjust.AddClass("BetAdjustPanel");

      var playerPanelBetAdjustUp = $.CreatePanel("Button", playerPanelBetAdjust, "BetAdjustUp_"+index);
      playerPanelBetAdjustUp.AddClass("BetAdjustUp");

      var playerPanelBetAdjustDown = $.CreatePanel("Button", playerPanelBetAdjust, "BetAdjustDown_"+index);
      playerPanelBetAdjustDown.AddClass("BetAdjustDown");

      var playerPanelBetAlert = $.CreatePanel("Label", playerPanelBet, "BetAlertLabel_"+index);
      playerPanelBetAlert.AddClass("BetAlertLabel");
      playerPanelBetAlert.AddClass("Hidden");

      updateAdjuctEvent(playerPanelBetAdjustUp, playerPanelBetAdjustDown, playerPanelBetText, playerPanelBetAlert)

      var playerPanelBetConfirn = $.CreatePanel("Button", playerPanelBet, "BetConfirmButton_"+index);
      playerPanelBetConfirn.AddClass("BetConfirmButton");
      ConfirmBetEvent(playerPanelBetConfirn, teamId, index)

      var playerPanelBetConfirnText = $.CreatePanel("Label", playerPanelBetConfirn, "BetConfirmButtonLabel_"+index);
      playerPanelBetConfirnText.html = true
      playerPanelBetConfirnText.AddClass("BetConfirmButtonLabel");
      playerPanelBetConfirnText.text = $.Localize("#confirm")

      var playerPanelBetMax = $.CreatePanel("Button", playerPanelBetInput, "BetMaxButton_"+index);
      playerPanelBetMax.AddClass("BetMaxButton");
      MaxBetEvent(playerPanelBetMax, teamId, index, playerPanelBetText)
    

      var playerPanelBetMaxText = $.CreatePanel("Label", playerPanelBetMax, "BetMaxButtonLabel_"+index);
      playerPanelBetMaxText.AddClass("BetMaxButtonLabel");
      playerPanelBetMaxText.text = $.Localize("#max_bet")

      //////////////////////////////////////////////////////

      var PlayerBetSetPercentageButton_10 = $.CreatePanel("Panel", PlayerBetSetPercentageMain, "");
      PlayerBetSetPercentageButton_10.AddClass("PlayerBetSetPercentageButton");
      MaxBetEventCurrent(PlayerBetSetPercentageButton_10, teamId, index, playerPanelBetText, 5)
  
      var PlayerBetSetPercentageButton_10_label = $.CreatePanel("Label", PlayerBetSetPercentageButton_10, "");
      PlayerBetSetPercentageButton_10_label.AddClass("PlayerBetSetPercentageButton_10_label");
      PlayerBetSetPercentageButton_10_label.text = "5%"
  
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

      //////////////////////////////////////////////////////





    //-------------------

    var heroInfo = $.CreatePanel("Panel", playerPanelShow, "");
    heroInfo.AddClass("HeroInfo");

    var heroInfoPlayer = $.CreatePanel("Label", heroInfo, "");
    heroInfoPlayer.AddClass("PlayerName");

    var heroInfoHeroName = $.CreatePanel("Label", heroInfo, "");
    heroInfoHeroName.AddClass("HeroName");

    var logoAndHeroPanel = $.CreatePanel("Panel", playerPanelShow, "");
    logoAndHeroPanel.AddClass("LogoAndHeroPanel");

    LogoAndHeroPanelEvent(logoAndHeroPanel, index)

    var BonusPlayerInformation = $.CreatePanel("Panel", logoAndHeroPanel, "BonusPlayerInformation"+index);
    BonusPlayerInformation.AddClass("BonusPlayerInformation");

    var HeroRank = $.CreatePanel("Panel", BonusPlayerInformation, "HeroRank"+index);
    HeroRank.AddClass("HeroRank");

    var rank_number = $.CreatePanel("Label", HeroRank, "rank_number"+index);
    rank_number.AddClass("rank_number");

    var HeroInfoAndRating = $.CreatePanel("Panel", BonusPlayerInformation, "HeroInfoAndRating"+index);
    HeroInfoAndRating.AddClass("HeroInfoAndRating");

    var HeroInfoLevel = $.CreatePanel("Panel", HeroInfoAndRating, "HeroInfoLevel"+index);
    HeroInfoLevel.AddClass("HeroInfoLevel");

    var LevelCircle = $.CreatePanel("Panel", HeroInfoLevel, "LevelCircle"+index);
    LevelCircle.AddClass("LevelCircle");

    var LevelLabel = $.CreatePanel("Label", LevelCircle, "LevelLabel"+index);
    LevelLabel.AddClass("LevelLabel");
    LevelLabel.text = playerInfo.player_level

    var GoldInfoLabel = $.CreatePanel("Panel", HeroInfoLevel, "GoldInfoLabel"+index);
    GoldInfoLabel.AddClass("GoldInfoLabel");

    var GoldInfoLabelText = $.CreatePanel("Label", HeroInfoLevel, "GoldInfoLabelText"+index);
    GoldInfoLabelText.AddClass("GoldInfoLabelText");

    var goldData = CustomNetTables.GetTableValue( "player_info", playerId )

    if (goldData!=undefined) 
    {
       GoldInfoLabelText.text = goldData.gold
    } 
    else
    {
       GoldInfoLabelText.text = 600
    }

    var GoldInfoIcon= $.CreatePanel("Panel", HeroInfoLevel, "GoldInfoIcon"+index);
    GoldInfoIcon.AddClass("GoldInfoIcon");

    var HeroInfoRating = $.CreatePanel("Panel", HeroInfoAndRating, "HeroInfoRating"+index);
    HeroInfoRating.AddClass("HeroInfoRating");

    var HeroInfoRatingLabel = $.CreatePanel("Label", HeroInfoRating, "HeroInfoRatingLabel"+index);
    HeroInfoRatingLabel.AddClass("HeroInfoRatingLabel");
    HeroInfoRatingLabel.text = ""

    var localPlayerId = Game.GetLocalPlayerInfo().player_id;

    var pass_info = CustomNetTables.GetTableValue("player_info", "pass_data_"+localPlayerId);

    if (pass_info && (pass_info.pass_level_3_days > 0 || pass_info.pass_level_2_days > 0 || pass_info.pass_level_1_days > 0 ))
    {
      var rank_info_duel = CustomNetTables.GetTableValue("cha_server_data", String(playerId));
      if (rank_info_duel)
      {
          HeroInfoRatingLabel.text = $.Localize("#score")+":"+(rank_info_duel.mmr[3] || 0) +"     "+$.Localize("#games_duel")+":"+(rank_info_duel.games[3] || 0);

          if ( (rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0" && rank_info_duel.rating_number_in_top <= 10) && (rank_info_duel.mmr[3] || 2500) >= 5420)
          {
              HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
          } else {
              HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rank_info_duel.mmr[3] || 0) + '.png")';
          }

          HeroRank.style.backgroundSize = "100%"

          if (rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0")
          {
              rank_number.text = rank_info_duel.rating_number_in_top
          }
          HeroInfoRatingLabel.style.opacity = "1"
          HeroRank.style.opacity = "1"
      }
    } else {
      HeroInfoRatingLabel.style.opacity = "0"
      HeroRank.style.opacity = "0"
    }

    var HealthAndManaPanel = $.CreatePanel("Image", playerPanelShow, "HealthAndManaPanel"+index);
    HealthAndManaPanel.AddClass("HealthAndManaPanel");

    var healthContainer = $.CreatePanel("Panel", HealthAndManaPanel, "HealthContainer_"+index);
    healthContainer.AddClass("HealthContainer");
    healthContainer.playerId = playerId

    var healthLabel = $.CreatePanel("Label", healthContainer, "HealthLabel_"+index);
    healthLabel.AddClass("HealthLabel");

    var healthProgress = $.CreatePanel("ProgressBar", healthContainer, "HealthProgress_"+index);
    healthProgress.AddClass("HealthProgress");

    var manaContainer = $.CreatePanel("Panel", HealthAndManaPanel, "ManaContainer_"+index);
    manaContainer.AddClass("ManaContainer");
    manaContainer.playerId = playerId

    var manaLabel = $.CreatePanel("Label", manaContainer, "ManaLabel_"+index);
    manaLabel.AddClass("ManaLabel");

    var manaProgress = $.CreatePanel("ProgressBar", manaContainer, "ManaProgress_"+index);
    manaProgress.AddClass("ManaProgress");

    var localPlayerId = Game.GetLocalPlayerInfo().player_id;

    var heroIcon = $.CreatePanel("Image", logoAndHeroPanel, "HeroIcon_"+index);
    heroIcon.AddClass("HeroIconInBet");
    heroIcon.SetImage("file://{images}/heroes/npc_dota_hero_abaddon.png")
    heroIcon.playerId = playerId;

    var playerHeroIndexHealth = Players.GetPlayerHeroEntityIndex(playerId);

    $("#HealthLabel_"+index).text = Entities.GetHealth(playerHeroIndexHealth)+" / "+Entities.GetMaxHealth(playerHeroIndexHealth);
    $("#ManaLabel_"+index).text = Entities.GetMana(playerHeroIndexHealth)+" / "+Entities.GetMaxMana(playerHeroIndexHealth);

    if ( GameUI.CustomUIConfig().team_colors )
    {
        var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
        if ( teamColor )
        {
          heroIcon.style.borderTop = "3px solid  " + teamColor;
        }
    }

    var teamLogo = $.CreatePanel("Panel", heroIcon, "");
    teamLogo.AddClass("TeamLogo");

    var teamLogoShadow = $.CreatePanel("Image", teamLogo, "");
    teamLogoShadow.SetImage("file://{resources}/images/custom_game/team_icons/team_shield_shadow_01.psd")

    var teamLogoBorder = $.CreatePanel("Image", teamLogo, "");
    teamLogoBorder.SetImage("file://{resources}/images/custom_game/team_icons/team_shield_border_01.psd")

    var teamLogoColor = $.CreatePanel("Image", teamLogo, "");
    teamLogoColor.SetImage("file://{resources}/images/custom_game/team_icons/team_shield_color_01.psd")

    var teamLogoIcon = $.CreatePanel("Image", teamLogo, "");
    teamLogoIcon.SetImage("")
    teamLogoIcon.AddClass("TeamLogoIcon")

    var itemPanel = $.CreatePanel("Panel", playerPanelShow, "ItemPanel_"+index);
    itemPanel.AddClass("ItemPanel");

    var abilityPanel = $.CreatePanel("Panel", playerPanelShow, "AbilityPanel_"+index);
    abilityPanel.AddClass("AbilityPanel");

    var localTeamId = Game.GetPlayerInfo(Players.GetLocalPlayer()).player_team_id;

    if ( localTeamId == firstTeamId || localTeamId == secondTeamId ) 
    {
      playerPanelBet.AddClass("BetPanelHide")
      if (playerId == Game.GetLocalPlayerID())
      {
        heroInfoPlayer.text = playerInfo.player_name+GetEarlyLeaver(playerId)+" "+$.Localize("#you");
      }else{
        heroInfoPlayer.text = playerInfo.player_name+GetEarlyLeaver(playerId);
      }
    } else {
      heroInfoPlayer.text = playerInfo.player_name+GetEarlyLeaver(playerId);
    }


    // Цвет никнейма

    var player_information_battlepass = CustomNetTables.GetTableValue("cha_server_data", String(playerId));
    if (player_information_battlepass) 
    {
      if (heroInfoPlayer)
      {
        if (player_information_battlepass.nickname == 1)
        {
          if ( GameUI.CustomUIConfig().team_colors )
          {
            var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
            if ( teamColor )
            {
              heroInfoPlayer.style.color = teamColor
            }
          }
        }
        else if (player_information_battlepass.nickname == 2)
        {
          heroInfoPlayer.SetHasClass("rainbow_nickname", true)
          heroInfoPlayer.style.color = "gradient( linear, 100% 0%, 0% 0%, from( rgb(0, 183, 255)), color-stop( 0.5, rgb(0, 255, 85)), to( rgb(255, 196, 0)))"
        }
        else if (player_information_battlepass.nickname == 3)
        {
          heroInfoPlayer.SetHasClass("rainbow_nickname_animate", true)
        }
      }
    }

    if (firstTeamBetConfirn == null && (teamId == firstTeamId))
    {
      firstTeamBetConfirn = playerPanelBet
    }
    else if(firstTeamBetConfirn!=null && (teamId == firstTeamId))
    {
      firstTeamBetConfirn.AddClass("BetPanelHide")
    }

    if (secondTeamBetConfirn == null && (teamId == secondTeamId))
    {
      secondTeamBetConfirn = playerPanelBet
    }else if(secondTeamBetConfirn!=null && (teamId == secondTeamId)){
      secondTeamBetConfirn.AddClass("BetPanelHide")
    }

    if ( GameUI.CustomUIConfig().team_colors )
    {
      var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
      if ( teamColor )
      {
        teamLogoColor.style.washColor = teamColor;
      }
    }
    if ( GameUI.CustomUIConfig().team_icons )
    {
      var teamIcon = GameUI.CustomUIConfig().team_icons[ teamId ];
      if ( teamIcon )
      {
        teamLogoIcon.SetImage( teamIcon );
      }
    }

    heroIcon.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
    heroIcon.playerId= playerId;
    heroInfoHeroName.text = $.Localize("#"+playerInfo.player_selected_hero);

    var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);
     
    let abilityIndex = 0;
  }

  $.Schedule(0.1, function() {
      UpdatePVPPanel(heroNumber)
  });

  $("#BetMain").RemoveClass("Hidden");
}

function UpdatePVPPanel(heroNumber) {
    if ($("#FirstTeam") != null) {

        if (!$("#BetMain").BHasClass("Hidden")) {
            $.Schedule(0.5, function() {
                UpdatePVPPanel(heroNumber)
            });
        }

        for (var index = 1; index <= heroNumber; index++) {
            if ($("#HeroIcon_" + index) != undefined) {
                var playerId = $("#HeroIcon_" + index).playerId;
                var heroIndex = Players.GetPlayerHeroEntityIndex(playerId);
                var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);
                let abilityIndex = 0;
                var playerInfo = Game.GetPlayerInfo(playerId);


                if (Game.GetMapInfo().map_display_name != "5v5") {
                    
                    let ability_panel = $("#AbilityPanel_" + index)
                    
                    let item_panel = $("#ItemPanel_" + index)
                   
                    ability_panel.RemoveAndDeleteChildren()
                    
                    for (var i = 0; i <= 120; i++) {
                        var ability = Entities.GetAbility(playerHeroIndex, i);
                        if (IsValidAbilityDuel(ability)) {
                            var abilityName = Abilities.GetAbilityName(ability);
                            abilityIndex = abilityIndex + 1;
                            let ability_box = ability_panel.FindChild("AbilityImage_" + abilityIndex);
                            if (!ability_box) {
                                ability_box = $.CreatePanel("Panel", ability_panel, "AbilityImage_" + abilityIndex);
                                ability_box.BLoadLayoutSnippet("AbilityBox")
                            }

                            let Cooldown = ability_box.FindChild("CooldownItem");
                            if (!Cooldown) {
                                Cooldown = $.CreatePanel("Panel", ability_box, "CooldownItem");
                            }

                            let CooldownOverlay = ability_box.FindChild("CooldownOverlayItem");
                            if (!CooldownOverlay) {
                                CooldownOverlay = $.CreatePanel("Panel", ability_box, "CooldownOverlayItem");
                            }

                            let CooldownTimer = ability_box.FindChild("CooldownTimerItem");
                            if (!CooldownTimer) {
                                CooldownTimer = $.CreatePanel("Label", ability_box, "CooldownTimerItem");
                            }

                            var pass_info_local = CustomNetTables.GetTableValue("player_info", "pass_data_"+Players.GetLocalPlayer());
                            if (pass_info_local && (pass_info_local.pass_level_1_days > 0 || pass_info_local.pass_level_2_days > 0 || pass_info_local.pass_level_3_days > 0))
                            {
                                let ability_levelbox = ability_box.FindChild("ability_levelbox");
                                if (!ability_levelbox) 
                                {
                                    ability_levelbox = $.CreatePanel("Panel", ability_box, "ability_levelbox");
                                }

                                ability_levelbox.AddClass("ability_levelbox")

                                for (var ability_level = 1; ability_level <= Abilities.GetMaxLevel(ability); ability_level++) 
                                {
                                    let ability_level_quad = ability_levelbox.FindChild("ability_level_quad"+ability_level);
                                    if (!ability_level_quad) {
                                        ability_level_quad = $.CreatePanel("Panel", ability_levelbox, "ability_level_quad"+ability_level);
                                    }
                                    if (Abilities.GetLevel(ability) >= ability_level)
                                    {
                                        ability_level_quad.AddClass("ability_level_quad")
                                    } else {
                                      ability_level_quad.AddClass("ability_level_quad_not_learn")
                                    }
                                }
                            }

                            Cooldown.AddClass("CooldownItem")
                            CooldownOverlay.AddClass("CooldownOverlayItem")
                            CooldownTimer.AddClass("CooldownTimerItem")
                            var cooldown = Abilities.GetCooldownTimeRemaining(ability);
                            if (cooldown > 0) {
                                CooldownTimer.text = Math.ceil(cooldown);
                                CooldownOverlay.RemoveClass("Hidden");
                                var cooldownLength = Abilities.GetCooldownLength(ability);
                                var angle = cooldown / cooldownLength * -360;
                                if (cooldownLength > 0) {
                                    var angle = cooldown / cooldownLength * -360;
                                    CooldownOverlay.style.clip = "radial( 50.0% 50.0%, 0.0deg, " + angle + "deg)";
                                }
                            } else {
                                CooldownTimer.text = "";
                                CooldownOverlay.AddClass("Hidden");
                                CooldownOverlay.style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";
                            }
                            let abilityImage = ability_box.GetChild(0)
                            abilityImage.abilityname = abilityName;
                            ability_box.SetPanelEvent("onmouseover", ShowAbilityTooltip(abilityImage));
                            ability_box.SetPanelEvent("onmouseout", HideAbilityTooltip(abilityImage));
                            ability_box.SetHasClass("Passive", Abilities.IsPassive(ability))
                            ability_box.SetHasClass("Unlearned", Abilities.GetLevel(ability) == 0)
                        }
                    }

                    var talent_display_check = item_panel.FindChild("talent_display");
                    
                    if (!talent_display_check) 
                    {
                        let talent_display = $.CreatePanel("DOTAHudTalentDisplay", item_panel, "talent_display")
                        talent_display.style.height = "36px"
                        talent_display.style.width = "36px"
                        let container = talent_display.FindChildTraverse("StatPipContainer")
                        let tree_parts = talent_display.FindChildrenWithClassTraverse("StatBranchPip")
                        tree_parts.forEach(panel => {
                            panel.style.transitionProperty = "brightness"
                            panel.style.width = "36px"
                            panel.style.height = "36px"
                        })
                        talent_display.AddClass("TalentTree")
                        talent_display.SetPanelEvent("onmouseover", _ShowTalentsTooltip(talent_display, playerInfo.player_selected_hero_id))
                        talent_display.SetPanelEvent("onmouseout", _HideTalentsTooltip(talent_display))
                        talent_display.heroname = playerInfo.player_selected_hero
                        $.Msg(talent_display)
                    }

                    var shard_and_scepter_upgrade_panel = item_panel.FindChild("shard_and_scepter_upgrade_panel");
                    
                    if (!shard_and_scepter_upgrade_panel) 
                    {
                      shard_and_scepter_upgrade_panel = $.CreatePanel("Panel", item_panel, "shard_and_scepter_upgrade_panel")
                      shard_and_scepter_upgrade_panel.style.width = "25px"
                      shard_and_scepter_upgrade_panel.style.height = "100%"
                      shard_and_scepter_upgrade_panel.style.marginRight = "3px"
                      shard_and_scepter_upgrade_panel.style.flowChildren = "down"
                    }

                    var scepter_upgrade_panel = shard_and_scepter_upgrade_panel.FindChild("scepter_upgrade_panel");
                    if (!scepter_upgrade_panel) 
                    {
                      scepter_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "scepter_upgrade_panel")
                      scepter_upgrade_panel.style.width = "40px"
                      scepter_upgrade_panel.style.height = "70%"
                      scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
                      scepter_upgrade_panel.style.backgroundSize = "100%"
                    }

                    var shard_upgrade_panel = shard_and_scepter_upgrade_panel.FindChild("shard_upgrade_panel");
                    if (!shard_upgrade_panel) 
                    {
                      shard_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "shard_upgrade_panel")
                      shard_upgrade_panel.style.width = "40px"
                      shard_upgrade_panel.style.height = "30%"
                      shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
                      shard_upgrade_panel.style.backgroundSize = "100%"
                    }

                    if (Entities.HasScepter(playerHeroIndex)) {
                        scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_on_psd.vtex")';
                        scepter_upgrade_panel.style.backgroundSize = "100%"
                    } else {
                        scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
                        scepter_upgrade_panel.style.backgroundSize = "100%"
                    }

                    if (HasModifier(playerHeroIndex, "modifier_item_aghanims_shard")) {
                        shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_on_psd.vtex")';
                        shard_upgrade_panel.style.backgroundSize = "100%"
                    } else {
                        shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
                        shard_upgrade_panel.style.backgroundSize = "100%"
                    }

                    var itemIndex = 0;
                    for (var i = 0; i <= 5; i++) {
                        var item = Entities.GetItemInSlot(playerHeroIndex, i);
                        var itemName = Abilities.GetAbilityName(item);
                        itemIndex = itemIndex + 1;
                        var itemImage = $("#ItemPanel_" + index).FindChild("ItemImage_" + itemIndex);
                        if (!itemImage) {
                            itemImage = $.CreatePanel("DOTAItemImage", item_panel, "ItemImage_" + itemIndex);
                            itemImage.itemname = itemName;
                            itemImage.SetPanelEvent("onmouseover", ShowItemTooltip(itemImage));
                            itemImage.SetPanelEvent("onmouseout", HideItemTooltip(itemImage));
                        } else {
                            itemImage.itemname = itemName;
                            itemImage.SetPanelEvent("onmouseover", ShowItemTooltip(itemImage));
                            itemImage.SetPanelEvent("onmouseout", HideItemTooltip(itemImage));
                        }
                        
                          let Cooldown = itemImage.FindChild("CooldownItem");
                          if (!Cooldown) {
                              Cooldown = $.CreatePanel("Panel", itemImage, "CooldownItem");
                          }

                          let CooldownOverlay = itemImage.FindChild("CooldownOverlayItem");
                          if (!CooldownOverlay) {
                              CooldownOverlay = $.CreatePanel("Panel", itemImage, "CooldownOverlayItem");
                          }

                          let CooldownTimer = itemImage.FindChild("CooldownTimerItem");
                          if (!CooldownTimer) {
                              CooldownTimer = $.CreatePanel("Label", itemImage, "CooldownTimerItem");
                          }

                        Cooldown.AddClass("CooldownItem")
                        CooldownOverlay.AddClass("CooldownOverlayItem")
                        CooldownTimer.AddClass("CooldownTimerItem")
                        var cooldown = Abilities.GetCooldownTimeRemaining(item);
                        if (cooldown > 0) {
                            CooldownTimer.text = Math.ceil(cooldown);
                            CooldownOverlay.RemoveClass("Hidden");
                            var cooldownLength = Abilities.GetCooldownLength(item);
                            var angle = cooldown / cooldownLength * -360;
                            CooldownOverlay.style.clip = "radial( 50.0% 50.0%, 0.0deg, " + angle + "deg)";
                        } else {
                            CooldownTimer.text = "";
                            CooldownOverlay.AddClass("Hidden");
                            CooldownOverlay.style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";
                        }
                    }

                    var neutral_item = Entities.GetItemInSlot(playerHeroIndex, 16)
                    var neutral_itemName = Abilities.GetAbilityName(neutral_item);

                    var neutral_item_panel = item_panel.FindChild("itemPanel_neutral");

                    if (!neutral_item_panel) 
                    {
                        neutral_item_panel = $.CreatePanel("DOTAItemImage", item_panel, "itemPanel_neutral");
                        neutral_item_panel.AddClass("NeutralItem");
                    }

                    let Cooldown = $.CreatePanel("Panel", neutral_item_panel, "CooldownItem");
                    let CooldownOverlay = $.CreatePanel("Panel", neutral_item_panel, "CooldownOverlayItem");
                    let CooldownTimer = $.CreatePanel("Label", neutral_item_panel, "CooldownTimerItem");
                    Cooldown.AddClass("CooldownItem")
                    CooldownOverlay.AddClass("CooldownOverlayItem")
                    CooldownTimer.AddClass("CooldownTimerItem")

                    neutral_item_panel.style.width = "28px"

                    if (neutral_item != -1) {
                        neutral_item_panel.itemname = Abilities.GetAbilityName(neutral_item)
                        neutral_item_panel.SetHasClass("empty_item", false)
                    } else {
                        neutral_item_panel.SetImage("");
                        neutral_item_panel.SetHasClass("empty_item", true)
                    }

                    var cooldown = Abilities.GetCooldownTimeRemaining(neutral_item);
                    if (cooldown > 0) {
                        CooldownTimer.text = Math.ceil(cooldown);
                        CooldownOverlay.RemoveClass("Hidden");
                        var cooldownLength = Abilities.GetCooldownLength(neutral_item);
                        var angle = cooldown / cooldownLength * -360;
                        CooldownOverlay.style.clip = "radial( 50.0% 50.0%, 0.0deg, " + angle + "deg)";
                    } else {
                        CooldownTimer.text = "";
                        CooldownOverlay.AddClass("Hidden");
                        CooldownOverlay.style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";
                    }
                }
            }
        }
    }
}



//Hide bet pages
function HidePvpBet() {
    $("#BetMain").AddClass("Hidden");

  for (var k in $("#BetMain").Children()) {
    var panel = $("#BetMain").Children()[k];
    //panel.RemoveAndDeleteChildren()
    panel.DeleteAsync(0.0)
  }

    for(var x = 1; x < 20;x++){
      var aPanel = $("#AbilityPanel_"+x)
      if (aPanel != null){
        aPanel.RemoveAndDeleteChildren()
      }
      var iPanel = $("#ItemPanel_"+x)
    if (iPanel != null){
      iPanel.RemoveAndDeleteChildren()
    }
    }
}

// Не трогать

function MaxBetEvent(playerPanelBetMax, teamId, index, playerPanelBetText){
  playerPanelBetMax.SetPanelEvent("onactivate", function () {
    var playerId = Game.GetLocalPlayerID();
    var maxGold =  Math.floor(Players.GetGold(playerId)/2);
    playerPanelBetText.text = maxGold;
  })
}

function MaxBetEventCurrent(playerPanelBetMax, teamId, index, playerPanelBetText, current){
  playerPanelBetMax.SetPanelEvent("onactivate", function () {
    var playerId = Game.GetLocalPlayerID();
    var maxGold =  Math.floor(Players.GetGold(playerId)/100*current);
    playerPanelBetText.text = maxGold;
  })
}

function BetTextChangedEvent(textEntry, index){
    textEntry.SetPanelEvent("ontextentrychange", function () {
       BetTextChanged(index)
  })
}

function BetTextChanged(index)
{

  var playerId = Game.GetLocalPlayerID();
  var maxGold =  Math.floor(Players.GetGold(playerId)/2);
  
  var panel = $("#BetTextEntryPanel_"+index).FindChild("BetTextEntry")
  var alertPanel = $("#BetAlertLabel_"+index)

  var text = panel.text

  for (var i = 1; i <= 4; i++) {
     if ((i+"")!=index && text!="")
     {
        if ($("#BetTextEntryPanel_"+i)!=undefined)
        {
          $("#BetTextEntryPanel_"+i).FindChild("BetTextEntry").text=""  
        }
     }
  }
  
  if (text.indexOf(".") != -1) {
    text=text.replace(".","");
    panel.text =text;
    alertPanel.RemoveClass("Hidden");
    alertPanel.text = $.Localize("#bet_must_positive_integer");
    return
  }

  if (text.indexOf("-") != -1){
    panel.text ="";
    alertPanel.RemoveClass("Hidden");
    alertPanel.text = $.Localize("#bet_must_positive_integer");
    return
  }

  if (parseInt(text)>maxGold){
    panel.text =maxGold;
    alertPanel.RemoveClass("Hidden");
    alertPanel.text = $.Localize("#bet_max_gold");
    return
  }

  alertPanel.AddClass("Hidden");
}

function updateAdjuctEvent(upPanel, downPanel, focusPanel, alertPanel) {
    upPanel.SetPanelEvent("onactivate", function () {
      var playerId = Game.GetLocalPlayerID();
      var maxGold =  Math.floor(Players.GetGold(playerId)/2);
      var multiple = Math.floor(maxGold/10/100);
      if (multiple<1) {
        multiple = 1;
      }
      var slice = multiple * 100;
      var text = focusPanel.text;
      var value = 0
            if (text!="")
            {
                  value = parseInt(text)
            }
            value = value+slice;
            if (value>maxGold)
            {
              alertPanel.RemoveClass("Hidden");
              alertPanel.text = $.Localize("#bet_max_gold");
              value = maxGold;
             } else {
                alertPanel.AddClass("Hidden");
            }
            focusPanel.text = value;
    })
    downPanel.SetPanelEvent("onactivate", function () {
      var playerId = Game.GetLocalPlayerID();
      var maxGold =  Math.floor(Players.GetGold(playerId)/2);
      var multiple = Math.floor(maxGold/10/100);
      if (multiple<1) {
        multiple = 1;
      }
      var slice = multiple * 100;
      var text = focusPanel.text;
      var value = 0
      if (text!="")
      {
          value = parseInt(text)
      }
      value = value-slice;
      if (value<0)
      {
        alertPanel.RemoveClass("Hidden");
        alertPanel.text = $.Localize("#bet_must_positive_integer");
        value = 0;
      }else{
        alertPanel.AddClass("Hidden");
      }

      focusPanel.text =value;
    })
}

//Player gold coins change Adjust input box
function UpdateBetInput() {
    var playerId = Game.GetLocalPlayerID();
    var maxGold =  Math.floor(Players.GetGold(playerId)/2);
    for (var index = 1; index <= 10; index++) {
      if($("#BetTextEntryPanel_"+index) != null){
        var text = $("#BetTextEntryPanel_"+index).FindChild("BetTextEntry").text;
        if (text!="" ){
           if (parseInt(text)>maxGold){
             $("#BetTextEntryPanel_"+index).FindChild("BetTextEntry").text =maxGold;
           }
        }
      }
    }
}

function UpdateConfirmButton(keys){
   
  for (var i = 1; i <=4; i++) {
    if ($("#BetConfirmButtonLabel_"+i)!=undefined)
    {
      $("#BetConfirmButtonLabel_"+i).text =$.Localize("#confirm")+ "<br>" +""+ (keys.totalTime-keys.currentTime) +"";
    }
  }
}

function LogoAndHeroPanelEvent(logoAndHeroPanel, index){
    logoAndHeroPanel.SetPanelEvent("onactivate", function () {
      HeroIconClicked(index,false)
    })
    logoAndHeroPanel.SetPanelEvent("ondblclick", function () {
      HeroIconClicked(index,true)
    })
}

function ConfirmBetEvent(playerPanelBetConfirn, teamId, index){
    playerPanelBetConfirn.SetPanelEvent("onactivate", function () {
      if ($("#BetTextEntryPanel_"+index).FindChild("BetTextEntry").text != ""){
        ConfirmBet(teamId, index)
      }
    })
}

function ConfirmBet(teamId, index){
  var value = 0;
    HidePvpBet()
    var betValuePane = $("#BetTextEntryPanel_"+index).FindChild("BetTextEntry")
    value = parseInt(betValuePane.text);
    
    if (value>0 && teamId!=undefined)
    {
        GameEvents.SendCustomGameEventToServer("ConfirmBet", {
            value: value,
            wish_team_id: teamId,
            bet_ui_secret: $("#BetMain").bet_ui_secret
        });
    }
}

function HeroIconClicked(index,bDoubleClick)
{
    var targetPlayerId = $("#HeroIcon_"+index).playerId;
    var targetHero =Players.GetPlayerHeroEntityIndex(targetPlayerId)
    if  (targetHero!=undefined) {
        GameUI.SelectUnit(targetHero, false)
    }
    GameEvents.SendCustomGameEventToServer('HeroIconClicked', {playerId:Players.GetLocalPlayer(), targetPlayerId:targetPlayerId,doubleClick:bDoubleClick,controldown:GameUI.IsControlDown() })
}

function HasModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
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

function BetInit(){
  GameEvents.Subscribe("UpdateBetInput", UpdateBetInput);
  GameEvents.Subscribe("HidePvpBet", HidePvpBet);
  GameEvents.Subscribe("UpdateConfirmButton", UpdateConfirmButton);
  GameEvents.Subscribe("ShowPvpBet", ShowPvpBet);
}
BetInit()
