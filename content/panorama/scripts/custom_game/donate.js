var dotaHudChatControls = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ChatControls");
$("#SmilesButton").SetParent(dotaHudChatControls);
dotaHudChatControls.MoveChildBefore(dotaHudChatControls.FindChildTraverse("SmilesButton"), dotaHudChatControls.FindChildTraverse("ChatEmoticonButton"))
dotaHudChatControls.FindChildTraverse("ChatEmoticonButton").style.visibility = "collapse"

var toggle_battlepass = false;
var first_time_battlepass = false;
var cooldown_panel_battlepass = false
var timer_loading = -1

GameUI.CustomUIConfig().OpenPass = function ToggleBattlePass() {
    if (toggle_battlepass === false) {
        if (cooldown_panel_battlepass == false) {
            toggle_battlepass = true;
            if (first_time_battlepass === false) {
                first_time_battlepass = true;
                UpdateInformation();
                $("#BattlePassWindow").AddClass("sethidden");
            }  
            if ($("#BattlePassWindow").BHasClass("sethidden")) {
                $("#BattlePassWindow").RemoveClass("sethidden");
            }
            $("#BattlePassWindow").AddClass("setvisible");
            $("#BattlePassWindow").style.visibility = "visible"
            cooldown_panel_battlepass = true
            $.Schedule( 0.503, function(){
                cooldown_panel_battlepass = false
            })
        }
    } else {
        if (cooldown_panel_battlepass == false) {
            toggle_battlepass = false;
            if ($("#BattlePassWindow").BHasClass("setvisible")) {
                $("#BattlePassWindow").RemoveClass("setvisible");
            }
            $("#BattlePassWindow").AddClass("sethidden");
            cooldown_panel_battlepass = true
            $.Schedule( 0.503, function(){
                cooldown_panel_battlepass = false
                $("#BattlePassWindow").style.visibility = "collapse"
            })
        }
    }
}

var toggle_wheel = false;
var first_time_wheel = false;
var cooldown_panel_wheel = false

GameUI.CustomUIConfig().OpenWheel = function ToggleWheel() {
    if (toggle_wheel === false) {
        if (cooldown_panel_wheel == false) {
            toggle_wheel = true;
            UpdateInformation()
            if (first_time_wheel === false) {
                first_time_wheel = true;
                $("#WheelWindow").AddClass("sethidden");
            }  
            if ($("#WheelWindow").BHasClass("sethidden")) {
                $("#WheelWindow").RemoveClass("sethidden");
            }
            $("#WheelWindow").AddClass("setvisible");
            $("#WheelWindow").style.visibility = "visible"
            cooldown_panel_wheel = true
            $.Schedule( 0.503, function(){
                cooldown_panel_wheel = false
            })
        }
    } else {
        if (cooldown_panel_wheel == false) {
            toggle_wheel = false;
            if ($("#WheelWindow").BHasClass("setvisible")) {
                $("#WheelWindow").RemoveClass("setvisible");
            }
            $("#WheelWindow").AddClass("sethidden");
            cooldown_panel_wheel = true
            $.Schedule( 0.503, function(){
                cooldown_panel_wheel = false
                $("#WheelWindow").style.visibility = "collapse"
            })
        }
    }
}

var toggle_rewards = false;
var first_time_rewards = false;
var cooldown_panel_rewards = false

GameUI.CustomUIConfig().OpenRewards = function ToggleRewards() {
    if (toggle_rewards === false) {
        if (cooldown_panel_rewards == false) {
            toggle_rewards = true;
            if (first_time_rewards === false) {
                first_time_rewards = true;
                InitRewards()
                $("#RewardsWindow").AddClass("sethidden");
            }  
            if ($("#RewardsWindow").BHasClass("sethidden")) {
                $("#RewardsWindow").RemoveClass("sethidden");
            }
            $("#RewardsWindow").AddClass("setvisible");
            $("#RewardsWindow").style.visibility = "visible"
            cooldown_panel_rewards = true
            $.Schedule( 0.503, function(){
                cooldown_panel_rewards = false
            })
        }
    } else {
        if (cooldown_panel_rewards == false) {
            toggle_rewards = false;
            if ($("#RewardsWindow").BHasClass("setvisible")) {
                $("#RewardsWindow").RemoveClass("setvisible");
            }
            $("#RewardsWindow").AddClass("sethidden");
            cooldown_panel_rewards = true
            $.Schedule( 0.503, function(){
                cooldown_panel_rewards = false
                $("#RewardsWindow").style.visibility = "collapse"
            })
        }
    }
}

