# OmniFocus Plugins - Development Tasks

# OmniFocus plugins directory
plugins_dir := env_var('HOME') + "/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application Support/Plug-Ins"

# List all available plugins
list:
    @echo "Available plugins:"
    @find . -maxdepth 2 -name "*.omnifocusjs" -not -name "test-*" | sed 's|^\./||' | sed 's|/.*||' | sort -u

# Install a specific plugin (usage: just install obsidian-integration)
install plugin:
    #!/bin/bash
    set -euo pipefail

    # Find the plugin file
    PLUGIN_FILE=$(find {{plugin}} -name "*.omnifocusjs" -not -name "test-*" | head -n 1)

    if [ -z "$PLUGIN_FILE" ]; then
        echo "Error: No plugin file found in {{plugin}}/"
        exit 1
    fi

    # Create plugins directory if it doesn't exist
    mkdir -p "{{plugins_dir}}"

    # Copy plugin
    echo "Installing $PLUGIN_FILE..."
    cp "$PLUGIN_FILE" "{{plugins_dir}}/"

    echo "✓ Plugin installed successfully"
    echo ""
    echo "To reload in OmniFocus:"
    echo "  • Automation > Configure Plugins... > Refresh"
    echo "  • Or restart OmniFocus"

# Install all plugins
install-all:
    #!/bin/bash
    set -euo pipefail

    echo "Installing all plugins..."
    echo ""

    # Find all plugin files (excluding test files)
    PLUGIN_FILES=$(find . -maxdepth 2 -name "*.omnifocusjs" -not -name "test-*")

    if [ -z "$PLUGIN_FILES" ]; then
        echo "No plugin files found"
        exit 1
    fi

    # Create plugins directory if it doesn't exist
    mkdir -p "{{plugins_dir}}"

    # Install each plugin
    COUNT=0
    for PLUGIN_FILE in $PLUGIN_FILES; do
        BASENAME=$(basename "$PLUGIN_FILE")
        echo "  → Installing $BASENAME"
        cp "$PLUGIN_FILE" "{{plugins_dir}}/"
        COUNT=$((COUNT + 1))
    done

    echo ""
    echo "✓ Installed $COUNT plugin(s)"
    echo ""
    echo "To reload in OmniFocus:"
    echo "  • Automation > Configure Plugins... > Refresh"
    echo "  • Or restart OmniFocus"

# Show OmniFocus plugins directory
show-dir:
    @echo "{{plugins_dir}}"

# Open OmniFocus plugins directory in Finder
open-dir:
    open "{{plugins_dir}}"
