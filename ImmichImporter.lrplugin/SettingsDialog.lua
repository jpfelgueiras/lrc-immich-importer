local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrPrefs = import 'LrPrefs'

local prefs = LrPrefs.prefsForPlugin()




local function showSettingsDialog()
    prefs.tempServerUrl = "Please define the Immich server URL"
    prefs.tempApiKey= "Please define the Immich API key"

    if _G.globalSettings then
        prefs.tempServerUrl = _G.globalSettings.serverUrl or "Please define the Immich server URL"
        prefs.tempApiKey = _G.globalSettings.apiKey or  "Please define the Immich API key"
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
                action = function()
                    -- TODO - Replace this with a real API call to test the connection
                    local tempServerUrl = prefs.tempServerUrl or "Not set"
                    local tempApiKey = prefs.tempApiKey or "Not set"
                    LrDialogs.message("Test Connection", "Server URL: " .. tempServerUrl .. "\nAPI Key: " .. tempApiKey, "info")
                end,
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