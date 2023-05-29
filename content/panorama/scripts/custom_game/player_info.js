var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#PlayerInfoButton")) {
    if (parentHUDElements.FindChildTraverse("PlayerInfoButton")){
        $("#PlayerInfoButton").DeleteAsync( 0 );
    } else {
        $("#PlayerInfoButton").SetParent(parentHUDElements);
    }
}

var parentHUDElements2 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements2);

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

GameUI.CustomUIConfig().OpenProfile = function TogglePlayerInfo() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) { 
                first_time = true;
                $("#PlayerInfoWindow").AddClass("sethidden");
            }  
            InitProfile()
            if ($("#PlayerInfoWindow").BHasClass("sethidden")) {
                $("#PlayerInfoWindow").RemoveClass("sethidden");
            }
            $("#PlayerInfoWindow").AddClass("setvisible");
            $("#PlayerInfoWindow").style.visibility = "visible"
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#PlayerInfoWindow").BHasClass("setvisible")) {
                $("#PlayerInfoWindow").RemoveClass("setvisible");
            }
            $("#PlayerInfoWindow").AddClass("sethidden");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
                $("#PlayerInfoWindow").style.visibility = "collapse"
            })
        }
    }
}

function SwitchTab(tab, button) 
{

}

function SwitchTabSkills(tab, button) 
{
    $("#skills_tier_1").style.visibility = "collapse";
    $("#skills_tier_2").style.visibility = "collapse";
    $("#skills_tier_3").style.visibility = "collapse";
    $("#skills_tier_4").style.visibility = "collapse";
    $("#skills_tier_5").style.visibility = "collapse";

    $("#skills_tier_button_1").SetHasClass( "ButtonMenuActive_skill", false );
    $("#skills_tier_button_2").SetHasClass( "ButtonMenuActive_skill", false );
    $("#skills_tier_button_3").SetHasClass( "ButtonMenuActive_skill", false );
    $("#skills_tier_button_4").SetHasClass( "ButtonMenuActive_skill", false );
    $("#skills_tier_button_5").SetHasClass( "ButtonMenuActive_skill", false );

    Game.EmitSound("ui_topmenu_select")

    $("#" + button).SetHasClass( "ButtonMenuActive_skill", true );

    $("#" + tab).style.visibility = "visible";
}
  
function InitSkillsInfo()
{
    let skills_1 = CustomNetTables.GetTableValue("skills_table", "tier_1").skills
    for (var i = 1; i <= Object.keys(skills_1).length; i++)
    {
        CreateSkill(skills_1[i], $("#skills_tier_1"), 1)
    }
    let skills_2 = CustomNetTables.GetTableValue("skills_table", "tier_2").skills
    for (var i = 1; i <= Object.keys(skills_2).length; i++)
    {
        CreateSkill(skills_2[i], $("#skills_tier_2"), 2)
    }
    let skills_3 = CustomNetTables.GetTableValue("skills_table", "tier_3").skills
    for (var i = 1; i <= Object.keys(skills_3).length; i++)
    {
        CreateSkill(skills_3[i], $("#skills_tier_3"), 3)
    }
    let skills_4 = CustomNetTables.GetTableValue("skills_table", "tier_4").skills
    for (var i = 1; i <= Object.keys(skills_4).length; i++)
    {
        CreateSkill(skills_4[i], $("#skills_tier_4"), 4)
    }
    let skills_5 = CustomNetTables.GetTableValue("skills_table", "tier_5").skills
    for (var i = 1; i <= Object.keys(skills_5).length; i++)
    {
        CreateSkill(skills_5[i], $("#skills_tier_5"), 5)
    }
}
  
function CreateSkill(info, panel, tier)
{
    var Skill_full = $.CreatePanel("Panel", panel, "");
    Skill_full.AddClass("Skill_full");

    var Skill = $.CreatePanel("Panel", Skill_full, "");
    Skill.AddClass("SkillPanel"+tier);
    Skill.style.backgroundImage = 'url("file://{images}/custom_game/skills/' + info[3] + '.png")';
    Skill.style.backgroundSize = "100%"

    var Label = $.CreatePanel("Label", Skill_full, "");
    Label.AddClass("SkillPanelLabel"+tier);
    Label.text = $.Localize("#"+info[2])

    SetShowText(Skill, "<b>" + $.Localize("#"+info[2]) + "</b>" + "<br><br>" + $.Localize("#" + info[2]+ "_desc"))
    Skill.SetPanelEvent("onactivate", function() 
    { 
        GameEvents.SendCustomGameEventToServer( "ChooseSkill", { skill : info[1], tier : tier } );
    })
}

function SetShowText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

function InitProfile()
{
    let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
    if (player_table)
    {
        let arena_exp = player_table.arena_level
        $("#ArenaLevelPanelProgress").style['width'] = GetHeroExpProgress(arena_exp)
        $("#ArenaLevelPoints").text = GetHeroExp(arena_exp) + " / 1000"
        $("#ArenaLevel").text = "Arena Level " + (GetHeroLevel(arena_exp) + 1)
        CreateQuests(player_table)
    }
}

