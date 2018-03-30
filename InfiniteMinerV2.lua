local component = require "component"
local robot = require "robot"
local computer = require "computer"
local orientation = "Z-"
local orientationNum = 3
local XCoord = -10537
local YCoord = 236
local ZCoord = 9145
local inventory_controller = component.inventory_controller
function recharge(time)
	robot.select(3)
	robot.up()
	robot.placeUp()
	robot.down()
	robot.select(2)
	robot.placeUp()
	robot.select(1)
	component.inventory_controller.equip()
	robot.useUp()
	os.sleep(time)
	component.inventory_controller.equip()
	robot.select(2)
	robot.swingUp()
	robot.up()
	robot.select(3)
	robot.swingUp()
	robot.down()
end
function RobotSwing()
	robot.swing()
end
function RobotSwingDown()
	robot.swingDown()
end
function RobotSwingUp()
	robot.swingUp()
end
function RobotForward()
	robot.forward()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge(15)
	end
	if orientation == "Z-" then
		ZCoord = ZCoord - 1
	elseif orientation == "Z+" then
		ZCoord = ZCoord + 1
	elseif orientation == "X-" then
		XCoord = XCoord - 1
	elseif orientation == "X+" then
		XCoord = XCoord + 1
	end
end
function RobotBack()
	robot.back()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge(15)
	end
	if orientation == "Z-" then
		ZCoord = ZCoord + 1
	elseif orientation == "Z+" then
		ZCoord = ZCoord - 1
	elseif orientation == "X-" then
		XCoord = XCoord + 1
	elseif orientation == "X+" then
		XCoord = XCoord - 1
	end
end	
function RobotDown()
	robot.down()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge(15)
	end
	YCoord = YCoord - 1
end
function RobotUp()
	robot.up()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge(15)
	end
	YCoord = YCoord + 1
end
function RobotTurnLeft()
	robot.turnLeft()
	SetEndOrientation(-1)
end
function RobotTurnRight()
	robot.turnRight()
	SetEndOrientation(1)
end
function RobotTurnAround()
	robot.turnAround()
	SetEndOrientation(-2)
end
function SetEndOrientation(delta)
	orientationNum = orientationNum + delta
	if orientationNum == 0 then
		orientationNum = 4
		orientation = "X-"
	elseif orientationNum == 1 then
		orientation = "Z+"
	elseif orientationNum == 2 then
		orientation = "X+"
	elseif orientationNum == 3 then
		orientation = "Z-"
	elseif orientationNum == 4 then
		orientation = "X-"
	elseif orientationNum == 5 then
		orientationNum = 1
		orientation = "Z+"
	elseif orientationNum == -1 then
		orientationNum = 3
		orientation = "Z-"
	elseif orientationNum == 6 then
		orientationNum = 2
		orientation = "X+"
	end
end
function SetOrientation(Target)
	local TargetNum
	if Target == "Z+" then
		TargetNum = 1
	elseif Target == "X+" then
		TargetNum = 2
	elseif Target == "Z-" then
		TargetNum = 3
	elseif Target == "X-" then
		TargetNum = 4
	end
	local Diff = TargetNum - orientationNum

	if Diff == -1 or Diff == 3 then
		RobotTurnLeft()
	elseif Diff == 1 or Diff == -3 then
		RobotTurnRight()
	elseif Diff == 2 or Diff == -2 then
		RobotTurnAround()
	end
end
function GoToX(X)
	if X < XCoord then
		SetOrientation("X-")
		while XCoord > X do
			RobotForward()
		end
	elseif X > XCoord then
		SetOrientation("X+")
		while XCoord < X do
			RobotForward()
		end
	end
end
function GoToY(Y)
	if Y < YCoord then
		while YCoord > Y do
			RobotDown()
		end
	elseif Y > YCoord then
		while YCoord < Y do
			RobotUp()
		end
	end
