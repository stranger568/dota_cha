function Confirm() 
{
    $("#PlayerLosePanel").AddClass("Hidden");
}

function ShowPlayerLose(keys) 
{
    $("#PlayerLosePanel").RemoveClass("Hidden");
    $("#RankInner2").text = keys.game_rank;
    $("#RankInner3").text = " / "+keys.valid_team;
    DotaMindScoreChanged();
}

function DotaMindScoreChanged() 
{
     var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );

     var player_data = CustomNetTables.GetTableValue("mmr_player", String(Players.GetLocalPlayer()));
     var player_data_main = CustomNetTables.GetTableValue("cha_server_data", String(Players.GetLocalPlayer()));

     if ( player_data && player_data_main)
     {

        $("#DotaMindLabel").text = $.Localize("#dota_mind_score");
     	$("#DotaMindInner1").text = parseInt(player_data.original_rating);
        $("#DotaMindInner3").text = parseInt(player_data.new_rating);

	    if (parseInt(player_data.original_rating) >= parseInt(player_data.new_rating))
	    {
	    	$("#DotaMindInner2").AddClass("Red")
	    	$("#DotaMindInner3").AddClass("Red")
	    }
	    if (parseInt(player_data.original_rating) < parseInt(player_data.new_rating))
	    {
	    	$("#DotaMindInner2").AddClass("Green")
	    	$("#DotaMindInner3").AddClass("Green")
	    }

        if (player_data_main.calibrating_games[7] > 0)
        {
           $("#DotaMindInner4").text = "( "+$.Localize("#dota_mind_calibrating")+" )";
        }
    }
}

(function () {
    GameEvents.Subscribe("ShowPlayerLose", ShowPlayerLose);
    CustomNetTables.SubscribeNetTableListener("mmr_player", DotaMindScoreChanged);
})();