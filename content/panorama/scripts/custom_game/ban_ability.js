var previousHeroRadio = null;

var groupKV=
{
  str_1:["earthshaker","sven","tiny","kunkka","beastmaster","dragon_knight","rattletrap","omniknight","huskar","alchemist","brewmaster","treant","wisp",
        "centaur","shredder","bristleback","tusk","elder_titan","legion_commander","earth_spirit","phoenix","mars","snapfire","dawnbreaker","marci"],
  str_2:["axe","pudge","sand_king","slardar","tidehunter","skeleton_king","life_stealer","night_stalker","doom_bringer","spirit_breaker","lycan","chaos_knight","undying",
        "magnataur","abaddon","abyssal_underlord","primal_beast"],
  agi_1:["antimage","drow_ranger","juggernaut","mirana","morphling","phantom_lancer","vengefulspirit","riki","sniper","templar_assassin","luna","bounty_hunter","ursa",
        "gyrocopter","lone_druid","naga_siren","troll_warlord","ember_spirit","monkey_king","pangolier","hoodwink"], 
  agi_2:["bloodseeker","nevermore","razor","venomancer","faceless_void","phantom_assassin","viper","clinkz","broodmother","weaver","spectre","meepo","nyx_assassin",
        "slark","medusa","terrorblade","arc_warden"],
  int_1:["crystal_maiden","puck","storm_spirit","windrunner","zuus","lina","shadow_shaman","tinker","furion","enchantress","jakiro","chen","silencer","ogre_magi",
        "rubick","disruptor","keeper_of_the_light","skywrath_mage","oracle","techies","dark_willow","void_spirit"], 
  int_2:["bane","lich","lion","witch_doctor","enigma","necrolyte","warlock","queenofpain","death_prophet","pugna","dazzle","leshrac","dark_seer","batrider",
        "ancient_apparition","invoker","obsidian_destroyer","shadow_demon","visage","winter_wyvern","grimstroke"], 
}


// Прогрузка пика и создание переменных

var recentBannedAbilities = null;
var recentBannedHeroes = null;
var abilityTimeLeft = 0
var heroTimeLeft = 0

var table_player = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))

if (table_player)
{
	abilityTimeLeft = table_player.ban_count_ability
	heroTimeLeft = table_player.ban_count_hero
}

// Функции дополнительные

function SetPanelText(parentPanel, childPanelId, text) {
	if (!parentPanel) {
		return;
	}

	var childPanel = parentPanel.FindChildInLayoutFile(childPanelId);

	if (!childPanel) {
		return;
	}

	childPanel.text = text;
}

var ShowAbilityTooltip = (function (ability) {
    return function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", ability, ability.abilityname);
    }
});

var HideAbilityTooltip = (function (ability) {
    return function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", ability);
    }
});

function CloseBanPanel(){
   
   $("#MainBlock").AddClass("Hidden")
   var table_player = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))

	if (table_player)
	{
		abilityTimeLeft = table_player.ban_count_ability
		heroTimeLeft = table_player.ban_count_hero
	}
}

function OpenBanPanel(){
   
   $("#MainBlock").RemoveClass("Hidden")
   var table_player = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))
	if (table_player)
	{
		abilityTimeLeft = table_player.ban_count_ability
		heroTimeLeft = table_player.ban_count_hero
	}
}

// Создание героев

function Update_Heroes_Table() 
{
	Update_Heroes_Row($("#heroesTableStrAgi"), "str");
	Update_Heroes_Row($("#heroesTableStrAgi"), "agi");
	Update_Heroes_Row($("#heroesTableInt"), "int");
}

function Update_Heroes_Row(container, type) {

	var parentPanelId = "HeroesRow_" + type;

	var parentPanel = container.FindChild(parentPanelId);
	if (!parentPanel) {
		parentPanel = $.CreatePanel("Panel", container, parentPanelId);
		parentPanel.BLoadLayoutSnippet("HeroesRow");
		parentPanel.SetHasClass("HeroesRow", true);
	}

	var groupNamePanel = parentPanel.FindChildTraverse("RowName");
	groupNamePanel.text = $.Localize("#"+type+"");
    parentPanel.FindChildTraverse("RowIcon").SetImage("file://{resources}/images/custom_game/" + type + ".png");

	var groupTable = parentPanel.FindChildTraverse("RowTable");

	for (var i = 1; i <= 2; i++) {

        var groupName =  type+"_"+i;
		var groupPanelId = "HeroesGroup_" + groupName;

		var groupPanel = groupTable.FindChild(groupPanelId);
		if (!groupPanel) {
			groupPanel = $.CreatePanel("Panel", groupTable, groupPanelId);
			groupPanel.SetHasClass("HeroesGroup", true);
		}

		Update_Heroes_Group(groupPanel, groupName);
	}
}

