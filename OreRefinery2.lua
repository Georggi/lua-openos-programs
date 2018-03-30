local component = require("component")
local robot = require("robot")
local inv = component.inventory_controller
local tasks = {}
local orientation = "Z-"
local orientationNum = 3
local XCoord = 0
local YCoord = 0
local ZCoord = 0
local function unloadFixes()
    robot.select(1)
    robot.drop(2)
    robot.select(2)
    robot.drop(2)
    robot.select(3)
    robot.drop(4)
    robot.select(4)
    robot.drop(4)
end
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
local function addTask( name, endT, prio )
    if tasks[name] == nil then
        tasks[name] = {endT,prio}
    end
end
local function checkMaintenance()
    local UseTimes = 0
    local hatch1 = false
    local hatch2 = false
    local hatch3 = false
    local hatch4 = false
    GoToCoords(6,0,0)
    GoToCoords(6,2,-2)
    if( inv.getStackInSlot(3, 1) == nil ) then
        hatch1 = true
        UseTimes = UseTimes + 1
    end
    GoToCoords(6,2,0)
    GoToCoords(2,2,0)
    GoToCoords(2,2,-2)
    if( inv.getStackInSlot(3, 1) == nil ) then
        hatch2 = true
        UseTimes = UseTimes + 1
    end
    GoToCoords(2,2,0)
    GoToCoords(-2,2,0)
    GoToCoords(-2,2,-2)
    if( inv.getStackInSlot(3, 1) == nil ) then
        hatch3 = true
        UseTimes = UseTimes + 1
    end
    GoToCoords(-2,2,0)
    GoToCoords(-6,2,0)
    GoToCoords(-6,2,-2)
    if( inv.getStackInSlot(3, 1) == nil ) then
        hatch4 = true
        UseTimes = UseTimes + 1
    end
    GoToCoords(-6,2,0)
    GoToCoords(0,0,0)
    if( UseTimes ~= 0 ) then
        GoToCoords(2,0,0)
        SetOrientation("Z+")
        robot.select(1)
        robot.suck(UseTimes*2)
        GoToCoords(1,0,0)
        SetOrientation("Z+")
        robot.select(2)
        robot.suck(UseTimes*2)
        GoToCoords(-1,0,0)
        SetOrientation("Z+")
        robot.select(3)
        robot.suck(UseTimes*4)
        GoToCoords(-2,0,0)
        SetOrientation("Z+")
        robot.select(4)
        robot.suck(UseTimes*4)
        GoToCoords(0,0,0)
        SetOrientation("Z-")
        GoToCoords(6,0,0)
        if (hatch1) then
            GoToCoords(6,2,-2)
            unloadFixes()
            GoToCoords(6,2,0)
        end
        GoToCoords(2,2,0)
        if (hatch2) then
            GoToCoords(2,2,-2)
            unloadFixes()
            GoToCoords(2,2,0)
        end
        GoToCoords(-2,2,0)
        if (hatch3) then
            GoToCoords(-2,2,-2)
            unloadFixes()
            GoToCoords(-2,2,0)
        end
        if (hatch4) then
            GoToCoords(-6,2,-2)
            unloadFixes()
            GoToCoords(-6,2,0)
        end
    end
    robot.select(1)
    GoToCoords(0,0,0)
    SetOrientation("Z-")
    addTask( "checkMaintenance", os.time()/72 + 10*60, 2 )
end
local function lookForTask()
    local task
    local bestScore
    for k, v in pairs(tasks) do
        if os.time() / 72 > v[1] then
            local newBestScore = (v[1] - (os.time() / 72)) / v[2]
            if task == nil or newBestScore > bestScore then
                bestScore = newBestScore
                task = k
            end
            if v[2] <= 1 then
                task = k
            end
        end
    end
    if( task ~= nil ) then
        tasks[task] = nil
        if task == "checkMaintenance" then
            checkMaintenance()
        end
    else
        os.sleep(5)
    end
end
checkMaintenance()
--addTask( "checkMaintenance", os.time()/72 + 1*60, 2 )
while true do
    lookForTask()
end