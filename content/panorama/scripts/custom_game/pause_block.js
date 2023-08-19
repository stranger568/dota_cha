pause_owner_check()

var InitPlayersAll = false

function pause_owner_check() {

    let owner_table = CustomNetTables.GetTableValue("pause_owner", "owner")
    if (owner_table) {

        if (typeof owner_table.owner !== 'undefined') {
            if (Game.GetPlayerInfo(owner_table.owner) && Game.GetPlayerInfo(owner_table.owner).player_steamid) {
                $("#PauseAvatar").steamid = Game.GetPlayerInfo(owner_table.owner).player_steamid
                $("#PauseName").steamid = Game.GetPlayerInfo(owner_table.owner).player_steamid
            }
        }
    }

    if (Game.IsGamePaused()) 
    {
        $("#PauseOwner").style.visibility = "visible"
        if ((Game.GetMapInfo().map_display_name) == "tournament_1x8")
        {
            $("#PlayersChecked").style.visibility = "visible"
            $("#ButtonPlayerReady").style.visibility = "visible"
        }
        if (InitPlayersAll == false)
        {
            InitPlayers()
        }
    }
    else 
    {
        $("#PauseOwner").style.visibility = "collapse"
        if ((Game.GetMapInfo().map_display_name) == "tournament_1x8")
        {
            $("#PlayersChecked").style.visibility = "collapse"
            $("#ButtonPlayerReady").style.visibility = "collapse"
        }
        $("#PlayersChecked").RemoveAndDeleteChildren()
        InitPlayersAll = false
    }

    $.Schedule(0.1, pause_owner_check)
}

GameEvents.Subscribe( 'player_set_ready_pause', player_set_ready_pause );
function player_set_ready_pause(data)
{
    let player_id = data.id
    let player_panel = $("#PlayersChecked").FindChildTraverse("player_"+data.id)
    if (player_panel)
    {
        player_panel.SetHasClass("player_ready", true)
    }
}

function PlayerReadyPause()
{
    GameEvents.SendCustomGameEventToServer("player_set_ready_pause_lua", {});
}

function InitPlayers()
{
    InitPlayersAll = true
    var teamsList = [];
    var players = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		teamsList.push( Game.GetTeamDetails( teamId ) );
	}
    for ( var i = 0; i < teamsList.length; ++i )
	{
		let teamId = teamsList[i].team_id;
        let teamPlayers = Game.GetPlayerIDsOnTeam( teamId )
        for ( var d = 0; d < teamPlayers.length; ++d )
	    {
            players.push( teamPlayers[d] );
        }
	}
    for ( var i = 0; i < players.length; ++i )
	{
        var player_panel = $.CreatePanel("Panel", $("#PlayersChecked"), "player_" + players[i]);
        player_panel.AddClass("Player");
        let playerInfo = Game.GetPlayerInfo(players[i]);
        if (playerInfo) 
        {
            $.CreatePanelWithProperties("DOTAAvatarImage", player_panel, "avatar_panel", { style: "width:100%;height:100%;vertical-align:center;", steamid: playerInfo.player_steamid });
        }
    }
}
