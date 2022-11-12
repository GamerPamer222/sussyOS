--bios launcher

local comp = component
local paired = ""
local network,screen,gpu = component.proxy(component.list("internet")() or error("failure")),component.list("screen")(),component.list("gpu")()

if screen and gpu then
      paired = "yes"
end

function getChunkfromtxt(data)
   local handle, chunk = network.request()
end
