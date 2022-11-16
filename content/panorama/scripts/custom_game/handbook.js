var costMap={1:50,2:150,3:600,4:2400};
//买东西的锁
var buyingLock = false;
//当前过滤的宝藏ID
var currentTreasureIndex;

function CloseHandbook(){
    $( "#page_handbook" ).ToggleClass("Hidden");
}


//根据稀有度排序
function SortByRarity(a,b) {
   if (a.rarity < b.rarity)
    {
        return 1;
    } 
    else if ( a.rarity > b.rarity )
    {
       return -1; 
    } 
    else
    {
        if ( a.itemName < b.itemName )
        {
            return 1; 
        }
        else if ( a.itemName > b.itemName )
        {
            return -1;
        }
        else
        {
            return 0;
        }
    } 
}

//构建图鉴
function EconDataArrive(treasureIndex){

    var playerId = Game.GetLocalPlayerInfo().player_id;     //玩家ID
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    
    if(typeof ConvertToSteamId32 != "function") return;

    steam_id = ConvertToSteamId32(steam_id);

    var playerData = GetPlayerEconInfoData(steam_id);
    var moneyData = CustomNetTables.GetTableValue("econ_data", "money_"+steam_id);

    if (playerData === undefined) return;
    if (moneyData === undefined) return;
    
    var  fragmentValue=moneyData["fragment"]

    if ( $( "#LoadingPanel" ) == undefined) return;

    $( "#LoadingPanel" ).AddClass("Hidden");
    $( "#HandbookContainer" ).RemoveClass("Hidden");

    $("#InventoryBarrageTitle").AddClass("Hidden")
    $("#InventoryWearableTitle").AddClass("Hidden")
    $("#InventoryParticleTitle").AddClass("Hidden")
    $("#InventoryKillEffectTitle").AddClass("Hidden")
    $("#InventoryKillSoundTitle").AddClass("Hidden")
    $("#InventoryBlinkEffectTitle").AddClass("Hidden")
    $("#InventoryAttackEffectTitle").AddClass("Hidden")
    $("#InventoryCosmeticsAbilityTitle").AddClass("Hidden")
    $("#InventoryPetTitle").AddClass("Hidden")

    $("#InventoryBarragePanel").RemoveAndDeleteChildren();
    $("#InventoryWearablePanel").RemoveAndDeleteChildren();
    $("#InventoryParticlePanel").RemoveAndDeleteChildren();
    $("#InventoryKillEffectPanel").RemoveAndDeleteChildren();
    $("#InventoryKillSoundPanel").RemoveAndDeleteChildren();
    $("#InventoryBlinkEffectPanel").RemoveAndDeleteChildren();
    $("#InventoryAttackEffectPanel").RemoveAndDeleteChildren();
    $("#InventoryCosmeticsAbilityPanel").RemoveAndDeleteChildren();
    $("#InventoryPetPanel").RemoveAndDeleteChildren();

    $( "#FragmentStorageLabel" ).text=" X "+fragmentValue;

    let econRarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
    let econType = CustomNetTables.GetTableValue("econ_type", "econ_type");
    let econIndex = CustomNetTables.GetTableValue("econ_rarity", "econ_index");

    var typeNumberMap={}
    
    typeNumberMap["Wearable"]=0
    typeNumberMap["Barrage"]=0
    typeNumberMap["Particle"]=0
    typeNumberMap["KillEffect"]=0
    typeNumberMap["KillSound"]=0
    typeNumberMap["BlinkEffect"]=0
    typeNumberMap["AttackEffect"]=0
    typeNumberMap["CosmeticsAbility"]=0
    typeNumberMap["Pet"]=0

    //key itemName, value true
    //整理一下玩家目前拥有的饰品的Map
    var itemMap={}
    for (var index in playerData){
        var itemName=playerData[index].name;
        if ("true"!=playerData[index].demo)
        {
            itemMap[itemName]=true;
        }
    }

    let itemList = [];
    for (var itemName in econType){
        var node = {}
        node.itemName = itemName;
        node.rarity = econRarity[itemName];
        itemList.push(node);
    }
    itemList.sort(SortByRarity);


    for (var i in itemList){

        let itemName = itemList[i].itemName;

        //过滤宝藏
        if (treasureIndex && (typeof treasureIndex === "number") && treasureIndex!=parseInt(econIndex[itemName]))
        {
           continue;
        }
        
        var parentPanel= $("#Inventory"+econType[itemName]+"Panel")
        $("#Inventory"+econType[itemName]+"Title").RemoveClass("Hidden")

        var rarityLevel = econRarity[itemName]
        
        //如果面板已经存在，处理一下按钮即可
        if (parentPanel.FindChildTraverse(itemName))
        {   
            var itemPanel = parentPanel.FindChildTraverse(itemName)
            //限定饰品
            if (rarityLevel==0) {
                itemPanel.FindChildTraverse("button_limited").visible = true;
                itemPanel.FindChildTraverse("button_buy").visible = false;
                itemPanel.FindChildTraverse("button_already").visible = false;
                itemPanel.FindChildTraverse("button_not_enough").visible = false; 
            } else {
                if (itemMap[itemName])
                {
                   itemPanel.FindChildTraverse("button_limited").visible = false;
                   itemPanel.FindChildTraverse("button_buy").visible = false;
                   itemPanel.FindChildTraverse("button_already").visible = true; 
                   itemPanel.FindChildTraverse("button_not_enough").visible = false; 
                }  
                else 
                {
                   if (fragmentValue>=costMap[rarityLevel])
                   {
                       itemPanel.FindChildTraverse("button_limited").visible = false;
                       itemPanel.FindChildTraverse("button_buy").visible = true;
                       itemPanel.FindChildTraverse("button_already").visible = false; 
                       itemPanel.FindChildTraverse("button_not_enough").visible = false; 
                       itemPanel.FindChildTraverse("button_buy_label").SetDialogVariableInt("fragment_need",costMap[rarityLevel]);
                   } 
                   else
                   {
                       itemPanel.FindChildTraverse("button_limited").visible = false;
                       itemPanel.FindChildTraverse("button_buy").visible = false;
                       itemPanel.FindChildTraverse("button_already").visible = false; 
                       itemPanel.FindChildTraverse("button_not_enough").visible = true;
                       itemPanel.FindChildTraverse("button_not_enough").SetDialogVariableInt("fragment_need",costMap[rarityLevel]);
                   }
                }
            }
            itemPanel.FindChildTraverse("button_limited").enabled = false;
            itemPanel.FindChildTraverse("button_not_enough").enabled = false;
            itemPanel.FindChildTraverse("button_already").enabled = false; 
            continue;
        }

        typeNumberMap[econType[itemName]] = typeNumberMap[econType[itemName]]+1
        
        var newItemPanel = $.CreatePanel("Panel", parentPanel, itemName);
        newItemPanel.BLoadLayoutSnippet("CollectionItem");

        var itemIndex= econIndex[itemName]
        
        if (itemIndex==1){
            newItemPanel.FindChildTraverse("collection_item_index").text = $.Localize("#treasure_1");
        }
        if (itemIndex==2){
            newItemPanel.FindChildTraverse("collection_item_index").text = $.Localize("#treasure_2");
        }
        if (itemIndex==3){
            newItemPanel.FindChildTraverse("collection_item_index").text = $.Localize("#treasure_3");
        }
        if (itemIndex==4){
            newItemPanel.FindChildTraverse("collection_item_index").text = $.Localize("#treasure_4");
        }

        if (rarityLevel==0) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_limited");
            newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Limited")
            newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleLimited")
        }
        
        if (rarityLevel==1) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_normal");
        }
        if (rarityLevel==2) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("rarity_rare");
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
        
        //限定饰品
        if (rarityLevel==0){
            newItemPanel.FindChildTraverse("button_limited").visible = true;
            newItemPanel.FindChildTraverse("button_buy").visible = false;
            newItemPanel.FindChildTraverse("button_already").visible = false;
            newItemPanel.FindChildTraverse("button_not_enough").visible = false; 
        }else{
            if (itemMap[itemName])
            {
               newItemPanel.FindChildTraverse("button_limited").visible = false;
               newItemPanel.FindChildTraverse("button_buy").visible = false;
               newItemPanel.FindChildTraverse("button_already").visible = true; 
               newItemPanel.FindChildTraverse("button_not_enough").visible = false; 
            }  
            else 
            {
               if (fragmentValue>=costMap[rarityLevel])
               {
                   newItemPanel.FindChildTraverse("button_limited").visible = false;
                   newItemPanel.FindChildTraverse("button_buy").visible = true;
                   newItemPanel.FindChildTraverse("button_already").visible = false; 
                   newItemPanel.FindChildTraverse("button_not_enough").visible = false; 
                   newItemPanel.FindChildTraverse("button_buy_label").SetDialogVariableInt("fragment_need",costMap[rarityLevel]);
               } 
               else
               {
                   newItemPanel.FindChildTraverse("button_limited").visible = false;
                   newItemPanel.FindChildTraverse("button_buy").visible = false;
                   newItemPanel.FindChildTraverse("button_already").visible = false; 
                   newItemPanel.FindChildTraverse("button_not_enough").visible = true;
                   newItemPanel.FindChildTraverse("button_not_enough").SetDialogVariableInt("fragment_need",costMap[rarityLevel]);
               }
            }
            newItemPanel.FindChildTraverse("button_limited").enabled = false;
            newItemPanel.FindChildTraverse("button_not_enough").enabled = false;
            newItemPanel.FindChildTraverse("button_already").enabled = false; 
        }

        (function(thisItemPanel,thisItemName){
          newItemPanel.FindChildTraverse("button_buy").SetPanelEvent("onactivate", 
           function(){               
	         ShowNewItemPanel(thisItemName);
          });
        })(newItemPanel,itemName);
    }
    

    //调整面板的高度，适应滚动条
    for(var key in typeNumberMap){
        if (typeNumberMap[key]>0)
        {
            var panelHeight = 280* Math.ceil(typeNumberMap[key]/7);
            $("#Inventory"+key+"Panel").style.height=(panelHeight+"px;");
        }
        else
        {
            $("#Inventory"+key+"Panel").style.height="0px";
        }
    }


}

