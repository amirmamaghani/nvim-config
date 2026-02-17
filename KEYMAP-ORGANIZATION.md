# Keymap Organization Strategy

## Where Are My Keymaps?

This config uses a **hybrid approach** - keymaps are split between two locations for optimal organization and performance.

## Quick Reference

| Keymap Type | Location | Example |
|-------------|----------|---------|
| **Core plugin commands** | `init.lua` (plugin `keys` spec) | `<leader>ff` (Telescope find files) |
| **General editor** | `lua/keymaps.lua` | `<C-h>` (move to left window) |
| **Additional plugin commands** | `lua/keymaps.lua` | `<leader>fc` (Telescope find commands) |
| **Custom functions** | `lua/keymaps.lua` | `<leader>cf` (format) |

## Decision Tree

```
Do you want to add a keymap?
│
├─ Is it a PRIMARY command for a plugin?
│  (e.g., main interface, most common operation)
│  │
│  └─ YES → Put in init.lua under plugin's `keys` spec
│     Benefits: Lazy-loading, self-contained
│     Example: <leader>F for Fugit2
│
└─ Is it for general editing or a secondary command?
   │
   └─ YES → Put in lua/keymaps.lua
      Benefits: Centralized, easy to find/modify
      Example: <C-h> for window navigation
```

## Current Keymap Distribution

### In `init.lua` (Plugin Keys Specs)

**Telescope** (lines 75-80):
```lua
keys = {
  { "<leader>ff", ..., desc = "Find files" },
  { "<leader>fg", ..., desc = "Live grep" },
  { "<leader>fb", ..., desc = "Buffers" },
  { "<leader>fh", ..., desc = "Help tags" },
}
```

**Fugit2** (line 144):
```lua
keys = {
  { "<leader>F", ..., desc = "Fugit2" },
}
```

**Claude Code** (lines 153-170):
```lua
keys = {
  { "<leader>a", nil, desc = "AI/Claude Code" },
  { "<leader>ac", ..., desc = "Toggle Claude" },
  { "<leader>af", ..., desc = "Focus Claude" },
  -- ... more AI commands
}
```

### In `lua/keymaps.lua`

**General Editor** (`setup_general`):
- Window navigation: `<C-h/j/k/l>`
- Window resizing: `<C-Up/Down/Left/Right>`
- Buffer navigation: `<S-h/l>`
- Visual mode: `</>`, `J/K`, `p`
- Utilities: `<Esc>`

**Explorer** (`setup_explorer`):
- `<leader>e` - Toggle Snacks explorer

**Telescope Extras** (`setup_telescope`):
- `<leader>fc` - Find commands
- `<leader>fk` - Find keymaps (Telescope)
- `<leader>fr` - Recent files

**Formatting** (`setup_formatting`):
- `<leader>cf` - Format file or range

**Git Extras** (`setup_git`):
- `<leader>gd` - Git diff
- `<leader>gg` - Git graph

**LSP** (`setup_lsp` - buffer-local):
- `gd`, `gD`, `gr`, `gi` - Navigation
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `[d`, `]d` - Diagnostics

## Why This Approach?

### Plugin Keys in init.lua

**Pros:**
- ⚡ **Lazy loading** - Plugin only loads when you press the key
- 🚀 **Faster startup** - Plugins don't load until needed
- 📦 **Self-contained** - Config and keymaps together
- ✅ **Best practice** - Recommended by lazy.nvim

**Cons:**
- 🔍 Keymaps split across two files
- 📝 Need to check init.lua to see all plugin keymaps

**Example:**
```lua
-- Telescope loads when you press <leader>ff
{
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>ff", ..., desc = "Find files" },
  },
}
```

### Module Keymaps in lua/keymaps.lua

**Pros:**
- 📋 **Centralized** - All in one file by category
- 🔍 **Easy to find** - Organized by function
- ⚙️ **Flexible** - Good for general editor keymaps
- 🛠️ **Easy to modify** - All keymaps visible together

**Cons:**
- ⏱️ Loads at startup (but very fast)
- 🔌 Can't trigger lazy-loading

**Example:**
```lua
function M.setup_general()
  map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
end
```

## Best Practices

### ✅ DO

1. **Put primary plugin commands in init.lua**
   ```lua
   keys = {
     { "<leader>F", "<cmd>Fugit2<cr>", desc = "Fugit2" },
   }
   ```

2. **Put additional commands in lua/keymaps.lua**
   ```lua
   function M.setup_git()
     map("n", "<leader>gd", "<cmd>Fugit2Diff<cr>", { desc = "Git diff" })
   end
   ```

3. **Add comments in lua/keymaps.lua pointing to init.lua**
   ```lua
   -- Core fugit2 keymap is in init.lua (lazy-loaded):
   --   <leader>F - Open Fugit2
   ```

### ❌ DON'T

1. **Don't duplicate keymaps** between init.lua and lua/keymaps.lua
2. **Don't put general editor keymaps in init.lua** (they can't lazy-load anyway)
3. **Don't put ALL plugin keymaps in init.lua** (only core ones)

## How to Find Keymaps

### Method 1: Pretty Viewer (Recommended)
```vim
:Keymaps
" or
<leader>fK
```
Shows ALL keymaps from both locations in a nice table.

### Method 2: Check Both Files
1. **Plugin core commands**: Check `init.lua` under plugin's `keys` spec
2. **Everything else**: Check `lua/keymaps.lua` under relevant `setup_*()` function

### Method 3: Telescope
```vim
:Telescope keymaps
" or
<leader>fk
```
Fuzzy search ALL keymaps from both locations.

## Migration Guide

If you want to move a keymap:

### From init.lua → lua/keymaps.lua

1. **Remove from init.lua:**
   ```lua
   keys = {
     -- { "<leader>x", "<cmd>Command<cr>", desc = "Description" },  -- Remove this
   }
   ```

2. **Add to lua/keymaps.lua:**
   ```lua
   function M.setup_category()
     map("n", "<leader>x", "<cmd>Command<cr>", { desc = "Description" })
   end
   ```

### From lua/keymaps.lua → init.lua

1. **Remove from lua/keymaps.lua:**
   ```lua
   function M.setup_category()
     -- map("n", "<leader>x", "<cmd>Command<cr>", { desc = "Description" })  -- Remove this
   end
   ```

2. **Add to init.lua plugin spec:**
   ```lua
   {
     "plugin/name.nvim",
     keys = {
       { "<leader>x", "<cmd>Command<cr>", desc = "Description" },
     },
   }
   ```

## Summary

| Question | Answer |
|----------|--------|
| Where are Telescope keymaps? | Core (`ff`, `fg`, `fb`, `fh`) in init.lua, extras (`fc`, `fk`, `fr`) in lua/keymaps.lua |
| Where are Git keymaps? | Core (`<leader>F`) in init.lua, extras (`gd`, `gg`) in lua/keymaps.lua |
| Where are window navigation keymaps? | All in lua/keymaps.lua (general editor, can't lazy-load) |
| How do I see ALL keymaps? | `:Keymaps` or `<leader>fK` |
| Why split keymaps? | Better lazy-loading (fast startup) + centralized organization |
| Should I add my keymap to init.lua? | Only if it's a PRIMARY command for a plugin you want to lazy-load |

This hybrid approach gives us the best of both worlds: fast startup through lazy-loading, and centralized organization for easy maintenance.
