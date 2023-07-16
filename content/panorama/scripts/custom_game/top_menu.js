function FindDotaHudElement(id)
{
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}

function OpenSettings()
{
    FindDotaHudElement("page_setting").ToggleClass("Show");
    GameEvents.SendCustomGameEventToAllClients("RefreshAbilityOrder", {}) 
}

function OpenLeaderboard()
{
    GameUI.CustomUIConfig().OpenLeaderboard()
}

function OpenProfileAndDonate(inf1, inf2)
{
    GameUI.CustomUIConfig().OpenPass(inf1, inf2)
}