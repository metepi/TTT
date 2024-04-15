local admintag = {
    [1] = "#3fe065[ADMIN]",
    [2] = "#3fd8e0[FŐADMIN]",
    [3] = "#e6454a[TULAJDONOS]"
}

function asay(player, message)
    for i, playerElement in ipairs(getElementsByType("player")) do
        local playerAdminLevel = getElementData(player, "adminlevel") or 0
        local adminTagText = admintag[playerAdminLevel] or ""
        outputChatBox("#ff0000[FELHÍVÁS] --" .. adminTagText .. "#ffffff " .. getPlayerName(player) .. ": " .. message, playerElement, 255, 255, 255, true)
    end
end

-- A /asay parancs kezelése
addCommandHandler("asay",
    function (player, cmd, ...)
        local message = table.concat({...}, " ") -- Az összes paramétert egyetlen üzenetté egyesíti
        local adminLevel = getElementData(player, "adminlevel") or 0 -- Az adminszint lekérése, ha nincs megadva, akkor 0
        if adminLevel > 0 then
            if message ~= "" then
                if adminLevel == 1 then
                    asay(player, message) -- Küldi az üzenetet minden játékosnak
                elseif adminLevel == 2 then
                    asay(player, message) -- Küldi az üzenetet minden játékosnak
                end
            else
                outputChatBox("Használat: /asay [üzenet]", player, 255, 255, 0) -- Hibás használat esetén hibaüzenet
            end
        else
            outputChatBox("Nincs jogosultságod ehhez a parancshoz.", player, 255, 0, 0)
        end
    end
)

function sendMessageToAll(player, message, alevel)
    for i, playerElement in ipairs(getElementsByType("player")) do
        outputChatBox(alevel .. "#ffffff " .. getPlayerName(player) .. ": #ffffff" .. message, playerElement, 255, 255, 255, true) -- "ADMIN" előtaggal és a játékos nevével együtt küldi az üzenetet a megfelelő színnel
    end
end

addEventHandler("onPlayerChat", root,
    function (message, messageType)
        local player = source
        local adminLevel = getElementData(player, "adminlevel") or 0
        if messageType == 0 and adminLevel > 0 then -- Ellenőrzi, hogy a játékos admin és az üzenet publikus
            cancelEvent() -- Megakadályozza az üzenet továbbítását a szerveren
            local alevel = ""
            if adminLevel == 1 then
                alevel = "#3fe065[ADMIN]"
            elseif adminLevel == 2 then
                alevel = "#3fd8e0[FŐADMIN]"
            elseif adminLevel == 3 then
                alevel = "#e6454a[TULAJDONOS]"
            end
            sendMessageToAll(player, message, alevel) -- Küldi az üzenetet minden játékosnak
        end
    end
)

-- A /setadmin parancs kezelése
addCommandHandler("setadmin",
    function (player, cmd, name, level)
        if not hasObjectPermissionTo(player, "function.setPlayerAdmin") then -- Ellenőrzi, hogy a parancsot indító játékosnak megvan-e a megfelelő jogosultsága
            outputChatBox("Nincs jogosultságod ehhez a parancshoz.", player, 255, 0, 0)
            return
        end
        local targetPlayer = getPlayerFromName(name)
        if not targetPlayer then
            outputChatBox("Nem található ilyen nevű játékos.", player, 255, 0, 0)
            return
        end
        local level = tonumber(level)
        if not level or level < 0 then
            outputChatBox("Hibás admin szint.", player, 255, 0, 0)
            return
        end
        setElementData(targetPlayer, "adminlevel", level) -- Beállítja a játékos admin szintjét
        local newadmin = admintag[tonumber(level)]
        if level > 0 then
            outputChatBox("#d90b34[TTT - ADMIN] #1ebbd6" .. getPlayerName(targetPlayer) .. "#ffffff Adminszintjét beállította #1ebbd6" .. getPlayerName(player) .. "#ffffff a következőre: " .. newadmin, root, 255,0,0,true)
        elseif level == 0 then
            outputChatBox("#d90b34[TTT - ADMIN] #1ebbd6" .. getPlayerName(targetPlayer) .. "#ffffff Adminszintjét elvette: #1ebbd6" .. getPlayerName(player), root, 255,0,0,true)
        end
    end
)

