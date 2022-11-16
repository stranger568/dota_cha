function FindDotaHudElement(id){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}

function OpenRank(){
	FindDotaHudElement("page_rank").ToggleClass("Hidden");
}

function OpenInventory(){
    FindDotaHudElement("page_inventory").ToggleClass("Hidden");
    GameEvents.SendCustomGameEventToAllClients("UpdatePassInfo", {}) 

}

function OpenChatwheel(){
    FindDotaHudElement("page_chatwheel").ToggleClass("Hidden");  
}

function OpenTuant(){
    FindDotaHudElement("page_taunt").ToggleClass("Hidden");  
}

function OpenOrder(){
    FindDotaHudElement("page_setting").ToggleClass("Show");
    GameEvents.SendCustomGameEventToAllClients("RefreshAbilityOrder", {}) 
}

function OpenFeedback() {
  var feedbackRoot = FindDotaHudElement("FeedbackInput").GetParent();
  feedbackRoot.ToggleClass("show");
  Game.EmitSound("ui_chat_slide_in");
  //玩家点开反馈，取消闪烁
  FindDotaHudElement("FeedbackColor").SetHasClass("Glow",false)
  //已点击过的标识 不会重复加闪烁
  FindDotaHudElement("FeedbackColor").SetHasClass("Clicked",true)
  GameEvents.SendCustomGameEventToServer("FeedbackRead", {});
}


(function()
{

   // $.Schedule(7, function(){
   //   TipsOver('TopMenuIcon_Rank_message','TopMenuIcon_Rank')
   // });

   // $.Schedule(14, function(){
   //   TipsOver('TopMenuIcon_Inventory_message','TopMenuIcon_Inventory')
   // });

   // $.Schedule(21, function(){
   //   TipsOver('TopMenuIcon_Chatwheel_message','TopMenuIcon_Chatwheel')
   // });

   //$.Schedule(28, function(){
   //  TipsOver('TopMenuIcon_Tuant_message','TopMenuIcon_Tuant')
   //});

    //$.Schedule(35, function(){
    //  TipsOver('TopMenuIcon_Setting_message','TopMenuIcon_Order')
    //});

    //$.Schedule(42, function(){
    //  TipsOver('TopMenuIcon_Feedback_message','TopMenuIcon_Feedback')
    //});

    //$.Schedule(49, function(){
    //  TipsOut()
    //});
    
    
})();
