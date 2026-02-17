# Configuration Architecture

## File Structure

```
nvim-config/
│
├── init.lua                 # Entry point - loads everything
│   ├── Bootstrap lazy.nvim
│   ├── Set leader keys
│   ├── Plugin specifications
│   ├── Load keymaps module ← require("keymaps").setup()
│   └── Editor options
│
├── lua/
│   └── keymaps.lua          # Keymap management module
│       ├── Helper functions
│       ├── setup_general()    - Window/buffer navigation, editing
│       ├── setup_explorer()   - File tree
│       ├── setup_telescope()  - Fuzzy finding
│       ├── setup_formatting() - Code formatting
│       ├── setup_lsp()        - LSP keybindings (per-buffer)
│       ├── setup_git()        - Git operations (placeholder)
│       ├── setup_debug()      - Debugging (placeholder)
│       └── setup()            - Initializes all categories
│
├── README.md                # Quick start and overview
├── KEYMAPS.md               # Keymap management guide
├── EXAMPLES.md              # Real-world extension examples
└── ARCHITECTURE.md          # This file - system overview
```

## Data Flow

```
Neovim Startup
     ↓
init.lua loads
     ↓
┌─────────────────────────────────────┐
│  1. Bootstrap lazy.nvim             │
│     - Clone if not present          │
│     - Add to runtime path           │
└─────────────────────────────────────┘
     ↓
┌─────────────────────────────────────┐
│  2. Set leader keys                 │
│     - mapleader = " "               │
│     - maplocalleader = "\"          │
└─────────────────────────────────────┘
     ↓
┌─────────────────────────────────────┐
│  3. Load plugins (lazy.nvim)        │
│     - Catppuccin (colorscheme)      │
│     - Snacks (utilities)            │
│     - Telescope (fuzzy finder)      │
│     - Treesitter (syntax)           │
│     - Conform (formatting)          │
│     - Claude Code (AI)              │
│     └─ Each plugin can have:        │
│        • opts (configuration)       │
│        • config (setup function)    │
│        • keys (plugin keymaps)      │
└─────────────────────────────────────┘
     ↓
┌─────────────────────────────────────┐
│  4. Load keymaps module             │
│     require("keymaps").setup()      │
│       ↓                              │
│     Calls all setup_*() functions:  │
│       • setup_general()             │
│       • setup_explorer()            │
│       • setup_telescope()           │
│       • setup_formatting()          │
│       • setup_git()                 │
│       • setup_debug()               │
└─────────────────────────────────────┘
     ↓
┌─────────────────────────────────────┐
│  5. Set editor options              │
│     - expandtab, tabstop, etc.      │
└─────────────────────────────────────┘
     ↓
Ready to use!
```

## Keymap System Architecture

```
lua/keymaps.lua (Module M)
│
├── map(mode, lhs, rhs, opts)           [Helper Function]
│   └── Wrapper around vim.keymap.set with defaults
│
├── M.setup_general()                   [Category]
│   ├── Window navigation (Ctrl+hjkl)
│   ├── Window resizing (Ctrl+Arrows)
│   ├── Buffer navigation (Shift+hl)
│   ├── Visual mode helpers (<, >, J, K)
│   └── Utility (Esc, paste)
│
├── M.setup_explorer()                  [Category]
│   └── <leader>e - Toggle file explorer
│
├── M.setup_telescope()                 [Category]
│   ├── <leader>fc - Find commands
│   ├── <leader>fk - Find keymaps
│   └── <leader>fr - Recent files
│
├── M.setup_formatting()                [Category]
│   └── <leader>cf - Format file/range
│
├── M.setup_lsp(bufnr)                  [Category - Buffer Local]
│   ├── gd, gD, gr, gi - Navigation
│   ├── K - Hover documentation
│   ├── <leader>rn - Rename
│   ├── <leader>ca - Code action
│   └── [d, ]d - Diagnostics
│
├── M.setup_git()                       [Category - Placeholder]
│   └── Ready for git plugin integration
│
├── M.setup_debug()                     [Category - Placeholder]
│   └── Ready for DAP integration
│
└── M.setup()                           [Main Entry Point]
    └── Calls all setup_*() functions
```

## Plugin vs Module Keymaps

This config uses a **hybrid approach** for optimal organization and performance:

### Plugin-Level Keymaps (in init.lua)

**Core plugin keymaps** are defined in `init.lua` using the `keys` spec:

```lua
{
    "nvim-telescope/telescope.nvim",
    keys = {
        { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live grep" },
    },
}
```

**Current examples in this config:**
- Telescope: `<leader>ff`, `fg`, `fb`, `fh` (lines 75-80 in init.lua)
- Fugit2: `<leader>F` (line 144 in init.lua)
- Claude Code: `<leader>a*` (lines 153-170 in init.lua)

