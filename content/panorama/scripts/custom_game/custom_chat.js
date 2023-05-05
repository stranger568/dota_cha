const NON_BREAKING_SPACE = "\u00A0";
const BASE_MESSAGE_INDENT = NON_BREAKING_SPACE.repeat(19);

GameEvents.Subscribe("custom_chat_message", (event) => {
	let text = BASE_MESSAGE_INDENT;

	const chatLinesPanel = FindDotaHudElement("ChatLinesPanel");
	const message = $.CreatePanelWithProperties("Label", chatLinesPanel, "", {
		class: "ChatLine",
		html: "true",
		selectionpos: "auto",
		hittest: "false",
		hittestchildren: "false",
	});
	message.style.flowChildren = "right";
	message.style.color = "#faeac9";
	message.style.opacity = 1;
	$.Schedule(7, () => {
		message.style.opacity = null;
	});

	if (event.PlayerID > -1) {
		const playerInfo = Game.GetPlayerInfo(event.PlayerID);
		const localTeamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];

		text += event.isTeam ? `[${$.Localize("#DOTA_ChatCommand_GameAllies_Name")}] ` : NON_BREAKING_SPACE;
		text += `<font color='${localTeamColor}'>${playerInfo.player_name}</font>: `;

		$.CreatePanelWithProperties("Panel", message, "", { class: "HeroBadge", selectionpos: "auto" });

		const heroIcon = $.CreatePanelWithProperties("Image", message, "", { class: "HeroIcon", selectionpos: "auto" });
		heroIcon.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png");
	} else {
		text += event.isTeam ? `[${$.Localize("#DOTA_ChatCommand_GameAllies_Name")}] ` : NON_BREAKING_SPACE;
	}

	text += event.textData.replace(/%%\d*(.+?)%%/g, (_, token) => $.Localize("#"+token));
	message.text = text;
});

ThinkCameraPosition()
var current_vision = null

function ThinkCameraPosition()
{
    let camPosition = GameUI.GetCameraLookAtPosition();
    let map = Game.GetMapInfo().map_display_name

    if (map == "1x8" || map == "1x8_pve") 
    {
	    let center_arena = 	[0,0,0]

	    let arena1_position = [5376, 320, 128]
	    let arena2_position = [4416, -4416, 128]
	    let arena3_position = [-4288, -4352, 128]
	    let arena4_position = [64, -5312, 128]
	    let arena5_position = [-5376, 0, 128]
	    let arena6_position = [-4544, 4608, 128]
	    let arena7_position = [0, 5376, 128]
	    let arena8_position = [4608, 4800, 128]

		if ( Game.Length2D( camPosition, arena1_position ) < 1400 ) 
		{
			if (current_vision != 1)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 5376, y : 320, z : 128} );
				current_vision = 1
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena2_position ) < 1400 ) 
		{
			if (current_vision != 2)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 4416, y : -4416, z : 128} );
				current_vision = 2
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena3_position ) < 1400 ) 
		{
			if (current_vision != 3)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : -4288, y : -4352, z : 128} );
				current_vision = 3
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena4_position ) < 1400 ) 
		{
			if (current_vision != 4)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 64, y : -5312, z : 128} );
				current_vision = 4
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena5_position ) < 1400 ) 
		{
			if (current_vision != 5)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : -5376, y : 0, z : 128} );
				current_vision = 5
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena6_position ) < 1400 ) 
		{
			if (current_vision != 6)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : -4544, y : 4608, z : 128} );
				current_vision = 6
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena7_position ) < 1400 ) 
		{
			if (current_vision != 7)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 0, y : 5376, z : 128} );
				current_vision = 7
			}
			
		} 
		else if ( Game.Length2D( camPosition, arena8_position ) < 1400 ) 
		{
			if (current_vision != 8)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 4608, y : 4800, z : 128} );
				current_vision = 8
			}
		}
    } else if (map == "2x6") {
	    let center_arena = 	[0,0,0]
	    let arena1_position =	[5376, 320, 128]
	    let arena2_position =	[2609.3, -5621.45, 128]
	    let arena3_position =	[-5376, 0, 128]
	    let arena4_position =	[-2619.91, 5133.2, 128]
	    let arena5_position =	[2399.39, 4899.61, 128]
	    let arena6_position =	[-2520.51, -5353.72, 128]

		if ( Game.Length2D( camPosition, arena1_position ) < 1700 ) 
		{
			if (current_vision != 1)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 5376, y : 320, z : 128} );
				current_vision = 1
			}
		} 
		else if ( Game.Length2D( camPosition, arena2_position ) < 1700 ) 
		{
			if (current_vision != 2)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 2699.3, y : -5621.45, z : 128} );
				current_vision = 2
			}
		} 
		else if ( Game.Length2D( camPosition, arena3_position ) < 1700 ) 
		{
			if (current_vision != 3)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : -5376, y : 0, z : 128} );
				current_vision = 3
			}
		} 
		else if ( Game.Length2D( camPosition, arena4_position ) < 1700 ) 
		{
			if (current_vision != 4)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : -2619.91, y : 5133.2, z : 128} );
				current_vision = 4
			}
		} 
		else if ( Game.Length2D( camPosition, arena5_position ) < 1700 ) 
		{
			if (current_vision != 5)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : 2699, y : 5133.61, z : 128} );
				current_vision = 5
			}
		} 
		else if ( Game.Length2D( camPosition, arena6_position ) < 1700 ) 
		{
			if (current_vision != 6)
			{
				GameEvents.SendCustomGameEventToServer( 'cha_update_camera_visible', {x : -2520.51, y : -5353.72, z : 128} );
				current_vision = 6
			}
		}
    }

    $.Schedule(1/144, ThinkCameraPosition)
}

