-- Azure Configuration
-- Martin Abbott
-- 25/10/2015

local serviceBusSas = "[Enter Service Bus Key]"
local serviceBusUrl = "[Enter Service Bus URL]"
local eventHubSas = "[Enter Event Hub Key]"
local eventHubUrl = "[Enter Event Hub URL]"
local storageTableSas = "[Enter Storage Table Key]"
local storageTableUrl = "[Enter Storage Table URL]"
local storageBlobSas = "[Enter Storage Blob Key]"
local storageBlobUrl = "[Enter Storage Blob URL]"
local storageQueueSas = "[Enter Storage Queue Key]"
local storageQueueUrl = "[Enter Storage Queue URL]"
local documentDbKey = "[Enter DocumentDB Key]"
local documentDbUrl = "[Enter DocumentDB URL]"

module("azure.configuration")

function getServiceBusSas()
	return serviceBusSas
end

function getServiceBusUrl()
	return serviceBusUrl
end

function getEventHubSas()
	return eventHubSas
end

function getEventHubUrl()
	return eventHubUrl
end

function getStorageTableSas()
	return storageTableSas
end

function getStorageTableUrl()
	return storageTableUrl
end

function getStorageBlobSas()
	return storageBlobSas
end

function getStorageBlobUrl()
	return storageBlobUrl
end

function getStorageQueueSas()
	return storageTableSas
end

function getStorageQueueUrl()
	return storageTableUrl
end

function getDocumentDbKey()
	return documentDbKey
end

function getDocumentDbUrl()
	return documentDbUrl
end
