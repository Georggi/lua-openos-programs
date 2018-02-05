local component = require("component")
local locomotivesList = {locomotive = {nil, nil, nil}}

local sides = require("sides")
local colours = require("colors")



local junctions = {
  JEBIW1 = {state}
}


local signals = {
  SEBWE1 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.black}, nextForward = {type = "s", name = "SEBWE2"}, nextBackward = nil},
  SEBWE2 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.red}, nextForward = {type = "s", name = "SEBWE3"}, nextBackward = nil},
  SEBWE3 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.green}, nextForward = {type = "s", name = "SEBWE4"}, nextBackward = nil},
  SEBWE4 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.brown}, nextForward = {type = "s", name = "SEBWE5"}, nextBackward = nil},
  SEBWE5 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.blue}, nextForward = {type = "s", name = ""}, nextBackward = nil},
  SEBWE6 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.purple}, nextForward = {type = "s", name = ""}, nextBackward = nil},
  SEBWE7 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.cyan}, nextForward = {type = "s", name = ""}, nextBackward = nil},
  SEBWE8 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.silver}, nextForward = {type = "s", name = ""}, nextBackward = nil},
  SEBWE9 = {part = {control = "c21640dc-b0e3-4996-b20c-f1037927bdbe", sidebottom = sides.right, sidetop = sides.top, colour = colours.gray}, nextForward = {type = "s", name = ""}, nextBackward = nil}
}

local function setSignal(name, colour)
  if colour == "green" then
    component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidetop, signals[name].part.colour, 256)
	component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidebottom, signals[name].part.colour, 0)
  elseif colour == "yellow" then
    component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidetop, signals[name].part.colour, 144)
    component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidebottom, signals[name].part.colour, 0)
	if signals[name].nextBackward then
		setSignal(signals[name].nextBackward.name, "green-yellow")
	end
  elseif colour == "red" then
	component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidetop, signals[name].part.colour, 48)
    component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidebottom, signals[name].part.colour, 0)
	if signals[name].nextBackward then
		setSignal(signals[name].nextBackward.name, "yellow")
	end
  elseif colour == "green-yellow" then
	component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidetop, signals[name].part.colour, 256)
    component.invoke(signals[name].part.control,"setBundledOutput",signals[name].part.sidebottom, signals[name].part.colour, 144)
    if signals[name].nextBackward then
		setSignal(signals[name].nextBackward.name, "green")
	end
  
  else if "yellow-blink-top" then
	
  else if "off" then

  else if "green-blink-yellow" then
	
  else if "yellow-blink-yellow" then
  
  else if "double-green" then
  
  end
end

local function checkNextSignal(locomotive)
  return signals[locomotive["nextSignal"]]
end

local function checkLocomotives()
  for k, v in pairs(locomotivesList) do
	
  end
end
setSignal("SEBWE1", "red")
setSignal("SEBWE2", "red")
setSignal("SEBWE3", "red")
setSignal("SEBWE4", "red")