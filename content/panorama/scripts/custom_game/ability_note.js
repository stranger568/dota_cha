var base;
var tooltipManager;
var ability_tooltip;
var details;
var ad_label;
var ad_scepter_container;
var ad_scepter_label;
var ad_shard_container;
var ad_shard_label;
var ability_name;
var ad_container;
var prev_ability_name;
var prev_time;
var prev_height;
var screen_height;
var l_arrow, r_arrow;

var registered_abilities = {};

function _ParseHeight(css_line) {
	const values = css_line.slice(css_line.indexOf("(") + 2, css_line.length - 1).split(" ");
	const height = values[1];
	return height.slice(0, height.length - 4);
}

function RegisterHoverableAbility(data) {
	var  loc_name = $.Localize("#DOTA_Tooltip_ability_" + data.ability_name).toUpperCase() 
	registered_abilities[loc_name.toUpperCase()] = data.ability_name;
}

// real magic begins here, since tooltip is moved with translate3d instead of position set,
// we need to parse height value and reduce it to accomodate tooltip height changes
// but only if tooltip actually overflowing screen
function RealignTooltipBlock(fast_hover, value) {
	const parsed_height = _ParseHeight(ability_tooltip.style.transform);
	const float_value = parseFloat(parsed_height);
	let ad_content_height = value;
	if (!ad_content_height) {
		ad_content_height = ad_container.contentheight;
	}

	if (float_value + ability_tooltip.contentheight > screen_height && !fast_hover) {
		ability_tooltip.style.transform = ability_tooltip.style.transform
			.replace(parsed_height, float_value - ad_content_height)
			.replace(/x /g, "x,");

		// same goes for arrows, but only if they are visible
		// also style string from .transform is returned without commas
		// but setter for .transform requires them, otherwise throws errors
		// splendid system!
		if (l_arrow.visible) {
			const l_arrow_height = _ParseHeight(l_arrow.style.transform);
			l_arrow.style.transform = l_arrow.style.transform
				.replace(l_arrow_height, parseFloat(l_arrow_height) + ad_content_height)
				.replace(/x /g, "x,");
		}
		if (r_arrow.visible) {
			const r_arrow_height = _ParseHeight(r_arrow.style.transform);
			r_arrow.style.transform = r_arrow.style.transform
				.replace(r_arrow_height, parseFloat(r_arrow_height) + ad_content_height)
				.replace(/x /g, "x,");
		}
		return ad_content_height;
	}
}

