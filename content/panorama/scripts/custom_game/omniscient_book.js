var previousHeroRadio = null; //暂存玩家点选的英雄按钮
var banAbilities = CustomNetTables.GetTableValue("hero_info", "ban_abilities")
var exclusionAbilities = null;
var preHeroName = null;

var groupKV=
{
  str_1:["earthshaker","sven","tiny","kunkka","beastmaster","dragon_knight","rattletrap","omniknight","huskar","alchemist","brewmaster","treant","wisp",
        "centaur","shredder","bristleback","tusk","elder_titan","legion_commander","earth_spirit","phoenix","mars","snapfire","dawnbreaker","marci"],
  str_2:["axe","pudge","sand_king","slardar","tidehunter","skeleton_king","life_stealer","night_stalker","doom_bringer","spirit_breaker","lycan","chaos_knight","undying",
        "magnataur","abaddon","abyssal_underlord","primal_beast"],
  agi_1:["antimage","drow_ranger","juggernaut","mirana","morphling","phantom_lancer","vengefulspirit","riki","sniper","templar_assassin","luna","bounty_hunter","ursa",
        "gyrocopter","lone_druid","naga_siren","troll_warlord","ember_spirit","monkey_king","pangolier","hoodwink"], 
  agi_2:["bloodseeker","nevermore","razor","venomancer","faceless_void","phantom_assassin","viper","clinkz","broodmother","weaver","spectre","meepo","nyx_assassin",
        "slark","medusa","terrorblade","arc_warden"],
  int_1:["crystal_maiden","puck","storm_spirit","windrunner","zuus","lina","shadow_shaman","tinker","furion","enchantress","jakiro","chen","silencer","ogre_magi",
        "rubick","disruptor","keeper_of_the_light","skywrath_mage","oracle","techies","dark_willow","void_spirit"], 
  int_2:["bane","lich","lion","witch_doctor","enigma","necrolyte","warlock","queenofpain","death_prophet","pugna","dazzle","leshrac","dark_seer","batrider",
        "ancient_apparition","invoker","obsidian_destroyer","shadow_demon","visage","winter_wyvern","grimstroke"], 
}



function SetPanelText(parentPanel, childPanelId, text) {
    if (!parentPanel) {
        return;
    }

    var childPanel = parentPanel.FindChildInLayoutFile(childPanelId);
    if (!childPanel) {
        return;
    }

    childPanel.text = text;
}

var ShowAbilityTooltip = (function (ability) {
    return function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", ability, ability.abilityname);
    }
});

var HideAbilityTooltip = (function (ability) {
    return function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", ability);
    }
});


function Update_Heroes_Table() {

    Update_Heroes_Row($("#heroesTableStrAgi"), "str");
    Update_Heroes_Row($("#heroesTableStrAgi"), "agi");
    Update_Heroes_Row($("#heroesTableInt"), "int");
    $("#SelectButton").enabled=false

}

function Update_Heroes_Row(container, type) {

    var parentPanelId = "HeroesRow_" + type;

    var parentPanel = container.FindChild(parentPanelId);
    if (!parentPanel) {
        parentPanel = $.CreatePanel("Panel", container, parentPanelId);    //创建英雄组的panel
        parentPanel.BLoadLayoutSnippet("HeroesRow");
        parentPanel.SetHasClass("HeroesRow", true);
    }

    var groupNamePanel = parentPanel.FindChildTraverse("RowName");
    groupNamePanel.text = $.Localize("#"+type+"");    //设置Row Name
    parentPanel.FindChildTraverse("RowIcon").SetImage("file://{resources}/images/custom_game/" + type + ".png");

    var groupTable = parentPanel.FindChildTraverse("RowTable");

    for (var i = 1; i <= 2; i++) {

        var groupName =  type+"_"+i;
        var groupPanelId = "HeroesGroup_" + groupName;

        var groupPanel = groupTable.FindChild(groupPanelId);
        if (!groupPanel) {
            groupPanel = $.CreatePanel("Panel", groupTable, groupPanelId);
            groupPanel.SetHasClass("HeroesGroup", true);
        }

        Update_Heroes_Group(groupPanel, groupName);
    }
}

function Update_Heroes_Group(groupPanel, groupName) {

    var groupContainerId = "HeroesGroupContainer_" + groupName;

    var groupContainer = groupPanel.FindChild(groupContainerId);
    if (!groupContainer) {
        groupContainer = $.CreatePanel("Panel", groupPanel, groupContainerId);
        groupContainer.SetHasClass("HeroesGroupContainer", true);
        groupContainer.SetHasClass("hBlock", true);
    }
    
    for (var key in groupKV[groupName]) {
        var name = groupKV[groupName][key]
        var heroPanelId = "Hero_" + name;
        var heroPanel = groupContainer.FindChild(heroPanelId);
        if (!heroPanel) {
            heroPanel = $.CreatePanel("Panel", groupContainer, heroPanelId);
            heroPanel.BLoadLayoutSnippet("HeroesRadioButton");
            heroPanel.SetHasClass("HeroPanel", true);
        }

        Update_Heroes(heroPanel, groupName, name);
    }
}

function Update_Heroes(heroPanel, groupName, name) {

    var rButton = heroPanel.FindChildInLayoutFile("RadioButton");
    rButton.group = "Heroes";
    rButton.SetHasClass("hBlock", true);
    rButton.data = {
        heroName: name,
        heroGroup: groupName
    };

    rButton.SetPanelEvent("onselect", PreviewHero(rButton));   //保存下选择的英雄内容
    var childImage = heroPanel.FindChildInLayoutFile("RadioImage");
    childImage.heroname = "npc_dota_hero_" + name;
}


