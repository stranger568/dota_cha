var dotaHudChatControls = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ChatControls");
$("#SmilesButton").SetParent(dotaHudChatControls);
dotaHudChatControls.MoveChildBefore(dotaHudChatControls.FindChildTraverse("SmilesButton"), dotaHudChatControls.FindChildTraverse("ChatEmoticonButton"))
dotaHudChatControls.FindChildTraverse("ChatEmoticonButton").style.visibility = "collapse"

var toggle_battlepass = false;
var first_time_battlepass = false;
var cooldown_panel_battlepass = false
var timer_loading = -1
var current_tab

/////////// BattlePass /////////////
var current_choose_month_bp = 0
var current_info = 0
var timer_info = -1
var shop_delay = false
var bp_info = 
[
    ["#bp_reward_inf1", "1"],
    ["#bp_reward_inf2", "2"],
    ["#bp_reward_inf3", "3"],
    ["#bp_reward_inf4", "4"],
    ["#bp_reward_inf5", "5"],
    ["#bp_reward_inf6", "6"],
    ["#bp_reward_inf7", "7"],
    ["#bp_reward_inf8", "8"],
    ["#bp_reward_inf9", "9"],
]
var shop_info = 
[
    //Обычные фразы
    [1, 500, "item_1", "sound", "arena"],
    [2, 500, "item_2", "sound", "arena"],
    [3, 500, "item_3", "sound", "arena"],
    [4, 500, "item_4", "sound", "arena"],
    [5, 500, "item_5", "sound", "arena"],
    [6, 500, "item_6", "sound", "arena"],
    [7, 500, "item_7", "sound", "arena"],
    [8, 500, "item_8", "sound", "arena"],
    [9, 500, "item_9", "sound", "arena"],
    [10, 500, "item_10", "sound", "arena"],
    [11, 500, "item_11", "sound", "arena"],
    [12, 500, "item_12", "sound", "arena"],
    [13, 500, "item_13", "sound", "arena"],
    [14, 500, "item_14", "sound", "arena"],
    [15, 500, "item_15", "sound", "arena"],
    [16, 500, "item_16", "sound", "arena"],
    [17, 500, "item_17", "sound", "arena"],
    [18, 500, "item_18", "sound", "arena"],
    [19, 500, "item_19", "sound", "arena"],
    [20, 500, "item_20", "sound", "arena"],
    [21, 500, "item_21", "sound", "arena"],
    [22, 500, "item_22", "sound", "arena"],
    [23, 500, "item_23", "sound", "arena"],
    [24, 500, "item_24", "sound", "arena"],
    [25, 500, "item_25", "sound", "arena"],
    [26, 500, "item_26", "sound", "arena"],
    [27, 500, "item_27", "sound", "arena"],
    [28, 500, "item_28", "sound", "arena"],
    [29, 500, "item_29", "sound", "arena"],
    [106, 500, "item_106", "sound", "arena"],
    [107, 500, "item_107", "sound", "arena"],
    [108, 500, "item_108", "sound", "arena"],
    [109, 500, "item_109", "sound", "arena"],
    [112, 500, "item_112", "sound", "arena"],
    [113, 500, "item_113", "sound", "arena"],
    [114, 500, "item_114", "sound", "arena"],
    [115, 500, "item_115", "sound", "arena"],
    [116, 500, "item_116", "sound", "arena"],
    [117, 500, "item_117", "sound", "arena"],
    [118, 500, "item_118", "sound", "arena"],
    [120, 500, "item_120", "sound", "arena"],
    [121, 500, "item_121", "sound", "arena"],
    [123, 500, "item_123", "sound", "arena"],
    [124, 500, "item_124", "sound", "arena"],
    [129, 500, "item_129", "sound", "arena"],
    [130, 500, "item_130", "sound", "arena"],
    [131, 500, "item_131", "sound", "arena"],
    [132, 500, "item_132", "sound", "arena"],
    [134, 500, "item_134", "sound", "arena"],
    [135, 500, "item_135", "sound", "arena"],
    [139, 500, "item_139", "sound", "arena"],
    [140, 500, "item_140", "sound", "arena"],
    [141, 500, "item_141", "sound", "arena"],

    //Редкие фразы
    [30, 100, "item_30", "sound", "donate"],
    [31, 100, "item_31", "sound", "donate"],
    [32, 100, "item_32", "sound", "donate"],
    [33, 100, "item_33", "sound", "donate"],
    [34, 100, "item_34", "sound", "donate"],
    [35, 100, "item_35", "sound", "donate"],
    [36, 100, "item_36", "sound", "donate"],
    [37, 100, "item_37", "sound", "donate"],
    [38, 100, "item_38", "sound", "donate"],
    [39, 100, "item_39", "sound", "donate"],
    [40, 100, "item_40", "sound", "donate"],
    [112, 100, "item_112", "sound", "donate"],
    [111, 100, "item_111", "sound", "donate"],
    [119, 100, "item_119", "sound", "donate"],
    [122, 100, "item_122", "sound", "donate"],
    [125, 100, "item_125", "sound", "donate"],
    [126, 100, "item_126", "sound", "donate"],
    [127, 100, "item_127", "sound", "donate"],
    [128, 100, "item_128", "sound", "donate"],
    [110, 100, "item_110", "sound", "donate"],
    [142, 100, "item_142", "sound", "donate"],
    [143, 100, "item_143", "sound", "donate"],
    [145, 100, "item_145", "sound", "donate"],
    [146, 100, "item_146", "sound", "donate"],
    [147, 100, "item_147", "sound", "donate"],
    [148, 100, "item_148", "sound", "donate"],
    [149, 100, "item_149", "sound", "donate"],
    [150, 100, "item_150", "sound", "donate"],
    [151, 100, "item_151", "sound", "donate"],
    [152, 100, "item_152", "sound", "donate"],
    [153, 100, "item_153", "sound", "donate"],
    [161, 100, "item_161", "sound", "donate"],
    [133, 100, "item_133", "sound", "donate"],
    [136, 100, "item_136", "sound", "donate"],
    [137, 100, "item_137", "sound", "donate"],
    [138, 100, "item_138", "sound", "donate"],
    [144, 100, "item_144", "sound", "donate"],

    //Уникальные фразы
    [154, 150, "item_154", "sound", "donate"],
    [155, 150, "item_155", "sound", "donate"],
    [156, 150, "item_156", "sound", "donate"],
    [157, 150, "item_157", "sound", "donate"],
    [158, 150, "item_158", "sound", "donate"],
    [159, 150, "item_159", "sound", "donate"],
    [160, 150, "item_160", "sound", "donate"],
    [162, 150, "item_162", "sound", "donate"],
    [163, 150, "item_163", "sound", "donate"],
    [164, 200, "item_164", "sound", "donate"],

    [165, 500, "item_165", "sound", "arena"],
    [166, 200, "item_166", "sound", "donate"],
    [167, 200, "item_167", "sound", "donate"],

    //Обычные смайлы
    [51, 250, "item_51", "smile__0054_1", "arena"],
    [52, 250, "item_52", "smile__0051_3Head", "arena"],
    [53, 250, "item_53", "smile__0048_AYAYA", "arena"],
    [54, 250, "item_54", "smile__0047_BibleThump", "arena"],
    [55, 250, "item_55", "smile__0045_Catgasm", "arena"],
    [56, 250, "item_56", "smile__0043_CoolStoryBob", "arena"],
    [57, 250, "item_57", "smile__0041_Dolan", "arena"],
    [58, 250, "item_58", "smile__0038_EHEHE", "arena"],
    [59, 250, "item_59", "smile__0035_FeelsBadMan", "arena"],
    [60, 250, "item_60", "smile__0034_GachiBass", "arena"],
    [61, 250, "item_61", "smile__0033_GG", "arena"],
    [62, 250, "item_62", "smile__0031_HeavyBreathing", "arena"],
    [63, 250, "item_63", "smile__0029_Kappa", "arena"],
    [64, 250, "item_64", "smile__0024_LUL", "arena"],
    [65, 250, "item_65", "smile__0023_MaN", "arena"],
    [66, 250, "item_66", "smile__0022_monkaChrist", "arena"],
    [67, 250, "item_67", "smile__0021_monkaEyes", "arena"],
    [68, 250, "item_68", "smile__0020_monkaS", "arena"],
    [69, 250, "item_69", "smile__0019_NotLikeThis", "arena"],
    [70, 250, "item_70", "smile__0017_Pepega", "arena"],
    [71, 250, "item_71", "smile__0016_PLEASENO", "arena"],
    [72, 250, "item_72", "smile__0014_PressF", "arena"],
    [73, 250, "item_73", "smile__0013_pudge", "arena"],
    [74, 250, "item_74", "smile__0012_residentsleeper", "arena"],
    [75, 250, "item_75", "smile__0011_RIP", "arena"],
    [76, 250, "item_76", "smile__0010_SadCat", "arena"],
    [77, 250, "item_77", "smile__0009_seemsgood", "arena"],
    [78, 250, "item_78", "smile__0007_StrimPlz", "arena"],
    [79, 250, "item_79", "smile__0005_VaN", "arena"],
    [80, 250, "item_80", "smile__0002_weSmart", "arena"],
    [81, 250, "item_81", "smile__0001_wutface", "arena"],
    [82, 250, "item_82", "smile__0000_YouDied", "arena"],
    [103, 250, "item_103", "smile__0053_1ntes_smile", "arena"],
    [104, 250, "item_104", "smile__0039_dwayne", "arena"],
    [105, 250, "item_105", "smile__0040_durka", "arena"],

    //Редкие смайлы
    [83, 500, "item_83", "smile__0050_4head", "arena"],
    [84, 500, "item_84", "smile__0049_Agent", "arena"],
    [85, 500, "item_85", "smile__0046_BloodTrail", "arena"],
    [86, 500, "item_86", "smile__0044_CatWhat", "arena"],
    [87, 500, "item_87", "smile__0042_dogeKek", "arena"],
    [88, 500, "item_88", "smile__0037_EZ", "arena"],
    [89, 500, "item_89", "smile__0036_FacePalm", "arena"],
    [90, 500, "item_90", "smile__0032_Gigachad", "arena"],
    [91, 500, "item_91", "smile__0028_Kappapride", "arena"],
    [92, 500, "item_92", "smile__0027_KEKW", "arena"],
    [93, 500, "item_93", "smile__0025_Kreygasm", "arena"],
    [94, 500, "item_94", "smile__0018_OMEGALUL", "arena"],
    [95, 500, "item_95", "smile__0006_SuchMeme", "arena"],
]

