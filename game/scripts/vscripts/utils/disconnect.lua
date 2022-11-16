Chadisconnect = class({})

function Chadisconnect:RegListeners()
    ListenToGameEvent( "player_disconnect", Dynamic_Wrap( self, 'OnDisconnect' ), self )
end

function Chadisconnect:OnDisconnect(table)
    local id = tonumber(table.PlayerID)
    Pass:PauseDisconnectPlayer(id)
end     