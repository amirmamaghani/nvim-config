# Keymap Management Guide

This config uses a modular keymap system that makes it easy to add, modify, and organize keybindings.

## File Structure

All keymaps are defined in `lua/keymaps.lua` and organized by category.

## Adding New Keymaps

### 1. Add to Existing Category

To add a keymap to an existing category, edit `lua/keymaps.lua`:

```lua
-- In the appropriate setup_* function
function M.setup_telescope()
    -- Existing keymaps...
    
    -- Add your new keymap
    map("n", "<leader>fn", "<cmd>lua require('telescope.builtin').find_notes()<cr>", { desc = "Find notes" })
end
```

### 2. Create a New Category

To add a completely new category:

```lua
-- Add a new setup function
function M.setup_notes()
    map("n", "<leader>nn", ":NewNote<CR>", { desc = "Create new note" })
    map("n", "<leader>nf", ":FindNotes<CR>", { desc = "Find notes" })
    map("n", "<leader>nt", ":NoteTags<CR>", { desc = "Note tags" })
end

-- Add it to the main setup function
function M.setup()
    M.setup_general()
    M.setup_explorer()
    M.setup_telescope()
    M.setup_formatting()
    M.setup_notes()  -- Add your new category here
    M.setup_git()
    M.setup_debug()
end
```

### 3. Plugin-Specific Keymaps

**Important:** This config uses a hybrid approach - some keymaps are in `init.lua`, some in `lua/keymaps.lua`.

**For primary plugin commands**, use the `keys` option in the plugin spec in `init.lua`:

```lua
{
    "your/plugin.nvim",
    keys = {
        { "<leader>p", "<cmd>PluginCommand<cr>", desc = "Plugin action" },
    },
}
```

**Benefits:** Lazy-loads the plugin when you press the key, better startup time.

**Examples in this config:**
- Telescope core commands: `<leader>ff`, `fg`, `fb`, `fh` → in `init.lua`
- Fugit2: `<leader>F` → in `init.lua`
- Claude Code: `<leader>a*` → in `init.lua`

**For secondary/additional commands**, add to `lua/keymaps.lua`:

```lua
function M.setup_telescope()
    -- Core commands in init.lua, extras here
    map("n", "<leader>fc", "<cmd>telescope.builtin.commands()<cr>", { desc = "Find commands" })
end
```

**Examples in this config:**
- Telescope extras: `<leader>fc`, `fk`, `fr` → in `lua/keymaps.lua`
- Git extras: `<leader>gd`, `gg` → in `lua/keymaps.lua`

## Keymap Function Reference

The `map()` helper function signature:

```lua
map(mode, lhs, rhs, opts)
```

- **mode**: String or table of modes (`"n"`, `"v"`, `"i"`, `{"n", "v"}`)
- **lhs**: Left-hand side (the key combination)
- **rhs**: Right-hand side (the command or function)
- **opts**: Table of options:
  - `desc`: Description (shown in which-key)
  - `buffer`: Buffer number (for buffer-local keymaps)
  - `silent`: Suppress command output (default: true)
  - `noremap`: Non-recursive mapping (default: true via vim.keymap.set)

## Examples

### Simple command mapping
```lua
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
```

### Function mapping
```lua
map("n", "<leader>t", function()
    print("Hello from keymap!")
end, { desc = "Test function" })
```

### Multiple modes
```lua
map({"n", "v"}, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
```

### Buffer-local (LSP example)
```lua
function M.setup_lsp(bufnr)
    local opts = { buffer = bufnr }
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
end
```

## Recommended Keymap Prefixes

Organize your keymaps with consistent prefixes:

- `<leader>f` - **Find** (Telescope, file navigation)
- `<leader>c` - **Code** (formatting, actions, LSP)
- `<leader>g` - **Git** (git operations)
- `<leader>d` - **Debug** (debugging operations)
- `<leader>b` - **Buffer** (buffer operations)
- `<leader>t` - **Terminal** (terminal operations)
- `<leader>n` - **Notes** (note-taking)
- `<leader>a` - **AI** (AI/Claude operations)
- `<leader>e` - **Explorer** (file tree)

## LSP Keymaps

LSP keymaps are set automatically when an LSP attaches to a buffer. To customize, edit the `M.setup_lsp(bufnr)` function in `lua/keymaps.lua`.

## Best Practices

1. **Always add descriptions**: Makes keymaps discoverable with which-key
2. **Group by functionality**: Keep related keymaps together
3. **Use consistent prefixes**: Easier to remember and discover
4. **Document custom keymaps**: Add comments for complex bindings
5. **Avoid conflicts**: Check existing keymaps before adding new ones
6. **Use leader key**: For custom commands, prefer `<leader>` prefix

## Viewing Keymaps

### Which-key (Recommended)

The config includes [which-key.nvim](https://github.com/folke/which-key.nvim) for discovering keymaps:

- Press `<leader>` and wait - which-key shows all available keymaps starting with leader
- Press `<leader>?` to show buffer-local keymaps
- Works with any key prefix - just start typing and wait

**Features:**
- Shows keymaps as you type
- Groups related keymaps together
- Shows descriptions for each keymap
- No configuration needed

### Telescope (Fuzzy Search)

For fuzzy searching keymaps:
```vim
:Telescope keymaps
```

Or with keymap:
- `<leader>fk` - Find keymaps (Telescope)

### Neovim Built-in

To see all current keymaps:
```vim
:map     " Show all mappings
:nmap    " Show normal mode mappings
:vmap    " Show visual mode mappings
```

To check if a key is already mapped:
```vim
:verbose map <leader>x
```
