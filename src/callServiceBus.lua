-- Service Bus Sample
-- Martin Abbott
-- 25/10/2015

require("azure.configuration")
local http = require("lib.socket.http")

--print(http)

local headers = {
			["User-Agent"] = "A custom user-agent!",
			["Host"] = "Minecraft-Computer",
			["api-key"] = "E1C721069E67E24A94EA73EFB75FA7AD",
			["Content-Type"] = "application/json; charset=utf-8"
        }




local resp = http.get("http://www.example.com",headers)

--print(resp)