//设置稀有度
function SetPanelRarity(rarityLevel,panel) {


    panel.FindChildTraverse("lottery_item_rarity").RemoveClass("Rarity_Rare")
    panel.FindChildTraverse("lottery_item_title_panel").RemoveClass("TitleRare")
    
    panel.FindChildTraverse("lottery_item_rarity").RemoveClass("Rarity_Mythical")
    panel.FindChildTraverse("lottery_item_title_panel").RemoveClass("TitleMythical")

    panel.FindChildTraverse("lottery_item_rarity").RemoveClass("Rarity_Immortal")
    panel.FindChildTraverse("lottery_item_title_panel").RemoveClass("TitleImmortal")


    if (rarityLevel==1) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("#rarity_normal");
    }

   if (rarityLevel==2) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("#rarity_rare");
        panel.FindChildTraverse("lottery_item_rarity").AddClass("Rarity_Rare")
        panel.FindChildTraverse("lottery_item_title_panel").AddClass("TitleRare")
    }
    if (rarityLevel==3) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("#rarity_mythical");
        panel.FindChildTraverse("lottery_item_rarity").AddClass("Rarity_Mythical")
        panel.FindChildTraverse("lottery_item_title_panel").AddClass("TitleMythical")
    }
    if (rarityLevel==4) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("#rarity_immortal");
        panel.FindChildTraverse("lottery_item_rarity").AddClass("Rarity_Immortal")
        panel.FindChildTraverse("lottery_item_title_panel").AddClass("TitleImmortal")
    }

}



