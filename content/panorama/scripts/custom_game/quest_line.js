function RefreshQuest(data) 
{
    let round_name = data.text_value_2
    let creep_kill = data.svalue
    let creep_count = data.evalue

    $("#QuestPanel").style.opacity = "1"

    if ((typeof round_name !== 'undefined') && (typeof creep_kill !== 'undefined') && (typeof creep_count !== 'undefined'))
    {
        $("#RoundName").text = $.Localize(round_name)
        $("#KillsInfo").text = "Убито " + creep_kill + " / " + creep_count
        //$("#RoundPanel").style.backgroundImage = 'url("file://{images}/custom_game/rounds/' + round_name.replace("#", '') + '.png")';
        //$("#RoundPanel").style.backgroundSize = '100%';
    } else if ((typeof round_name !== 'undefined'))
    {
       $("#RoundName").text = $.Localize(round_name) 
       $("#KillsInfo").text = ""
       //$("#RoundPanel").style.backgroundImage = 'url("file://{images}/custom_game/rounds/' + round_name.replace("#", '') + '.png")';
       //$("#RoundPanel").style.backgroundSize = '100%';
    }

    if ((typeof data.text_value !== 'undefined'))
    {
        $("#RoundLabel").text = data.text_value
    }
}

function RefreshPrepare(data) 
{
    let round_name = data.text_value_2
    let time = data.svalue
    let full_time = data.evalue

    if (data.svalue == 0)
    {
        $("#LinePanelActive").SetHasClass("LinePanelActive_anim", false)
    } else {
        $("#LinePanelActive").SetHasClass("LinePanelActive_anim", true)
    }

    var percent = ((full_time-time)*100)/full_time

    if (percent != "NaN") 
    {
        $("#LinePanelActive").style['width'] = percent +'%';
    }

    $("#QuestPanel").style.opacity = "1"

    if ((typeof round_name !== 'undefined'))
    {
       $("#RoundName").text = $.Localize(round_name) 
       $("#KillsInfo").text = ""
       $("#RoundPanel").style.backgroundImage = 'url("file://{images}/custom_game/rounds/' + round_name.replace("#", '') + '.png")';
       $("#RoundPanel").style.backgroundSize = '100%';
    }

    if ((typeof data.text_value !== 'undefined'))
    {
        $("#RoundLabel").text = data.text_value
    }

    $("#LinePanelActive").SetHasClass("color_round", false)
    $("#LinePanelActive").SetHasClass("color_prepare", true)
    $("#WaveInfoDurationCurrentState").text = $.Localize("#next_wave_timer")

    var times = full_time-time
    var min = Math.trunc((times)/60) 
    var sec_n =  (times) - 60*Math.trunc((times)/60) 
    var hour = String( Math.trunc((min)/60) )
    var min = String(min - 60*( Math.trunc(min/60) ))
    var sec = String(sec_n)
    if (sec_n < 10) 
    {
        sec = '0' + sec
    }

    $("#RoundTime").text=min + ':' + sec

    if ((typeof data.abilities !== 'undefined'))
    {
        $("#AbilitiesRound").RemoveAndDeleteChildren()
        for (var i = 1; i <= Object.keys(data.abilities).length; i++) 
        {
            var ability_panel = $.CreatePanel('DOTAAbilityImage', $("#AbilitiesRound"), '');
            ability_panel.abilityname = data.abilities[i];
            ability_panel.AddClass('RoundAbility');
            SetShowAbDesc(ability_panel, data.abilities[i]);
        }
    }
}

function SetShowAbDesc(panel, ability)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowAbilityTooltip', panel, ability); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideAbilityTooltip', panel);
    });       
}

function UpdateRoundTimer(data)
{
    let time = data.svalue
    let full_time = data.evalue

    if (data.svalue == full_time)
    {
        $("#LinePanelActive").SetHasClass("LinePanelActive_anim", false)
    } else {
        $("#LinePanelActive").SetHasClass("LinePanelActive_anim", true)
    }

    $("#LinePanelActive").SetHasClass("color_round", true)
    $("#LinePanelActive").SetHasClass("color_prepare", false)

    var percent = ((full_time-time)*100)/full_time

    if (percent != "NaN") 
    {
        $("#LinePanelActive").style['width'] = (100 - percent) +'%';
    } else {
       $("#LinePanelActive").style['width'] = '0%'; 
    }

    $("#QuestPanel").style.opacity = "1"


    if ((typeof data.berserk !== 'undefined') && data.berserk != 0)
    {
        $("#RoundTime").text = data.berserk
        $("#WaveInfoDurationCurrentState").text = $.Localize("#berserk_wave_timer")
    }
    else
    {
        $("#WaveInfoDurationCurrentState").text = $.Localize("#end_wave_timer")
        var times = time
        var min = Math.trunc((times)/60) 
        var sec_n =  (times) - 60*Math.trunc((times)/60) 
        var hour = String( Math.trunc((min)/60) )
        var min = String(min - 60*( Math.trunc(min/60) ))
        var sec = String(sec_n)
        if (sec_n < 10) 
        {
            sec = '0' + sec
        }
        $("#RoundTime").text=min + ':' + sec
    }
}

(function() 
{
    GameEvents.Subscribe("RefreshQuest", RefreshQuest);
    GameEvents.Subscribe("RefreshPrepare", RefreshPrepare);
    GameEvents.Subscribe("UpdateRoundTimer", UpdateRoundTimer);
})();