GameUI.CustomUIConfig().OpenPass = function ToggleBattlePass(inf1, inf2) 
{
    if (toggle_battlepass === false) 
    {
        if (cooldown_panel_battlepass == false) 
        {
            toggle_battlepass = true;
            if (first_time_battlepass === false) 
            {
                first_time_battlepass = true;
                UpdateInformation(true);
                $("#BattlePassWindow").AddClass("sethidden");
            }  
            if ($("#BattlePassWindow").BHasClass("sethidden")) 
            {
                $("#BattlePassWindow").RemoveClass("sethidden");
            }
            $("#BattlePassWindow").AddClass("setvisible");
            $("#BattlePassWindow").style.visibility = "visible"
            cooldown_panel_battlepass = true
            $.Schedule( 0.503, function()
            {
                cooldown_panel_battlepass = false
            })
            SetMenu(inf1, inf2)
        }
    } else {
        if (cooldown_panel_battlepass == false) 
        {
            if (current_tab != inf2)
            {
                SetMenu(inf1, inf2)
            }
            else
            {
                toggle_battlepass = false;
                if ($("#BattlePassWindow").BHasClass("setvisible")) {
                    $("#BattlePassWindow").RemoveClass("setvisible");
                }
                $("#BattlePassWindow").AddClass("sethidden");
                cooldown_panel_battlepass = true
                $.Schedule( 0.503, function()
                {
                    cooldown_panel_battlepass = false
                    $("#BattlePassWindow").style.visibility = "collapse"
                })
            }
        }
    }
}

