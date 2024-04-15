function getPlayerPosition(player)
    -- Szerezzük meg a játékos pozícióját
    local x, y, z = getElementPosition(player)

    -- Kiírjuk a pozíciót a játékos chat ablakába
    outputChatBox("A te pozíciód: X: " .. x .. ", Y: " .. y .. ", Z: " .. z, player)
end

-- Regisztráljuk a /getpos parancsot
addCommandHandler("getpos", function(player)
    getPlayerPosition(player)
end)









local pedCount = 0  -- A létrehozott pedek számát tároló változó

local pedData = {}  -- Ped adatok tárolására létrehozott tábla

-- Új, szabad ped ID meghatározása
local function getFreePedID()
    local freeID = 1
    while pedData[freeID] do
        freeID = freeID + 1
    end
    return freeID
end

-- "pa" parancs kezelése (ped létrehozása)
addCommandHandler("pa", function(player, cmd, skinID, anim)
    -- Ellenőrizzük, hogy a játékos létezik-e és online
    if not isElement(player) or getElementType(player) ~= "player" then
        outputChatBox("Hiba: Nincs ilyen játékos vagy nincs online.", player, 255, 0, 0)
        return
    end

    -- SkinID és anim ellenőrzése, ha nincsenek megadva
    if not skinID or not anim then
        outputChatBox("Használat: /pa [SkinID] [Anim]", player, 255, 0, 0)
        return
    end

    -- Szabad ped ID meghatározása
    local pedID = getFreePedID()

    -- Szerezzük meg a játékos pozícióját és nézési irányát (rotation)
    local x, y, z = getElementPosition(player)
    local _, _, rz = getElementRotation(player)

    -- A játékos nézési irányából számítsuk ki az előre mutató irányt
    local offsetX, offsetY = 1 * math.sin(math.rad(-rz)), -1 * math.cos(math.rad(-rz))
    
    -- A ped előtti pozíciót számítsuk ki a játékos pozíciójához hozzáadva az előre mutató irányt
    local pedX, pedY, pedZ = x + offsetX, y + offsetY, z

    -- Létrehozzuk a pedet a kiszámított pozícióra
    local ped = createPed(tonumber(skinID), pedX, pedY, pedZ)
    if ped then
        -- Ped adatok hozzáadása a pedData táblához
        pedData[pedID] = {
            x = pedX,
            y = pedY,
            z = pedZ,
            rotation = rz,
            name = pedID,
            animation = anim,  -- Animáció hozzárendelése
            skinID = tonumber(skinID),  -- Skin ID mentése
            dimension = 0
        }
        setPedRotation(ped, rz) -- Ped elfordítása a játékos nézési irányába
        setPedAnimation(ped, "ped", anim) -- Animáció hozzárendelése

        -- Nevezzük el a pedet
        setElementData(ped, "pedName", pedID)
        setElementFrozen(ped, true)

        -- Kiírjuk a ped nevét a játékosnak
        outputChatBox(" ", player)
        outputChatBox("Új ped létrehozva.", player) 
        outputChatBox("Ped ID: " .. pedID, player)
        outputChatBox("SkinID: " .. tonumber(skinID), player)
        outputChatBox("Animáció: " .. anim, player)
        pedCount = pedCount + 1

        -- Mentsük el a ped adatokat a fájlba
        savePedData()
    else
        outputChatBox("Hiba történt a ped létrehozása során.", player, 255, 0, 0)
    end
end)


addCommandHandler("peds", function(player)
    local zeroDimensionCount = 0

    local file = fileOpen("peds.json")
    if file then
        local jsonContent = fileRead(file, fileGetSize(file))
        if jsonContent then
            pedData = fromJSON(jsonContent) or {}

            -- Pedek létrehozása a pedData tábla alapján
            for pedID, pedInfo in pairs(pedData) do
                if pedInfo.dimension == 0 then
                    zeroDimensionCount = zeroDimensionCount + 1
                end
            end
        end
    end

    -- Kiírjuk a nulla dimenziójú pedek számát
    outputChatBox("Pedek száma: " .. zeroDimensionCount)
end)



