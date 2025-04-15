local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrView = import 'LrView'
local LrPrefs = import 'LrPrefs'

local function getImmichAlbums()
    -- TODO - Replace this with a real API call to get albums from Immich
    return {
        { title = "Vacation 2025", value = "vacation_2025" },
        { title = "Family", value = "family" },
        { title = "Work", value = "work" },
        { title = "Personal", value = "personal" },
    }
end

local prefs = LrPrefs.prefsForPlugin()

local function showDialog()
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
        -- TODO - Add the logic to import photos from Immich
        -- TODO - Access the global values
        local serverUrl = _G.globalSettings and _G.globalSettings.serverUrl or "Not Set"
        local apiKey = _G.globalSettings and _G.globalSettings.apiKey or "Not Set"
        local selectedAlbumValue = prefs.selectedAlbum

        local selectedAlbumTitle = LrDialogs.message("Import!", 
            string.format("Importing photos from Immich...\nSelected Album: %s\nServer URL: %s\nAPI Key: %s", 
            selectedAlbumValue or "None",
            serverUrl,
            apiKey), 
            "info")
    end
    
end

showDialog() -- Runs when the menu item is clicked