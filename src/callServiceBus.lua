local http = require("socket.http")
local url = require("socket.url")
local json = require("utils.json")
local ltn12 = require("ltn12")
local sas = require("azure.sas")

local sasToken = sas.getServiceBusSasToken("http://example.com", "Root", "abc")
print(sasToken)

local enc = url.escape("sig=sdfdsff")-- .. hash)
print(enc)

local reqheaders = {
  ["Content-Type"] = "application/json",
  ["Authorization"] = ""
  }

local buildingTelemetry = {
  building = "Library"
  }		

	
local httpRequest = json.encode( buildingTelemetry )	
print(httpRequest)

local respbody = {}

local result, respcode, respheaders, respstatus = http.request {
    method = "GET",
    url = "http://example.com/",
    sink = ltn12.sink.table(respbody)
  }
 
respbody = table.concat(respbody) 
print(respbody)
