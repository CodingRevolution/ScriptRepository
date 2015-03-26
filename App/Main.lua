--[[
	Script Repository
	Project
	by Creator
]]--


--Variables--
local Lists = {
	Layouts = {
		Main = "Main.lua",
	},
}
local Buffers = {
	Layouts = {},
}

--Functions--
local function parse(sText,sPattern)
	local tBuffer = {}
	if not type(sText) == "string" then
		error("Expected string, got "..type(sText),2)
	end
	for token in sText:gmatch(sPattern) do
		tBuffer[#tBuffer+1] = token
	end
	return tBuffer
end

local function clear()
	term.setBackgroundColor(colors.white)	
	term.setTextColor(colors.black)
	term.setCursorPos(1,1)
	term.clear()
end

local web = {
	loadAPI = function(sWebAddress,sAPIname)
		local env = setmetatable({}, { __index = _G })
		local func, err = loadstring(http.get(sWebAddress).readAll())
		if not func or err then
		  return false, err
		end
		setfenv(func, env)
		func()
		local api = {}
		for k,v in pairs(env) do
		  api[k] =  v
		end
		_G[sAPIname] = api
		return true
	end,
	loadFile = function(sWebAddress)
		return http.get(sWebAddress).readAll()
		print("hi")
	end,
}

local function loadLayouts()
	for i,v in pairs(Lists.Layouts) do
		print(i)
		Buffers.Layouts[i] = web.loadFile("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/Layouts/"..v)
	end
end

--Code--
print("Working")
if not Interact then web.loadAPI("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/API/Interact","Interact") end
loadLayouts()

print(textutils.serialize(Buffers.Layouts))