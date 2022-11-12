local gui = {}

gui.component = {}

function gui:set(comp)
  gui.component = comp  
end

function gui:Text(...)
  local args = {...}
  gui.component.invoke(gui.component.list("gpu")(), "set", args[2], args[3], args[1])
end

return gui
