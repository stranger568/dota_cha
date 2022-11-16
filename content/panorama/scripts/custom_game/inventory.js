const createPaymentRequest = CreateEventRequestCreator("CreatePayment");

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
        if ( a.name < b.name )
        {
            return 1; 
        }
        else if ( a.name > b.name )
        {
            return -1;
        }
        else
        {
            return 0;
        }
    } 
}


function SubmitTaobaoCode(){
    
    $("#SubmitTaobaoCodeButtonLabel").AddClass("Hidden")
    $("#SubmitTaobaoCodeButtonLoading").RemoveClass("Hidden")
    $("#TaobaoCodeNotify").AddClass("Hidden")
    $("#SubmitTaobaoCodeButton").enabled=false;

    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if ( !playerInfo )
        return;
    var playerId = playerInfo.player_id;

    var code= $("#TaobaoCodeEntry").text;

    GameEvents.SendCustomGameEventToServer('SubmitTaobaoCode', {
        playerId:playerId, code:code
    })
}


function OnChangeEquip(itemName,isEquip) {
    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if ( !playerInfo )
        return;
    var playerId = playerInfo.player_id;
    
    var econ_type = CustomNetTables.GetTableValue("econ_type", "econ_type");
    var typeMap=econ_type;

    GameEvents.SendCustomGameEventToServer('ChangeEquip', {
        playerId:playerId, itemName:itemName, isEquip:isEquip, type:typeMap[itemName]
    })
}

function ShowPaymentContainer(){

   $("#PaymentContainer").RemoveClass("Hidden")
   $("#TaobaoCodeNotify").AddClass("Hidden")
}

function ClosePaymentContainer(){

   $("#PaymentContainer").AddClass("Hidden")
}