function UpdateInformation()
{
    let player_info = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_info) 
    {
        $("#DonateBattlePassDays1").text = (player_info.pass_level_1_days || 0)
        $("#DonateBattlePassDays2").text = (player_info.pass_level_3_days || 0)
        //$("#DonateBattlePassDays3").text = (player_info.pass_level_3_days || 0)

        $("#ArenaCoinLabel").text = player_info.game_coin || "0"
        $("#BalanceCoinChestLabel").text = player_info.game_coin || "0"
        $("#DonateCoinLabel").text = player_info.donate_coin || "0"

        $("#RewardsMain").RemoveAndDeleteChildren()
        InitRewards()
    }
}

function OpenBattlePassInfo(id)
{
    Game.EmitSound("ui.click_toptab")
    $("#" + id).style.visibility = "visible"
}

function CloseBattlePassInfo(id)
{
    Game.EmitSound("ui.click_alt")
    $("#" + id).style.visibility = "collapse"
}

GameEvents.Subscribe( 'donate_event_error', ErrorCreated );
GameEvents.Subscribe( 'donate_event_accept', AcceptCreated );

function battlepass_buy(coin_type, level, duration_type)
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "BattlePassBuy", {coin_type : coin_type, level : level, duration_type : duration_type } );
    $.Schedule( 1, function()
    {
        UpdateCalibratingTicket()
    })
}

function swap_currency(donate, arena)
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "SwapCurrency", {donate : donate, arena : arena } );
}

function ErrorCreated(data)
{
    Game.EmitSound("Relic.Received")
    if( timer_loading != -1 )
    {
        $.CancelScheduled(timer_loading)
    }
    LoadingClose()

    if (data && data.error_name)
    {
        $("#donate_error_label").text = $.Localize("#" + data.error_name)
    } else {
        $("#donate_error_label").text = $.Localize("#bp_error")
    }

    OpenBattlePassInfo('BuyBattlePassWindow_coinshop');

    $("#donate_error_window").style.visibility = "visible"
    $.Schedule(2 , ErrorClose);
    UpdateInformation()
}

function ErrorClose()
{
    $("#donate_error_window").style.visibility = "collapse"
}

function AcceptCreated()
{
    Game.EmitSound("ui.trophy_levelup")
    if( timer_loading != -1 )
    {
        $.CancelScheduled(timer_loading)
    }
    LoadingClose()
    $("#donate_accept_window").style.visibility = "visible"
    $.Schedule(2 , AcceptClose);
    UpdateInformation()
}

function AcceptClose()
{
    $("#donate_accept_window").style.visibility = "collapse"
}

function LoadingCreated()
{
    $("#donate_loading_window").style.visibility = "visible"
    timer_loading = $.Schedule(10 , LoadingClose);
}

function LoadingClose()
{
    $("#donate_loading_window").style.visibility = "collapse"
    UpdateInformation()
    timer_loading = -1;
}

// День, иконка, описание, название
  
var rewards_list = 
[
    ["1", "arena_coin", "#reward_arena_coin_30", "reward_1"],
    ["2", "arena_coin", "#reward_arena_coin_50", "reward_2"],
    ["3", "arena_coin", "#reward_arena_coin_70", "reward_3"],
    ["4", "arena_coin", "#reward_arena_coin_100", "reward_4"],
    ["5", "arena_coin", "#reward_arena_coin_150", "reward_5"],
    ["6", "donate_coin", "#reward_donate_coin_50", "reward_6"],

    ["7", "battlepass", "#reward_battlepass", "reward_7"], 

    ["8", "arena_coin", "#reward_arena_coin_30", "reward_8"],
    ["9", "arena_coin", "#reward_arena_coin_50", "reward_9"],
    ["10", "arena_coin", "#reward_arena_coin_70", "reward_10"],
    ["11", "arena_coin", "#reward_arena_coin_100", "reward_11"],
    ["12", "arena_coin", "#reward_arena_coin_150", "reward_12"],
    ["13", "donate_coin", "#reward_donate_coin_100", "reward_13"],
    ["14", "rating_ticket", "#rating_ticket", "reward_14"], 
    ["15", "battlepass", "#reward_battlepass", "reward_15"], 
]
 
