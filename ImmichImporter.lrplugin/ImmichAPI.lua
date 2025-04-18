
local LrDialogs = import 'LrDialogs'
local LrHttp = import 'LrHttp'
local LrTasks = import 'LrTasks'
local JSON = require "JSON"

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

function ImmichAPI:downloadAsset(asset)
    local assetUrl = self.url .. self.apiBasePath .. asset

    -- Perform the HTTP GET request to download the asset
    local response, headers = LrHttp.get(assetUrl, ImmichAPI.createHeaders(self))

    if headers.status == 200 and response then
        -- Return the response (binary data of the asset)
        return response
    else
        -- Log an error message if the download fails
        LrDialogs.message("Error", "Failed to download asset. HTTP Status: " .. tostring(headers.status), "critical")
        return nil
    end
end

function ImmichAPI:getAlbumAssets(albumId)
    local path = '/albums/' .. albumId
    local parsedResponse = ImmichAPI.doGetRequest(self, path)
    local assets = {}
    if parsedResponse then
        if  parsedResponse.assets then
            for i = 1, #parsedResponse.assets do
                local row = parsedResponse.assets[i]
                table.insert(assets,{
                    id = "/assets/"..row.id.."/original",
                    originalFileName = row.originalFileName,
                })
            end
        else
            LrDialogs.message('No assets found in the response.')
        end
       
        return assets
    else
        return nil
    end
end

function ImmichAPI:getAlbums()
    local path = '/albums'
    local parsedResponse = ImmichAPI.doGetRequest(self, path)
    local albums = {}
    if parsedResponse then
        for i = 1, #parsedResponse do
            local row = parsedResponse[i]
            table.insert(albums,
                { title = row.albumName , value = row.id })
        end
        return albums
    else
        return nil
    end
end

function ImmichAPI:doGetRequest(apiPath)

    local response, headers = LrHttp.get(self.url .. self.apiBasePath .. apiPath, ImmichAPI.createHeaders(self))

    if headers.status == 200 then
        return JSON:decode(response)
    else

        if response ~= nil then
            LrDialogs.message('Response body: ' .. response)
        end
        return nil
    end
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

