local modem = require("component").modem
local event = require("event")
local robot = require("robot")
local c = require("component").inventory_controller
local orientation = "Z-"
local orientationNum = 3
local XCoord = -2912
local YCoord = 66
local ZCoord = -355
function RobotForward()
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
function RobotDown()
  robot.down()
  YCoord = YCoord - 1
end
function RobotUp()
  YCoord = YCoord + 1
  robot.up()
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
    GoToY(250)
  end
  GoToX(X)
  GoToZ(Z)
  GoToY(Y)
end
function placeAnchors()
  robot.select(9)
  robot.turnRight()
  for i=1,4 do
    for k=1,16 do
      robot.forward()
    end
    robot.turnLeft()
    for l=1,4 do
      for g=1,16 do
        robot.forward()
      end
      robot.placeDown()
    end 
    robot.turnAround()
    for l=1,4 do
      for g=1,16 do
        robot.forward()
      end
    end
  end
end
function InitiateFireSequence()
  robot.select(1)
  robot.place()
  robot.select(2)
  robot.drop()
  robot.select(3)
  robot.drop()
  robot.turnRight()
  robot.forward()
  robot.turnLeft()
  robot.select(1)
  robot.place()
  robot.select(4)
  robot.drop()
  robot.select(5)
  robot.drop()
  robot.select(6)
  robot.placeDown()
  robot.up()
  robot.select(7)
  robot.placeDown()
  robot.turnLeft()
  robot.forward()
  robot.down()
  robot.select(6)
  robot.placeDown()
  robot.select(7)
  robot.up()
  robot.placeDown()
  robot.forward()
  robot.down()
  robot.select(8)
  robot.placeDown()
  robot.up()
  robot.placeDown()
end
GoToCoords(-2957,100,-781,true)
InitiateFireSequence()