end
function GoToZ(Z)
	if Z < ZCoord then
		SetOrientation("Z-")
		while ZCoord > Z do
			RobotForward()
		end
	elseif Z > ZCoord then
		SetOrientation("Z+")
		while ZCoord < Z do
			RobotForward()
		end
	end
end
function GoToCoords(X,Y,Z, goHigh)
	if goHigh == true then
		GoToY(255)
	end
	GoToX(X)
	GoToZ(Z)
	GoToY(Y)
end
function moveToNewChunk()
	for i = 1, 192 do
		RobotForward()
	end
end

function setupAnchors(startingOrientation)
	robot.select(9)
	GoToCoords(XCoord + 80, YCoord, ZCoord + 80)
	robot.placeDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.placeDown()

	GoToCoords(XCoord, YCoord, ZCoord - 48)
	robot.placeDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.placeDown()

	GoToCoords(XCoord, YCoord, ZCoord - 32)
	robot.placeDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	-- robot.placeDown() robot is chunkloader
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.placeDown()

	GoToCoords(XCoord, YCoord, ZCoord - 32)
	robot.placeDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.placeDown()

	GoToCoords(XCoord, YCoord, ZCoord - 48)
	robot.placeDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.placeDown()
	GoToCoords(XCoord + 80, YCoord, ZCoord + 80)

	SetOrientation(startingOrientation)
end
function collectAnchors(startingOrientation)
	robot.select(9)
	GoToCoords(XCoord + 80, YCoord, ZCoord + 80)
	robot.swingDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.swingDown()

	GoToCoords(XCoord, YCoord, ZCoord - 48)
	robot.swingDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.swingDown()

	GoToCoords(XCoord, YCoord, ZCoord - 32)
	robot.swingDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	-- Robot is also chunkloader
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.swingDown()

	GoToCoords(XCoord, YCoord, ZCoord - 32)
	robot.swingDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 48, YCoord, ZCoord)
	robot.swingDown()

	GoToCoords(XCoord, YCoord, ZCoord - 48)
	robot.swingDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 32, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord - 48, YCoord, ZCoord)
	robot.swingDown()
	GoToCoords(XCoord + 80, YCoord, ZCoord + 80)

	SetOrientation(startingOrientation)
end

