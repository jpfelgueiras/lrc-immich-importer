

local prefs = LrPrefs.prefsForPlugin()

-- Function to test the connection
local function testConnection()
    local tempServerUrl = prefs.tempServerUrl or "Not set"
    local tempApiKey = prefs.tempApiKey or "Not set"

    local immich = ImmichAPI:new(tempServerUrl, tempApiKey)
    immich:checkConnectivity(function(success)
        if success then
            LrDialogs.message("Test Connection", "Immich connection working!", "info")
        else
            LrDialogs.message("Test Connection", "Immich connection not working, probably due to wrong URL and/or API key.", "critical")
        end
    end)  
end

local function showSettingsDialog()
    prefs.tempServerUrl = "Please define the Immich server URL"
    prefs.tempApiKey = "Please define the Immich API key"

    if _G.globalSettings then
        prefs.tempServerUrl = _G.globalSettings.serverUrl or "Please define the Immich server URL"
        prefs.tempApiKey = _G.globalSettings.apiKey or "Please define the Immich API key"
    end

    local f = LrView.osFactory()
    local contents = f:column {
        bind_to_object = prefs,
        spacing = f:control_spacing(),
        f:row {
            f:static_text {
                title = "Immich Server URL:",
                alignment = 'right',
                width = LrView.share 'label_width',
            },
            f:edit_field {
                value = LrView.bind('tempServerUrl'),
                width_in_chars = 30,
                immediate = true,
            },
        },
        f:row {
            f:static_text {
                title = "API Key:",
                alignment = 'right',
                width = LrView.share 'label_width',
            },
            f:edit_field {
                value = LrView.bind('tempApiKey'),
                width_in_chars = 30,
                immediate = true,
            },
        },
        f:row {
            f:push_button {
                title = "Test Connection",
                action = testConnection, -- Call the separate function
            },
        },
    }

    local result = LrDialogs.presentModalDialog {
        title = "Immich Settings",
        contents = contents,
        actionVerb = "Save",
    }

    if result == "ok" then
        -- Save to preferences
        _G.globalSettings = {
            serverUrl = prefs.tempServerUrl,
            apiKey = prefs.tempApiKey,
        }
    end
end

showSettingsDialog()