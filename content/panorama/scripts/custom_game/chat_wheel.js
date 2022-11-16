cooldown = 0
itemNumber = 0


function ToggleChatWheel()
{
    $("#page_chatwheel").ToggleClass("Hidden");
}

function CloseChatWheel()
{
    $("#page_chatwheel").AddClass("Hidden");
}

function CountDown () {

    cooldown = cooldown-1;

    if (cooldown>0){
      $("#chat_wheel_cooldown").text = $.Localize("#Cooldown")+cooldown;
      $.Schedule(1,CountDown);  
    } else {
      $("#chat_wheel_cooldown").AddClass("Hidden");
      $("#chat_wheel_cooldown_note").AddClass("Hidden");
    }

}


function ChatWheelDataChanged()
{

    var playerId = Game.GetLocalPlayerInfo().player_id;
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    steam_id = ConvertToSteamId32(steam_id);

    var playerData = GetPlayerEconInfoData(steam_id);
    if (playerData.length==0) return;

    var typeMap = CustomNetTables.GetTableValue("econ_type", "econ_type");

    for (var index in playerData) {
        if (playerData[index].name == undefined)
        {
            continue;
        }
        var itemName=playerData[index].name;
        if (typeMap[itemName]=="KillSound")
        {
            //如果已经有此条目，跳过不处理
            if ($("#ChatWheelLeft").FindChildTraverse(itemName))
            {
                continue;
            }
            itemNumber = itemNumber + 1
            $("#chat_wheel_empty_note").visible=false

            var newItemPanel = $.CreatePanel("Panel", $("#ChatWheelLeft"), itemName);
            newItemPanel.BLoadLayoutSnippet("ChatWheelItem");
            newItemPanel.FindChildTraverse("chat_wheel_label").text = $.Localize("#econ_" + itemName);

            (function(thisItemPanel,thisItemName){
            newItemPanel.FindChildTraverse("chat_wheel_item_main").SetPanelEvent("onactivate", 
               function(){
                 if (cooldown==0) 
                 {
                   cooldown = (37-itemNumber);
                   //最低CD 为12S
                   if (cooldown<12)
                   {
                       cooldown =12
                   }
                   GameEvents.SendCustomGameEventToServer('ActiveChatWheel', {playerId:playerId, itemName:thisItemName})
                   $("#chat_wheel_cooldown").text = $.Localize("#Cooldown")+cooldown;
                   $("#chat_wheel_cooldown").RemoveClass("Hidden");
                   $("#chat_wheel_cooldown_note").RemoveClass("Hidden");

                   if(typeof CountDown === "function") {
                     CountDown();
                   }
                 }
               });
            })(newItemPanel,itemName);
        }
    }
}


(function()
{
    CustomNetTables.SubscribeNetTableListener("econ_data", ChatWheelDataChanged);
    ChatWheelDataChanged();
})();