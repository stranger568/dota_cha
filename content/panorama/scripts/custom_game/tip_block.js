var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);

GameEvents.Subscribe("TipPlayerNotification", TipPlayerNotification);

function TipPlayerNotification(data)
{
	Game.EmitSound("General.Coins")

	var playerInfo_1 = Game.GetPlayerInfo( data.player_id_1 );
	var playerInfo_2 = Game.GetPlayerInfo( data.player_id_2 );

	let notification = $.CreatePanel("Panel", $("#PlayersTipHistory"), "")
	notification.AddClass("notification")
	notification.AddClass("visible")

	let one_player = $.CreatePanel("Panel", notification, "")
	one_player.AddClass("playerbox")

	let one_player_portrait = $.CreatePanel("Panel", one_player, "")
	one_player_portrait.AddClass("one_player_portrait")
	one_player_portrait.style.backgroundImage = 'url("file://{images}/heroes/' + playerInfo_1.player_selected_hero + '.png")'
	one_player_portrait.style.backgroundSize = "100%"

	let one_player_nickname = $.CreatePanel("Label", one_player, "")
	one_player_nickname.AddClass("one_player_nickname")
	one_player_nickname.text = playerInfo_1.player_name

	let label_tip = $.CreatePanel("Label", notification, "")
	label_tip.AddClass("label_tip")
	label_tip.text = $.Localize("#tipped")
     

	let two_player = $.CreatePanel("Panel", notification, "")
	two_player.AddClass("playerbox_two")
	 
	let two_player_portrait = $.CreatePanel("Panel", two_player, "")
	two_player_portrait.AddClass("two_player_portrait")
	two_player_portrait.style.backgroundImage = 'url("file://{images}/heroes/' + playerInfo_2.player_selected_hero + '.png")'
	two_player_portrait.style.backgroundSize = "100%"

	let two_player_nickname = $.CreatePanel("Label", two_player, "")
	two_player_nickname.AddClass("two_player_nickname")
	two_player_nickname.text = playerInfo_2.player_name

    var player_information_battlepass_1 = CustomNetTables.GetTableValue("cha_server_data", String(data.player_id_1));
    if (player_information_battlepass_1) 
    {
        if (one_player_nickname)
        {
            if (player_information_battlepass_1.nickname == 1)
            {
              if ( GameUI.CustomUIConfig().team_colors )
              {
                var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo_1.player_team_id ];
                if ( teamColor )
                {
                  one_player_nickname.style.color = teamColor
                }
              }
            }
            else if (player_information_battlepass_1.nickname == 2)
            {
              one_player_nickname.SetHasClass("rainbow_nickname", true)
              one_player_nickname.style.color = "gradient( linear, 100% 0%, 0% 0%, from( rgb(0, 183, 255)), color-stop( 0.5, rgb(0, 255, 85)), to( rgb(255, 196, 0)))"
            }
            else if (player_information_battlepass_1.nickname == 3)
            {
              one_player_nickname.SetHasClass("rainbow_nickname_animate", true)
            }
        }
    }

    var player_information_battlepass_2 = CustomNetTables.GetTableValue("cha_server_data", String(data.player_id_2));
    if (player_information_battlepass_2) 
    {
        if (two_player_nickname)
        {
      	     if (player_information_battlepass_1.nickname == 1)
              {
                if ( GameUI.CustomUIConfig().team_colors )
                {
                  var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo_2.player_team_id ];
                  if ( teamColor )
                  {
                    two_player_nickname.style.color = teamColor
                  }
                }
              }
              else if (player_information_battlepass_1.nickname == 2)
              {
                two_player_nickname.SetHasClass("rainbow_nickname", true)
                two_player_nickname.style.color = "gradient( linear, 100% 0%, 0% 0%, from( rgb(0, 183, 255)), color-stop( 0.5, rgb(0, 255, 85)), to( rgb(255, 196, 0)))"
              }
              else if (player_information_battlepass_1.nickname == 3)
              {
                two_player_nickname.SetHasClass("rainbow_nickname_animate", true)
              }  
        }
    }

   
	$.Schedule(4.5, function() {
		notification.RemoveClass("visible")
	})

	notification.DeleteAsync(5)
}

