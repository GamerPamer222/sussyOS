local init
do
  local component_invoke = component.invoke
  local function boot_invoke(address, method, ...)
    local result = table.pack(pcall(component_invoke, address, method, ...))
    if not result[1] then
      return nil, result[2]
    else
      return table.unpack(result, 2, result.n)
    end
  end

  -- backwards compatibility, may remove later
  local comp = component
  local paired = ""
  local status = ""
  local network,screen,gpu = component.proxy(component.list("internet")() or error("failure (component not found : INTERNET CARD)")),component.list("screen")(),component.list("gpu")()
  local resX, resY = boot_invoke(gpu,"getResolution")
  boot_invoke(gpu, "setForeground", 0x727272)
  boot_invoke(gpu, "setBackground", 0xF3F3F3)
  function loadbar(val)
    local width = 20
    component.invoke(gpu,"fill",x/2-(width/2),y/2,math.ceil(width * val/100),1,"─")
  end
  component.proxy(component.list("eeprom")() or error("get an bios/uefi man"))
  computer.getBootAddress = function()
      return boot_invoke(eeprom, "getData")
  end
  computer.setBootAddress = function(address)
      return boot_invoke(eeprom, "setData", address)
  end

  function gpuFill(x,y,w,h,t)
    boot_invoke(gpu, "fill", x,y,w,h,t)	
  end

  function gpuSet(x,y,t)
    boot_invoke(gpu,"set",x,y,t)	
  end
  local a = 0
  while true do
    loadbar(a)
    a = a + 25
    if a == 100 then
      break
    end
  end
  do
    local screen = component.list("screen")()
    local gpu = component.list("gpu")()
    if gpu and screen then
      boot_invoke(gpu, "bind", screen)
    end
  end
  local function tryLoadFrom(address)
    local handle, reason = boot_invoke(address, "open", "/init.lua")
    if not handle then
      return nil, reason
    end
    local buffer = ""
    repeat
      local data, reason = boot_invoke(address, "read", handle, math.huge)
      if not data and reason then
        return nil, reason
      end
      buffer = buffer .. (data or "")
    until not data
    boot_invoke(address, "close", handle)
    return load(buffer, "=init")
  end
  local reason
  if computer.getBootAddress() then
    init, reason = tryLoadFrom(computer.getBootAddress())
  end
  if not init then
    computer.setBootAddress()
    for address in component.list("filesystem") do
      init, reason = tryLoadFrom(address)
      if init then
        computer.setBootAddress(address)
        break
      end
    end
  end
  if not init then
    error("no bootable medium found" .. (reason and (": " .. tostring(reason)) or ""), 0)
  end
  computer.beep(200, 0.2)
end
return init()
