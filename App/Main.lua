--[[
	Script Repository
	Project
	by Creator
]]--


--Variables--

--Strings
local gui = Interact:Initialize()
local w,h = term.getSize()

--Tables
local Lists = {
	Layouts = {
		Main = "Main.layout",
	},
}
local Buffers = {
	Layouts = {},
}
local Layouts = {}

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
	end,
}

local function unserialize( s )
	local func, err = loadstring( "return "..s, "unserialize" )
	if func then
		local env = {}
		setmetatable(env,{__index = _G})
		setfenv( func, env )
		local ok, result = pcall( func )
		if ok then
			return result
		end
	end
	print(err)
	return nil
end

local function loadLayouts()
	for i,v in pairs(Lists.Layouts) do
		Buffers.Layouts[i] = unserialize(web.loadFile("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/Layouts/"..v))
	end
end

local function initializeLayouts()
	for i,v in pairs(Buffers.Layouts) do
		Layouts[i] = gui.loadObjects(v)
	end
end

--Code--
print("Working")
if not Interact then web.loadAPI("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/API/Interact","Interact") end
loadLayouts()
initializeLayouts()