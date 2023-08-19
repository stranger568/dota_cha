//此类危险技能删除可能会闪退
var unremovableAbilities = {
    "monkey_king_wukongs_command": true,
    "rubick_empty1" : true,
    "rubick_empty2" : true,
};

var unremovableAbilitiesBonus = {
    "monkey_king_wukongs_command": true,
    "morphling_waveform"    : true,
    "huskar_life_break" : true,
    "tusk_snowball" : true,
    "ember_spirit_fire_remnant" : true,
    "rattletrap_hookshot"   : true,
    "faceless_void_time_walk"   : true,
    "faceless_void_time_walk_reverse"   : true,
    "batrider_sticky_napalm"    : true,
    "pudge_meat_hook"   : true,
    "marci_grapple"   : true,
    "dazzle_good_juju_lua"   : true,
    "dazzle_bad_juju"   : true,
    "slark_depth_shroud" : true,
    "phoenix_supernova" : true,
    "rubick_spell_steal_custom" : true,
    "rubick_empty1" : true,
    "rubick_empty2" : true,
    "oracle_fortunes_end" : true,
};

var AbilitiesFullReact = 
{
    "lycan_shapeshift_custom" : true,
    "sven_gods_strength_custom" : true,
    "wisp_overcharge_custom" : true,
    "tiny_grow" : true,
    "undying_flesh_golem_custom" : true,
    "bloodseeker_bloodrage_custom" : true,
    "venomancer_poison_nova_custom" : true,
    "venomancer_noxious_plague" : true,
    "broodmother_insatiable_hunger_custom" : true,
    "meepo_ransack_custom" : true,
    "custom_terrorblade_metamorphosis" : true,
    "lina_laguna_blade_custom" : true,
    "rubick_spell_steal_custom" : true,
    "lich_chain_frost_custom" : true,
    "lion_finger_of_death_custom" : true,
    "obsidian_destroyer_arcane_orb" : true,
    "life_stealer_feast"    : true,
    "pugna_life_drain_custom" :true,
};

var AbilitiesFullReactPurple = 
{
    "drow_ranger_frost_arrows_custom" : true,
    "enigma_midnight_pulse_custom" : true,
    "sandking_caustic_finale_lua":true,
    "winter_wyvern_arctic_burn":true,
    "phoenix_sun_ray":true,
    "zuus_arc_lightning_custom":true,
    "witch_doctor_maledict":true,
    "necrolyte_heartstopper_aura_lua":true,
    "jakiro_liquid_fire_lua":true,
    "terrorblade_reflection_lua":true,
    "abyssal_underlord_firestorm_custom":true,
    "elder_titan_earth_splitter":true,
};

//调整技能选择页面位置
function AdjustPosition()
{
    if ($("#AbilitySelectorPanelRoot").dockRight)
    {
        $("#AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRootSide", true)
        $("#AbilitySelectorPanel").SetHasClass("AbilitySelectorPanelSide", true)
        $("#AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBodySide", true)

        $("#AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRoot", false)
        $("#AbilitySelectorPanel").SetHasClass("AbilitySelectorPanel", false)
        $("#AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBody", false)
    }
    else
    {
        $("#AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRootSide", false)
        $("#AbilitySelectorPanel").SetHasClass("AbilitySelectorPanelSide", false)
        $("#AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBodySide", false)
        
        $("#AbilitySelectorPanelRoot").SetHasClass("AbilitySelectorPanelRoot", true)
        $("#AbilitySelectorPanel").SetHasClass("AbilitySelectorPanel", true)
        $("#AbilitySelectorAbilityBody").SetHasClass("AbilitySelectorAbilityBody", true)
    }
    
    if (FindDotaHudElement("AbilitySelectorPanelRoot").dockWidth) 
    {
        $("#AbilitySelectorPanelRoot").SetHasClass("SelectorMini", true)
    }
    else {
        $("#AbilitySelectorPanelRoot").SetHasClass("SelectorMini", false)
    }
}

