
local prefix = "[EventAmmo]" -- Prefix for chatprint
local timeLeft = 60 -- This is the length of the cooldown timer
local infAmnt = 9999 -- Amount of ammo you wish to give of common ammotype.
local rareAmnt = 12 -- Amount of ammo you wish to give of rare ammotype.
-- Shows Console That the Addon Is working.
print(prefix .. " Loading")

-- Function to give common ammotype to be called later.
local givePlyInfAmmo = function(ply)
	for v in pairs(YOGINFAMMOread) do
		ply:GiveAmmo(infAmnt, YOGINFAMMOread[v])
		ply:ChatPrint( prefix .. " ".. YOGINFAMMOread[v] .." Given x" .. infAmnt)
	end

end

-- Function to give rare ammotype to be called later.
local givePlyRareAmmo = function(ply)
	for x in pairs(YOGRAREAMMOread) do
		ply:GiveAmmo(rareAmnt, YOGRAREAMMOread[x])
		ply:ChatPrint( prefix .. " " .. YOGRAREAMMOread[x] .. " Given x" ..rareAmnt)
	end
end


-- Hook called on PlayerSay
-- Checks for the command !ammo (Can be changed)
-- Checks if Cooldown is active if not it continues
-- Gives ammo to Player and resets cooldown
hook.Add("PlayerSay", "giveAmmo", function(sender, text, teamChat)
	
	if timeLeft == 60 then
		sender.ammoCd = false
	end
	if string.lower(text) == "!ammo" then 
		if sender.ammoCd == false then
			givePlyRareAmmo(sender)
			givePlyInfAmmo(sender)
			timer.Create("ammoCooldown", 1, 60, function()
				timeLeft = timeLeft - 1
				sender.ammoCd = true
				if timeLeft == 0 then 
					timeLeft = timeLeft + 60
				end
			end)
		else
			sender:ChatPrint("You have to wait " .. timeLeft .. "s until you can spawn more ammo!")
		end
	end
end)