function GetHeroExpProgress(exp)
{
    let level = exp % 1000
    var percent = ((1000-level)*100)/1000

    if (percent >= 0) {
        return (100 - percent) +'%';
    } else {
        return '0%'
    }
} 

function GetHeroExp(exp)
{
    let level = exp % 1000
    return level
} 

function GetHeroLevel(exp)
{
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

function CreateQuest(quest_player_table, tier, swap, no_battlepass)
{
    let quest_table = null

    let quest_table_tier_1 = CustomNetTables.GetTableValue("quests_table", "tier_1")
    let quest_table_tier_2 = CustomNetTables.GetTableValue("quests_table", "tier_2")
    let quest_table_tier_3 = CustomNetTables.GetTableValue("quests_table", "tier_3")

    if (quest_table_tier_1 && quest_table_tier_2 && quest_table_tier_3)
    {
        for (var i = 1; i <= Object.keys(quest_table_tier_1.quest).length; i++) 
        {
            if (quest_table_tier_1.quest[i][1] == Number(quest_player_table["quest_number"]))
            {
                quest_table = quest_table_tier_1.quest[i]
            }
        }

        for (var i = 1; i <= Object.keys(quest_table_tier_2.quest).length; i++) 
        {
            if (quest_table_tier_2.quest[i][1] == Number(quest_player_table["quest_number"]))
            {
                quest_table = quest_table_tier_2.quest[i]
            }
        }

        for (var i = 1; i <= Object.keys(quest_table_tier_3.quest).length; i++) 
        {
            if (quest_table_tier_3.quest[i][1] == Number(quest_player_table["quest_number"]))
            {
                quest_table = quest_table_tier_3.quest[i]
            }
        }

        if (quest_table == null) 
        {
            return
        }

        var QuestTierInfo = $.CreatePanel("Panel", $("#QuestBlock"), "");
        QuestTierInfo.AddClass("QuestTierInfo"+tier);

        var QuestTierInfo_label = $.CreatePanel("Label", QuestTierInfo, "");
        QuestTierInfo_label.AddClass("QuestTierInfo_label"+tier);
        QuestTierInfo_label.text = "Tier " + tier
      
        var DayQuest = $.CreatePanel("Panel", $("#QuestBlock"), "quest_tier_" + tier);
        DayQuest.AddClass("DayQuest");

        var QuestIcon = $.CreatePanel("Panel", DayQuest, "");
        QuestIcon.AddClass("QuestIcon");
        //QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_table[2] + '.png")';
        //QuestIcon.style.backgroundSize = "100%"

        var QuestInfo = $.CreatePanel("Panel", DayQuest, "");
        QuestInfo.AddClass("QuestInfo");

        var QuestName = $.CreatePanel("Label", QuestInfo, "");
        QuestName.AddClass("QuestName");
        QuestName.text = $.Localize("#" + quest_table[2])

        var QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
        QuestProgress.AddClass("QuestProgress");

        var QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
        QuestProgressBackground.AddClass("QuestProgressBackground");

        var QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
        QuestProgressLine.AddClass("QuestProgressLine");

        var percentage = ((quest_table[3]-Number(quest_player_table["current_point"]))*100)/quest_table[3]
        QuestProgressLine.style['width'] = (100 - percentage) +'%';

        var QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
        QuestProgressLabel.AddClass("QuestProgressLabel");
        QuestProgressLabel.text = Number(quest_player_table["current_point"]) + " / " + quest_table[3]  // Прогресс квеста

        var QuestSuccesIcon = $.CreatePanel("Panel", QuestIcon, "QuestSuccesIcon");
        QuestSuccesIcon.AddClass("QuestSuccesIcon");
        QuestSuccesIcon.style.opacity = 0;

        var update_quest_button = $.CreatePanel("Panel", QuestInfo, "update_quest_button");
        update_quest_button.AddClass("update_quest_button");

        var update_quest_button_label = $.CreatePanel("Label", update_quest_button, "update_quest_button_label");
        update_quest_button_label.AddClass("update_quest_button_label");
        update_quest_button_label.text = $.Localize("#update_quest_button_label")

        if (Number(quest_player_table["current_point"]) >= Number(quest_table[3]))
        {
            QuestSuccesIcon.style.opacity = 1;
            update_quest_button.style.visibility = "collapse"
        }

        if (Number(swap) == 1)
        {
            update_quest_button.style.visibility = "collapse"
        }

        if (no_battlepass)
        {
            update_quest_button.style.visibility = "collapse"
        }

        ChangeQuestButton(update_quest_button, quest_table[0], tier)
    }
}

function ChangeQuestButton(panel, quest_id, tier)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        GameEvents.SendCustomGameEventToServer("ChangeQuest", {quest_id : quest_id, tier : tier});
        panel.style.visibility = "collapse"
        $.Schedule( 0.503, function(){
            InitProfile()
        })
    });
}

var toggle_quest = false;
var first_time_quest = false;
var cooldown_panel_quest = false

