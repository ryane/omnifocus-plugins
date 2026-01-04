# OmniFocus Plugins

A collection of OmniFocus automation plugins using Omni Automation (JavaScript).

## Plugins

### [Obsidian Note](./obsidian-note/)

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

[View documentation →](./obsidian-note/README.md)

## Installation

### Quick Install

Install a specific plugin:
```bash
just install obsidian-note
```

Install all plugins:
```bash
just install-all
```

List available plugins:
```bash
just list
```

### Manual Install

Each plugin directory contains:
- `.js` file - The plugin script (stored as `.js` for editor support)
- `README.md` - Plugin-specific documentation

To install manually, copy the `.js` file and rename it to `.omnifocusjs`:
```bash
cp <plugin-dir>/<plugin-name>.js ~/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application\ Support/Plug-Ins/<plugin-name>.omnifocusjs
```

The plugin will appear in OmniFocus's Automation menu after reloading.

**Note:** Plugins are stored as `.js` files in the repository for editor integration support, but must be renamed to `.omnifocusjs` when installed to OmniFocus. The `just install` command handles this automatically.

## Development

### Setup

This repository includes a Nix flake for a reproducible development environment.

**With direnv:**
```bash
direnv allow
```

**Without direnv:**
```bash
nix develop
```

This provides:
- `just` - Task runner for common operations

### Available Just Tasks

- `just list` - Show all available plugins
- `just install <plugin>` - Install a specific plugin (e.g., `just install obsidian-note`)
- `just install-all` - Install all plugins in the repo
- `just show-dir` - Show the OmniFocus plugins directory path
- `just open-dir` - Open the OmniFocus plugins directory in Finder

### Workflow

1. Edit plugin code in its directory
2. Run `just install <plugin-name>` to copy to OmniFocus
3. Reload plugins in OmniFocus (Automation > Configure Plugins, or restart)
4. Test your changes

Note: OmniFocus does not support symlinks, so changes must be copied using the justfile tasks.

## Resources

- [OmniFocus Automation Documentation](https://omni-automation.com/omnifocus/)
- [Omni Automation API Reference](https://omni-automation.com/shared/)
- [OmniFocus Plugin Gallery](https://omni-automation.com/omnifocus/plugins.html)

## License

MIT

## Author

Ryan Eschinger
