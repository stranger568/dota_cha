//可以在换技能页面展示的 附属技能
var subsidiaryException = {
    "beastmaster_call_of_the_wild_hawk": true,
    "morphling_adaptive_strike_str": true,
    "morphling_morph_str": true,
    "puck_ethereal_jaunt": true,
    "templar_assassin_trap": true,
    "elder_titan_ancestral_spirit": true,
    "earth_spirit_stone_caller": true,
    "phoenix_sun_ray_toggle_move": true,
    "lone_druid_true_form_battle_cry": true,
    "troll_warlord_whirling_axes_melee": true,
    "ember_spirit_activate_fire_remnant": true,
    "techies_focused_detonate": true,
    "nevermore_shadowraze2": true,
    "nevermore_shadowraze3": true,
    "shadow_demon_shadow_poison_release": true,
    "monkey_king_primal_spring": true,
    "kunkka_torrent_storm": true,
    "rattletrap_overclocking": true,
    "enchantress_bunny_hop": true,
    "treant_eyes_in_the_forest": true,
    "ogre_magi_unrefined_fireblast": true,
    "earth_spirit_petrify": true,
    "juggernaut_swift_slash": true,
    "snapfire_gobble_up": true,
    "snapfire_spit_creep": true,
    "nyx_assassin_burrow": true,
    "shredder_chakram_2_lua": true,
    "tusk_walrus_kick": true,
    "grimstroke_scepter": true,
    "zuus_cloud": true,
    "spectre_haunt_single": true,
    "tiny_tree_channel": true,
    "tiny_toss_tree": true,
    "alchemist_unstable_concoction_throw": true,
    "antimage_mana_overload": true,
    "keeper_of_the_light_will_o_wisp": true,
    "leshrac_greater_lightning_storm": true,
    "terrorblade_terror_wave": true,
    "templar_assassin_trap_teleport": true,
    "alchemist_berserk_potion": true,
    "bristleback_hairball": true,
    "broodmother_silken_bola": true,
    "rattletrap_jetpack": true,
    "dark_seer_normal_punch": true,
    "dragon_knight_fireball": true,
    "grimstroke_ink_over": true,
    "jakiro_liquid_ice": true,
    "jakiro_liquid_ice_lua": true,
    "kunkka_tidal_wave": true,
    "lich_ice_spire": true,
    "life_stealer_open_wounds": true,
    "magnataur_horn_toss": true,
    "meepo_petrify": true,
    "necrolyte_death_seeker": true,
    "ogre_magi_smash": true,
    "omniknight_hammer_of_purity": true,
    "pangolier_rollup": true,
    "phantom_assassin_fan_of_knives": true,
    "riki_poison_dart": true,
    "slark_fish_bait": true,
    "sniper_concussive_grenade": true,
    "storm_spirit_electric_rave": true,
    "shredder_flamethrower": true,
    "tinker_defense_matrix": true,
    "terrorblade_demon_zeal": true,
    "tiny_craggy_exterior": true,
    "tusk_frozen_sigil": true,
    "witch_doctor_voodoo_switcheroo": true,
    "wisp_spirits_in_lua": true,
};

var settingInited=false

