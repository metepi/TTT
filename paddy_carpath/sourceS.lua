
PlayRec = {}
PlayRec.__index = PlayRec

PlayRec.controlTable = {"accelerate", "brake_reverse", "handbrake", "vehicle_secondary_fire", "vehicle_left", "vehicle_right"}

function PlayRec.create()
	local a = {}
	setmetatable(a, PlayRec)

	a.playing = false
	a.currentRow = 1
	a.recordInfo = {}
	a.lastInfo = {}
	a.loop = true

	return a
end

function PlayRec:load(file)
	if not (file) then return false end

	local pathNode = xmlLoadFile(file)
	if(pathNode) then
		local vehicleNode = xmlFindChild(pathNode, "vehicle", 0 )
		if(vehicleNode) then
			local i = 1
			local recordInfo = {}	
			while vehicleNode do 
				local model = tonumber(xmlNodeGetAttribute(vehicleNode, "model"))
				local pos = {tonumber(xmlNodeGetAttribute(vehicleNode, "x")), 
							tonumber(xmlNodeGetAttribute(vehicleNode, "y")), 
							tonumber(xmlNodeGetAttribute(vehicleNode, "z"))}
				local rot = {tonumber(xmlNodeGetAttribute(vehicleNode, "rx")), 
							tonumber(xmlNodeGetAttribute(vehicleNode, "ry")), 
							tonumber(xmlNodeGetAttribute(vehicleNode, "rz"))}

				local keys = {}
				for i, key in ipairs (PlayRec.controlTable) do
					if (tostring(xmlNodeGetAttribute(vehicleNode, key))) then
						keys[key] = tonumber(xmlNodeGetAttribute(vehicleNode, key))
					end
				end

				table.insert(recordInfo, {model, pos, rot, keys})
				vehicleNode = xmlFindChild(pathNode, "vehicle", i)
				i = i + 1
			end

			self.recordInfo = recordInfo
			return true
		end
	end	
	return false
end

function PlayRec:start(data)
	if not (self.vehicle) then
		self.ped = createPed(0, 0, 0, 0)
		self.vehicle = createVehicle(411, 0, 0, 0)
		warpPedIntoVehicle(self.ped, self.vehicle)
	end

	self.startTick = getTickCount()
	self.updateFunction = function ()
		self.time = (getTickCount() - self.startTick)
		self:update()
	end
	
	self.keys = {}
	self.playing = true

	addEventHandler("onClientPreRender", root, self.updateFunction)
end

function PlayRec:stop()
	removeEventHandler("onClientPreRender", root, self.updateFunction)
	self.playing = false
	self.currentRow = 1
	self.recordInfo = {}
	self.loop = true
	destroyElement(self.vehicle)
	destroyElement(self.ped)
end

function PlayRec:update()
 	local offX, offY, offZ = 0,0,0
 	local r = self.recordInfo[self.currentRow]

	local x,y,z = r[2][1] or 0, r[2][2] or 0, r[2][3] or 0
	local rx, ry, rz = r[3][1] or 0, r[3][2] or 0, r[3][3] or 0
	local vx, vy, vz = r[4][1] or 0, r[4][2] or 0, r[4][3] or 0

 	setElementPosition(self.vehicle, x + offX,y + offY, z + offZ, false)
 	setElementRotation(self.vehicle, rx, ry, rz, "default", true)

	if (r[1]) then
 		setElementModel(self.vehicle, r[1])
 	end

 	if (self.currentRow == #self.recordInfo) then
 		self.currentRow = 1
 	else
 		self.currentRow = self.currentRow + 1
 	end
 end

function PlayRec:isPlaying()
	return self.playing
end
