function UpdateReadyButton(data){
	if (!Players.IsSpectator(Players.GetLocalPlayer())) {
		$("#ReadyButton").visible = data.visible
	} else {
		$("#ReadyButton").visible = false
	}
}

function PlayerReady() {
	GameEvents.SendCustomGameEventToServer("PlayerReady", {});
}


(function()
{
   GameEvents.Subscribe('UpdateReadyButton', UpdateReadyButton);
})();

