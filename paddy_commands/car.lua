addCommandHandler("createcar", function(player, command, carID)
    -- Ellenőrizzük, hogy a játékos létezik-e és online van-e
    if not isElement(player) or getElementType(player) ~= "player" then
        outputChatBox("Hiba: Nincs ilyen játékos vagy nincs online.", player, 255, 0, 0)
        return
    end

    -- Ellenőrizzük, hogy az autó ID egy szám-e
    if not tonumber(carID) then
        outputChatBox("Használat: /createcar [ID]", player, 255, 0, 0)
        return
    end

    -- Konvertáljuk az autó ID-t számmá
    carID = tonumber(carID)

    -- Játékos pozíciójának és forgatásának lekérése
    local x, y, z = getElementPosition(player)
    local _, _, rotation = getElementRotation(player)

    -- Játékos dimenziójának lekérése
    local dimension = getElementDimension(player)

    -- Autó létrehozása a játékos pozíciójában és forgatásával
    local vehicle = createVehicle(carID, x, y, z, 0, 0, rotation)

    -- Ha az autót sikeresen létrehozták
    if vehicle then
        -- Játékos beszállítása az autóba
        warpPedIntoVehicle(player, vehicle)

        -- Autó dimenziójának beállítása a játékos dimenziójára
        setElementDimension(vehicle, dimension)

        outputChatBox("Autó sikeresen létrehozva.", player)
        saveCarData()
    else
        outputChatBox("Hiba történt az autó létrehozása közben.", player, 255, 0, 0)
    end
end)


local carData = {}
function saveCarData()
    local carData = {}

    -- Végigiterálunk az összes járművön
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        -- A jármű adatainak gyűjtése
        local x, y, z = getElementPosition(vehicle)
        local rx, ry, rz = getElementRotation(vehicle)
        local dimension = getElementDimension(vehicle)
        local modelID = getElementModel(vehicle)
        local color = {getVehicleColor(vehicle, true)}
        local isTemp = getElementData(vehicle, "temp")
        local carIDm = tonumber(getElementData(vehicle, "carID")) or 0

        -- Jármű adatok hozzáadása a carData táblához
        table.insert(carData, {
            carID = carIDm,
            x = x,
            y = y,
            z = z,
            rotation = {rx, ry, rz},
            dimension = dimension,
            modelID = modelID,
            color = color,
            started = false,
            headlight = false,
            seat_bh = -1,
            seat_je = -1,
            seat_jh = -1,
            seat_driver = -1
            
        })
    end

    -- JSON formátumba alakítás
    local jsonContent = toJSON(carData)

    -- Beállítjuk a JSON formázását a sortörések kezeléséhez
    jsonContent = string.gsub(jsonContent, "%}", "}\n")

    -- Hozzáadjuk a sortörést a kezdetére és a végére

    -- Fájlba írás
    local file = fileCreate("cars.json")
    if file then
        fileWrite(file, jsonContent)
        fileClose(file)
        outputDebugString("Autó adatok sikeresen mentve a cars.json fájlba.")
    else
        outputDebugString("Hiba történt az autó adatok mentése közben.", 2)
    end
end

function loadCarsFromJSON()
    -- Ellenőrizzük, hogy a cars.json fájl létezik-e
    if not fileExists("cars.json") then
        outputDebugString("Hiba: A cars.json fájl nem található.", 2)
        return
    end

    -- Fájl beolvasása
    local file = fileOpen("cars.json")
    if file then
        local jsonContent = fileRead(file, fileGetSize(file))
        fileClose(file)

        -- JSON tartalom dekódolása
        local carData = fromJSON(jsonContent)
        if not carData then
            outputDebugString("Hiba: Nem sikerült dekódolni a cars.json fájlt.", 2)
            return
        end

        -- Autók létrehozása a betöltött adatok alapján
        for _, carInfo in ipairs(carData) do
            local x, y, z = carInfo.x, carInfo.y, carInfo.z
            local rx, ry, rz = unpack(carInfo.rotation)
            local modelID = carInfo.modelID
            local dimension = carInfo.dimension
            local color = carInfo.color
            local carID = _

            -- Autó létrehozása és beállítása
            local vehicle = createVehicle(modelID, x, y, z, rx, ry, rz)
            if vehicle then
                setElementDimension(vehicle, dimension)
                setVehicleColor(vehicle, unpack(color))
                -- Beállítjuk a carID-t az autóhoz
                setElementData(vehicle, "carID", carID)
                
                -- NPC hozzáadása az adott ülésekhez
                if carInfo.seat_driver ~= -1 then
                    local npc = createPed(carInfo.seat_driver, x, y, z)
                    warpPedIntoVehicle(npc, vehicle, 0)
                end
                
                if carInfo.seat_je ~= -1 then
                    local npc = createPed(carInfo.seat_je, x, y, z)
                    warpPedIntoVehicle(npc, vehicle, 1)
                end

                if carInfo.seat_bh ~= -1 then
                    local npc = createPed(carInfo.seat_bh, x, y, z)
                    warpPedIntoVehicle(npc, vehicle, 2)
                end
                
                if carInfo.seat_jh ~= -1 then
                    local npc = createPed(carInfo.seat_jh, x, y, z)
                    warpPedIntoVehicle(npc, vehicle, 3)
                end
            else
                outputDebugString("Hiba történt az autó létrehozása közben.", 2)
            end
        end

        outputDebugString("Autók sikeresen betöltve a cars.json fájlból.")
    else
        outputDebugString("Hiba történt a cars.json fájl megnyitása közben.", 2)
    end
