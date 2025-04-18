require "ImmichAPI"

local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrView = import 'LrView'
local LrPrefs = import 'LrPrefs'
local LrPathUtils = import 'LrPathUtils'

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
            local catalog = import 'LrApplication'.activeCatalog()
            local tempFiles = {}

            -- Download all assets and save them to temporary files
            for i = 1, #albumAssets do
                local asset = albumAssets[i]
                local assetData = immich:downloadAsset(asset.id)
                if assetData then
                    local tempFilePath = LrPathUtils.child(LrPathUtils.getStandardFilePath("temp"), asset.originalFileName)
                    local file = io.open(tempFilePath, "wb")
                    if file then
                        file:write(assetData)
                        file:close()
                        table.insert(tempFiles, tempFilePath)
                    else
                        LrDialogs.message("Error", "Failed to save asset to temporary file.", "critical")
                    end
                else
                    LrDialogs.message("Error", "Failed to download asset: " .. asset, "critical")
                end
            end

            -- Import all downloaded files into the catalog in a single write access block
            catalog:withWriteAccessDo("Import Assets", function()
                for _, tempFilePath in ipairs(tempFiles) do
                    catalog:addPhoto(tempFilePath)
                end
            end)

            LrDialogs.message("Success", "All assets have been imported into the catalog.", "info")
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