local component = require "component"
local event = require "event"
local geo = component.geolyzer
local robot = require "robot"
local computer = require "computer"
local m = component.tunnel -- get primary modem component
local mining = true
local EventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
local orientation = "Z-"
local orientationNum = 3
local XCoord = -10537
local YCoord = 90
local ZCoord = 9145
local oreChunkX = 0
local oreChunkZ = 0
local ChunksToScan = {}
local ScannedChunks = {}
local scanStartX
local scanStartY
local scanStartZ
local maxChunkX=0
local minChunkX=0
local maxChunkZ=0
local minChunkZ=0
local foundOreX
local foundOreZ
local ChunkStartX
local ChunkStartY
local ChunkStartZ
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
function sendItems()
	robot.select(2)
	robot.swing()
	robot.place()
	local h = 6
	while h <= 16 do
		robot.select(h)
		robot.drop()
		h = h + 1
	end
	robot.select(2)
	robot.swing()
	robot.select(1)
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
function unknownEvent()
	-- do nothing if the event wasn't relevant
end
function TableContains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end
function RobotForward()
	if computer.maxEnergy() / 4 > computer.energy() then
		recharge()
	end
	if geo.analyze(3).harvestTool == "scoop" then
		sendItems()
		robot.select(4)
		component.inventory_controller.equip()
		robot.swing()
		component.inventory_controller.equip()
		robot.select(1)
		sendItems()
	end
	while robot.detect() do
		local _, type = robot.detect()
		if type == "solid" or type == "passable" then
			RobotSwing()
			break
		elseif type == "entity" then
			robot.select(5)
			component.inventory_controller.equip()
			RobotSwing()
			RobotSwing()
			RobotSwing()
			RobotSwing()
			RobotSwing()
			component.inventory_controller.equip()
			robot.select(1)
			break
		end
	end
	while robot.forward() == nil do
		robot.swing()
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
	if geo.analyze(0).harvestTool == "scoop" then
		sendItems()
		robot.select(4)
		component.inventory_controller.equip()
		robot.swingDown()
		component.inventory_controller.equip()
		robot.select(1)
		sendItems()
	end
	while robot.detectDown() do
		local _, type = robot.detectDown()
		if type == "solid" or type == "passable" then
			RobotSwing()
			break
		elseif type == "entity" then
			robot.select(5)
			component.inventory_controller.equip()
			RobotSwingDown()
			RobotSwingDown()
			RobotSwingDown()
			component.inventory_controller.equip()
			robot.select(1)
			break
		end
	end
	while robot.down() == nil do
		robot.swingDown()
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
	if geo.analyze(1).harvestTool == "scoop" then
		sendItems()
		robot.select(4)
		component.inventory_controller.equip()
		robot.swingUp()
		component.inventory_controller.equip()
		robot.select(1)
		sendItems()
	end
	while robot.detectUp() do
		local _, type = robot.detectUp()
		if type == "solid" or type == "passable" then
			RobotSwing()
			break
		elseif type == "entity" then
			robot.select(5)
			component.inventory_controller.equip()
			RobotSwingUp()
			RobotSwingUp()
			RobotSwingUp()
			component.inventory_controller.equip()
			robot.select(1)
			break
		end
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
		GoToY(250)
	end
	GoToX(X)
	GoToZ(Z)
	GoToY(Y)
end

function EventHandlers.modem_message(adress1, adress2, port, distance, message)
	if tostring(message) == "BackToBase" then
		event.ignore("modem_message", handleEvent)
		mining = false
		local HomeX = -1769
		local HomeY = 69
		local HomeZ = -1319
		GoToCoords(HomeX, HomeY, HomeZ, true)
	end
