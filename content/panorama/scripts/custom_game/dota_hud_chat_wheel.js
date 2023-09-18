var favourites = new Array();
var nowrings = 8;
var selected_sound_current = undefined;
var nowselect = 0;
var default_button

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

var rings = new Array(

    new Array(//0 start
        new Array("","","","","","","",""),
        new Array(true,true,true,true,true,true,true,true),
    ),
    new Array(//1 Sound list 1
        new Array("#sounds_1","#sounds_2","#sounds_3","#sounds_4","#sounds_5","#sounds_6","#sounds_7","#sounds_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(1,2,3,4,5,6,7,8)
    ),
    new Array(//2 Sound list 2
        new Array("#sounds_9","#sounds_10","#sounds_11","#sounds_12","#sounds_13","#sounds_14","#sounds_15","#sounds_16"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(9,10,11,12,13,14,15,16)
    ),
    new Array(//3 Sound list 3
        new Array("#sounds_17","#sounds_18","#sounds_19","#sounds_20","#sounds_21","#sounds_22","#sounds_23","#sounds_24"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(17,18,19,20,21,22,23,24)
    ),
    new Array(//4 Sound list 4
        new Array("#sounds_25","#sounds_26","#sounds_27","#sounds_28","#sounds_29","#sounds_30","#sounds_31","#sounds_32"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(25,26,27,28,29,30,31,32)
    ),
    new Array(//5 Sound list 5
        new Array("#sounds_33","#sounds_34","#sounds_35","#sounds_36","#sounds_37","#sounds_38","#sounds_39","#sounds_40"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(33,34,35,36,37,38,39,40)
    ),
    new Array(//6 Sound list 6
        new Array("#sounds_41","#sounds_42","#sounds_43","#sounds_44","#sounds_45","#sounds_46","#sounds_47","#sounds_48"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(41,42,43,44,45,46,47,48)
    ),
    new Array(//7 Sprays list 1
        new Array("#sounds_49","#sounds_50","#sounds_106","#sounds_107","#sounds_108","#sounds_109","#sounds_110","#sounds_111"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(49,50,106,107,108,109,110,111)
    ),
    new Array(//7 Sprays list 1
        new Array("#sounds_112","#sounds_113","#sounds_114","#sounds_115","#sounds_116","#sounds_117","#sounds_118","#sounds_119"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(112,113,114,115,116,117,118,119)
    ),
    new Array(//7 Sprays list 1
        new Array("#sounds_120","#sounds_121","#sounds_122","#sounds_123","#sounds_124","#sounds_125","#sounds_126","#sounds_127"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(120,121,122,123,124,125,126,127)
    ),
    new Array(//8 Sprays list 1
        new Array("#sounds_128","#sounds_129","#sounds_130","#sounds_131","#sounds_132","#sounds_133","#sounds_134","#sounds_135"),
        new Array(true, true, true, true, true, true, true, true),
        new Array(128,129,130,131,132,133,134,135)
    ),
    new Array(//8 Sprays list 1
        new Array("#sounds_136", "#sounds_137", "#sounds_138", "#sounds_139", "#sounds_140", "#sounds_141", "#sounds_142", "#sounds_143"),
        new Array(true, true, true, true, true, true, true, true),
        new Array(136, 137, 138, 139, 140, 141, 142, 143)
    ),
    new Array(//8 Sprays list 1
        new Array("#sounds_144", "#sounds_145", "#sounds_146", "#sounds_147", "#sounds_148", "#sounds_149", "#sounds_150", "#sounds_151"),
        new Array(true, true, true, true, true, true, true, true),
        new Array(144, 145, 146, 147, 148, 149, 150, 151)
    ),
    new Array(//8 Sprays list 1
        new Array("#sounds_152", "#sounds_153", "#sounds_154", "#sounds_155", "#sounds_156", "#sounds_157", "#sounds_158", "#sounds_159"),
        new Array(true, true, true, true, true, true, true, true),
        new Array(152, 153, 154, 155, 156, 157, 158, 159)
    ),
    new Array(//8 Sprays list 1
        new Array("#sounds_160", "#sounds_161", "#sounds_162", "#sounds_163", "#sounds_164", "#sounds_165", "#sounds_166", "#sounds_167"),
        new Array(true, true, true, true, true, true, true, true),
        new Array(160, 161, 162, 163, 164, 165, 166, 167)
    ),
);

function StartWheel() {
    selected_sound_current = undefined;
    $("#Wheel").visible = true;
    $("#Bubble").visible = true;
    $("#PhrasesContainer").visible = true;
    $("#ChangeWheelButtons").visible = true;
    $("#ChangeWheelButtonLabel").text = (nowselect + 1) + " / " + rings.length
    $("#PhrasesContainer").RemoveAndDeleteChildren();
    for ( var i = 0; i < 8; i++ )
    {
        let properities_for_panel = {
            class: `MyPhrases`,
            onmouseactivate: `OnSelect(${i})`,
            onmouseover: `OnMouseOver(${i})`,
            onmouseout: `OnMouseOut(${i})`,
        };

        $.CreatePanel(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");

        if (nowselect != 0)
        {
             var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
             var player_table_js = []
            
             for (var d = 1; d < 300; d++) {
                 player_table_js.push(player_table.player_items[d])
             }
            
             var phase_deactive = true
            
             for ( var item of player_table_js )
             {
                 if (item == rings[nowselect][2][i]) {
                     phase_deactive = false
                     break
                 }
             }

             if (rings[nowselect][1][i] == false)
             {
                $("#Phrase"+i).style.visibility = "collapse"
             } else {
                $("#Phrase"+i).style.visibility = "visible"
             }

            $("#Phrase"+i).GetChild(0).GetChild(0).text = $.Localize(rings[nowselect][0][i]);

            if (phase_deactive) {   
                var blocked = $.CreatePanel("Panel", $("#Phrase"+i).GetChild(0), "" );
                blocked.AddClass("BlockChatWheel");
                $("#Phrase"+i).GetChild(0).style.washColor = "red"
            }
        } else {
            let name = $.Localize("#chatwheel_CHA_null")
            var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
            if (player_table)
            {
                if (player_table.chat_wheel)
                {
                    for ( var item of Items_sounds )
                    {
                        if (item[0] == String(player_table.chat_wheel[i+1])) {
                            name = $.Localize("#" + item[1])
                        }
                    }
                }
            }
            $("#Phrase"+i).GetChild(0).GetChild(0).text = name;
        }
    }
}

function LeftButton()
{
    if (nowselect - 1 < 0)
    {
        nowselect = rings.length - 1
    } else {
        nowselect = nowselect - 1
    }
    $("#ChangeWheelButtonLabel").text = (nowselect + 1) + " / " + rings.length
    $("#PhrasesContainer").RemoveAndDeleteChildren();
    for ( var i = 0; i < 8; i++ )
    {
        let properities_for_panel = {
            class: `MyPhrases`,
            onmouseactivate: `OnSelect(${i})`,
            onmouseover: `OnMouseOver(${i})`,
            onmouseout: `OnMouseOut(${i})`,
        };

        $.CreatePanel(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");

        if (nowselect != 0)
        {
             var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
             var player_table_js = []
            
             for (var d = 1; d < 300; d++) {
                 player_table_js.push(player_table.player_items[d])
             }
            
             var phase_deactive = true
            
             for ( var item of player_table_js )
             {
                 if (item == rings[nowselect][2][i]) {
                     phase_deactive = false
                     break
                 }
             }

             if (rings[nowselect][1][i] == false)
             {
                $("#Phrase"+i).style.visibility = "collapse"
             } else {
                $("#Phrase"+i).style.visibility = "visible"
             }

            $("#Phrase"+i).GetChild(0).GetChild(0).text = $.Localize(rings[nowselect][0][i]);

            if (phase_deactive) {   
                var blocked = $.CreatePanel("Panel", $("#Phrase"+i).GetChild(0), "" );
                blocked.AddClass("BlockChatWheel");
                $("#Phrase"+i).GetChild(0).style.washColor = "red"
            }
        } else {
            let name = $.Localize("#chatwheel_CHA_null")
            var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
            if (player_table)
            {
                if (player_table.chat_wheel)
                {
                    for ( var item of Items_sounds )
                    {
                        if (item[0] == String(player_table.chat_wheel[i+1])) {
                            name = $.Localize("#" + item[1])
                        }
                    }
                }
            }
            $("#Phrase"+i).GetChild(0).GetChild(0).text = name;
        }
    }
}

function RightButton()
{
    if (nowselect + 1 > (rings.length - 1))
    {
        nowselect = 0
    } else {
        nowselect = nowselect + 1
    }
    $("#ChangeWheelButtonLabel").text = (nowselect + 1) + " / " + rings.length
    $("#PhrasesContainer").RemoveAndDeleteChildren();
    for ( var i = 0; i < 8; i++ )
    {
        let properities_for_panel = {
            class: `MyPhrases`,
            onmouseactivate: `OnSelect(${i})`,
            onmouseover: `OnMouseOver(${i})`,
            onmouseout: `OnMouseOut(${i})`,
        };

        $.CreatePanel(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");

         if (nowselect != 0)
        {
             var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
             var player_table_js = []
            
             for (var d = 1; d < 300; d++) {
                 player_table_js.push(player_table.player_items[d])
             }
            
             var phase_deactive = true
            
             for ( var item of player_table_js )
             {
                 if (item == rings[nowselect][2][i]) {
                     phase_deactive = false
                     break
                 }
             }

             if (rings[nowselect][1][i] == false)
             {
                $("#Phrase"+i).style.visibility = "collapse"
             } else {
                $("#Phrase"+i).style.visibility = "visible"
             }

            $("#Phrase"+i).GetChild(0).GetChild(0).text = $.Localize(rings[nowselect][0][i]);

            if (phase_deactive) {   
                var blocked = $.CreatePanel("Panel", $("#Phrase"+i).GetChild(0), "" );
                blocked.AddClass("BlockChatWheel");
                $("#Phrase"+i).GetChild(0).style.washColor = "red"
            }
        } else {
            let name = $.Localize("#chatwheel_CHA_null")
            var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
            if (player_table)
            {
                if (player_table.chat_wheel)
                {
                    for ( var item of Items_sounds )
                    {
                        if (item[0] == String(player_table.chat_wheel[i+1])) {
                            name = $.Localize("#" + item[1])
                        }
                    }
                }
            }
            $("#Phrase"+i).GetChild(0).GetChild(0).text = name;
        }
    }
}



function StopWheel() {
    $("#Wheel").visible = false;
    $("#Bubble").visible = false;
    $("#PhrasesContainer").visible = false;
    $("#ChangeWheelButtons").visible = false;

    if (nowselect == 0)
    {
        var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
        if (player_table)
        {
            if (player_table.chat_wheel)
            {
                GameEvents.SendCustomGameEventToServer("SelectVO", {num: Number(player_table.chat_wheel[selected_sound_current+1])});
            }
        }
    } else {
        var newnum = rings[nowselect][2][selected_sound_current];
        if (rings[nowselect][1][selected_sound_current])
        {
            GameEvents.SendCustomGameEventToServer("SelectVO", {num: Number(newnum)});
        }
    }

    selected_sound_current = undefined;
}

function OnSelect(num) {
    if (nowselect == 0)
    {
        var player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
        if (player_table)
        {
            if (player_table.chat_wheel)
            {
                GameEvents.SendCustomGameEventToServer("SelectVO", {num: Number(player_table.chat_wheel[num+1])});
            }
        }
    } else {
        var newnum = rings[nowselect][2][num];
        if (rings[nowselect][1][num])
        {
            GameEvents.SendCustomGameEventToServer("SelectVO", {num: Number(newnum)});
        }
    }
    selected_sound_current = undefined;
}

function OnMouseOver(num) {
    selected_sound_current = num;
    $( "#WheelPointer" ).RemoveClass( "Hidden" );
    $( "#Arrow" ).RemoveClass( "Hidden" );
    for ( var i = 0; i < 8; i++ )
    {
        if ($("#Wheel").BHasClass("ForWheel"+i))
            $( "#Wheel" ).RemoveClass( "ForWheel"+i );
    }
    $( "#Wheel" ).AddClass( "ForWheel"+num );
}

function OnMouseOut(num) {
    selected_sound_current = undefined;
    $( "#WheelPointer" ).AddClass( "Hidden" );
    $( "#Arrow" ).AddClass( "Hidden" );
}

GameEvents.Subscribe( 'chat_cha_sound', ChatSound );

function ChatSound( data )
{
    let dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
    let Hudchat = dotaHud.FindChildTraverse("HudChat")
    let LinesPanel = Hudchat.FindChildTraverse("ChatLinesPanel")

    let hero_icon = "file://{images}/heroes/" + data.hero_name + ".png"
    let player_name = Players.GetPlayerName( data.player_id )
    let sound_name = data.sound_name
    let color = "white;"

    if (Game.IsPlayerMuted( data.player_id ) || Game.IsPlayerMutedVoice( data.player_id ) || Game.IsPlayerMutedText( data.player_id )) {
        return
    }

    if (GameUI.CustomUIConfig().MuteSoundsChatWheel != null)
    {
        if ((GameUI.CustomUIConfig().MuteSoundsChatWheel == true))
        {
            return
        }
    }

    var playerInfo = Game.GetPlayerInfo( data.player_id );
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

    Game.EmitSound(data.sound_name_global)

    let player_color_style = "font-size:18px;font-weight:bold;text-shadow: 1px 1.5px 0px 2 black;color:" + color
    let ChatPanelSound = $.CreatePanel("Panel", LinesPanel, "", { style:"margin-left:37px;flow-children: right;width:100%;" });
    let HeroIcon = $.CreatePanel("Image", ChatPanelSound, "", { src:`${hero_icon}`, style:"width:40px;height:23px;margin-right:4px;border:1px solid black;" }); 
    let LabelPlayer = $.CreatePanel("Label", ChatPanelSound, "", { text:`${player_name}` + ":", style:`${player_color_style}` });
    let SoundIcon = $.CreatePanel("Image", ChatPanelSound, "", { class:"ChatWheelIcon", src:"file://{images}/hud/reborn/icon_scoreboard_mute_sound.psd" }); 
    let LabelSound = $.CreatePanel("Label", ChatPanelSound, "", { text:`${sound_name}`, style:"font-size:18px;font-weight:bold;text-shadow: 1px 1.5px 0px 2 black;color:white;" });

    $.Schedule( 3, function(){
        if (ChatPanelSound) {
            ChatPanelSound.AddClass('ChatLine');  
        }
    })
}

(function() {
	GameUI.CustomUIConfig().chatWheelLoaded = true;

    const name_bind = "WheelButton" + Math.floor(Math.random() * 99999999);
    Game.AddCommand("+" + name_bind, StartWheel, "", 0);
    Game.AddCommand("-" + name_bind, StopWheel, "", 0);
    Game.CreateCustomKeyBind(GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_WHEEL), "+" + name_bind);
    default_button = GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_WHEEL)

    updatechatwheelbutton()

    $("#Wheel").visible = false;
    $("#Bubble").visible = false;
    $("#PhrasesContainer").visible = false;
    $("#ChangeWheelButtons").visible = false;
})();

function GetGameKeybind(command) {
    return Game.GetKeybindForCommand(command);
}

function updatechatwheelbutton()
{
    if (default_button != GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_WHEEL) ) {
        const name_bind = "WheelButton" + Math.floor(Math.random() * 99999999);
        Game.AddCommand("+" + name_bind, StartWheel, "", 0);
        Game.AddCommand("-" + name_bind, StopWheel, "", 0);
        Game.CreateCustomKeyBind(GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_WHEEL), "+" + name_bind);
        default_button = GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_WHEEL)
    }
    $.Schedule( 1, updatechatwheelbutton );
}