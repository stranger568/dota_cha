function ToggleTaunt()
{
    $("#page_taunt").ToggleClass("Hidden");
}

function CloseTaunt()
{
    $("#page_taunt").AddClass("Hidden");
}

function TauntCountDown () {

    if ($("#page_taunt").tauntCooldown>0){

      $("#taunt_cooldown").text = $.Localize("#Cooldown")+$("#page_taunt").tauntCooldown;
      $("#taunt_cooldown").RemoveClass("Hidden");
      $("#taunt_cooldown_note").RemoveClass("Hidden");
      $("#taunt_cooldown").text = $.Localize("#Cooldown")+Math.ceil($("#page_taunt").tauntCooldown);
      $("#page_taunt").tauntCooldown = $("#page_taunt").tauntCooldown-0.2;

    } else {
      $("#taunt_cooldown").AddClass("Hidden");
      $("#taunt_cooldown_note").AddClass("Hidden");
    }

    $.Schedule(0.2,TauntCountDown);  

}


function TauntDataChanged()
{
    var playerId = Game.GetLocalPlayerInfo().player_id;
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    steam_id = ConvertToSteamId32(steam_id);

    var playerData = GetPlayerEconInfoData(steam_id);

    if (playerData === undefined) return;

    var typeMap = CustomNetTables.GetTableValue("econ_type", "econ_type");
    var econRarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");

    var tauntItemNumber =0 

    for (var index in playerData) {
        if (playerData[index].name == undefined)
        {
            continue;
        }
        var itemName=playerData[index].name;
        if (typeMap[itemName]=="KillEffect")
        {   
            tauntItemNumber = tauntItemNumber + 1
            //如果已经有此条目，跳过不处理
            if ($("#taunt_left").FindChildTraverse(itemName))
            {
                continue;
            }
            $("#taunt_empty_note").visible =false

            var newItemPanel = $.CreatePanel("Panel", $("#taunt_left"), itemName);
            newItemPanel.BLoadLayoutSnippet("CollectionItem");

            var rarityLevel = econRarity[itemName]
        
            if (rarityLevel==1) {
                newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_normal");
            }
            if (rarityLevel==2) {
                newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_rare");
                newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Rare")
                newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleRare")
            }
            if (rarityLevel==3) {
                newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_mythical");
                newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Mythical")
                newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleMythical")
            }
            if (rarityLevel==4) {
                newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_immortal");
                newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Immortal")
                newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleImmortal")
            }

            newItemPanel.FindChildTraverse("collection_item_title").text = $.Localize("#econ_" + itemName);
            newItemPanel.FindChildTraverse("collection_item_image").SetImage("file://{resources}/images/custom_game/econ/" + itemName + ".png");
            
            (function(thisItemPanel,thisItemName){
            newItemPanel.SetPanelEvent("onactivate", 
               function(){
                 if ($("#page_taunt").tauntCooldown<=0) 
                 {
                   $("#page_taunt").tauntCooldown = $("#page_taunt").maxTauntCooldown
                   GameEvents.SendCustomGameEventToServer('ActiveTaunt', {playerId:playerId, itemName:thisItemName})
                   $("#taunt_cooldown").text = $.Localize("#Cooldown")+$("#page_taunt").tauntCooldown;
                   $("#taunt_cooldown").RemoveClass("Hidden");
                   $("#taunt_cooldown_note").RemoveClass("Hidden");
                 }
               });
            })(newItemPanel,itemName);
        }
    }
    $("#page_taunt").maxTauntCooldown = (80-tauntItemNumber);
    //CD最短10秒
    if ($("#page_taunt").maxTauntCooldown<8)
    {
       $("#page_taunt").maxTauntCooldown = 8
    }

}


(function()
{
    CustomNetTables.SubscribeNetTableListener("econ_data", TauntDataChanged);
    TauntDataChanged()
    $("#page_taunt").tauntCooldown = 0
    TauntCountDown();
})();

const name_bind = "TauntButton" + Math.floor(Math.random() * 99999999);
Game.AddCommand("+" + name_bind, ToggleTaunt, "", 0);
Game.CreateCustomKeyBind("F7", "+" + name_bind);