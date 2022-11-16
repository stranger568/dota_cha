var steakSound={
  3:"announcer_killing_spree_announcer_kill_spree_01",
  4:"announcer_killing_spree_announcer_kill_dominate_01",
  5:"announcer_killing_spree_announcer_kill_mega_01",
  6:"announcer_killing_spree_announcer_kill_unstop_01",
  7:"announcer_killing_spree_announcer_kill_wicked_01",
  8:"announcer_killing_spree_announcer_kill_monster_01",
  9:"announcer_killing_spree_announcer_kill_godlike_01",
  10:"announcer_killing_spree_announcer_kill_holy_01"  
}


function FindDotaHudElements(className){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comps = hudRoot.FindChildrenWithClassTraverse(className);
    return comps;
}

function DotaKillStreak(keys)
{   
    
    var streakDelay = 0.1
    if ( Players.GetTeam( Players.GetLocalPlayer())>=6 )  
    {
       $.Schedule(streakDelay, function(){
         if (keys.killer_streak>10) {keys.killer_streak=10}
         Game.EmitSound(steakSound[keys.killer_streak]);
       });
    }
}

function DotaFirstBlood(keys)
{   
  if ( Players.GetTeam( Players.GetLocalPlayer())>=6 )  
  {
     Game.EmitSound("announcer_killing_spree_announcer_1stblood_01");
  }
}




//连杀音效修复器
(function () {
    GameEvents.Subscribe( "dota_chat_kill_streak", DotaKillStreak );
    GameEvents.Subscribe( "dota_chat_first_blood", DotaFirstBlood );
})();