--bios launcher

local component_invoke = component.invoke
local function boot_invoke(address, method, ...)
    local result = table.pack(pcall(component_invoke, address, method, ...))
    if not result[1] then
      return nil, result[2]
    else
      return table.unpack(result, 2, result.n)
    end
end

local comp = component
local paired = ""
local status = ""
local network,screen,gpu = component.proxy(component.list("internet")() or error("failure (component not found : INTERNET CARD)")),component.list("screen")(),component.list("gpu")()
local resX, resY = boot_invoke(gpu,"getResolution")
boot_invoke(gpu, "setForeground", 0xDCDCDC)
boot_invoke(gpu, "setBackground", 0xF3F3F3)
component.proxy(component.list("eeprom")() or error("get an bios/uefi man"))
computer.getBootAddress = function()
    return boot_invoke(eeprom, "getData")
end
computer.setBootAddress = function(address)
    return boot_invoke(eeprom, "setData", address)
end

function gpuFill(x,y,w,h,t)
	boot_invoke(gpu, "fill", x,y,w,h,t)	
end

function gpuSet(x,y,t)
	boot_invoke(gpu,"set",x,y,t)	
end

function setStatus(stat)
	status = stat
	gpuFill(resX/2,(resY/2)+7,resX,1," ")
	gpuSet(resX/2-(string.len(stat)/2),(resY/2)+7,stat)
end

if screen and gpu then
      paired = "yes"
      --bind the gpu idk
      boot_invoke(component.proxy(component.list("gpu")()), "bind", component.list("screen")())
end

setStatus("Downloading File")

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

setStatus("Installing : running")

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
