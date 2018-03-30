local component = require "component"
local robot = require "robot"
local computer = require "computer"
local m = component.tunnel -- get primary modem component
local mining = true
local orientation = "Z-"
local orientationNum = 3
local XCoord = -10537
local YCoord = 90
local ZCoord = 9145
local tick = 0

function sendCoords()
	m.send(XCoord,YCoord,ZCoord)
end

function recharge()
	robot.swing()
	robot.forward()
	robot.swing()
	robot.select(2)
	robot.place()
	robot.back()
	robot.select(1)
	robot.place()
	robot.select(3)
	component.inventory_controller.equip()
	robot.use()
	os.sleep(8)
	component.inventory_controller.equip()
	robot.select(1)
	robot.swing()
	robot.forward()
	robot.swing()
	robot.back()
end
function RobotSwing()
	robot.swing()
	if robot.count(16) > 0 then
		sendItems()
	end
end
function RobotSwingDown()
	robot.swingDown()
	if robot.count(16) > 0 then
		sendItems()
	end
end
function RobotSwingUp()
	robot.swingUp()
	if robot.count(16) > 0 then
		sendItems()
	end
end
function RobotForward()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge()
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
	tick = tick + 1
	if tick == 300 then
		sendCoords()
		tick = 0
	end
end
function RobotDown()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge()
	end
	YCoord = YCoord - 1
	tick = tick + 1
	if tick == 300 then
		sendCoords()
		tick = 0
	end
end
function RobotUp()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge()
	end
	while robot.up() == nil do
		robot.swingUp()
	end
	YCoord = YCoord + 1
	tick = tick + 1
	if tick == 300 then
		sendCoords()
		tick = 0
	end
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
	for i = 0, 191 do
		RobotForward()
	end
end
function setupAnchors()
	robot.select(3)
end
function collectAnchors()

end

function doMiningProcedure(startingOrientation)
	setupAnchors(startingOrientation)
	setupMiner(startingOrientation)
	setupCharger(startingOrientation)
	while inventory_controller.getStackInSlot(3,4).size ~= ?? do
		os.sleep(300)
	end
	collectCharger(startingOrientation)
	collectMiner(startingOrientation)
	collectAnchors(startingOrientation)
end
while mining do
	if ZCoord > 9165 then
		SetOrientation("X+")
		moveToNewChunk()
		SetOrientation("Z+")
	elseif ZCoord < -10500 then
		SetOrientation("X+")
		moveToNewChunk()
		SetOrientation("Z-")
	else
		moveToNewChunk()
	end
	doMiningProcedure()
end