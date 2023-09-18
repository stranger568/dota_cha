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

    if (HasModifier(hero, "modifier_item_essence_of_speed"))
    {
        CreateSkill("modifier_item_essence_of_speed", 1)
    }

    if (HasModifier(hero, "modifier_item_gem_shard"))
    {
        CreateSkill("modifier_item_gem_shard", 2)
    }

    if (HasModifier(hero, "modifier_item_moon_shard_buff_custom"))
    {
        CreateSkill("modifier_item_moon_shard_buff_custom", 3)
    }

    if (HasModifier(hero, "modifier_item_dark_moon_shard"))
    {
        CreateSkill("modifier_item_dark_moon_shard", 4)
    }

    $.Schedule(0.1, UpdateHeroHudBuffs)
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

function CreateSkill(modifier, tier)
{
    let this_skill = $("#SkillsPlayer").FindChildTraverse(modifier)

    if (this_skill)
    {
        return
    }

    var Skill = $.CreatePanel("Panel", $("#SkillsPlayer"), modifier);
    Skill.AddClass("SkillPanel"+tier);
    Skill.style.backgroundImage = 'url("file://{images}/custom_game/buffs/' + modifier + '.png")';
    Skill.style.backgroundSize = "100%"

    SetShowText(Skill, modifier)
}

function SetShowText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent( "DOTAShowBuffTooltip", panel, Players.GetLocalPlayerPortraitUnit(), HasModifier(Players.GetLocalPlayerPortraitUnit(), text) , Entities.IsEnemy( Players.GetLocalPlayerPortraitUnit() ) );
    })
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent( "DOTAHideBuffTooltip", panel );
    });       
}