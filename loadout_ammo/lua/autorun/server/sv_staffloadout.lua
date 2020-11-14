include("autorun/sh_loadoutammo.lua")
util.AddNetworkString("YOG_opengui")
util.AddNetworkString("YOG_reqalltabs")
util.AddNetworkString("YOG_sendalltabs")
util.AddNetworkString("YOGrequestSTAFFLOADOUT")
util.AddNetworkString("YOGrequestSTAFFRANKS")
util.AddNetworkString("YOGrequestINFAMMO")
util.AddNetworkString("YOGrequestRAREAMMO")




local prefix = "[StaffLoadout]"
local LDTloop = 0
local Repetitions = 0
print(prefix .. " Loading")


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

--[[net.Receive("YOGrequestSTAFFLOADOUT", function(len, ply)
	YOGsendSTAFFLOADOUT(ply)
end)

net.Receive("YOGrequestSTAFFRANKS", function(len, ply)
	YOGsendSTAFFRANKS(ply)
end)

net.Receive("YOGrequestINFAMMO", function(len, ply)
	YOGsendINFAMMO(ply)
end)

net.Receive("YOGrequestRAREAMMO", function(len, ply)
	YOGsendRAREAMMO(ply)
end)

YOGsendSTAFFLOADOUT = function(ply)
	net.Start("YOG_SENDSTAFFLOADOUT")
	net.WriteTable(YOGSTAFFLOADOUT)
	net.Send(ply)
end

YOGsendSTAFFRANKS = function(ply)
	net.Start("YOG_SENDSTAFFRANKS")
	net.WriteTable(YOGSTAFFRANKS)
	net.Send(ply)
end

YOGsendINFAMMO = function(ply)
	net.Start("YOG_SENDINFAMMO")
	net.WriteTable(YOGINFAMMO)
	net.Send(ply)
end

YOGsendRAREAMMO = function(ply)
	net.Start("YOG_SENDRAREAMMO")
	net.WriteTable(YOGRAREAMMO)
	net.Send(ply)
end]]












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