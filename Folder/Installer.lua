local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")
local network = component.proxy(component.list("internet")())
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
    local width = 36
    component.invoke(gpu,"fill",width/2,y/2,math.ceil(width * val/100),1,"-")
end
status("Downloading Stuff")
component.invoke(gpu,"set",(x/2)-(string.len("sussyOS Installer")/2),(y/2)-2,"sussyOS Installer")
loadbar(10)
local a = 10
wait(3)
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
       return result, reason
    end
end
function getResult(v1,v2)
    return v1
end
local gui = load(getResult(require("GUI")), "=gui")
gui:set(component)
gui.Text("this is a sussy text, dont ask.", 1, 1)

while true do
    a = a + 1
    loadbar(a)
    if a == 100 then break end
    wait(0.2)
end