end
function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    EventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end
event.listen("modem_message", handleEvent)
function ScanChunkForOre()
	ChunkStartX = XCoord
	ChunkStartY = YCoord
	ChunkStartZ = ZCoord
	local hasChunkOre = false
	local stopScan = false
	while geo.analyze(0).name ~= "minecraft:bedrock" and stopScan == false do
		local blockDown = geo.analyze(0)
		if blockDown.name == "gregtech:gt.blockores" then
			sendItems()
			RobotSwingDown()
			if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
				print("FoundOre")
				foundOreX = XCoord
				foundOreZ = ZCoord
				hasChunkOre = true
				stopScan = true
				RobotDown()
				break
			end
		end
		RobotSwingDown()
		RobotDown()
		-- Check walls
		local blockBack = geo.analyze(2)
		if blockBack.name == "gregtech:gt.blockores" then
			sendItems()
			RobotTurnAround()
			RobotSwing()
			RobotTurnAround()
			if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
				print("FoundOre")
				foundOreX = XCoord
				foundOreZ = ZCoord
				hasChunkOre = true
				stopScan = true
				break
			end
		end
		local blockFront = geo.analyze(3)
		if blockFront.name == "gregtech:gt.blockores" then
			RobotTurnRight()
			sendItems()
			RobotTurnLeft()
			robot.swing()
			if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
				print("FoundOre")
				foundOreX = XCoord
				foundOreZ = ZCoord
				hasChunkOre = true
				stopScan = true
				break
			end
		end
		local blockRight = geo.analyze(4)
		if blockRight.name == "gregtech:gt.blockores" then
			sendItems()
			RobotTurnRight()
			RobotSwing()
			RobotTurnLeft()
			if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
				print("FoundOre")
				foundOreX = XCoord
				foundOreZ = ZCoord
				hasChunkOre = true
				stopScan = true
				break
			end
		end
		local blockLeft = geo.analyze(5)
		if blockLeft.name == "gregtech:gt.blockores" then
			sendItems()
			RobotTurnLeft()
			RobotSwing()
			RobotTurnRight()
			if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
				print("FoundOre")
				foundOreX = XCoord
				foundOreZ = ZCoord
				hasChunkOre = true
				stopScan = true
				break
			end
		end
	end
	if hasChunkOre == false then
		GoToCoords(ChunkStartX, ChunkStartY, ChunkStartZ,false)
		SetOrientation("Z-")
	end
	return hasChunkOre
end
function findVeinY()
	local nextYHasOre = false
	local VeinMaxY
	local VeinMinY
	for i = 0, 7, 1 do
		RobotForward()
		if nextYHasOre == false then
			local blockUp = geo.analyze(1)
			if blockUp.name == "gregtech:gt.blockores" then
				sendItems()
				RobotSwingUp()
				if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
					nextYHasOre = true
				end
			end
		end
	end
	RobotTurnAround()
	for i = 0, 7, 1 do
		RobotForward()
	end
	if nextYHasOre == false then
		for i = 0, 6, 1 do
			RobotSwing()
			RobotForward()
			local blockUp = geo.analyze(1)
			if blockUp.name == "gregtech:gt.blockores" then
				sendItems()
				RobotSwingUp()
				if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
					nextYHasOre = true
				end
			end
		end
		RobotTurnAround()
		for i = 0, 6, 1 do
			RobotForward()
		end
	else
		RobotTurnAround()
	end
	if nextYHasOre == false then
		VeinMaxY = YCoord
		VeinMinY = YCoord - 6
	else
		RobotUp()
		VeinMaxY, VeinMinY = findVeinY()
	end
	return VeinMaxY, VeinMinY