function RefreshAbilityOrder(keys) {

        //遍历 玩家技能
        var parent = $("#AbilityOrderAbilityBody");
        $("#AbilityOrderAbilityBody").RemoveAndDeleteChildren()
        
        if (keys!=undefined && keys.swap_ui_secret!=undefined) 
        {
           $("#AbilityOrderAbilityBody").swap_ui_secret = keys.swap_ui_secret 
        }

        var playerHeroIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
        var abilityIndex = 0;
        for (var i = 0; i <= 30; i++) {
            var ability = Entities.GetAbility(playerHeroIndex, i);
            var abilityName = Abilities.GetAbilityName(ability);
            if (IsValidAbility(ability) || true==subsidiaryException[abilityName]) 
            {
                abilityIndex = abilityIndex + 1;
                var panelID = "ability_"+abilityIndex;
                var panel = parent.FindChildTraverse(panelID);
                if (panel == undefined && panel == null) {
                    panel = $.CreatePanel("Panel", parent, panelID);
                    panel.BLoadLayoutSnippet("AbilityOrderAbility");     
                }
                panel.abilityname = abilityName;
                panel.FindChildTraverse("AbilityImage").abilityname = abilityName;
                panel.FindChildTraverse('AbilityName').text = $.Localize("#DOTA_Tooltip_ability_" + abilityName); 
            }      
        }

        //遍历按钮 设置事件
        for (var i = 1; i <= abilityIndex; i++) {

          if (parent.FindChildTraverse("ability_"+i))
          {      
              var buttonLeft = parent.FindChildTraverse("ability_"+i).FindChildTraverse("ButtonLeft");
              var buttonRight = parent.FindChildTraverse("ability_"+i).FindChildTraverse("ButtonRight");
              
              //禁用最左边按钮
              if (i==1) {
                 buttonLeft.enabled=false;
              } else {
                 (function(thisIndex){          
                     buttonLeft.SetPanelEvent("onactivate", function(){
                        GameEvents.SendCustomGameEventToServer("SwapAbility", {
                            player_id : Players.GetLocalPlayer(),
                            swap_1 : parent.FindChildTraverse("ability_"+(thisIndex-1)).abilityname,
                            swap_2 : parent.FindChildTraverse("ability_"+thisIndex).abilityname,
                            swap_ui_secret: $("#AbilityOrderAbilityBody").swap_ui_secret
                         });
                     });
                 })(i);
              }
              // 禁用最右边按钮
              if (i==abilityIndex) {
                 buttonRight.enabled=false;  
              } else {
                 (function(thisIndex){ 
                     buttonRight.SetPanelEvent("onactivate", function(){
                        GameEvents.SendCustomGameEventToServer("SwapAbility", {
                            player_id : Players.GetLocalPlayer(),
                            swap_1 : parent.FindChildTraverse("ability_"+thisIndex).abilityname,
                            swap_2 : parent.FindChildTraverse("ability_"+(thisIndex+1)).abilityname,
                            swap_ui_secret: $("#AbilityOrderAbilityBody").swap_ui_secret
                         });
                     });
                 })(i);
              }
            }
        }

}

function CloseAbilityOrder() {
    $("#page_setting").SetHasClass("Show", false);
}

function ToggleOrder() {
    $("#page_setting").ToggleClass("Show");
    RefreshAbilityOrder();
}

function UpdateInventory() {
  RefreshAbilityOrder()
}

function FindDotaHudElement(id){  
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}

function  ChangeBarrageOpacity() {
    if (FindDotaHudElement("BarrgeMainPanel") && $("#BarrageOpacitySlider"))
    {
       FindDotaHudElement("BarrgeMainPanel").style.opacity = $("#BarrageOpacitySlider").value
    }
    UpdateSetting();
}

function ToggleAutoDuel(isLabel) {
   
   if (isLabel) {
     $("#CheckAutoDuel").SetSelected( !$("#CheckAutoDuel").IsSelected() );
   }
   GameEvents.SendCustomGameEventToServer("ToggleAutoDuel", {selected:$("#CheckAutoDuel").IsSelected()});
   UpdateSetting();
}

function ToggleAutoCreep(isLabel) {
  
  if (isLabel) {
    $("#CheckAutoCreep").SetSelected( !$("#CheckAutoCreep").IsSelected() );
  }
  GameEvents.SendCustomGameEventToServer("ToggleAutoCreep", {selected:$("#CheckAutoCreep").IsSelected()});
  UpdateSetting();
}


function ToggleLeftAbilitySelect(isLabel) {
  
  if (isLabel) {
    $("#CheckLeftAbilitySelect").SetSelected( !$("#CheckLeftAbilitySelect").IsSelected() );
  }


  FindDotaHudElement("AbilitySelectorPanelRoot").dockRight  =$("#CheckLeftAbilitySelect").IsSelected()
  
  if (FindDotaHudElement("AbilitySelectorPanelRoot").dockRight)
  {
        FindDotaHudElement("AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRootSide", true)
        FindDotaHudElement("AbilitySelectorPanel").SetHasClass("AbilitySelectorPanelSide", true)
        FindDotaHudElement("AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBodySide", true)

        FindDotaHudElement("AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRoot", false)
        FindDotaHudElement("AbilitySelectorPanel").SetHasClass("AbilitySelectorPanel", false)
        FindDotaHudElement("AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBody", false)
  }
  else
  {
        FindDotaHudElement("AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRootSide", false)
        FindDotaHudElement("AbilitySelectorPanel").SetHasClass("AbilitySelectorPanelSide", false)
        FindDotaHudElement("AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBodySide", false)
        
        FindDotaHudElement("AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRoot", true)
        FindDotaHudElement("AbilitySelectorPanel").SetHasClass("AbilitySelectorPanel", true)
        FindDotaHudElement("AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBody", true)
  }


  UpdateSetting();

}


