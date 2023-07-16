// Указывать кнопки на дефолтные предметы в функции GetDefaultKeybind

// thx nibuja05, edited stranger

// https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Panorama/Javascript/API
// дефолтные кнопки игрока можно взять из переменных DOTAKeybindCommand_t

// this.lockedKeybinds - массив отключает какие-то кнопки для использование ( те что нужны игроку дефолтные аля инвентарь или абилки)
// this.keyList - массив клавиш которые блокируются навсегда и их можно использовать для выбора в настройке клавиш

const humanFriendlyToActualKeyMap = {
    TAB: "tab",
    BACKSPACE: "backspace",
    ENTER: "enter",
    SPACE: "space",
    CAPSLOCK: "capslock",
    PAGEUP: "pgup",
    PAGEDOWN: "pgdn",
    END: "end",
    HOME: "home",
    INSERT: "ins",
    DELETE: "del",
    LEFT: "leftarrow",
    UP: "uparrow",
    RIGHT: "rightarrow",
    DOWN: "downarrow",
    "KEYPAD 0": "kp_0",
    "KEYPAD 1": "kp_1",
    "KEYPAD 2": "kp_2",
    "KEYPAD 3": "kp_3",
    "KEYPAD 4": "kp_4",
    "KEYPAD 5": "kp_5",
    "KEYPAD 6": "kp_6",
    "KEYPAD 7": "kp_7",
    "KEYPAD 8": "kp_8",
    "KEYPAD 9": "kp_9",
    "KEYPAD /": "kp_divide",
    "KEYPAD +": "kp_plus",
    "KEYPAD -": "kp_minus",
    "KEYPAD *": "kp_multiply",
    "KEYPAD ENTER": "kp_enter",
};


var keys_list_b = {}

function ConvertHumanFriendlyToActual(key) {
    return humanFriendlyToActualKeyMap[key] || key.toLowerCase();
}

GameUI.CustomUIConfig().OpenKeybind = function OnSettingsOpen() {
    let settings = $("#SettingsRoot");
    if (settings.BHasClass("open")) {
        OnSettingsClose();
        return;
    }
    settings.AddClass("open");
    settings.RemoveClass("closing");
}

function OnSettingsClose() {
    let settings = $("#SettingsRoot");
    settings.RemoveClass("open");
    settings.AddClass("closing");
    $.Schedule(0.4, () => {
        settings.RemoveClass("closing");
    });
}

let keybindRefs = new Map();

function RefreshKeybindSettings()
 
    {
    let keylist = $("#SettingsKeybindsList");
    keylist.RemoveAndDeleteChildren()
    for (let [name, [key, func]] of keybinds) {
        if (!keybindRefs.has(name)) {
            const keybind = new PanoramaKeybind(name, key, func, keylist);
            keybindRefs.set(name, keybind);
        }
        else {
            const keybind = keybindRefs.get(name);
            if (keybind.key !== key)
                keybind.changeKeybind(key);
            keybind.updateCallback(func);
        }
    }
}

class PanoramaKeybind {
    constructor(name, key, callback, parent) {
        this.name = name;
        this.key = key;
        this.callback = callback;
        const newPanel = $.CreatePanel("Panel", parent, "");
        newPanel.BLoadLayoutSnippet("CustomKeyRegister");
        const title = newPanel.FindChild("CustomKeybindTitle");
        title.text = $.Localize("#keybind_" + name);
        const preview = newPanel.FindChildTraverse("title");
        preview.text = this.localizePreviewLetter();
        this.keyLabel = newPanel.FindChildTraverse("value");
        this.keyLabel.text = key;
        this.button = newPanel.FindChildTraverse("CustomBinder");
        this.button.SetPanelEvent("onactivate", () => this.onClick());
        let cancel = newPanel.FindChildTraverse("BindingClose");
        cancel.SetPanelEvent("onactivate", () => {
            this.button.RemoveClass("active");
            KeyEvents.StopListeningToKeybindChange();
        });
    }
    onClick() {
        if (KeyEvents.IsListeningToKeybindChange())
            return;
        this.button.AddClass("active");
        KeyEvents.ListenToKeybindChange((newKey) => this.changeKeybind(newKey));
    }
    changeKeybind(newKey, replaceOld = true) {
        this.button.RemoveClass("active");
        this.keyLabel.text = newKey.toUpperCase();
        KeyEvents.UnregisterKeybind(this.key);
        if (replaceOld) {
            for (const [_, keybind] of keybindRefs) {
                if (keybind === this)
                    continue;
                if (keybind.key === newKey) {
                    keybind.changeKeybind(this.key, false);
                }
            }
        }
        this.key = newKey;
        AddNewKeybind(newKey, this.name, this.callback);
    }
    updateCallback(callback) {
        if (callback === this.callback)
            return;
        this.callback = callback;
    }
    localizePreviewLetter() {
        let previewLetter
        previewLetter = $.Localize("keybind_" + this.name).slice(0, 1);
        return "";
    }
}

