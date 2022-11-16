var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

GameUI.CustomUIConfig().OpenGuide = function ToggleGuide() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                first_time = true;
                $("#GuideWindow").AddClass("sethidden");
            }  
            if ($("#GuideWindow").BHasClass("sethidden")) {
                $("#GuideWindow").RemoveClass("sethidden");
            }
            $("#GuideWindow").AddClass("setvisible");
            $("#GuideWindow").style.visibility = "visible"
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#GuideWindow").BHasClass("setvisible")) {
                $("#GuideWindow").RemoveClass("setvisible");
            }
            $("#GuideWindow").AddClass("sethidden");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
                $("#GuideWindow").style.visibility = "collapse"
            })
        }
    }
}