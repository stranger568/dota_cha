var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

GameUI.CustomUIConfig().OpenGuide = function ToggleGuide() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                first_time = true;
                $("#GuideWindow").AddClass("sethidden");
            }  
            if ($("#GuideWindow").BHasClass("sethidden")) {
                $("#GuideWindow").RemoveClass("sethidden");
            }
            $("#GuideWindow").AddClass("setvisible");
            $("#GuideWindow").style.visibility = "visible"
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#GuideWindow").BHasClass("setvisible")) {
                $("#GuideWindow").RemoveClass("setvisible");
            }
            $("#GuideWindow").AddClass("sethidden");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
                $("#GuideWindow").style.visibility = "collapse"
            })
        }
    }
}

var toggle_2 = false;
var first_time_2 = false;
var cooldown_panel_2 = false
var current_sub_tab_2 = "";

GameUI.CustomUIConfig().OpenSkills = function OpenSkills() {
    if (toggle_2 === false) {
        if (cooldown_panel_2 == false) {
            toggle_2 = true;
            if (first_time_2 === false) {
                first_time_2 = true;
                InitSkillsInfo()
                $("#PanelPlayerInfoSkills").AddClass("sethidden");
            }  
            if ($("#PanelPlayerInfoSkills").BHasClass("sethidden")) {
                $("#PanelPlayerInfoSkills").RemoveClass("sethidden");
            }
            $("#PanelPlayerInfoSkills").AddClass("setvisible");
            $("#PanelPlayerInfoSkills").style.visibility = "visible"
            cooldown_panel_2 = true
            $.Schedule( 0.503, function(){
                cooldown_panel_2 = false
            })
        }
    } else {
        if (cooldown_panel_2 == false) {
            toggle_2 = false;
            if ($("#PanelPlayerInfoSkills").BHasClass("setvisible")) {
                $("#PanelPlayerInfoSkills").RemoveClass("setvisible");
            }
            $("#PanelPlayerInfoSkills").AddClass("sethidden");
            cooldown_panel_2 = true
            $.Schedule( 0.503, function(){
                cooldown_panel_2 = false
                $("#PanelPlayerInfoSkills").style.visibility = "collapse"
            })
        }
    }
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