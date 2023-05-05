
 
function ShowRandomHeroSelection(keys) 
{
    var data = keys.data
    var cardSelectionPanel = $("#CardSelection_Body");
    if (cardSelectionPanel.inited != undefined) 
    {
        return;
    }
    cardSelectionPanel.inited = true;
    Game.EmitSound("announcer_announcer_now_select")
    for (var k in data) {
        var heroName = data[k];
        var heroInfo = CustomNetTables.GetTableValue("hero_info", heroName)

        var panelID = "card_" + k;
        var panel = cardSelectionPanel.FindChildTraverse(panelID);
        if (panel == undefined && panel == null) {
            panel = $.CreatePanel("Panel", cardSelectionPanel, panelID);
            panel.BLoadLayoutSnippet("Card");
            InitCardPanelEvent(panel);
        }

        let last_scene = panel.FindChildTraverse("hero_model")
        let last_talents = panel.FindChildTraverse("talents_p")
        let last_abil = panel.FindChildTraverse("hero_abilities")
        if (last_scene)
        {
            last_scene.DeleteAsync(0)
        }
        if (last_talents)
        {
            last_talents.DeleteAsync(0)
        }
        if (last_abil)
        {
            last_abil.DeleteAsync(0)
        }

        $.CreatePanelWithProperties("DOTAScenePanel", panel.FindChildTraverse("CardImage"), "hero_model", { style: "width:100%;height:100%;", drawbackground: true, unit:heroName, particleonly:"false", renderdeferred:"false", antialias:"true", renderwaterreflections:"true" });

        let talents = $.CreatePanel("Panel", panel, "talents_p");
        talents.AddClass("talents_block")
        panel.FindChildTraverse("CardIcon").heroimagestyle = "icon";
        panel.FindChildTraverse("CardIcon").heroname = heroName;

        switch (heroInfo.szAttributePrimary) {
            case "DOTA_ATTRIBUTE_AGILITY":
                panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_agility_psd.vtex");
                break;
            case "DOTA_ATTRIBUTE_INTELLECT":
                panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_intelligence_psd.vtex");
                break;
            case "DOTA_ATTRIBUTE_STRENGTH":
                panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex");
                break;
            case "DOTA_ATTRIBUTE_ALL":
                panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_all_psd.vtex");
                break;
            default:
                panel.FindChildTraverse("CardAttributePrimaryIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex");
        }

        let tables = CustomNetTables.GetTableValue("hero_info", "Abilities_"+heroName.replace( "npc_dota_hero_", "" ))
        let banned_ab = CustomNetTables.GetTableValue("hero_info", "ban_abilities")
        let hero_abilities = $.CreatePanel("Panel", panel, "hero_abilities");
        hero_abilities.AddClass("hero_abilities")
        for (var i = 1; i <= Object.keys(tables).length; i++) 
        {
            var ability_panel = $.CreatePanel('DOTAAbilityImage', hero_abilities, '');
            ability_panel.abilityname = tables[i]
            ability_panel.AddClass("abiliti_hero")
            SetShowAbDesc(ability_panel, tables[i])
            for (var b = 1; b <= Object.keys(banned_ab).length; b++) 
            {
                if (String(banned_ab[b]) == String(tables[i]))
                {
                    let banned_visual = $.CreatePanel("Panel", ability_panel, "");
                    banned_visual.AddClass("banned_visual")
                    ability_panel.AddClass("banned_color")
                }
            }
        }

        TalentOver(talents, GetHeroID(heroName)) 
        panel.FindChildTraverse("CardName").text = $.Localize("#" + heroName);
        panel.heroName = heroName
    }

    if (keys.first_random == "yes") {
        MouseOver($("#CardSelection_RerollButton"), "#rerol_aviable_in_bp")

        var player_information_battlepass = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()));
        if (player_information_battlepass) {
            if (player_information_battlepass.pass_level_3_days && player_information_battlepass.pass_level_3_days > 0) {
                $("#CardSelection_RerollButton").SetHasClass("no_battle_pass", false);
                MouseOver($("#CardSelection_RerollButton"), "#rerol_description")
                $("#CardSelection_RerollButton").SetPanelEvent("onactivate", function() {
                    $("#CardSelection").SetHasClass("show", false);
                    $("#CardSelection_Body").RemoveClass("draw");
                    $("#HeroSelectionShow").TriggerClass("fade");
                    cardSelectionPanel.inited = undefined;
                    GameEvents.SendCustomGameEventToServer("RerollHeroes", {
                        player_id: Players.GetLocalPlayer()
                    });
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

function SetShowAbDesc(panel, ability)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowAbilityTooltip', panel, ability); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideAbilityTooltip', panel);
    });       
}