function InitRewards()
{
    $("#RewardsMain").RemoveAndDeleteChildren()
    for (var i = 0; i < rewards_list.length; i++) {
        CreateReward(rewards_list[i])
    }
}

function CreateReward(reward_table)
{
    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))

    var RewardBlock = $.CreatePanel("Panel", $("#RewardsMain"), "reward_" + reward_table[0]);
    RewardBlock.AddClass("RewardBlock");

    var RewardName = $.CreatePanel("Label", RewardBlock, "");
    RewardName.AddClass("RewardName");
    RewardName.text = reward_table[0] + " " + $.Localize("#reward_day")

    var RewardIcon = $.CreatePanel("Panel", RewardBlock, "");
    RewardIcon.AddClass("RewardIcon");
    RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/donate/rewards/' + reward_table[1] + '.png")';
    RewardIcon.style.backgroundSize = "100%"

    var RewardDescription = $.CreatePanel("Label", RewardBlock, "");
    RewardDescription.AddClass("RewardDescription");
    RewardDescription.text = $.Localize(reward_table[2])

    var RewardReceive = $.CreatePanel("Panel", RewardBlock, "");
    RewardReceive.AddClass("RewardReceive");

    var RewardReceiveLabel = $.CreatePanel("Label", RewardReceive, "");
    RewardReceiveLabel.AddClass("RewardReceiveLabel");
    RewardReceiveLabel.text = $.Localize("#reward_button_receive")

    if (Number(player_table.month_rewards_days) >= Number(reward_table[0]))
    {
        RewardReceiveLabel.text = $.Localize("#reward_button_received")
        RewardReceive.AddClass("recive_reward")
    }

    if (Number(reward_table[0]) == Number(player_table.month_rewards_days))
    {
        if (player_table.month_days_disabled == 0)
        {
            RewardReceiveLabel.text = $.Localize("#reward_button_receive")
            RewardReceive.SetPanelEvent("onactivate", function() { RecieveReward(reward_table[3], reward_table[0]) } );
            RewardReceive.style.saturation = "1"
            RewardReceive.RemoveClass("recive_reward")
        } else {
            RewardReceiveLabel.text = $.Localize("#reward_button_received")
            RewardReceive.AddClass("recive_reward")
        }
    }

    if (Number(reward_table[0]) > Number(player_table.month_rewards_days))
    {
        RewardReceiveLabel.text = $.Localize("#reward_button_closed")
        RewardReceive.AddClass("closed_reward")
    }
}

function RecieveReward(reward_name, day)
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "RewardAccept", {reward_name : reward_name, day : day} );
}





var toggle_smiles = false;
var cooldown_panel_smiles = false

function ToggleSmiles() {
    if (toggle_smiles === false) {
        if (cooldown_panel_smiles == false) {
            toggle_smiles = true;
            if ($("#SmilesWindow").BHasClass("sethidden")) {
                $("#SmilesWindow").RemoveClass("sethidden");
            }
            InitSmiles()
            $("#SmilesWindow").AddClass("setvisible");
            $("#SmilesWindow").style.visibility = "visible"
            cooldown_panel_smiles = true
            $.Schedule( 0.503, function(){
                cooldown_panel_smiles = false
            })
        }
    } else {
        if (cooldown_panel_smiles == false) {
            toggle_smiles = false;
            if ($("#SmilesWindow").BHasClass("setvisible")) {
                $("#SmilesWindow").RemoveClass("setvisible");
            }
            $("#SmilesWindow").AddClass("sethidden");
            cooldown_panel_smiles = true
            $.Schedule( 0.503, function(){
                cooldown_panel_smiles = false
                $("#SmilesWindow").style.visibility = "collapse"
            })
        }
    }
}

CheckSmileContainer()

function CheckSmileContainer()
{
    var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("HudChat");
    if (parentHUDElements && !parentHUDElements.BHasClass("Active"))
    {
       if (toggle_smiles == true)
       {
            ToggleSmiles()
       } 
    }
    $.Schedule(0.1, CheckSmileContainer)
}

