local r_table = {}
local r2_table = {} -- contains positions
local startTick = 0
local pushedControls = {} -- {pushed control, forhowmuchtime, when it start to push}
local recording = false
local cs = { "fire", "aim_weapon", "next_weapon", "previous_weapon", "forwards", "backwards", "left", "right", "zoom_in", "zoom_out",
 "change_camera", "jump", "sprint", "look_behind", "crouch", "action", "walk", "conversation_yes", "conversation_no",
 "group_control_forwards", "group_control_back", "enter_exit", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right",
 "steer_forward", "steer_back", "accelerate", "brake_reverse", "radio_next", "radio_previous", "radio_user_track_skip", "horn", "sub_mission",
 "handbrake", "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind", "vehicle_mouse_look", "special_control_left", "special_control_right",
 "special_control_down", "special_control_up" }
local eventPlaying = false

local customTimer_ = {
	event = false,
	timers = {},
}

function customTimerEvent(  )
	for k, v in pairs( customTimer_.timers ) do
		if getTickCount(  ) >= v[1] then
			v[2](unpack( v[3] ))
			table.remove( customTimer_.timers, k )
		end
	end
	if #customTimer_.timers == 0 then
		removeEventHandler( "onClientRender", root, customTimerEvent )
		customTimer_.event = false
	end
end

function customTimer( time, func, ... )
	table.insert( customTimer_.timers, { getTickCount(  )+time, func, {...} } )
	if not customTimer_.event then
		addEventHandler( "onClientRender", root, customTimerEvent )
		customTimer_.event = true
	end
end

function table.contains( t, d )
	for k, v in pairs( t ) do
		if v == d then
			return k
		end
	end
	return false
end

function isAControlAlreadyPushed( thecontrol )
	for k, v in pairs( pushedControls ) do
		if v[1] == thecontrol then
			return k
		end
	end
	return false
end

function isPedInPosition( ped, position )
	if isElement( ped ) then
		local x,y,z = getElementPosition( ped )
		local rot = getPedRotation( ped )
		local x1,y1,z1,rot1 = unpack( position )
		if not (getDistanceBetweenPoints3D( x,y,z,x1,y1,z1 ) <= 1.5) then
			if isPedInVehicle( ped ) then
				--destroyElement( getPedOccupiedVehicle( ped ) )
				setElementPosition( getPedOccupiedVehicle( ped ), x1,y1,z1 )
				setElementRotation( getPedOccupiedVehicle( ped ), 0,0,rot1 )
			end
			--destroyElement( ped )
			iprint( "Ped set to the good position (dist:".. getDistanceBetweenPoints3D( x,y,z,x1,y1,z1 )..")" )
			--setElementPosition( localPlayer, x1,y1,z1 )
		end
	end
end

function readKeyPushed(  )
	for _, v in pairs( cs ) do
		if getPedControlState( localPlayer, v ) then
			if not isAControlAlreadyPushed( v ) then
				table.insert( pushedControls, {v,getTickCount(  )} )
			end
		end
	end
	for key, v in pairs( pushedControls ) do
		if not getPedControlState( localPlayer, v[1] ) then
			table.insert( r_table, {v[1],getTickCount()-v[2], v[2]-startTick} )
			local x,y,z = getElementPosition( localPlayer )
			table.insert( r2_table, {x,y,z,getPedRotation( localPlayer ),getTickCount(  )-startTick} )
			table.remove( pushedControls, key )
		end
	end
end