function EconDataArrive(){

    var playerId = Game.GetLocalPlayerInfo().player_id;     //玩家ID
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    
    if(typeof ConvertToSteamId32 != "function") return;

    steam_id = ConvertToSteamId32(steam_id);

    var playerData = GetPlayerEconInfoData(steam_id);
    var moneyData = CustomNetTables.GetTableValue("econ_data", "money_"+steam_id);

    if (playerData === undefined) return;
    if (moneyData === undefined) return;
    
    var  moneyValue=moneyData["money"]

    if ( $( "#LoadingPanel" ) == undefined) return;

    var econ_type = CustomNetTables.GetTableValue("econ_type", "econ_type");
    var typeMap=econ_type;

    
    $( "#LoadingPanel" ).AddClass("Hidden");
    $( "#InventoryRightMain" ).RemoveClass("Hidden");

    $("#InventoryBarrageTitle").AddClass("Hidden")
    $("#InventoryWearableTitle").AddClass("Hidden")
    $("#InventoryParticleTitle").AddClass("Hidden")
    $("#InventoryPetTitle").AddClass("Hidden")
    $("#InventoryKillEffectTitle").AddClass("Hidden")
    $("#InventoryKillSoundTitle").AddClass("Hidden")
    $("#InventoryBlinkEffectTitle").AddClass("Hidden")
    $("#InventoryAttackEffectTitle").AddClass("Hidden")
    $("#InventoryCosmeticsAbilityTitle").AddClass("Hidden")

    
    $("#DrawButton1").enabled=false;
    $("#DrawButton2").enabled=false;
    $("#DrawButton3").enabled=false;
    $("#DrawButton4").enabled=false;

    $( "#MoneyStorageLabel" ).text=" X "+moneyValue;
    
    if (moneyValue>=50)
    {
        $("#DrawButton1").enabled=true;
        $("#DrawButton2").enabled=true;
        $("#DrawButton3").enabled=true;
        $("#DrawButton4").enabled=true;
    }

    data=playerData

    var econRarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
    
    var typeNumberMap={}
    
    typeNumberMap["Wearable"]=0
    typeNumberMap["Barrage"]=0
    typeNumberMap["Particle"]=0
    typeNumberMap["Pet"]=0
    typeNumberMap["KillEffect"]=0
    typeNumberMap["KillSound"]=0
    typeNumberMap["BlinkEffect"]=0
    typeNumberMap["AttackEffect"]=0
    typeNumberMap["CosmeticsAbility"]=0

    let itemList = [];
    for (var index in data){
        var node = {}
        node.rarity = econRarity[data[index].name];
        node.name = data[index].name;
        node.equip = data[index].equip;
        node.demo =  data[index].demo;
        itemList.push(node);
    }
    itemList.sort(SortByRarity);

    for (var index in itemList){
        
        var itemName=itemList[index].name;
        
        //过滤没有name的数据
        if (itemList[index].name == undefined)
        {
            continue;
        }

        var isEquip = (itemList[index].equip=="true")


        var parentPanel= $("#Inventory"+typeMap[itemName]+"Panel")

        $("#Inventory"+typeMap[itemName]+"Title").RemoveClass("Hidden")

        typeNumberMap[typeMap[itemName]] = typeNumberMap[typeMap[itemName]]+1

        //如果已经有此物品，跳过不处理
        if (parentPanel.FindChildTraverse(itemName))
        {   
            //是不是Demo饰品处理一下
            if (itemList[index].demo=="true")
            {
                parentPanel.FindChildTraverse(itemName).FindChildTraverse("collection_item_demo").RemoveClass("Hidden")
            } else {
                parentPanel.FindChildTraverse(itemName).FindChildTraverse("collection_item_demo").AddClass("Hidden")
            }
            continue;
        }

        var newItemPanel = $.CreatePanel("Panel", parentPanel, itemName);
        newItemPanel.BLoadLayoutSnippet("CollectionItem");

        
        var rarityLevel = econRarity[itemName]

        if (rarityLevel==0) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("#rarity_limited");
            newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Limited")
            newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleLimited")
        }
        
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

        if (itemList[index].demo=="true")
        {
            newItemPanel.FindChildTraverse("collection_item_demo").RemoveClass("Hidden")
        } else {
            newItemPanel.FindChildTraverse("collection_item_demo").AddClass("Hidden")
        }


        newItemPanel.FindChildTraverse("collection_item_title").text = $.Localize("#econ_" + itemName);  
        newItemPanel.FindChildTraverse("collection_item_image").SetImage("file://{resources}/images/custom_game/econ/" + itemName + ".png");


        if (isEquip){
            newItemPanel.FindChildTraverse("button_equip").visible = false;
        }else{
            newItemPanel.FindChildTraverse("button_remove").visible = false;
        }
        //注意此处写法，不会导致局部变量歧义
        (function(thisItemPanel,thisItemName){
        newItemPanel.FindChildTraverse("button_equip").SetPanelEvent("onactivate", 
           function(){
                
                if (typeMap[thisItemName]=="Particle" || typeMap[thisItemName]=="Pet" || typeMap[thisItemName]=="KillEffect" || typeMap[thisItemName]=="KillSound" || typeMap[thisItemName]=="Barrage" || typeMap[thisItemName]=="BlinkEffect" || typeMap[thisItemName]=="AttackEffect" || typeMap[thisItemName]=="CosmeticsAbility")
                {
                    for (var i = thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonEquip").length - 1; i >= 0; i--) {
                        thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonEquip")[i].visible=true;
                    }                
                    for (var i = thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonRemove").length - 1; i >= 0; i--) {
                        thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonRemove")[i].visible=false;
                    }
                }

	            thisItemPanel.FindChildTraverse("button_equip").visible=false;
	            thisItemPanel.FindChildTraverse("button_remove").visible=true;

                if (typeMap[thisItemName]=="Wearable") {
                    //正在穿戴的饰品
                    if ($("#InventoryWearablePanel").wearingList==undefined)
                    {
                      $("#InventoryWearablePanel").wearingList =new Array();
                    }
                    $("#InventoryWearablePanel").wearingList.push(thisItemName);
                    // 如果队列长度大于2
                    if  ($("#InventoryWearablePanel").wearingList.length>2)
                    {
                       //把队列头上的饰品卸掉
                       var firstItemName=$("#InventoryWearablePanel").wearingList.shift();
                       var firstItemPanel=$("#InventoryWearablePanel").FindChild(firstItemName);
                       if (firstItemPanel)
                       {
                            firstItemPanel.FindChildTraverse("button_equip").visible=true;
                            firstItemPanel.FindChildTraverse("button_remove").visible=false; 
                            OnChangeEquip(firstItemName,false);
                       }
                    }        
                }

	            OnChangeEquip(thisItemName,true);

           });
	    newItemPanel.FindChildTraverse("button_remove").SetPanelEvent("onactivate", 
        	function() {
                
	            thisItemPanel.FindChildTraverse("button_equip").visible=true;
	            thisItemPanel.FindChildTraverse("button_remove").visible=false;
	            OnChangeEquip(thisItemName,false);
            });
        })(newItemPanel,itemName);
    }
    

    //调整面板的高度，适应滚动条
    for(var key in typeNumberMap){
        if (typeNumberMap[key]>0)
        {
            var panelHeight = 280* Math.ceil(typeNumberMap[key]/5);
            $("#Inventory"+key+"Panel").style.height=(panelHeight+"px;");
        }
    }

}


