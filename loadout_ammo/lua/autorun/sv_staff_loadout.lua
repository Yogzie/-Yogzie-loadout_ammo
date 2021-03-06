
-- [[ Adjust the staff loadout as you see fit. It will not override default loadout set by DarkRP]]
local STAFFLOADOUT = { "weapon_physgun", "gmod_tool", "weaponchecker", "keys"  }
-- [[ Add the ulx ranks here ]]
local STAFFRANKS = { "superadmin", "admin", "mod", "tmod" } 
local prefix = "[StaffLoadout]"
local LDTloop = 0
local Repetitions = 0
print(prefix .. " Loading")

-- Gives the hook the size of the loadout (int)
local loadoutSize = function(tab)
	return table.Count(tab)
end


-- Rank check for the command
local rankCheck = function(ply)
	for Repetitions in pairs(STAFFRANKS) do
		-- print(loadoutSize(STAFFRANKS) .. " " .. STAFFRANKS[Repetitions])	-- Debug
		if ply:GetUserGroup() == STAFFRANKS[Repetitions] then 
			return true
		end
	-- print(prefix .. STAFFRANKS[v])	-- For debugging purposes
	end
end



-- Command for accquiring loadout
hook.Add("PlayerSay", "giveLoadout", function(sender, text, teamChat)
	if text == "!staff" then
		if rankCheck(sender) == true then
				while LDTloop != loadoutSize(STAFFLOADOUT) do
					-- print(STAFFLOADOUT[LDTloop]) -- Debug
					LDTloop = LDTloop + 1
					sender:Give(STAFFLOADOUT[LDTloop])
					-- sender:ChatPrint(prefix .. STAFFLOADOUT[LDTloop] .. " Recieved")	-- Debug if needed						
				end
			sender:ChatPrint(prefix .. " Staff Loadout Recieved!")
			LDTloop = 0
		else
			sender:ChatPrint(prefix .. " You are not staff!")
		end
	end
end)





