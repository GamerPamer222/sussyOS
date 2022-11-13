local gui = function()
  sus = {}
  sus.component = {}

  function gui:set(comp)
    sus.component = comp  
  end

  function gui:Text(...)
    local args = {...}
    sus.component.invoke(gui.component.list("gpu")(), "set", args[2], args[3], args[1])
  end
  return sus
end
  
return gui
