include("autorun/sh_loadoutammo.lua")

util.AddNetworkString("YOG_opengui")
util.AddNetworkString("YOG_reqalltabs")
util.AddNetworkString("YOG_sendalltabs")
util.AddNetworkString("YOGrequestSTAFFLOADOUT")
util.AddNetworkString("YOGrequestSTAFFRANKS")
util.AddNetworkString("YOGrequestINFAMMO")
util.AddNetworkString("YOGrequestRAREAMMO")
util.AddNetworkString("YOGRemove_Item")
util.AddNetworkString("YOGAdd_Item")


local prefix = "[StaffLoadout]"
local LDTloop = 0
local Repetitions = 0
print(prefix .. " Loading")
--print("[TableEditor] For Help With Using The Active Table Editor Type !yoghelp")


-- [[ The usergroups that can load the loadout / ammotype editor]] 
YOGEDITOR = { "superadmin", "admin" } -- defaulted to superadmin and admin




-- [[ Adjust the staff loadout as you see fit. It will not override default loadout set by DarkRP]]

--YOGSTAFFLOADOUT = { "weapon_physgun", "gmod_tool", "weaponchecker", "keys"  } -- DEFAULT VALUES
YOGSTAFFLOADOUTread = util.JSONToTable(file.Read("tableditor/loadoutTable.txt", "DATA"))

--YOGSTAFFRANKS = { "superadmin", "admin", "mod", "tmod" } -- DEFAULT VALUES
YOGSTAFFRANKSread = util.JSONToTable(file.Read("tableditor/rankTable.txt", "DATA"))

--YOGINFAMMO = {"tfa_ammo_sniper_rounds", "tfa_ammo_ar2", "tfa_ammo_pistol", "buckshot"}  -- DEFAULT VALUES
YOGINFAMMOread = util.JSONToTable(file.Read("tableditor/commonammoTable.txt", "DATA")) -- place common ammotypes here

--YOGRAREAMMO = { "ammo_rpgclip" } -- place rare ammotypes here(explosives etc) -- DEFAULT VALUES
YOGRAREAMMOread = util.JSONToTable(file.Read("tableditor/rareammoTable.txt", "DATA")) -- place rare ammotypes here(explosives etc)





-- Gives the hook the size of the loadout (int)
local loadoutSize = function(tab)
	return table.Count(tab)
end


-- Rank check for the command
local YOGrankCheck = function(ply)
	for Repetitions in pairs(YOGSTAFFRANKSread) do
		-- print(loadoutSize(YOGSTAFFRANKSread) .. " " .. YOGSTAFFRANKSread[Repetitions])	-- Debug
		if ply:GetUserGroup() == YOGSTAFFRANKSread[Repetitions] then 
			return true
		end
	-- print(prefix .. YOGSTAFFRANKSread[v])	-- For debugging purposes
	end
end



-- Command for accquiring loadout
hook.Add("PlayerSay", "giveLoadout", function(sender, text, teamChat)
	if text == "!staff" then
		if YOGrankCheck(sender) == true then
				while LDTloop != loadoutSize(YOGSTAFFLOADOUTread) do
					-- print(YOGSTAFFLOADOUTread[LDTloop]) -- Debug
					LDTloop = LDTloop + 1
					sender:Give(YOGSTAFFLOADOUTread[LDTloop])
					-- sender:ChatPrint(prefix .. YOGSTAFFLOADOUTread[LDTloop] .. " Recieved")	-- Debug if needed						
				end
			sender:ChatPrint(prefix .. " Staff Loadout Recieved!")
			LDTloop = 0
		else
			sender:ChatPrint(prefix .. " You are not staff!")
		end
	end
end)

-- Table Editor Net Code From This Point Onward!

net.Receive("YOGrequestTables", function(len, ply)
	YOGgetTables(ply)
end)

YOGappendTable = function()
	
end

net.Receive("YOG_reqalltabs", function(len, ply)
	sendAll(ply)
end)

sendAll = function(ply)
	net.Start("YOG_sendalltabs")

	net.WriteTable(YOGSTAFFLOADOUTread)

	net.WriteTable(YOGSTAFFRANKSread)

	net.WriteTable(YOGINFAMMOread)

	net.WriteTable(YOGRAREAMMOread)

	net.Send(ply)
end

