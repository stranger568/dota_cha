function CreatQuest(data) {
    newPanel = $.CreatePanel('Panel', $('#QuestPanel'), data.name);
    newPanel.BLoadLayoutSnippet("QuestLine");
    newPanel.AddClass("Panle_MarginStyle")
    RefreshQuest(data)
}

function RefreshQuest(data) {

    var panleId = data.name
    var panleSvalue = data.svalue
    var panleEvalue = data.evalue
    
    var questPanle = $('#QuestPanel').FindChild(panleId)
    var valuePercent = parseInt(panleSvalue) / parseInt(panleEvalue) * 100;
    if (questPanle) {
        sliderPanle = questPanle.GetChild(0);
        sliderPanle.GetChild(0).style.width = valuePercent.toString() + "%"
        sliderPanle.GetChild(1).style.width = (100 - valuePercent).toString() + "%"
        questPanle.GetChild(1).GetChild(0).text = panleText

        var panleText = $.Localize(data.text, questPanle.GetChild(1).GetChild(0)) + "(" + panleSvalue + "/" + panleEvalue + ")"
        if (data.text_value!=undefined)
        {
            panleText=panleText.replace("[!s:value]",data.text_value)
        }
        if (data.text_value_2!=undefined)
        {
            panleText=panleText.replace("[!s:value_2]",$.Localize(data.text_value_2))
        }

        if (data.unique!=undefined)
        {
            questPanle.GetChild(1).GetChild(0).text = data.text_value + " " + $.Localize(data.text_value_2) + "<br>" + panleText
        } else {
            questPanle.GetChild(1).GetChild(0).text = panleText
        }
    }
}




function RemoveQuest(data) {

    var removePanleList = $('#QuestPanel').FindChildrenWithClassTraverse("QuestLine")
    //遍历全部 移除
    for (var i = 0; i < removePanleList.length; i++) {
        if (removePanleList[i].id==data.name)
        {
            removePanleList[i].DeleteAsync(0)
        }
    }

}


(function () {
    GameEvents.Subscribe("CreateQuest", CreatQuest);
    GameEvents.Subscribe("RefreshQuest", RefreshQuest);
    GameEvents.Subscribe("RemoveQuest", RemoveQuest);
})();