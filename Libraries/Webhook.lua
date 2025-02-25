local HttpService = game:GetService("HttpService")

local Webhook = {}
Webhook.__index = Webhook

function Webhook.new(Url)
    local self = setmetatable({}, Webhook)
    self.Url = Url:match("(.+)%?") or Url
    self.Id, self.Token = self.Url:match("webhooks/(%d+)/([%w-_]+)")
    
    return self
end

local function Request(Url, Method, Body)
    local http = request or http_request

    return http({
        Url = Url,
        Method = Method,
        Headers = { ["Content-Type"] = "application/json" },
        Body = Body and HttpService:JSONEncode(Body) or nil
    })
end

function Webhook:Send(Content, Embed)
    local Res = Request(self.Url .. "?wait=true", "POST", {
        content = Content or nil,
        embeds = Embed and {Embed} or nil
    })
    
    if Res and Res.Success then
        local Data = HttpService:JSONDecode(Res.Body)
        return Data.id
    end
    
    warn("Failed to Send Message")
    return nil
end

function Webhook:Edit(MessageId, Content, Embed)
    local Res = Request(self.Url .. "/messages/" .. MessageId, "PATCH", {
        content = Content or nil,
        embeds = Embed and {Embed} or nil
    })
    
    if Res and Res.Success then
        return true
    end
    
    warn("Failed to Edit Message")
    return false
end

function Webhook:Delete(MessageId)
    local Res = Request(self.Url .. "/messages/" .. MessageId, "DELETE")
    
    if Res and Res.Success then
        return true
    end
    
    warn("Failed to Delete Message")
    return false
end

return Webhook
