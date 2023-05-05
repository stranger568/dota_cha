
function ShowActorPanel(keys){

    
    if (!IsSecurityKeyValid(keys.security_key))
    {
         return
    }

    $("#ActorPanel").actor_ui_secret = keys.actor_ui_secret;
    
    var target_player_id =  keys.target_player_id
    var targetPlayerInfo = Game.GetPlayerInfo( target_player_id );

    //$("#ActorPanelTopLabel").SetDialogVariableInt("time",keys.time);

    if (targetPlayerInfo!=undefined) 
    {
       $("#ActorPlayerImage").steamid = targetPlayerInfo.player_steamid; 
       $("#ActorHeroImage").SetImage( "file://{images}/heroes/" + targetPlayerInfo.player_selected_hero + ".png" );   
       $("#PlayerName").text = targetPlayerInfo.player_name;
       $("#HeroName").text =  $.Localize("#hero_level")+" "+targetPlayerInfo.player_level +" "+ $.Localize("#"+targetPlayerInfo.player_selected_hero);
    }
    $("#ActorPanel").target_player_id = target_player_id
    
    if (keys.time==0)
    {
       $("#ActorAcceptButton").enabled=false
    }

    $("#ActorPanel").RemoveClass("Hidden")
}


function Confirm(){
     var target_player_id = $("#ActorPanel").target_player_id

     GameEvents.SendCustomGameEventToServer("ConfirmActor", {
            player_id:Game.GetLocalPlayerInfo().player_id,
            target_player_id: target_player_id,
            actor_ui_secret: $("#ActorPanel").actor_ui_secret
     });
     $("#ActorPanel").AddClass("Hidden")
}



function Cancle(){
     $("#ActorPanel").AddClass("Hidden");
}



(function() {
    GameEvents.Subscribe("ShowActorPanel", ShowActorPanel);
})();