local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")
local network = component.proxy(component.list("internet")())
local repository = "https://raw.githubusercontent.com/GamerPamer222/sussyOS/main/"
component.invoke(gpu,"fill",1,1,x,y," ")
function status(text)
    component.invoke(gpu,"fill",1,(y/2)+7,x,1," ")
    component.invoke(gpu,"set",(x/2)-(string.len(text)/2),(y/2)+7,text)
end
function loadbar(val)
    local width = 36
    component.invoke(gpu,"fill",width/2,y/2,math.ceil(width * val/100),1,"-")
end
status("Downloading Stuff")
component.invoke(gpu,"set",(x/2)-(string.len("sussyOS Installer")/2),(y/2)-2,"sussyOS Installer")
loadbar(10)
local a = 10
function require(wot)
    if network then
        status("Downloading : "..wot..".lua")
        loadbar(a+5)
        a = a + 5
        local result, reason = ""
        local handle, chunk = network.request(repository.."/lib/"..wot..".lua")
        while true do
            chunk = handle.read(math.huge)

            if chunk then
                result = result .. chunk
            else
                break
            end
        end

       handle.close()
       return load(result, "="..wot)
    end
end
local gui = require("GUI")
gui.Text("this is a sussy text, dont ask.", 1, 1)
