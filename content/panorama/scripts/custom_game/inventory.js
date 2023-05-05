function SortByRarity(a,b) 
{

}


function SubmitTaobaoCode()
{

}

function OnChangeEquip(itemName,isEquip) 
{

}

function ShowPaymentContainer()
{

}

function ClosePaymentContainer()
{

}

function EconDataArrive()
{

}

function CloseInventory()
{

}

function ShowLotteryPage(index)
{

}

function ShowHandBookPage()
{

}

function ShowPassPanel(keys) 
{

}

function TogglePassPanel()
{

}


function ClosePassPanel()
{

}

function SubscribeByCoins()
{

}

function SubscribePassByCoinsResult(keys)
{

}

function SubscribeByCash()
{
}

function ScrollInventory(type)
{      

}

function SetPaymentWindowStatus(state) {

}

function GetPaymentQRCode(tier,type) 
{

}

function ChangePaymentType(type) 
{

}


function PaymentSuccess(keys) 
{

}

function UpdatePassInfo()
{
    var playerId = Game.GetLocalPlayerInfo().player_id;
    var pass_info = CustomNetTables.GetTableValue("player_info", "pass_data_"+playerId);
    if ( pass_info && (pass_info.pass_level_3_days > 0 || pass_info.pass_level_2_days > 0 || pass_info.pass_level_1_days > 0) )
    { 
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

(function()
{   
    GameEvents.Subscribe( "UpdatePassInfo", UpdatePassInfo );
    EconDataArrive()
    UpdatePassInfo();
})();
