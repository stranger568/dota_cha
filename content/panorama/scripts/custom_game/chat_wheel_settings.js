var toggle = false;
var first_time = false;
var cooldown_panel = false

var Items_sounds = [
    //Обычные фразы
    ["1", "item_1"],
    ["2", "item_2"],
    ["3", "item_3"],
    ["4", "item_4"],
    ["5", "item_5"],
    ["6", "item_6"],
    ["7", "item_7"],
    ["8", "item_8"],
    ["9", "item_9"],
    ["10", "item_10"],
    ["11", "item_11"],
    ["12", "item_12"],
    ["13", "item_13"],
    ["14", "item_14"],
    ["15", "item_15"],
    ["16", "item_16"],
    ["17", "item_17"],
    ["18", "item_18"],
    ["19", "item_19"],
    ["20", "item_20"],
    ["21", "item_21"],
    ["22", "item_22"],
    ["23", "item_23"],
    ["24", "item_24"],
    ["25", "item_25"],
    ["26", "item_26"],
    ["27", "item_27"],
    ["28", "item_28"],
    ["29", "item_29"],
    ["106", "item_106"],
    ["107", "item_107"],
    ["108", "item_108"],
    ["109", "item_109"],
    ["112", "item_112"],
    ["113", "item_113"],
    ["114", "item_114"],
    ["115", "item_115"],
    ["116", "item_116"],
    ["117", "item_117"],
    ["118", "item_118"],
    ["120", "item_120"],
    ["121", "item_121"],
    ["123", "item_123"],
    ["124", "item_124"],
    ["129", "item_129"],
    ["130", "item_130"],
    ["131", "item_131"],
    ["132", "item_132"],
    ["134", "item_134"],
    ["135", "item_135"],
    ["139", "item_139"],
    ["140", "item_140"],
    ["141", "item_141"],
    ["162", "item_162"],

    //Редкие фразы
    ["30", "item_30"],
    ["31", "item_31"],
    ["32", "item_32"],
    ["33", "item_33"],
    ["34", "item_34"],
    ["35", "item_35"],
    ["36", "item_36"],
    ["37", "item_37"],
    ["38", "item_38"],
    ["39", "item_39"],
    ["40", "item_40"],
    ["112", "item_112"],
    ["111", "item_111"],
    ["119", "item_119"],
    ["122", "item_122"],
    ["125", "item_125"],
    ["126", "item_126"],
    ["127", "item_127"],
    ["128", "item_128"],
    ["110", "item_110"],
    ["145", "item_145"],
    ["146", "item_146"],
    ["147", "item_147"],
    ["148", "item_148"],
    ["149", "item_149"],
    ["150", "item_150"],
    ["151", "item_151"],
    ["152", "item_152"],
    ["153", "item_153"],
    ["161", "item_161"],
    ["133", "item_133"],
    ["136", "item_136"],
    ["137", "item_137"],
    ["138", "item_138"],
    
    //Уникальные фразы
    ["154", "item_154"],
    ["155", "item_155"],
    ["156", "item_156"],
    ["157", "item_157"],
    ["158", "item_158"],
    ["159", "item_159"],
    ["160", "item_160"],
    ["163", "item_163"],
    ["164", "item_164"],

    ["165", "item_165"],
    ["166", "item_166"],
    ["167", "item_167"],
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