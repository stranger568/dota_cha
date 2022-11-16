EventDriver = EventDriver or class({})


function EventDriver:Init()
    EventDriver.serverside_events = {}
end


function EventDriver:Dispatch(event_name, args_tbl)
    if not event_name then print("[Event Driver] no event name in dispatch") return end
    local callbacks = EventDriver.serverside_events[event_name]
    if not callbacks then print("[Event Driver] no callback in dispatch") return end
    for id, callback_info in pairs(callbacks) do
		if not callback_info[1] then
			print("[Event Driver] WARNING: callback of event", event_name, "at id", id, "is deleted! Unsubscribing...")
			EventDriver:CancelListener(event_name, id)
		else
			if callback_info[2] then
				if not callback_info[2].IsNull or not callback_info[2]:IsNull() then
					ErrorTracking.Try(callback_info[1], callback_info[2], args_tbl)
				else
					EventDriver:CancelListener(event_name, id)
				end
			else
				ErrorTracking.Try(callback_info[1], args_tbl)
			end
		end
    end
end


function EventDriver:Listen(event_name, callback, context)
    if not EventDriver.serverside_events[event_name] then
        EventDriver.serverside_events[event_name] = {}
    end
	-- since we are not removing callbacks from arrays (to not invalidate rest ids)
	-- but nulling them, we should check for those nulled callbacks 
	-- and reuse their ids
	for i = 1, #EventDriver.serverside_events[event_name] + 1 do
		local m_callback = EventDriver.serverside_events[event_name][i]
		if not m_callback then
			EventDriver.serverside_events[event_name][i] = {
				callback, context
			}
			EventDriver:ReportCreatedListener(callback, i, event_name)
			return i
		end
	end
    table.insert(EventDriver.serverside_events[event_name], {
        callback,
        context
    })
	local inserted_index = #EventDriver.serverside_events[event_name]
	EventDriver:ReportCreatedListener(callback, inserted_index, event_name)
	return inserted_index
end


function EventDriver:CancelListener(event_name, listener_id)
	local event_callbacks = EventDriver.serverside_events[event_name]
	if event_callbacks and event_callbacks[listener_id] then
		event_callbacks[listener_id] = nil
	end
end


function EventDriver:ReportCreatedListener(callback, id, event_name)
	if not callback then print("[Event Driver] No callback in creating listener!\n", debug.traceback()) return end
	local callback_info = debug.getinfo(callback)
	local traceback_line = callback_info.short_src .. ":" .. callback_info.linedefined
	--print("[Event Driver] Created listener of", event_name, "with id", id, "from:\n\t", traceback_line)
end


EventDriver:Init()