function QuestToggle() {
    if (toggle_quest === false) {
        if (cooldown_panel_quest == false) {
            toggle_quest = true;
            if (first_time_quest === false) 
            {
                let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
                if (player_table)
                {
                    CreateQuestsFront(player_table)
                }
                first_time_quest = true;
                $("#QuestFront").AddClass("damage_close");
            }  
            if ($("#QuestFront").BHasClass("damage_close")) {
                $("#QuestFront").RemoveClass("damage_close");
            }
            $("#QuestFront").AddClass("damage_open");
            cooldown_panel_quest = true
            $.Schedule( 0.503, function(){
                cooldown_panel_quest = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle_quest = false;
            if ($("#QuestFront").BHasClass("damage_open")) {
                $("#QuestFront").RemoveClass("damage_open");
            }
            $("#QuestFront").AddClass("damage_close");
            cooldown_panel_quest = true
            $.Schedule( 0.503, function(){
                cooldown_panel_quest = false
            })
        }
    }
}


function CreateQuestsFront(player_table)
{
    $("#QuestFrontList").RemoveAndDeleteChildren()
    if (player_table) 
    {
        CreateQuestFront(player_table.quest_1, 1, player_table.quest_swap1, player_table.pass_level_3_days <= 0)
        CreateQuestFront(player_table.quest_2, 2, player_table.quest_swap2, player_table.pass_level_3_days <= 0)
        CreateQuestFront(player_table.quest_3, 3, player_table.quest_swap3, player_table.pass_level_3_days <= 0)
    }
}

function CreateQuestFront(quest_player_table, tier, swap, no_battlepass)
{
    let quest_table = null

    let quest_table_tier_1 = CustomNetTables.GetTableValue("quests_table", "tier_1")
    let quest_table_tier_2 = CustomNetTables.GetTableValue("quests_table", "tier_2")
    let quest_table_tier_3 = CustomNetTables.GetTableValue("quests_table", "tier_3")

    if (quest_table_tier_1 && quest_table_tier_2 && quest_table_tier_3)
    {
        for (var i = 1; i <= Object.keys(quest_table_tier_1.quest).length; i++) 
        {
            if (quest_table_tier_1.quest[i][1] == Number(quest_player_table["quest_number"]))
            {
                quest_table = quest_table_tier_1.quest[i]
            }
        }

        for (var i = 1; i <= Object.keys(quest_table_tier_2.quest).length; i++) 
        {
            if (quest_table_tier_2.quest[i][1] == Number(quest_player_table["quest_number"]))
            {
                quest_table = quest_table_tier_2.quest[i]
            }
        }

        for (var i = 1; i <= Object.keys(quest_table_tier_3.quest).length; i++) 
        {
            if (quest_table_tier_3.quest[i][1] == Number(quest_player_table["quest_number"]))
            {
                quest_table = quest_table_tier_3.quest[i]
            }
        }

        if (quest_table == null) 
        {
            return
        }

        var QuestTierInfo = $.CreatePanel("Panel", $("#QuestFrontList"), "");
        QuestTierInfo.AddClass("QuestTierInfo"+tier);

        var QuestTierInfo_label = $.CreatePanel("Label", QuestTierInfo, "");
        QuestTierInfo_label.AddClass("QuestTierInfo_label"+tier);
        QuestTierInfo_label.text = "Tier " + tier
      
        var DayQuest = $.CreatePanel("Panel", $("#QuestFrontList"), "quest_tier_" + tier);
        DayQuest.AddClass("DayQuest");

        var QuestIcon = $.CreatePanel("Panel", DayQuest, "");
        QuestIcon.AddClass("QuestIcon");
        //QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_table[2] + '.png")';
        //QuestIcon.style.backgroundSize = "100%"

        var QuestInfo = $.CreatePanel("Panel", DayQuest, "");
        QuestInfo.AddClass("QuestInfo");

        var QuestName = $.CreatePanel("Label", QuestInfo, "");
        QuestName.AddClass("QuestName");
        QuestName.text = $.Localize("#" + quest_table[2])

        var QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
        QuestProgress.AddClass("QuestProgress");

        var QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
        QuestProgressBackground.AddClass("QuestProgressBackground");

        var QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
        QuestProgressLine.AddClass("QuestProgressLine2");

        var percentage = ((quest_table[3]-Number(quest_player_table["current_point"]))*100)/quest_table[3]
        QuestProgressLine.style['width'] = (100 - percentage) +'%';

        var QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
        QuestProgressLabel.AddClass("QuestProgressLabel");
        QuestProgressLabel.text = Number(quest_player_table["current_point"]) + " / " + quest_table[3]  // Прогресс квеста

        var QuestSuccesIcon = $.CreatePanel("Panel", QuestIcon, "QuestSuccesIcon");
        QuestSuccesIcon.AddClass("QuestSuccesIcon");
        QuestSuccesIcon.style.opacity = 0;
    }
}

CustomNetTables.SubscribeNetTableListener( "cha_server_data", UpdateQuest );

function UpdateQuest(table, key, data ) 
{
    if (table == "cha_server_data") 
    {
        if (key == Players.GetLocalPlayer()) 
        {
            let player_table = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()))
            if (player_table)
            {
                CreateQuestsFront(player_table)
            }
        }
    }
}