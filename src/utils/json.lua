json = {}
local _M = json
------------------------------------------------------------------ utils
local controls = {["\n"]="\\n", ["\r"]="\\r", ["\t"]="\\t", ["\b"]="\\b", ["\f"]="\\f", ["\""]="\\\"", ["\\"]="\\\\"}

local function isArray(t)
	local max = 0
	for k,v in pairs(t) do
		if type(k) ~= "number" then
			return false
		elseif k > max then
			max = k
		end
	end
	return max == #t
end

local whites = {['\n']=true; ['r']=true; ['\t']=true; [' ']=true; [',']=true; [':']=true}
function _M.removeWhite(str)
	while whites[str:sub(1, 1)] do
		str = str:sub(2)
	end
	return str
end

------------------------------------------------------------------ encoding

local function encodeCommon(val, pretty, tabLevel, tTracking)
	local str = ""

	-- Tabbing util
	local function tab(s)
		str = str .. ("\t"):rep(tabLevel) .. s
	end

	local function arrEncoding(val, bracket, closeBracket, iterator, loopFunc)
		str = str .. bracket
		if pretty then
			str = str .. "\n"
			tabLevel = tabLevel + 1
		end
		for k,v in iterator(val) do
			tab("")
			loopFunc(k,v)
			str = str .. ","
			if pretty then str = str .. "\n" end
		end
		if pretty then
			tabLevel = tabLevel - 1
		end
		if str:sub(-2) == ",\n" then
			str = str:sub(1, -3) .. "\n"
		elseif str:sub(-1) == "," then
			str = str:sub(1, -2)
		end
		tab(closeBracket)
	end

	-- Table encoding
	if type(val) == "table" then
		assert(not tTracking[val], "Cannot encode a table holding itself recursively")
		tTracking[val] = true
		if isArray(val) then
			arrEncoding(val, "[", "]", ipairs, function(k,v)
				str = str .. encodeCommon(v, pretty, tabLevel, tTracking)
			end)
		else
			arrEncoding(val, "{", "}", pairs, function(k,v)
				assert(type(k) == "string", "JSON object keys must be strings", 2)
				str = str .. encodeCommon(k, pretty, tabLevel, tTracking)
				str = str .. (pretty and ": " or ":") .. encodeCommon(v, pretty, tabLevel, tTracking)
			end)
		end
	-- String encoding
	elseif type(val) == "string" then
		str = '"' .. val:gsub("[%c\"\\]", controls) .. '"'
	-- Number encoding
	elseif type(val) == "number" or type(val) == "boolean" then
		str = tostring(val)
	else
		error("JSON only supports arrays, objects, numbers, booleans, and strings", 2)
	end
	return str
end

function _M.encode(val)
	return encodeCommon(val, false, 0, {})
end

function _M.encodePretty(val)
	return encodeCommon(val, true, 0, {})
end

------------------------------------------------------------------ decoding

function _M.parseBoolean(str)
	if str:sub(1, 4) == "true" then
		return true, _M.removeWhite(str:sub(5))
	else
		return false, _M.removeWhite(str:sub(6))
	end
end

function _M.parseNull(str)
	return nil, _M.removeWhite(str:sub(5))
end

local numChars = {['e']=true; ['E']=true; ['+']=true; ['-']=true; ['.']=true}
function _M.parseNumber(str)
	local i = 1
	while numChars[str:sub(i, i)] or tonumber(str:sub(i, i)) do
		i = i + 1
	end
	local val = tonumber(str:sub(1, i - 1))
	str = _M.removeWhite(str:sub(i))
	return val, str
end

function _M.parseString(str)
	local i,j = str:find('[^\\]"')
	local s = str:sub(2, j - 1)

	for k,v in pairs(controls) do
		s = s:gsub(v, k)
	end
	str = _M.removeWhite(str:sub(j + 1))
	return s, str
end

function _M.parseArray(str)
	str = _M.removeWhite(str:sub(2))
	
	local val = {}
	local i = 1
	while str:sub(1, 1) ~= "]" do
		local v = nil
		v, str = _M.parseValue(str)
		val[i] = v
		i = i + 1
		str = _M.removeWhite(str)
	end
	str = _M.removeWhite(str:sub(2))
	return val, str
end

function _M.parseObject(str)
	str = _M.removeWhite(str:sub(2))
	
	local val = {}
	while str:sub(1, 1) ~= "}" do
		local k, v = nil, nil
		k, v, str = _M.parseMember(str)
		val[k] = v
		str = _M.removeWhite(str)
	end
	str = _M.removeWhite(str:sub(2))
	return val, str
end

function _M.parseMember(str)
	local k = nil
	k, str = _M.parseValue(str)
	local val = nil
	val, str = _M.parseValue(str)
	return k, val, str
end

function _M.parseValue(str)
	local fchar = str:sub(1, 1)
	if fchar == "{" then
		return _M.parseObject(str)
	elseif fchar == "[" then
		return _M.parseArray(str)
	elseif tonumber(fchar) ~= nil or numChars[fchar] then
		return _M.parseNumber(str)
	elseif str:sub(1, 4) == "true" or str:sub(1, 5) == "false" then
		return _M.parseBoolean(str)
	elseif fchar == "\"" then
		return _M.parseString(str)
	elseif str:sub(1, 4) == "null" then
		return _M.parseNull(str)
	end
	return nil
end

function _M.decode(str)
	str = _M.removeWhite(str)
	t = _M.parseValue(str)
	return t
end

function _M.decodeFromFile(path)
	local file = assert(fs.open(path, "r"))
	return _M.decode(file.readAll())
end

return _M