function CloseWindowsBPFast() 
{
    toggle_battlepass = false;
    if ($("#BattlePassWindow").BHasClass("setvisible")) 
    {
        $("#BattlePassWindow").RemoveClass("setvisible");
    }
    $("#BattlePassWindow").AddClass("sethidden");
    cooldown_panel_battlepass = true
    $.Schedule(0.503, function () {
        cooldown_panel_battlepass = false
        $("#BattlePassWindow").style.visibility = "collapse"
    })
}

function SetMenu(id, id2)
{
    current_tab = id2
    $("#DonateWindowBattlePass").style.visibility = "collapse"
    $("#DonateWindowBattleRewards").style.visibility = "collapse"
    $("#DonateWindowBattleProfile").style.visibility = "collapse"
    $("#DonateWindowBattleShop").style.visibility = "collapse"
    for (var i = 0; i < $("#DonateButtons").GetChildCount(); i++) 
    {
        $("#DonateButtons").GetChild(i).SetHasClass("active_button", false)
    }
    if (id2 == "DonateWindowBattlePass")
    {
        RestartUpdateInfo();
    } else {
        if (timer_info != -1 )
        {
            $.CancelScheduled(timer_info)
            timer_info = -1
        }
    }
    if (id2 == "DonateWindowBattleRewards") 
    {
        InitRewards();
    }
    if (id2 == "DonateWindowBattleProfile") 
    {
        InitCustomize();
        InitProfile() 
    }
    if (id2 == "DonateWindowBattleShop") {
        InitShop()
    }
    $("#" + id).SetHasClass("active_button", true)
    $("#" + id2).style.visibility = "visible"
}

function UpdateInformation(start)
{
    let player_info = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_info)
    {
        if (player_info.pass_level_3_days && player_info.pass_level_3_days > 0)
        {
            UpdateBattlePassButton();
        }
        $("#ArenaCoinLabel").text = player_info.game_coin || "0"
        $("#DonateCoinLabel").text = player_info.donate_coin || "0"
        InitRewards()
    }
    if (start)
    {
        UpdateBattlePassPrice(0)
    }
}

function UpdateBattlePassButton()
{
    let player_info = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_info) 
    {
        if (player_info.pass_level_3_days && player_info.pass_level_3_days > 0) 
        {
            $("#DurationBattlePassPrice").style.visibility = "collapse"
            $("#BuyBattlePassButtons").style.visibility = "collapse"
            $("#BattlePassDaysDuration").style.visibility = "visible"
            $("#BattlePassDaysDuration").text = $.Localize("#bp_time_rem") + player_info.pass_level_3_days + " " + $.Localize("#bp_time_day")
        } else {
            $("#DurationBattlePassPrice").style.visibility = "visible"
            $("#BuyBattlePassButtons").style.visibility = "visible"
            $("#BattlePassDaysDuration").style.visibility = "collapse"
            $("#BattlePassDaysDuration").text = $.Localize("#bp_time_rem") + " 0 " + $.Localize("#bp_time_day")
        }
    }
}

 


function UpdateBattlePassPrice(id)
{
    let choose = Number(id)
    current_choose_month_bp = choose
    let battlepass_price_arena = [4000, 11000, 21000, 40000]
    let battlepass_price_donate = [400, 1100, 2100, 4000]
    let battlepass_price_duration = [1, 3, 6, 12]
    $("#BuyBattlePassButtonRedPrice").text = battlepass_price_arena[choose]
    $("#BuyBattlePassButtonBluePrice").text = battlepass_price_donate[choose]
    $("#BuyBattlePassButtonRed").SetPanelEvent("onactivate", function () { 
        battlepass_buy("arena", battlepass_price_duration[choose]) 
    });
    $("#BuyBattlePassButtonBlue").SetPanelEvent("onactivate", function () { 
        battlepass_buy("donate", battlepass_price_duration[choose]) 
    });
}

function RestartUpdateInfo()
{
    if (timer_info != -1) 
    {
        $.CancelScheduled(timer_info)
        timer_info = -1
    }
    current_info = 0
    $("#BattlePassInformationBodyImage").style.backgroundImage = 'url("file://{images}/custom_game/bp_info/' + bp_info[current_info][1] + '.png")';
    $("#BattlePassInformationBodyImage").style.backgroundSize = "100%"
    $("#BattlePassInformationBodyInfoDescr").text = $.Localize(bp_info[current_info][0])

    for (var i = 0; i < $("#NavigationWidgets").GetChildCount(); i++) 
    {
        if (i == current_info)
        {
            $("#NavigationWidgets").GetChild(i).SetHasClass("NavigationWidget_Active", true)
        }
        else
        {
            $("#NavigationWidgets").GetChild(i).SetHasClass("NavigationWidget_Active", false)
        }
    }

    timer_info = $.Schedule(5, RestartUpdateNext);
}

