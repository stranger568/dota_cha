var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#LeaderboardButton")) {
    if (parentHUDElements.FindChildTraverse("LeaderboardButton")){
        $("#LeaderboardButton").DeleteAsync( 0 );
    } else {
        $("#LeaderboardButton").SetParent(parentHUDElements);
    }
}

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

function ToggleLeaderboard() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                first_time = true;
                GetPlayersDataSolo()
                GetPlayersDataDuo()
                GetPlayersDataPve()
                $("#LeaderboardWindow").AddClass("sethidden");
            }  
            if ($("#LeaderboardWindow").BHasClass("sethidden")) {
                $("#LeaderboardWindow").RemoveClass("sethidden");
            }
            $("#LeaderboardWindow").AddClass("setvisible");
            $("#LeaderboardWindow").style.visibility = "visible"
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#LeaderboardWindow").BHasClass("setvisible")) {
                $("#LeaderboardWindow").RemoveClass("setvisible");
            }
            $("#LeaderboardWindow").AddClass("sethidden");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
                $("#LeaderboardWindow").style.visibility = "collapse"
            })
        }
    }
}

function GetPlayersDataSolo()
{
    var topmmr = CustomNetTables.GetTableValue("cha_server_data", "top_rating_solo_200");
    if (!topmmr)
    {
        $.Schedule(1, GetPlayersDataSolo)
        return;
    } 
    for (var i = 1; i <= 200; i++)
    {
        if (topmmr[i] != null)
        {
            CreatePlayer(topmmr[i].steamid, topmmr[i].rating, $("#PlayersTableSolo"), i, false)
        }    
    }
}

function GetPlayersDataDuo()
{
    var topmmr = CustomNetTables.GetTableValue("cha_server_data", "top_rating_duo_200");
    if (!topmmr)
    {
        $.Schedule(1, GetPlayersDataDuo)
        return;
    } 
    for (var i = 1; i <= 200; i++)
    {
        if (topmmr[i] != null)
        {
            CreatePlayer(topmmr[i].steamid, topmmr[i].rating, $("#PlayersTableDuo"), i, false)
        }    
    }
}

function GetPlayersDataPve()
{
    var topmmr = CustomNetTables.GetTableValue("cha_server_data", "top_rating_pve_200");
    if (!topmmr)
    {
        $.Schedule(1, GetPlayersDataPve)
        return;
    } 
    for (var i = 1; i <= 200; i++)
    {
        if (topmmr[i] != null)
        {
            CreatePlayer(topmmr[i].steamid, topmmr[i].rating, $("#PlayersTablePVE"), i, true)
        }    
    }
}

function CreatePlayer(id, rating, panel, number, time) 
{

    var Line = $.CreatePanel("Panel", panel, "");
    Line.AddClass("LinePlayer");

    var RankPanel = $.CreatePanel("Panel", Line, "");
    RankPanel.AddClass("RankPanel");

    var RankImage = $.CreatePanel("Panel", RankPanel, "");
    RankImage.AddClass("RankImage");
    if (number <= 10 && rating >= 5420)
    {
        RankImage.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
    } else {
        RankImage.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(rating) + '.png")';
    }
    RankImage.style.backgroundSize = "100%" 

    var Rank_number = $.CreatePanel("Label", RankImage, "");
    Rank_number.AddClass("Rank_number");
    Rank_number.text = number

    var AvatarNicknamePanel = $.CreatePanel("Panel", Line, "");
    AvatarNicknamePanel.AddClass("AvatarNicknamePanel");

    $.CreatePanelWithProperties("DOTAAvatarImage", AvatarNicknamePanel, "AvatarLeaderboard", { style: "width:40px;height:40px;vertical-align:center;", accountid: id });
    $.CreatePanelWithProperties("DOTAUserName", AvatarNicknamePanel, "AvatarLeaderboard", { style: "vertical-align:center;margin-left:25px;height: 20px;", accountid: id });

    var Rating = $.CreatePanel("Label", Line, "");
    Rating.AddClass("RatingLabel");
    if (time)
    {   
        var hours = Math.floor(rating / 60 / 60);
        var minutes = Math.floor(rating / 60) - (hours * 60);
        var seconds = rating % 60;
        var formatted = hours + ':' + minutes + ':' + seconds;
        Rating.text = String(formatted)
        RankImage.style.backgroundImage = 'url("file://{images}/custom_game/ranks/' + GetImageRank(10000) + '.png")';
    } else {
        Rating.text = String(rating)
    }
}