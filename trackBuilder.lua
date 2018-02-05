local component = require("component")
local robot = require("robot")
local inv = component.inventory_controller
local computer = require "computer"
function recharge()
	robot.back()
	robot.select(5)
	robot.place()
	robot.back()
	robot.select(6)
	robot.place()
	robot.select(7)
	component.inventory_controller.equip()
	robot.use()
	os.sleep(8)
	component.inventory_controller.equip()
	robot.select(6)
	robot.swing()
	robot.select(5)
	robot.forward()
	robot.swing()
	robot.forward()
end

function digLineUp()
	for k = 1, 7 do
	  for i = 1, 5 do
		while robot.detect() do
		  robot.swing()
		  os.sleep(1)
		end
		if math.fmod(k,2) == 1 then
		  while robot.detectUp() do
		    robot.swingUp()
			os.sleep(1)
		  end
		  robot.up()
		else
		  while robot.detectDown() do
		    robot.swingDown()
			os.sleep(1)
		  end
		  robot.down()
		end
	  end
	  while robot.detect() do
		robot.swing()
		os.sleep(1)
	  end
	  if k ~= 7 then
		  robot.turnRight()
		  while robot.detect() do
		    robot.swing()
			os.sleep(1)
		  end
		  while robot.detect() do
	        robot.swing()
	        os.sleep(1)
          end
		  robot.forward()
		  robot.turnLeft()	
	  end
	end
end
function placeGranite()
  robot.select(8)
  robot.placeDown()
  if inv.getStackInInternalSlot() == nil then
    robot.select(1)
	robot.placeUp()
	robot.select(8)
	robot.suckUp()
	robot.select(1)
	robot.swingUp()
	robot.select(8)
  end
end
function placeConcrete()
  robot.select(9)
  robot.placeDown()
  if inv.getStackInInternalSlot() == nil then
    robot.select(2)
	robot.placeUp()
	robot.select(9)
	robot.suckUp()
	robot.select(2)
	robot.swingUp()
	robot.select(9)
  end
end
function placeStone()
  robot.select(10)
  robot.placeDown()
  if inv.getStackInInternalSlot() == nil then
    robot.select(3)
	robot.placeUp()
	robot.select(10)
	robot.suckUp()
	robot.select(3)
	robot.swingUp()
	robot.select(10)
  end
end
function placeTrack()
  robot.select(11)
  robot.placeDown()
  if inv.getStackInInternalSlot() == nil then
    robot.select(4)
	robot.placeUp()
	robot.select(11)
	robot.suckUp()
	robot.select(4)
	robot.swingUp()
	robot.select(11)
  end
end
local arguments_as_a_table = {...}
for i = 1, arguments_as_a_table[1] do
  digLineUp()
  for i = 1, 4 do
	robot.down()
  end
  placeGranite()
  robot.turnLeft()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  placeConcrete()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  placeStone()
  while robot.detectUp() do
	robot.swingUp()
	os.sleep(1)
  end
  robot.up()
  placeTrack()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  while robot.detectDown() do
	robot.swingDown()
	os.sleep(1)
  end
  robot.down()
  placeGranite()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  placeStone()
  while robot.detectUp() do
	robot.swingUp()
	os.sleep(1)
  end
  robot.up()
  placeTrack()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  while robot.detectDown() do
	robot.swingDown()
	os.sleep(1)
  end
  robot.down()
  placeConcrete()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  placeGranite()
  robot.turnRight()
  while robot.detect() do
	robot.swing()
	os.sleep(1)
  end
  robot.forward()
  if computer.maxEnergy() / 4 > computer.energy() then
	recharge()
  end
  while robot.detectDown() do
	robot.swingDown()
	os.sleep(1)
  end
  robot.down()
end