var PreviewHero = (function (rButton) {
    return function () {
        var heroInfo = rButton.data;
        UpdateTargetHeroAbilityList(heroInfo.heroName);
        preHeroName = heroInfo.heroName;
        if (previousHeroRadio != null) {
            previousHeroRadio.checked = false; //取消上一次点选的英雄（此处因为radio group失效）
        }
        previousHeroRadio = rButton;       //重新记录
    }
});


function UpdateTargetHeroAbilityList(heroName) {

    var parentPanel = $("#OperatePanel")
    var childImage = parentPanel.FindChildInLayoutFile("HeroImage");
    var abilityList = parentPanel.FindChildInLayoutFile("Abilities");

    if (heroName != "") {
        childImage.heroname = "npc_dota_hero_" + heroName;            //英雄头像
        var slotNumber = 0;
        for (var abilitySlot in CustomNetTables.GetTableValue("hero_info", "Abilities_"+heroName)) {
            slotNumber = slotNumber + 1;
        }
        if (!abilityList.maxslot || abilityList.maxslot < slotNumber) {
            abilityList.maxslot = slotNumber;
        }
        for (var slot = 1; slot <= abilityList.maxslot; slot++)                       //先全部隐藏起来
        {
            InvisibleAbilityList(abilityList, slot);
        }
        for (var slot = 1; slot <= slotNumber; slot++)                                //目标英雄技能列表
        {
            UpdateAbility(abilityList, heroName, slot);
        }
    }
}

function InvisibleAbilityList(abilityList, slot) {
    var abButtonId = "Ability_" + slot;
    var abButton = abilityList.FindChild(abButtonId);
    if (abButton) {
        abButton.SetHasClass("Hidden", true);
    }
}

function UpdateAbility(abilityList, heroName, slot) {

    var abButtonId = "Ability_" + slot;
    var abButton = abilityList.FindChild(abButtonId);
    if (!abButton) {
        abButton = $.CreatePanel("RadioButton", abilityList, abButtonId);
    }
    abButton.SetHasClass("Hidden", false);
    abButton.AddClass("AbilityRadioButton");

    var abPanelId = "Ability_Image_" + slot;
    var abPanel = abButton.FindChild(abPanelId);

    var abilityName = CustomNetTables.GetTableValue("hero_info", "Abilities_"+heroName)[slot];
    abButton.abilityName = abilityName;

    if (!abPanel) {
        abPanel = $.CreatePanel("DOTAAbilityImage", abButton, abPanelId);
        abPanel.SetHasClass("hBlock", true);
        abPanel.SetHasClass("vBlock", true);
        abPanel.data = {
            abilityName: abPanel.abilityname,
            heroName: heroName,
        }
        abPanel.abilityname = abilityName;
    }
    else    //更新技能
    {
        abPanel.abilityname = abilityName;
        abPanel.data.abilityName = abilityName;
        abPanel.data.heroName = heroName;
    }

    abButton.enabled=true

    //如果技能已经被禁用
    if (banAbilities)
    {
      for(var index in banAbilities) {
         if (abilityName==banAbilities[index])
         {
            abButton.enabled=false 
         }
       };  
    }

    if (exclusionAbilities)
    {
        for(var index in exclusionAbilities) {
            if (abilityName==exclusionAbilities[index])
            {
                abButton.enabled=false 
            }
       }; 
    }

    SetPanelEvent(abButton,abilityName);
}

function SetPanelEvent(panel,abilityName) {
   
   panel.SetPanelEvent("onactivate", function() {
  
       $("#SelectButtonLabel").text= $.Localize("#select") +  $.Localize("#DOTA_Tooltip_ability_"+abilityName);    
       $("#SelectButtonLabel").abilityName= abilityName;
       $("#SelectButton").enabled=true

   })

}


function CloseBanPanel(){
   
   $("#MainBlock").AddClass("Hidden")

}

function OpenBanPanel(){
   
   $("#MainBlock").RemoveClass("Hidden")

}

function ShowAllAbilitySelection(keys) {
    var parent = $("#OmniscientMain");

    if (parent==undefined) {
        return
    }
    GameEvents.SendCustomGameEventToServer("ClientReconnected", {});
    parent.ui_secret=keys.ui_secret;
    parent.RemoveClass("Hidden");
    $("#OmniscientButtonPanel").RemoveClass("Hidden");
    exclusionAbilities = keys.exclusion;
    if (preHeroName)
    {
        UpdateTargetHeroAbilityList(preHeroName);
    }
    //按钮复原
    $("#SelectButton").enabled=false
    $("#SelectButtonLabel").text= $.Localize("#confirm")

}

function HideAllAbilitySelection() {
    
    $("#OmniscientMain").ToggleClass("Hidden")
    $("#SelectButton").ToggleClass("Hidden")
    
}


function OminiscientSelectAbility() {
    
   var abilityName = $("#SelectButtonLabel").abilityName;
   GameEvents.SendCustomGameEventToServer("OminiscientSelectAbility", {ability_name:abilityName, ui_secret: $("#OmniscientMain").ui_secret});
   $("#OmniscientMain").AddClass("Hidden")
   $("#OmniscientButtonPanel").AddClass("Hidden")
   
}

(function() {
    GameEvents.Subscribe("ShowAllAbilitySelection", ShowAllAbilitySelection);
    Update_Heroes_Table();
})();