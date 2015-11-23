--local sha2 = require("sha2")
local url = require("socket.url")
azuresas = {}
local _M = azuresas

--local function epoch()
--  return diff = (os.time() / 1000.0) + 3600.0
--end

function _M.getServiceBusSasToken(uri, keyName, key)
  local expiry = (os.time() / 1000.0) + 3600.0
  local stringToSign = url.escape(uri) .. "\\n" .. expiry
--  local hash = sha2.hash256(key)
--  local hash = sha2.hash256("Hello World")
  return hash
end

return _M