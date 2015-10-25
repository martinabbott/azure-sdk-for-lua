-- Service Bus Sample
-- Martin Abbott
-- 25/10/2015

local http = require("socket.http")
local config = require("azure.configuration")

local url = config.getServiceBusUrl()

print(url)
