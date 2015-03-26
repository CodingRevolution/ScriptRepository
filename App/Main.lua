--[[
	Script Repository
	Project
	by Creator
]]--


--Variables--
local getList
local List
local position = 1
local event = {}
local Description = {}




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

local function nicePrint(tInput,sElement,nIndent,yPos)
	if tInput[sElement] == nil then error("Nil",2) end
	term.setCursorPos(nIndent,yPos)
	print(sElement..": "..tInput[sElement])
end

local function loadWebAPI(sWebAddress,sAPIname)
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
  end
--Code--
if not Interact then loadWebAPI("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/App/API/Interact","Interact") end

clear()
term.write("Please wait, fetching data...")
getList = http.get("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/List")
List = parse(getList.readAll(),"[^\n]+")

clear()
for i,v in pairs(List) do
	print("   "..v)
end
term.setCursorPos(1,position)
term.write(">>")

while true do
	event = {os.pullEvent("key")}
	clear()
	for i,v in pairs(List) do
		print("   "..v)
	end
	term.setCursorPos(1,position)
	term.write(">>")
	if event[2] == keys.up then
		position = position - 1
		if position == 0 then position = 1 end
	elseif event[2] == keys.down then
		position = position + 1
		if position > #List then position = #List end
	elseif event[2] == keys.enter then
		clear()
		term.write("Please wait, fetching data...")
		Description = textutils.unserialise(http.get("https://raw.githubusercontent.com/CodingRevolution/ScriptRepository/master/Descriptions/"..List[position]).readAll())
		clear()
		nicePrint(Description,"Name",2,2)
		nicePrint(Description,"Author",2,4)
		nicePrint(Description,"Version",2,6)
		nicePrint(Description,"Description",#"Description"+2,8)
	elseif event[2] == keys.tab then
		error()
	end
end