GameEvents.Subscribe("set_player_icon", set_player_icon);
function set_player_icon(data)
{	
	Entities.SetMinimapIcon( data.entity, "minimap_heroicon_" + Entities.GetUnitName(data.hero) );
}

GameEvents.Subscribe( 'set_camera_target', SetCamera );
function SetCamera( data )
{
	GameUI.SetCameraTargetPosition(data.location, 0.003);
} 

GameEvents.Subscribe("check_smoke_disabled", check_smoke_disabled);
function check_smoke_disabled(data)
{	
	if (GameUI.IsControlDown())
	{
		GameEvents.SendCustomGameEventToServer( 'RemoveSmoke', {unit: data.unit} );
	}
}

function GetGameKeybind(command) 
{
    return Game.GetKeybindForCommand(command);
}

function set_pause(data)
{	
	GameEvents.SendCustomGameEventToServer( 'PauseGame', {} );
}

GameEvents.Subscribe("player_unpause_chat", player_unpause_chat);

function player_unpause_chat( data )
{
	let dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	let Hudchat = dotaHud.FindChildTraverse("HudChat")
	let LinesPanel = Hudchat.FindChildTraverse("ChatLinesPanel")

	let player_name = Players.GetPlayerName( data.id )
	let hero_name = player_name + " " + $.Localize("#cha_unpause_player")
	let color = "white;"

	var playerInfo = Game.GetPlayerInfo( data.id );
	if ( playerInfo )
	{
		if ( GameUI.CustomUIConfig().team_colors )
		{
			var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
			if ( teamColor )
			{
				color = teamColor;
			}
		}
	}

	let player_color_style = "font-size:18px;font-weight:bold;text-shadow: 1px 1.5px 0px 2 black;color:" + color
	let ChatPanelSound = $.CreatePanelWithProperties("Panel", LinesPanel, "", { style:"margin-left:37px;flow-children: right;width:100%;" });
	let LabelSound = $.CreatePanelWithProperties("Label", ChatPanelSound, "", { text:`${hero_name}`, style:"font-size:18px;font-weight:bold;text-shadow: 1px 1.5px 0px 2 black;color:white;" });

	$.Schedule( 7, function(){
		if (ChatPanelSound) {
	    	ChatPanelSound.AddClass('ChatLine');  
		}
	})
}

(function() {

	const name_bind = "set_pause" + Math.floor(Math.random() * 99999999);
    Game.AddCommand(name_bind, set_pause, "", 0);
    Game.CreateCustomKeyBind(GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_PAUSE), name_bind);
})();