function record(  )
    outputChatBox("teszt", player)
	playRecord( fromJSON('[ [ 0,0,0, 359.9898681640625, 0.088134765625, 90.22314453125 ] ]'),fromJSON('[ [ [ "vehicle_right", 1309, 1319 ], [ "vehicle_right", 100, 2859 ], [ "vehicle_right", 80, 3159 ], [ "accelerate", 2489, 889 ], [ "vehicle_left", 270, 3929 ], [ "accelerate", 650, 3728 ], [ "vehicle_left", 781, 4218 ], [ "vehicle_left", 211, 5068 ], [ "vehicle_left", 280, 5388 ], [ "vehicle_left", 120, 5838 ], [ "accelerate", 1430, 4618 ], [ "vehicle_right", 131, 6318 ], [ "accelerate", 339, 6409 ], [ "accelerate", 501, 7228 ], [ "accelerate", 69, 7879 ], [ "vehicle_right", 841, 7588 ], [ "vehicle_left", 59, 9039 ], [ "vehicle_right", 79, 9399 ], [ "vehicle_right", 81, 10428 ], [ "accelerate", 2750, 8229 ], [ "vehicle_left", 70, 11799 ], [ "vehicle_left", 320, 12879 ], [ "vehicle_left", 151, 13418 ], [ "accelerate", 2400, 11199 ], [ "vehicle_left", 920, 13679 ], [ "vehicle_left", 60, 14789 ], [ "vehicle_left", 80, 15078 ], [ "vehicle_right", 91, 15668 ], [ "vehicle_right", 70, 16308 ], [ "vehicle_right", 129, 16749 ], [ "vehicle_right", 130, 17308 ], [ "vehicle_right", 119, 17579 ], [ "vehicle_right", 160, 18039 ], [ "vehicle_right", 100, 18338 ], [ "vehicle_right", 100, 18589 ], [ "vehicle_right", 120, 18888 ], [ "vehicle_right", 131, 19468 ], [ "vehicle_right", 150, 19719 ], [ "vehicle_right", 69, 20029 ], [ "accelerate", 6250, 14068 ], [ "accelerate", 629, 20699 ], [ "brake_reverse", 410, 22009 ], [ "vehicle_right", 110, 22888 ], [ "vehicle_right", 230, 23438 ], [ "vehicle_right", 359, 23799 ], [ "vehicle_right", 340, 24278 ], [ "vehicle_right", 110, 24798 ], [ "accelerate", 2539, 22629 ], [ "accelerate", 660, 25619 ], [ "accelerate", 600, 26479 ], [ "vehicle_left", 2100, 25479 ], [ "accelerate", 359, 27519 ], [ "accelerate", 329, 28369 ], [ "vehicle_left", 1081, 27698 ], [ "accelerate", 160, 29069 ], [ "vehicle_left", 419, 28840 ], [ "brake_reverse", 401, 29498 ], [ "vehicle_left", 201, 29708 ] ] ]'),fromJSON('[ [ [ -805.332763671875, 1586.018920898438, 26.63676834106445, 17.76824951171875, 2628 ], [ -805.7278442382813, 1590.235595703125, 26.65402030944824, 6.111785888671875, 2959 ], [ -805.9424438476563, 1594.342529296875, 26.64418029785156, 2.92852783203125, 3239 ], [ -805.977294921875, 1596.57177734375, 26.64223480224609, 1.303558349609375, 3378 ], [ -806.4583740234375, 1607.8291015625, 26.65570831298828, 6.170013427734375, 4199 ], [ -807.1010131835938, 1610.39599609375, 26.65960502624512, 13.30154418945313, 4378 ], [ -811.9795532226563, 1616.3564453125, 26.65828323364258, 51.98773193359375, 4999 ], [ -815.5377197265625, 1617.900268554688, 26.65497398376465, 67.28717041015625, 5279 ], [ -821.5682373046875, 1619.058227539063, 26.65280342102051, 82.38897705078125, 5668 ], [ -826.6240844726563, 1619.147216796875, 26.65061950683594, 89.57000732421875, 5958 ], [ -828.2620849609375, 1619.061767578125, 26.65007781982422, 91.87484741210938, 6048 ], [ -834.685791015625, 1618.864135742188, 26.64398574829102, 90.49261474609375, 6449 ], [ -839.3173217773438, 1619.13330078125, 26.65044975280762, 87.17523193359375, 6748 ], [ -851.8325805664063, 1619.816772460938, 26.63486480712891, 85.52615356445313, 7729 ], [ -854.6199340820313, 1620.459716796875, 26.63213920593262, 77.11703491210938, 7948 ], [ -858.570068359375, 1623.577392578125, 26.63924980163574, 44.42379760742188, 8429 ], [ -863.0845336914063, 1630.6728515625, 26.65344047546387, 33.3341064453125, 9098 ], [ -866.5885620117188, 1635.771850585938, 26.6611270904541, 34.11697387695313, 9478 ], [ -877.727783203125, 1653.282958984375, 26.71584129333496, 31.97711181640625, 10509 ], [ -883.3809814453125, 1662.869750976563, 26.78210639953613, 30.56112670898438, 10979 ], [ -893.9291381835938, 1680.693359375, 26.9169807434082, 30.95782470703125, 11869 ], [ -913.4273681640625, 1710.665649414063, 27.07010078430176, 39.35479736328125, 13199 ], [ -920.779541015625, 1718.41162109375, 27.35814666748047, 45.32049560546875, 13569 ], [ -921.4205932617188, 1719.004516601563, 27.39833068847656, 46.22787475585938, 13599 ], [ -943.166259765625, 1729.1845703125, 29.11658668518066, 85.14321899414063, 14599 ], [ -949.1246337890625, 1729.225708007813, 29.44645118713379, 89.859375, 14849 ], [ -956.7573852539063, 1729.057495117188, 29.7934455871582, 91.652587890625, 15158 ], [ -972.1607055664063, 1728.269897460938, 30.27086639404297, 92.42922973632813, 15759 ], [ -989.0933837890625, 1727.961791992188, 30.54391288757324, 90.70236206054688, 16378 ], [ -1003.445617675781, 1728.112548828125, 30.66239166259766, 88.289306640625, 16878 ], [ -1020.304504394531, 1729.227294921875, 30.72439575195313, 85.0517578125, 17438 ], [ -1028.371704101563, 1730.229614257813, 30.74590301513672, 81.92257690429688, 17698 ], [ -1044.19140625, 1733.105224609375, 30.91395950317383, 78.12490844726563, 18199 ], [ -1051.878662109375, 1735.0224609375, 31.01696968078613, 75.20703125, 18438 ], [ -1059.918823242188, 1737.432373046875, 31.22837257385254, 72.75799560546875, 18689 ], [ -1070.129638671875, 1740.948852539063, 31.47385025024414, 69.90228271484375, 19008 ], [ -1088.964111328125, 1748.553833007813, 32.16135025024414, 66.6500244140625, 19599 ], [ -1097.473266601563, 1752.637573242188, 32.54501724243164, 63.03485107421875, 19869 ], [ -1104.526733398438, 1756.55078125, 33.07957077026367, 60.58380126953125, 20098 ], [ -1111.20263671875, 1760.481689453125, 33.70774078369141, 59.54116821289063, 20318 ], [ -1137.177734375, 1775.804321289063, 37.64555740356445, 59.4051513671875, 21328 ], [ -1157.318969726563, 1787.602783203125, 39.48288726806641, 58.85409545898438, 22419 ], [ -1161.880249023438, 1790.397583007813, 39.76374435424805, 58.04330444335938, 22998 ], [ -1168.527954101563, 1795.216674804688, 39.73713302612305, 51.62118530273438, 23668 ], [ -1173.45458984375, 1801.013427734375, 39.86912155151367, 35.18539428710938, 24158 ], [ -1176.539184570313, 1808.35400390625, 40.42601776123047, 16.12677001953125, 24618 ], [ -1177.422119140625, 1813.42236328125, 40.66091918945313, 9.2940673828125, 24908 ], [ -1177.903686523438, 1818.196411132813, 40.86849212646484, 6.352996826171875, 25168 ], [ -1183.175048828125, 1832.953247070313, 41.28326416015625, 41.78341674804688, 26279 ], [ -1192.722534179688, 1835.13525390625, 41.39749908447266, 95.81304931640625, 27079 ], [ -1197.140258789063, 1832.212524414063, 41.41450500488281, 132.6832885742188, 27579 ], [ -1198.770751953125, 1829.544555664063, 41.4027214050293, 146.880859375, 27878 ], [ -1198.45166015625, 1823.58056640625, 41.40799713134766, 197.0721893310547, 28698 ], [ -1198.13232421875, 1823.118774414063, 41.41462326049805, 202.3166656494141, 28779 ], [ -1196.57421875, 1821.475341796875, 41.40635681152344, 220.3708801269531, 29229 ], [ -1196.4541015625, 1821.397216796875, 41.40636444091797, 221.7097320556641, 29259 ], [ -1196.094970703125, 1821.056884765625, 41.40655899047852, 223.3982086181641, 29899 ], [ -1196.120727539063, 1821.076293945313, 41.4063720703125, 223.1853790283203, 29909 ] ] ]'), 516 )
	if not recording then
        addEventHandler( "onClientRender", root, readKeyPushed )
        recording = true
        startTick = getTickCount(  )
        local _elemToGetPosOf = localPlayer
        if isPedInVehicle( localPlayer ) then
        	_elemToGetPosOf = getPedOccupiedVehicle( localPlayer )
        end
        local x,y,z = getElementPosition( _elemToGetPosOf )
        local rx, ry, rz = getElementRotation( _elemToGetPosOf ) 
        positionTable = {x,y,z,rx,ry,rz}
    else
    	removeEventHandler( "onClientRender", root, readKeyPushed )
    	recording = false
    	setClipboard( "fromJSON('"..toJSON(positionTable).."'),fromJSON('"..toJSON(r_table).."'),fromJSON('"..toJSON(r2_table).."')" )
    	pushedControls = {}
    	r_table = {}
    end
end


function toggleControlForTime( ped, control, time )
	if isElement( ped ) then
	    setPedControlState( ped, control, true )
	    customTimer( time, setPedControlState, ped, control, false )
	end
end

function playRecord( pos, record, positions, vehicle )
	local ped = createPed( 0, 0, 0,0  )
	if vehicle then
		theV = createVehicle( vehicle, unpack( pos ) )
		warpPedIntoVehicle( ped, theV )
	end
	for _, v in pairs( record ) do
		customTimer( v[3], toggleControlForTime, ped, v[1], v[2] )
	end
	for _, v in pairs( positions ) do
		customTimer( v[5], isPedInPosition,  ped, {v[1],v[2],v[3],v[4]} )
	end
	setElementStreamable( ped, false ) setElementStreamable( theV, false )
	return ped, theV
end

addCommandHandler("r",record )


 