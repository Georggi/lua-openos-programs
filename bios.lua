local component = require("component")
robot = component.robot
inv = component.inventory_controller
local sides = require("sides")
--robot api
function drop(count)
  checkArg(1, count, "nil", "number")
  return component.robot.drop(sides.front, count)
end

function suck(count)
  checkArg(1, count, "nil", "number")
  return component.robot.suck(sides.front, count)
end
 
function suckUp(count)
  checkArg(1, count, "nil", "number")
  return component.robot.suck(sides.up, count)
end
 
function suckDown(count)
  checkArg(1, count, "nil", "number")
  return component.robot.suck(sides.down, count)
end

function up()
  return component.robot.move(sides.up)
end
 
function down()
  return component.robot.move(sides.down)
end

function turnLeft()
  return component.robot.turn(false)
end
 
function turnRight()
  return component.robot.turn(true)
end
 
function turnAround()
  turnRight()
  turnRight()
end

function wash()
	turnLeft()
	drop()
	turnRight()
end
function heat()
	turnRight()
	drop()
	turnLeft()
end
function macerate()
	drop()
end
function macerate2()
	up()
	turnAround()
	drop()
	turnAround()
	down()
end
function intoAE()
	up()
	turnLeft()
	drop()
	turnRight()
	down()
end
function getOre()
	up()
	turnRight()
	suck()
	turnLeft()
	down()
	if inv.getStackInInternalSlot() ~= nil then
		local metadata = inv.getStackInInternalSlot().damage
		print("Ore Metadata: ")
		print(metadata)
		if metadata % 1000 == 878 then
			OilSand()
		else
			macerate()
		end
	end
end
function getProccesing()
	local i = 1
	local t = {}
	local free = {}
	free[2] = check(2)
	free[4] = check(4)
	free[5] = check(5)
	while TempStorageSize >= i do
		if inv.getStackInSlot(0, i) ~= nil then
			damage = inv.getStackInSlot(0, i).damage
			if
			(free[5] == false and damage < 6000 and damage > 4999) or
			(free[4] == false and damage < 7000 and damage > 5999) or
			(free[2] == false and damage < 8000 and damage > 6999) or
			(damage < 5000)  or (damage > 7999)
			then
				t[i] = inv.getStackInSlot(0, i).size
			end	
		end
		i = i + 1
	end
	if next(t) ~= nil then
		local max_val, key = -math.huge
		for k, v in pairs(t) do
			if v > max_val then
				max_val, key = v, k
			end
		end
		print(key, max_val)	
		inv.suckFromSlot(0, key)
		evaluateItem()
	end
end
function OilSand()
	up()
	turnAround()
	drop()
	turnAround()
	down()
end
function SecondMacerate()
	up()
	turnAround()
	drop()
	turnAround()
	down()
end
function evaluateItem()
	local metadata = inv.getStackInInternalSlot().damage
	print("Proc Metadata: ")
	print(metadata)
	if metadata < 1000 then
		intoAE()
	elseif metadata < 2000 then
		intoAE()
	elseif metadata < 3000 then
		intoAE()
	elseif metadata < 4000 then
		intoAE()
	elseif metadata < 5000 then
		intoAE()
	elseif metadata < 6000 then
		wash()
	elseif metadata < 7000 then
		heat()
	elseif metadata < 8000 then
		macerate2()
	else
		intoAE()
	end
end
function check(side)
	local p = 1
	local SlotsOccupied = 0
	local InventorySize = 27
	local AreSlotsOccupied = false
	if side == 3 then
		sideToCheck = 3
		InventorySize = macerate1Size
	elseif side == 5 then
		sideToCheck = 3
		turnLeft()
		InventorySize = WashSize
	elseif side == 4 then
		sideToCheck = 3
		turnRight()
		InventorySize = HeatSize
	elseif side == 2 then
		sideToCheck = 3
		turnAround()
		up()
		InventorySize = macerate2Size
	elseif side == 0 then
		sideToCheck = 0
		InventorySize = TempStorageSize
	end
	while InventorySize >= p do
		if inv.getStackInSlot(sideToCheck, p) ~= nil then
			SlotsOccupied = SlotsOccupied + 1;
		end
		p = p + 1
	end
	if SlotsOccupied > 0 then
		AreSlotsOccupied = true
	elseif SlotsOccupied == 0 then
		AreSlotsOccupied = false
	end
	if side == 5 then
		turnRight()
	elseif side == 4 then
		turnLeft()
	elseif side == 2 then
		turnAround()
		down()
	end
	return AreSlotsOccupied
end
macerate1Size = inv.getInventorySize(3) -- front
turnRight()
HeatSize = inv.getInventorySize(3) -- right
turnRight()
turnRight()
WashSize = inv.getInventorySize(3) -- left
turnRight()
TempStorageSize = inv.getInventorySize(0) -- bottom
up()
turnRight()
OreStorageSize = inv.getInventorySize(3) -- right
turnRight()
macerate2Size = inv.getInventorySize(3) -- back
turnAround()
down()

while true do
	while check(0) == true do
		getProccesing()
	end
	getOre()
	up()
	os.sleep(1)
	down()
end