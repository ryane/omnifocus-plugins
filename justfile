# OmniFocus Plugins - Development Tasks

# OmniFocus plugins directory
plugins_dir := env_var('HOME') + "/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application Support/Plug-Ins"

# List all available plugins
list:
    @echo "Available plugins:"
    @find . -maxdepth 2 -name "*.js" -not -name "test-*" | sed 's|^\./||' | sed 's|/.*||' | sort -u

# Install a specific plugin (usage: just install obsidian-note)
install plugin:
    #!/bin/bash
    set -euo pipefail

    # Find the plugin file (.js in repo)
    PLUGIN_FILE=$(find {{plugin}} -name "*.js" -not -name "test-*" | head -n 1)

    if [ -z "$PLUGIN_FILE" ]; then
        echo "Error: No plugin file found in {{plugin}}/"
        exit 1
    fi

    # Create plugins directory if it doesn't exist
    mkdir -p "{{plugins_dir}}"

    # Get basename and change extension from .js to .omnifocusjs
    BASENAME=$(basename "$PLUGIN_FILE" .js)
    DEST_FILE="{{plugins_dir}}/${BASENAME}.omnifocusjs"

    # Copy plugin with renamed extension
    echo "Installing $PLUGIN_FILE → ${BASENAME}.omnifocusjs..."
    cp "$PLUGIN_FILE" "$DEST_FILE"

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

    # Find all plugin files (excluding test files, .js in repo)
    PLUGIN_FILES=$(find . -maxdepth 2 -name "*.js" -not -name "test-*")

    if [ -z "$PLUGIN_FILES" ]; then
        echo "No plugin files found"
        exit 1
    fi

    # Create plugins directory if it doesn't exist
    mkdir -p "{{plugins_dir}}"

    # Install each plugin
    COUNT=0
    for PLUGIN_FILE in $PLUGIN_FILES; do
        BASENAME=$(basename "$PLUGIN_FILE" .js)
        DEST_FILE="{{plugins_dir}}/${BASENAME}.omnifocusjs"
        echo "  → Installing ${BASENAME}.js → ${BASENAME}.omnifocusjs"
        cp "$PLUGIN_FILE" "$DEST_FILE"
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
