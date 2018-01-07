local event = require("event")
local thread = require("thread")
local internet = require("internet")
local json = require("json")
local urlencode = require("urlencode")
local chat_box = require("component").chat_box
local debug = require("component").debug
bot_token = "507736545:AAFt5B65i_5DfAdiL_HZqgJlmhyqOpXE2dY"
local running = true -- state variable so the loop can terminate
local offsetID = 0
function unknownEvent()
  -- do nothing if the event wasn't relevant
end

-- table that holds all event handlers
-- in case no match can be found returns the dummy function unknownEvent
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

-- Example key-handler that simply sets running to false if the user hits space
function myEventHandlers.key_up(_, char, _, _)
  if (char == char_space) then
    running = false
  end
end

function myEventHandlers.chat_message(_,username, message)
  url = "https://api.telegram.org/bot" .. bot_token .. "/sendMessage?chat_id=-313329315&text=[Minecraft->Telegram][" .. username .. "] " .. message
  url = urlencode.string(url)
  print(url)
  internet.request(url)
end

-- The main event handler as function to separate eventID from the remaining arguments
function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end

local threadToTelegram = thread.create(function()
    while running do
        handleEvent(event.pull()) -- sleeps until an event is available, then process it
    end
end)
-- main event loop which processes all events, or sleeps if there is nothing to do
while running do
    local request = internet.request("https://api.telegram.org/bot" .. bot_token .. "/getUpdates?offset=" .. offsetID)
    local counter = 0
    while counter < 10 do
      read = request.read()
      if read == "" then
        counter=counter + 1
        os.sleep(1)
      else
        break
      end
    end
	if read == "" then
		local decoded = json.decode(read)
		for k, v in pairs(decoded.result) do
		  if v.message then
			if v.message.entities ~= nil and v.message.entities[1].type == "bot_command" then
			  url = "https://api.telegram.org/bot" .. bot_token .. "/getChatMember?chat_id=-313329315&user_id=" .. v.message.from.id
			  url = urlencode.string(url)
			  local request = internet.request(url)
			  counter = 0
			  while counter < 10 do
				read=request.read()
				if read == "" then
				  counter=counter + 1
				  os.sleep(1)
				else
				  break
				end
			  end
			  if read ~= "" and read ~= nil then
				local decoded2 = json.decode(read)
				if decoded2.result.status == "administrator" or decoded2.result.status == "creator" then
				  debug.runCommand(v.message.text)
				else
				  internet.request("https://api.telegram.org/bot" .. bot_token .. "/sendMessage?chat_id=-313329315&text=You+do+not+have+permission+to+use+this+command")
				end
			  end
			elseif v.message.text~=nil then
			  chat_box.setName(v.message.from.username)
			  chat_box.say(v.message.text)
			end
			offsetID=v.update_id+1
		  end
		end
	end
    os.sleep(1)
end
