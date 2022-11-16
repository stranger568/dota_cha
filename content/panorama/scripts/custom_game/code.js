GameEvents.Subscribe( 'open_code_panel', OpenCodePanel );

function OpenCodePanel()
{
    var playerInfo = Game.GetLocalPlayerInfo();
    if (playerInfo) {
        if (playerInfo.player_has_host_privileges) 
        {
          $("#code_panel").style.visibility = "visible"
        }
    }
}

function CloseCodePanel()
{
    $("#code_panel").style.visibility = "collapse"
}

function CheckCode()
{
    let code = "Q7FgSDJS" // Кто увидел это, тот поел говняшку
    let password_type = $("#code_password").text
    GameEvents.SendCustomGameEventToServer( "StartGameCodeOk", {code : password_type} );  
    CloseCodePanel()
}