YOGeditorCheck = function(ply)
	for k in pairs(YOGEDITOR) do
		if ply:GetUserGroup() == YOGEDITOR[k] then
			return true
		else 
			return false
		end
	end
end

hook.Add("PlayerSay", "YOGGUILoad", function(sender, text, teamChat)
	if string.lower(text) == "!ld" then	
		if YOGeditorCheck(sender) then
			net.Start("YOG_opengui")
			net.Send(sender)
		else 
			sender:ChatPrint("[TableEditor] You Are Not An Editor Rank!")
		end
	end
end)

yogldtr = function(key)
	table.remove(YOGSTAFFLOADOUTread, key)
	file.Write("tableditor/loadoutTable.txt", util.TableToJSON(YOGSTAFFLOADOUTread))
end

yogrnkr = function(key)
	table.remove(YOGSTAFFRANKSread, key)
	file.Write("tableditor/rankTable.txt", util.TableToJSON(YOGSTAFFRANKSread))	
end

yoginfr = function(key)
	table.remove(YOGINFAMMOread, key)
	file.Write("tableditor/commonammoTable.txt", util.TableToJSON(YOGINFAMMOread))	
end

yograrer = function(key)
	table.remove(YOGRAREAMMOread, key)
	file.Write("tableditor/rareammoTable.txt", util.TableToJSON(YOGRAREAMMOread))
end

net.Receive("YOGRemove_Item", function(len, ply)
	local allowRemove = false
	for k, v in pairs(YOGEDITOR) do	
		if ply:GetUserGroup() == YOGEDITOR[k] then
			allowRemove = true
			local denyRemoveAccess = true
		elseif denyRemoveAccess == true then
			allowRemove = false
			print("[TableEditor] A Non Editor Tried To Remove A Value From A Table! Name :" .. ply:Nick())
		end
	end

	if allowRemove then
		print("RemoveReceived")
		local yogTable = net.ReadInt(8)
		local tableKey = net.ReadInt(8)
		local yogTabName = tostring(yogTable)		
		if not file.Exists("tableditor", "data") then 
			file.CreateDir("tableditor")
		else
			if yogTable == 1 then
				yogldtr(tableKey)
			elseif yogTable == 2 then
				yogrnkr(tableKey)
			elseif yogTable == 3 then	
				yoginfr(tableKey)	
			elseif yogTable == 4 then
				yograrer(tableKey)
			else
				print("yogTable is not a good value")
			end
			print("Checked")
		end
	end

end)


net.Receive("YOGAdd_Item", function(len, ply)
	local allowAdd = false
	for k, v in pairs(YOGEDITOR) do	
		if ply:GetUserGroup() == YOGEDITOR[k] then
			allowAdd = true
			local denyAddAccess = true
		elseif denyAddAccess == true then
			allowAdd = false
			print("[TableEditor] A Non Editor Tried To Add A Value To A Table! Name :" .. ply:Nick())
		end
	end
	if allowAdd == true then
		local yogTable = net.ReadInt(8)
		local AddedValue = net.ReadString()
		if yogTable == 1 then
			table.insert(YOGSTAFFLOADOUTread, table.Count(YOGSTAFFLOADOUTread) + 1, AddedValue )
			file.Write("tableditor/loadoutTable.txt", util.TableToJSON(YOGSTAFFLOADOUTread))
		elseif yogTable == 2 then
			table.insert(YOGSTAFFRANKSread, table.Count(YOGSTAFFRANKSread) + 1, AddedValue )
			file.Write("tableditor/rankTable.txt", util.TableToJSON(YOGSTAFFRANKSread))
		elseif yogTable == 3 then
			table.insert(YOGINFAMMOread, table.Count(YOGINFAMMOread) + 1, AddedValue )
			file.Write("tableditor/commonammoTable.txt", util.TableToJSON(YOGINFAMMOread))
		elseif yogTable == 4 then
			table.insert(YOGRAREAMMOread, table.Count(YOGRAREAMMOread) + 1, AddedValue )
			file.Write("tableditor/rareammoTable.txt", util.TableToJSON(YOGRAREAMMOread))
		end

	end

end)

--[[local YOGREMOVEitem = function(key, tab)
	net.Start("YOGRemove_Item")
	net.WriteInt(tab, 8) -- Table 1-4 digit (Keyed at the top of the file)
	net.WriteInt(key, 8) -- Table Key Value for Removal
	net.SendToServer()
end]]
