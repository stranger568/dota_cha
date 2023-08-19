
"use strict";

var g_ScoreboardHandle = null;

function SwitchCheckboxState(id, base_state=false) {
	let checkbox = $("#" + id)
	if (checkbox.selected == undefined) {checkbox.selected = base_state}
	checkbox.selected = !checkbox.selected
	//$.Msg("state:", checkbox.selected)
	checkbox.SetSelected(checkbox.selected)
	return checkbox.selected
}

function SetFlyoutScoreboardVisible( bVisible )
{
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", bVisible );
	if ( bVisible )
	{
		ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, true );
	}
	else
	{
		ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, false );
	}
}

function ToggleAbilities() {
	let state = SwitchCheckboxState("ToggleAbilities")
	$.GetContextPanel().SetHasClass("abilities_toggled", state)
}

function ToggleItems() {
	let state = SwitchCheckboxState("ToggleItems")
	$.GetContextPanel().SetHasClass("items_toggled", state)
}

function _ToggleMuteImage(panel, state) {
	if (state) {
		panel.style.backgroundImage = `url("s2r://panorama/images/custom_game/button_audio_off_psd.vtex");`
	}
	else {
		panel.style.backgroundImage = `url("s2r://panorama/images/custom_game/button_audio_on_psd.vtex");`
	}
}

function ToggleAllMute() {
	let mute_all_button = $("#MuteAllButton")
	if (mute_all_button.state == undefined) {
		mute_all_button.state = true
	}
	else {
		mute_all_button.state = !mute_all_button.state
	}
	let muted = new Set()
	for (var i=0; i<=24;i++) {
		if (Players.IsValidPlayerID(i) && Game.GetLocalPlayerID() != i) {
			muted.add(i)
			Game.SetPlayerMuted( i, mute_all_button.state )
			GameEvents.SendCustomGameEventToServer("set_mute_player", { disable: mute_all_button.state, toPlayerId: i } )
		}
	}
	let team_container = $("#TeamsContainer")
	let rows = team_container.FindChildrenWithClassTraverse("PlayerRow")
	rows.forEach(row=>{
		let player_id = row.GetAttributeInt( "player_id", -1 );
		if (muted.has(player_id)) {
			let mute_button = row.FindChildTraverse("MuteButton")
			_ToggleMuteImage(mute_button, mute_all_button.state)
		}
	})
}

function ToggleMuteSounds()
{
    $("#MuteVoicesButton").SetHasClass("muted_chat_wheel", !$("#MuteVoicesButton").BHasClass("muted_chat_wheel"))
    GameUI.CustomUIConfig().MuteSoundsChatWheel = $("#MuteVoicesButton").BHasClass("muted_chat_wheel")
}

(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_player.xml",
	};
	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );
	

	SetFlyoutScoreboardVisible( false );

	$.Schedule(5, function() {
		ToggleAbilities()
		ToggleItems()
	})
	
	
	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
