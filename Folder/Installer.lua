local gpu = component.list("gpu")()
local x,y = component.invoke(gpu,"getResolution")
component.invoke(gpu,"fill",1,1,x,y," ")
function status(text)
    component.invoke(gpu,"fill",1,(y/2)+7,x,1," ")
    component.invoke(gpu,"set",(x/2)-(string.len(text)/2),(y/2)+7,text)
end

while true do
  status("this is a broken installer")  
end