//判断两个队列是否值相等
function IsDataListSame(dataList1,dataList2) {
    
    if (dataList1.length!=dataList2.length) 
    {
         return false
    }

    for (var n in dataList1) 
    {
       if (dataList1[n]==undefined||dataList2[n]==undefined||dataList1[n].ability_name!=dataList2[n].ability_name)
       {
          return false
       }
    }

    return true
} 
 
   
function ShowRandomAbilitySelection(keys) 
{
    var parent = $("#AbilitySelectorAbilityBody");

    if (parent==undefined)
    {
        return
    }

    parent.ui_secret = keys.ui_secret;

    if (parent.dataList)
    {
        if (IsDataListSame(parent.dataList,keys.data_list))
        {  
            $("#AbilitySelectorPanelRoot").SetHasClass("Show", true);
            $("#AbilitySelectorTitle").text= $.Localize("#AbilitySelectorTitle_1") +keys.ability_number+ $.Localize("#AbilitySelectorTitle_2");
            $("#AbilitySelection_Close").text = $.Localize("#AbilitySelection_Close");
            $("#AbilitySelector_CloseButton").SetPanelEvent("onmouseover", function() {
              $.DispatchEvent( "DOTAShowTextTooltip", $("#AbilitySelector_CloseButton"), $.Localize("#AbilitySelection_Close_Description"));
            });
            $("#AbilitySelector_CloseButton").SetPanelEvent("onactivate", function() {
                CloseAbilitySelect();
            });
            return
        }
    }
 
    parent.dataList = keys.data_list;

    AdjustPosition()

    $("#AbilitySelectorPanelRoot").SetHasClass("Show", true);

    var dataList = keys.data_list

    for (var n in dataList) 
    {
        var abilityName = dataList[n].ability_name;
        var panelID = "ability_"+n;
        var panel = parent.FindChildTraverse(panelID);
        if (panel == undefined && panel == null) {
            panel = $.CreatePanel("Panel", parent, panelID);
            panel.BLoadLayoutSnippet("AbilitySelectorAbility");     
        }
        panel.FindChildTraverse("AbilityImage").abilityname = abilityName;
        panel.FindChildTraverse('AbilityName').text = $.Localize("#DOTA_Tooltip_ability_" + abilityName);
        SetAbilityPanelEvent(panel,abilityName);

        var settingData = CustomNetTables.GetTableValue("player_info", "setting_data_"+Players.GetLocalPlayer())
        if (settingData && String(settingData.settings_effect_select) == "0")
        {
            if (AbilitiesFullReact[abilityName])
            {
                panel.FindChildTraverse("EffectReact").visible = true
            } else {
                panel.FindChildTraverse("EffectReact").visible = false
            }
            if (AbilitiesFullReactPurple[abilityName])
            {
                panel.FindChildTraverse("EffectReactPurple").visible = true
            } else {
                panel.FindChildTraverse("EffectReactPurple").visible = false
            }
        } else {
            panel.FindChildTraverse("EffectReact").visible = false
        }

        panel.FindChildTraverse("LinkedAbilityPlusIcon").SetHasClass("LinkedAbilityCollapse", true);
        panel.FindChildTraverse("LinkedAbilityImage_1").SetHasClass("LinkedAbilityCollapse", true);
        panel.FindChildTraverse("LinkedAbilityImage_2").SetHasClass("LinkedAbilityCollapse", true);
        
        if (dataList[n].linked_abilities!=undefined)
        {   
            var linkedAbilityIndex=1
            panel.FindChildTraverse("LinkedAbilityPlusIcon").SetHasClass("LinkedAbilityCollapse", false);
            for (var m in dataList[n].linked_abilities) {
               if (linkedAbilityIndex<=2)
               {
                 panel.FindChildTraverse("LinkedAbilityImage_"+linkedAbilityIndex).abilityname = dataList[n].linked_abilities[m];
                 panel.FindChildTraverse("LinkedAbilityImage_"+linkedAbilityIndex).SetHasClass("LinkedAbilityCollapse", false);
                 linkedAbilityIndex=linkedAbilityIndex+1
               }
            }
        } 
    }

    UpdateAbilityMask()

    $("#AbilitySelectorTitle").text= $.Localize("#AbilitySelectorTitle_1") +keys.ability_number+ $.Localize("#AbilitySelectorTitle_2");

    //修改关闭按钮
    $("#AbilitySelection_Close").text = $.Localize("#AbilitySelection_Close");
    $("#AbilitySelector_CloseButton").SetPanelEvent("onmouseover", function() {
      $.DispatchEvent( "DOTAShowTextTooltip", $("#AbilitySelector_CloseButton"), $.Localize("#AbilitySelection_Close_Description"));
    });
    $("#AbilitySelector_CloseButton").SetPanelEvent("onactivate", function() {
        CloseAbilitySelect();
    });

}