function Update_Heroes_Group(groupPanel, groupName) {

	var groupContainerId = "HeroesGroupContainer_" + groupName;

	var groupContainer = groupPanel.FindChild(groupContainerId);

	if (!groupContainer) {
		groupContainer = $.CreatePanel("Panel", groupPanel, groupContainerId);
		groupContainer.SetHasClass("HeroesGroupContainer", true);
		groupContainer.SetHasClass("hBlock", true);
	}
    
	for (var key in groupKV[groupName]) {
		var name = groupKV[groupName][key]
		var heroPanelId = "npc_dota_hero_" + name;
		var heroPanel = groupContainer.FindChild(heroPanelId);

		if (!heroPanel) {
			heroPanel = $.CreatePanel("Panel", groupContainer, heroPanelId);
			heroPanel.BLoadLayoutSnippet("HeroesRadioButton");
			heroPanel.SetHasClass("HeroPanel", true);
		}

		Update_Heroes(heroPanel, groupName, name);
	}
}

function Update_Heroes(heroPanel, groupName, name) {

	var rButton = heroPanel.FindChildInLayoutFile("RadioButton");
	rButton.group = "Heroes";
	rButton.SetHasClass("hBlock", true);

	rButton.data = { heroName: name, heroGroup: groupName };

	rButton.SetPanelEvent("onselect", PreviewHero(rButton));
	var childImage = heroPanel.FindChildInLayoutFile("RadioImage");
	childImage.heroname = name;
}

var PreviewHero = (function (rButton) 
{
	return function () {
		var heroInfo = rButton.data;
		UpdateTargetHeroAbilityList(heroInfo.heroName, true);
		if (previousHeroRadio != null) {
			previousHeroRadio.checked = false;
		}
		previousHeroRadio = rButton;
	}
});

// Вызов окна с информацией о герое

function UpdateTargetHeroAbilityList(heroName, isButtonEvent) 
{
	var parentPanel = $("#OperatePanel")

	var heroImageButton = parentPanel.FindChildTraverse("HeroImageRadioButton");

    var childImage = parentPanel.FindChildTraverse("HeroImage");

	var abilityList = parentPanel.FindChildInLayoutFile("Abilities");

	if (heroName != "") 
	{
		childImage.heroname = heroName;	
        heroImageButton.enabled = true

        let ban_heroes_table = CustomNetTables.GetTableValue("hero_info", "hero_abilities")

        if (ban_heroes_table)
        {
        	for (var i = 0; i <= Object.keys(ban_heroes_table).length; i++) 
		    {
		       if ( "npc_dota_hero_"+ heroName == ban_heroes_table[i] )
		       {
		       	   heroImageButton.enabled=false
		       }
		    }
        }

	    SetHeroImageEvent(heroImageButton, heroName);

		var slotNumber = 0;

		for (var abilitySlot in CustomNetTables.GetTableValue("hero_info", "Abilities_"+heroName)) 
		{
			slotNumber = slotNumber + 1;
		}

		if (!abilityList.maxslot || abilityList.maxslot < slotNumber) 
		{
			abilityList.maxslot = slotNumber;
		}

		for (var slot = 1; slot <= abilityList.maxslot; slot++)
		{
			InvisibleAbilityList(abilityList, slot);
		}

		for (var slot = 1; slot <= slotNumber; slot++)
		{
			UpdateAbility(abilityList, heroName, slot);
		}

		$("#BanButtonLabel").heroName = heroName;
	}
}

// Ивент нажатия по герою

function SetHeroImageEvent(heroButton,heroName) {
   
   heroButton.SetPanelEvent("onactivate", function() 
   {
   	   var parentPanel = $("#OperatePanel")
   	   var abilityList = parentPanel.FindChildInLayoutFile("Abilities");

   	   for (var slot = 1; slot <= abilityList.maxslot; slot++)
	   {
			var abButtonId = "Ability_" + slot;
			var abButton = abilityList.FindChild(abButtonId);
			if (abButton) {
				abButton.checked = false;
			}
	   }

        $("#BanButtonLabel").text= $.Localize("#ban") +  $.Localize("#npc_dota_hero_"+heroName);  
        $("#BanButtonLabel").heroName= heroName;
        $("#BanButtonLabel").abilityName = null;

        if (heroTimeLeft==0)
	    {
	       $("#TimeLeftLabel").RemoveClass("Green");
	       $("#TimeLeftLabel").AddClass("Red");
	       $("#BanButton").AddClass("Hidden");
	   	   $("#TimeLeftLabel").AddClass("Hidden");
	       $("#BanButton").enabled=false;
	    }

	    if ( heroTimeLeft > 0 ) 
	    {
	    	$("#BanButton").enabled= true
	    	$("#TimeLeftLabel").RemoveClass("Red");
	        $("#TimeLeftLabel").AddClass("Green");
	    	$("#BanButton").RemoveClass("Hidden");
	   	   	$("#TimeLeftLabel").RemoveClass("Hidden");
   	       	$("#TimeLeftLabel").SetDialogVariableInt("times", heroTimeLeft);
	    }
   })
}