function setupMiner(startingOrientation)
	--Setup glass ceiling
	robot.select(20)--glass
	os.sleep(0.5)
	for _=1,6 do
		RobotUp()
	end
	RobotTurnRight()
	os.sleep(0.5)
	for _=1,3 do
		RobotForward()
	end
	RobotTurnLeft()
	os.sleep(0.5)
	for _=1,3 do
		os.sleep(0.5)
		for _=1,4 do
			robot.placeUp()
			RobotForward()
		end
		robot.placeUp()
		RobotTurnLeft()
		RobotForward()
		RobotTurnLeft()
		os.sleep(0.5)
		for _=1,4 do
			robot.placeUp()
			RobotForward()
		end
		robot.placeUp()
		RobotTurnRight()
		RobotForward()
		RobotTurnRight()
	end
	RobotTurnRight()
	RobotForward()
	RobotForward()
	RobotForward()
	RobotTurnLeft()
	os.sleep(0.5)
	for _=1,6 do
		RobotDown()
	end
	robot.select(10)-- controller
	robot.place()
	RobotTurnRight()
	RobotForward()
	RobotForward()
	RobotTurnLeft()
	RobotForward()
	RobotTurnLeft()
	robot.select(11)-- robust tungstensteel block
	robot.place()
	RobotTurnRight()
	RobotForward()
	RobotTurnLeft()
	robot.select(12)--energy hatch
	robot.place()
	RobotTurnLeft()
	robot.select(3)--solar
	robot.place()
	RobotTurnAround()
	robot.place()
	RobotTurnLeft()
	RobotUp()
	robot.select(13)--transformer
	robot.placeDown(2)
	robot.select(4)--soft mallet
	inventory_controller.equip()
	os.sleep(10)
	robot.useDown()
	inventory_controller.equip()
	RobotTurnRight()
	RobotForward()
	RobotForward()
	RobotTurnLeft()
	RobotForward()
	RobotDown()
	RobotTurnLeft()
	robot.select(14)--output bus
	robot.place()
	RobotUp()
	robot.select(8)--ore tesseract+ fluid
	robot.placeDown()
	RobotTurnRight()
	RobotForward()
	RobotTurnLeft()
	RobotDown()
	robot.select(15)--input hatch
	robot.place()
	RobotUp()
	robot.select(16)--fluid pipe
	robot.placeDown()
	RobotForward()
	RobotForward()
	robot.select(11)
	robot.placeDown()
	RobotBack()
	RobotTurnRight()
	RobotForward()
	robot.placeDown()
	RobotForward()
	RobotDown()
	RobotTurnLeft()
	RobotForward()
	RobotTurnLeft()
	robot.select(17)--auto maintenance
	robot.place()
	RobotTurnRight()
	RobotForward()
	RobotTurnLeft()
	robot.select(18)--input bus
	robot.place()
	RobotTurnLeft()
	robot.select(5)--tesser for repair
	robot.place()
	RobotTurnRight()
	RobotUp()
	robot.select(6)--redstone block
	robot.placeDown()
	os.sleep(5)
	robot.swingDown()
	RobotTurnRight()
	RobotForward()
	robot.placeDown()
	RobotBack()	
	robot.select(7)--tesseract for pipes
	robot.placeDown()
	RobotBack()
	robot.select(5)
	robot.swingDown()
	RobotForward()
	RobotForward()
	robot.select(6)
	robot.swingDown()
	RobotTurnLeft()
	RobotForward()
	RobotTurnLeft()
	RobotForward()
	RobotForward()
	RobotTurnRight()
	robot.select(19)--frames
	os.sleep(0.5)
	for i=1,3 do
		RobotUp()
		robot.placeDown()
	end
	RobotForward()
	RobotForward()
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotUp()
		robot.placeDown()
	end
	RobotTurnLeft()
	RobotForward()
	RobotTurnLeft()
	RobotForward()
	RobotTurnLeft()
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotUp()
		robot.placeDown()
	end
	RobotForward()
	robot.select(11)
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotUp()
		robot.placeDown()
	end
	robot.select(19)
	os.sleep(0.5)
	for i=1,2 do
		RobotUp()
		robot.placeDown()
	end
	RobotForward()
	RobotTurnAround()
	robot.place()
	RobotTurnAround()
	os.sleep(0.5)
	for i=1,5 do
		RobotDown()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotUp()
		robot.placeDown()
	end
	RobotForward()
	os.sleep(0.5)
	for i=1,4 do
		RobotDown()
	end
	SetOrientation(startingOrientation)
