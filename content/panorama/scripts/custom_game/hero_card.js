function ShowRandomHeroSelection(keys) {
       
    if (!IsSecurityKeyValid(keys.security_key))
    {
        return
    }

    var data = keys.data

    var cardSelectionPanel = $("#CardSelection_Body");
    
    
    if (cardSelectionPanel.inited!=undefined)
    {
        return;
    }
    // 初始化标志位
    cardSelectionPanel.inited= true;

    for (var k in data) {
        var heroName = data[k];
        var heroInfo = CustomNetTables.GetTableValue( "hero_info", heroName )

        var panelID = "card_"+k;
        var panel = cardSelectionPanel.FindChildTraverse(panelID);
        if (panel == undefined && panel == null) {
            panel = $.CreatePanel("Panel", cardSelectionPanel, panelID);
            panel.BLoadLayoutSnippet("Card");
            InitCardPanelEvent(panel);
        }
        panel.FindChildTraverse("CardImage").SetImage("file://{images}/custom_game/card/"+heroName+".png");

        panel.FindChildTraverse("CardIcon").heroimagestyle = "icon";
        panel.FindChildTraverse("CardIcon").heroname = heroName;
        
        switch(heroInfo.szAttributePrimary) {
         case "DOTA_ATTRIBUTE_AGILITY":
            panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_agility_psd.vtex");
            break;
         case "DOTA_ATTRIBUTE_INTELLECT":
            panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_intelligence_psd.vtex");
            break;
         case "DOTA_ATTRIBUTE_STRENGTH":
            panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex");
            break;
         default:
            panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex");
        } 
        for (var i = 1; i <= 8; i++) {
             var talentName= heroInfo.talentNames[i];
             var label = panel.FindChildTraverse("StatBonusLabel_"+i)
             label.text = $.Localize("#DOTA_Tooltip_ability_"+talentName,label);

             if (heroInfo.talentValues[i]!=null){               
                for(var key in heroInfo.talentValues[i]){
                  label.text = label.text.replace(/\[!s:[a-zA-Z_]+]/, heroInfo.talentValues[i][key])
　　　　　　　　　}
             }
        }

        panel.FindChildTraverse("CardName").text = $.Localize("#"+heroName);
        panel.heroName=heroName
    }

    if (keys.first_random == "yes")
    {
        MouseOver($("#CardSelection_RerollButton"), "#rerol_aviable_in_bp")

        var player_information_battlepass = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()));
        if (player_information_battlepass) 
        {
            if (player_information_battlepass.pass_level_3_days && player_information_battlepass.pass_level_3_days > 0)
            {
                $("#CardSelection_RerollButton").SetHasClass("no_battle_pass", false);
                MouseOver($("#CardSelection_RerollButton"), "#rerol_description")
                $("#CardSelection_RerollButton").SetPanelEvent("onactivate", function() {
                    $("#CardSelection").SetHasClass("show", false);
                    $("#CardSelection_Body").RemoveClass("draw");
                    $("#HeroSelectionShow").TriggerClass("fade");
                    cardSelectionPanel.inited= undefined;
                    GameEvents.SendCustomGameEventToServer("RerollHeroes", { player_id : Players.GetLocalPlayer() });
                    $("#CardSelection_RerollButton").SetPanelEvent("onactivate", function() {});   
                    $("#CardSelection_RerollButton").SetHasClass("no_battle_pass", false);
                });
            } 
        } 
    } else {
        $("#CardSelection_RerollButton").SetHasClass("no_battle_pass", true);
        $("#CardSelection_RerollButton").SetPanelEvent("onactivate", function() {});
    }

    $("#CardSelection").SetHasClass("show", true);
    $("#CardSelection_Body").AddClass("draw");
    Game.EmitSound("GameUI.DrawCard");
}

function MouseOver(panel, text) {
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, $.Localize(text))
    });

    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });

}

function InitCardPanelEvent(panel) {
    panel.SetPanelEvent("onactivate", function() {
        HeroSelected(panel.heroName)
    });
}

function CloseCardSelection() {
    HeroSelected( Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()) )
}

function HeroSelected(heroName){
   
    GameEvents.SendCustomGameEventToServer("HeroSelected", {
        hero_name : heroName,
        player_id : Players.GetLocalPlayer() 
    });

    $("#CardSelection").SetHasClass("show", false);
    $("#CardSelection_Body").RemoveClass("draw");

    var soundList = HERO_SPAWN_SOUND_EVENTS[heroName];
    if (soundList != undefined && soundList != null) {
        var soundEventName = soundList[Math.floor((Math.random()*soundList.length))];
        Game.EmitSound(soundEventName);
    } 

    $("#HeroSelectionShow").SetImage("file://{images}/custom_game/show/"+heroName+".png")
    $("#HeroSelectionShow").TriggerClass("fade");

    var particleID = Particles.CreateParticle("particles/generic_gameplay/screen_arcane_drop.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, 0);
    $.Schedule(0.5, function() {
        Particles.DestroyParticleEffect(particleID, false);
    });

}



function HideHeroSelection(keys) {

    if (!IsSecurityKeyValid(keys.security_key))
    {
        return
    }

    $("#CardSelection").SetHasClass("show", false);
    $("#CardSelection_Body").RemoveClass("draw");

}


function ShowHeroPrecacheCountDown(keys) {
    
    $("#HeroPrecacheCountDownPanel").RemoveClass("Hidden");
    $("#HeroPrecacheCountDownPanel").RemoveClass("PopOut");
    $("#HeroPrecacheCountDownLabel").text = keys.countDown;
    $("#HeroPrecacheCountDownPanel").AddClass("PopOut");
}
function HideHeroPrecacheCountDown(keys) {

    $("#HeroPrecacheCountDownPanel").AddClass("Hidden");
}


function ExtraCreatureAdded(keys) {
   
    $("#HeroSelectionShow").SetImage("file://{images}/custom_game/creature_show/"+keys.creatureName+".png")
    $("#HeroSelectionShow").TriggerClass("fade");

    var soundEventName = EXTRA_CREATURE_SOUND_EVENTS[keys.creatureName];
    if (soundEventName != undefined) {
        Game.EmitSound(soundEventName);
    }

    var particleID = Particles.CreateParticle("particles/generic_gameplay/screen_arcane_drop.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, 0);
    $.Schedule(0.5, function() {
        Particles.DestroyParticleEffect(particleID, false);
    });
}



(function()
{
    GameEvents.Subscribe( "ShowRandomHeroSelection", ShowRandomHeroSelection );
    GameEvents.Subscribe( "ShowHeroPrecacheCountDown", ShowHeroPrecacheCountDown );
    GameEvents.Subscribe( "HideHeroPrecacheCountDown", HideHeroPrecacheCountDown );
    //强制选择英雄，隐藏本页面
    GameEvents.Subscribe( "HideHeroSelection", HideHeroSelection );
    GameEvents.Subscribe( "ExtraCreatureAdded", ExtraCreatureAdded );
})();
