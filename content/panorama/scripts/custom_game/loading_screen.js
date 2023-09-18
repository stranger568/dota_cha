//GameEvents.Subscribe("loading_screen_event", CheckLoadingScreen )

//function CheckLoadingScreen()
//{
//    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
//    if (playerInfo)
//    {
//        if (playerInfo.player_connection_state == 2)
//        {
//            let start_screen = $.CreatePanel("Movie", $("#video_bar"), "Movie", { src: "file://{resources}/videos/custom_game/loading_screen_1.webm", autoplay:"onload", repeat:"true", style:"width:100%;height:100%;" });
//
//            $.Schedule( 9, function(){
//                let start_screen = $.GetContextPanel().FindChildTraverse("Movie")
//                if ( start_screen )
//                {
//                    start_screen.SetMovie('file://{resources}/videos/custom_game/loading_screen_2.webm')
//                }  
//            })
//        } else {
//            $.Schedule( 0.1, function(){
//                CheckLoadingScreen()
//            }) 
//        }
//    } else {
//        $.Schedule( 0.1, function(){
//            CheckLoadingScreen()
//        })
//    }
//}

(function()
{
    $.CreatePanel("Movie", $("#LoadingScreenCup"), "Movie", { src: "file://{resources}/videos/custom_game/loading_screen_3.webm", style: "width:100%;height:100%;", controls: "none", repeat: "true", hittest: "false", autoplay: "onload" });
})(); 

var hittestBlocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

if (hittestBlocker) {
    hittestBlocker.hittest = false;
    hittestBlocker.hittestchildren = false;
}

function FindDotaHudElement(id) {
    var hudRoot;
    for (panel = $.GetContextPanel(); panel != null; panel = panel.GetParent()) {
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}

let loading_chat = FindDotaHudElement('LoadingScreenChat')
if (loading_chat) 
{
    loading_chat.style.width = "410px"
}
