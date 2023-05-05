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

function OpenPass()
{
    GameUI.CustomUIConfig().OpenPass()
}

function OpenWheel()
{
    GameUI.CustomUIConfig().OpenWheel()
}

function OpenRewards()
{
    GameUI.CustomUIConfig().OpenRewards()
}

function OpenProfile()
{
    GameUI.CustomUIConfig().OpenProfile()
}