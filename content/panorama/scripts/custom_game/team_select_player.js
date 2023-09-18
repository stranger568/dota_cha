"use strict";

var rating = 0;

//--------------------------------------------------------------------------------------------------
// Handeler for when the unssigned players panel is clicked that causes the player to be reassigned
// to the unssigned players team
//--------------------------------------------------------------------------------------------------
function OnLeaveTeamPressed()
{
    Game.PlayerJoinTeam( 5 ); // 5 == unassigned ( DOTA_TEAM_NOTEAM )
}

function p(s){$.Msg(s);}
//--------------------------------------------------------------------------------------------------
// Update the contents of the player panel when the player information has been modified.
//--------------------------------------------------------------------------------------------------
function OnPlayerDetailsChanged()
{
    var playerId = $.GetContextPanel().GetAttributeInt("player_id", -1);
    var playerInfo = Game.GetPlayerInfo( playerId );
    if ( !playerInfo )
        return;

    $( "#PlayerName" ).text = playerInfo.player_name+GetEarlyLeaver(playerId);
    $( "#PlayerAvatar" ).steamid = playerInfo.player_steamid;
    $.GetContextPanel().SetHasClass( "player_is_local", playerInfo.player_is_local );
    $.GetContextPanel().SetHasClass( "player_has_host_privileges", playerInfo.player_has_host_privileges );

    var rank_info = CustomNetTables.GetTableValue("cha_server_data", String(playerId));

    if (rank_info != null) {
       
       if (rank_info && rank_info.mmr && rank_info.games)
       {    
            if (rank_info.calibrating_games[7] > 0)
            {
                $("#rank_image").style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + "rank0" + '.png")';
                $("#rank_image").style.backgroundSize = "100%" 
                $("#PlayTime").text = $.Localize("#dota_mind_calibrating")
                $("#EarlyLeave").text = (rank_info.games[7] || 0)
            } 
            else 
            {
                if ( (rank_info.rating_number_in_top != 0 && rank_info.rating_number_in_top != "0" && rank_info.rating_number_in_top <= 10) && (rank_info.mmr[7] || 2500) >= 5420)
               {
                      $("#rank_image").style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
               } else {
                      $("#rank_image").style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rank_info.mmr[7] || 2500) + '.png")';
               }
                $("#rank_image").style.backgroundSize = "100%" 
                $("#PlayTime").text = (rank_info.mmr[7] || $.Localize("#dota_mind_calibrating"))
                $("#EarlyLeave").text = (rank_info.games[7] || 0)
            }
            if (rank_info.rating_number_in_top != 0 && rank_info.rating_number_in_top != "0")
            {
                $("#rank_number").text = rank_info.rating_number_in_top
            }
       }

    } else {
        if (Game.GetState() == 2) {
            $.Schedule(0.3, OnPlayerDetailsChanged);
        }
    }
}


//--------------------------------------------------------------------------------------------------
// Entry point, update a player panel on creation and register for callbacks when the player details
// are changed.
//--------------------------------------------------------------------------------------------------
(function()
{
    OnPlayerDetailsChanged();
    $.RegisterForUnhandledEvent( "DOTAGame_PlayerDetailsChanged", OnPlayerDetailsChanged );
    CustomNetTables.SubscribeNetTableListener("player_rating_data", OnPlayerDetailsChanged);
    GameEvents.Subscribe('player_rating_data_arrived', OnPlayerDetailsChanged);
    GameEvents.Subscribe('player_stastics_data_arrived', OnPlayerDetailsChanged);
})();

function ShowRatingTooltip()
{
    $.DispatchEvent("DOTAShowTextTooltip", "#rating_tooltip_" + rating);
}

function HideRatingTooltip()
{
    $.DispatchEvent("DOTAHideTextTooltip");
}