function RestartUpdateNext()
{
    current_info = current_info + 1

    if (current_info > 8)
    {
        current_info = 0
    }

    if (current_info < 0)
    {
        current_info = 8
    }

    $("#BattlePassInformationBodyImage").style.backgroundImage = 'url("file://{images}/custom_game/bp_info/' + bp_info[current_info][1] + '.png")';
    $("#BattlePassInformationBodyImage").style.backgroundSize = "100%"
    $("#BattlePassInformationBodyInfoDescr").text = $.Localize(bp_info[current_info][0])

    for (var i = 0; i < $("#NavigationWidgets").GetChildCount(); i++) 
    {
        if (i == current_info) {
            $("#NavigationWidgets").GetChild(i).SetHasClass("NavigationWidget_Active", true)
        }
        else {
            $("#NavigationWidgets").GetChild(i).SetHasClass("NavigationWidget_Active", false)
        }
    }

    timer_info = $.Schedule(5, RestartUpdateNext);
}

function BattlePassInfoSwap(style)
{
    if (timer_info != -1) {
        $.CancelScheduled(timer_info)
        timer_info = -1
    }

    if (style == "right")
    {
        current_info = current_info + 1
    } else {
        current_info = current_info - 1
    }

    if (current_info > 8) {
        current_info = 0
    }

    if (current_info < 0) {
        current_info = 8
    }

    $("#BattlePassInformationBodyImage").style.backgroundImage = 'url("file://{images}/custom_game/bp_info/' + bp_info[current_info][1] + '.png")';
    $("#BattlePassInformationBodyImage").style.backgroundSize = "100%"
    $("#BattlePassInformationBodyInfoDescr").text = $.Localize(bp_info[current_info][0])

    for (var i = 0; i < $("#NavigationWidgets").GetChildCount(); i++) {
        if (i == current_info) {
            $("#NavigationWidgets").GetChild(i).SetHasClass("NavigationWidget_Active", true)
        }
        else {
            $("#NavigationWidgets").GetChild(i).SetHasClass("NavigationWidget_Active", false)
        }
    }

    timer_info = $.Schedule(5, RestartUpdateNext);
}

GameEvents.Subscribe( 'donate_event_error', ErrorCreated );
GameEvents.Subscribe( 'donate_event_accept', AcceptCreated );

function battlepass_buy(coin_type, duration_type) 
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer("BattlePassBuy", { coin_type: coin_type, duration_type: duration_type });
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
    $.Schedule(0.5 , AcceptClose);
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
    ["7", "bp_book3", "#reward_battlepass", "reward_7"],
    ["8", "arena_coin", "#reward_arena_coin_30", "reward_8"],
    ["9", "arena_coin", "#reward_arena_coin_50", "reward_9"],
    ["10", "arena_coin", "#reward_arena_coin_70", "reward_10"],
    ["11", "arena_coin", "#reward_arena_coin_100", "reward_11"],
    ["12", "arena_coin", "#reward_arena_coin_150", "reward_12"],
    ["13", "donate_coin", "#reward_donate_coin_50", "reward_13"],
    ["14", "rating_ticket", "#rating_ticket", "reward_14"],
    ["15", "bp_book3", "#reward_battlepass", "reward_15"],
    ["16", "arena_coin", "#reward_arena_coin_30", "reward_1"],
    ["17", "arena_coin", "#reward_arena_coin_50", "reward_2"],
    ["18", "arena_coin", "#reward_arena_coin_70", "reward_3"],
    ["19", "arena_coin", "#reward_arena_coin_100", "reward_4"],
    ["20", "arena_coin", "#reward_arena_coin_150", "reward_5"],
    ["21", "donate_coin", "#reward_donate_coin_100", "reward_6"],
    ["22", "bp_book3", "#reward_battlepass", "reward_7"],
    ["23", "arena_coin", "#reward_arena_coin_100", "reward_8"],
    ["24", "arena_coin", "#reward_arena_coin_100", "reward_9"],
    ["25", "arena_coin", "#reward_arena_coin_150", "reward_10"],
    ["26", "arena_coin", "#reward_arena_coin_150", "reward_11"],
    ["27", "arena_coin", "#reward_arena_coin_200", "reward_12"],
    ["28", "donate_coin", "#reward_donate_coin_100", "reward_13"],
    ["29", "rating_ticket", "#rating_ticket", "reward_14"],
    ["30", "bp_book3", "#reward_battlepass", "reward_15"],
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

    var RewardNameBlock = $.CreatePanel("Panel", RewardBlock, "");
    RewardNameBlock.AddClass("RewardNameBlock");

    var RewardName = $.CreatePanel("Label", RewardNameBlock, "");
    RewardName.AddClass("RewardName");
    RewardName.text = reward_table[0] + " " + $.Localize("#reward_day")

    var RewardIcon = $.CreatePanel("Panel", RewardBlock, "");
    RewardIcon.AddClass("RewardIcon");
    RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/donate/rewards/' + reward_table[1] + '.png")';
    RewardIcon.style.backgroundSize = "100%"

    var RewardReceive = $.CreatePanel("Panel", RewardBlock, "");
    RewardReceive.AddClass("RewardReceive");

    var RewardReceiveLabel = $.CreatePanel("Label", RewardReceive, "");
    RewardReceiveLabel.AddClass("RewardReceiveLabel");
    RewardReceiveLabel.html = true
    RewardReceiveLabel.text = $.Localize(reward_table[2])

    RewardBlock.SetHasClass("full_color_reward", false)

    if (Number(player_table.month_rewards_days) >= Number(reward_table[0]))
    {
        RewardReceive.AddClass("recive_reward")
    }

    if (Number(reward_table[0]) == Number(player_table.month_rewards_days))
    {
        if (player_table.month_days_disabled == 0)
        {
            RewardReceive.SetPanelEvent("onactivate", function() { RecieveReward(reward_table[3], reward_table[0]) } );
            RewardReceive.style.saturation = "1"
            RewardReceive.RemoveClass("recive_reward")
            RewardBlock.SetHasClass("full_color_reward", true)
        } else {
            RewardReceiveLabel.text = $.Localize(reward_table[2]) + "<br> <font color=\'gray\'>(" + $.Localize("#reward_button_received") + ")</font>"
            RewardReceive.style.marginTop = "0px"
            RewardReceive.AddClass("recive_reward")
        }
    }

    if (Number(reward_table[0]) > Number(player_table.month_rewards_days))
    {
        RewardReceive.AddClass("closed_reward")
    }
}

