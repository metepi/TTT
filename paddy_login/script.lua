local spawnX, spawnY, spawnZ = 1,1,1
function joinHandler()
	spawnPlayer(source, spawnX, spawnY, spawnZ)
	fadeCamera(source, true)
	setCameraTarget(source, source)
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)