function GetGameKeybind(command) {
    if (command == null || command == undefined)
    {
        return ""
    }
    return Game.GetKeybindForCommand(command);
}

let keybinds = new Map();

function AddNewKeybind(key, name, func, ability_save) 
{ 
    key = ConvertHumanFriendlyToActual(key);
    GameEvents.SendCustomGameEventToServer("custom_keybind_changed", { name: name, key: key });
    const successful = KeyEvents.RegisterKeybind(key, func);
    keybinds.set(name, [successful ? key : "", func]);
    //GameEvents.SendEventClientSide("on_keybind_changed", { name: name, key: successful ? key : "" });
}

class KeyLogger {
    constructor() {
        this.keyList = [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "b",
            "c",
            "n",
            "v",
            "x",
            "z",
            "0",
            "a",
            "d",
            "e",
            "f",
            "g",
            "h",
            "i",
            "j",
            "k",
            "l",
            "m",
            "o",
            "p",
            "q",
            "r",
            "s",
            "t",
            "u",
            "w",
            "pgup",
            "pgdn",
            "end",
            "home",
            "ins",
            "del",
            "leftarrow",
            "uparrow",
            "rightarrow",
            "downarrow",
            "kp_0",
            "kp_1",
            "kp_2",
            "kp_3",
            "kp_4",
            "kp_5",
            "kp_6",
            "kp_7",
            "kp_8",
            "kp_9",
            "kp_divide",
            "kp_plus",
            "kp_minus",
            "kp_del",
            "f1",
            "f2",
            "f3",
            "f4",
            "f5",
            "f6",
            "f7",
            "f9",
            "f10",
            "f11",
            "f12",
            "mouse1",
            "mouse2",
            "mouse4",
            "mouse6",
            "mouse7",
            "mouse8",
            "mouse9",
            "mouse10",
            "mouse11",
        ];
        this.lockedKeybinds = [
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1_QUICKCAST_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY2_QUICKCAST_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY3_QUICKCAST_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY1_QUICKCAST_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2_QUICKCAST_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE_QUICKCAST_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1_AUTOMATIC_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY2_AUTOMATIC_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY3_AUTOMATIC_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY1_AUTOMATIC_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2_AUTOMATIC_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE_AUTOMATIC_AUTOCAS ),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY3),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY4),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY5),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY6),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYNEUTRAL),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY2_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY3_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY4_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY5_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY6_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYNEUTRAL_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY2_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY3_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY4_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY5_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY6_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYNEUTRAL_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY2_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY3_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY4_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY5_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY6_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYNEUTRAL_QUICKAUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SHOP_TOGGLE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_ATTACK),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_STOP),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_HOLD),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_SELECT),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_PAUSE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_SELECT_ALL),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_SELECT_ALL_OTHERS),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_TEAM),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_TEAM2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_GLOBAL),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_GLOBAL2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_VOICE_PARTY),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_VOICE_TEAM),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY3),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY1),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY2_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY3_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY1_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE_QUICKCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY2_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY3_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY1_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2_EXPLICIT_AUTOCAST),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_ESCAPE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_PURCHASE_QUICKBUY),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_PURCHASE_STICKY),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SCOREBOARD_TOGGLE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP1),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP3),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP4),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP5),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP6),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP7),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP8),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP9),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP10),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUPCYCLE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUPCYCLE),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SELECT_ALLY1),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SELECT_ALLY2),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SELECT_ALLY3),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SELECT_ALLY4),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_SELECT_ALLY5),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_LEARN_ABILITIES),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_LEARN_STATS),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INSPECTHEROINWORLD),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_FIRST),  
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CAMERA_UP),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CAMERA_DOWN),  
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CAMERA_LEFT),  
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CAMERA_RIGHT ),  
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CAMERA_GRIP),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_TAUNT),
            GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_GRAB_STASH_ITEMS),
        ];
        this.keybinds = new Map();
        for (let index = 0; index < this.lockedKeybinds.length; index++) {
            if (this.lockedKeybinds[index] != null && this.lockedKeybinds[index] != undefined)
            {
                this.lockedKeybinds[index] = ConvertHumanFriendlyToActual(this.lockedKeybinds[index]);
                const keyListIndex = this.keyList.indexOf(this.lockedKeybinds[index]);
                if (keyListIndex !== -1) {
                    delete this.keyList[keyListIndex];
                }
            }
        }

        for (let key of this.keyList) {
            if (key) {
                const name_bind = "key_" + Math.floor(Math.random() * 99999999) + key;
                Game.AddCommand(name_bind, () => {
                    this.HandleKeyPressed(key);
                }, "", 0);
                Game.CreateCustomKeyBind(key, name_bind);
            }
        }

        keys_list_b = this.keyList
    }
    HandleKeyPressed(key) {
        if (this.listeningToKeybindChange) {
            this.listeningToKeybindChange(key);
            this.StopListeningToKeybindChange();
        }
        else {
            const keybind = this.keybinds.get(key);
            if (keybind) {
                keybind();
            }
        }
    }
    RegisterKeybind(key, func) {
        if (this.keyList.includes(key)) {
            this.keybinds.set(key, func);
            return true;
        }
        return false;
    }
    UnregisterKeybind(key) {
        this.keybinds.delete(key);
    }
    ListenToKeybindChange(callback) {
        this.listeningToKeybindChange = callback;
    }
    IsListeningToKeybindChange() {
        return this.listeningToKeybindChange !== undefined;
    }
    StopListeningToKeybindChange() {
        this.listeningToKeybindChange = undefined;
    }
}