function CloseInventory(){
	$( "#page_inventory" ).ToggleClass("Hidden");
}

function ShowLotteryPage(index){
    FindDotaHudElement("page_lottery").ToggleClass("Hidden");
    if (!FindDotaHudElement("page_lottery").BHasClass("Hidden"))
    {
        FindDotaHudElement("page_lottery").currentIndex = index
    }
}


function ShowHandBookPage(){
    FindDotaHudElement("page_handbook").ToggleClass("Hidden");
}

function ShowPassPanel(keys) {
    if (keys.playerId==Players.GetLocalPlayer())
    {
        TogglePassPanel();
    }
}

function TogglePassPanel(){


    if ($("#PassPanel")==undefined)
    {
        return;
    }

    if ($("#PassPanel").BHasClass("Hidden"))
    {
       $("#PassPanel").RemoveClass("Hidden");   
    }else {
       $("#PassPanel").AddClass("Hidden");
    }

    var playerId = Game.GetLocalPlayerInfo().player_id;
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    if(typeof ConvertToSteamId32 != "function") return;
    steam_id = ConvertToSteamId32(steam_id);
    var moneyValue = CustomNetTables.GetTableValue("econ_data", "money_"+steam_id).money;
    if (moneyValue<5000)
    {
        $("#CoinSubscribe").enabled=false;
    } else {
        $("#CoinSubscribe").enabled=true;
    }

}


function ClosePassPanel(){

    $("#PassPanel").AddClass("Hidden")
}


function SubscribeByCoins(){
    $("#CoinSubscribeLabel").AddClass("Hidden")
    $("#CoinSubscribeLoading").RemoveClass("Hidden")
    $("#CoinSubscribe").enabled=false;
    GameEvents.SendCustomGameEventToServer( "SubscribePassByCoins", {} );
}

function SubscribePassByCoinsResult(keys){
    
    

    if ($("#CoinSubscribeLoading")==undefined) {
       return;
    }
    
    $("#CoinSubscribeLoading").AddClass("Hidden")
    $("#CoinSubscribeLabel").RemoveClass("Hidden")
    $("#CoinSubscribe").enabled=true;
    
    if (keys.type=="1")
    {
        //等待数据同步过来
        $.Schedule(0.5, () => {
            UpdatePassInfo()
        });
    }
    if (keys.type=="2")
    {
        $("#PassButtonLabel").text="Not Enough Coins"
    }
     $("#PassPanel").AddClass("Hidden");
}



function UpdatePassInfo(){
    var playerId = Game.GetLocalPlayerInfo().player_id;
    var pass_info = CustomNetTables.GetTableValue("player_info", "pass_data_"+playerId);
    if ( pass_info && (pass_info.pass_level_3_days > 0 || pass_info.pass_level_2_days > 0 || pass_info.pass_level_1_days > 0) )
    { 
        $.Msg("Da ")
        var portraitHUD = FindDotaHudElement("center_block");        
        wearButton = portraitHUD.FindChildTraverse("WearButton");
        if (wearButton!=undefined)
        {
            wearButton.style.saturation=1;
        }
        
        var selectCosmeticsContainer = FindDotaHudElement("SelectCosmeticsContainer");    
        if (selectCosmeticsContainer!=undefined)
        {
            cosmeticsContainerMain = selectCosmeticsContainer.FindChildTraverse("CosmeticsContainerMain");
            if (cosmeticsContainerMain!=undefined)
            {
                cosmeticsContainerMain.RemoveClass("Blur");
            }

            cosmeticsContainerMask = selectCosmeticsContainer.FindChildTraverse("CosmeticsContainerMask");
            if (cosmeticsContainerMask!=undefined)
            {
                cosmeticsContainerMask.SetHasClass("Hidden",true)
            }
        }
    }
}

