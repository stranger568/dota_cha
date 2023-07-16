GameEvents.Subscribe("event_neutral_select", NeutralRewardStart)

function NeutralRewardStart(data)
{
    $("#NeutralItem1").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem2").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem3").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem4").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem5").SetPanelEvent("onactivate", function() {} );

    if (data.roshan)
    {
        $("#NeutralItem2").visible = false
        $("#NeutralItem3").visible = false
        $("#NeutralItem4").visible = false
        $("#NeutralItem5").visible = false
    } else {
        $("#NeutralItem2").visible = true
        $("#NeutralItem3").visible = true
        $("#NeutralItem4").visible = true
        $("#NeutralItem5").visible = true
    }

	$("#NeutralPanelReward").style.opacity = "1"

    for (var i = 1; i <= Object.keys(data.neutral_items).length; i++) 
    {
        $("#neutral_item_"+i).itemname = data.neutral_items[i]
        $("#ItemName_"+i).text = $.Localize("#DOTA_Tooltip_Ability_" + data.neutral_items[i])
    }

	$("#NeutralItem1").SetPanelEvent("onactivate", function() {
		SelectNeutralItem(1, data.roshan, data.tier)
	} );

	$("#NeutralItem2").SetPanelEvent("onactivate", function() {
		SelectNeutralItem(2, data.roshan, data.tier)
	} );

	$("#NeutralItem3").SetPanelEvent("onactivate", function() {
		SelectNeutralItem(3, data.roshan, data.tier)
	} );

	$("#NeutralItem4").SetPanelEvent("onactivate", function() {
		SelectNeutralItem(4, data.roshan, data.tier)
	} );

	$("#NeutralItem5").SetPanelEvent("onactivate", function() {
		SelectNeutralItem(5, data.roshan, data.tier)
	});

    $("#ButtonReturn").SetPanelEvent("onactivate", function() {
		SelectReturn(data.roshan, data.tier)
	});
}

function MouseOver(panel, text) 
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text)
    });
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });
}

function SelectNeutralItem(id, roshan, tier)
{
	$("#NeutralItem1").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem2").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem3").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem4").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem5").SetPanelEvent("onactivate", function() {} );
    $("#ButtonReturn").SetPanelEvent("onactivate", function() {} );
	$("#NeutralPanelReward").style.opacity = "0"
    if (roshan)
    {
        GameEvents.SendCustomGameEventToServer( "SelectNeutralReward", {choose : id, roshan : 1, tier : tier} );
    } else {
        GameEvents.SendCustomGameEventToServer( "SelectNeutralReward", {choose : id, tier : tier} );
    }
}

function SelectReturn(roshan, tier)
{
    $("#NeutralItem1").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem2").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem3").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem4").SetPanelEvent("onactivate", function() {} );
	$("#NeutralItem5").SetPanelEvent("onactivate", function() {} );
    $("#ButtonReturn").SetPanelEvent("onactivate", function() {} );
	$("#NeutralPanelReward").style.opacity = "0"
    if (roshan)
    {
        GameEvents.SendCustomGameEventToServer( "SelectNeutralRewardReturn", {roshan : 1, tier : tier} );
    } else {
        GameEvents.SendCustomGameEventToServer( "SelectNeutralRewardReturn", {tier : tier} );
    }
}