let KeyEvents = new KeyLogger();
let checkboxCallbacks = new Map();
let checkBoxes = [];
$.RegisterForUnhandledEvent("StyleClassesChanged", (panel) => {
    if (!checkBoxes.includes(panel))
        return;
    let state = panel.checked;
    checkboxCallbacks.get(panel)(state);
});

function GetDefaultKeybind(name) {
    switch (name) {
        case "cast_ability_7":
            return "kp_0"
        case "cast_ability_8":
            return "kp_1"
        case "cast_ability_9":
            return "kp_2"
        case "cast_ability_10":
            return "kp_3"
        case "cast_ability_11":
            return "kp_4"
        case "cast_ability_12":
            return "kp_5"
        case "cast_ability_13":
            return "kp_6"
        case "cast_ability_14":
            return "kp_7"
        case "cast_ability_15":
            return "kp_8"
        case "cast_ability_16":
            return "kp_9"
    }
}

















function ResetKeybinds() {
   //let ability_setted = 0
   //let buttons = keys_list_b
   //for (const [name, keybind] of keybindRefs) {
   //    for (let index = 0; index < buttons.length; index++) {
   //        if (buttons[index] != null && buttons[index] != undefined)
   //        {
   //            buttons[index] = ConvertHumanFriendlyToActual(buttons[index]);
   //            if (keybind.key !== buttons[index]) {
   //                keybind.changeKeybind(buttons[index], false);
   //            }
   //            delete buttons[index];
   //            break
   //        }
   //    } 
   //}
}

function UpdateSkillBar()
{
    for (const [name, keybind] of keybindRefs) 
    {
        let hud_abilities = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements")
        let hud_abilities_panel = hud_abilities.FindChildTraverse("abilities")
        let ability_number = Number(name.replace("cast_ability_", '')) - 1;

        if (hud_abilities_panel) {
            let abil_panel = hud_abilities_panel.FindChildTraverse("Ability" + ability_number)
            if (abil_panel) {
                let Hotkey = abil_panel.FindChildTraverse("Hotkey")
                if (Hotkey)
                {
                    Hotkey.style.visibility = "visible"
                }
                let HotkeyText = abil_panel.FindChildTraverse("HotkeyText")
                if (HotkeyText)
                {
                    HotkeyText.text = String(keybind.key).toUpperCase()
                }
            }
        }
    }
    $.Schedule(1, UpdateSkillBar)
}

var locked_keys = {}

function GetKeyBindFree(key)
{
    if (locked_keys[key] == null || locked_keys[key] == undefined)
    {
        locked_keys[key] = true
        return key
    }
    for (let index = 0; index < keys_list_b.length; index++) 
    {
        if (keys_list_b[index] != null && keys_list_b[index] != undefined && (locked_keys[keys_list_b[index]] == null || locked_keys[keys_list_b[index]] == undefined))
        {
            keys_list_b[index] = ConvertHumanFriendlyToActual(keys_list_b[index]);
            locked_keys[keys_list_b[index]] = true
            return keys_list_b[index]
        }
    }
}