function MouseOver(panel, text) {
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, $.Localize(text))
    });

    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });
}

function TalentOver(panel, hero_id) 
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAHUDShowHeroStatBranchTooltip', panel, hero_id)
    });

    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHUDHideStatBranchTooltip', panel);
    });
}

function GetHeroID(heroName) 
{
    var result = heroesId[heroName];
    if (result == null) return -1;
    return result;
}

function InitCardPanelEvent(panel) {
    panel.SetPanelEvent("onactivate", function() {
        HeroSelected(panel.heroName)
    });
}

function CloseCardSelection() {
    HeroSelected(Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()))
}

function HeroSelected(heroName) 
{
    if (!$("#CardSelection").BHasClass("show"))
    {
        return
    }

    GameEvents.SendCustomGameEventToServer("HeroSelected", 
    {
        hero_name: heroName,
        player_id: Players.GetLocalPlayer()
    });

    $("#CardSelection").SetHasClass("show", false);
    $("#CardSelection_Body").RemoveClass("draw");

    var soundList = HERO_SPAWN_SOUND_EVENTS[heroName];
    if (soundList != undefined && soundList != null) {
        var soundEventName = soundList[Math.floor((Math.random() * soundList.length))];
        Game.EmitSound(soundEventName);
    }

    $("#HeroSelectionShow").SetImage("file://{images}/custom_game/show/" + heroName + ".png")
    $("#HeroSelectionShow").TriggerClass("fade");

    var particleID = Particles.CreateParticle("particles/generic_gameplay/screen_arcane_drop.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, 0);
    $.Schedule(0.5, function() {
        Particles.DestroyParticleEffect(particleID, false);
    });
}

function HideHeroSelection(keys) {

    if (!IsSecurityKeyValid(keys.security_key)) {
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

    $("#HeroSelectionShow").SetImage("file://{images}/custom_game/creature_show/" + keys.creatureName + ".png")
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

const heroesId = {
    npc_dota_hero_antimage: 1,
    npc_dota_hero_axe: 2,
    npc_dota_hero_bane: 3,
    npc_dota_hero_bloodseeker: 4,
    npc_dota_hero_crystal_maiden: 5,
    npc_dota_hero_drow_ranger: 6,
    npc_dota_hero_earthshaker: 7,
    npc_dota_hero_juggernaut: 8,
    npc_dota_hero_mirana: 9,
    npc_dota_hero_nevermore: 11,
    npc_dota_hero_morphling: 10,
    npc_dota_hero_phantom_lancer: 12,
    npc_dota_hero_puck: 13,
    npc_dota_hero_pudge: 14,
    npc_dota_hero_razor: 15,
    npc_dota_hero_sand_king: 16,
    npc_dota_hero_storm_spirit: 17,
    npc_dota_hero_sven: 18,
    npc_dota_hero_tiny: 19,
    npc_dota_hero_vengefulspirit: 20,
    npc_dota_hero_windrunner: 21,
    npc_dota_hero_zuus: 22,
    npc_dota_hero_kunkka: 23,
    npc_dota_hero_lina: 25,
    npc_dota_hero_lich: 31,
    npc_dota_hero_lion: 26,
    npc_dota_hero_shadow_shaman: 27,
    npc_dota_hero_slardar: 28,
    npc_dota_hero_tidehunter: 29,
    npc_dota_hero_witch_doctor: 30,
    npc_dota_hero_riki: 32,
    npc_dota_hero_enigma: 33,
    npc_dota_hero_tinker: 34,
    npc_dota_hero_sniper: 35,
    npc_dota_hero_necrolyte: 36,
    npc_dota_hero_warlock: 37,
    npc_dota_hero_beastmaster: 38,
    npc_dota_hero_queenofpain: 39,
    npc_dota_hero_venomancer: 40,
    npc_dota_hero_faceless_void: 41,
    npc_dota_hero_skeleton_king: 42,
    npc_dota_hero_death_prophet: 43,
    npc_dota_hero_phantom_assassin: 44,
    npc_dota_hero_pugna: 45,
    npc_dota_hero_templar_assassin: 46,
    npc_dota_hero_viper: 47,
    npc_dota_hero_luna: 48,
    npc_dota_hero_dragon_knight: 49,
    npc_dota_hero_dazzle: 50,
    npc_dota_hero_rattletrap: 51,
    npc_dota_hero_leshrac: 52,
    npc_dota_hero_furion: 53,
    npc_dota_hero_life_stealer: 54,
    npc_dota_hero_dark_seer: 55,
    npc_dota_hero_clinkz: 56,
    npc_dota_hero_omniknight: 57,
    npc_dota_hero_enchantress: 58,
    npc_dota_hero_huskar: 59,
    npc_dota_hero_night_stalker: 60,
    npc_dota_hero_broodmother: 61,
    npc_dota_hero_bounty_hunter: 62,
    npc_dota_hero_weaver: 63,
    npc_dota_hero_jakiro: 64,
    npc_dota_hero_batrider: 65,
    npc_dota_hero_chen: 66,
    npc_dota_hero_spectre: 67,
    npc_dota_hero_doom_bringer: 69,
    npc_dota_hero_ancient_apparition: 68,
    npc_dota_hero_ursa: 70,
    npc_dota_hero_spirit_breaker: 71,
    npc_dota_hero_gyrocopter: 72,
    npc_dota_hero_alchemist: 73,
    npc_dota_hero_invoker: 74,
    npc_dota_hero_silencer: 75,
    npc_dota_hero_obsidian_destroyer: 76,
    npc_dota_hero_lycan: 77,
    npc_dota_hero_brewmaster: 78,
    npc_dota_hero_shadow_demon: 79,
    npc_dota_hero_lone_druid: 80,
    npc_dota_hero_chaos_knight: 81,
    npc_dota_hero_meepo: 82,
    npc_dota_hero_treant: 83,
    npc_dota_hero_ogre_magi: 84,
    npc_dota_hero_undying: 85,
    npc_dota_hero_rubick: 86,
    npc_dota_hero_disruptor: 87,
    npc_dota_hero_nyx_assassin: 88,
    npc_dota_hero_naga_siren: 89,
    npc_dota_hero_keeper_of_the_light: 90,
    npc_dota_hero_wisp: 91,
    npc_dota_hero_visage: 92,
    npc_dota_hero_slark: 93,
    npc_dota_hero_medusa: 94,
    npc_dota_hero_troll_warlord: 95,
    npc_dota_hero_centaur: 96,
    npc_dota_hero_magnataur: 97,
    npc_dota_hero_shredder: 98,
    npc_dota_hero_bristleback: 99,
    npc_dota_hero_tusk: 100,
    npc_dota_hero_skywrath_mage: 101,
    npc_dota_hero_abaddon: 102,
    npc_dota_hero_elder_titan: 103,
    npc_dota_hero_legion_commander: 104,
    npc_dota_hero_ember_spirit: 106,
    npc_dota_hero_earth_spirit: 107,
    npc_dota_hero_abyssal_underlord: 108,
    npc_dota_hero_terrorblade: 109,
    npc_dota_hero_phoenix: 110,
    npc_dota_hero_techies: 105,
    npc_dota_hero_oracle: 111,
    npc_dota_hero_winter_wyvern: 112,
    npc_dota_hero_arc_warden: 113,
    npc_dota_hero_monkey_king: 114,
    npc_dota_hero_dark_willow: 119,
    npc_dota_hero_pangolier: 120,
    npc_dota_hero_grimstroke: 121,
    npc_dota_hero_hoodwink: 123,
    npc_dota_hero_void_spirit: 126,
    npc_dota_hero_snapfire: 128,
    npc_dota_hero_mars: 129,
    npc_dota_hero_dawnbreaker: 135,
    npc_dota_hero_marci: 136,
    npc_dota_hero_primal_beast: 137,
    npc_dota_hero_muerta: 138,
};


(function() 
{
    GameEvents.Subscribe("ShowRandomHeroSelection", ShowRandomHeroSelection);
    GameEvents.Subscribe("ShowHeroPrecacheCountDown", ShowHeroPrecacheCountDown);
    GameEvents.Subscribe("HideHeroPrecacheCountDown", HideHeroPrecacheCountDown);
    GameEvents.Subscribe("HideHeroSelection", HideHeroSelection);
    GameEvents.Subscribe("ExtraCreatureAdded", ExtraCreatureAdded);
})();