_isDebug = true;

--加载badboy库
local bb = require("badboy");
--加载utils模块
bb.loadutilslib();
--加载JSON模块
bb_json = bb.getJSON();
--加载网络模块
bb.loadluasocket();



function getInternetTime ()
  local socket = bb.socket
  local server_ip = {
    "132.163.4.101",
    "132.163.4.102",
    "132.163.4.103",
    "128.138.140.44",
    "192.43.244.18",
    "131.107.1.10",
    "66.243.43.21",
    "216.200.93.8",
    "208.184.49.9",
    "207.126.98.204",
    "207.200.81.113",
    "205.188.185.33"
  }
  local function nstol(str)
    assert(str and #str == 4)
    local t = {str:byte(1,-1)}
    local n = 0
    for k = 1, #t do
      n= n*256 + t[k]
    end
    return n
  end
  local function gettime(ip)
    local tcp = socket.tcp()
    tcp:settimeout(10)
    tcp:connect(ip, 37)
    success, time = pcall(nstol, tcp:receive(4))
    tcp:close()
    return success and time or nil
  end
  local function nettime()
    for _, ip in pairs(server_ip) do
      time = gettime(ip)
      if time then 
        return time
      end
    end
  end
  dialog(nettime(),0)
end



printFunction = function (...)
  if not _isDebug then
    do return end
  end
  local params = {...}
  local str = nil
  for k,v in pairs(params) do
    if not str then
      str = tostring(v)
    else
      str = str .. ", " .. tostring(v)
    end
  end
  sysLog("[调试信息]>>>>"..str)
end


-- 格式化输出table（力荐）
function printTable (root, notPrint, params)
  
  if not _isDebug then
    do return end
  end
  local rootType = type(root)
  if rootType == "table" then
    local tag = params and params.tag or "Table detail:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    local cache = {  [root] = "." }
    local isHead = false
    local function _dump(t, space, name)
      local temp = {}
      if not isHead then
        temp = {tag}
        isHead = true
      end
      for k,v in pairs(t) do
        local key = tostring(k)
        if cache[v] then
          table.insert(temp, "+" .. key .. " {" .. cache[v] .. "}")
        elseif type(v) == "table" then
          local new_key = name .. "." .. key
          cache[v] = new_key
          table.insert(temp, "+" .. key .. _dump(v, space .. (next(t, k) and "|" or " " ) .. string.rep(" ", #key), new_key))
        else
          table.insert(temp, "+" .. key .. " [" .. tostring(v) .. "]")
        end
      end
      return table.concat(temp, "\n" .. space)
    end
    if not notPrint then
      sysLog(_dump(root, "", ""))
      sysLog("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    else
      return _dump(root, "", "")
    end
  else
    sysLog("[printr error]: not support type")
  end
end