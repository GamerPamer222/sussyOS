local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")
while true do
component.invoke(gpu, "fill", 1,1,x,y,"AA")
end
