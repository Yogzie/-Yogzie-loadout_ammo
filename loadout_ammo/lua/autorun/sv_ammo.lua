infAmmo = {"tfa_ammo_sniper_rounds", "tfa_ammo_ar2", "tfa_ammo_pistol", "buckshot"} -- place common ammotypes here
rareAmmo = {"ammo_rpgclip"} -- place rare ammotypes here(explosives etc)
local prefix = "[EventAmmo]" -- Prefix for chatprint
local ammoCd = false -- Cooldown Variable (dont touch)
local timeLeft = 180 -- This is the length of the cooldown timer
local timerReps = 180 -- This is the variable used to display cooldown time left to player
local infAmnt = 9999 -- Amount of ammo you wish to give of common ammotype.
local rareAmnt = 12 -- Amount of ammo you wish to give of rare ammotype.

-- Shows Console That the Addon Is working.
print(prefix .. " Loading")

-- Function to give common ammotype to be called later.
local givePlyInfAmmo = function(ply)
	for v in pairs(infAmmo) do
		ply:GiveAmmo(infAmnt, infAmmo[v])
		ply:ChatPrint( prefix .. " ".. infAmmo[v] .." Given x" .. infAmnt)
	end

end

-- Function to give rare ammotype to be called later.
local givePlyRareAmmo = function(ply)
	for x in pairs(rareAmmo) do
		ply:GiveAmmo(rareAmnt, rareAmmo[x])
		ply:ChatPrint( prefix .. " " .. rareAmmo[x] .. " Given x" ..rareAmnt)
	end
end

-- Hook called on PlayerSay
-- Checks for the command !ammo (Can be changed)
-- Checks if Cooldown is active if not it continues
-- Gives ammo to Player and resets cooldown
hook.Add("PlayerSay", "giveAmmo", function(sender, text, teamChat)
	if text == "!ammo" then 
		if ammoCd == true then
			sender:ChatPrint("You have to wait " .. timerReps .. "s until you can spawn more ammo!")
		else
			givePlyRareAmmo(sender)
			givePlyInfAmmo(sender)
			timerCd(true)
			timer.Create("ammoTimer", 1, timeLeft, function()
				timerReps = timerReps - 1
				if timerReps == 359 then
					ammoCd = true
				end
			end)
		end
	end
end)

