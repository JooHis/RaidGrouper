local AceGUI = LibStub("AceGUI-3.0")


players = {[1] = {},
		   [2] = {},
		   [3] = {},
		   [4] = {},
		   [5] = {},
		   [6] = {},
		   [7] = {},
		   [8] = {}}


				 
SLASH_RaidGrouper1= '/rg'
function SlashCmdList.RaidGrouper(msg)
	ShowFrame()
end

function CreateBox(v, k)
	local editbox = AceGUI:Create("EditBox")
	if k == 1 then
		group = "Group " .. v .. ":"
		editbox:SetLabel(group)
	end
	editbox:SetText(players[v][k])
	editbox:SetWidth(200)
	editbox:DisableButton(false)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) text = CheckInput(text)
																	   players[v][k] = text
																	   editbox:SetText(text) end)
	scroll:AddChild(editbox)
end


function ShowFrame()
	
	-- UI STARTS HERE --
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("RaidGrouper")
	frame:SetStatusText("RaidGrouper v0.1 By Läppädin")
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	frame:SetLayout("Fill")
	-- frame:RegisterEvent("ADDON_LOADED")
	-- frame:RegisterEvent("PLAYER_LOGOUT")

	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill")
	frame:AddChild(scrollcontainer)

	scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("List")
	scrollcontainer:AddChild(scroll)

	local button = AceGUI:Create("Button")
	button:SetText("Fix Groups!")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() FixGroup() end)
	scroll:AddChild(button)
	
	-- Create EditBoxes --
	for i = 1, 8 do
		for j = 1, 5 do
			CreateBox(i, j)
		end
	end
end
	-- UI ENDS HERE --

function FixGroup()
	if IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
		for i = 1, 8 do
			for j = 1, 5 do
				playerId = UnitInRaid(players[i][j])
				playerName = players[i][j]
				if playerId == nil and playerName ~= nil then
					print(playerName, "is not in the raid! - RG")
				elseif playerName == nil then
				else 
					local _, _, subgroup = GetRaidRosterInfo(playerId)
					if subgroup ~= i then
						SetRaidSubgroup(playerId, i)
					end
				end
			end
		end
	else
		print("You are not in a raid and/or not the raid leader! - RG")
	end
end

function CheckInput(str)
	str = str:gsub("%s+", "")
	if string.len(str) > 0 then
		return str
	else
		return nil
	end
end

