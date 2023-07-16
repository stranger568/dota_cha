function AbilitiesCooldownCheck() 
{
	if ($.GetContextPanel() && $.GetContextPanel().Data && $.GetContextPanel().Data.id)
	{
		$("#AvatarLocal").accountid = $.GetContextPanel().Data.id
		$("#NicknameLocal").accountid = $.GetContextPanel().Data.id
	}

	$.Schedule(5, AbilitiesCooldownCheck);
}
 
(function() {
	AbilitiesCooldownCheck();
})(); 