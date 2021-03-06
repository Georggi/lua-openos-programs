local component = require("component")
local robot = require("robot")
local inv = component.inventory_controller
local rs = component.redstone
local tasks = {}
local orientation = "X-"
local orientationNum = 4
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
local function addTask( name, endT, prio )
    if tasks[name] == nil then
        tasks[name] = {endT,prio}
    end
end
local function swapTurbine()
    RobotTurnAround()
    robot.select(1)
    robot.suck()
    robot.select(2)
    robot.suck()
    GoToY(2)
    GoToZ(3)
    GoToX(-3)
    SetOrientation("X-")
    robot.use()
    os.sleep(1)
    robot.select(3)
    robot.suck()
    robot.select(1)
    robot.drop()
    robot.use()
    os.sleep(1)
    GoToZ(-5)
    SetOrientation("X-")
    robot.use()
    os.sleep(1)
    robot.select(4)
    robot.suck()
    robot.select(2)
    robot.drop()
    robot.use()
    os.sleep(1)
    GoToCoords(0,0,0)
    SetOrientation("X-")
    RobotUp()
    RobotUp()
    SetOrientation("X+")
    robot.select(3)
    robot.drop()
    robot.select(4)
    robot.drop()
    SetOrientation("X-")
    RobotDown()
    RobotDown()
    addTask( "swapTurbine", os.time()/72 + 60*60*24, 2 )
end
local function checkMaintenance()
    local UseTimes = 0
    local turbine1 = false
    local turbine2 = false
    GoToCoords(-5,2,1)
    SetOrientation("Z+")
    if( inv.getStackInSlot(3, 1) == nil ) then
        turbine2 = true
        UseTimes = UseTimes + 1
    end
    GoToZ(-3)
    if( inv.getStackInSlot(3, 1) == nil ) then
        turbine1 = true
        UseTimes = UseTimes + 1
    end
    if( UseTimes ~= 0 ) then
        GoToCoords(0,0,-2)
        SetOrientation("X+")
        robot.select(1)
        robot.suck(UseTimes*2)
        GoToCoords(0,0,-1)
        SetOrientation("X+")
        robot.select(2)
        robot.suck(UseTimes*2)
        GoToCoords(0,0,1)
        SetOrientation("X+")
        robot.select(3)
        robot.suck(UseTimes*4)
        GoToCoords(0,0,2)
        SetOrientation("X+")
        robot.select(4)
        robot.suck(UseTimes*4)
        GoToCoords(0,0,0)
        SetOrientation("X-")
        if (turbine2) then
            GoToCoords(-5,2,1)
            SetOrientation("Z+")
            robot.select(1)
            robot.drop(2)
            robot.select(2)
            robot.drop(2)
            robot.select(3)
            robot.drop(4)
            robot.select(4)
            robot.drop(4)
        end
        if (turbine1) then
            GoToCoords(-5,2,-3)
            SetOrientation("Z-")
            robot.select(1)
            robot.drop(2)
            robot.select(2)
            robot.drop(2)
            robot.select(3)
            robot.drop(4)
            robot.select(4)
            robot.drop(4)
        end
    end
    robot.select(1)
    GoToCoords(0,0,0)
    SetOrientation("X-")
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
        if task == "swapTurbine" then
            swapTurbine()
        elseif task == "checkMaintenance" then
            checkMaintenance()
        end
    else
        os.sleep(5)
    end
end
addTask( "checkMaintenance", os.time()/72 + 1*60, 2 )
addTask( "swapTurbine", os.time()/72 + 60*60*24, 2 )
while true do
    lookForTask()
end