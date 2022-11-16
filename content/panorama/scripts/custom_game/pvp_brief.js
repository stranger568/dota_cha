victoryParticleID=0
victoryLocateTimes = 0

function SetCameraFocus(data){
  GameUI.SetCameraTargetPosition(data.vector,0.1)
}

function ShowPvpBrief(data) {

  $.Msg("wasd")

  var maxBetValue
  var heroNumber = 0

  for(var index in data.players) {
      var playerId = data.players[index].playerID;
      var teamId = data.players[index].teamID;
      heroNumber = heroNumber + 1
      for(var i in data.betMap[teamId]){
      if (maxBetValue==undefined)
      {
          maxBetValue = data.betMap[teamId][i].nValue;
      }
      else
      {
          if (maxBetValue<data.betMap[teamId][i].nValue){
            maxBetValue = data.betMap[teamId][i].nValue;
          }
      }
    }
  }

  var mainBriefPvpPanel = $("#PvPMain")

  if (Game.GetMapInfo().map_display_name=="2x6")
  {
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

  if (data.bonusPool)
  {
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

  for(var index in data.players) {
    var playerId = data.players[index].playerID;
    var playerInfo = Game.GetPlayerInfo( playerId );
    var teamId = data.players[index].teamID;
    var heroIndex =  Players.GetPlayerHeroEntityIndex(playerId)

    if (teamId == firstTeamId){
      currentPanel = firstTeamPanel
      positionOnScreen = "top"
    }else{
      currentPanel = secondTeamPanel
      positionOnScreen = "bottom"
    }

    var playerAbilityPanel = $.CreatePanel("Panel", currentPanel, "PlayerAbilityPanel_"+index);
    playerAbilityPanel.AddClass("PlayerAbilityPanel");
    playerAbilityPanel.positionOnScreen = positionOnScreen
    playerAbilityPanel.teamId = teamId

    var HeroIconAndHealthAndMana = $.CreatePanel("Image", playerAbilityPanel, "HeroIconAndHealthAndMana"+index);
    HeroIconAndHealthAndMana.AddClass("HeroIconAndHealthAndMana");
    
    var heroBriefIcon = $.CreatePanel("Image", HeroIconAndHealthAndMana, "HeroIcon_"+index);
    heroBriefIcon.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png")
    heroBriefIcon.AddClass("HeroIcon");
    heroBriefIcon.playerId = playerId;
    HeroIconEvent(heroBriefIcon, index)

    if ( GameUI.CustomUIConfig().team_colors )
    {
      var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
      if ( teamColor )
      {
        heroBriefIcon.style.borderTop = "3px solid  " + teamColor;
      }
    }

    var BonusPlayerInformation = $.CreatePanel("Panel", HeroIconAndHealthAndMana, "BonusPlayerInformation"+index);
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
    if (goldData!=undefined) {
       GoldInfoLabelText.text = goldData.gold
    } else{
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
              HeroRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rank_info_duel.mmr[3] || 2500) + '.png")';
          }
          HeroRank.style.backgroundSize = "100%" 
          if (rank_info_duel.rating_number_in_top != 0 && rank_info_duel.rating_number_in_top != "0")
          {
              rank_number.text = rank_info_duel.rating_number_in_top
          }
      }
    } else {
      HeroInfoRatingLabel.style.opacity = "0"
      HeroRank.style.opacity = "0"
    }

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

    var HealthAndManaPanel = $.CreatePanel("Image", playerAbilityPanel, "HealthAndManaPanel"+index);
    HealthAndManaPanel.AddClass("HealthAndManaPanel");

    var itemPanel = $.CreatePanel("Panel", playerAbilityPanel, "ItemPanel_"+index);
    itemPanel.AddClass("ItemPanel");

    var abilityPanel = $.CreatePanel("Panel", playerAbilityPanel, "AbilityPanel_"+index);
    abilityPanel.AddClass("AbilityPanel");

    var healthContainer = $.CreatePanel("Panel", HealthAndManaPanel, "HealthContainer_"+index);
    healthContainer.AddClass("HealthContainer");
    healthContainer.positionOnScreen = positionOnScreen
    healthContainer.teamId = teamId

    var healthLabel = $.CreatePanel("Label", healthContainer, "HealthLabel_"+index);
    healthLabel.AddClass("HealthLabel");

    var healthProgress = $.CreatePanel("ProgressBar", healthContainer, "HealthProgress_"+index);
    healthProgress.AddClass("HealthProgress");

    var healthProgressLeft = $("#HealthProgress_"+index+"_Left")
    healthProgressLeft.AddClass("HealthProgressLeft");

    var healthProgressRight = $("#HealthProgress_"+index+"_Right")
    healthProgressRight.AddClass("HealthProgressRight");

    var dotaSceneContainer = $.CreatePanel("Panel", healthProgressLeft,"");
    dotaSceneContainer.AddClass("DotaSceneContainer");
    var healthBarBurner = $.CreatePanel("Panel",dotaSceneContainer, "");
    healthBarBurner.BLoadLayoutSnippet("BarBurner");

    var manaContainer = $.CreatePanel("Panel", HealthAndManaPanel, "ManaContainer_"+index);
    manaContainer.AddClass("ManaContainer");
    manaContainer.positionOnScreen = positionOnScreen
    manaContainer.teamId = teamId

    var manaLabel = $.CreatePanel("Label", manaContainer, "ManaLabel_"+index);
    manaLabel.AddClass("ManaLabel");

    var manaProgress = $.CreatePanel("ProgressBar", manaContainer, "ManaProgress_"+index);
    manaProgress.AddClass("ManaProgress");

    var manaProgressLeft = $("#ManaProgress_"+index+"_Left")
    manaProgressLeft.AddClass("ManaProgressLeft");

    var manaProgressRight = $("#ManaProgress_"+index+"_Right")
    manaProgressRight.AddClass("ManaProgressRight");

    var dotaSceneManaContainer = $.CreatePanel("Panel", manaProgressLeft,"");
    dotaSceneManaContainer.AddClass("DotaSceneManaContainer");
    var manaBarBurner = $.CreatePanel("Panel",dotaSceneManaContainer, "");
    manaBarBurner.BLoadLayoutSnippet("BarBurner");


        $("#HealthLabel_"+index).text = Entities.GetHealth(heroIndex)+" / "+Entities.GetMaxHealth(heroIndex);
        $("#ManaLabel_"+index).text = Entities.GetMana(heroIndex)+" / "+Entities.GetMaxMana(heroIndex);

        var healthPercent = Entities.GetHealth(heroIndex)/Entities.GetMaxHealth(heroIndex);
        $("#HealthProgress_"+index).value = healthPercent;

        var manaPercent = Entities.GetMana(heroIndex)/Entities.GetMaxMana(heroIndex);
        $("#ManaProgress_"+index).value = manaPercent;
    }

    // СОЗДАНИЕ СТАВОЧЕК////////////////////////////////////////////////////////////////////////////////////////

  if (maxBetValue!=undefined)
  {
    if (Game.GetMapInfo().map_display_name=="2x6")
    {

      for(var i in data.betMap[firstTeamId]){
          var betData = data.betMap[firstTeamId][i]

          let teambetline = firstBetInfo.FindChildTraverse("teambetline_" + Players.GetTeam( betData.nPlayerId ))
          if (!teambetline)
          {
            teambetline = $.CreatePanel("Panel",firstBetInfo, "teambetline_" + Players.GetTeam( betData.nPlayerId ));
            teambetline.BLoadLayoutSnippet("PlayerBetLine");
            let percent = betData.nValue/maxBetValue;
            teambetline.FindChildTraverse("BetValueProgressBar").value = percent;
            teambetline.FindChildTraverse("BetValue").text = betData.nValue;
            if ( GameUI.CustomUIConfig().team_icons )
            {
              var teamIcon = GameUI.CustomUIConfig().team_icons[ Players.GetTeam( betData.nPlayerId ) ];
              if ( teamIcon )
              {
                teambetline.FindChildTraverse("HeroIcon").SetImage( teamIcon );
              }
            }
          } else {
            let percent = betData.nValue/maxBetValue;
            teambetline.FindChildTraverse("BetValueProgressBar").value = Number(teambetline.FindChildTraverse("BetValueProgressBar").value) + percent;
            teambetline.FindChildTraverse("BetValue").text = Number(teambetline.FindChildTraverse("BetValue").text) + betData.nValue;
          }
        }

    } else {
        for(var i in data.betMap[firstTeamId]){
          var betData = data.betMap[firstTeamId][i]
          var playerBetLine = $.CreatePanel("Panel",firstBetInfo, "PlayerBetLine_"+i);
          playerBetLine.BLoadLayoutSnippet("PlayerBetLine");
          var percent = betData.nValue/maxBetValue;
          playerBetLine.FindChildTraverse("BetValueProgressBar").value = percent;
          playerBetLine.FindChildTraverse("BetValue").text = betData.nValue;
          var heroName = Players.GetPlayerSelectedHero(betData.nPlayerId)

          playerBetLine.FindChildTraverse("HeroIcon").SetImage( "file://{images}/heroes/icons/" + heroName + ".png" );
        }
    }
  }

  if (maxBetValue!=undefined)
  {
    if (Game.GetMapInfo().map_display_name=="2x6")
    {
        for(var i in data.betMap[secondTeamId]){
          var betData = data.betMap[secondTeamId][i]

          let teambetline = firstBetInfo.FindChildTraverse("teambetline_" + Players.GetTeam( betData.nPlayerId ))
          if (!teambetline)
          {
            teambetline = $.CreatePanel("Panel",firstBetInfo, "teambetline_" + Players.GetTeam( betData.nPlayerId ));
            teambetline.BLoadLayoutSnippet("PlayerBetLine");
            let percent = betData.nValue/maxBetValue;
            teambetline.FindChildTraverse("BetValueProgressBar").value = percent;
            teambetline.FindChildTraverse("BetValue").text = betData.nValue;
            if ( GameUI.CustomUIConfig().team_icons )
            {
              var teamIcon = GameUI.CustomUIConfig().team_icons[ Players.GetTeam( betData.nPlayerId ) ];
              if ( teamIcon )
              {
                teambetline.FindChildTraverse("HeroIcon").SetImage( teamIcon );
              }
            }
          } else {
            let percent = betData.nValue/maxBetValue;
            teambetline.FindChildTraverse("BetValueProgressBar").value = Number(teambetline.FindChildTraverse("BetValueProgressBar").value) + percent;
            teambetline.FindChildTraverse("BetValue").text = Number(teambetline.FindChildTraverse("BetValue").text) + betData.nValue;
          }
        }
    } else {
        for(var i in data.betMap[secondTeamId]){
          var betData = data.betMap[secondTeamId][i]
          var playerBetLine = $.CreatePanel("Panel",secondBetInfo, "PlayerBetLine_"+i);
          playerBetLine.BLoadLayoutSnippet("PlayerBetLine");
          var percent = betData.nValue/maxBetValue;
          playerBetLine.FindChildTraverse("BetValueProgressBar").value = percent;
          playerBetLine.FindChildTraverse("BetValue").text = betData.nValue;
          var heroName = Players.GetPlayerSelectedHero(betData.nPlayerId)

          playerBetLine.FindChildTraverse("HeroIcon").SetImage( "file://{images}/heroes/icons/" + heroName + ".png" );
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

function UpdatePvpBrief(heroNumber) {

    if($("#FirstTeamBrief") != null){

      if(!$("#PvPMain").BHasClass("Hidden")) {
        $.Schedule(0.5, function() {
          UpdatePvpBrief(heroNumber)
        });
      }

      for (var index = 1; index <= heroNumber; index++) {
        if ($("#HeroIcon_"+index)!=undefined)
        {
          var playerId =  $("#HeroIcon_"+index).playerId;
          var playerInfo = Game.GetPlayerInfo( playerId );
          var heroIndex =  Players.GetPlayerHeroEntityIndex(playerId);
          let abilityIndex = 0;
          var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);

                let ability_panel = $("#AbilityPanel_" + index)
                ability_panel.RemoveAndDeleteChildren()

                for (var i = 0; i <= 120; i++) {
                    var ability = Entities.GetAbility(playerHeroIndex, i);
                    if (IsValidAbilityDuel(ability)) {
                        var abilityName = Abilities.GetAbilityName(ability);
                        abilityIndex = abilityIndex + 1;
                        let ability_box = ability_panel.FindChild("AbilityImage_" + abilityIndex);
                        if (!ability_box) {
                            ability_box = $.CreatePanel("Panel", ability_panel, "AbilityImage_" + abilityIndex);
                            ability_box.BLoadLayoutSnippet("AbilityItem")
                        }


                        var pass_info_local = CustomNetTables.GetTableValue("player_info", "pass_data_"+Players.GetLocalPlayer());
                        if (pass_info_local && (pass_info_local.pass_level_1_days > 0 || pass_info_local.pass_level_2_days > 0 || pass_info_local.pass_level_3_days > 0))
                        {
                            let ability_levelbox = $.CreatePanel("Panel", ability_box, "ability_levelbox");
                            ability_levelbox.AddClass("ability_levelbox")

                            for (var ability_level = 1; ability_level <= Abilities.GetMaxLevel(ability); ability_level++) 
                            {
                                let ability_level_quad = $.CreatePanel("Panel", ability_levelbox, "");
                                if (Abilities.GetLevel(ability) >= ability_level)
                                {
                                    ability_level_quad.AddClass("ability_level_quad")
                                } else {
                                  ability_level_quad.AddClass("ability_level_quad_not_learn")
                                }
                            }
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

                let panelka_items = $("#ItemPanel_"+index)


                var talent_display = panelka_items.FindChild("talent_display");
                    
                if (!talent_display) 
                {
                    talent_display = $.CreatePanel("DOTAHudTalentDisplay", panelka_items, "talent_display")  
                }

                talent_display.style.height = "36px"      
                talent_display.style.width = "36px"
                let container = talent_display.FindChildTraverse("StatPipContainer")
                let tree_parts = talent_display.FindChildrenWithClassTraverse("StatBranchPip")
                tree_parts.forEach(panel=>{
                  panel.style.transitionProperty = "brightness"
                  panel.style.width = "36px"
                  panel.style.height = "36px"
                })
                talent_display.AddClass("TalentTree")
                talent_display.SetPanelEvent("onmouseover", _ShowTalentsTooltip(talent_display, playerInfo.player_selected_hero_id))
                talent_display.SetPanelEvent("onmouseout", _HideTalentsTooltip(talent_display))
                talent_display.heroname = playerInfo.player_selected_hero


                var shard_and_scepter_upgrade_panel = panelka_items.FindChild("shard_and_scepter_upgrade_panel");
                if (!shard_and_scepter_upgrade_panel) 
                {
                    shard_and_scepter_upgrade_panel = $.CreatePanel("Panel", panelka_items, "shard_and_scepter_upgrade_panel")  
                }   
                shard_and_scepter_upgrade_panel.style.width = "25px"
                shard_and_scepter_upgrade_panel.style.height = "100%"
                shard_and_scepter_upgrade_panel.style.marginRight = "3px"
                shard_and_scepter_upgrade_panel.style.flowChildren = "down"

                var scepter_upgrade_panel = shard_and_scepter_upgrade_panel.FindChild("scepter_upgrade_panel");
                if (!scepter_upgrade_panel) 
                {
                    scepter_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "scepter_upgrade_panel")      
                }     
                scepter_upgrade_panel.style.width = "40px"
                scepter_upgrade_panel.style.height = "70%"
                scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
                scepter_upgrade_panel.style.backgroundSize = "100%"

                var shard_upgrade_panel = shard_and_scepter_upgrade_panel.FindChild("shard_upgrade_panel");
                if (!shard_upgrade_panel) 
                {
                    shard_upgrade_panel = $.CreatePanel("Panel", shard_and_scepter_upgrade_panel, "shard_upgrade_panel")   
                } 
                shard_upgrade_panel.style.width = "40px"
                shard_upgrade_panel.style.height = "30%"
                shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
                shard_upgrade_panel.style.backgroundSize = "100%"
            
                if (Entities.HasScepter( heroIndex ))
                {
                    scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_on_psd.vtex")';
                    scepter_upgrade_panel.style.backgroundSize = "100%"
                } 
                else 
                {
                    scepter_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_scepter_psd.vtex")';
                    scepter_upgrade_panel.style.backgroundSize = "100%"
                }
            
                if (HasModifier(heroIndex, "modifier_item_aghanims_shard"))
                {
                    shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_on_psd.vtex")';
                    shard_upgrade_panel.style.backgroundSize = "100%"
                } 
                else 
                {
                    shard_upgrade_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/aghsstatus_shard_psd.vtex")';
                    shard_upgrade_panel.style.backgroundSize = "100%"
                }

                var itemIndex = 0;
                for (var i = 0; i <= 5; i++) {
                    var item = Entities.GetItemInSlot(heroIndex, i);
                    var itemName = Abilities.GetAbilityName(item);
                        itemIndex = itemIndex + 1;
                        var itemImage =  $("#ItemPanel_"+index).FindChild("ItemImage_"+itemIndex);
                        if (!itemImage) {
                           itemImage = $.CreatePanel("DOTAItemImage", panelka_items, "ItemImage_"+itemIndex);
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
                           if (cooldownLength > 0)
                           {
                              var angle = cooldown/cooldownLength * -360;
                              CooldownOverlay.style.clip="radial( 50.0% 50.0%, 0.0deg, "+angle+"deg)";
                           }
                        } else {
                           CooldownTimer.text = "";
                           CooldownOverlay.AddClass("Hidden");
                           CooldownOverlay.style.clip="radial( 50.0% 50.0%, 0.0deg, -360deg)";
                        }
                }

                var neutral_item = Entities.GetItemInSlot(heroIndex, 16)
                var neutral_itemName = Abilities.GetAbilityName(neutral_item);

                var neutral_item_panel = panelka_items.FindChild("itemPanel_neutral");
                if (!neutral_item_panel) 
                {
                    neutral_item_panel = $.CreatePanel( "DOTAItemImage", panelka_items, "itemPanel_neutral" );
                } 
                neutral_item_panel.AddClass( "NeutralItem");
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
                }
                else {
                  neutral_item_panel.SetImage( "" );
                  neutral_item_panel.SetHasClass("empty_item", true)
                }
                var cooldown = Abilities.GetCooldownTimeRemaining(neutral_item);
               if (cooldown > 0) {
                 CooldownTimer.text = Math.ceil(cooldown);
                 CooldownOverlay.RemoveClass("Hidden");
                 var cooldownLength = Abilities.GetCooldownLength(neutral_item);
                 var angle = cooldown/cooldownLength * -360;
                 CooldownOverlay.style.clip="radial( 50.0% 50.0%, 0.0deg, "+angle+"deg)";
              } else {
                 CooldownTimer.text = "";
                 CooldownOverlay.AddClass("Hidden");
                 CooldownOverlay.style.clip="radial( 50.0% 50.0%, 0.0deg, -360deg)";
              }



          $("#HealthLabel_"+index).text = Entities.GetHealth(heroIndex)+" / "+Entities.GetMaxHealth(heroIndex);
          $("#ManaLabel_"+index).text = Entities.GetMana(heroIndex)+" / "+Entities.GetMaxMana(heroIndex);

          var healthPercent = Entities.GetHealth(heroIndex)/Entities.GetMaxHealth(heroIndex);
          $("#HealthProgress_"+index).value = healthPercent;
          var manaPercent = Entities.GetMana(heroIndex)/Entities.GetMaxMana(heroIndex);
          $("#ManaProgress_"+index).value = manaPercent;
        }
      }
   }
}











function HidePvpBrief() 
{

   $("#PvPMain").AddClass("Hidden");
   $("#PvPMainHeaderShowPanel").AddClass("Hidden");
}

function ResetPvpBrief() {
  if($("#FirstTeamBrief") != null){$("#FirstTeamBrief").DeleteAsync(0)}
  if($("#SecondTeamBrief") != null){$("#SecondTeamBrief").DeleteAsync(0)}
  if($("#VsLogo") != null){$("#VsLogo").DeleteAsync(0)}
  if($("#BetInfoContainer_1") != null){$("#BetInfoContainer_1").DeleteAsync(0)}
  if($("#BetInfoContainer_2") != null){$("#BetInfoContainer_2").DeleteAsync(0)}
}

















// Не трогать

function LocateVictoryParticle() {
    
    victoryLocateTimes = victoryLocateTimes + 1 
    if(victoryLocateTimes>500){     
        return;
    }
    var location = Game.ScreenXYToWorld( 580, 655 )
    location[2] = 1000;

    Particles.SetParticleControl(victoryParticleID, 3, location)  

    $.Schedule(0.01,LocateVictoryParticle);
}

function ShowVictoryParticle() {

     var location = Game.ScreenXYToWorld( 580, 655 )
     location[2] = 1000;
     victoryParticleID = Particles.CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_commander_duel_victories.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, 0);
     victoryLocateTimes = 0
     Particles.SetParticleControl( victoryParticleID, 3, location  ) 
     LocateVictoryParticle () 
}

function TeamWin(data) {

  if($("#BetInfoContainer_1") != null){$("#BetInfoContainer_1").DeleteAsync(0)}
  if($("#BetInfoContainer_2") != null){$("#BetInfoContainer_2").DeleteAsync(0)}

  if($("#VsLogo") != null){
    $("#VsLogo").AddClass("Hidden")
    $("#PvPMain").RemoveClass("PvPMainBackground")
    $("#PvPMainHeader").AddClass("Hidden")
    for (var index = 1; index <= 4; index++) {
      if ($("#PlayerAbilityPanel_"+index)!=undefined)
      {

        var barTeamId = $("#PlayerAbilityPanel_"+index).teamId
        if (barTeamId == data.winnerTeamID){
          var positionOnScreen = $("#PlayerAbilityPanel_"+index).positionOnScreen
          if(positionOnScreen=="top"){
            $("#FirstTeamBrief").AddClass("MoveDown")
          }else{
            $("#SecondTeamBrief").AddClass("MoveUp")
          }
        }

        if (barTeamId == data.loserTeamID){
          if ($("#PlayerAbilityPanel_"+index)==undefined)
          {
            return;
          }
          $("#PlayerAbilityPanel_"+index).AddClass("Hidden");
          $("#HealthContainer_"+index).AddClass("Hidden");
          $("#ManaContainer_"+index).AddClass("Hidden");
        }
      }
    }
    
    //为非参与者播放胜利特效
    if(Players.GetTeam(Players.GetLocalPlayer())!=data.nWinnerTeamID && Players.GetTeam(Players.GetLocalPlayer())!=data.nLoserTeamID){
      ShowVictoryParticle()
    }

    $.Schedule(3.2,HidePvpBrief);
    $.Schedule(5,ResetPvpBrief);
  }
}

function HeroIconEvent(heroIcon, index){
    heroIcon.SetPanelEvent("onactivate", function () {
      HeroIconClicked(index,false)
    })
    heroIcon.SetPanelEvent("ondblclick", function () {
      HeroIconClicked(index,true)
    })
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

function TogglePvPMain()
{
    $("#PvPMain").ToggleClass("PvPMainHidden");
    $("#PvPMainHeaderShowPanel").ToggleClass("Hidden");   
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

(function () {
    GameEvents.Subscribe("ShowPvpBrief", ShowPvpBrief);
    GameEvents.Subscribe("TeamWin", TeamWin);
    GameEvents.Subscribe( "ShowVictoryParticle", ShowVictoryParticle );
    GameEvents.Subscribe( "SetCameraFocus", SetCameraFocus );
})();