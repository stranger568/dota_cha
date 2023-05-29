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
    for (var i = 1; i <= Object.keys(data.skills).length; i++)
    {
        if (i == 4)
        {
            let player_table = CustomNetTables.GetTableValue("cha_server_data", Players.GetLocalPlayer())
            //if (player_table && player_table.pass_level_3_days > 0)
            //{
                CreateSkill(data.skills[i], $("#SkillSelectorSkillBody"), true, data.tier, i)
            //}
        } else {
            CreateSkill(data.skills[i], $("#SkillSelectorSkillBody"), false, data.tier, i)
        }
    }
    UpdateAbilityMask()
    $("#SkillSelectorPanelRoot").SetHasClass("show", true)
}

function CreateSkill(info, panel, battlepass, tier, number)
{
    var Skill_full = $.CreatePanel("Panel", panel, "");
    Skill_full.AddClass("Skill_full");

    var Skill = $.CreatePanel("Panel", Skill_full, "skill_"+number);
    Skill.AddClass("SkillPanel");
    Skill.style.backgroundImage = 'url("file://{images}/custom_game/skills/' + info[3] + '.png")';
    Skill.style.backgroundSize = "100%"
    Skill.style.border = "1px solid " + Tier_color[tier-1]
    $("#SkillSelectorTitleTier").style.color = Tier_color[tier-1]
    $("#SkillSelectorTitleTier").text = "Tier " + tier
    SetShowText(Skill, "<b>" + $.Localize("#"+info[2]) + "</b>" + "<br><br>" + $.Localize("#" + info[2]+ "_desc"))
    var CooldownOverlay = $.CreatePanel("Panel", Skill, "CooldownOverlay");
    Skill.SetPanelEvent("onactivate", function() 
    { 
        $("#SkillSelectorSkillBody").RemoveAndDeleteChildren()
        $("#SkillSelectorPanelRoot").SetHasClass("show", false)
        GameEvents.SendCustomGameEventToServer( "ChooseSkillReal", {skill : info[1], tier : tier} );
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

function UpdateAbilityMask() 
{
    var parent = $("#SkillSelectorSkillBody");

    if (parent.cooldown == undefined) 
    {
        parent.cooldown = 0.8
        for (var i = 1; i <= 4; i++) 
        {
            var panelID = "skill_"+i;
            var panel = parent.FindChildTraverse(panelID);
            if (panel!=undefined)
            {
                panel.enabled = false;
                panel.FindChildTraverse("CooldownOverlay").RemoveClass("Hidden");
            }
        }
    }

    var angle = parent.cooldown / 0.8 * 360;
    parent.cooldown = parent.cooldown - 0.04

    if (parent.cooldown<=0)
    {
        parent.cooldown = undefined
        for (var i = 1; i <= 4; i++) 
        {
            var panelID = "skill_"+i;
            var panel = parent.FindChildTraverse(panelID);
            if (panel!=undefined)
            {
                panel.enabled = true;
                panel.FindChildTraverse("CooldownOverlay").AddClass("Hidden");
            }
        }
    }
    else 
    {
        for (var i = 1; i <= 4; i++) 
        {
            var panelID = "skill_"+i;
            var panel = parent.FindChildTraverse(panelID);
            if (panel!=undefined)
            {
                panel.FindChildTraverse("CooldownOverlay").style.clip="radial( 50.0% 50.0%, 0.0deg, -"+angle+"deg)";
            }               
        }
        $.Schedule(0.04, UpdateAbilityMask)
    } 
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