local runned = false
-- Ped adatok betöltése a fájlból
function loadPedData()
    local file = fileOpen("peds.json")
    if file then
        local jsonContent = fileRead(file, fileGetSize(file))
        if jsonContent then
            pedData = fromJSON(jsonContent) or {}

            -- Pedek létrehozása a pedData tábla alapján
            for pedID, pedInfo in pairs(pedData) do
                local ped = createPed(pedInfo.skinID, pedInfo.x, pedInfo.y, pedInfo.z)
                setElementDimension(ped, pedInfo.dimension)
                if ped then
                    setPedRotation(ped, pedInfo.rotation)
                    setElementData(ped, "pedName", pedInfo.name)
                    local pedloc = {x = pedInfo.x, y = pedInfo.y, z = pedInfo.z}
                    setElementData(ped, "pedLocation", pedloc)
                    setElementData(ped, "pedDim", pedInfo.dimension)
                    setElementData(ped, "pedAnim", pedInfo.animation)
                    setElementID(ped, pedInfo.name)
                    setElementFrozen(ped, true)

                    setTimer(function ()
                        setPedAnimation (getElementByID(pedID), "ped", pedInfo.animation) 
                    end, 100, 1)
                    
                    -- Eseménykezelő hozzáadása a pedhez kattintás eseményre
                    addEventHandler("onElementClicked", ped, function(mouseButton, buttonState, player)
                        -- Csak a bal egérgomb lenyomását figyeljük
                        if mouseButton == "left" and buttonState == "down" then
                            -- Ellenőrizzük, hogy a kattintás a játékosra történt-e
                            if player and getElementType(player) == "player" then
                                -- Kattintás utáni műveletek végrehajtása
                                local skinID = pedInfo.skinID
                                local animation = pedInfo.animation
                                outputChatBox(" ", player)
                                outputChatBox("Ped ID: " .. pedID, player)
                                outputChatBox("SkinID: " .. skinID, player)
                                outputChatBox("Animáció: " .. animation, player)
                            end
                        end
                    end)
                else
                    outputDebugString("Hiba történt a ped létrehozása során.", 2)
                end
            end
        else
            pedData = {}  -- Üres tábla létrehozása, ha a fájl tartalma érvénytelen
        end
        fileClose(file)
        outputDebugString("Ped adatok sikeresen betöltve a peds.json fájlból.")
    else
        pedData = {}  -- Üres tábla létrehozása, ha a fájl nem található vagy nem nyitható meg
        outputDebugString("Hiba: Nem sikerült megnyitni a peds.json fájlt.", 2)
    end
end

-- Ped adatok mentése a fájlba
function savePedData()
    local jsonContent = toJSON(pedData)
    local file = fileCreate("peds.json")
    if file then
        fileWrite(file, jsonContent)
        fileClose(file)
    end
end

-- Szerver indításakor betöltjük a ped adatokat
addEventHandler("onResourceStart", resourceRoot, loadPedData)

-- "/gotoped" parancs kezelése
addCommandHandler("gotoped", function(player, cmd, pedID)
    if not pedID then
        outputChatBox("Használat: /gotoped [Ped ID]", player, 255, 0, 0)
        return
    end

    -- Azonosító konvertálása szám típusra
    pedID = tonumber(pedID)

    -- Ped keresése az azonosító alapján a pedData táblában
    local pedName = getElementByID(pedID)
    local peddim = getElementData(pedName, "pedDim")
    if pedName then
        if peddim == 0 then
            -- Játékos pozíciójának beállítása a ped pozíciójára
            local pedLoc = getElementData(pedName, "pedLocation")
            setElementPosition(player, pedLoc.x+1, pedLoc.y, pedLoc.z)
            outputChatBox("Sikeresen odaléptél a(z) " .. pedID .. ". ID-jű pedhez.", player)

            -- Kör alakú marker létrehozása a ped körül
            local marker = createMarker(pedLoc.x, pedLoc.y, pedLoc.z-1, "cylinder", 1, 53, 130, 252, 150)
            
            -- Marker eltüntetése 3 másodperc után
            setTimer(function()
                if isElement(marker) then
                    destroyElement(marker)
                end
            end, 3000, 1)
        else
            outputChatBox("Törölt Ped-re nem tudsz gotozni.", player, 255, 0, 0)
        end
    else
        -- Ha nem található a megadott ped azonosító
        outputChatBox("Nem található ped azonosítóval: " .. pedID, player, 255, 0, 0)
    end
end)

