var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

GameUI.CustomUIConfig().OpenCustomize = function ToggleGuide() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                InitCustomize()
                first_time = true;
                $("#CustomizeProfileWindow").AddClass("sethidden");
            }  
            if ($("#CustomizeProfileWindow").BHasClass("sethidden")) {
                $("#CustomizeProfileWindow").RemoveClass("sethidden");
            }
            $("#CustomizeProfileWindow").AddClass("setvisible");
            $("#CustomizeProfileWindow").style.visibility = "visible"
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#CustomizeProfileWindow").BHasClass("setvisible")) {
                $("#CustomizeProfileWindow").RemoveClass("setvisible");
            }
            $("#CustomizeProfileWindow").AddClass("sethidden");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
                $("#CustomizeProfileWindow").style.visibility = "collapse"
            })
        }
    }
}

function InitCustomize()
{
    let player_table = CustomNetTables.GetTableValue("cha_server_data", Players.GetLocalPlayer())

    if (player_table)
    {
        $("#nickname_id_0").SetHasClass("active", false)
        $("#frame_id_0").SetHasClass("active", false)
        $("#nickname_id_1").SetHasClass("active", false)
        $("#frame_id_1").SetHasClass("active", false)
        $("#nickname_id_2").SetHasClass("active", false)
        $("#frame_id_2").SetHasClass("active", false)
        $("#nickname_id_3").SetHasClass("active", false)
        $("#frame_id_3").SetHasClass("active", false)
        $("#effect_id_0").SetHasClass("active", false)
        $("#effect_id_1").SetHasClass("active", false)
        $("#effect_id_2").SetHasClass("active", false)

        $("#nickname_id_0").SetHasClass("closed", false)
        $("#frame_id_0").SetHasClass("closed", false)
        $("#effect_id_0").SetHasClass("closed", false)

        $("#nickname_id_0").SetPanelEvent("onactivate", function() 
        { 
            GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 0} );
        });

        $("#frame_id_0").SetPanelEvent("onactivate", function() 
        { 
            GameEvents.SendCustomGameEventToServer( "change_frame_customoze", {id : 0} );
        });

        $("#effect_id_0").SetPanelEvent("onactivate", function() 
        { 
            GameEvents.SendCustomGameEventToServer( "change_effect_customoze", {id : 0} );
        });

        if (player_table.pass_level_1_days > 0)
        {
            $("#nickname_id_1").SetHasClass("closed", false)
            
            $("#nickname_id_1").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 1} );
            });
        }
        if (player_table.pass_level_2_days > 0)
        {
            $("#nickname_id_1").SetHasClass("closed", false)
            $("#nickname_id_2").SetHasClass("closed", false)

            $("#nickname_id_1").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 1} );
            });

            $("#nickname_id_2").SetPanelEvent("onactivate", function() 
            { 
               GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 2} ); 
            });
        }
        if (player_table.pass_level_3_days > 0)
        {
            $("#nickname_id_1").SetHasClass("closed", false)
            $("#frame_id_1").SetHasClass("closed", false)
            $("#nickname_id_2").SetHasClass("closed", false)
            $("#frame_id_2").SetHasClass("closed", false)
            $("#nickname_id_3").SetHasClass("closed", false)
            $("#frame_id_3").SetHasClass("closed", false)

            $("#nickname_id_1").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 1} );
            });

            $("#frame_id_1").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_frame_customoze", {id : 1} );
            });

            $("#nickname_id_2").SetPanelEvent("onactivate", function() 
            { 
               GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 2} ); 
            });

            $("#frame_id_2").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_frame_customoze", {id : 2} );
            });

            $("#nickname_id_3").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_nickname_customize", {id : 3} );
            });

            $("#frame_id_3").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_frame_customoze", {id : 3} );
            });
        }

         var player_table_js = []
        
         for (var d = 1; d < 300; d++) {
             player_table_js.push(player_table.player_items[d])
         }
        
         var has_top1_season = false
         var has_top2_season = false
        
         for ( var item of player_table_js )
         {
             if (item == 127) 
             {
                 has_top1_season = true
             }
             if (item == 128) 
             {
                 has_top2_season = true
             }
         }

         if (has_top1_season)
         {
            $("#effect_id_1").SetHasClass("closed", false)
            $("#effect_id_1").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_effect_customoze", {id : 1} );
            });
         }

         if (has_top2_season)
         {
            $("#effect_id_2").SetHasClass("closed", false)
            $("#effect_id_2").SetPanelEvent("onactivate", function() 
            { 
                GameEvents.SendCustomGameEventToServer( "change_effect_customoze", {id : 2} );
            });
         }

        if (typeof player_table.effect !== 'undefined') {
            $("#effect_id_" + player_table.effect).SetHasClass("active", true)
        }
        if (typeof player_table.nickname !== 'undefined') {
            $("#nickname_id_" + player_table.nickname).SetHasClass("active", true)
        }
        if (typeof player_table.frame !== 'undefined') {
            $("#frame_id_" + player_table.frame).SetHasClass("active", true)
        }
    }
}

CustomNetTables.SubscribeNetTableListener( "cha_server_data", UpdateChaData );

function UpdateChaData(table, key, data ) {
    if (table == "cha_server_data") {
        if (key == Players.GetLocalPlayer()) 
        {
            InitCustomize()
        }
    }
}