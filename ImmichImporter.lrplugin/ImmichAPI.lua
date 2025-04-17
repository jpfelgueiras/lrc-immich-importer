local LrDialogs = import 'LrDialogs'
local LrHttp = import 'LrHttp'
local LrTasks = import 'LrTasks'

ImmichAPI = {}
ImmichAPI.__index = ImmichAPI


function ImmichAPI:new(url, apiKey)
    local o = setmetatable({}, ImmichAPI)
    self.deviceIdString = 'Lightroom Immich Upload Plugin'
    self.apiBasePath = '/api'
    self.apiKey = apiKey
    self.url = url
    return o
end


function ImmichAPI:checkConnectivity(callback)

    if self.url == '' or self.apiKey == '' then
        LrDialogs.message("Test Connection", "URL or API Key is empty", "critical")
        if callback then callback(false) end
        return
    end


    local requestHeaders = ImmichAPI.createHeaders(self)


    LrTasks.startAsyncTask(function()
        local response, headers = LrHttp.get(self.url .. self.apiBasePath .. '/users/me', requestHeaders)

        if not response or not headers then
            LrDialogs.message("Test Connection", "LrHttp.get failed: No response or headers", "critical")
            if callback then callback(false) end
            return
        end

        if not headers.status then
            LrDialogs.message("Test Connection", "HTTP request failed: Missing status in headers", "critical")
            if callback then callback(false) end
            return
        end

        if headers.status == 200 then
            if callback then callback(true) end
        else
            LrDialogs.message("Test Connection", "Connection failed with status: " .. tostring(headers.status), "critical")
            if callback then callback(false) end
        end
    end)
end

-- Utility function to create headers
function ImmichAPI:createHeaders()
    return {
        { field = 'x-api-key',    value = self.apiKey },
        { field = 'Accept',       value = 'application/json' },
        { field = 'Content-Type', value = 'application/json' },
    }
end

