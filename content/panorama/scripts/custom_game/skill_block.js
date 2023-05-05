var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
if (parentHUDElements)
{
    var center_block = parentHUDElements.FindChildTraverse("center_block");
    $.GetContextPanel().SetParent(center_block);
}

var hero = Players.GetLocalPlayerPortraitUnit()

UpdateHeroHudBuffs();

function UpdateHeroHudBuffs()
{
    if (hero != Players.GetLocalPlayerPortraitUnit())
    {
        $("#SkillsPlayer").RemoveAndDeleteChildren()
    }

    hero = Players.GetLocalPlayerPortraitUnit()

    let skills_1 = CustomNetTables.GetTableValue("skills_table", "tier_1")
    if (skills_1 && skills_1.skills)
    {
        for (var i = 1; i <= Object.keys(skills_1.skills).length; i++)
        {
            if (HasModifier(hero, skills_1.skills[i][1]))
            {
                CreateSkill(skills_1.skills[i], 1)
            }
        }
    }
    let skills_2 = CustomNetTables.GetTableValue("skills_table", "tier_2")
    if (skills_2 && skills_2.skills)
    {
        for (var i = 1; i <= Object.keys(skills_2.skills).length; i++)
        {
            if (HasModifier(hero, skills_2.skills[i][1]))
            {
                CreateSkill(skills_2.skills[i], 2)
            }
        }
    }
    let skills_3 = CustomNetTables.GetTableValue("skills_table", "tier_3")
    if (skills_3 && skills_3.skills)
    {
        for (var i = 1; i <= Object.keys(skills_3.skills).length; i++)
        {
            if (HasModifier(hero, skills_3.skills[i][1]))
            {
                CreateSkill(skills_3.skills[i], 3)
            }
        }
    }
    
    let skills_4 = CustomNetTables.GetTableValue("skills_table", "tier_4")
    if (skills_4 && skills_4.skills)
    {
        for (var i = 1; i <= Object.keys(skills_4.skills).length; i++)
        {
            if (HasModifier(hero, skills_4.skills[i][1]))
            {
                CreateSkill(skills_4.skills[i], 4)
            }
        }
    }
    
    let skills_5 = CustomNetTables.GetTableValue("skills_table", "tier_5")
    if (skills_5 && skills_5.skills)
    {
        for (var i = 1; i <= Object.keys(skills_5.skills).length; i++)
        {
            if (HasModifier(hero, skills_5.skills[i][1]))
            {
                CreateSkill(skills_5.skills[i], 5)
            }
        }
    }

    $.Schedule(1/144, UpdateHeroHudBuffs)
}

function HasModifier(unit, modifier) 
{
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) 
    {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier)
        {
            return Entities.GetBuff(unit, i)
        }
    }
   return false
}

function CreateSkill(info, tier)
{
    let this_skill = $("#SkillsPlayer").FindChildTraverse(info[1])

    if (this_skill)
    {
        return
    }

    var Skill = $.CreatePanel("Panel", $("#SkillsPlayer"), info[1]);
    Skill.AddClass("SkillPanel"+tier);
    Skill.style.backgroundImage = 'url("file://{images}/custom_game/skills/' + info[3] + '.png")';
    Skill.style.backgroundSize = "100%"

    SetShowText(Skill, "<b>" + $.Localize("#"+info[2]) + "</b>" + "<br><br>" + $.Localize("#" + info[2]+ "_desc"))
}

function SetShowText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}