function SetAbilityPanelEvent(panel,abilityName) {
   
    var parent = $("#AbilitySelectorAbilityBody");

   panel.SetPanelEvent("onactivate", function()
   {
        if (!$("#AbilitySelectorPanelRoot").BHasClass("Show"))
        {
            return
        }
        GameEvents.SendCustomGameEventToServer("AbilitySelected", {
            ability_name : abilityName,
            player_id : Players.GetLocalPlayer(),
            spell_book_selected: false,
            ui_secret: parent.ui_secret
        });
        $("#AbilitySelectorPanelRoot").SetHasClass("Show", false);
   });

   panel.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", panel, abilityName);
   });
   panel.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
   })    
}




 
function ShowSpellBookAbilitySelection(keys) {

        if (!IsSecurityKeyValid(keys.security_key))
        {
             return
        }

        var parent = $("#AbilitySelectorAbilityBody");
        parent.ui_secret = keys.ui_secret
        
        AdjustPosition()

        $("#AbilitySelectorAbilityBody").RemoveAndDeleteChildren()
        $("#AbilitySelectorPanelRoot").SetHasClass("Show", true);
        $("#AbilitySelectorTitle").text = $.Localize("#record_ability")
        var playerHeroIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
        var abilityIndex = 0;
        for (var i = 0; i <= 32; i++) {
            var ability = Entities.GetAbility(playerHeroIndex, i);
            var abilityName = Abilities.GetAbilityName(ability);
            if( (IsValidAbility(ability) || "wisp_spirits_lua"==abilityName) && unremovableAbilitiesBonus[abilityName]==undefined)
            {
                abilityIndex = abilityIndex + 1;
                var panelID = "ability_"+abilityIndex;
                var panel = parent.FindChildTraverse(panelID);
                if (panel == undefined && panel == null) {
                    panel = $.CreatePanel("Panel", parent, panelID);
                    panel.BLoadLayoutSnippet("AbilitySelectorAbility");     
                }
                panel.FindChildTraverse("AbilityImage").abilityname = abilityName;
                panel.FindChildTraverse('AbilityName').text = $.Localize("#DOTA_Tooltip_ability_" + abilityName);
                if (AbilitiesFullReact[abilityName])
                {
                    panel.FindChildTraverse("EffectReact").visible = true
                } else {
                    panel.FindChildTraverse("EffectReact").visible = false
                }
                if (AbilitiesFullReactPurple[abilityName])
                {
                    panel.FindChildTraverse("EffectReactPurple").visible = true
                } else {
                    panel.FindChildTraverse("EffectReactPurple").visible = false
                }
                SetSpellBookAbilityPanelEvent(panel,abilityName);
            }
        }
        //修改关闭按钮
        $("#AbilitySelection_Close").text = $.Localize("#AbilitySpellSelection_Close_Label");
        $("#AbilitySelector_CloseButton").SetPanelEvent("onmouseover", function() {
          $.DispatchEvent( "DOTAShowTextTooltip", $("#AbilitySelector_CloseButton"), $.Localize("#AbilitySpellSelection_Close_Description"));
        });
        $("#AbilitySelector_CloseButton").SetPanelEvent("onactivate", function() {
            GameEvents.SendCustomGameEventToServer("SpellBookAbilitySelected", {
                player_id: Players.GetLocalPlayer(),
                ui_secret: $("#AbilitySelectorAbilityBody").ui_secret
            });
            $("#AbilitySelectorPanelRoot").SetHasClass("Show", false);
        });
}


function SetSpellBookAbilityPanelEvent(panel,abilityName) {
   
   panel.SetPanelEvent("onactivate", function(){
        GameEvents.SendCustomGameEventToServer("SpellBookAbilitySelected", {
            ability_name : abilityName,
            player_id : Players.GetLocalPlayer(),
            ui_secret: $("#AbilitySelectorAbilityBody").ui_secret
        });
        $("#AbilitySelectorPanelRoot").SetHasClass("Show", false);
   });

   panel.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", panel, abilityName);
   });
   panel.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
   })    
}



function ShowRelearnBookAbilitySelection(keys) {

        if (!IsSecurityKeyValid(keys.security_key))
        {
             return
        }

        AdjustPosition()

        //遍历 玩家技能
        var parent = $("#AbilitySelectorAbilityBody");
        parent.ui_secret = keys.ui_secret;

        $("#AbilitySelectorAbilityBody").RemoveAndDeleteChildren()
        $("#AbilitySelectorPanelRoot").SetHasClass("Show", true);
        $("#AbilitySelectorTitle").text = $.Localize("#unlearn_ability")
        var playerHeroIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
        var abilityIndex = 0;
        for (var i = 0; i <= 32; i++) {
            var ability = Entities.GetAbility(playerHeroIndex, i);
            var abilityName = Abilities.GetAbilityName(ability);
            if ( (IsValidAbility(ability) || "wisp_spirits_lua"==abilityName) && unremovableAbilities[abilityName]==undefined && IsAbilityUnlocked(abilityName))
            {
                abilityIndex = abilityIndex + 1;
                var panelID = "ability_"+abilityIndex;
                var panel = parent.FindChildTraverse(panelID);
                if (panel == undefined && panel == null) {
                    panel = $.CreatePanel("Panel", parent, panelID);
                    panel.BLoadLayoutSnippet("AbilitySelectorAbility");     
                }
                panel.FindChildTraverse("AbilityImage").abilityname = abilityName;
                panel.FindChildTraverse('AbilityName').text = $.Localize("#DOTA_Tooltip_ability_" + abilityName);
                SetRelearnBookAbilityPanelEvent(panel,abilityName,keys.omniscient_book);
            }
        }
        //修改关闭按钮
        $("#AbilitySelection_Close").text = $.Localize("#AbilityRelearnCloseSelection_Label");
        $("#AbilitySelector_CloseButton").SetPanelEvent("onmouseover", function() {
          $.DispatchEvent( "DOTAShowTextTooltip", $("#AbilitySelector_CloseButton"), $.Localize("#AbilityRelearnSelection_Description")  );
        });
        //没有选择就关闭，返还重修书 
        $("#AbilitySelector_CloseButton").SetPanelEvent("onactivate", function() {
            GameEvents.SendCustomGameEventToServer("RelearnBookAbilitySelected", {
              player_id : Players.GetLocalPlayer(),
              ui_secret: $("#AbilitySelectorAbilityBody").ui_secret,
              omniscient_book: keys.omniscient_book
            });
            $("#AbilitySelectorPanelRoot").SetHasClass("Show", false);
        });
}



