--bios launcher

local comp = component
local paired = ""
local network,screen,gpu = component.proxy(component.list("internet")() or error("failure (component not found : INTERNET CARD)")),component.list("screen")(),component.list("gpu")()

if screen and gpu then
      paired = "yes"
end

function getChunkfromtxt(data)
   local result, reason = ""
   local handle, chunk = network.request((data or "https://raw.githubusercontent.com/GamerPamer222/sussyOS/main/Folder/Installer.lua"))
   while true do
		chunk = handle.read(math.huge)
		
		if chunk then
			result = result .. chunk
		else
			break
		end
	end

   handle.close()
   return result, reason
end


result, reason = getChunkfromtxt("https://raw.githubusercontent.com/GamerPamer222/sussyOS/main/Folder/Installer.lua")
result, reason = load(result, "=install")

if result then
	result, reason = xpcall(result, debug.traceback)

	if not result then
		error(reason)
	end
else
	error(reason)	
end
