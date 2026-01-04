# Claude Development Context

This document provides context for AI assistants working on this codebase.

## Project Overview

This repository contains OmniFocus automation plugins written in JavaScript using the Omni Automation API. These plugins extend OmniFocus 4 with custom automation capabilities.

## Repository Structure

```
omnifocus-plugins/
├── obsidian-note/              # Plugin: Create/open Obsidian notes for OmniFocus tasks
│   ├── obsidian-note.js        # Plugin source (stored as .js for editor support)
│   └── README.md
├── justfile                    # Task runner for plugin installation
├── flake.nix                   # Nix development environment
├── .envrc                      # direnv configuration
├── README.md                   # Repository overview
└── CLAUDE.md                   # This file
```

## Plugin Structure

Each plugin is a directory containing:
- `<name>.js` - The plugin script (JavaScript with JSON metadata header)
- `README.md` - Plugin-specific documentation

**Important:** Plugins are stored as `.js` files in the repository for proper editor integration (syntax highlighting, LSP, etc.), but OmniFocus requires the `.omnifocusjs` extension. The justfile automatically renames files during installation.

### Plugin File Format

```javascript
/*{
  "type": "action",
  "targets": ["omnifocus"],
  "author": "Ryan Eschinger",
  "identifier": "com.omni-automation.<plugin-name>",
  "version": "X.Y",
  "description": "...",
  "label": "Display Name",
  "shortLabel": "Short Name",
  "paletteLabel": "Palette Name",
  "image": "sf.symbol.name"
}*/
(() => {
  // Plugin code here
  const action = new PlugIn.Action(async function(selection, sender){
    // Implementation
  });

  action.validate = function(selection, sender){
    // Return true if plugin can run
    return true;
  };

  return action;
})();
```

## Development Environment

### Nix Flake

The repository uses a Nix flake for reproducible development environments.

**Tools provided:**
- `just` - Task runner

**Activation:**
```bash
# With direnv (automatic)
direnv allow

# Manual
nix develop
```

### Just Tasks

- `just list` - Show all available plugins
- `just install <plugin>` - Install a specific plugin (e.g., `just install obsidian-note`)
- `just install-all` - Install all plugins
- `just show-dir` - Show OmniFocus plugins directory path
- `just open-dir` - Open OmniFocus plugins directory in Finder

## Development Workflow

1. **Edit** plugin code in its directory
2. **Install** using `just install <plugin-name>`
3. **Reload** plugins in OmniFocus:
   - Go to Automation > Configure Plugins
   - Click refresh button
   - Or restart OmniFocus
4. **Test** the plugin
5. **Debug** using `console.log()` (view in plugin console)

## Important Technical Details

### OmniFocus Plugin Directory

Plugins must be installed to:
```
~/Library/Containers/com.omnigroup.OmniFocus4/Data/Library/Application Support/Plug-Ins/
```

**Critical:** OmniFocus **does NOT support symlinks**. Plugins must be actual files. This is why we use the justfile to copy files instead of symlinking.

### OmniFocus Automation API

**Key APIs:**
- `PlugIn.Action` - Define plugin actions
- `Preferences` - Store plugin preferences
- `Form` - Create configuration dialogs
- `Alert` - Show alerts
- `URL.FetchRequest` - Make HTTP requests (returns Promises!)
- `Text` and `Style` - Manipulate styled text in notes

**Important:** `URL.FetchRequest.fetch()` returns a **Promise**, not callbacks!

```javascript
// CORRECT - Promise-based API
const response = await request.fetch()
console.log(response.statusCode)
console.log(response.bodyString)

// WRONG - This is the old URL.fetch() API, not URL.FetchRequest
request.fetch(successCallback, errorCallback)  // This never triggers callbacks!
```

### App Transport Security (ATS)

- OmniFocus enforces macOS App Transport Security
- HTTPS with valid certificates works fine
- HTTP localhost works (e.g., `http://127.0.0.1:27123`)
- HTTPS with self-signed certificates fails with certificate validation errors
- No apparent way to disable certificate verification in OmniFocus

### OmniFocus v4 Text API

Use `item.noteText` (styled text) instead of older v3 APIs:

```javascript
// Get note content
const noteContent = item.noteText.string

// Add styled link
const linkObj = new Text("Link Text", item.noteText.style)
const style = linkObj.styleForRange(linkObj.range)
style.set(Style.Attribute.Link, URL.fromString("https://..."))
item.noteText.insert(item.noteText.start, linkObj)
```

## Plugin-Specific Notes

### obsidian-note

Creates/opens Obsidian notes for OmniFocus tasks with ID-based search.

**Original Source:** Based on the [OmniFocus Obsidian Plugin](https://omni-automation.com/omnifocus/plug-in-obsidian.html) from omni-automation.com, enhanced with REST API integration, duplicate prevention, and rename-safe linking.

**Dependencies:**
- Obsidian Local REST API plugin (HTTP mode on port 27123)
- Obsidian Dataview plugin (for ID-based search)
- Obsidian Advanced URI plugin (for UID-based opening)

**How it works:**
1. Uses Local REST API to search for existing notes by frontmatter `id` field
2. Dataview query: `TABLE file.path FROM "" WHERE id = "<task-id>"`
3. If found: Opens via Advanced URI (`obsidian://advanced-uri?vault=...&uid=...&newpane=true`)
4. If not found: Creates note via REST API PUT request, then opens it
5. Adds clickable link to OmniFocus note

**Search result format:**
```json
[
  {
    "filename": "path/to/file.md",
    "result": {
      "file.path": "path/to/file.md"
    }
  }
]
```

Parse as: `resultJSON[0].result["file.path"]`

**Critical settings:**
- Advanced URI "UID field name": Must be set to `id`
- Templater plugin: Must be disabled for OmniFocus notes folder (it overwrites frontmatter)

## Naming Conventions

- **Directory names:** `kebab-case` (e.g., `obsidian-note`)
- **Plugin filenames in repo:** `kebab-case.js` (e.g., `obsidian-note.js`) - stored as `.js` for editor support
- **Plugin filenames when installed:** `kebab-case.omnifocusjs` (e.g., `obsidian-note.omnifocusjs`) - required by OmniFocus
- **Plugin identifiers:** `com.omni-automation.<plugin-name>` (e.g., `com.omni-automation.obsidian-note`)
- **Labels:** Human-readable (e.g., "Obsidian Note")

## Version Control

This repository uses **Jujutsu (jj)** for version control, not Git. Let the user handle all SCM commands.

## Testing

- Manual testing only (no automated test framework)
- Use `console.log()` for debugging
- View output in OmniFocus > Automation > Configure Plugins > [Plugin Name] > Console
- Test with actual OmniFocus tasks/projects
- Verify plugin preferences persist across runs

## Common Pitfalls

1. **Symlinks don't work** - Always use `just install` to copy files
2. **URL.FetchRequest API confusion** - Use `await request.fetch()`, not callbacks
3. **Identifier changes require uninstall** - Old plugins with different identifiers persist
4. **Preferences are per-identifier** - Changing identifier loses user settings
5. **Frontmatter syntax matters** - Invalid YAML breaks Obsidian parsing
6. **Templater interference** - Disable it for OmniFocus notes folders

## Useful Resources

- [OmniFocus Automation Documentation](https://omni-automation.com/omnifocus/)
- [Omni Automation API Reference](https://omni-automation.com/shared/)
- [URL.FetchRequest API Docs](https://omni-automation.com/shared/url-fetch-api.html)
- [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api)
- [Obsidian Dataview](https://blacksmithgu.github.io/obsidian-dataview/)
- [Obsidian Advanced URI](https://github.com/Vinzent03/obsidian-advanced-uri)

## Adding New Plugins

1. Create new directory: `<plugin-name>/`
2. Create plugin file: `<plugin-name>/<plugin-name>.js` (stored as `.js` for editor support)
3. Create README: `<plugin-name>/README.md`
4. Update main `README.md` with plugin entry
5. Test with `just install <plugin-name>` (automatically renames to `.omnifocusjs`)
6. Document in plugin's README:
   - Features
   - Requirements/dependencies
   - Configuration steps
   - Usage instructions
   - Troubleshooting

## Code Style

- Use tabs for indentation (matches OmniFocus examples)
- Use `async/await` for asynchronous operations
- Prefer `const` over `var` where appropriate
- Use template strings for string interpolation
- Add clear `console.log()` statements for debugging
- Handle errors with try/catch blocks
- Show user-friendly error messages via `Alert`