function ShowNewItemPanel(itemName) {

    if (buyingLock)
    {
        return;
    }
    
    //设置通告版
    var econ_rarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
    var targetLevel=econ_rarity[itemName]  
    var notifyPanel = $("#new_item_notify_container")
    notifyPanel.FindChildTraverse("lottery_new_item_title").text = $.Localize("#econ_"+itemName);
    notifyPanel.FindChildTraverse("lottery_new_item_image").SetImage("file://{resources}/images/custom_game/econ/"+itemName+".png");
    SetPanelRarity(targetLevel,notifyPanel)
    $("#new_item_notify_container").itemName = itemName
    $("#new_item_confirm_label").visible=true;
    $("#new_item_notify_label").visible=false;
    $("#NewItemNotifyOperate").visible=true;
    $("#NewItemNotifyConfirm").visible=false;
    $("#new_item_confirm_label").SetDialogVariableInt("fragment_need",costMap[targetLevel]);
    $("#new_item_notify").RemoveClass("Hidden")
}


function ConfirmBuy() {
    if (buyingLock)
    {
        return;
    }

    buyingLock=true;

    $("#buy_item_confirm_label").AddClass("Hidden");
    $("#buy_item_confirm_label_loading").RemoveClass("Hidden");

    $("#buy_item_cancel_label").AddClass("Hidden");
    $("#buy_item_cancel_label_loading").RemoveClass("Hidden");

    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if ( !playerInfo )
        return;
    var playerId = playerInfo.player_id;

    GameEvents.SendCustomGameEventToServer('BuyItemWithFragment', {
        playerId:playerId, itemName:$("#new_item_notify_container").itemName
    })
}


