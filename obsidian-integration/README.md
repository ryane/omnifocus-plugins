# OmniFocus Obsidian Integration

An OmniFocus plugin that creates and opens Obsidian notes for tasks and projects, with intelligent duplicate prevention and bi-directional linking.

## Features

- **Smart Note Creation**: Creates clean, readable Obsidian notes from OmniFocus tasks/projects
- **Duplicate Prevention**: Searches by ID to avoid creating duplicate notes, even if you rename the file
- **Bi-directional Links**: Adds clickable links in OmniFocus notes that open the corresponding Obsidian note
- **Rename-Safe Links**: Links use ID-based URIs, so they work even after renaming notes
- **Automatic Tab Management**: Opens notes in new tabs (or focuses existing tab if already open)
- **Rich Frontmatter**: Includes `id`, `created` date, OmniFocus `action` link, and optional `tags`
- **Note Content Preservation**: Includes OmniFocus note content as initial body of Obsidian note

## Requirements

### OmniFocus
- OmniFocus 4 (macOS)

### Obsidian Plugins
1. **[Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api)**
   - Install and enable in Obsidian
   - Enable **HTTP mode** (non-secure) on port **27123**
   - Copy your API key (found in Settings > Local REST API)

2. **[Dataview](https://github.com/blacksmithgu/obsidian-dataview)**
   - Install and enable in Obsidian
   - Required for ID-based search functionality

3. **[Advanced URI](https://github.com/Vinzent03/obsidian-advanced-uri)**
   - Install and enable in Obsidian
   - Set "UID field name" to `id` in plugin settings

### Important Note on Templater

If you use the **Templater** plugin, you must **disable it** for the folder where OmniFocus notes are stored. Otherwise, Templater may overwrite the frontmatter created by this plugin.

## Installation

### Quick Install

From the repository root, run:
```bash
just install obsidian-integration
```

This will copy the plugin to your OmniFocus plugins directory. Restart OmniFocus or refresh plugins (Automation > Configure Plugins).

### Manual Install

Copy `of-obsidian-open-or-create.omnifocusjs` to your OmniFocus plugins directory:
```bash
cp of-obsidian-open-or-create.omnifocusjs ~/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application\ Support/Plug-Ins/
```

The plugin will appear in OmniFocus's Automation menu after reloading.

## Configuration

1. Select a task or project in OmniFocus
2. Run the plugin while holding the **Control** key
3. Configure the following settings:
   - **Vault name**: Your Obsidian vault name
   - **Local REST API key**: Copy from Obsidian Settings > Local REST API
   - **Local REST API URL**: Default is `http://127.0.0.1:27123`
   - **Folder path**: Where to create notes (leave empty for vault root, or specify like `tasks` or `projects/omnifocus`)
   - **Include OmniFocus tags**: Check to include OmniFocus tags in note frontmatter

## Usage

1. Select a task or project in OmniFocus
2. Run the plugin (via Automation menu, keyboard shortcut, or palette)
3. The plugin will:
   - Search for an existing note with matching ID
   - If found: Open the existing note in a new tab
   - If not found: Create a new note with frontmatter and open it
   - Add a clickable "(Obsidian Link)" to the OmniFocus note

## Note Format

Created notes use this format:

```markdown
---
id: kFe8Z2xKrQp
created: 2026-01-02
action: omnifocus:///task/kFe8Z2xKrQp
tags: ["work", "important"]
---
Your original OmniFocus note content appears here
```

## How It Works

1. **ID-based Search**: Uses the Obsidian Local REST API to search for notes by frontmatter `id` field
2. **Dataview Query**: Executes `TABLE file.path FROM "" WHERE id = "<task-id>"` to find existing notes
3. **Smart Opening**: Uses Advanced URI plugin with `uid` parameter to open notes by ID (not filepath)
4. **Link Persistence**: Links stored in OmniFocus work even after renaming the Obsidian note

## Troubleshooting

### "Undeclared Vault Preference" Error
- Hold Control while running the plugin to configure settings

### Notes Not Opening
- Verify Obsidian Local REST API plugin is running
- Check that HTTP mode is enabled on port 27123
- Verify API key is correct

### Duplicate Notes Created
- Ensure Dataview plugin is installed and enabled
- Check that frontmatter `id` field exists in your notes

### Malformed Frontmatter
- Disable Templater plugin for your OmniFocus notes folder

### Links Break After Renaming
- Verify Advanced URI plugin is installed
- Check that "UID field name" is set to `id` in Advanced URI settings

## Development

### Workflow

1. **Edit** the plugin in this directory
2. **Install** from repo root: `just install obsidian-integration`
3. **Reload** plugins in OmniFocus (Automation > Configure Plugins, or restart)
4. **Test** your changes

Note: OmniFocus does not support symlinks in the plugins directory, so changes must be copied via the justfile tasks.

### Debugging

- Use `console.log()` statements in the code
- View output in OmniFocus's plugin console (Automation > Configure Plugins > [Plugin Name] > Console)

## Version History

### 6.0 (2026-01-02)
- Initial release with REST API integration
- ID-based search using Dataview
- Rename-safe links using Advanced URI
- Automatic tab management

## License

MIT

## Author

Ryan Eschinger