-- Ez a függvény küld egy üzenetet a chatre azoknak, akiknek nagyobb az adminszintjük, mint 0
function sendMessageToAdmins(player, message, towhos)
    for i, playerElement in ipairs(getElementsByType("player")) do
        local playerAdminLevel = getElementData(playerElement, "adminlevel") or 0
        local adminTagText = admintag[playerAdminLevel] or ""
        if playerAdminLevel > 0 then
            if towhos == "a" then
                outputChatBox("#3fe065{AdminChat} " .. adminTagText .. "#ffffff " .. getPlayerName(player) .. ": " .. message, playerElement, 255, 255, 255, true) -- Küldi az üzenetet az adminoknak
            elseif towhos == "fa" then
                if playerAdminLevel > 1 then
                    outputChatBox("#3fd8e0{FőAdminChat} " .. adminTagText .. "#ffffff " .. getPlayerName(player) .. ": " .. message, playerElement, 255, 255, 255, true)
                end
            end
        end
    end
end

-- A /a parancs kezelése
addCommandHandler("a",
    function (player, cmd, ...)
        local message = table.concat({...}, " ") -- Az összes paramétert egyetlen üzenetté egyesíti
        local adminLevel = getElementData(player, "adminlevel") or 0 -- Az adminszint lekérése, ha nincs megadva, akkor 0
        if adminLevel > 0 then
            if message ~= "" then
                sendMessageToAdmins(player, message, "a") -- Küldi az üzenetet csak az adminoknak
            else
                outputChatBox("Használat: /a [üzenet]", player, 255, 255, 0) -- Hibás használat esetén hibaüzenet
            end
        else
            outputChatBox("Nincs jogosultságod ehhez a parancshoz.", player, 255, 0, 0)
        end
    end
)

addCommandHandler("fa",
    function (player, cmd, ...)
        local message = table.concat({...}, " ") -- Az összes paramétert egyetlen üzenetté egyesíti
        local adminLevel = getElementData(player, "adminlevel") or 0 -- Az adminszint lekérése, ha nincs megadva, akkor 0
        if adminLevel > 1 then
            if message ~= "" then
                sendMessageToAdmins(player, message, "fa") -- Küldi az üzenetet csak az adminoknak
            else
                outputChatBox("Használat: /a [üzenet]", player, 255, 255, 0) -- Hibás használat esetén hibaüzenet
            end
        else
            outputChatBox("Nincs jogosultságod ehhez a parancshoz.", player, 255, 0, 0)
        end
    end
)