function BuyItemResultArrive(data) {

    var playerId = Game.GetLocalPlayerInfo().player_id;     //玩家ID
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    steam_id = ConvertToSteamId32(steam_id);
    //购买成功
    if (data.type=="0")
    {
        var econ_rarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
        var targetLevel=econ_rarity[data.item_name]  

        $("#new_item_confirm_label").visible=false;
        $("#new_item_notify_label").visible=true;

        $("#NewItemNotifyOperate").visible=false;
        $("#NewItemNotifyConfirm").visible=true;

        $("#buy_item_confirm_label").RemoveClass("Hidden");
        $("#buy_item_confirm_label_loading").AddClass("Hidden");

        $("#buy_item_cancel_label").RemoveClass("Hidden");
        $("#buy_item_cancel_label_loading").AddClass("Hidden");

        var econData=GetPlayerEconInfoData(steam_id);
        var length=Object.keys(econData).length;

        var newData={}
        newData.name=data.item_name
        newData.equip="false"
        econData[length+1]=newData;

        var moneyValue= parseInt(CustomNetTables.GetTableValue("econ_data", "money_"+steam_id)["money"])
        var fragmentValue= parseInt(CustomNetTables.GetTableValue("econ_data", "money_"+steam_id)["fragment"])-costMap[targetLevel]
        GameEvents.SendCustomGameEventToServer ("EconDataRefresh",{playerId:playerId,econData:econData,moneyValue:moneyValue,fragmentValue:fragmentValue}); //通知前台更新NetTable
    } else {
        var econData=GetPlayerEconInfoData(steam_id);
        var moneyValue= parseInt(CustomNetTables.GetTableValue("econ_data", "money_"+steam_id)["money"])
        var fragmentValue= parseInt(CustomNetTables.GetTableValue("econ_data", "money_"+steam_id)["fragment"])
        GameEvents.SendCustomGameEventToServer ("EconDataRefresh",{playerId:playerId,econData:econData,moneyValue:moneyValue,fragmentValue:fragmentValue}); //通知前台更新NetTable
        $("#buy_item_confirm_label").RemoveClass("Hidden");
        $("#buy_item_confirm_label_loading").AddClass("Hidden");
        $("#buy_item_cancel_label").RemoveClass("Hidden");
        $("#buy_item_cancel_label_loading").AddClass("Hidden");
        $("#new_item_notify").AddClass("Hidden");
    }

    //解锁
    buyingLock=false;
}

function HideNotify() {
    $("#new_item_notify").AddClass("Hidden")
}


function ScrollInventory(type)
{      
    $("#Inventory"+type+"Title").ScrollParentToMakePanelFit( 1, false );

}

function FilterIndex(treasureIndex)
{   
    //如果重复选中，取消选中
    if (currentTreasureIndex && currentTreasureIndex==treasureIndex)
    {
      EconDataArrive();
      currentTreasureIndex = null
      $("#Treasure_"+treasureIndex).checked = false;
    }
    else
    {
      EconDataArrive(treasureIndex);  
      currentTreasureIndex=treasureIndex
    }
}

(function()
{   
    CustomNetTables.SubscribeNetTableListener("econ_data", EconDataArrive);
    GameEvents.Subscribe( "BuyItemResultArrive", BuyItemResultArrive ); //持久化服务器对于购买处理完毕
    EconDataArrive()
})();
