# OmniFocus Plugins

A collection of OmniFocus automation plugins using Omni Automation (JavaScript).

## Plugins

### [Obsidian Integration](./obsidian-integration/)

Creates and opens Obsidian notes for OmniFocus tasks/projects with intelligent duplicate prevention and bi-directional linking.

**Features:**
- ID-based note search (works even after renaming)
- Automatic frontmatter with `id`, `created`, `action`, and `tags`
- Rename-safe links using Advanced URI
- Opens notes in new tabs automatically
- Preserves OmniFocus note content as body

**Requirements:**
- OmniFocus 4
- Obsidian with Local REST API, Dataview, and Advanced URI plugins

[View documentation →](./obsidian-integration/README.md)

## Installation

Each plugin directory contains:
- `.omnifocusjs` file - The plugin script
- `README.md` - Plugin-specific documentation

To install a plugin:

1. Navigate to the plugin directory
2. Copy the `.omnifocusjs` file to your OmniFocus plugins directory:
   ```bash
   ~/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application Support/Plug-Ins/
   ```
3. The plugin will appear in OmniFocus's Automation menu

## Resources

- [OmniFocus Automation Documentation](https://omni-automation.com/omnifocus/)
- [Omni Automation API Reference](https://omni-automation.com/shared/)
- [OmniFocus Plugin Gallery](https://omni-automation.com/omnifocus/plugins.html)

## License

MIT

## Author

Ryan Eschinger