end
function ScanWall()
	local near_by_chunk_has_ore = false
	for i = 0, 14, 1 do
		if near_by_chunk_has_ore == false then
			RobotTurnRight()
			local block = geo.analyze(3)
			if block.name == "gregtech:gt.blockores" then
				RobotTurnLeft()
				sendItems()
				RobotTurnRight()
				RobotSwing()
				if component.inventory_controller.getStackInInternalSlot(6).name == "gregtech:gt.blockores" then
					near_by_chunk_has_ore = true
					if orientation == "X+"		and TableContains(ChunksToScan, {oreChunkX + 1, oreChunkZ}) == false
												and	TableContains(ScannedChunks, {oreChunkX + 1, oreChunkZ}) == false then
						ChunksToScan [#ChunksToScan + 1] = {oreChunkX + 1, oreChunkZ}
					elseif orientation == "X-" 	and TableContains(ChunksToScan, {oreChunkX - 1, oreChunkZ}) == false
												and	TableContains(ScannedChunks, {oreChunkX - 1, oreChunkZ}) == false then
						ChunksToScan [#ChunksToScan + 1] = {oreChunkX - 1, oreChunkZ}
					elseif orientation == "Z+" 	and TableContains(ChunksToScan, {oreChunkX, oreChunkZ + 1}) == false
												and	TableContains(ScannedChunks, {oreChunkX, oreChunkZ + 1}) == false then
						ChunksToScan [#ChunksToScan + 1] = {oreChunkX, oreChunkZ + 1}
					elseif orientation == "Z-" 	and TableContains(ChunksToScan, {oreChunkX, oreChunkZ - 1}) == false
												and	TableContains(ScannedChunks, {oreChunkX, oreChunkZ - 1}) == false then
						ChunksToScan [#ChunksToScan + 1] = {oreChunkX, oreChunkZ - 1}
					end
				end
			end
			RobotTurnLeft()
		end
		RobotForward()
	end
end
function scanWalls()
	scanStartX = XCoord
	scanStartY = YCoord
	scanStartZ = ZCoord
	for i = 0, 3, 1 do
		ScanWall()
		RobotTurnLeft()
	end
	while next(ChunksToScan) ~= nil do
		local nextChunk = ChunksToScan[1]
		table.remove(ChunksToScan, 1)
		ScannedChunks [#ScannedChunks + 1] = {nextChunk[1], nextChunk[2]}
		print("Next chunk X:Z - " .. nextChunk[1] .. ":" ..  nextChunk[2])
		if nextChunk[1] > maxChunkX then
			maxChunkX = nextChunk[1]
			print("New maxChunkX" .. maxChunkX)
		elseif nextChunk[1] < minChunkX then
			minChunkX = nextChunk[1]
			print("New minChunkX" .. minChunkX)
		end
		if nextChunk[2] > maxChunkZ then
			maxChunkZ = nextChunk[2]
			print("New maxChunkZ" .. maxChunkZ)
		elseif nextChunk[2] < minChunkZ then
			minChunkZ = nextChunk[2]
			print("New minChunkZ" .. minChunkZ)
		end
		local X = scanStartX + ((nextChunk[1] - oreChunkX) * 16)
		local Z = scanStartZ + ((nextChunk[2] - oreChunkZ) * 16)
		oreChunkX = nextChunk[1]
		oreChunkZ = nextChunk[2]
		local EndOrientation = orientation
		GoToCoords(X, scanStartY, Z, false)
		SetOrientation(EndOrientation)
		scanWalls()
	end
	if next(ChunksToScan) == nil then
		ChunksToScan = {}
		ScannedChunks = {}
		local VeinMaxZ = foundOreZ + 8 + math.abs(maxChunkZ*16)
		local VeinMinZ = foundOreZ - 8 - math.abs(minChunkZ*16)
		local VeinMaxX = foundOreX + 8 + math.abs(maxChunkX*16)
		local VeinMinX = foundOreX - 7 - math.abs(minChunkX*16)
		return VeinMaxX, VeinMinX, VeinMaxZ, VeinMinZ
	end
end
function scanVeinSize()
	local VeinMaxY, VeinMinY = findVeinY()
	for i = 0, 7, 1 do
		RobotForward()
	end
	for i = 0, 2, 1 do
		RobotSwingDown()
		RobotDown()
	end
	RobotTurnLeft()
	for i = 0, 7, 1 do
		RobotSwing()
		RobotForward()
	end
	RobotTurnLeft()
	local VeinMaxX, VeinMinX, VeinMaxZ, VeinMinZ = scanWalls()
	print(VeinMaxX .. "MaxX:MinX" .. VeinMinX .. " " .. VeinMaxZ .. "MaxZ:MinZ" .. VeinMinZ)
	return VeinMinX,VeinMaxX,VeinMinY,VeinMaxY,VeinMinZ,VeinMaxZ
end
function moveToNewChunk()
	for i = 0, 15, 1 do
		RobotForward()
	end
end
function Quarry(VeinMinX,VeinMaxX,VeinMinY,VeinMaxY,VeinMinZ,VeinMaxZ)
	for i = 0, 2, 1 do
		GoToCoords(VeinMinX, VeinMaxY - (i*3), VeinMinZ,false)
		SetOrientation("X+")
		while VeinMaxZ > ZCoord do
			if orientation == "X-" then
				while VeinMinX < XCoord do
					RobotSwing()
					RobotSwingUp()
					RobotSwingDown()
					RobotForward()
				end
				RobotTurnRight()
				RobotSwingUp()
				RobotSwingDown()
				RobotForward()
				RobotTurnRight()
			elseif orientation == "X+" then
				while VeinMaxX > XCoord do
					RobotSwing()
					RobotSwingUp()
					RobotSwingDown()
					RobotForward()
				end
				RobotTurnLeft()
				RobotSwingUp()
				RobotSwingDown()
				RobotForward()
				RobotTurnLeft()
			end
		end
	end
end
while mining do
	if ZCoord > 9165 then
		SetOrientation("X+")
		moveToNewChunk()
		if ScanChunkForOre() == true then
			scanVeinSize()
		end
		SetOrientation("Z+")
		moveToNewChunk()
	end
	if ZCoord < -10500 then
		SetOrientation("X+")
		moveToNewChunk()
		if ScanChunkForOre() == true then
			scanVeinSize()
		end
		SetOrientation("Z-")
	end
	if ScanChunkForOre() == true then
		print("Chunk Has Ore")
		local VeinMinX,VeinMaxX,VeinMinY,VeinMaxY,VeinMinZ,VeinMaxZ = scanVeinSize()
		Quarry(VeinMinX,VeinMaxX,VeinMinY,VeinMaxY,VeinMinZ,VeinMaxZ)
		GoToCoords(ChunkStartX, ChunkStartY, ChunkStartZ,false)
		SetOrientation("Z-")
		maxChunkX = 0
		maxChunkZ = 0
		minChunkX = 0
		minChunkZ = 0
	end
	moveToNewChunk()
end