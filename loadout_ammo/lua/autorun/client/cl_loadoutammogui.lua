local tableCount = 4
local currentTab = 1
local showLDT = false
local showRNK = false
local showINF = false
local showRAR = false
local tableSelected = 0
--   1 = Loadout   2 = Ranks   3 = INFAmmo   4 = RAREAmmo
local keySelected = 0

blankTab = {}

local colors = {
	["background"] = Color(0,0,0,230),
	["secondary"] = Color(66,66,66,200),
	["tertiary"] = Color(255,255,255,255),
	["transparent"] = Color(0,0,0,0),

}


net.Receive("YOG_opengui", function(len)
	yogtabgui(LocalPlayer(), true)
end)


local YOGREMOVEitem = function(key, tab)
	net.Start("YOGRemove_Item")
	net.WriteInt(tab, 8) -- Table 1-4 digit (Keyed at the top of the file)
	net.WriteInt(key, 8) -- Table Key Value for Removal
	net.SendToServer()
end

local YOGADDitem = function(tab)
	net.Start("YOGAdd_Item")
	net.WriteInt(tab, 8) -- Table 1-4 digit (Keyed at the top of the file)
	net.SendToServer()
end


yogtabgui = function(ply, open)
		if open then
			display = {}
			local displayCalled = 0

			net.Start("YOG_reqalltabs")
			net.SendToServer()
			net.Receive("YOG_sendalltabs", function()

				local YOGstaffLoadout = {}
				YOGstaffLoadout = net.ReadTable()
				local YOGstaffRanks = {}
				YOGstaffRanks = net.ReadTable()
				local YOGinfAmmo = {}
				YOGinfAmmo = net.ReadTable()			
				local YOGrareAmmo = {}
				YOGrareAmmo = net.ReadTable()


				local scrw, scrh = ScrW(), ScrH()
				local boxw, boxh = scrw * 0.3, scrh * 0.4
				yogMenu = vgui.Create("DFrame")
				function yogMenu:Init()
					self.startTime = SysTime()
				end
				yogMenu:SetTitle("")
				yogMenu:SetSize( boxw , boxh)
				yogMenu:MakePopup()
				yogMenu:Center()
				yogMenu.Paint = function(self, w, h)
					Derma_DrawBackgroundBlur(self, self.startTime)
					draw.RoundedBox(10,0,0, w, h, colors.background)
					draw.RoundedBoxEx(10, 0, 0, w, h * 0.09, color_black, true, true, false, false)
					draw.SimpleText("Yogzie's Table Editor", "ChatFont", boxw * 0.02, boxh * 0.025, color_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				end --[[ I spent too long looking for a reason why a large render queue was making the game
				lag and rendering the derma assets unusable, it was the "end" that was missing. :( ]]


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

				yogComboLb = vgui.Create("DLabel", yogMenu)
				yogComboLb:SetPos(boxw * 0.66, boxh * 0.14)
				yogComboLb:SetSize(boxw *0.37, boxh * 0.13)
				yogComboLb:SetColor(colors.tertiary)
				yogComboLb:SetText("Select Option Twice to Show")

				yogComboTwoLb = vgui.Create("DLabel", yogMenu)
				yogComboTwoLb:SetPos(boxw * 0.67, boxh * 0.31)
				yogComboTwoLb:SetSize(boxw *0.37, boxh * 0.13)
				yogComboTwoLb:SetColor(colors.tertiary)
				yogComboTwoLb:SetText("Because Im Bad At Coding")

				yogAddButton = vgui.Create("DButton", yogMenu)
				yogAddButton:SetText("Add Value")
				yogAddButton:SetSize(boxw * 0.3, boxh * 0.12)
				yogAddButton:SetPos(boxw * 0.65, boxh * 0.53)

				yogRemoveButton = vgui.Create("DButton", yogMenu)
				yogRemoveButton:SetText("Remove Value")
				yogRemoveButton:SetSize(boxw * 0.3, boxh * 0.12)
				yogRemoveButton:SetPos(boxw * 0.65, boxh * 0.75)
				yogRemoveButton.DoClick = function(ply)
					YOGREMOVEitem(keyVSelected, tableSelected)
				end




				DisplayTable = function(tab)
					if displayCalled == 0 then
						yogScroll = vgui.Create("DScrollPanel", yogMenu)
						yogScroll:SetPos(boxw * 0.1, boxh * 0.15)
						yogScroll:SetSize(boxw * 0.4, boxh * 0.6)
						yogScroll.Paint = function(self, w, h)
							surface.SetDrawColor(colors.transparent)
							surface.DrawRect(0,0, w, h)
						end
					end


					local panw, panh = yogScroll:GetWide(), yogScroll:GetTall()
					local ypos = 0
					local panelColor = Color(255,255,255,255)
					if showLDT == true then
						for k, v in pairs(tab) do
							YOGKeyV = k
							local yogshowLDT = vgui.Create("DButton", yogScroll)
							yogshowLDT:SetText(tab[k])
							yogshowLDT:SetPos( panw * 0.09, ypos)
							yogshowLDT:SetSize(panw * 0.8, panh * 0.15)
							yogshowLDT.DoClick = function()
								keyVSelected = YOGKeyV
								print("dsfjsaljfjhal")
							end
							ypos = ypos + yogshowLDT:GetTall() * 1.1
						end
					end

					if showRNK == true then
						for k, v in pairs(tab) do
							local yogshowRNK = vgui.Create("DButton", yogScroll)
							yogshowRNK:SetText(tab[k])
							yogshowRNK:SetPos( panw * 0.09, ypos)
							yogshowRNK:SetSize(panw * 0.8, panh * 0.15)
							yogshowRNK.DoClick = function()
								keyVSelected = YOGKeyV
								print("dsfjsaljfjhal")
							end
							ypos = ypos + yogshowRNK:GetTall() * 1.1
						end
					end

					if showINF == true then
						for k, v in pairs(tab) do
							local yogshowINF = vgui.Create("DButton", yogScroll)
							yogshowINF:SetText( tab[k] )
							yogshowINF:SetPos( panw * 0.09, ypos)
							yogshowINF:SetSize(panw * 0.8, panh * 0.15)
							yogshowINF.DoClick = function(ply)
								keyVSelected = YOGKeyV
								print("dsfjsaljfjhal")
							end
							ypos = ypos + yogshowINF:GetTall() * 1.1
						end
					end

					if showRAR == true then
						for k, v in pairs(tab) do
							local yogshowRAR = vgui.Create("DButton", yogScroll)
							yogshowRAR:SetText( tab[k] )
							yogshowRAR:SetPos( panw * 0.09, ypos )
							yogshowRAR:SetSize( panw * 0.8, panh * 0.15)
							yogshowRAR.DoClick = function(ply)
								panelColor = Color(66,66,66,200)
								DisplayTable()
							end
							ypos = ypos + yogshowRAR:GetTall() * 1.1
						end			
					end
						displayCalled = displayCalled + 1
						if displayCalled > 1 then
							yogScroll:Remove()
							displayCalled = 0
						end
					end

				-- For Aesthetic
				yogScrollBDR = vgui.Create("DPanel", yogMenu)
				yogScrollBDR:SetPos(boxw * 0.1, boxh * 0.13)
				yogScrollBDR:SetSize(boxw * 0.4, boxh * 0.6)
				yogScrollBDR.Paint = function(self, w, h)
					surface.SetDrawColor(Color(0,0,0,230))
					surface.DrawOutlinedRect( 0, 0, w , h, 2)
				end

				yogAdd = vgui.Create("DComboBox", yogMenu)
				yogAdd:SetValue("Change Table")
				yogAdd:SetSize(boxw * 0.3, boxh * 0.12)
				yogAdd:SetPos(boxw * 0.65, boxh * 0.23)
				yogAdd:AddChoice("Staff Loadout")
				yogAdd:AddChoice("Staff Ranks")
				yogAdd:AddChoice("Common Ammotypes")
				yogAdd:AddChoice("Rare Ammotypes")

				function yogAdd:OnSelect(index, str, data)
					if str == "Staff Loadout" then
							showLDT = true
							showRNK = false
							showINF = false
							showRAR = false
							DisplayTable(YOGstaffLoadout)
							tableSelected = 1
					elseif str == "Staff Ranks" then
							showLDT = false
							showRNK = true
							showINF = false
							showRAR = false
							DisplayTable(YOGstaffRanks)
							tableSelected = 2
					elseif str == "Common Ammotypes" then
							showLDT = false
							showRNK = false
							showINF = true
							showRAR = false
							DisplayTable(YOGinfAmmo)
							tableSelected = 3
					elseif str == "Rare Ammotypes" then
							showLDT = false
							showRNK = false
							showINF = false
							showRAR = true
							DisplayTable(YOGrareAmmo)
							tableSelected = 4
					end
				end
			end)
		end
end