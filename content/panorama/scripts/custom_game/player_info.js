var parentHUDElements2 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements2);

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
        if (cooldown_panel_quest == false) {
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
      
        var DayQuest = $.CreatePanel("Panel", $("#QuestFrontList"), "quest_tier_" + tier);
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