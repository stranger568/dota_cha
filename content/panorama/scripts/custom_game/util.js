
const dotaHud = (() => {
    let panel = $.GetContextPanel();
    while (panel) {
        if (panel.id === "DotaHud") return panel;
        panel = panel.GetParent();
    }
})();


function GetLength2D(p1,p2){
    return Math.sqrt(Math.pow((p1[0]-p2[0]),2)+Math.pow((p1[1]-p2[1]),2));
}

function FindDotaHudElement(id){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}



function FindDotaHudElementByClass(className){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildrenWithClassTraverse(className);
    if (comp.length>0)
    {
        return comp[0];
    } 
    else 
    {
        return null;
    }
}



function ConvertToSteamid64(steamid32)  //32位转64位
{
    var steamid64 = '765' + (parseInt(steamid32) + 61197960265728).toString();
    return steamid64;
}

function ConvertToSteamId32(steamid64) {   //64位转32位
    return steamid64.substr(3) - 61197960265728;
}

function FormatSeconds(value) {
    var theTime = parseInt(value);// 秒
    var theTime1 = 0;// 分
    var theTime2 = 0;// 小时
    if(theTime > 60) {
        theTime1 = parseInt(theTime/60);
        theTime = parseInt(theTime%60);
            if(theTime1 > 60) {
            theTime2 = parseInt(theTime1/60);
            theTime1 = parseInt(theTime1%60);
            }
    }
        var result = ""+parseInt(theTime)+"\"";
        if(theTime1 > 0) {
           result = ""+parseInt(theTime1)+"\'"+result;
        }
        if(theTime2 > 0) {
          result = ""+parseInt(theTime2)+":"+result;
        }
    return result;
}

function DrawRandomFromArray (arr,num){

    var result = [];

    for (var i = 0; i < num; i++) {
        var ran = Math.floor(Math.random() * arr.length);
        result.push(arr.splice(ran, 1)[0]);
    }

    return result;

};

var ShowAbilityTooltip = ( function( ability )
{ 
    return function()
    {
        $.DispatchEvent( "DOTAShowAbilityTooltip", ability, ability.abilityname );
    }
});

var HideAbilityTooltip = ( function( ability )
{
    return function()
    {
        $.DispatchEvent( "DOTAHideAbilityTooltip", ability );
    }
});


var ShowItemTooltip = ( function( item )
{
    return function()

    {
        $.DispatchEvent( "DOTAShowAbilityTooltip", item, item.itemname );
    }
});

var HideItemTooltip = ( function( item )
{
    return function()
    {
        $.DispatchEvent( "DOTAHideAbilityTooltip", item );
    }
});




function TipsOver(message, pos){
    if ($("#"+pos)!=undefined)
    {
       $.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize("#"+message));
    }
}

function TipsOut(){
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}

function SendHudError(keys) {
    GameEvents.SendEventClientSide("dota_hud_error_message", {
        splitscreenplayer: 0,
        reason: 80,
        message: "#"+keys.message,
    });
}

function AbilityInDeleteCoolDown(keys) {
    GameEvents.SendEventClientSide("dota_hud_error_message", {
        splitscreenplayer: 0,
        reason: 80,
        message:  $.Localize("#DOTA_Tooltip_ability_" + keys.ability_name) + $.Localize("#InDeleteCoolDown"),
    });
}

function GetEarlyLeaver(playerId) {

  var early_leaver = CustomNetTables.GetTableValue("rank_data", "early_leaver");
  if (early_leaver &&  early_leaver[playerId])
  {
    return $.Localize("#early_leaver");
  }
  else
  {
     return "";
  }

}



//获取玩家全部饰品
function GetPlayerEconInfoData(steam_id) {

    var playerData = [];
    var bucketData = CustomNetTables.GetTableValue("econ_data", "econ_total_bucket_"+steam_id) 
    if (bucketData && bucketData.total_bucket)
    {
       var bucket_number = parseInt(bucketData.total_bucket)
       for (var i = 1; i <= bucket_number; i++) {
          var econ_info = CustomNetTables.GetTableValue("econ_data", "econ_info_"+steam_id+"_"+i)
          for (var index in econ_info){
               playerData.push(econ_info[index])
          }
       }
    }
    return playerData;
}