function RecieveReward(reward_name, day)
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "RewardAccept", {reward_name : reward_name, day : day} );
}



function InitCustomize() {
    let player_table = CustomNetTables.GetTableValue("cha_server_data", Players.GetLocalPlayer())

    $("#NickNamePanel").RemoveAndDeleteChildren()
    $("#FramesPanel").RemoveAndDeleteChildren()
    $("#EffectsPanel").RemoveAndDeleteChildren()

    // название, картинка, доступен сразу, нужен бп, нужен предмет
    let customize_effects = 
    [
        ["#customize_frame_off", "effect1", true, false, 0],
        ["#customize_effect_1_season", "effect2", false, true, 127],
        ["#customize_effect_2_season", "effect3", false, true, 128],
    ]
    let customize_frames = 
    [
        ["#customize_frame_off", "frame1", true, false, 0],
        ["#customize_frame_team", "frame2", false, true, 0],
        ["#customize_frame_rainbow", "frame3", false, true, 0],
        ["#customize_frame_gold", "frame4", false, true, 0],
    ]
    
    let customize_nickname = 
    [
        ["#customize_nickname_white", "nick1", true, false, 0],
        ["#customize_nickname_team", "nick2", false, true, 0],
        ["#customize_nickname_rainbow", "nick3", false, true, 0],
        ["#customize_nickname_gold", "nick4", false, true, 0],
    ]

    for (var i = 0; i < customize_nickname.length; i++) 
    {
        CreateNickName(customize_nickname[i], i)
    }
    for (var i = 0; i < customize_frames.length; i++) 
    {
        CreateFrame(customize_frames[i], i)
    }
    for (var i = 0; i < customize_effects.length; i++) 
    {
        CreateEffect(customize_effects[i], i)
    }
}

function CreateNickName(info, id)
{
    var ChooseBlock = $.CreatePanel("Panel", $("#NickNamePanel"), "nickname_id_"+id);
    ChooseBlock.AddClass("ChooseBlock");
    ChooseBlock.AddClass("closed");

    var ChooseBlockImage = $.CreatePanel("Panel", ChooseBlock, "");
    ChooseBlockImage.AddClass("ChooseBlockImage");
    ChooseBlockImage.style.backgroundImage = 'url("file://{images}/custom_game/customize/' + info[1] + '.png")';
    ChooseBlockImage.style.backgroundSize = "100%"

    var ChooseBlockName = $.CreatePanel("Label", ChooseBlock, "");
    ChooseBlockName.AddClass("ChooseBlockName");
    ChooseBlockName.text = $.Localize(info[0])

    var VisualButtonActivated = $.CreatePanel("Panel", ChooseBlock, "");
    VisualButtonActivated.AddClass("VisualButtonActivated");

    var VisualButtonActivatedLabel = $.CreatePanel("Label", VisualButtonActivated, "");
    VisualButtonActivatedLabel.AddClass("VisualButtonActivatedLabel");

    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))

    if (info[2] == true)
    {
        ChooseBlock.RemoveClass("closed")
        ChooseBlock.SetPanelEvent("onactivate", function () {
            GameEvents.SendCustomGameEventToServer("change_nickname_customize", { id: Number(id) });
        });
    } 
    else 
    {
        if (player_table) 
        {
            if (player_table.pass_level_3_days > 0 && info[3] == true) 
            {
                ChooseBlock.RemoveClass("closed")
                ChooseBlock.SetPanelEvent("onactivate", function () {
                    GameEvents.SendCustomGameEventToServer("change_nickname_customize", { id: Number(id) });
                });
            }
            if (info[4] != 0 && PlayerHasItem(info[4, player_table]))
            {
                ChooseBlock.RemoveClass("closed")
                ChooseBlock.SetPanelEvent("onactivate", function () {
                    GameEvents.SendCustomGameEventToServer("change_nickname_customize", { id: Number(id) });
                });
            }
        }
    }

    if (player_table && typeof player_table.nickname !== 'undefined' && Number(player_table.nickname) == id) 
    {
        ChooseBlock.SetHasClass("active", true)
        VisualButtonActivatedLabel.text = $.Localize("#customize_active")
        return
    }
    if (ChooseBlock.BHasClass("closed"))
    {
        VisualButtonActivatedLabel.text = $.Localize("#customize_lock")
    } else 
    {
        VisualButtonActivatedLabel.text = $.Localize("#customize_on")
    }
}