end


-- Autók betöltése a szkript indításakor
addEventHandler("onResourceStart", resourceRoot, loadCarsFromJSON)

-- A player beszállásának eseménykezelője
addEventHandler("onVehicleEnter", root, function(player, seat)
    if player and seat == 0 then -- Ellenőrizzük, hogy a játékos vezetői ülésben ül-e
        local vehicle = source -- Az autó, amibe a játékos beszállt

        -- Az autóhoz tartozó carID lekérése
        local carID = tonumber(getElementData(vehicle, "carID")) or 0

        -- Megkeressük az autót az adatok között
        local foundCar = nil
        for _, car in ipairs(carData) do
            if car.carID == carID then
                foundCar = car
                break
            end
        end

        -- Ha megtaláltuk az autót
        if foundCar then
            -- Beállítjuk az autó pozícióját és rotációját
            setElementPosition(vehicle, foundCar.x, foundCar.y, foundCar.z)
            setElementRotation(vehicle, unpack(foundCar.rotation))

            -- Kiírjuk a chatre a carID-t
            outputChatBox("CarID: " .. carID, player)
        end
    end
end)

-- A player kiszállásának eseménykezelője
addEventHandler("onVehicleExit", root, function(player, seat)
    if player and seat == 0 then -- Ellenőrizzük, hogy a játékos vezette-e a kocsit
        local vehicle = source -- Az elhagyott jármű
        local isTemp = getElementData(vehicle, "temp")

        -- Az autó adatainak frissítése a carData táblában
        for _, car in ipairs(carData) do
            if car.vehicle == vehicle then
                local x, y, z = getElementPosition(vehicle)
                local rx, ry, rz = getElementRotation(vehicle)
                car.x, car.y, car.z = x, y, z
                car.rotation = {rx, ry, rz}
                break
            end
        end

        -- Ha nem ideiglenes jármű akkor mentsük el.
        if not isTemp == "True" then
            saveCarData()
        end
    end
end)

function changeCarLightsColor ( thePlayer, command, red, green, blue )
	local theVehicle = getPedOccupiedVehicle ( thePlayer )
	if ( not theVehicle ) then
		return outputChatBox( "You don't have vehicle!" )
	end
	red = tonumber ( red )
	green = tonumber ( green )
	blue = tonumber ( blue )
	-- check if the colour values for red, green and blue are valid
	if red and green and blue then
		local color = setVehicleHeadLightColor ( theVehicle, red, green, blue )
		if(not color) then
			outputChatBox( "Failed to change vehicle lights color" )
		else
			outputChatBox ( "Vehicle lights color changed sucessfully" )
		end
	else
		outputChatBox( "Failed to change vehicle lights color" )
	end
end
addCommandHandler ( "carlights", changeCarLightsColor )

addCommandHandler("attach", function(player, command, seat, skinID)
    -- Ellenőrizzük, hogy a játékos járműben ül-e
    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then
        outputChatBox("Nem ülsz járműben.", player, 255, 0, 0)
        return
    end
    
    -- Ellenőrizzük, hogy helyes-e az ülés paraméter
    if not seat or not skinID then
        outputChatBox("Helyes parancshasználat: /attach [je/jh/bh] [skinID]", player, 255, 0, 0)
        return
    end
    
    -- Ellenőrizzük, hogy van-e még szabad hely az adott ülésen
    local seatIndex
    if seat == "je" then
        seatIndex = 1
    elseif seat == "bh" then
        seatIndex = 2
    elseif seat == "jh" then
        seatIndex = 3
    end
    
    local passenger = getVehicleOccupant(vehicle, seatIndex)
    if passenger then
        outputChatBox("Az adott ülés már foglalt.", player, 255, 0, 0)
        return
    end
    
    -- Létrehozzuk az NPC-t és ültetjük az autóba
    local x, y, z = getElementPosition(vehicle)
    local npc = createPed(skinID, x, y, z)
    warpPedIntoVehicle(npc, vehicle, seatIndex)
    
    outputChatBox("Az NPC-t sikeresen ültették az anyósülésre.", player, 0, 255, 0)
end)


addCommandHandler("fixveh", function(player)
    -- Ellenőrizze, hogy a játékos egy járműben ül-e
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        -- Javítsa ki a járművet
        fixVehicle(vehicle)

        -- Visszajelzés a játékosnak
        outputChatBox("A járművet megjavították.", player, 0, 255, 0)
    else
        outputChatBox("Nem ülsz autóban", player, 255,0,0)
    end
end)

-- Ideiglenesen létrehoz egy motort.
addCommandHandler("car", function(player)
    local x, y, z = getElementPosition(player)
    local _, _, rotation = getElementRotation(player)

    -- Játékos dimenziójának lekérése
    local dimension = getElementDimension(player)

    -- Autó létrehozása a játékos pozíciójában és forgatásával
    local vehicle = createVehicle(468, x, y, z, 0, 0, rotation)

    -- Ha az autót sikeresen létrehozták
    if vehicle then
        -- Játékos beszállítása az autóba
        warpPedIntoVehicle(player, vehicle)
        setElementData(vehicle, "temp", "True")
    end
end)




addEventHandler( "onResourceStop", root,
    function( resource )
        if resource == "paddy_commands" then
            saveCarData()
        end
    end
)