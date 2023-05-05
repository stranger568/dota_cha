var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "DamageAbilities";

function DamageToggle() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                first_time = true;
                CheckBattlePass();
                $("#DamageBlockWithButton").AddClass("damage_close");
            }  
            if ($("#DamageBlockWithButton").BHasClass("damage_close")) {
                $("#DamageBlockWithButton").RemoveClass("damage_close");
            }
            $("#DamageBlockWithButton").AddClass("damage_open");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#DamageBlockWithButton").BHasClass("damage_open")) {
                $("#DamageBlockWithButton").RemoveClass("damage_open");
            }
            $("#DamageBlockWithButton").AddClass("damage_close");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    }
}

function DamageToggleButton(tab, button) {
	$("#DamageAbilities").style.visibility = "collapse";
	$("#DamageAbilitiesIncome").style.visibility = "collapse";
	$("#" + tab).style.visibility = "visible";

	for (var i = 0; i < $("#MenuButtons").GetChildCount(); i++) {
		$("#MenuButtons").GetChild(i).RemoveClass("button_select")
	}

	current_sub_tab = tab;

	$("#" + button).AddClass("button_select")
}




function CheckBattlePass()
{
	var player_information_battlepass = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()));
	if (player_information_battlepass) 
	{
		if (player_information_battlepass.pass_level_2_days > 0 || player_information_battlepass.pass_level_3_days > 0)
		{
			UpdateAbilitiesHudDamage()
			UpdateAbilitiesHudDamageIncoming()
		} else {
			$( "#DamageAbilities" ).RemoveAndDeleteChildren()
			var panel_book = $.CreatePanel( "Panel", $( "#DamageAbilities" ), "BattlePassTier2Only_panel" );
			var BattlePassTier2Only = $.CreatePanel( "Label", $( "#DamageAbilities" ), "BattlePassTier2Only" );
			BattlePassTier2Only.text = $.Localize("#BattlePassTier2Only")
			$( "#DamageAbilitiesIncome" ).RemoveAndDeleteChildren()
			var panel_book = $.CreatePanel( "Panel", $( "#DamageAbilitiesIncome" ), "BattlePassTier2Only_panel" );
			var BattlePassTier2Only = $.CreatePanel( "Label", $( "#DamageAbilitiesIncome" ), "BattlePassTier2Only" );
			BattlePassTier2Only.text = $.Localize("#BattlePassTier2Only")
			$( "#DamageRoundHistoryHeadLabel" ).style.visibility = "collapse"
		}
	}
}

GameEvents.Subscribe( "remove_damage_units", remove_damage_units );

function remove_damage_units() {
	var player_information_battlepass = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()));
	if (player_information_battlepass) 
	{
		if (player_information_battlepass.pass_level_2_days > 0 || player_information_battlepass.pass_level_3_days > 0)
		{
			$( "#DamageAbilities" ).RemoveAndDeleteChildren()
			$( "#DamageAbilitiesIncome" ).RemoveAndDeleteChildren()
		}
	}
}

function UpdateAbilitiesHudDamage() {
	var maximum_damage = 0
	var table_units = CustomNetTables.GetTableValue("spell_damage", Players.GetLocalPlayer());
	if (table_units) {
		if (Object.keys(table_units).length > 0) {
			for (var i = 1; i <= Object.keys(table_units).length; i++) {
				maximum_damage = maximum_damage + table_units[i].damage
			}
		}
	}

	if (current_sub_tab == "DamageAbilities")
	{
		$("#DamageRoundHistoryHeadLabel").text = $.Localize("#DamageRoundHistoryHeadLabel_maximum") + ": " + maximum_damage.toFixed(0)
	}

	if (table_units) {
		if (Object.keys(table_units).length > 0) {
			for (var i = 1; i <= Object.keys(table_units).length; i++) {
				if ($( "#DamageAbilities" ).FindChildTraverse("unit_damage_" + table_units[i].name)) {
					var percent = (table_units[i].damage * 100) / (maximum_damage || 1)
					if ($( "#DamageAbilities" ).GetChild(i-1))
					{
						$( "#DamageAbilities" ).MoveChildAfter( $( "#DamageAbilities" ).FindChildTraverse("unit_damage_" + table_units[i].name), $( "#DamageAbilities" ).GetChild(i-1) );
					}
					$( "#DamageAbilities" ).FindChildTraverse("unit_damage_" + table_units[i].name).FindChildTraverse("DamageLine").style['width'] = percent.toFixed(0) +'%';
					var damage_text = CheckStringDamage(table_units[i].damage) + " " + "( " + percent.toFixed(0) + "% )"
					$( "#DamageAbilities" ).FindChildTraverse("unit_damage_" + table_units[i].name).FindChildTraverse("DamageUnitLabel").text = String(damage_text)
				} else {
					CreateNewAbility(table_units[i], $( "#DamageAbilities" ))
				}
			}
		}
	}
	$.Schedule(1/144, UpdateAbilitiesHudDamage)
}

