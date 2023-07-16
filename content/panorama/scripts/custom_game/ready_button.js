function UpdateReadyButton(data){
	if (!Players.IsSpectator(Players.GetLocalPlayer())) {
		$("#ReadyButtonNew").visible = data.visible
	} else {
		$("#ReadyButtonNew").visible = false
	}
}

function PlayerReady() {
	GameEvents.SendCustomGameEventToServer("PlayerReady", {});
}


(function()
{
   GameEvents.Subscribe('UpdateReadyButton', UpdateReadyButton);
})();

