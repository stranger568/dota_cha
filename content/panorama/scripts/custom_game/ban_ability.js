var previousHeroRadio = null;

var groupKV=
{
  str_1:["earthshaker","sven","tiny","kunkka","dragon_knight","omniknight","huskar","alchemist","treant",
        "centaur","bristleback","tusk","elder_titan","legion_commander","earth_spirit","mars","dawnbreaker"],
  
  str_2:["axe","pudge","sand_king","slardar","tidehunter","skeleton_king","life_stealer","night_stalker","doom_bringer","spirit_breaker","chaos_knight","undying","abyssal_underlord","primal_beast"],
  
  agi_1:["antimage","drow_ranger","juggernaut","morphling","phantom_lancer","riki","sniper","templar_assassin","luna","bounty_hunter","ursa",
        "gyrocopter","naga_siren","troll_warlord","ember_spirit","monkey_king","hoodwink"], 
  
  agi_2:["bloodseeker","nevermore","razor","faceless_void","phantom_assassin","viper","clinkz","weaver","spectre","meepo",
        "slark","medusa","terrorblade","arc_warden"],
  
  int_1:["crystal_maiden","puck","storm_spirit","zuus","lina","shadow_shaman","tinker","furion","enchantress","jakiro","silencer","ogre_magi",
	  "rubick", "disruptor", "witch_doctor", "keeper_of_the_light","skywrath_mage","oracle"], 
  
  int_2:["lich","lion","necrolyte","warlock","queenofpain","death_prophet","pugna","leshrac","muerta",
        "ancient_apparition","invoker","obsidian_destroyer","shadow_demon","grimstroke"], 

	universal_1: ["dark_seer", "beastmaster", "chen", "vengefulspirit", "dazzle", "void_spirit", "winter_wyvern", "marci", "enigma", "dark_willow", "rattletrap", "brewmaster", "wisp", "windrunner", "visage", "venomancer",], 
  universal_2:["lone_druid","techies","mirana","magnataur","pangolier","snapfire","nyx_assassin","shredder","phoenix","abaddon","lycan","bane","batrider","broodmother"],   
}




groupKV.str_1.sort()
groupKV.str_2.sort()
groupKV.agi_1.sort()
groupKV.agi_2.sort()
groupKV.int_1.sort()
groupKV.int_2.sort()
groupKV.universal_1.sort()
groupKV.universal_2.sort()


// Прогрузка пика и создание переменных

var recentBannedAbilities = null;
var recentBannedHeroes = null;
var abilityTimeLeft = 0
var heroTimeLeft = 0
var timer_close_right = -1
  
var table_player = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))

if (table_player)
{
	abilityTimeLeft = table_player.ban_count_ability
	heroTimeLeft = table_player.ban_count_hero
	$("#PanelBanHeroes").style.opacity = "1" 
}

CustomNetTables.SubscribeNetTableListener( "ban_count", Updateban_table );
 
function Updateban_table(table, key, data ) 
{
	if (table == "ban_count") 
	{
		if (key == Players.GetLocalPlayer()) 
		{
			abilityTimeLeft = (data.ban_count_ability || 0)
			heroTimeLeft = (data.ban_count_hero || 0)
			$("#PanelBanHeroes").style.opacity = "1"
		}
	}
}

function UpdateBanPanelStart()
{
	let ban_count = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))
	if (ban_count && (ban_count.ban_count_ability || 0) > 0)
	{
		$("#PanelBanHeroes").style.opacity = "1"
	}
	if (ban_count == null)
	{
		$.Schedule(1 , UpdateBanPanelStart);
	}
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

function OpenBanPanel()
{
	if ($("#MainBlock").BHasClass("Hidden"))
	{	
		$("#DonateImage").style.opacity = "1"
	    $("#MainBlock").RemoveClass("Hidden")
	    var table_player = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))
		if (table_player)
		{
			abilityTimeLeft = table_player.ban_count_ability
			heroTimeLeft = table_player.ban_count_hero
		}
		if (GameUI.CustomUIConfig().CloseTeamList)
		{
			GameUI.CustomUIConfig().CloseTeamList()
		}
		StartTimerTeamList()
	} else {
		$("#DonateImage").style.opacity = "0"
		$("#MainBlock").AddClass("Hidden")
	    var table_player = CustomNetTables.GetTableValue("ban_count", String(Players.GetLocalPlayer()))
		if (table_player)
		{
			abilityTimeLeft = table_player.ban_count_ability
			heroTimeLeft = table_player.ban_count_hero
		}
		if (timer_close_right != -1) 
		{
			$.CancelScheduled(timer_close_right)
			timer_close_right = -1
		}
		if (GameUI.CustomUIConfig().OpenTeamList)
		{
			GameUI.CustomUIConfig().OpenTeamList()
		}
	}
}

function StartTimerTeamList()
{
	if (GameUI.CustomUIConfig().CloseTeamList) 
	{
		GameUI.CustomUIConfig().CloseTeamList()
	}
    if (Game.GetState() == DOTA_GameState.DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD || Game.GetState() ==  DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP)
    {
        timer_close_right = $.Schedule(0.01, StartTimerTeamList);
    }
}
 
// Создание героев

function Update_Heroes_Table() 
{
	Update_Heroes_Row($("#HeroesList"), "str");
	Update_Heroes_Row($("#HeroesList"), "agi");
	Update_Heroes_Row($("#HeroesList"), "int");
	Update_Heroes_Row($("#HeroesList"), "universal");
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
    
    if (type == "universal")
    {
    	parentPanel.FindChildTraverse("RowIcon").SetImage("file://{images}/primary_attribute_icons/primary_attribute_icon_all_psd.vtex");
    }

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
				heroImage = $.CreatePanel(`DOTAHeroImage`, heroButton, heroImageId, { scaling: "stretch-to-cover-preserve-aspect", heroname: String(rep_heroName), tabindex: "auto", heroimagestyle: "portrait" });
				heroImage.SetHasClass("hBlock", true);
				heroImage.SetHasClass("vBlock", true);
				heroImage.data = 
				{
					heroname: rep_heroName,
				}
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

function ClosePlayers(data)
{
	if (GameUI.CustomUIConfig().CloseTeamList)
	{
		GameUI.CustomUIConfig().CloseTeamList()
	}
}

(function() 
{
    GameEvents.Subscribe( "UpdatePassData", UpdatePassData );
    GameEvents.Subscribe( "UpdatebanHero", UpdatebanHero );
    GameEvents.Subscribe( "UpdatebanAbility", UpdatebanAbility );
    GameEvents.Subscribe( "ClosePlayers", ClosePlayers );
    UpdateBanPanelStart();
	Update_Heroes_Table();
})();