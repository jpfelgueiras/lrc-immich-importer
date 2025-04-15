return {
    LrSdkVersion = 6.0, -- Minimum SDK version
    LrToolkitIdentifier = 'com.jpfelgueiras.immichimporter',
    LrPluginName = "Immich Importer",
    LrPluginInfoUrl = "https://jpfelgueiras.com",


    -- Menu integration
    LrExportMenuItems = {
        {
            title = "Import from Immich",
            file = "Main.lua",
            --enabledWhen = "photosAvailable", -- Optional condition
        },
        {
            title = "Configure Immich Settings",
            file = "SettingsDialog.lua",
        },
    },

}