--credits to mineos / tho i made the bios lol
local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")
local network = component.proxy(component.list("internet")())
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
    local width = 15
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
    local a,b = temporaryFilesystemProxy.open(installerPath.."libs/"..module..".lua", "wb")
    if a then
	local bb = request(repository.."lib/"..module..".lua")
        temporaryFilesystemProxy.write(a, bb)
        temporaryFilesystemProxy.close(a) return bb
    end
end

function require(module)
        local yes
		local handle, reason = temporaryFilesystemProxy.open(installerPath .. "libs/" .. module .. ".lua", "rb")
		if handle then
			local data, chunk = ""
			repeat
				chunk = temporaryFilesystemProxy.read(handle, math.huge)
				data = data .. (chunk or "")
			until not chunk

			temporaryFilesystemProxy.close(handle)
			
			local result, reason = load(data, "=" .. module)
			if result then
				yes = result() or true
			end
		end

		return yes
end
function getResult(v1,v2)
    return v1
end
component.invoke(gpu, "set", 1, 1, download("GUI"))
wait(5)
local gui = require('GUI')()
gui:set(component)
gui.Text("this is a sussy text, dont ask.", 1, 1)

while true do
    a = a + 1
    loadbar(a)
    if a == 100 then break end
    wait(0.2)
end
