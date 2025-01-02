--[[ Framework.lua
  Main base of Therion
]]

local owner, branch = 'zuvbruuv', 'main'

local function Import(path, args)
    local repo, file = path:match('([^/]+)/([^/]+)')
    local url = ('https://raw.githubusercontent.com/%s/%s/refs/heads/%s/%s'):format(owner, repo, branch, file)

    local success, result = pcall(function()
        return loadstring(game:HttpGetAsync(url), file)(args or {})
    end)

    if not success then
        error(("[THERION] Failed to import '%s': %s"):format(path, result), 2)
    end

    return result
end

return function(config)
    config = config or {}

    if not config[game.PlaceId] then
        return nil
    end

    local Therion    = {
        Shared       = setmetatable({}, {
            __index  = function(_, key)
                warn(("[THERION] Attempt to access non-existent shared key '%s'"):format(key))
                return nil
            end
        }),
        Managers     = {
            Signal   = Import('Managers/Signal.lua'),
            Cleaner  = Import('Managers/Janitor.lua'),
            Instance = Import('Managers/Instance.lua'),
            sha1     = Import('Managers/sha1.lua'),

            Module   = {
                cache = {},

                create = function(self, name, load)
                    if not self.cache[name] then
                        local module = {}

                        load(module)

                        if module then
                            self.cache[name] = module
                        else
                            warn(("[THERION] Failed to import module '%s'."):format(name))
                        end
                    end
                end,

                get = function(self, name)
                    return self.cache[name] or nil
                end,

                unload = function(self)
                    for _, module in pairs(self.cache) do
                        table.clear(module)
                    end
                    self.cache = {}
                end
            }
        },
        Services    = setmetatable({}, {
            __index = function(self, service)
                local instance = game:GetService(service)

                rawset(self, service, instance)

                return instance
            end
        })
    }

    -- Base Directory
    local baseDir = 'therion'
    local gameDir = ('%s/games/%d'):format(baseDir, game.PlaceId)

    if not isfolder(baseDir) then
        makefolder(baseDir)
    end

    if not isfolder(baseDir .. '/games') then
        makefolder(baseDir .. '/games')
    end

    if not isfolder(gameDir) then
        makefolder(gameDir)
    end

    config[game.PlaceId]()

    return Therion, Import, gameDir
end
