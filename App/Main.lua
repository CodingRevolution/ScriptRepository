--[[
	Script Repository
	Project
	by Creator
]]--
--Initialize Stuff--

--Variables--

--Strings
local gui = {}
local w,h = term.getSize()
local MainLayout = {}

--Tables
local Lists = {
	Layouts = {
		Main = "Main.layout",
	},
}
local Buffers = {
	Layouts = {
		Main = {},
	},
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
		if not type(sWebAddress) == "string" then error("Expected string, got "..type(sWebAddress),2) end
		if not type(sAPIname) == "string" then error("Expected string, got "..type(sAPIname),2) end
		local env = setmetatable({}, { __index = _G })
		local func, err = loadstring(http.get(sWebAddress).readAll(),sAPIname)
		if (not func) or err then
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
		else
			print(err)
		end
	end
	return nil
end

local function loadLayouts()
	for i,v in pairs(Lists.Layouts) do
		Buffers.Layouts[i] = unserialize(web.loadFile("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/Layouts/"..v))
	end
end

--Code--

--Initializing Stuff
print("Working")
if not Interact then web.loadAPI("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/API/Interact","Interact") end
gui = Interact:Initialize()
loadLayouts()
--print(textutils.serialize(Buffers.Layouts))
--print(web.loadFile("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/Layouts/Main.layout"))

--Layouts--
MainLayout = gui.Layout.new({xPos = 1,yPos = 1,xLength = w, yLength = h})
gui.loadLayout(Buffers.Layouts.Main,MainLayout)
MainLayout:draw()