// Создание способностей

function InvisibleAbilityList(abilityList, slot) 
{
	var abButtonId = "Ability_" + slot;
	var abButton = abilityList.FindChild(abButtonId);
	if (abButton) {
		abButton.SetHasClass("Hidden", true);
	}
}

function UpdateAbility(abilityList, heroName, slot) {

	var abButtonId = "Ability_" + slot;
	var abButton = abilityList.FindChild(abButtonId);

	if (!abButton) {
		abButton = $.CreatePanel("RadioButton", abilityList, abButtonId);
	}

	abButton.SetHasClass("Hidden", false);

	abButton.AddClass("AbilityRadioButton");

	var abPanelId = "Ability_Image_" + slot;

	var abPanel = abButton.FindChild(abPanelId);

	var abilityName = CustomNetTables.GetTableValue("hero_info", "Abilities_"+heroName)[slot];

	abButton.abilityName = abilityName;

	if (!abPanel) {
		abPanel = $.CreatePanel("DOTAAbilityImage", abButton, abPanelId);
		abPanel.SetHasClass("hBlock", true);
		abPanel.SetHasClass("vBlock", true);
		abPanel.data = {
			abilityName: abPanel.abilityname,
			heroName: heroName,
		}
		abPanel.abilityname = abilityName;
	}
	else
	{
		abPanel.abilityname = abilityName;
		abPanel.data.abilityName = abilityName;
		abPanel.data.heroName = heroName;
	}

	abButton.enabled=true
    
    let ban_abilities_table = CustomNetTables.GetTableValue("hero_info", "ban_abilities")

    if (ban_abilities_table)
    {
    	for (var i = 0; i <= Object.keys(ban_abilities_table).length; i++) 
	    {
	       if ( abilityName == ban_abilities_table[i] )
	       {
	       	   abButton.enabled=false
	       }
	    }
    }

	SetAbilityPanelEvent(abButton,abilityName);
}

function SetAbilityPanelEvent(panel,abilityName) 
{  
   panel.SetPanelEvent("onactivate", function() 
   {
       	$("#HeroImageRadioButton").checked = false;  
       	$("#BanButtonLabel").text= $.Localize("#ban") +  $.Localize("#DOTA_Tooltip_ability_"+abilityName);    
       	$("#BanButtonLabel").abilityName= abilityName;
       	$("#BanButtonLabel").heroName= null;

	    if (abilityTimeLeft==0)
	    {
	       $("#TimeLeftLabel").RemoveClass("Green");
	       $("#TimeLeftLabel").AddClass("Red");
	       $("#BanButton").AddClass("Hidden");
	   	   $("#TimeLeftLabel").AddClass("Hidden");
	       $("#BanButton").enabled=false;
	    }

	    if ( abilityTimeLeft > 0 ) 
	    {
	    	$("#TimeLeftLabel").RemoveClass("Red");
	        $("#TimeLeftLabel").AddClass("Green");
	    	$("#BanButton").enabled= true
	    	$("#BanButton").RemoveClass("Hidden");
	   	   	$("#TimeLeftLabel").RemoveClass("Hidden");
   	       	$("#TimeLeftLabel").SetDialogVariableInt("times", abilityTimeLeft);
	    }	 
   })
}

// обновление данных пасса

function UpdatePassData(keys)
{

    let recent_banned_heroes_table = keys.recent_banned_heroes.split(',');
    let recent_banned_abilities_table = keys.recent_banned_abilities.split(',');

    if (keys.recent_banned_heroes == "")
    {
    	recent_banned_heroes_table = []
    }
    if (keys.recent_banned_abilities == "")
    {
    	recent_banned_abilities_table = []
    }

    UpdateRecentBannedAbilityList(recent_banned_abilities_table)
    UpdateRecentBannedHeroList(recent_banned_heroes_table)
	 
	$("#WaitingContainer").AddClass("Hidden");
}

