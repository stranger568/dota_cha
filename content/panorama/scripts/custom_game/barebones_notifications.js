function TopNotification( msg ) {
  AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
  AddNotification(msg, $('#BottomNotifications'));
}

function TopRemoveNotification(msg){
  RemoveNotification(msg, $('#TopNotifications'));
}

function BottomRemoveNotification(msg){
  RemoveNotification(msg, $('#BottomNotifications'));
}


function RemoveNotification(msg, panel){
  var count = msg.count;
  if (count > 0 && panel.GetChildCount() > 0){
    var start = panel.GetChildCount() - count;
    if (start < 0)
      start = 0;

    for (i=start;i<panel.GetChildCount(); i++){
      var lastPanel = panel.GetChild(i);
      //lastPanel.SetAttributeInt("deleted", 1);
      lastPanel.deleted = true;
      lastPanel.DeleteAsync(0);
    }
  }
}

function AddNotification(msg, panel) {
  var newNotification = true;
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
  //$.Msg(msg)

  msg.continue = msg.continue || false;
  //msg.continue = true;

  if (lastNotification != null && msg.continue) 
    newNotification = false;

  if (newNotification){
    lastNotification = $.CreatePanel('Panel', panel, '');
    lastNotification.AddClass('NotificationLine')
    lastNotification.hittest = false;
  }

  var notification = null;
  
  if (msg.hero != null)
    notification = $.CreatePanel('DOTAHeroImage', lastNotification, '');
  else if (msg.image != null)
    notification = $.CreatePanel('Image', lastNotification, '');
  else if (msg.ability != null)
    notification = $.CreatePanel('DOTAAbilityImage', lastNotification, '');
  else if (msg.item != null)
    notification = $.CreatePanel('DOTAItemImage', lastNotification, '');
  else
    notification = $.CreatePanel('Label', lastNotification, '');

  if (typeof(msg.duration) != "number"){
    //$.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  if (newNotification){
    $.Schedule(msg.duration, function(){
      //$.Msg('callback')
      if (lastNotification.deleted)
        return;
      
      lastNotification.DeleteAsync(0);
    });
  }

  if (msg.hero != null){
    notification.heroimagestyle = msg.imagestyle || "icon";
    notification.heroname = msg.hero
    notification.hittest = false;
  } else if (msg.image != null){
    notification.SetImage(msg.image);
    notification.hittest = false;
  } else if (msg.ability != null){
    notification.abilityname = msg.ability
    notification.hittest = false;
  } else if (msg.item != null){
    notification.itemname = msg.item
    notification.hittest = false;
  } else{
    notification.html = true;
    var text = msg.text || "No Text provided";
    notification.text = $.Localize(text)
    notification.hittest = false;
    notification.AddClass('TitleText');
  }
  
  if (msg.class)
    notification.AddClass(msg.class);
  else
    notification.AddClass('NotificationMessage');

  if (msg.style){
    for (var key in msg.style){
      var value = msg.style[key]
      notification.style[key] = value;
    }
  }
}

function banned_this_game_information(data)
{
    let notification = $.CreatePanel('Panel', $.GetContextPanel(), '');
    notification.AddClass("notification_banned")

    let notification_close = $.CreatePanel('Panel', notification, '');
    notification_close.AddClass("notification_close")

    notification_close.SetPanelEvent("onactivate", function() 
    { 
        notification.DeleteAsync(0);
    });

    let notification_label = $.CreatePanel('Label', notification, '');
    notification_label.AddClass("notification_label_banned")
    notification_label.text = $.Localize("#banned_in_this_game")

    let notification_banned_heroes = $.CreatePanel('Panel', notification, '');
    notification_banned_heroes.AddClass("notification_banned_banned_heroes")

    let notification_banned_abilities = $.CreatePanel('Panel', notification, '');
    notification_banned_abilities.AddClass("notification_banned_banned_abilities")

    for (var i = 1; i <= Object.keys(data.abilities).length; i++) 
    {
        var ability_panel = $.CreatePanel('DOTAAbilityImage', notification_banned_abilities, '');
        ability_panel.abilityname = data.abilities[i]
        ability_panel.AddClass("banned_ab")
    }
    for (var f = 1; f <= Object.keys(data.heroes).length; f++) 
    {
        var HeroImage = $.CreatePanelWithProperties(`DOTAHeroImage`, notification_banned_heroes, "", {scaling: "stretch-to-cover-preserve-aspect", heroname : String(data.heroes[f]), tabindex : "auto", class: "HeroImageBanned", heroimagestyle : "portrait"});
    }
    notification.DeleteAsync(30);
}


(function () {
  GameEvents.Subscribe( "top_notification", TopNotification );
  GameEvents.Subscribe( "banned_this_game_information", banned_this_game_information );
  GameEvents.Subscribe( "bottom_notification", BottomNotification );
  GameEvents.Subscribe( "top_remove_notification", TopRemoveNotification );
  GameEvents.Subscribe( "bottom_remove_notification", BottomRemoveNotification );
})();