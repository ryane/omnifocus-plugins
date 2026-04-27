# OmniFocus Obsidian Integration

An OmniFocus plugin that creates and opens Obsidian notes for tasks and projects, with intelligent duplicate prevention and bi-directional linking.

## Features

- **Smart Note Creation**: Creates clean, readable Obsidian notes from OmniFocus tasks/projects
- **Duplicate Prevention**: Searches by ID to avoid creating duplicate notes, even if you rename the file
- **Bi-directional Links**: Adds clickable links in OmniFocus notes that open the corresponding Obsidian note
- **Rename-Safe Links**: Links use ID-based URIs, so they work even after renaming notes
- **Automatic Tab Management**: Opens notes in new tabs (or focuses existing tab if already open)
- **Rich Frontmatter**: Includes `id`, `created` date, OmniFocus `action` link, `project` wiki-link, and optional `tags`
- **Project Integration**: Automatically links to project notes using Obsidian wiki-links
- **Note Content Preservation**: Includes OmniFocus note content as initial body of Obsidian note

## Requirements

### OmniFocus
- OmniFocus 4 (macOS)

### Obsidian Plugins
1. **[Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api)**
   - Install and enable in Obsidian
   - Enable **HTTP mode** (non-secure) on port **27123**
   - Copy your API key (found in Settings > Local REST API)

2. **[Advanced URI](https://github.com/Vinzent03/obsidian-advanced-uri)**
   - Install and enable in Obsidian
   - Set "UID field name" to `id` in plugin settings

### Important Note on Templater

If you use the **Templater** plugin, you must **disable it** for the folder where OmniFocus notes are stored. Otherwise, Templater may overwrite the frontmatter created by this plugin.

## Installation

### Quick Install

From the repository root, run:
```bash
just install obsidian-note
```

This will copy the plugin to your OmniFocus plugins directory. Restart OmniFocus or refresh plugins (Automation > Configure Plugins).

### Manual Install

Copy the plugin to your OmniFocus plugins directory (rename from `.js` to `.omnifocusjs`):
```bash
cp obsidian-note.js ~/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application\ Support/Plug-Ins/obsidian-note.omnifocusjs
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
project: "[[My Project Name]]"
project_link: omnifocus:///project/abc123xyz
tags: ["work", "important"]
---
Your original OmniFocus note content appears here
```

**Note:** The `project` and `project_link` fields are only included if the task belongs to a project (inbox tasks won't have these fields).

## How It Works

1. **ID-based Search**: Uses the Obsidian Local REST API to search for notes by frontmatter `id` field
2. **JsonLogic Query**: Sends `{"==": [{"var": "frontmatter.id"}, "<task-id>"]}` to the REST API's `/search/` endpoint to find existing notes
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
- Check that frontmatter `id` field exists in your notes

### Malformed Frontmatter
- Disable Templater plugin for your OmniFocus notes folder

### Links Break After Renaming
- Verify Advanced URI plugin is installed
- Check that "UID field name" is set to `id` in Advanced URI settings

## Development

### Workflow

1. **Edit** the plugin in this directory
2. **Install** from repo root: `just install obsidian-note`
3. **Reload** plugins in OmniFocus (Automation > Configure Plugins, or restart)
4. **Test** your changes

Note: OmniFocus does not support symlinks in the plugins directory, so changes must be copied via the justfile tasks.

### Debugging

- Use `console.log()` statements in the code
- View output in OmniFocus's plugin console (Automation > Configure Plugins > [Plugin Name] > Console)

## Version History

### 6.3 (2026-04-27)
- Switched search from Dataview DQL to Local REST API JsonLogic
- Removed Dataview as a required Obsidian plugin dependency
- Added HTTP status checks on search and create requests so REST API failures surface as alerts instead of silently focusing Obsidian with no note

### 6.1 (2026-01-03)
- Added project integration with Obsidian wiki-links
- Includes `project: "[[Project Name]]"` and `project_link` in frontmatter
- Enables bi-directional linking between task and project notes

### 6.0 (2026-01-02)
- Initial release with REST API integration
- ID-based search using Dataview
- Rename-safe links using Advanced URI
- Automatic tab management

## Credits

This plugin is based on the [OmniFocus Obsidian Plugin](https://omni-automation.com/omnifocus/plug-in-obsidian.html) from omni-automation.com, enhanced with:
- ID-based search using Obsidian Local REST API
- Duplicate note prevention
- Rename-safe links via Advanced URI
- Automatic tab management

## License

MIT

## Author

Ryan Eschinger