end
function collectMiner()
	RobotTurnLeft()
	RobotForward()
	RobotForward()
	RobotTurnRight()
	robot.select(5)
	robot.swing()
	RobotForward()
	RobotForward()
	RobotTurnRight()
	os.sleep(0.5)
	for i=21,24 do
		robot.select(i)
		robot.suck()
	end
	RobotTurnLeft()
	RobotForward()
	RobotForward()
	RobotTurnRight()
	RobotForward()
	RobotTurnRight()
	robot.select(11)
	robot.swing()
	RobotForward()
	robot.select(17)
	robot.swing()
	RobotForward()
	robot.select(19)
	os.sleep(0.5)
	for i=1,3 do
		robot.swingUp()
		RobotUp()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	robot.select(18)
	robot.swing()
	RobotForward()
	RobotTurnLeft()
	robot.select(10)
	robot.swing()
	RobotForward()
	RobotTurnLeft()
	robot.select(19)
	os.sleep(0.5)
	for i=1,3 do
		robot.swingUp()
		RobotUp()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	robot.select(11)
	robot.swing()
	RobotForward()
	os.sleep(0.5)
	for i=1,3 do
		robot.swingUp()
		RobotUp()
	end
	robot.select(19)
	os.sleep(0.5)
	for i=1,3 do
		robot.swingUp()
		RobotUp()
	end
	os.sleep(0.5)
	for i=1,6 do
		RobotDown()
	end
	robot.select(15)
	robot.swing()
	RobotForward()
	robot.select(19)
	os.sleep(0.5)
	for i=1,3 do
		robot.swingUp()
		RobotUp()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	robot.select(16)
	robot.swing()
	RobotForward()
	RobotTurnRight()
	os.sleep(0.5)
	for i=21,24 do
		robot.select(i)
		robot.drop()
		os.sleep(0.5)
	end
	robot.select(8)
	robot.swing()
	RobotForward()
	RobotTurnRight()
	robot.select(14)
	robot.swing()
	RobotForward()
	robot.select(12)
	robot.swing()
	RobotForward()
	robot.select(19)
	os.sleep(0.5)
	for i=1,3 do
		robot.swingUp()
		RobotUp()
	end
	os.sleep(0.5)
	for i=1,3 do
		RobotDown()
	end
	robot.select(11)
	robot.swing()
	RobotForward()
	RobotTurnLeft()
	robot.select(3)
	robot.swing()
	RobotForward()
	RobotTurnLeft()
	robot.select(13)
	robot.swing()
	RobotForward()
	robot.select(3)
	robot.swing()
	RobotBack()
	RobotBack()
	RobotTurnLeft()
	RobotForward()
	RobotForward()
	RobotTurnRight()
	robot.select(20)--glass
	os.sleep(0.5)
	for _=1,6 do
		RobotUp()
	end
	RobotTurnRight()
	os.sleep(0.5)
	for _=1,3 do
		RobotForward()
	end
	RobotTurnLeft()
	os.sleep(0.5)
	for _=1,3 do
		os.sleep(0.5)
		for _=1,4 do
			robot.useUp()
			RobotForward()
		end
		robot.useUp()
		RobotTurnLeft()
		RobotForward()
		RobotTurnLeft()
		os.sleep(0.5)
		for _=1,4 do
			robot.useUp()
			RobotForward()
		end
		robot.useUp()
		RobotTurnRight()
		RobotForward()
		RobotTurnRight()
	end
	RobotTurnRight()
	RobotForward()
	RobotForward()
	RobotForward()
	RobotTurnLeft()
	os.sleep(0.5)
	for _=1,6 do
		RobotDown()
	end
end
function setupCharger()
	robot.up()
	robot.select(3)
	robot.placeUp()
	robot.select(1)
	os.sleep(1)
	inventory_controller.equip()
	os.sleep(1)
	robot.dropUp()
	os.sleep(10)
	robot.suckUp()
	robot.down()
	robot.select(2)
	robot.placeUp()
	robot.useUp(_,true)
	robot.select(1)
	inventory_controller.equip()
end
function collectCharger()
	robot.select(2)
	robot.swingUp()
	robot.select(3)
	robot.up()
	robot.swingUp()
	robot.down()
end
function doMiningProcedure(startingOrientation)
	setupAnchors(startingOrientation)
	setupMiner(startingOrientation)
	setupCharger()
	robot.select(4)
	inventory_controller.equip()
	robot.use()
	os.sleep(3600)
	while inventory_controller.getStackInSlot(3,2) ~= nil do
		os.sleep(300)
	end
	robot.use()
	inventory_controller.equip()
	collectCharger()
	collectMiner()
	collectAnchors(startingOrientation)
end
doMiningProcedure(orientation)
--[[while mining do
	if ZCoord > 14000 then
		SetOrientation("X+")
		moveToNewChunk()
		SetOrientation("Z+")
	elseif ZCoord < -15500 then
		SetOrientation("X+")
		moveToNewChunk()
		SetOrientation("Z-")
	else
		moveToNewChunk()
	end
	doMiningProcedure(orientation)
end]]