function CreateFrame(info, id) {
    var ChooseBlock = $.CreatePanel("Panel", $("#FramesPanel"), "frame_id_" + id);
    ChooseBlock.AddClass("ChooseBlock");
    ChooseBlock.AddClass("closed");

    var ChooseBlockImage = $.CreatePanel("Panel", ChooseBlock, "");
    ChooseBlockImage.AddClass("ChooseBlockImage");
    ChooseBlockImage.style.backgroundImage = 'url("file://{images}/custom_game/customize/' + info[1] + '.png")';
    ChooseBlockImage.style.backgroundSize = "100%"

    var ChooseBlockName = $.CreatePanel("Label", ChooseBlock, "");
    ChooseBlockName.AddClass("ChooseBlockName");
    ChooseBlockName.text = $.Localize(info[0])

    var VisualButtonActivated = $.CreatePanel("Panel", ChooseBlock, "");
    VisualButtonActivated.AddClass("VisualButtonActivated");

    var VisualButtonActivatedLabel = $.CreatePanel("Label", VisualButtonActivated, "");
    VisualButtonActivatedLabel.AddClass("VisualButtonActivatedLabel");

    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))

    if (info[2] == true) {
        ChooseBlock.RemoveClass("closed")
        ChooseBlock.SetPanelEvent("onactivate", function () {
            GameEvents.SendCustomGameEventToServer("change_frame_customoze", { id: Number(id) });
        });
    }
    else {
        if (player_table) {
            if (player_table.pass_level_3_days > 0 && info[3] == true) {
                ChooseBlock.RemoveClass("closed")
                ChooseBlock.SetPanelEvent("onactivate", function () {
                    GameEvents.SendCustomGameEventToServer("change_frame_customoze", { id: Number(id) });
                });
            }
            if (info[4] != 0 && PlayerHasItem(info[4, player_table])) {
                ChooseBlock.RemoveClass("closed")
                ChooseBlock.SetPanelEvent("onactivate", function () {
                    GameEvents.SendCustomGameEventToServer("change_frame_customoze", { id: Number(id) });
                });
            }
        }
    }

    if (player_table && typeof player_table.frame !== 'undefined' && Number(player_table.frame) == id) 
    {
        ChooseBlock.SetHasClass("active", true)
        VisualButtonActivatedLabel.text = $.Localize("#customize_active")
        return
    }
    if (ChooseBlock.BHasClass("closed")) {
        VisualButtonActivatedLabel.text = $.Localize("#customize_lock")
    } else {
        VisualButtonActivatedLabel.text = $.Localize("#customize_on")
    }
}

function CreateEffect(info, id) {
    var ChooseBlock = $.CreatePanel("Panel", $("#EffectsPanel"), "frame_id_" + id);
    ChooseBlock.AddClass("ChooseBlock");
    ChooseBlock.AddClass("closed");

    var ChooseBlockImage = $.CreatePanel("Panel", ChooseBlock, "");
    ChooseBlockImage.AddClass("ChooseBlockImage");
    ChooseBlockImage.style.backgroundImage = 'url("file://{images}/custom_game/customize/' + info[1] + '.png")';
    ChooseBlockImage.style.backgroundSize = "100%"

    var ChooseBlockName = $.CreatePanel("Label", ChooseBlock, "");
    ChooseBlockName.AddClass("ChooseBlockName");
    ChooseBlockName.text = $.Localize(info[0])

    var VisualButtonActivated = $.CreatePanel("Panel", ChooseBlock, "");
    VisualButtonActivated.AddClass("VisualButtonActivated");

    var VisualButtonActivatedLabel = $.CreatePanel("Label", VisualButtonActivated, "");
    VisualButtonActivatedLabel.AddClass("VisualButtonActivatedLabel");

    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))

    if (info[2] == true) {
        ChooseBlock.RemoveClass("closed")
        ChooseBlock.SetPanelEvent("onactivate", function () {
            GameEvents.SendCustomGameEventToServer("change_effect_customoze", { id: Number(id) });
        });
    }
    else {
        if (player_table) {
            if (player_table.pass_level_3_days > 0 && info[3] == true) {
                ChooseBlock.RemoveClass("closed")
                ChooseBlock.SetPanelEvent("onactivate", function () {
                    GameEvents.SendCustomGameEventToServer("change_effect_customoze", { id: Number(id) });
                });
            }
            if (info[4] != 0 && PlayerHasItem(info[4])) {
                ChooseBlock.RemoveClass("closed")
                ChooseBlock.SetPanelEvent("onactivate", function () {
                    GameEvents.SendCustomGameEventToServer("change_effect_customoze", { id: Number(id) });
                });
            }
        }
    }

    if (player_table && typeof player_table.effect !== 'undefined' && Number(player_table.effect) == id) 
    {
        ChooseBlock.SetHasClass("active", true)
        VisualButtonActivatedLabel.text = $.Localize("#customize_active")
        return
    }
    if (ChooseBlock.BHasClass("closed")) {
        VisualButtonActivatedLabel.text = $.Localize("#customize_lock")
    } else {
        VisualButtonActivatedLabel.text = $.Localize("#customize_on")
    }
}

function PlayerHasItem(item)
{
    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_table) {
        var player_table_js = []
        for (var d = 1; d < 300; d++) 
        {
            player_table_js.push(player_table.player_items[d])
        }
        for (var item_has of player_table_js) 
        {
            if (Number(item_has) == Number(item)) 
            {
                return true
            }
        }
    }
    return false
}

CustomNetTables.SubscribeNetTableListener("cha_server_data", UpdateChaData);

function UpdateChaData(table, key, data) 
{
    if (table == "cha_server_data") {
        if (key == Players.GetLocalPlayer()) {
            InitCustomize()
        }
    }
}

