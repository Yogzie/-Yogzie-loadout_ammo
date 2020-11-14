include("autorun/client/cl_loadoutammogui.lua")
print("[TableEditor] Has Loaded")

YOGeditorCheck = function(ply)
	print("check ran")
	for k in pairs(YOGEDITOR) do
		if ply:GetUserGroup() == YOGEDITOR[k] then
			return true
		end
	end
end

SHAREDyoggui = function(ply, bool)
	yoggui(ply,bool)
end