function TooltipTextChanged(data) {
	const new_text = ability_name.text;
	const fast_hover = Game.GetGameTime() - prev_time < 0.1;
	// filter calls that occur too fast (cause for some reason LocalizationChanged triggers 2 times per actual change)
	// and only if they have same name
	if (prev_ability_name == new_text && fast_hover) {	
		return;
	}
	if (prev_height) {
		RealignTooltipBlock(fast_hover, -prev_height);
		prev_height = undefined;
	}

	if (!(new_text in registered_abilities)) {
		ability_tooltip.SetHasClass("AbilityDraftDetails", false);
		return;
	}

	const ad_note_loc_token = `#DOTA_Tooltip_ability_${registered_abilities[new_text]}_ability_note`;
	let ad_note_loc_string = $.Localize(ad_note_loc_token);
	const ad_note_localized = ad_note_loc_token != ad_note_loc_string;

	if (ad_note_localized) {
		ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(registered_abilities[new_text], ad_note_loc_string); // Technically probably not needed, but just in case some ability will have an ability special somehow. Can't hurt ;)
		ad_label.SetDialogVariable("ability_draft_note", ad_note_loc_string);
		ad_label.style.visibility = "visible";
	} else {
		ad_label.style.visibility = "collapse";
	}

	const ad_scepter_loc_token = `#DOTA_Tooltip_ability_${registered_abilities[new_text]}_scepter_description`;
	let ad_scepter_loc_string = $.Localize(ad_scepter_loc_token);
	const ad_scepter_localized = ad_scepter_loc_token != ad_scepter_loc_string && ad_scepter_loc_string!="";

	if (ad_scepter_localized) {
		ad_scepter_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(
			registered_abilities[new_text],
			ad_scepter_loc_string,
		);
		ad_scepter_container.style.visibility = "visible";
		ad_scepter_label.SetDialogVariable("ability_draft_scepter", ad_scepter_loc_string);
	} else {
		ad_scepter_container.style.visibility = "collapse";
	}

	const ad_shard_loc_token = `#DOTA_Tooltip_ability_${registered_abilities[new_text]}_shard_description`;
	let ad_shard_loc_string = $.Localize(ad_shard_loc_token);
	const ad_shard_localized = ad_shard_loc_token != ad_shard_loc_string && ad_shard_loc_string != "";

	if (ad_shard_localized) {
		ad_shard_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(
			registered_abilities[new_text],
			ad_shard_loc_string,
		);
		ad_shard_container.style.visibility = "visible";
		ad_shard_label.SetDialogVariable("ability_draft_shard", ad_shard_loc_string);
	} else {
		ad_shard_container.style.visibility = "collapse";
	}

	const ad_block_present = ad_note_localized || ad_scepter_localized || ad_shard_localized;

	if (ad_block_present) {
		$.Schedule(Game.GetGameFrameTime(), () => {
			prev_height = RealignTooltipBlock(fast_hover);
		});
	} else {
		prev_height = undefined;
	}

	ability_tooltip.SetHasClass("AbilityDraftDetails", ad_block_present);
	prev_ability_name = new_text;
	prev_time = Game.GetGameTime();
}
function Init() {
	if (!base) {
		base = dotaHud;
	}
	if (!tooltipManager) {
		tooltipManager = base.FindChildTraverse("Tooltips");
	}
	ability_tooltip = tooltipManager.FindChildTraverse("DOTAAbilityTooltip");
	if (!ability_tooltip) {
		// tooltip for ability initializes first time ability is hovered
		$.Schedule(0.3, Init); // so search for it is not that reliable without retries
		return;
	}
	details = ability_tooltip.FindChildrenWithClassTraverse("TooltipRow")[0];
	l_arrow = details.GetChild(0);
	r_arrow = details.GetChild(2);
	details = details.GetChild(1);
	details = details.FindChildTraverse("AbilityDetails");
	ad_container = details.FindChildTraverse("AbilityDraftDescriptionContainer");
	ad_label = ad_container.GetChild(3);
	ability_name = details.FindChildTraverse("AbilityName");

	ad_scepter_container = details.FindChildTraverse("ScepterDesc");
	ad_scepter_label = ad_scepter_container.GetChild(1);

	ad_shard_container = details.FindChildTraverse("ShardDesc");
	ad_shard_label = ad_shard_container.GetChild(1);

	const header = details.FindChildTraverse("AbilityName");
	screen_height = Game.GetScreenHeight();
	$.RegisterEventHandler("LocalizationChanged", header, function () {
		$.Schedule(0.01, TooltipTextChanged);
	});
}

function PortraitUnitChanged() {
	const unit = Players.GetLocalPlayerPortraitUnit();
	if (!Entities.IsRealHero(unit)) {
		return;
	}
	for (i = 0; i < Entities.GetAbilityCount(unit); i++) {
		const ability = Entities.GetAbility(unit, i);
		if (ability && ability != -1 && !Abilities.IsHidden(ability)) {
			const ability_name = Abilities.GetAbilityName(ability);
			if (ability_name.match("special_bonus")) {
				continue;
			}
			RegisterHoverableAbility({
				ability_name: ability_name,
			});
		}
	}
}

(function () {


	$.Schedule(2, function () {
		GameEvents.Subscribe("RegisterHoverableAbility", RegisterHoverableAbility);
		GameEvents.Subscribe("dota_portrait_ability_layout_changed", PortraitUnitChanged);
		GameEvents.Subscribe("dota_player_update_selected_unit", PortraitUnitChanged);
	});
	$.Schedule(1, function () {
		Init();
	});
})();