function InitProfile() 
{
    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_table) {
        let arena_exp = player_table.arena_level
        $("#ArenaLevelPanelProgress").style['width'] = GetHeroExpProgress(arena_exp)
        $("#ArenaLevelPoints").text = GetHeroExp(arena_exp) + " / 1000"
        $("#ArenaLevel").text = "Arena Level " + (GetHeroLevel(arena_exp) + 1)
        CreateQuests(player_table)
        InitRating(player_table)
    }
}

function InitRating(player_table)
{
    $("#PlayerRatingProfile").text = $.Localize("#Score") + " " + (player_table.mmr[7] || 0)

    let PlayerRank = $("#PlayerRankProfile")
    if (player_table.calibrating_games[7] > 0) 
    {
        PlayerRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + "rank0" + '.png")';
        PlayerRank.style.backgroundSize = "100%"
    }
    else 
    {
        if ((player_table.rating_number_in_top != 0 && player_table.rating_number_in_top != "0" && player_table.rating_number_in_top <= 10) && (player_table.mmr[7] || 2500) >= 5420) 
        {
            PlayerRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
        } else {
            PlayerRank.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(player_table.mmr[7] || 2500) + '.png")';
        }
        PlayerRank.style.backgroundSize = "100%"
    }
    if (player_table.rating_number_in_top != 0 && player_table.rating_number_in_top != "0")
    {
        $("#PlayerRankProfilePlace").text = String(player_table.rating_number_in_top)
    }
}

function GetHeroExpProgress(exp) {
    let level = exp % 1000
    var percent = ((1000 - level) * 100) / 1000

    if (percent >= 0) {
        return (100 - percent) + '%';
    } else {
        return '0%'
    }
}

function GetHeroExp(exp) {
    let level = exp % 1000
    return level
}

function GetHeroLevel(exp) {
    let level = exp / 1000
    return Math.floor(level)
}

function CreateQuests(player_table) 
{
    $("#QuestBlock").RemoveAndDeleteChildren()
    if (player_table) 
    {
        CreateQuest(player_table.quest_1, 1, player_table.quest_swap1, player_table.pass_level_3_days <= 0)
        CreateQuest(player_table.quest_2, 2, player_table.quest_swap2, player_table.pass_level_3_days <= 0)
        CreateQuest(player_table.quest_3, 3, player_table.quest_swap3, player_table.pass_level_3_days <= 0)
    }
}

function CreateQuest(quest_player_table, tier, swap, no_battlepass) {
    let quest_table = null

    let quest_table_tier_1 = CustomNetTables.GetTableValue("quests_table", "tier_1")
    let quest_table_tier_2 = CustomNetTables.GetTableValue("quests_table", "tier_2")
    let quest_table_tier_3 = CustomNetTables.GetTableValue("quests_table", "tier_3")

    if (quest_table_tier_1 && quest_table_tier_2 && quest_table_tier_3) 
    {
        for (var i = 1; i <= Object.keys(quest_table_tier_1.quest).length; i++) {
            if (quest_table_tier_1.quest[i][1] == Number(quest_player_table["quest_number"])) 
            {
                quest_table = quest_table_tier_1.quest[i]
            }
        }

        for (var i = 1; i <= Object.keys(quest_table_tier_2.quest).length; i++) {
            if (quest_table_tier_2.quest[i][1] == Number(quest_player_table["quest_number"])) {
                quest_table = quest_table_tier_2.quest[i]
            }
        }

        for (var i = 1; i <= Object.keys(quest_table_tier_3.quest).length; i++) {
            if (quest_table_tier_3.quest[i][1] == Number(quest_player_table["quest_number"])) {
                quest_table = quest_table_tier_3.quest[i]
            }
        }

        if (quest_table == null) {
            return
        }

        var DayQuest = $.CreatePanel("Panel", $("#QuestBlock"), "quest_tier_" + tier);
        DayQuest.AddClass("DayQuest");
        DayQuest.AddClass("QuestTierInfo" + tier);

        var QuestInfo = $.CreatePanel("Panel", DayQuest, "");
        QuestInfo.AddClass("QuestInfo");

        var IconAndName = $.CreatePanel("Panel", QuestInfo, "");
        IconAndName.AddClass("QuestIconAndName");

        var QuestIcon = $.CreatePanel("Panel", IconAndName, "");
        QuestIcon.AddClass("QuestIcon");
        //QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_table[2] + '.png")';
        //QuestIcon.style.backgroundSize = "100%"

        var QuestName = $.CreatePanel("Label", IconAndName, "");
        QuestName.AddClass("QuestName");
        QuestName.text = $.Localize("#" + quest_table[2])

        var QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
        QuestProgress.AddClass("QuestProgress");

        var QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
        QuestProgressBackground.AddClass("QuestProgressBackground");

        var QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
        QuestProgressLine.AddClass("QuestProgressLine");

        var percentage = ((quest_table[3] - Number(quest_player_table["current_point"])) * 100) / quest_table[3]
        QuestProgressLine.style['width'] = (100 - percentage) + '%';

        var QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
        QuestProgressLabel.AddClass("QuestProgressLabel");
        QuestProgressLabel.text = Number(quest_player_table["current_point"]) + " / " + quest_table[3]  // Прогресс квеста

        
        var ProgreessAndRefresh = $.CreatePanel("Panel", DayQuest, "");
        ProgreessAndRefresh.AddClass("ProgreessAndRefresh");

        var QuestSuccesIcon = $.CreatePanel("Panel", ProgreessAndRefresh, "QuestSuccesIcon");
        QuestSuccesIcon.AddClass("QuestSuccesIcon");
        QuestSuccesIcon.style.opacity = 1;

        var update_quest_button = $.CreatePanel("Panel", ProgreessAndRefresh, "update_quest_button");
        update_quest_button.AddClass("update_quest_button");

       var update_quest_button_label = $.CreatePanel("Label", update_quest_button, "update_quest_button_label");
       update_quest_button_label.AddClass("update_quest_button_label");
       update_quest_button_label.text = $.Localize("#update_quest_button_label")

       if (Number(quest_player_table["current_point"]) >= Number(quest_table[3])) 
       {
           QuestSuccesIcon.style.opacity = 1;
           update_quest_button.style.visibility = "collapse"
       } else {
           QuestSuccesIcon.AddClass("QuestSuccesWait");  
       }

       if (Number(swap) == 1) {
           update_quest_button.style.visibility = "collapse"
       }

       if (no_battlepass) {
           update_quest_button.style.visibility = "collapse"
       }

       ChangeQuestButton(update_quest_button, quest_table[0], tier)
    }
}

