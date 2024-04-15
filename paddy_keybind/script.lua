function toggleCursor()
    local cursorState = isCursorShowing() -- Retrieve the state of the player's cursor
    local cursorStateOpposite = not cursorState -- The logical opposite of the cursor state

    showCursor(cursorStateOpposite) -- Setting the new cursor state
end

bindKey("m", "down", toggleCursor) -- Assigning our toggleCursor function to the 'm' key press.

function toggleVehicleLights(player)
    if isPedInVehicle(player) then
        local vehicle = getPedOccupiedVehicle(player)
        if vehicle then
            if getVehicleOverrideLights(vehicle) ~= 2 then
                setVehicleOverrideLights(vehicle, 2) -- Lámpák bekapcsolása
            else
                setVehicleOverrideLights(vehicle, 1) -- Lámpák kikapcsolása
            end
        end
    end
end

function onClientKey(key, keyState)
    if key == "l" and keyState == "down" then -- Ellenőrzés, hogy az "L" gombot lenyomták-e
        toggleVehicleLights(localPlayer) -- Lámpák be- vagy kikapcsolása a játékos által vezetett járművön
    end
end

-- Az "L" billentyű lenyomásának lekötése a lámpák be- és kikapcsolásához
bindKey("l", "down", onClientKey)

function toggleEngine()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and getVehicleController(vehicle) == localPlayer then
		setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
	end
end

bindKey("j", "down", toggleEngine)

addCommandHandler ("fly",  
    function () 
        if not flyEnabled then 
            setWorldSpecialPropertyEnabled ( "aircars", true ) 
            flyEnabled = true 
        else 
            setWorldSpecialPropertyEnabled ( "aircars", false ) 
            flyEnabled = false 
        end 
    end 
) 