local component = require("component")
local robot = require("robot")
local inv = component.inventory_controller
local orientation = "Z+"
local orientationNum = 1
local XCoord = 0
local YCoord = 0
local ZCoord = 0
local function SetEndOrientation(delta)
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
local function RobotForward()
    robot.forward()
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
local function RobotDown()
    robot.down()
    YCoord = YCoord - 1
end
local function RobotUp()
    robot.up()
    YCoord = YCoord + 1
end
local function RobotTurnLeft()
    robot.turnLeft()
    SetEndOrientation(-1)
end
local function RobotTurnRight()
    robot.turnRight()
    SetEndOrientation(1)
end
local function RobotTurnAround()
    robot.turnAround()
    SetEndOrientation(-2)
end
local function SetOrientation(Target)
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
local function GoToX(X)
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
local function GoToY(Y)
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
local function GoToZ(Z)
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
local function GoToCoords(X,Y,Z)
    GoToX(X)
    GoToZ(Z)
    GoToY(Y)
end
while true do
    if inv.getStackInSlot(3, 1) ~= nil then
        robot.select(1)
        robot.suck(1)
        robot.select(2)
        robot.suck(2)
        robot.select(3)
        robot.suck(64)
        robot.select(4)
        robot.suck(64)
        robot.select(5)
        robot.suck(64)
        robot.select(6)
        robot.suck(64)
        robot.select(7)
        robot.suck(2)
        robot.select(8)
        robot.suck(1)
        GoToCoords(0,1,-1)
        robot.select(1)
        robot.dropUp()
        GoToCoords(0,1,-2)
        robot.select(2)
        robot.dropUp()
        GoToCoords(0,1,-3)
        robot.select(3)
        robot.dropUp()
        GoToCoords(0,1,-4)
        robot.select(4)
        robot.dropUp()
        GoToCoords(0,1,-5)
        robot.select(5)
        robot.dropUp()
        GoToCoords(0,1,-6)
        robot.select(6)
        robot.dropUp()
        GoToCoords(0,1,-7)
        robot.select(7)
        robot.dropUp()
        GoToCoords(0,0,-4)
        SetOrientation("X+")
        robot.select(8)
        robot.drop()
        GoToCoords(0,0,0)
    end
    os.sleep(5)
end