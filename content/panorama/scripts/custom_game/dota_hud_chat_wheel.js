var favourites = new Array();
var nowrings = 8;
var selected_sound_current = undefined;
var nowselect = 0;
var default_button

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
    ["37",  "sounds_37"], 
    ["38",  "sounds_38"], 
    ["39",  "sounds_39"], 
    ["40",  "sounds_40"], 
    ["41",  "sounds_41"], 
    ["42",  "sounds_42"], 
    ["43",  "sounds_43"], 
    ["44",  "sounds_44"], 
    ["45",  "sounds_45"], 
    ["46",  "sounds_46"], 
    ["47",  "sounds_47"], 
    ["48",  "sounds_48"], 
    ["49",  "sounds_49"],
    ["50",  "sounds_50"],
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
        new Array("#sounds_120","#sounds_121","#sounds_122","#sounds_123","#sounds_124","#sounds_125","#sounds_126",""),
        new Array(true,true,true,true,true,true,true,false),
        new Array(120,121,122,123,124,125,126,0)
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

        $.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
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

        $.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
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

        $.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
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
    let ChatPanelSound = $.CreatePanelWithProperties("Panel", LinesPanel, "", { style:"margin-left:37px;flow-children: right;width:100%;" });
    let HeroIcon = $.CreatePanelWithProperties("Image", ChatPanelSound, "", { src:`${hero_icon}`, style:"width:40px;height:23px;margin-right:4px;border:1px solid black;" }); 
    let LabelPlayer = $.CreatePanelWithProperties("Label", ChatPanelSound, "", { text:`${player_name}` + ":", style:`${player_color_style}` });
    let SoundIcon = $.CreatePanelWithProperties("Image", ChatPanelSound, "", { class:"ChatWheelIcon", src:"file://{images}/hud/reborn/icon_scoreboard_mute_sound.psd" }); 
    let LabelSound = $.CreatePanelWithProperties("Label", ChatPanelSound, "", { text:`${sound_name}`, style:"font-size:18px;font-weight:bold;text-shadow: 1px 1.5px 0px 2 black;color:white;" });

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
    $.Schedule( 0.1, updatechatwheelbutton );
}