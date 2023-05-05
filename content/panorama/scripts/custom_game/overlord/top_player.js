function AbilitiesCooldownCheck() 
{
	if ($.GetContextPanel() && $.GetContextPanel().Data && $.GetContextPanel().Data.id)
	{
		$("#AvatarLocal").accountid = $.GetContextPanel().Data.id
		$("#NicknameLocal").accountid = $.GetContextPanel().Data.id
	}

	$.Schedule(1, AbilitiesCooldownCheck);
}
 
(function() {
	AbilitiesCooldownCheck();
})(); 