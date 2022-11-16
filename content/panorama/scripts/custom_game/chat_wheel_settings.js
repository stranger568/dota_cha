var toggle = false;
var first_time = false;
var cooldown_panel = false

var Items_sounds = [
    ["1",  "sounds_1"], 
    ["2",  "sounds_2"], 
    ["3",  "sounds_3"], 
    ["4",  "sounds_4"],
    ["5",  "sounds_5"], 
    ["6",  "sounds_6"], 
    ["7",  "sounds_7"], 
    ["8",  "sounds_8"], 
    ["9",  "sounds_9"], 
    ["10",  "sounds_10"], 
    ["11",  "sounds_11"], 
    ["12",  "sounds_12"], 
    ["13",  "sounds_13"], 
    ["14",  "sounds_14"], 
    ["15",  "sounds_15"], 
    ["16",  "sounds_16"],
    ["17",  "sounds_17"], 
    ["18",  "sounds_18"], 
    ["19",  "sounds_19"], 
    ["20",  "sounds_20"], 
    ["21",  "sounds_21"], 
    ["22",  "sounds_22"], 
    ["23",  "sounds_23"], 
    ["24",  "sounds_24"],
    ["25",  "sounds_25"], 
    ["26",  "sounds_26"], 
    ["27",  "sounds_27"], 
    ["28",  "sounds_28"], 
    ["29",  "sounds_29"], 
    ["30",  "sounds_30"], 
    ["31",  "sounds_31"], 
    ["32",  "sounds_32"], 
    ["33",  "sounds_33"], 
    ["34",  "sounds_34"], 
    ["35",  "sounds_35"], 
    ["36",  "sounds_36"], 
    ["37", 	"sounds_37"], 
    ["38", 	"sounds_38"], 
    ["39", 	"sounds_39"], 
    ["40", 	"sounds_40"], 
    ["41", 	"sounds_41"], 
    ["42", 	"sounds_42"], 
    ["43", 	"sounds_43"], 
    ["44", 	"sounds_44"], 
    ["45", 	"sounds_45"], 
    ["46", 	"sounds_46"], 
    ["47", 	"sounds_47"], 
    ["48", 	"sounds_48"], 
    ["49", 	"sounds_49"],
    ["50", 	"sounds_50"],
    ["106", "sounds_106"],

    ["107", "sounds_107"],
    ["108", "sounds_108"],
    ["109", "sounds_109"],
    ["110", "sounds_110"],
    ["111", "sounds_111"],
    ["112", "sounds_112"],
    ["113", "sounds_113"],
    ["114", "sounds_114"],

    ["115", "sounds_115"],
    ["116", "sounds_116"],
    ["117", "sounds_117"],
    ["118", "sounds_118"],
    ["119", "sounds_119"],
    ["120", "sounds_120"],
    ["121", "sounds_121"],
    ["122", "sounds_122"],
    ["123", "sounds_123"],
    ["124", "sounds_124"],
    ["125", "sounds_125"],
    ["126", "sounds_126"],
]

GameUI.CustomUIConfig().OpenChatWheel = function ToggleChatWheelSettingsButton() {
    if (toggle === false) {
    	if (cooldown_panel == false) {
	        toggle = true;
	        if (first_time === false) {
	            first_time = true;
	            $("#ChatWheelSettingsPanel").AddClass("sethidden");
				InitCHAChatWheel()
	        }  
	        if ($("#ChatWheelSettingsPanel").BHasClass("sethidden")) {
	            $("#ChatWheelSettingsPanel").RemoveClass("sethidden");
	        }
	        $("#ChatWheelSettingsPanel").AddClass("setvisible");
	        $("#ChatWheelSettingsPanel").style.visibility = "visible"
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        })
	    }
    } else {
    	if (cooldown_panel == false) {
	        toggle = false;
	        if ($("#ChatWheelSettingsPanel").BHasClass("setvisible")) {
	            $("#ChatWheelSettingsPanel").RemoveClass("setvisible");
	        }
	        $("#ChatWheelSettingsPanel").AddClass("sethidden");
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        	$("#ChatWheelSettingsPanel").style.visibility = "collapse"
			})
		}
    }
}

function InitCHAChatWheel()
{
	var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
	if (player_table)
	{
		if (player_table.chat_wheel)
		{
			for (var i = 1; i <= 8; i++) {
				
				let name = $.Localize("#chatwheel_CHA_null")
				for ( var item of Items_sounds )
				{
					if (item[0] == String(player_table.chat_wheel[i])) {
						name = $.Localize("#" + item[1])
					}
				}

				$( "#chat_wheel_CHA_"+i ).text = name
			}
		}
	}
}

function CloseSelectChatWheel()
{
  	$("#info_select_chat_wheel").style.visibility = "collapse"
  	$("#ChatWheelSelectList").RemoveAndDeleteChildren()
}

function OpenSelectChatWheel(id)
{
    $("#info_select_chat_wheel").style.visibility = "visible"
	var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
	var player_table_js = []
	for (var d = 1; d < 300; d++) {
		player_table_js.push(player_table.player_items[d])
	}

	var chatwheel_row = $.CreatePanel("Panel", $("#ChatWheelSelectList"), "");
	chatwheel_row.AddClass("chatwheel_row_title");

	var chatwheel_row_label = $.CreatePanel("Label", chatwheel_row, "");
	chatwheel_row_label.AddClass("chatwheel_row_label_title");
	chatwheel_row_label.text = $.Localize("#CHAPass_sound_1")

	for ( var item_inventory of player_table_js )
    {
    	for ( var item of Items_sounds )
    	{
			if (item_inventory == item[0]) {
				CreateChatWheelSelectItem(id, item[1], item[0])
			}
    	}
	}
}

function CreateChatWheelSelectItem(id, label, item)
{
    let chatwheel_row = $.CreatePanel("Panel", $("#ChatWheelSelectList"), "");
	chatwheel_row.AddClass("chatwheel_row");

	let chatwheel_row_label = $.CreatePanel("Label", chatwheel_row, "");
	chatwheel_row_label.AddClass("chatwheel_row_label");
	chatwheel_row_label.text = $.Localize("#" + label)

	chatwheel_row.SetPanelEvent("onactivate", function() { 
		GameEvents.SendCustomGameEventToServer( "SelectChatWheel", {id : id, item : item } );
		$.Schedule( 0.25, function(){
			InitCHAChatWheel()
			CloseSelectChatWheel()
		})
	})
}