function UpdateRecentBannedAbilityList(abilities) {
    if (abilities && abilities.length>0)
    {
    	recentBannedAbilities=abilities;

		for (var slot = 0; slot < abilities.length; slot++)
		{
			var abButtonId = "RecentBannedAbility_" + slot;
			var abButton = $("#RecentBannedAbilities").FindChild(abButtonId);

			if (!abButton) {
				abButton = $.CreatePanel("RadioButton", $("#RecentBannedAbilities"), abButtonId);
			}

			abButton.AddClass("AbilityRadioButton");

			var abPanelId = "RecentBannedAbility_Image_" + slot;

			var abPanel = abButton.FindChild(abPanelId);

			var abilityName = abilities[slot+""];

			abButton.abilityName = abilityName;

			if (!abPanel) {
				abPanel = $.CreatePanel("DOTAAbilityImage", abButton, abPanelId);
				abPanel.SetHasClass("hBlock", true);
				abPanel.SetHasClass("vBlock", true);
				abPanel.data = {
					abilityName: abilityName,
				}
				abPanel.abilityname = abilityName;
			}
			else
			{
				abPanel.abilityname = abilityName;
				abPanel.data.abilityName = abilityName;
			}

			abButton.enabled=true

		    let ban_abilities_table = CustomNetTables.GetTableValue("hero_info", "ban_abilities")

		    if (ban_abilities_table)
		    {
		    	for (var i = 0; i <= Object.keys(ban_abilities_table).length; i++) 
			    {
			       if ( abilityName == ban_abilities_table[i] )
			       {
			       	   abButton.enabled=false
			       }
			    }
		    }

			SetAbilityPanelEvent(abButton,abilityName);
		}
    }
}

function UpdateRecentBannedHeroList(heroes) {
    if (heroes && heroes.length>0)
    {
    	recentBannedHeroes = heroes;

		for (var slot = 0; slot < heroes.length; slot++)
		{
			var heroButtonId = "RecentBannedHero_" + slot;

			var heroButton = $("#RecentBannedHeroes").FindChild(heroButtonId);

			if (!heroButton) {
				heroButton = $.CreatePanel("RadioButton", $("#RecentBannedHeroes"), heroButtonId);
			}

			heroButton.AddClass("HeroImageRadioButton");

			var heroImageId = "RecentBannedHero_Image_" + slot;

			var heroImage = heroButton.FindChild(heroImageId);

			var heroName = heroes[slot+""];

			let rep_heroName = heroName.replace('npc_dota_hero_', ''); 

			heroButton.heroName = rep_heroName;

			if (!heroImage) {
				heroImage = $.CreatePanel("DOTAHeroImage", heroButton, heroImageId);
				heroImage.SetHasClass("hBlock", true);
				heroImage.SetHasClass("vBlock", true);
				heroImage.data = {
					heroname: rep_heroName,
				}
				heroImage.heroname = rep_heroName;
			}
			else
			{
				heroImage.heroname = rep_heroName;
				heroImage.data.heroname = rep_heroName;
			}

			let ban_heroes_table = CustomNetTables.GetTableValue("hero_info", "hero_abilities")

	        if (ban_heroes_table)
	        {
	        	for (var i = 0; i <= Object.keys(ban_heroes_table).length; i++) 
			    {
			       if ( rep_heroName == ban_heroes_table[i] )
			       {
			       	   heroImage.enabled=false
			       }
			    }
	        }

			SetHeroImageEvent(heroButton,rep_heroName);
		}
    }
}

