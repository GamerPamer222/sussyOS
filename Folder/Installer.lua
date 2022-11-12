local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")

component.invoke(gpu, "fill", 1,1,x,y,"h")