**Advantages:**
- ✅ Lazy-loaded with the plugin (better startup time)
- ✅ Self-contained in plugin spec (config + keymaps together)
- ✅ Keypress triggers plugin loading
- ✅ lazy.nvim best practice

**Use when:**
- Primary/core commands for a plugin
- Want plugin to load on keypress
- Command only works with that plugin

### Module Keymaps (in lua/keymaps.lua)

**Additional keymaps** and general editor keymaps go in the module:

```lua
function M.setup_telescope()
    -- Core keymaps in init.lua, additional ones here:
    map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>", { desc = "Find commands" })
    map("n", "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>", { desc = "Find keymaps" })
end
```

**Current examples:**
- General editing: Window navigation, buffer management, indenting
- Explorer: `<leader>e` (Snacks explorer)
- Telescope extras: `<leader>fc`, `fk`, `fr`
- Formatting: `<leader>cf`
- Git extras: `<leader>gd`, `gg`
- Keymap viewer: `<leader>fK`, `fn`, `fl`

**Advantages:**
- ✅ Centralized view of all keymaps by category
- ✅ Easy to find conflicts
- ✅ Better for editor-level keymaps
- ✅ Good for cross-plugin workflows

**Use when:**
- General editor navigation/editing
- Secondary commands for plugins
- Custom functions
- Editor-level operations

### Finding Keymaps

**To see all keymaps** (both plugin and module):
```vim
:Keymaps              " Pretty viewer (shows all)
<leader>fK            " Same as above
:Telescope keymaps    " Fuzzy search all keymaps
```

**To find plugin keymaps:**
1. Check `init.lua` under the plugin's `keys` spec
2. Check `lua/keymaps.lua` under the relevant `setup_*()` function
3. Use `:Keymaps` and search for the plugin name

## Extension Patterns

### Pattern 1: Add Single Keymap

```lua
-- In lua/keymaps.lua, add to existing setup_*() function
function M.setup_telescope()
    -- existing keymaps...
    map("n", "<leader>fx", "<cmd>NewCommand<cr>", { desc = "New feature" })
end
```

### Pattern 2: Add New Category

```lua
-- In lua/keymaps.lua

-- 1. Create new setup function
function M.setup_mycategory()
    map("n", "<leader>m1", "<cmd>Command1<cr>", { desc = "Action 1" })
    map("n", "<leader>m2", "<cmd>Command2<cr>", { desc = "Action 2" })
end

-- 2. Add to main setup
function M.setup()
    M.setup_general()
    M.setup_explorer()
    M.setup_telescope()
    M.setup_formatting()
    M.setup_mycategory()  -- Add here
    M.setup_git()
    M.setup_debug()
end
```

### Pattern 3: Buffer-Local Keymaps (LSP)

```lua
-- In init.lua plugin config
config = function()
    local keymaps = require("keymaps")
    
    lspconfig.server.setup({
        on_attach = function(client, bufnr)
            keymaps.setup_lsp(bufnr)  -- Applies buffer-local keymaps
        end,
    })
end
```

## Benefits of This Architecture

### 1. **Scalability**
- Easy to add new categories without cluttering init.lua
- Each category can grow independently
- Clear separation of concerns

### 2. **Maintainability**
- All keymaps in one place (except plugin-specific ones)
- Easy to find and modify keymaps
- Self-documenting with category functions

### 3. **Extensibility**
- Add new categories without modifying existing ones
- Placeholder functions ready for future plugins
- Consistent patterns for all keymaps

### 4. **Discoverability**
- All keymaps have descriptions
- Can use `:Telescope keymaps` to browse
- Organized by function, not scattered

### 5. **No Conflicts**
- See all keymaps in one file
- Easy to check for duplicates
- Consistent naming conventions

## Migration Guide

To add a new plugin with keymaps:

1. **Add plugin to init.lua**
   ```lua
   { "author/plugin.nvim", opts = {} }
   ```

2. **Create/update category in lua/keymaps.lua**
   ```lua
   function M.setup_pluginname()
       map("n", "<leader>p", "<cmd>PluginCommand<cr>", { desc = "Description" })
   end
   ```

3. **Add to M.setup()**
   ```lua
   M.setup_pluginname()
   ```

4. **Test**
   - Restart Neovim
   - Use `:Telescope keymaps` to verify
   - Test the keymap

## Debugging

### Check if keymap is set:
```vim
:verbose map <leader>e
```

### List all custom keymaps:
```vim
:Telescope keymaps
```

### Check keymap module loading:
```vim
:lua print(vim.inspect(require("keymaps")))
```

### Reload keymaps (during development):
```vim
:lua package.loaded.keymaps = nil
:lua require("keymaps").setup()
```
