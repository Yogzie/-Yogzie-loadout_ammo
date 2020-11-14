local tableCount = 4
local currentTab = 1
local tableNow = YOGstaffLoadout
local showLDT = false
local showRNK = false
local showINF = false
local showRAR = false
local guiOpened = false

local colors = {
	["background"] = Color(0,0,0,230),
	["secondary"] = Color(66,66,66,200),
	["tertiary"] = Color(255,255,255,255),
}


net.Receive("YOG_opengui", function(len)
	yogtabgui(LocalPlayer(), true)
end)

yogtabgui = function(ply, open)
 	display = {}
	if open then
		net.Start("YOG_reqalltabs")
		net.SendToServer()
		net.Receive("YOG_sendalltabs", function()
			guiOpened = true

			local YOGstaffLoadout = {}
			YOGstaffLoadout = net.ReadTable()
			local YOGstaffRanks = {}
			YOGstaffRanks = net.ReadTable()

			local YOGinfAmmo = {}
			YOGinfAmmo = net.ReadTable()			
			local YOGrareAmmo = {}
			YOGrareAmmo = net.ReadTable()

			--[[YOGstaffRanks = net.ReadTable()
			YOGinfAmmo = net.ReadTable()
			YOGrareAmmo = net.ReadTable()]]

			--[[net.Start("YOGrequestSTAFFLOADOUT")
			net.SendToServer()
			net.Receive("YOG_SENDSTAFFLOADOUT", function(len)		
				YOGstaffLoadout = net.ReadTable()
				yogLDT = YOGstaffLoadout
			end)
			PrintTable(YOGstaffLoadout)

			net.Start("YOGrequestSTAFFRANKS")
			net.SendToServer()
			net.Receive("YOG_SENDSTAFFRANKS", function(len)
				YOGstaffRanks = net.ReadTable()
				yogRNK = YOGstaffRanks
			end)
			PrintTable(YOGstaffRanks)

			net.Start("YOGrequestINFAMMO")
			net.SendToServer()
			net.Receive("YOG_SENDINFAMMO", function(len)
				YOGinfAmmo = net.ReadTable()
				PrintTable(YOGinfAmmo)
			end)

			net.Start("YOGrequestRAREAMMO")
			net.SendToServer()
			net.Receive("YOG_SENDRAREAMMO", function(len)
				YOGrareAmmo = net.ReadTable()
				PrintTable(YOGrareAmmo)
			end)]]

			--[[
				Got Brain fog on this and spent hours of Friday 13/11/2020 figuring out why i wasn't getting the tables to appear when i was overwriting YOGstaffLoadout constantly due to a typo :/ 
			]]

			local scrw, scrh = ScrW(), ScrH()
			local boxw, boxh = scrw * 0.3, scrh * 0.4
			yogMenu = vgui.Create("DFrame")
			yogMenu:SetTitle("")
			yogMenu:SetSize( boxw , boxh)
			yogMenu:MakePopup()
			yogMenu:Center()
			yogMenu.Paint = function(self, w, h)
				draw.RoundedBox(10,0,0, w, h, colors.background)
				draw.RoundedBoxEx(10, 0, 0, w, h * 0.09, color_black, true, true, false, false)
				draw.SimpleText("Yogzie's Table Editor", "ChatFont", boxw * 0.02, boxh * 0.025, color_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end --[[ I spent too long looking for a reason why a large render queue was making the game
			lag and rendering the derma assets unusable, it was the "end" that was missing. :( ]]




			local yogAdd = vgui.Create("DComboBox", yogMenu)
			yogAdd:SetValue("Change Table")
			yogAdd:SetSize(boxw * 0.3, boxh * 0.12)
			yogAdd:SetPos(boxw * 0.65, boxh * 0.23)
			yogAdd:AddChoice("Staff Loadout")
			yogAdd:AddChoice("Staff Ranks")
			yogAdd:AddChoice("Common Ammotypes")
			yogAdd:AddChoice("Rare Ammotypes")

			function yogAdd:OnSelect(index, str, data)
				if str == "Staff Loadout" then
					DisplayTable(YOGstaffLoadout)
				elseif str == "Staff Ranks" then
					DisplayTable(YOGstaffRanks)
				elseif str == "Common Ammotypes" then
					DisplayTable(YOGinfAmmo)		
				elseif str == "Rare Ammotypes" then
					DisplayTable(YOGrareAmmo)
				end
			end

			yogEntry = vgui.Create("DTextEntry", yogMenu)
			yogEntry:SetPos(boxw * 0.15, boxh * 0.8)
			yogEntry:SetSize(boxw * 0.3, boxh * 0.07)
			yogEntry:SetPlaceholderText("New Value Here")


			yogEntryLb = vgui.Create("DLabel", yogMenu)
			yogEntryLb:SetPos(boxw * 0.22, boxh * 0.72)
			yogEntryLb:SetSize(boxw *0.37, boxh * 0.13)
			yogEntryLb:SetColor(colors.tertiary)
			yogEntryLb:SetText("Insert New Item")

			yogEntryTwoLb = vgui.Create("DLabel", yogMenu)
			yogEntryTwoLb:SetPos(boxw * 0.22, boxh * 0.83)
			yogEntryTwoLb:SetSize(boxw *0.37, boxh * 0.13)
			yogEntryTwoLb:SetColor(colors.tertiary)
			yogEntryTwoLb:SetText("Case Sensitive")

			yogAddButton = vgui.Create("DButton", yogMenu)
			yogAddButton:SetText("Add Value")
			yogAddButton:SetSize(boxw * 0.3, boxh * 0.12)
			yogAddButton:SetPos(boxw * 0.65, boxh * 0.53)

			yogRemoveButton = vgui.Create("DButton", yogMenu)
			yogRemoveButton:SetText("Remove Value")
			yogRemoveButton:SetSize(boxw * 0.3, boxh * 0.12)
			yogRemoveButton:SetPos(boxw * 0.65, boxh * 0.75)


			local yogScroll = vgui.Create("DScrollPanel", yogMenu)
			yogScroll:SetPos(boxw * 0.1, boxh * 0.15)
			yogScroll:SetSize(boxw * 0.4, boxh * 0.6)
			yogScroll.Paint = function(self, w, h)
				surface.SetDrawColor(colors.secondary)
				surface.DrawRect(0,0, w, h)
			end

			-- For Aesthetic
			local yogScrollBDR = vgui.Create("DPanel", yogMenu)
			yogScrollBDR:SetPos(boxw * 0.1, boxh * 0.15)
			yogScrollBDR:SetSize(boxw * 0.4, boxh * 0.6)
			yogScrollBDR.Paint = function(self, w, h)
				surface.SetDrawColor(Color(0,0,0,230))
				surface.DrawOutlinedRect( 0, 0, w , h, 2)
			end


			local panw, panh = yogScroll:GetWide(), yogScroll:GetTall()
			local ypos = 0
			local panelColor = Color(255,255,255,255)
			DisplayTable = function(tab)
				for k, v in pairs(tab) do
					yogshowLDT = vgui.Create("DPanel", yogScroll)
					yogshowLDT:SetPos( panw * 0.09, ypos)
					yogshowLDT:SetSize(panw * 0.8, panh * 0.15)
					yogshowLDT.DoClick = function(ply)
						panelColor = Color(66,66,66,200)
						DisplayTable()
					end
					yogshowLDT.Paint = function(self, w, h)
						surface.SetDrawColor(panelColor)
						surface.DrawRect(0,0,w,h)
						draw.SimpleText(tab[k], ChatFont, w * 0.5, h * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
					ypos = ypos + yogshowLDT:GetTall() * 1.1
				end
			end

		end)
	end
end
