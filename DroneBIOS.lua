local drone = component.proxy(component.list("drone")())
local modem = component.proxy(component.list("modem")())

local down = 0
local up = 1
local back = 2
local front = 3
local right = 4
local left = 5
local power = true

local char_i = string.byte("i")
local char_w = string.byte("w")
local char_s = string.byte("s")
local char_a = string.byte("a")
local char_d = string.byte("d")
local char_r = string.byte("r")
local char_f = string.byte("f")
local char_t = string.byte("t")
local char_g = string.byte("g")
local char_y = string.byte("y")
local char_h = string.byte("h")
local char_u = string.byte("u")
local char_j = string.byte("j")
local remote_address = "1c4a9358-023a-469f-8a31-c78c76991f70"

function drop(count)
  checkArg(1, count, "nil", "number")
  return drone.drop(front, count)
end

function dropUp(count)
  checkArg(1, count, "nil", "number")
  return drone.drop(up, count)
end

function dropDown(count)
  checkArg(1, count, "nil", "number")
  return drone.drop(down, count)
end

function suck(count)
  checkArg(1, count, "nil", "number")
  return drone.suck(front, count)
end

function suckUp(count)
  checkArg(1, count, "nil", "number")
  return drone.suck(up, count)
end

function suckDown(count)
  checkArg(1, count, "nil", "number")
  return drone.suck(down, count)
end

function up()
  return drone.move(0,1,0)
end

function down()
  return drone.move(0,-1,0)
end

function left()
  return drone.move(0, 0, -1)
end

function right()
  return drone.move(0, 0, 1)
end

function forward()
  return drone.move(1, 0, 0)
end

function back()
  return drone.move(-1, 0, 0)
end

function unknownEvent()end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.modem_message(_, from, _, _, char)
  if from == remote_address then
    if (char == char_i) then
      power = false
    elseif (char == char_w) then
      forward()
    elseif (char == char_s) then
      back()
    elseif (char == char_a) then
      left()
    elseif (char == char_d) then
      right()
    elseif (char == char_r) then
      up()
    elseif (char == char_f) then
      down()
    elseif (char == char_t) then
      suck(64)
    elseif (char == char_g) then
      drop(64)
    elseif (char == char_y) then
      suckUp(64)
    elseif (char == char_h) then
      dropUp(64)
    elseif (char == char_u) then
      suckDown(64)
    elseif (char == char_j) then
      dropDown(64)
    end
  end
end

function handleEvent(eventID, ...)
  if (eventID) then
    myEventHandlers[eventID](...)
  end
end

modem.open(13438)
while power do
  handleEvent(computer.pullSignal())
end
modem.close(13438)