-- A /goto parancs kezelése
addCommandHandler("goto",
    function(player, cmd, targetPlayerName)
        -- Ellenőrzi, hogy a parancsot indító játékos létezik-e és online-e
        if not player or not isElement(player) or getElementType(player) ~= "player" then
            outputChatBox("Hiba: Nem található ilyen játékos.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a céljátékos neve meg van-e adva
        if not targetPlayerName then
            outputChatBox("Használat: /goto [játékosnév]", player, 255, 255, 0)
            return
        end

        -- Megkeresi a céljátékost a neve alapján
        local targetPlayer = getPlayerFromName(targetPlayerName)
        if not targetPlayer then
            outputChatBox("Hiba: Nem található ilyen játékos.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a célpont játékos online van-e
        if not isElement(targetPlayer) then
            outputChatBox("Hiba: A célpont játékos nem elérhető.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a céljátékos és a parancsot indító játékos ugyanaz-e
        if targetPlayer == player then
            outputChatBox("Hiba: Nem ugrálhatsz magadhoz.", player, 255, 0, 0)
            return
        end

        -- Teleportálja a játékost a céljátékoshoz
        local x, y, z = getElementPosition(targetPlayer)
        setElementPosition(player, x+1, y, z)

        -- Értesíti a játékost a sikeres teleportálásról
        outputChatBox("Sikeresen teleportáltál " .. getPlayerName(targetPlayer) .. " játékoshoz.", player, 0, 255, 0, true)
        outputChatBox("Hozzád teleportált " .. getPlayerName(player) .. ".", targetPlayer, 0, 255, 0)
    end
)

-- A /gethere parancs kezelése
addCommandHandler("gethere",
    function(player, cmd, targetPlayerName)
        -- Ellenőrzi, hogy a parancsot indító játékos létezik-e és online-e
        if not player or not isElement(player) or getElementType(player) ~= "player" then
            outputChatBox("Hiba: Nem található ilyen játékos.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a céljátékos neve meg van-e adva
        if not targetPlayerName then
            outputChatBox("Használat: /goto [játékosnév]", player, 255, 255, 0)
            return
        end

        -- Megkeresi a céljátékost a neve alapján
        local targetPlayer = getPlayerFromName(targetPlayerName)
        if not targetPlayer then
            outputChatBox("Hiba: Nem található ilyen játékos.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a célpont játékos online van-e
        if not isElement(targetPlayer) then
            outputChatBox("Hiba: A célpont játékos nem elérhető.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a céljátékos és a parancsot indító játékos ugyanaz-e
        if targetPlayer == player then
            outputChatBox("Hiba: Nem ugrálhatsz magadhoz.", player, 255, 0, 0)
            return
        end

        -- Teleportálja a játékost a céljátékoshoz
        local x, y, z = getElementPosition(player)
        setElementPosition(targetPlayer, x+1, y, z)

        -- Értesíti a játékost a sikeres teleportálásról
        outputChatBox("Magadhoz getelted " .. getPlayerName(targetPlayer) .. " játékoshoz.", player, 0, 255, 0, true)
        outputChatBox("Magához getelt " .. getPlayerName(player) .. ".", targetPlayer, 0, 255, 0)
    end
)

-- A /kick parancs kezelése
addCommandHandler("kick",
    function(player, cmd, targetPlayerName, ...)
        -- Ellenőrzi, hogy a parancsot indító játékos rendelkezik-e a megfelelő jogosultsággal
        if not hasObjectPermissionTo(player, "function.kickPlayer") then
            outputChatBox("Nincs jogosultságod ehhez a parancshoz.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a célpont játékos neve meg van-e adva
        if not targetPlayerName then
            outputChatBox("Használat: /kick [játékosnév] [indok]", player, 255, 255, 0)
            return
        end

        -- Megkeresi a célpont játékost a neve alapján
        local targetPlayer = getPlayerFromName(targetPlayerName)
        if not targetPlayer then
            outputChatBox("Hiba: Nem található ilyen játékos.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a célpont játékos online van-e
        if not isElement(targetPlayer) then
            outputChatBox("Hiba: A célpont játékos nem elérhető.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a célpont játékos és a parancsot indító játékos ugyanaz-e
        if targetPlayer == player then
            outputChatBox("Hiba: Nem rúghatod ki magad.", player, 255, 0, 0)
            return
        end

        -- Elküldi a célpont játékosnak az indokolt üzenetet a kickről
        local reason = "Indok: " .. table.concat({...}, " ")
        local playerAdminLevel = getElementData(player, "adminlevel") or 0
        local adminTagText = admintag[playerAdminLevel] or ""
        
        outputChatBox("#d90b34[TTT - KICK] #1ebbd6" .. getPlayerName(targetPlayer) .. "#ffffff kilett rúgva általa: #1ebbd6" .. getPlayerName(player), player, 255,0,0,true)
        local indok = table.concat({...}, " ")
        outputChatBox("#ffffffIndok: " .. reason, root, 255, 0, 0, true)
        --kickPlayer(targetPlayer, player, reason)
    end
)

addCommandHandler("alevel",
    function(player, cmd, targetPlayerName)
        -- Ellenőrzi, hogy a parancsot indító játékos rendelkezik-e a megfelelő jogosultsággal
        if not hasObjectPermissionTo(player, "function.checkAdminLevel") then
            outputChatBox("Nincs jogosultságod ehhez a parancshoz.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a céljátékos neve meg van-e adva
        if not targetPlayerName then
            outputChatBox("Használat: /alevel [játékosnév]", player, 255, 255, 0)
            return
        end

        -- Megkeresi a céljátékost a neve alapján
        local targetPlayer = getPlayerFromName(targetPlayerName)
        if not targetPlayer then
            outputChatBox("Nem található ilyen játékos.", player, 255, 0, 0)
            return
        end

        -- Ellenőrzi, hogy a céljátékos online van-e
        if not isElement(targetPlayer) then
            outputChatBox("A célpont játékos nem elérhető.", player, 255, 0, 0)
            return
        end

        -- Lekéri a céljátékos adminszintjét
        local targetAdminLevel = getElementData(targetPlayer, "adminlevel")
        if not targetAdminLevel then
            outputChatBox("A célpont játékosnak nincs adminszintje.", player, 255, 0, 0)
            return
        end

        -- Kiírja a céljátékos adminszintjét a parancsot indító játékosnak
        outputChatBox(getPlayerName(targetPlayer) .. " adminszintje: " .. targetAdminLevel, player, 0, 255, 0)
    end
)

addCommandHandler("teszt",
    function(player, cmd, targetPlayerName, level)
        local playerAdminLevel = getElementData(player, "adminlevel") or 0
        local adminTagText = admintag[playerAdminLevel] or ""
        local localplayer = adminTagText .. " " .. getPlayerName(player)
        local newadmin = admintag[tonumber(level)] or ""
        outputChatBox("#d90b34[TTT - ADMIN] #1ebbd6" .. targetPlayerName .. "#ffffff Adminszintjét beállította #1ebbd6" .. localplayer .. "#ffffff a következőre: " .. newadmin, root, 255,0,0,true)
    end
)

-- Fegyver elhelyezése a földön
function placeWeaponOnGround(x, y, z)
    local weaponObject = createObject(356, x, y, z-0.9)
    setElementCollisionsEnabled(weaponObject, true)
    setObjectRotation(weaponObject, 90, 0, 0)  -- Forgatás 90 fokkal a Z tengely körül
    return weaponObject
end

-- Fegyver kiosztása a játékosnak
function giveWeaponToPlayer(player)
    outputChatBox("Fegyver felvéve", player)
    giveWeapon(player, 31, 500)  -- M4A1 fegyver kiosztása a játékosnak
end

-- A /weapon parancs kezelése
addCommandHandler("weapon",
    function(player)
        -- A fegyver helyének meghatározása (például a játékos pozíciójában)
        local x, y, z = getElementPosition(player)

        -- Fegyver elhelyezése a földön a játékos pozíciójában és forgatása
        local weaponObject = placeWeaponOnGround(x, y, z)

        -- Fegyver collision-jének meghatározása
        local weaponColShape = createColSphere(x, y, z, 1)

        -- Ha sikerült létrehozni a fegyvert és a collision-t, akkor figyeljük meg az érintést
        if weaponObject and weaponColShape then
            addEventHandler("onColShapeHit", weaponColShape,
                function(hitElement, matchingDimension)
                    -- Ellenőrizzük, hogy a hozzáért-e a játékos
                    if hitElement and getElementType(hitElement) == "player" and matchingDimension then
                        giveWeaponToPlayer(hitElement)  -- Fegyver kiosztása a játékosnak
                        destroyElement(source)  -- Megsemmisítjük a collision-t, mivel már nem szükséges
                    end
                end
            )
        end
    end
)