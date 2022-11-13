--credits to mineos / tho i made the bios lol
local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")
local network = component.list("internet")()
local installerPath = "/sussyOS/"
temporaryFilesystemProxy = component.proxy(component.list("filesystem")())
local repository = "https://raw.githubusercontent.com/GamerPamer222/sussyOS/main/"
component.invoke(gpu,"fill",1,1,x,y," ")
function status(text)
    component.invoke(gpu,"fill",1,(y/2)+7,x,1," ")
    component.invoke(gpu,"set",(x/2)-(string.len(text)/2),(y/2)+7,text)
end
function wait(seconds)
    local start = os.clock()
    repeat until os.clock() >= start + seconds
end
function loadbar(val)
    local width = 20
    component.invoke(gpu,"fill",x/2-(width/2),y/2,math.ceil(width * val/100),1,"─")
end
status("Downloading Stuff")
component.invoke(gpu,"set",(x/2)-(string.len("sussyOS Installer")/2),(y/2)-2,"sussyOS Installer")
loadbar(10)
local a = 10
wait(3)
local function rawRequest(url, chunkHandler)
	local internetHandle, reason = component.invoke(network, "request", url)

	if internetHandle then
		local chunk, reason
		while true do
			chunk, reason = internetHandle.read(math.huge)	
			
			if chunk then
				chunkHandler(chunk)
			else
				if reason then
					error("Internet request failed: " .. tostring(reason))
				end

				break
			end
		end

		internetHandle.close()
	else
		error("Connection failed: " .. url)
	end
end

local function request(url)
	local data = ""
	
	rawRequest(url, function(chunk)
		data = data .. chunk
	end)

	return data
end

function download(module)
    local bb = request(repository.."lib/"..module..".lua")
    return bb
end

function require(module)
        local yes
		local handle = download(module)
		if handle then
			local result, reason = load(handle, "=" .. module)
			if result then
				yes = result() or true
			end
		end

		return yes
end
function getResult(v1,v2)
    return v1
end
local gui = require('GUI')()
component.invoke(gpu,"set",1,1,tostring(gui))
gui:set(component)

while true do
    a = a + 1
    loadbar(a)
    status("Loading : "..a.."%")
    if a == 100 then break end
    wait(0.02)
end

status("Flashing EEPROM [Do not shutdown the system.]")

local eeprom = component.list("eeprom")()

component.invoke(eeprom, "set", request(repository.."EFI/bios.lua"))