function UpdateAbilitiesHudDamageIncoming() {
	var maximum_damage = 0
	var table_units = CustomNetTables.GetTableValue("spell_damage_income", Players.GetLocalPlayer());
	if (table_units) {
		if (Object.keys(table_units).length > 0) {
			for (var i = 1; i <= Object.keys(table_units).length; i++) {
				maximum_damage = maximum_damage + table_units[i].damage
			}
		}
	}

	if (current_sub_tab == "DamageAbilitiesIncome")
	{
		$("#DamageRoundHistoryHeadLabel").text = $.Localize("#DamageRoundHistoryHeadLabel_maximum") + ": " + maximum_damage.toFixed(0)
	}

	if (table_units) {
		if (Object.keys(table_units).length > 0) {
			for (var i = 1; i <= Object.keys(table_units).length; i++) {
				if ($( "#DamageAbilitiesIncome" ).FindChildTraverse("unit_damage_" + table_units[i].name)) {
					var percent = (table_units[i].damage * 100) / (maximum_damage || 1)
					if ($( "#DamageAbilitiesIncome" ).GetChild(i-1))
					{
						$( "#DamageAbilitiesIncome" ).MoveChildAfter( $( "#DamageAbilitiesIncome" ).FindChildTraverse("unit_damage_" + table_units[i].name), $( "#DamageAbilitiesIncome" ).GetChild(i-1) );
					}
					$( "#DamageAbilitiesIncome" ).FindChildTraverse("unit_damage_" + table_units[i].name).FindChildTraverse("DamageLine").style['width'] = percent.toFixed(0) +'%';
					var damage_text = CheckStringDamage(table_units[i].damage) + " " + "( " + percent.toFixed(0) + "% )"
					$( "#DamageAbilitiesIncome" ).FindChildTraverse("unit_damage_" + table_units[i].name).FindChildTraverse("DamageUnitLabel").text = String(damage_text)
				} else {
					CreateNewAbility(table_units[i], $( "#DamageAbilitiesIncome" ))
				}
			}
		}
	}
	$.Schedule(1/144, UpdateAbilitiesHudDamageIncoming)
}

function compareFunc( a, b)
{
	if ( a < b )
	{
		return 1; // [ B, A ]
	}
	else if ( a > b )
	{
		return -1; // [ A, B ]
	}
	else
	{
		return 0;
	}
};

function CreateNewAbility(table, general) {
	var UnitDamagePanel = $.CreatePanel( "Panel", general, "unit_damage_"+table.name );
	UnitDamagePanel.AddClass( "UnitDamagePanel" );


	if (table.type == "item" )
	{
		var UnitPortrait = $.CreatePanel("DOTAItemImage", UnitDamagePanel, "UnitPortrait");
    	UnitPortrait.itemname = table.name;
    	UnitPortrait.style.height = "22px"
	} else if (table.type == "ability" ) {
		var UnitPortrait = $.CreatePanel("DOTAAbilityImage", UnitDamagePanel, "UnitPortrait");
    	UnitPortrait.abilityname = table.name;
    } else if (table.type == "unit" ) {
    	var UnitPortrait = $.CreatePanel("Panel", UnitDamagePanel, "UnitPortrait");
    	let creep_name = table.name
    	creep_name = creep_name.replace("_1", '')
    	creep_name = creep_name.replace("_2", '')
    	creep_name = creep_name.replace("_3", '')
    	creep_name = creep_name.replace("_4", '')
    	creep_name = creep_name.replace("1", '')
    	creep_name = creep_name.replace("2", '')
    	creep_name = creep_name.replace("3", '')
    	creep_name = creep_name.replace("4", '')
    	UnitPortrait.style.backgroundImage = 'url("s2r://panorama/images/heroes/' + creep_name + '_png.vtex")';
    	UnitPortrait.style.backgroundSize = "100%";
    	UnitPortrait.style.height = "22px"
	} else {
		var UnitPortrait = $.CreatePanel("DOTAAbilityImage", UnitDamagePanel, "UnitPortrait");
    	UnitPortrait.abilityname = "action_attack";
    	UnitPortrait.SetImage( "s2r://panorama/images/spellicons/action_attack_png.vtex" )
	}

	var UnitDamageInfoPanel = $.CreatePanel( "Panel", UnitDamagePanel, "" );
	UnitDamageInfoPanel.AddClass( "UnitDamageInfoPanel" );

	var DamageUnitLabel = $.CreatePanel( "Label", UnitDamageInfoPanel, "DamageUnitLabel" );
	DamageUnitLabel.text = CheckStringDamage(table.damage)

	var DamageLineBG = $.CreatePanel( "Panel", UnitDamageInfoPanel, "DamageLineBG" );

	var DamageLineBG2 = $.CreatePanel( "Panel", DamageLineBG, "DamageLineBG2" );

	var DamageLineStart = $.CreatePanel( "Panel", DamageLineBG2, "" );
	DamageLineStart.AddClass( "DamageLineStart" );

	var DamageLine = $.CreatePanel( "Panel", DamageLineBG2, "DamageLine" );

	if (table.damage_type == 1 )
	{
		DamageLineStart.style.backgroundColor = "#ae2f28"
		DamageLine.style.backgroundColor = "#ae2f28"
	} else if (table.damage_type == 2 ) {
		DamageLineStart.style.backgroundColor = "#5b93d1"
		DamageLine.style.backgroundColor = "#5b93d1"
	} else if (table.damage_type == 4 ) {
		DamageLineStart.style.backgroundColor = "#d8ae53"
		DamageLine.style.backgroundColor = "#d8ae53"
	} else {
		DamageLineStart.style.backgroundColor = "white"
		DamageLine.style.backgroundColor = "white"
	}
}


function CheckStringDamage(damage) {
	if (damage > 999999) {
		return String((damage/1000000).toFixed(2)) + "M"
	} else if (damage > 999) {
		return String((damage/1000).toFixed(2)) + "K"
	} else {
		return damage.toFixed(0)
	}
}
