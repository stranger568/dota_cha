pause_owner_check()

function pause_owner_check()
{

  let owner_table = CustomNetTables.GetTableValue("pause_owner", "owner")
  if (owner_table)
  {
    
    if (typeof owner_table.owner !== 'undefined')
    {
      if (Game.GetPlayerInfo( owner_table.owner ) && Game.GetPlayerInfo( owner_table.owner ).player_steamid)
      {
          $("#PauseAvatar").steamid = Game.GetPlayerInfo( owner_table.owner ).player_steamid
          $("#PauseName").steamid = Game.GetPlayerInfo( owner_table.owner ).player_steamid
      }
    }
  }

  if (Game.IsGamePaused())
  {
    $("#PauseOwner").style.visibility = "visible"
  } else {
    $("#PauseOwner").style.visibility = "collapse"
  }

  $.Schedule(1/144, pause_owner_check)
}