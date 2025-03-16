local InterfaceBuilder = {
	Options = {},
	Library = nil,
}

function InterfaceBuilder:SetLibrary(Library)
	self.Library = Library
end

function InterfaceBuilder:BuildInterfaceSection(Tab)
	assert(self.Library, "Library not set! Please call SetLibrary first.")
	assert(Tab, "Tab argument missing!")

	-- Shared Settings Section
	local Section = Tab:AddSection({ Title = "INTERFACE" })

	Section:AddToggle("SilentModeToggle", {
		Title = "Silent Mode",
		Description = "Hides the window on execution and disables notifications",
		Default = false,
		Callback = function(state)
			self.Library:SetSilentMode(state)
		end,
	})

	Section:AddDropdown("ThemePicker", {
		Title = "Theme",
		Description = "Change the UI theme to preview",
		Values = self.Library:GetThemes(),
		Default = self.Library.Theme,
		Callback = function(value)
			self.Library:SetTheme(value)
		end,
	})

	local MinimizeUI = Section:AddKeybind("MinimizeUI", {
		Title = "Minimize Bind",
		Description = "The key which you must press to minimize the window",
		Default = self.Library.MinimizeKey.Name,
	})
	MinimizeUI:OnChanged(function()
		self.Library.MinimizeKey = Enum.KeyCode[MinimizeUI.Value]
	end)
	self.Library.MinimizeKey = Enum.KeyCode[MinimizeUI.Value]

	Section:AddSlider("UIScale", {
		Title = "UI Scale",
		Description = "Adjusts the size of the window",
		Default = 100,
		Min = 75,
		Max = 150,
		Rounding = 1,
		Callback = function(num)
			self.Library.Window:SetScale(num / 100)
		end,
	})
end

return InterfaceBuilder