//带回传的请求，每次调用id都增加1
function CreateEventRequestCreator(eventName) {
    var idCounter = 0;
    return function(data, callback) {
        var id = ++idCounter;
        data.id = id;
        GameEvents.SendCustomGameEventToServer(eventName, data);
        var listener = GameEvents.Subscribe(eventName, function(data) {
            if (data.id !== id) return;
            GameEvents.Unsubscribe(listener);
            callback(data)
        });
        return listener;
    }
}

//判断技能 是否为动作栏的有效技能
function IsValidAbility(abilityIndex) {

    var result = false;
    var abilityName = Abilities.GetAbilityName(abilityIndex);
    //有效技能
    if (abilityName!=null && abilityName != "" && abilityName.substring(0, 14) != "special_bonus_" && abilityName!= "generic_hidden" && abilityName.substring(0, 6) != "empty_" )
    {
        //不是隐藏技能 不是配赠技能
        if (!Abilities.IsHidden(abilityIndex)  && CustomNetTables.GetTableValue("subsidiary_list", abilityName)==undefined)
        {
           result = true; 
        }
    }

    return result;
}


function IsValidAbilityDuel(abilityIndex) {

    var result = false;
    var abilityName = Abilities.GetAbilityName(abilityIndex);
    //有效技能
    if (abilityName!=null && abilityName != "" && abilityName.substring(0, 14) != "special_bonus_" && abilityName!= "generic_hidden" && abilityName.substring(0, 6) != "empty_" )
    {
        //不是隐藏技能 不是配赠技能
        if (!Abilities.IsHidden(abilityIndex))
        {
           result = true; 
        }
    }

    return result;
}

function GetImageRank(rating)
{
    if (rating >= 7000) {
        return "rank8_5"
    } else if (rating >= 6700) {
        return "rank8_4"
    } else if (rating >= 6400) {
        return "rank8_3"
    } else if (rating >= 6100) {
        return "rank8_2"
    } else if (rating >= 5800) {
        return "rank8_1"
    } else if (rating >= 5420) {
        return "rank7_5"
    } else if (rating >= 5220) {
        return "rank7_4"
    } else if (rating >= 5020) {
        return "rank7_3"
    } else if (rating >= 4820) {
        return "rank7_2"
    } else if (rating >= 4620) {
        return "rank7_1"
    } else if (rating >= 4460) {
        return "rank6_5"
    } else if (rating >= 4300) {
        return "rank6_4"
    } else if (rating >= 4150) {
        return "rank6_3"
    } else if (rating >= 4000) {
        return "rank6_2"
    } else if (rating >= 3850) {
        return "rank6_1"
    } else if (rating >= 3700) {
        return "rank5_5"
    } else if (rating >= 3540) {
       return  "rank5_4"
    } else if (rating >= 3390) {
        return "rank5_3"
    } else if (rating >= 3230) {
        return "rank5_2"
    } else if (rating >= 3080) {
        return "rank5_1"
    } else if (rating >= 2930) {
        return "rank4_5"
    } else if (rating >= 2770) {
        return "rank4_4"
    } else if (rating >= 2610) {
        return "rank4_3"
    } else if (rating >= 2450) {
        return "rank4_2"
    } else if (rating >= 2310) {
        return "rank4_1"
    } else if (rating >= 2150) {
        return "rank3_5"
    } else if (rating >= 2000) {
        return "rank3_4"
    } else if (rating >= 1850) {
        return "rank3_3"
    } else if (rating >= 1700) {
        return "rank3_2"
    } else if (rating >= 1540) {
        return "rank3_1"
    } else if (rating >= 1400) {
        return "rank2_5"
    } else if (rating >= 1230) {
        return "rank2_4"
    } else if (rating >= 1080) {
        return "rank2_3"
    } else if (rating >= 920) {
        return "rank2_2"
    } else if (rating >= 770) {
        return "rank2_1"
    } else if (rating >= 610) {
        return "rank1_5"
    } else if (rating >= 460) {
        return "rank1_4"
    } else if (rating >= 300) {
        return "rank1_3"
    } else if (rating >= 150) {
        return "rank1_2"
    } else if (rating <= 149) {
        return "rank1_1"
    }
}


(function () {
    GameEvents.Subscribe("SendHudError", SendHudError);
    GameEvents.Subscribe("AbilityInDeleteCoolDown", AbilityInDeleteCoolDown);
})();