var smiles = 
[
    [51, "1"],
    [52, "3Head"],
    [53, "AYAYA"],
    [54, "BibleThump"],
    [55, "Catgasm"],
    [56, "CoolStoryBob"],
    [57, "Dolan"],
    [58, "EHEHE"],
    [59, "FeelsBadMan"],
    [60, "GachiBass"],
    [61, "GG"],
    [62, "HeavyBreathing"],
    [63, "Kappa"],
    [64, "LUL"],
    [65, "MaN"],
    [66, "monkaChrist"],
    [67, "monkaEyes"],
    [68, "monkaS"],
    [69, "NotLikeThis"],
    [70, "Pepega"],
    [71, "PLEASENO"],
    [72, "PressF"],
    [73, "pudge"],
    [74, "residentsleeper"],
    [75, "RIP"],
    [76, "SadCat"],
    [77, "seemsgood"],
    [78, "StrimPlz"],
    [79, "VaN"],
    [80, "weSmart"],
    [81, "wutface"],
    [82, "YouDied"],

    [83, "4head"],
    [84, "Agent"],
    [85, "BloodTrail"],
    [86, "CatWhat"],
    [87, "dogeKek"],
    [88, "EZ"],
    [89, "FacePalm"],
    [90, "Gigachad"],
    [91, "Kappapride"],
    [92, "KEKW"],
    [93, "Kreygasm"],
    [94, "OMEGALUL"],
    [95, "SuchMeme"],

    [96, "2Head"],
    [97, "Highroll"],
    [98, "KEKWait"],
    [99, "PogChamp"],
    [100, "Stonks"],
    [101, "WaitWhat"],
    [102, "WeronEZ"],

    [103, "1ntes_smile"],
    [104, "dwayne"],
    [105, "durka"],
]



















function InitSmiles()
{
    $("#SmilesWindow").RemoveAndDeleteChildren()
    for (var i = 0; i < smiles.length; i++) {
        CreateSmiles(smiles[i])
    }
}

function CreateSmiles(smile_table)
{
    let SmileBlock = $.CreatePanel("Panel", $("#SmilesWindow"), "");
    SmileBlock.AddClass("SmileBlock");

    let SmileIcon = $.CreatePanel("Panel", SmileBlock, "");
    SmileIcon.AddClass("SmileIcon");
    SmileIcon.style.backgroundImage = 'url("file://{images}/custom_game/donate/smiles/' + smile_table[1] + '.png")';
    SmileIcon.style.backgroundSize = "100%"

    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    let player_table_js = []

     for (var d = 1; d < 300; d++) {
         player_table_js.push(player_table.player_items[d])
     }

    let smile_deactivate = true
    
     for ( let item of player_table_js )
     {
         if (item == smile_table[0]) {
             smile_deactivate = false
             break
         }
     }
    if (smile_deactivate)
    {
        let blocked = $.CreatePanel("Panel", SmileBlock, "" );
        blocked.AddClass("BlockSmile");
    } else {
        SmileBlock.SetPanelEvent("onactivate", function() { 
            GameEvents.SendCustomGameEventToServer("SelectSmile", {id : smile_table[0], smile_icon : smile_table[1]});
        } );
    }
}

GameEvents.Subscribe( 'chat_cha_smile', ChatSmile );

function ChatSmile( data )
{
    let dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
    let Hudchat = dotaHud.FindChildTraverse("HudChat")
    let LinesPanel = Hudchat.FindChildTraverse("ChatLinesPanel")

    let hero_icon = "file://{images}/heroes/" + data.hero_name + ".png"
    let smile_icon = "file://{images}/custom_game/donate/smiles/" + data.smile_icon + ".png"
    let player_name = Players.GetPlayerName( data.player_id )
    let sound_name = data.sound_name
    let color = "white;"

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

    let player_color_style = "font-size:18px;font-weight:bold;text-shadow: 1px 1.5px 0px 2 black;color:" + color
    let ChatPanelSound = $.CreatePanelWithProperties("Panel", LinesPanel, "", { style:"margin-left:37px;flow-children: right;width:100%;" });
    let HeroIcon = $.CreatePanelWithProperties("Image", ChatPanelSound, "", { src:`${hero_icon}`, style:"width:40px;height:23px;margin-right:4px;border:1px solid black;" }); 
    let LabelPlayer = $.CreatePanelWithProperties("Label", ChatPanelSound, "", { text:`${player_name}` + ":", style:`${player_color_style}` });
    let LabelSound = $.CreatePanelWithProperties("Image", ChatPanelSound, "", { class:"SmileIcon", style:"width:35px;height:35px;", src:`${smile_icon}` }); 

    $.Schedule( 7, function(){
        if (ChatPanelSound) {
            ChatPanelSound.AddClass('ChatLine');  
        }
    })
}