function SetKeyBind()
{
    let player_table_keybinds = CustomNetTables.GetTableValue("player_info", "setting_data_" + Players.GetLocalPlayer())
    let ability_setted = 0 

    for (let index = 0; index < keys_list_b.length; index++) 
    {
        if (player_table_keybinds && player_table_keybinds.keybinds && player_table_keybinds.keybinds[ability_setted + 1] && player_table_keybinds.keybinds[ability_setted +1] != "")
        {
            ability_setted = ability_setted + 1

            if (ability_setted >= 11) 
            {
                break
            }

            player_table_keybinds.keybinds[ability_setted] = ConvertHumanFriendlyToActual(player_table_keybinds.keybinds[ability_setted]);
  
            if (ability_setted == 1)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_7", () => CastAbility1());
            }
            if (ability_setted == 2)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_8", () => CastAbility2());
            }
            if (ability_setted == 3)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_9", () => CastAbility3());
            }
            if (ability_setted == 4)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_10", () => CastAbility4());
            }
            if (ability_setted == 5)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_11", () => CastAbility5());
            }
            if (ability_setted == 6)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_12", () => CastAbility6());
            }
            if (ability_setted == 7)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_13", () => CastAbility7());
            }
            if (ability_setted == 8)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_14", () => CastAbility8());
            }
            if (ability_setted == 9)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_15", () => CastAbility9());
            }
            if (ability_setted == 10)
            {
                AddNewKeybind(GetKeyBindFree(player_table_keybinds.keybinds[ability_setted]), "cast_ability_16", () => CastAbility10());
            } 
        } else {
            if (keys_list_b[index] != null && keys_list_b[index] != undefined)
            {
                ability_setted = ability_setted + 1

                if (ability_setted >= 11) 
                {
                    break
                } 

                keys_list_b[index] = ConvertHumanFriendlyToActual(keys_list_b[index]);

                if (ability_setted == 1)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_7", () => CastAbility1());
                }
                if (ability_setted == 2)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_8", () => CastAbility2());
                }
                if (ability_setted == 3)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_9", () => CastAbility3());
                }
                if (ability_setted == 4)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_10", () => CastAbility4());
                }
                if (ability_setted == 5)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_11", () => CastAbility5());
                }
                if (ability_setted == 6)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_12", () => CastAbility6());
                }
                if (ability_setted == 7)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_13", () => CastAbility7());
                }
                if (ability_setted == 8)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_14", () => CastAbility8());
                }
                if (ability_setted == 9)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_15", () => CastAbility9());
                }
                if (ability_setted == 10)
                {
                    AddNewKeybind(GetKeyBindFree(keys_list_b[index]), "cast_ability_16", () => CastAbility10());
                }   
            }
        }
    }
}

SetKeyBind()
RefreshKeybindSettings();
UpdateSkillBar()
//ResetKeybinds();

function IsValidAbilityCheck(abilityIndex) {

    var result = false;
    var abilityName = Abilities.GetAbilityName(abilityIndex);
    if (abilityName!=null && abilityName != "" && abilityName.substring(0, 14) != "special_bonus_" && abilityName!= "generic_hidden" && abilityName.substring(0, 6) != "empty_" )
    {
        if (!Abilities.IsHidden(abilityIndex))
        {
           result = true; 
        }
    }

    return result;
}

function CastAbility1() {
	let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

	let abilities_list = [];

    for (var i = 6; i <= 30; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
        	abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[0])
    {
    	Abilities.ExecuteAbility(abilities_list[0], playerHeroIndex, true);
    }
}

function CastAbility2() {
	let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

	let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
        	abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[1])
    {
    	Abilities.ExecuteAbility(abilities_list[1], playerHeroIndex, true);
    }
}

function CastAbility3() {
	let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

	let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
        	abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[2])
    {
    	Abilities.ExecuteAbility(abilities_list[2], playerHeroIndex, true);
    }
}

function CastAbility4() {
	let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

	let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
        	abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[3])
    {
    	Abilities.ExecuteAbility(abilities_list[3], playerHeroIndex, true);
    }
}

function CastAbility5() {
    let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

    let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
            abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[4])
    {
        Abilities.ExecuteAbility(abilities_list[4], playerHeroIndex, true);
    }
}

function CastAbility6() {
    let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

    let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
            abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[5])
    {
        Abilities.ExecuteAbility(abilities_list[5], playerHeroIndex, true);
    }
}

function CastAbility7() {
    let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

    let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
            abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[6])
    {
        Abilities.ExecuteAbility(abilities_list[6], playerHeroIndex, true);
    }
}

function CastAbility8() {
    let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

    let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
            abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[7])
    {
        Abilities.ExecuteAbility(abilities_list[7], playerHeroIndex, true);
    }
}

function CastAbility9() {
    let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

    let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
            abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[8])
    {
        Abilities.ExecuteAbility(abilities_list[8], playerHeroIndex, true);
    }
}

function CastAbility10() {
    let playerHeroIndex = Players.GetLocalPlayerPortraitUnit()

    let abilities_list = [];

    for (var i = 6; i <= 60; i++) {
        var ability = Entities.GetAbility(playerHeroIndex, i);
        var abilityName = Abilities.GetAbilityName(ability);
        if (IsValidAbilityCheck(ability)) 
        {
            abilities_list.push(ability)
        }      
    }

    if (abilities_list && abilities_list[9])
    {
        Abilities.ExecuteAbility(abilities_list[9], playerHeroIndex, true);
    }
}