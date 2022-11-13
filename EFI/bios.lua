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
  
  function sleep(seconds)
    local start = os.clock()
    repeat until os.clock() >= start + seconds
  end

  -- backwards compatibility, may remove later
  local eeprom = component.list("eeprom")()
  computer.getBootAddress = function()
    return boot_invoke(eeprom, "getData")
  end
  computer.setBootAddress = function(address)
    return boot_invoke(eeprom, "setData", address)
  end
  function status()
    
  end
  do
    local screen = component.list("screen")()
    local gpu = component.list("gpu")()
    local st = component.proxy(component.list("computer")())
    local sk = component.proxy(component.list("keyboard")())
    if gpu and screen then
      boot_invoke(gpu, "bind", screen)
      x, y = boot_invoke(gpu,"getResolution")
      boot_invoke(gpu,"fill",1,1,x,y," ")
      function loadbar(value)
        local width = 12
        boot_invoke(gpu,"fill",x/2-(width/2),y/2+1,math.ceil(width*value/100),1,"─")
        boot_invoke(gpu,"set", x/2-(string.len("sussyEFI")/2), y/2-1, "sussyEFI")
        if sk then boot_invoke(gpu,"set", x/2-(string.len("Press Alt to shutdown")), y-2, tostring(computer.pullSignal)) end
      end
      local a = 0
      while true do
        if sk then
          if sk.isAltDown() then
            st.stop()  
          end
        end
        loadbar(a)
        a = a + 5
        if a == 100 then break end
        status(a)
        sleep(0.020)
      end
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
  computer.beep(1000, 0.2)
end
return init()