function ChangeQuestButton(panel, quest_id, tier) 
{
    panel.SetPanelEvent("onactivate", function () 
    {
        GameEvents.SendCustomGameEventToServer("ChangeQuest", { quest_id: quest_id, tier: tier });
        panel.style.visibility = "collapse"
        $.Schedule(0.503, function () {
            InitProfile()
        })
    });
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

function OpenDonateInfo()
{
    CloseBattlePassInfo('BuyBattlePassWindow_coinshop')
    $("#donate_coin_panel").style.visibility = "visible"
}

function CloseDonateInfo()
{
    $("#donate_coin_panel").style.visibility = "collapse"
}

function swap_currency(donate, arena)
{
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer( "SwapCurrency", {donate : donate, arena : arena } );
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
    let ChatPanelSound = $.CreatePanel("Panel", LinesPanel, "", { style:"margin-left:37px;flow-children: right;width:100%;" });
    let HeroIcon = $.CreatePanel("Image", ChatPanelSound, "", { src:`${hero_icon}`, style:"width:40px;height:23px;margin-right:4px;border:1px solid black;" }); 
    let LabelPlayer = $.CreatePanel("Label", ChatPanelSound, "", { text:`${player_name}` + ":", style:`${player_color_style}` });
    let LabelSound = $.CreatePanel("Image", ChatPanelSound, "", { class:"SmileIcon", style:"width:35px;height:35px;", src:`${smile_icon}` }); 

    $.Schedule( 7, function(){
        if (ChatPanelSound) {
            ChatPanelSound.AddClass('ChatLine');  
        }
    })
}

function InitShop()
{
    $("#DonateShopItems").RemoveAndDeleteChildren()
    for (var i = 0; i < shop_info.length; i++) 
    {
        CreateItem(shop_info[i])
    }
}

function CreateItem(info)
{
    var ChooseBlock = $.CreatePanel("Panel", $("#DonateShopItems"), "item_" + info[0]);
    ChooseBlock.AddClass("ChooseBlockShop");
    ChooseBlock.AddClass("active_shop");

    var ChooseBlockImage = $.CreatePanel("Panel", ChooseBlock, "");
    ChooseBlockImage.AddClass("ChooseBlockImageShop");
    ChooseBlockImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/' + info[3] + '.png")';
    ChooseBlockImage.style.backgroundSize = "100%"

    var ChooseBlockName = $.CreatePanel("Label", ChooseBlock, "");
    ChooseBlockName.AddClass("ChooseBlockNameShop");
    ChooseBlockName.text = $.Localize("#"+info[2])

    var ItemCostPanelShop = $.CreatePanel("Panel", ChooseBlock, "");
    ItemCostPanelShop.AddClass("ItemCostPanelShop");

    var ArenaCoinShopPanel = $.CreatePanel("Panel", ItemCostPanelShop, "");

    if (info[4] == "arena")
    {
        ArenaCoinShopPanel.AddClass("ArenaCoinShopPanel");
    } else {
        ArenaCoinShopPanel.AddClass("DonateCoinShopPanel");
    }

    var ArenaCoinCost = $.CreatePanel("Label", ItemCostPanelShop, "");
    ArenaCoinCost.AddClass("ArenaCoinCost");
    ArenaCoinCost.text = info[1]

    var VisualButtonActivated = $.CreatePanel("Panel", ChooseBlock, "");
    VisualButtonActivated.AddClass("VisualButtonActivatedShop");

    var VisualButtonActivatedLabel = $.CreatePanel("Label", VisualButtonActivated, "");
    VisualButtonActivatedLabel.AddClass("VisualButtonActivatedLabelShop");

    if (PlayerHasItem(Number(info[0])))
    {
        VisualButtonActivatedLabel.text = $.Localize("#bp_button_bought")
        ChooseBlock.RemoveClass("active_shop")
        ItemCostPanelShop.style.opacity = "0"
    } else {
        VisualButtonActivatedLabel.text = $.Localize("#bp_button_buy")
        VisualButtonActivated.SetPanelEvent("onactivate", function () 
        {
            shop_buy_item(Number(info[0]))
        });
    }
}

function shop_buy_item(id)
{
    if (shop_delay)
    {
        return
    }
    shop_delay = true
    Game.EmitSound("ui_hero_transition")
    LoadingCreated()
    GameEvents.SendCustomGameEventToServer("ItemShopBuy", { item_id: id});
    $.Schedule(0.4, function () 
    {
        shop_delay = false
        InitShop()
    })
}