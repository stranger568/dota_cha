GameEvents.Subscribe("loading_screen_event", CheckLoadingScreen )

var iIndexTip = 1; 
var LOADINGTIP_CHANGE_DELAY = 6;

var availableIndexTable = 
[
    1,2,3,4,5,6,7,8,9,10
]

function NextTip_Delay()
{
    NextTip();
    $.Schedule(LOADINGTIP_CHANGE_DELAY, NextTip_Delay);
}

function RandomTipIndex()
{
    var randomIndex = Math.floor(Math.random()*availableIndexTable.length);
    while(availableIndexTable[(randomIndex).toString()] == iIndexTip)
    {
        
        randomIndex = Math.floor(Math.random()*availableIndexTable.length);
    }
    return availableIndexTable[(randomIndex).toString()];
}

function NextTip()
{
    iIndexTip = RandomTipIndex();
    var sTip = "#LoadingTip_" + iIndexTip;
    $("#TipLabel").text=$.Localize(sTip);
}

function CheckLoadingScreen()
{
    $.Msg("Чекаю чекаю")
    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if (playerInfo)
    {
        if (playerInfo.player_connection_state == 2)
        {
            $.Msg("Уже был коннект")
            let start_screen = $.CreatePanelWithProperties("Movie", $("#video_bar"), "Movie", { src: "file://{resources}/videos/custom_game/loading_screen_1.webm", autoplay:"onload", repeat:"true", style:"width:100%;height:100%;" });

            $.Schedule( 9, function(){
                let start_screen = $.GetContextPanel().FindChildTraverse("Movie")
                $.Msg(start_screen)
                if ( start_screen )
                {
                    $.Msg("Ну найс уже закончилось все 2  2") 
                    start_screen.SetMovie('file://{resources}/videos/custom_game/loading_screen_2.webm')
                }  
            })
        } else {
            $.Schedule( 0.1, function(){
                CheckLoadingScreen()
            }) 
        }
    } else {
        $.Schedule( 0.1, function(){
            CheckLoadingScreen()
        })
    }
}

(function()
{
    iIndexTip = RandomTipIndex();
    var sTip = "#LoadingTip_" + iIndexTip;
    $("#TipLabel").text=$.Localize(sTip);
    NextTip_Delay();
})(); 

var hittestBlocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

if (hittestBlocker) {
    hittestBlocker.hittest = false;
    hittestBlocker.hittestchildren = false;
}