function RollChestStart()
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "RollChestStart", {} );
}

GameEvents.Subscribe( 'wheel_update_items', wheel_update_items );

function wheel_update_items(data)
{
    for (var i = 1; i <= Object.keys(data.items_list).length; i++) {
        $("#chest_" + i).GetChild(0).style.fontSize = "16px"
        $("#chest_" + i).GetChild(0).text = $.Localize("#item_" + data.items_list[i] )
        let rare = false
        for (var r = 1; r <= Object.keys(data.rare_list).length; r++) {
            if (data.items_list[i] == data.rare_list[r])
            {
                rare = true
            }
        }
        if (rare)
        {
            $("#chest_" + i).GetChild(0).style.color = "gold"
        }
    }
}


GameEvents.Subscribe( 'wheel_change_animation', WheelChangeAnimation );

function WheelChangeAnimation(data)
{
    $("#ButtonChestOpen").style.visibility = "collapse"
    for (var i = 1; i <= 20; i++) {
        $("#chest_" + i).style.boxShadow = "black 0px 0px 15px 2px"
    }
    $("#chest_" + data.current_block).style.boxShadow = "gold 0px 0px 15px 3px"
    Game.EmitSound("random_wheel_lever")
}

GameEvents.Subscribe( 'wheel_gift_end', wheel_gift_end );

function wheel_gift_end(data)
{
    $("#ButtonChestOpen").style.visibility = "visible"
    Game.EmitSound("Gift_Unwrap_Stinger")

    $("#wheel_reward_panel_label2").text = $.Localize("#item_"+data.item_id)
    $("#wheel_reward_panel").style.visibility = "visible"
}

function CloseRewardPanel()
{
    for (var i = 1; i <= 20; i++) {
        $("#chest_" + i).GetChild(0).style.fontSize = "90px"
        $("#chest_" + i).GetChild(0).text = "?"
        $("#chest_" + i).GetChild(0).style.color = "white"
    }
    for (var i = 1; i <= 20; i++) {
        $("#chest_" + i).style.boxShadow = "black 0px 0px 15px 2px"
    }
    $("#wheel_reward_panel").style.visibility = "collapse"
    UpdateInformation()
}

function OpenDonateInfo()
{
    $("#donate_coin_panel").style.visibility = "visible"
}

function CloseDonateInfo()
{
    $("#donate_coin_panel").style.visibility = "collapse"
}

var calibrate_toggle = false;
var calibrate_first_time = false;
var calibrate_cooldown_panel = false

GameUI.CustomUIConfig().OpenCalibrate = function OpenCalibrate() 
{
    if (calibrate_toggle === false) {
        if (calibrate_cooldown_panel == false) {
            calibrate_toggle = true;
            UpdateCalibratingTicket()
            if (calibrate_first_time === false) {
                calibrate_first_time = true;
                $("#RacalibrateWindow").AddClass("sethidden");
            }  
            if ($("#RacalibrateWindow").BHasClass("sethidden")) {
                $("#RacalibrateWindow").RemoveClass("sethidden");
            }
            $("#RacalibrateWindow").AddClass("setvisible");
            $("#RacalibrateWindow").style.visibility = "visible"
            calibrate_cooldown_panel = true
            $.Schedule( 0.503, function(){
                calibrate_cooldown_panel = false
            })
        }
    } else {
        if (calibrate_cooldown_panel == false) {
            calibrate_toggle = false;
            if ($("#RacalibrateWindow").BHasClass("setvisible")) {
                $("#RacalibrateWindow").RemoveClass("setvisible");
            }
            $("#RacalibrateWindow").AddClass("sethidden");
            calibrate_cooldown_panel = true
            $.Schedule( 0.503, function(){
                calibrate_cooldown_panel = false
                $("#RacalibrateWindow").style.visibility = "collapse"
            })
        }
    }
}

function UpdateCalibratingTicket()
{
    let player_info = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_info) 
    {
        $("#TicketCount").text = $.Localize("#ticket_count") + player_info.ticket_calibrate
    }
}

function recalibrating_start()
{
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "rating_reset", {} );
    $.Schedule( 0.5, function()
    {
        UpdateCalibratingTicket()
    })
}