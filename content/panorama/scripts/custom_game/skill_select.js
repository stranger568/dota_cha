var Tier_color = 
[
    "#BEBEBE",
    "#92E47E",
    "#7F93FC",
    "#D57BFF",
    "#FFE195",
]

function HideSkillSelect() 
{
    $("#SkillSelectorPanel").ToggleClass("Hide")
}

function ShowSkillChoose(data)
{
    $("#SkillSelectorSkillBody").RemoveAndDeleteChildren()
    $("#SkillSelectorPanelRoot").SetHasClass("show", true)
    for (var i = 1; i <= Object.keys(data.skills).length; i++)
    {
        if (i == 4)
        {
            let player_table = CustomNetTables.GetTableValue("cha_server_data", Players.GetLocalPlayer())
            //if (player_table && player_table.pass_level_3_days > 0)
            //{
                CreateSkill(data.skills[i], $("#SkillSelectorSkillBody"), true, data.tier)
            //}
        } else {
            CreateSkill(data.skills[i], $("#SkillSelectorSkillBody"), false, data.tier)
        }
    }
}

function CreateSkill(info, panel, battlepass, tier)
{
    var Skill_full = $.CreatePanel("Panel", panel, "");
    Skill_full.AddClass("Skill_full");

    var Skill = $.CreatePanel("Panel", Skill_full, "");
    Skill.AddClass("SkillPanel");
    Skill.style.backgroundImage = 'url("file://{images}/custom_game/skills/' + info[3] + '.png")';
    Skill.style.backgroundSize = "100%"
    Skill.style.border = "1px solid " + Tier_color[tier-1]
    $("#SkillSelectorTitleTier").style.color = Tier_color[tier-1]
    $("#SkillSelectorTitleTier").text = "Tier " + tier
    SetShowText(Skill, "<b>" + $.Localize("#"+info[2]) + "</b>" + "<br><br>" + $.Localize("#" + info[2]+ "_desc"))

    Skill.SetPanelEvent("onactivate", function() 
    { 
        $("#SkillSelectorSkillBody").RemoveAndDeleteChildren()
        $("#SkillSelectorPanelRoot").SetHasClass("show", false)
        GameEvents.SendCustomGameEventToServer( "ChooseSkillReal", {skill : info[1]} );
    })

    var Label = $.CreatePanel("Label", Skill_full, "");
    Label.AddClass("SkillPanelLabel"+tier);
    Label.text = $.Localize("#"+info[2])

    //if (battlepass)
    //{
    //    var bp_icon = $.CreatePanel("Panel", Skill, "");
    //    bp_icon.AddClass("bp_icon");
    //    SetShowText(Skill, "<b>" + $.Localize("#"+info[2]) + "</b>" + "<br><br>" + $.Localize("#" + info[2]+ "_desc") + "<br><br><b><font color=\"#eadd5d\">" + $.Localize("#for_battlepass_skill") + "</font></b>")
    //    Skill.AddClass("bp_style");
    //}   
}

function SetShowText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

(function() 
{
     GameEvents.Subscribe("ShowSkillChoose", ShowSkillChoose);
})();