function ActiveBan() {

   	if ($("#BanButtonLabel").abilityName)
   	{
   		var abilityName = $("#BanButtonLabel").abilityName
   		GameEvents.SendCustomGameEventToServer("BanAbility", {abilityName:abilityName});
   		abilityTimeLeft = abilityTimeLeft-1
   		$("#TimeLeftLabel").SetDialogVariableInt("times", abilityTimeLeft);

   		if (abilityTimeLeft==0)
     	{
       		$("#TimeLeftLabel").RemoveClass("Green");
       		$("#TimeLeftLabel").AddClass("Red");
       		$("#BanButton").enabled=false;
     	}

		for (var slot = 1; slot <= $("#Abilities").maxslot; slot++) {   	  
	   		var abButtonId = "Ability_" + slot;
			var abButton = $("#Abilities").FindChild(abButtonId);
			if (abButton && abilityName==abButton.abilityName) {
				abButton.enabled=false;
			}
	 	}

     	if (recentBannedAbilities) 
     	{
     		for (var slot = 0; slot <= recentBannedAbilities.length; slot++) 
     		{
     			var abButtonId = "RecentBannedAbility_" + slot;
     			var abButton = $("#RecentBannedAbilities").FindChild(abButtonId);
     			if (abButton && abilityName==abButton.abilityName) 
     			{
     				abButton.enabled=false;
     			}
     		}
     	}
    }
     
    if ($("#BanButtonLabel").heroName)
    {
    	var heroName = $("#BanButtonLabel").heroName
    	GameEvents.SendCustomGameEventToServer("BanHero", {heroName:heroName});
    	heroTimeLeft = heroTimeLeft - 1
    	$("#TimeLeftLabel").SetDialogVariableInt("times", heroTimeLeft);
		if (heroTimeLeft==0)
     	{
       		$("#TimeLeftLabel").RemoveClass("Green");
       		$("#TimeLeftLabel").AddClass("Red");
       		$("#BanButton").enabled=false;
     	}

		if ( $("#OperatePanel").FindChildTraverse("HeroImageRadioButton") && $("#OperatePanel").FindChildTraverse("HeroImageRadioButton").FindChildTraverse("HeroImage") )
     	{
     		if ($("#OperatePanel").FindChildTraverse("HeroImageRadioButton").FindChildTraverse("HeroImage").heroname == heroName)
     		{
     			$("#HeroImageRadioButton").enabled=false;
     		}
     	}
     	if (recentBannedHeroes) 
     	{
     		for (var slot = 0; slot <= recentBannedHeroes.length; slot++) 
     		{ 
     			var heroButtonId = "RecentBannedHero_" + slot;
     			var heroButton = $("#RecentBannedHeroes").FindChild(heroButtonId);
     			if (heroButton && heroName==heroButton.heroName) 
     			{
     				heroButton.enabled=false;
     			}
     		}
     	}
    }

   	$("#BanButton").AddClass("Hidden")
} 

function UpdateBanHeroAllClients(hero)
{
	if (recentBannedHeroes)
	{
		for (var slot = 0; slot <= recentBannedHeroes.length; slot++) 
	   	{   	  
	     	var heroButtonId = "RecentBannedHero_" + slot;
		 	var heroButton = $("#RecentBannedHeroes").FindChild(heroButtonId);
		 	if (heroButton && hero == heroButton.heroName) 
		 	{
		   		heroButton.enabled=false;
		 	}
	   	}
	}

   	if ( $("#OperatePanel").FindChildTraverse("HeroImageRadioButton") && $("#OperatePanel").FindChildTraverse("HeroImageRadioButton").FindChildTraverse("HeroImage") )
 	{
 		if ($("#OperatePanel").FindChildTraverse("HeroImageRadioButton").FindChildTraverse("HeroImage").heroname == hero)
 		{
 			$("#HeroImageRadioButton").enabled=false;
 		}
 	}

   	if ($("#BanButtonLabel").heroName)
   	{
   		if ($("#BanButtonLabel").heroName == hero)
   		{
   			$("#BanButton").enabled=false;
   		}
   	}
}

function UpdateBanAbilityAllClients(ability)
{
	if (recentBannedAbilities)
	{
		for (var slot = 0; slot <= recentBannedAbilities.length; slot++) 
		{   	  
		    var abButtonId = "RecentBannedAbility_" + slot;
			var abButton = $("#RecentBannedAbilities").FindChild(abButtonId);
			if (abButton && ability == abButton.abilityName) 
			{
				abButton.enabled=false;
			}
		}
	}

	for (var slot = 1; slot <= $("#Abilities").maxslot; slot++) {   	  
   		var abButtonId = "Ability_" + slot;
		var abButton = $("#Abilities").FindChild(abButtonId);
		if (abButton && ability == abButton.abilityName) {
			abButton.enabled=false;
		}
 	}

	if ($("#BanButtonLabel").abilityName)
	{
		if ($("#BanButtonLabel").abilityName == ability)
		{
			$("#BanButton").enabled=false;
		}
	}
}

function UpdatebanHero(data)
{
	UpdateBanHeroAllClients(data.hero)
}

function UpdatebanAbility(data)
{
	UpdateBanAbilityAllClients(data.abilityName)
}

(function() 
{
    
    GameEvents.Subscribe( "UpdatePassData", UpdatePassData );
    GameEvents.Subscribe( "UpdatebanHero", UpdatebanHero );
    GameEvents.Subscribe( "UpdatebanAbility", UpdatebanAbility );
	Update_Heroes_Table();
})();