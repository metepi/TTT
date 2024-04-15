--[[
    # Resource Name
	  Recon HUD
	# Author
	  Rage
	# Date created
	  19.04.2014
	# Last update
	  18.07.2014
	# Copyright (c)
	  If you edit it, then please respect me and keep
	  the credits.
	# Contact
	  Homepage: http://rageresources.blogspot.com/
	  Facebook: https://www.facebook.com/pages/Rage-Scripting/1404262109835386?ref=hl
	  Community profile: http://community.mtasa.com/index.php?p=profile&id=370323
--]]

--# Resolution fix
local screenW,screenH = guiGetScreenSize()
local resW,resH = 1280,720
local sW,sH =  (screenW/resW), (screenH/resH)

    function drawHUD()
	    --# Health
	    local playerHealth = math.floor (getElementHealth( getLocalPlayer() ))
            dxDrawRectangle(1040*sW, 10*sH, 230*sW, 38*sH, tocolor(0, 0, 0, 75), true)
            dxDrawLine(1040*sW, 10*sH, 1050*sW, 10*sH, tocolor(156, 254, 133, 255), 1, true)
            dxDrawLine(1040*sW, 48*sH, 1050*sW, 48*sH, tocolor(156, 254, 133, 255), 1, true)
            dxDrawLine(1260*sW, 48*sH, 1270*sW, 48*sH, tocolor(156, 254, 133, 255), 1, true)
            dxDrawLine(1260*sW, 10*sH, 1270*sW, 10*sH, tocolor(156, 254, 133, 255), 1, true)
            dxDrawLine(1040*sW, 10*sH, 1040*sW, 49*sH, tocolor(156, 254, 133, 255), 1, true)
            dxDrawLine(1270*sW, 10*sH, 1270*sW, 49*sH, tocolor(156, 254, 133, 255), 1, true)			
            dxDrawImage(1044*sW, 14*sH, 30*sW, 30*sH, "img/health.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
            dxDrawRectangle(1084*sW, 33*sH, 176*sW, 11*sH, tocolor(0, 0, 0, 80), true)	
            dxDrawText( string.gsub( getPlayerName( localPlayer ), "#%x%x%x%x%x%x", "" ), 1084*sW, 19*sH, 1206*sW, 33*sH, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, true, false, false)			
            dxDrawRectangle(1084*sW, 33*sH, 176*sW/100*playerHealth, 11*sH, tocolor(156, 254, 133, 255), true)				
            dxDrawText(""..playerHealth.."/100", 1212*sW, 19*sH, 1260*sW, 33*sH, tocolor(156, 254, 133, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
        --# Armour
	    local playerArmor = math.floor (getPedArmor( getLocalPlayer() ))	
	        dxDrawRectangle(1040*sW, 55*sH, 230*sW, 38*sH, tocolor(0, 0, 0, 75), true)
            dxDrawLine(1040*sW, 55*sH, 1050*sW, 55*sH, tocolor(6, 128, 213, 255), 1, true)
            dxDrawLine(1260*sW, 55*sH, 1270*sW, 55*sH, tocolor(6, 128, 213, 255), 1, true)			
            dxDrawLine(1040*sW, 93*sH, 1050*sW, 93*sH, tocolor(6, 128, 213, 255), 1, true)
            dxDrawLine(1260*sW, 93*sH, 1270*sW, 93*sH, tocolor(6, 128, 213, 255), 1, true)
            dxDrawLine(1040*sW, 55*sH, 1040*sW, 93*sH, tocolor(6, 128, 213, 255), 1, true)
            dxDrawLine(1270*sW, 55*sH, 1270*sW, 93*sH, tocolor(6, 128, 213, 255), 1, true)		
            dxDrawImage(1044*sW, 60*sH, 30*sW, 30*sH, "img/sheild.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)	
            dxDrawRectangle(1084*sW, 79*sH, 176*sW, 11*sH, tocolor(0, 0, 0, 80), true)	
            dxDrawRectangle(1084*sW, 79*sH, 176*sW/100*playerArmor, 11*sH, tocolor(6, 128, 213, 255), true)
            dxDrawText(""..playerArmor.."/100", 1212*sW, 110*sH, 1260*sW, 33*sH, tocolor(6, 128, 213, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)		
	    --# Oxygen
		--math.ceil(current oxygen / 100)
		local playerOxygen = math.floor( getPedOxygenLevel( getLocalPlayer() ))
        if ( playerOxygen < 1000 or isElementInWater( getLocalPlayer() )) then
	        dxDrawRectangle(1040*sW, 100*sH, 230*sW, 38*sH, tocolor(0, 0, 0, 75), true)	
            dxDrawLine(1040*sW, 100*sH, 1050*sW, 100*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1260*sW, 100*sH, 1270*sW, 100*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1040*sW, 137*sH, 1050*sW, 137*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1260*sW, 137*sH, 1270*sW, 137*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1040*sW, 100*sH, 1040*sW, 137*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1270*sW, 100*sH, 1270*sW, 137*sH, tocolor(27, 214, 255, 255), 1, true)		
            dxDrawRectangle(1084*sW, 123*sH, 176*sW, 11*sH, tocolor(0, 0, 0, 80), true)	
            dxDrawRectangle(1084*sW, 123*sH, 176*sW/1000*playerOxygen, 11*sH, tocolor(27, 214, 255, 255), true)			
            dxDrawImage(1044*sW, 105*sH, 30*sW, 30*sH, "img/oxygen.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
            dxDrawText(""..playerOxygen.."/1000", 1203*sW, 200*sH, 1260*sW, 33*sH, tocolor(27, 214, 255, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)	
		end
        --# Weapon Interface
		local weaponAmmo = getPedTotalAmmo (getLocalPlayer())
        local weaponClip = getPedAmmoInClip (getLocalPlayer())
	    local weaponID = getPedWeapon(localPlayer)
	    local weaponName = getWeaponNameFromID(weaponID)
	    local weaponSlot = getPedWeaponSlot(getLocalPlayer())	
        if not ( isPedInVehicle(localPlayer) ) then		
            dxDrawText(weaponClip.."/#1BD6FF"..weaponAmmo,1050*sW, 645*sH, 1165*sW, 670*sH, tocolor(255, 255, 255, 255), 1.80, "arial", "left", "center", false, false, true, true, false)
            dxDrawRectangle(1040*sW, 634*sH, 230*sW, 51*sH, tocolor(0, 0, 0, 75), false)
            --dxDrawRectangle(1050*sW, 670*sH, 114*sW, 11*sH, tocolor(0, 0, 0, 80), true)
            --dxDrawRectangle(1050*sW, 670*sH, 114*sW, 11*sH, tocolor(27, 214, 255, 255), true)			
            dxDrawLine(1040*sW, 634*sH, 1050*sW, 634*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1040*sW, 685*sH, 1050*sW, 685*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1260*sW, 685*sH, 1270*sW, 685*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1260*sW, 634*sH, 1270*sW, 634*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1040*sW, 634*sH, 1040*sW, 685*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawLine(1270*sW, 634*sH, 1270*sW, 685*sH, tocolor(27, 214, 255, 255), 1, true)
            dxDrawImage(1150*sW, 635*sH, 120*sW, 50*sH, "img/weapons/"..tostring( weaponID ).. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)	
		end
		--# Vehicle Interface
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	    if ( vehicle ) then
		    local speedx, speedy, speedz = getElementVelocity ( vehicle  )
		    local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
		    local kmh = math.floor(actualspeed*180)	
		    if ( getElementHealth(vehicle) >= 999 ) then
		        vehiclehealth = 100
		    else
		        vehiclehealth = math.floor(getElementHealth ( vehicle )/10)
		    end
			if ( vehiclehealth <= 35 ) then
			    dxDrawRectangle(1040*sW, 586*sH, 230*sW, 25*sH, tocolor(0, 0, 0, 75), false)
                dxDrawLine(1040*sW, 585*sH, 1050*sW, 585*sH, tocolor(200, 0, 0, 255), 1, true)
                dxDrawLine(1040*sW, 611*sH, 1050*sW, 611*sH, tocolor(200, 0, 0, 255), 1, true)
                dxDrawLine(1260*sW, 611*sH, 1270*sW, 611*sH, tocolor(200, 0, 0, 255), 1, true)
                dxDrawLine(1260*sW, 585*sH, 1270*sW, 585*sH, tocolor(200, 0, 0, 255), 1, true)
                dxDrawLine(1040*sW, 586*sH, 1040*sW, 611*sH, tocolor(200, 0, 0, 255), 1, true)
                dxDrawLine(1270*sW, 585*sH, 1270*sW, 612*sH, tocolor(200, 0, 0, 255), 1, true)
                dxDrawRectangle(1084*sW, 652*sH, 176*sW, 11, tocolor(0, 0, 0, 80), true)
                dxDrawText("CRITICAL DAMAGE!", 1040*sW, 585*sH, 1270*sW, 611*sH, tocolor(200, 0, 0, 255), 1.20, "default-bold", "center", "center", false, false, true, false, false)
		    end
        dxDrawRectangle(1040*sW, 617*sH, 230*sW, 51*sH, tocolor(0, 0, 0, 75), false)
        dxDrawLine(1040*sW, 617*sH, 1050*sW, 617*sH, tocolor(156, 254, 133, 255), 1, true)
        dxDrawLine(1040*sW, 668*sH, 1050*sW, 668*sH, tocolor(156, 254, 133, 255), 1, true)
        dxDrawLine(1260*sW, 668*sH, 1270*sW, 668*sH, tocolor(156, 254, 133, 255), 1, true)
        dxDrawLine(1260*sW, 617*sH, 1270*sW, 617*sH, tocolor(156, 254, 133, 255), 1, true)
        dxDrawLine(1040*sW, 617*sH, 1040*sW, 668*sH, tocolor(156, 254, 133, 255), 1, true)
        dxDrawLine(1270*sW, 617*sH, 1270*sW, 668*sH, tocolor(156, 254, 133, 255), 1, true)
        dxDrawRectangle(1084*sW, 652*sH, 176*sW, 11*sH, tocolor(0, 0, 0, 80), true)
        dxDrawRectangle(1084*sW, 652*sH, 176*sW/100*vehiclehealth, 11*sH, tocolor(156, 254, 133, 255), true)		
        dxDrawImage(1050*sW, 640*sH, 25*sW, 25*sH, "img/wrench.png", 0, 0, 0, tocolor(255, 254, 254, 255), true)
        dxDrawText(vehiclehealth.."/100", 1203*sW, 1020*sH, 1260*sW, 270*sH, tocolor(156, 254, 133, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
        dxDrawText(kmh.." km/h", 1084*sW, 600*sH, 1205*sW, 666*sH, tocolor(255, 255, 255, 255), 1.80, "default", "left", "center", false, false, true, false, false)		
		end
		--# Nitro
        if ( isPedInVehicle(localPlayer) ) then
            local g_Vehicle = getPedOccupiedVehicle( localPlayer )
		    if ( g_Vehicle ) then
				local Nitro = getVehicleNitroLevel( g_Vehicle )
	            if ( Nitro ~= false and Nitro ~= nil and Nitro > 0 ) then
					dxDrawText(math.floor(Nitro/1*100).."/100", 1203*sW, 1095*sH, 1260*sW, 270*sH, tocolor(6, 128, 213, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
                    dxDrawRectangle(1040*sW, 675*sH, 230*sW, 31*sH, tocolor(0, 0, 0, 80), false)						
                    dxDrawLine(1040*sW, 675*sH, 1050*sW, 675*sH, tocolor(6, 128, 213, 255), 1, true)
                    dxDrawLine(1040*sW, 706*sH, 1050*sW, 706*sH, tocolor(6, 128, 213, 255), 1, true)
                    dxDrawLine(1260*sW, 706*sH, 1270*sW, 706*sH, tocolor(6, 128, 213, 255), 1, true)
                    dxDrawLine(1260*sW, 675*sH, 1270*sW, 675*sH, tocolor(6, 128, 213, 255), 1, true)
                    dxDrawLine(1040*sW, 675*sH, 1040*sW, 706*sH, tocolor(6, 128, 213, 255), 1, true)
                    dxDrawLine(1270*sW, 675*sH, 1270*sW, 706*sH, tocolor(6, 128, 213, 255), 1, true)
                    dxDrawRectangle(1084*sW, 690*sH, 176*sW, 11*sH, tocolor(0, 0, 0, 80), true)						
                    dxDrawRectangle(1084*sW, 690*sH, 176*sW/10*10*Nitro, 11*sH, tocolor(6, 128, 213, 255), true)
                    dxDrawImage(1050*sW, 678*sH, 25*sW, 25*sH, "img/nos.png", 0, 0, 0, tocolor(255, 254, 254, 255), true)
	            end	
            end					
        end
	end
addEventHandler( "onClientRender", root, drawHUD)

addEventHandler( "onClientPlayerWasted", root,
    function()
	    removeEventHandler("onClientRender", root, drawHUD)
    end);

addEventHandler( "onClientPlayerSpawn", root, 
    function()
	    addEventHandler( "onClientRender", root, drawHUD)
	end);

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
	    setPlayerHudComponentVisible ( "all", false )	
	    setPlayerHudComponentVisible ( "area_name", true )
	    setPlayerHudComponentVisible ( "radar", true )
	    setPlayerHudComponentVisible ( "vehicle_name", true )
	    setPlayerHudComponentVisible ( "radio", true )
	    setPlayerHudComponentVisible ( "crosshair", true )		
	end);
	
addEventHandler( "onClientResourceStop", resourceRoot,
	function()
	    setPlayerHudComponentVisible ( "all", true )
	end)	