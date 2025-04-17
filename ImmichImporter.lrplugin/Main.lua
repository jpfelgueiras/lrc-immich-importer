require "ImmichAPI"

local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrView = import 'LrView'
local LrPrefs = import 'LrPrefs'

local function getImmichAlbums()
    local serverUrl = _G.globalSettings and _G.globalSettings.serverUrl or "Not Set"
    local apiKey = _G.globalSettings and _G.globalSettings.apiKey or "Not Set"

    local immich = ImmichAPI:new(serverUrl, apiKey)
    
    return immich:getAlbums()    
end

local function loadAlbumPhotos(selectedAlbum)
    local serverUrl = _G.globalSettings and _G.globalSettings.serverUrl or "Not Set"
    local apiKey = _G.globalSettings and _G.globalSettings.apiKey or "Not Set"

    local immich = ImmichAPI:new(serverUrl, apiKey)
    LrTasks.startAsyncTask(function()
        local albumAssets = immich:getAlbumAssets(selectedAlbum)
        if albumAssets then
            for i = 1, #albumAssets do
                local asset = albumAssets[i]
                -- TODO Create a background task to download the asset
                -- and import it into Lightroom
                -- For now, just show a message with the asset URL
                LrDialogs.message("Asset", "Asset"..asset, "critical")
            end
        else
            LrDialogs.message("Error", "Failed to load album assets.", "critical")
        end
    end)
end

local prefs = LrPrefs.prefsForPlugin()

local function showDialog()
    LrTasks.startAsyncTask(function()
        local albums = getImmichAlbums()
        prefs.selectedAlbum = albums[1] and albums[1].value or nil
        local f = LrView.osFactory()
        local contents = f:column {
            bind_to_object = prefs,
            spacing = f:control_spacing(),
            f:row {
                f:static_text {
                    title = "Immich Album:",
                    alignment = 'right',
                    width = LrView.share 'label_width',
                },
                f:popup_menu {
                    items = albums,
                    value = LrView.bind('selectedAlbum'),
                    width = 250,
                },
            },
        }

        local result = LrDialogs.presentModalDialog {
            title = "Immich Settings",
            contents = contents,
            actionVerb = "Import",
        }

        if result == "ok" then
            loadAlbumPhotos(prefs.selectedAlbum)
        end
    end)
end

showDialog() -- Runs when the menu item is clicked