function TogglEffectAbilitySelect(isLabel) 
{
    if (isLabel) 
    {
        $("#CheckEffectAbilitySelect").SetSelected( !$("#CheckEffectAbilitySelect").IsSelected() );
    }
    UpdateSetting();
}



//显示玩家匹配秘钥
function UpdatePlayerMatchKey(keys){

 
    if (!IsSecurityKeyValid(keys.security_key))
    {
         return
    }
     
    
    $('#MatchKeyTitle').text = $.Localize("#MatchKeyTitle");
    if ($.Language()!="schinese")
    {
       $('#MatchKeySetting').SetHasClass("Collapse",true)
    }
}


function InitSetting(){
   
   var banAbilities = CustomNetTables.GetTableValue("hero_info", "ban_abilities")
   if (banAbilities)
   {
        for(var index in banAbilities) 
        {
            var panelID = "ban_ability_"+index;
            var abilityName = banAbilities[index];
            var panel = $('#BanAbilityContainer').FindChildTraverse(panelID);
            if (panel == undefined && panel == null) {
                panel = $.CreatePanel("Panel", $('#BanAbilityContainer'), panelID);
                panel.BLoadLayoutSnippet("AbilityBannedAbility");     
            }
            panel.FindChildTraverse("AbilityBannedImage").abilityname = abilityName;
            panel.FindChildTraverse('AbilityBannedName').text = $.Localize("#DOTA_Tooltip_ability_" + abilityName);
        };  
    }

    var banHeroes = CustomNetTables.GetTableValue("hero_info", "hero_abilities")
    if (banHeroes)
    {
        for(var index in banHeroes) {
            var panelID = "ban_hero_"+index;
            var abilityName = banHeroes[index];
            var panel = $('#BanHeroContainer').FindChildTraverse(panelID);
            if (panel == undefined && panel == null) {
                panel = $.CreatePanel("Panel", $('#BanHeroContainer'), panelID);
                panel.BLoadLayoutSnippet("HeroBannedHero");     
            }
            panel.FindChildTraverse("HeroBannedImage").heroname = abilityName;
        };  
    }

   var settingData = CustomNetTables.GetTableValue("player_info", "setting_data_"+Players.GetLocalPlayer())
   if (settingData && !settingInited && FindDotaHudElement("BarrgeMainPanel") && FindDotaHudElement("AbilitySelectorPanelRoot"))
   {
       settingInited = true
       $("#CheckLeftAbilitySelect").SetSelected(String(settingData.settings_right_select)=="1");
       $("#CheckEffectAbilitySelect").SetSelected(String(settingData.settings_effect_select)=="0");
       FindDotaHudElement("AbilitySelectorPanelRoot").dockRight  =$("#CheckLeftAbilitySelect").IsSelected();   
    }
}

function UpdateSetting()
{
    var settingData ={}
    settingData.right_ability_selection = $("#CheckLeftAbilitySelect").IsSelected()?1:0;
    settingData.effect_ability_selection = $("#CheckEffectAbilitySelect").IsSelected()?0:1;
    GameEvents.SendCustomGameEventToServer("PlayerSettings", settingData);
    $("#SliderValue").text = ($("#BarrageOpacitySlider").value*100).toFixed(0) + "%";
}

(function() {
    GameEvents.Subscribe("RefreshAbilityOrder", RefreshAbilityOrder);
    //GameEvents.Subscribe("UpdatePlayerMatchKey", UpdatePlayerMatchKey);
    CustomNetTables.SubscribeNetTableListener("hero_info", InitSetting);
    CustomNetTables.SubscribeNetTableListener("player_info", InitSetting);
    GameEvents.Subscribe( "dota_inventory_changed", UpdateInventory );
    RefreshAbilityOrder();
    InitSetting();
    $("#BarrageOpacitySlider").value=100;
    $('#CheckAutoDuel').checked = true;
    $('#CheckEffectAbilitySelect').checked = true;
    $('#CheckAutoCreep').checked = false;
})();