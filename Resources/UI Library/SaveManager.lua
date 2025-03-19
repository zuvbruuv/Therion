local httpService = game:GetService("HttpService")

local SaveManager = { Options = {}, Game = tostring(game.GameId) }
do
	SaveManager.Folder = "TherionSettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object)
				return { type = "Toggle", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, multi = object.Multi }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
                                        SaveManager.Options[idx]:SetValue(data.value)
					print("set", idx, data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object)
				return {
					type = "Colorpicker",
					idx = idx,
					value = object.Value:ToHex(),
					transparency = object.Transparency,
				}
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object)
				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},
		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] and type(data.text) == "string" then
					SaveManager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		if not name then
			return false, "no config file is selected"
		end

		local fullPath = self.Folder .. "/" .. self.Game .. "/settings/" .. name .. ".json"

		local data = {
			objects = {},
		}

		for idx, option in next, SaveManager.Options do
			if not self.Parser[option.Type] then
				continue
			end
			if self.Ignore[idx] then
				continue
			end
			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then
			return false, "failed to encode data"
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Delete(name)
		if not name then
			return false, "no config file is selected"
		end

		local fullPath = self.Folder .. "/" .. self.Game .. "/settings/" .. name .. ".json"
		if isfile(fullPath) then
			delfile(fullPath)

			if isfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt") then
				local autoloadPath = readfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt")
				if autoloadPath == name then
					delfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt")
					return true, "autoload"
				end
			end

			return true
		else
			return false, "config file not found"
		end
	end

	function SaveManager:Load(name)
		if not name then
			return false, "no config file is selected"
		end

		local file = self.Folder .. "/" .. self.Game .. "/settings/" .. name .. ".json"
		if not isfile(file) then
			return false, "invalid file"
		end

		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then
			return false, "decode error"
		end

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				task.spawn(function()
					self.Parser[option.type].Load(option.idx, option)
				end) -- task.spawn() so the config loading wont get stuck.
			end
		end

		if self.Options.MinimizeUI then
			self.Library.MinimizeKey = Enum.KeyCode[self.Options.MinimizeUI.Value]
		end

		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({
			"InterfaceTheme",
			"MenuKeybind",
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = {
			self.Folder,
			self.Folder .. "/" .. self.Game,
			self.Folder .. "/" .. self.Game .. "/settings",
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. "/" .. self.Game .. "/settings")

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local pos = file:find(".json", 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= "/" and char ~= "\\" and char ~= "" do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == "/" or char == "\\" then
					local name = file:sub(pos + 1, start - 1)
					if name ~= "options" then
						table.insert(out, name)
					end
				end
			end
		end

		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
		self.Options = library.Options
	end

	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt")

			local success, err = self:Load(name)
			if not success then
				self.Library:Notify({
					Title = "Configuration Error",
					Description = "Failed to load startup config: " .. err,
					Duration = 7,
					Type = "error",
				})
				return
			end

			self.Library:Notify({
				Title = "Configuration Loaded",
				Description = string.format("Successfully loaded startup config: %q", name),
				Duration = 7,
				Type = "success",
			})
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library")

		local section1 = tab:AddSection({ Title = "STATUS" })

		-- Current Status
		local ConfigStatus = section1:AddText({
			Title = "Current Config",
			Description = "No config is currently loaded",
		})

		local AutoloadStatus = section1:AddText({
			Title = "Autoload Status",
			Description = "No config set to autoload",
		})

		local section2 = tab:AddSection({ Title = "CONFIGURATION MANAGEMENT" })

		-- Config List
		section2:AddDropdown("SaveManager_ConfigList", {
			Title = "Saved Configurations",
			Description = "Select a configuration to manage",
			Values = self:RefreshConfigList(),
			AllowNull = true,
		})

		-- Config Actions
		section2:AddButton({
			Title = "Load Config",
			Type = "primary",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value

				local success, err = self:Load(name)
				if not success then
					self.Library:Notify({
						Title = "Configuration Error",
						Description = "Failed to load config: " .. err,
						Duration = 7,
						Type = "error",
					})
					return
				end

				self.Library:Notify({
					Title = "Configuration Loaded",
					Description = string.format("Successfully loaded config %q", name),
					Duration = 7,
					Type = "success",
				})
				ConfigStatus:SetDescription(string.format("Current config: %s", name))
			end,
		})

		section2:AddButton({
			Title = "Delete Config",
			Type = "danger",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				if not name then
					self.Library:Notify({
						Title = "Configuration Error",
						Description = "No config selected to delete",
						Duration = 7,
						Type = "error",
					})
					return
				end

				local success, result = self:Delete(name)
				if not success then
					self.Library:Notify({
						Title = "Configuration Error",
						Description = "Failed to delete config: " .. result,
						Duration = 7,
						Type = "error",
					})
					return
				end

				self.Library:Notify({
					Title = "Configuration Deleted",
					Description = string.format("Successfully deleted config: %q", name),
					Duration = 7,
					Type = "success",
				})
				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
				ConfigStatus:SetDescription("No config is currently loaded")

				if result == "autoload" then
					AutoloadStatus:SetDescription("No config set to autoload")
				end
			end,
		})

		section2:AddButton({
			Title = "Update Config",
			Type = "default",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value

				local success, err = self:Save(name)
				if not success then
					self.Library:Notify({
						Title = "Configuration Error",
						Description = "Failed to update config: " .. err,
						Duration = 7,
						Type = "error",
					})
					return
				end

				self.Library:Notify({
					Title = "Configuration Updated",
					Description = string.format("Successfully updated config: %q", name),
					Duration = 7,
					Type = "success",
				})
			end,
		})

		local section3 = tab:AddSection({ Title = "CREATE NEW CONFIG" })

		-- New Config Creation
		section3:AddInput("SaveManager_ConfigName", {
			Title = "New Config Name",
			Description = "Enter a name for your new configuration",
		})

		section3:AddButton({
			Title = "Create New Config",
			Type = "primary",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigName.Value

				if type(name) ~= "string" or name:gsub(" ", "") == "" then
					self.Library:Notify({
						Title = "Configuration Error",
						Description = "Invalid config name (empty)",
						Duration = 7,
						Type = "error",
					})
					return
				end

				local success, err = self:Save(name)
				if not success then
					self.Library:Notify({
						Title = "Configuration Error",
						Description = "Failed to save config: " .. err,
						Duration = 7,
						Type = "error",
					})
					return
				end

				self.Library:Notify({
					Title = "Configuration Created",
					Description = string.format("Successfuly created config: %q", name),
					Duration = 7,
					Type = "success",
				})

				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
				ConfigStatus:SetDescription(string.format("Current config: %s", name))
			end,
		})

		local section4 = tab:AddSection({ Title = "UTILITIES" })

		-- Utility
		section4:AddButton({
			Title = "Refresh Config List",
			Type = "default",
			Callback = function()
				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
			end,
		})

		section4:AddButton({
			Title = "Set as Autoload",
			Type = "default",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				writefile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt", name)
				AutoloadStatus:SetDescription(string.format("Config %q will load automatically", name))
				self.Library:Notify({
					Title = "Autoload Set",
					Description = string.format("Successfully set %q to auto startup", name),
					Duration = 7,
					Type = "success",
				})
			end,
		})

		-- Initialize autoload status
		if isfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/" .. self.Game .. "/settings/autoload.txt")
			ConfigStatus:SetDescription(string.format("Current config: %s", name))
			AutoloadStatus:SetDescription(string.format("Config %q will load automatically", name))
		end

		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
		SaveManager:LoadAutoloadConfig()
	end

	SaveManager:BuildFolderTree()
end

return SaveManager