function SetRelearnBookAbilityPanelEvent(panel,abilityName,omniscient_book) {
   
   panel.SetPanelEvent("onactivate", function(){
        GameEvents.SendCustomGameEventToServer("RelearnBookAbilitySelected", {
            ability_name : abilityName,
            player_id : Players.GetLocalPlayer(),
            ui_secret: $("#AbilitySelectorAbilityBody").ui_secret,
            omniscient_book: omniscient_book
        });
        $("#AbilitySelectorPanelRoot").SetHasClass("Show", false);
        $("#AbilitySelectorTitle").text = $.Localize("#record_ability")
   });

   panel.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", panel, abilityName);
   });
   panel.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
   })    
}




function CloseAbilitySelect() {
    
    var parent = $("#AbilitySelectorAbilityBody");

    GameEvents.SendCustomGameEventToServer("AbilitySelected", {
        player_id : Players.GetLocalPlayer(),
        ui_secret: parent.ui_secret
    });
    $("#AbilitySelectorPanelRoot").SetHasClass("Show", false);

}

function UpdateAbilityMask() {
    
    var parent = $("#AbilitySelectorAbilityBody");
    
    //设置持续时间0.8秒的蒙版
    if (parent.cooldown == undefined) {
        parent.cooldown = 0.8
        for (var i = 0; i <=10; i++) {
          var panelID = "ability_"+i;
          var panel = parent.FindChildTraverse(panelID);
          if (panel!=undefined)
          {
            panel.enabled = false;
            panel.FindChildTraverse("CooldownOverlay").RemoveClass("Hidden");
            $("#AbilitySelector_CloseButton").enabled = false;
          }
        }
    }

    var angle = parent.cooldown/0.8 * 360;
    parent.cooldown = parent.cooldown-0.04
     
    //倒计时结束，放开按钮
    if (parent.cooldown<=0)
    {
      parent.cooldown = undefined
      for (var i = 0; i <=10; i++) 
      {
        var panelID = "ability_"+i;
        var panel = parent.FindChildTraverse(panelID);
        if (panel!=undefined)
        {
            panel.enabled = true;
            panel.FindChildTraverse("CooldownOverlay").AddClass("Hidden");
            $("#AbilitySelector_CloseButton").enabled = true;
        }
      }

    } else {

      for (var i = 0; i <=10; i++) 
      {
        var panelID = "ability_"+i;
        var panel = parent.FindChildTraverse(panelID);
        if (panel!=undefined)
        {
          panel.FindChildTraverse("CooldownOverlay").style.clip="radial( 50.0% 50.0%, 0.0deg, -"+angle+"deg)";
        }               
      }
      $.Schedule(0.04, UpdateAbilityMask)

    } 
}

function HideAbilitySelect() 
{
    
    $("#AbilitySelectorPanel").ToggleClass("Hide")
    $("#AbilitySelector_CloseButton").ToggleClass("Hide")
    
}

function IsAbilityUnlocked(ability_name)
{
    if (GameUI.CustomUIConfig().abilities_locked == null)
    {
        return true
    }
    if (GameUI.CustomUIConfig().abilities_locked[ability_name] == null)
    {
        return true
    }
    if (GameUI.CustomUIConfig().abilities_locked[ability_name] == false)
    {
        return true
    }
    if (GameUI.CustomUIConfig().abilities_locked[ability_name] == true)
    {
        return false
    }
}

(function() 
{
    GameEvents.Subscribe("ShowRandomAbilitySelection", ShowRandomAbilitySelection);
    GameEvents.Subscribe("ShowSpellBookAbilitySelection", ShowSpellBookAbilitySelection);
    GameEvents.Subscribe("ShowRelearnBookAbilitySelection", ShowRelearnBookAbilitySelection);
    GameEvents.SendCustomGameEventToServer("ClientReconnected", {});
})();