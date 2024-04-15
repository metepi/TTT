
local fileName = "path.xml"
local tagName = "root"
local childName = "vehicle"

local playrec = PlayRec.create()

controlTable = {"accelerate", "brake_reverse", "handbrake", "vehicle_secondary_fire", "vehicle_left", "vehicle_right"}

local savePos = {}

function record()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)
	local model = getElementModel(vehicle)

    idk = {
    	model = model, 
    	x = x, 
    	y = y, 
    	z = z, 
    	rx = rx, 
    	ry = ry, 
    	rz = rz
	}
	
    for i, state in ipairs (controlTable) do
    	local b = getPedControlState(state)
    	idk[state] = (b and '1' or '0')
    end

    table.insert(savePos, idk)
end

function alo()
	local loadFile = xmlLoadFile("path.xml", "root")
	if not (loadFile) then
		loadFile = xmlCreateFile("path.xml", "root")
	end
	for i, v in ipairs(savePos) do
	    local createChild = xmlCreateChild(loadFile, "vehicle")

		xmlNodeSetAttribute(createChild, "model", v.model)
		xmlNodeSetAttribute(createChild, "x", v.x)
	    xmlNodeSetAttribute(createChild, "y", v.y)
		xmlNodeSetAttribute(createChild, "z", v.z)
		xmlNodeSetAttribute(createChild, "rx", v.rx)
	    xmlNodeSetAttribute(createChild, "ry", v.ry)
	    xmlNodeSetAttribute(createChild, "rz", v.rz)

	    for i, state in ipairs (controlTable) do
	   		xmlNodeSetAttribute(createChild, state, v[state])
	    end
	end

  	xmlSaveFile(loadFile)
	xmlUnloadFile(loadFile)
end
addCommandHandler("rsave", alo)

addCommandHandler("rec", function()
	outputChatBox("recording")
	addEventHandler("onClientRender", root, record)
end)

addCommandHandler("rs", function() 
	outputChatBox("record stoped")
	removeEventHandler("onClientRender", root, record)
end)

addCommandHandler("play", function() 
	if not (playrec:load("path.xml")) then
		outputChatBox("error to load rec")
	else
		outputChatBox("loading rec")
	end

	playrec:start()
end)