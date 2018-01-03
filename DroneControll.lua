local component = require "component"
local modem = component.modem
local event = require "event"
local running = true
function unknownEvent()end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(_, char, _, _)
	if char == string.byte("x") then
		running = false
	else
		modem.open(13438)
		modem.broadcast(13438, char)
		modem.close(13438)
	end
end

function handleEvent(eventID, ...)
	if (eventID) then -- can be nil if no event was pulled for some time
		myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
	end
end

while running do
	handleEvent(event.pull())
end