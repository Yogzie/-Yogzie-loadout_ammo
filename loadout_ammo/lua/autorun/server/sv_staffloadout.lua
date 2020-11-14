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
YOGSTAFFLOADOUT = { "weapon_physgun", "gmod_tool", "weaponchecker", "keys"  }
-- [[ Add the ulx ranks here ]]
YOGSTAFFRANKS = { "superadmin", "admin", "mod", "tmod" }



YOGINFAMMO = {"tfa_ammo_sniper_rounds", "tfa_ammo_ar2", "tfa_ammo_pistol", "buckshot" } -- place common ammotypes here
YOGRAREAMMO = {"ammo_rpgclip"} -- place rare ammotypes here(explosives etc)



-- Gives the hook the size of the loadout (int)
local loadoutSize = function(tab)
	return table.Count(tab)
end


-- Rank check for the command
local YOGrankCheck = function(ply)
	for Repetitions in pairs(YOGSTAFFRANKS) do
		-- print(loadoutSize(YOGSTAFFRANKS) .. " " .. YOGSTAFFRANKS[Repetitions])	-- Debug
		if ply:GetUserGroup() == YOGSTAFFRANKS[Repetitions] then 
			return true
		end
	-- print(prefix .. YOGSTAFFRANKS[v])	-- For debugging purposes
	end
end



-- Command for accquiring loadout
hook.Add("PlayerSay", "giveLoadout", function(sender, text, teamChat)
	if text == "!staff" then
		if YOGrankCheck(sender) == true then
				while LDTloop != loadoutSize(YOGSTAFFLOADOUT) do
					-- print(YOGSTAFFLOADOUT[LDTloop]) -- Debug
					LDTloop = LDTloop + 1
					sender:Give(YOGSTAFFLOADOUT[LDTloop])
					-- sender:ChatPrint(prefix .. YOGSTAFFLOADOUT[LDTloop] .. " Recieved")	-- Debug if needed						
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

YOGremoveItem = function()

end

net.Receive("YOG_reqalltabs", function(len, ply)
	sendAll(ply)
end)

sendAll = function(ply)
	net.Start("YOG_sendalltabs")
	net.WriteTable(YOGSTAFFLOADOUT)

	net.WriteTable(YOGSTAFFRANKS)

	net.WriteTable(YOGINFAMMO)

	net.WriteTable(YOGRAREAMMO)

	net.Send(ply)
end


YOGeditorCheck = function(ply)
	for k in pairs(YOGEDITOR) do
		if ply:GetUserGroup() == YOGEDITOR[k] then
			return true
		end
	end
end


hook.Add("PlayerSay", "YOGGUILoad", function(sender, text, teamChat)
	if string.lower(text) == "!ld" then	
		if YOGeditorCheck(sender) then
			net.Start("YOG_opengui")
			net.Send(sender)
		end
	end
end)




net.Receive("YOGRemove_Item", function(len, ply)
	local yogTable = net.ReadInt(8)
	local tableKey = net.ReadInt(8)
	if yogTable == 1 then
		table.remove(YOGSTAFFLOADOUT, tableKey)
	elseif yogTable == 2 then
		table.remove(YOGSTAFFLOADOUT, tableKey)			
	elseif yogTable == 3 then
		table.remove(YOGSTAFFLOADOUT, tableKey)
	elseif yogTable == 4 then
		table.remove(YOGSTAFFLOADOUT, tableKey)
	end
end)

--[[local YOGREMOVEitem = function(key, tab)
	net.Start("YOGRemove_Item")
	net.WriteInt(tab, 8) -- Table 1-4 digit (Keyed at the top of the file)
	net.WriteInt(key, 8) -- Table Key Value for Removal
	net.SendToServer()
end]]