function SubscribeByCash()
{
    $("#PassPanel").style.height = "800px;"
    $("#PassPayPalPanelLoading").SetHasClass("Hidden",true)
    $("#PassTaoBaoPanel").SetHasClass("Hidden",true)
    $("#PassPayPalPanel").SetHasClass("Hidden",true)
    $("#PassCashPanel").SetHasClass("Hidden",false)
}

function ScrollInventory(type)
{      
    $("#Inventory"+type+"Title").ScrollParentToMakePanelFit( 1, false );
}

//切换支付弹窗的显示状态，参数有 "closed" | "loading" | "html"
function SetPaymentWindowStatus(state) {
    if ($("#PaymentWindow")==undefined)
    {
        return;
    }
    const hid = $("#PaymentWindow").BHasClass("Hidden");
    const visible = state !== "closed";
    $("#PaymentWindow").SetHasClass("Hidden", !visible);
    GameEvents.SendCustomGameEventToServer("payments:window", { visible });
    $("#PaymentWindowLoader").visible = state === "loading";
    $("#PaymentWindowHTML").visible = state === "html";
    $("#PaymentWindowWaitExternalBrowser").visible = state === "wait_external_browser";

    const isError = typeof state === "object";
    $("#PaymentWindowError").visible = isError;
    if (isError) {
        $("#PaymentWindow").SetHasClass("Hidden", hid);
        $("#PaymentWindowErrorMessage").text = state.error;
    }
}

function GetPaymentQRCode(tier,type) {

    if (type==undefined)
    {
        type=$("#PaymentTier").type;
    }

    //打开支付弹窗
    SetPaymentWindowStatus("loading");
    
    paymentWindowUpdateListener = createPaymentRequest({ type:type, tier:tier }, (response) => {   

        if (response.url == null || response.url == "") {
            SetPaymentWindowStatus({ error: response.error || "Unknown error" });
            return;
        } 

        if (type=="wechat" || type=="alipay")
        {
            //渲染弹窗
            $("#PaymentWindowHTML").SetURL(response.url);
            //延迟1.5秒取消loading页面
             $.Schedule(1.5, () => {
                SetPaymentWindowStatus("html");
            });
        }
        
        if (type=="paypal" || type=="webmoney" || type=="grabpay_ph" || type=="qiwi")
        {
            //使用内置浏览器支付
            SetPaymentWindowStatus("wait_external_browser");
            //$.Msg(response.url)           
            $.DispatchEvent( 'ExternalBrowserGoToURL',response.url );
        }
    });
}



function ChangePaymentType(type) {
   
   $("#PaymentTier").type=type;
   $("#PaymentTierContainer").RemoveClass("Hidden");
   $("#SelectPaymentLabel").AddClass("Hidden");
}


function PaymentSuccess(keys) {
  
  SetPaymentWindowStatus("closed");
  if ($("#PaymentContainer"))
  {
    $("#PaymentContainer").AddClass("Hidden")
  }

  $("#TaobaoCodeNotify").RemoveClass("GreenAlert")
  
  if (keys.type=="1") {
    $("#TaobaoCodeNotify").RemoveClass("Hidden")
    $("#TaobaoCodeNotify").text=$.Localize("#PaymentSuccess")+keys.money_increase;
    $("#TaobaoCodeNotify").AddClass("GreenAlert")
  }
  if (keys.type=="2") {
    $("#PassPanel").AddClass("Hidden");
    UpdatePassInfo();
  }
}
 

(function()
{   
    CustomNetTables.SubscribeNetTableListener("econ_data", EconDataArrive);

    GameEvents.Subscribe( "SubscribePassByCoinsResult", SubscribePassByCoinsResult ); //返回订阅通行证信息
    GameEvents.Subscribe( "UpdatePassInfo", UpdatePassInfo ); //返回订阅通行证信息
    GameEvents.Subscribe( "PaymentSuccess", PaymentSuccess ); //关闭支付页面
    GameEvents.Subscribe( "ShowPassPanel", ShowPassPanel ); //展示支付页面
    EconDataArrive()
    if ($("#SelectPaymentLabel"))
    {
        $("#SelectPaymentLabel").RemoveClass("Hidden");
    }
    UpdatePassInfo();
})();
