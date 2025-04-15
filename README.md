# Immich Importer Lightroom Plugin

The **Immich Importer** is a Lightroom plugin that allows users to import photos from the Immich server into Adobe Lightroom. It provides a simple interface to configure the server settings and select albums for import.

## Features

- **Import Photos**: Import photos from Immich albums directly into Lightroom.
- **Configure Settings**: Set the Immich server URL and API key through a user-friendly settings dialog.
- **Album Selection**: Choose specific albums to import from Immich.

## Installation

1. Clone or download this repository.
2. Copy the `ImmichImporter.lrplugin` folder to a location on your computer.
3. Open Adobe Lightroom.
4. Go to `File > Plug-in Manager`.
5. Click `Add` and select the `ImmichImporter.lrplugin` folder.
6. Enable the plugin.

## Usage

### Configure Immich Settings

1. In Lightroom, go to `File > Plug-in Extras > Configure Immich Settings`.
2. Enter the **Immich Server URL** and **API Key**.
3. Click **Test Connection** to verify the settings.
4. Click **Save** to store the configuration.

### Import Photos from Immich

1. In Lightroom, go to `File > Plug-in Extras > Import from Immich`.
2. Select an album from the dropdown menu.
3. Click **Import** to start importing photos.

## File Structure

    .
    ├── ImmichImporter.lrplugin
    │   ├── Info.lua    # Plugin metadata and menu integration
    │   ├── Main.lua    # Handles the import functionality
    │   └── SettingsDialog.lua  # Handles the settings configuration dialog


## Development

### Prerequisites

- Adobe Lightroom Classic
- Lua programming knowledge

### Adding New Features

1. Modify the `Main.lua` file to add new import logic.
2. Update the `SettingsDialog.lua` file to include additional configuration options if needed.
3. Update the `Info.lua` file to register new menu items.

### Testing

- Use the **Test Connection** button in the settings dialog to verify the server URL and API key.
- Run the plugin in Lightroom to test the import functionality.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

For more information, visit [https://jpfelgueiras.com](https://jpfelgueiras.com).