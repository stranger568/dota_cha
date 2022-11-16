
function FindHudRoot(){  
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    return hudRoot;
}

function IsSecurityKeyValid(securityKey)
{
   var hudRoot = FindHudRoot();
      
   if (hudRoot==undefined || hudRoot.SECURITY_KEY==undefined){
      return true
   }

   if (hudRoot.SECURITY_KEY==securityKey) {
      return true
   } else {
      return false
   }
}


(function(){


})();