-- "/editped" parancs kezelése
addCommandHandler("editped", function(player, cmd, pedID, skinID, anim)
    -- Ellenőrizzük, hogy a játékos létezik-e és online
    if not isElement(player) or getElementType(player) ~= "player" then
        outputChatBox("Hiba: Nincs ilyen játékos vagy nincs online.", player, 255, 0, 0)
        return
    end

    -- Ellenőrizzük, hogy megadták-e az összes szükséges paramétert
    if not pedID or not skinID or not anim then
        outputChatBox("Használat: /editped [ID] [SkinID] [Anim]", player, 255, 0, 0)
        return
    end

    -- Azonosító konvertálása szám típusra
    pedID = tonumber(pedID)
    skinID = tonumber(skinID)

    -- Ellenőrizzük, hogy létezik-e a megadott ped azonosítóval ped
    local pedInfo = pedData[pedID]
    if pedInfo then
        -- Módosítjuk a ped adatokat
        pedInfo.skinID = skinID
        pedInfo.animation = anim

        -- Frissítjük a JSON fájlt az új adatokkal
        savePedData()

        -- Megkeressük és töröljük a régi pedet a játékban
        local oldPed = getElementByID(pedID)
        if oldPed then
            destroyElement(oldPed)
        end

        -- Létrehozzuk az új pedet azonos pozícióban és elfordulásban
        local x, y, z = pedInfo.x, pedInfo.y, pedInfo.z
        local rotation = pedInfo.rotation
        local newPed = createPed(skinID, x, y, z, rotation)

        -- Ellenőrizzük, hogy sikeresen létrejött-e az új ped
        if newPed then
            -- Beállítjuk az új ped nevét és animációját
            setElementData(newPed, "pedName", pedID)
            setPedAnimation(newPed, "ped", anim)

            -- Visszajelzés a játékosnak
            outputChatBox("A(z) " .. pedID .. ". ID-jű ped skinID-je és animációja sikeresen módosítva.", player)
        else
            outputChatBox("Hiba történt az új ped létrehozása során.", player, 255, 0, 0)
        end
    else
        -- Ha nem található a megadott ped azonosító
        outputChatBox("Nem található ped azonosítóval: " .. pedID, player, 255, 0, 0)
    end
end)




--másnál nem tünik el ha más írja be

-- "delped" parancs kezelése (ped törlése)
addCommandHandler("delped", function(player, cmd, pedID)
    -- Ellenőrizzük, hogy a játékos létezik-e és online
    if not isElement(player) or getElementType(player) ~= "player" then
        outputChatBox("Hiba: Nincs ilyen játékos vagy nincs online.", player, 255, 0, 0)
        return
    end

    -- Ped azonosítójának ellenőrzése
    if not pedID then
        outputChatBox("Használat: /delped [PedID]", player, 255, 0, 0)
        return
    end

    -- Azonosító konvertálása szám típusra
    pedID = tonumber(pedID)

    -- Megkeressük a pedet az azonosító alapján
    local pedInfo = nil
    for id, info in pairs(pedData) do
        if id == pedID then
            pedInfo = info
            break
        end
    end

    if pedInfo then
        -- Ped törlése a játék világából
        local pedElement = getElementByID(pedID)
        if pedElement then
            destroyElement(pedElement)
        end

        -- Ped dimension értékének beállítása 1-re a JSON-ban
        pedInfo.dimension = 1

        -- JSON fájl frissítése
        savePedData()

        -- Visszajelzés a játékosnak a sikeres törlésről
        outputChatBox("A(z) " .. pedID .. ". ID-jű ped sikeresen törölve lett.", player)
    else
        -- Ha nem található a megadott ped azonosítóval rendelkező ped
        outputChatBox("Nem található ped azonosítóval: " .. pedID, player, 255, 0, 0)
    end
end)
