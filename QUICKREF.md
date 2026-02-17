# Quick Reference Card

**Leader Key:** `<Space>`

## Essential Keymaps

### File Operations
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Focus explorer / reveal current file in explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | List buffers |
| `<leader>fr` | Recent files |
| `<leader>fc` | Find commands |
| `<leader>fk` | Find keymaps (Telescope) |
| `<leader>?` | Show buffer local keymaps (which-key) |

### Quit
| Key | Action |
|-----|--------|
| `<leader>qq` | Quit Neovim (close everything) |
| `<leader>wq` | Save all and quit |

### Window Management
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-Up/Down>` | Resize window height |
| `<C-Left/Right>` | Resize window width |

### Buffer Management (barbar)
| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>w` | Close buffer (tab) |
| `<leader>bd` / `<leader>bq` | Close buffer |
| `<leader>br` | Restore closed buffer |
| `<leader>bb` | Pick buffer (fuzzy) |
| `<leader>b1` … `<leader>b9` | Goto buffer 1–9 |
| `<leader>bmn` | Move buffer right |
| `<leader>bmp` | Move buffer left |
| `<S-h>` | Previous buffer (legacy) |
| `<S-l>` | Next buffer (legacy) |

**Buffer tabs (barbar):** Tabline shows open buffers; click or use barbar’s defaults Use the keymaps above or click tabs.

### Editing
| Key | Action |
|-----|--------|
| `<` (visual) | Indent left (keeps selection) |
| `>` (visual) | Indent right (keeps selection) |
| `J` (visual) | Move selected text down |
| `K` (visual) | Move selected text up |
| `p` (visual) | Paste without yanking |
| `<Esc>` | Clear search highlight |

### Code Formatting
| Key | Action |
|-----|--------|
| `<leader>cf` | Format file or selection |

### Git (Fugit2)
| Key | Action |
|-----|--------|
| `<leader>F` | Open Fugit2 |
| `<leader>gd` | Git diff |
| `<leader>gg` | Git graph |

**Note:** macOS users need `brew install libgit2` first.

### LSP (when available)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Show references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>d` | Show diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### AI (Claude Code)
| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude |
| `<leader>af` | Focus Claude |
| `<leader>ab` | Add current buffer |
| `<leader>ar` | Resume Claude |
| `<leader>aa` | Accept diff |
| `<leader>ad` | Deny diff |

## Quick Actions

### File Navigation Workflow
1. `<leader>ff` - Find files by name
2. `<leader>fg` - Search in file contents
3. `<leader>fr` - Recently opened files
4. `<leader>e` - Toggle file tree for browsing

### Window Workflow
1. `:vsplit` or `:split` - Create new split
2. `<C-h/j/k/l>` - Navigate between splits
3. `<C-arrows>` - Resize splits
4. `:close` - Close current split

### Editing Workflow
1. Select text in visual mode (`v` or `V`)
2. `>` or `<` to indent (stays in visual mode)
3. `J` or `K` to move lines
4. `<leader>cf` to format

### Code Navigation (with LSP)
1. `gd` - Jump to definition
2. `<C-o>` - Jump back (vim default)
3. `gr` - See all references
4. `K` - See documentation

## Commands

### Which-key (Keybinding Hints)
- `<leader>?` - Show buffer local keymaps
- Start typing a key sequence and wait - which-key shows available completions

### Plugin Management
- `:Lazy` - Open lazy.nvim UI
- `:Lazy sync` - Update all plugins
- `:Lazy clean` - Remove unused plugins

### Formatting
- `:Format` - Format current buffer (if conform is configured)

### LSP
- `:LspInfo` - Show LSP status
- `:LspRestart` - Restart LSP servers

### Telescope
- `:Telescope` - List all pickers
- `:Telescope keymaps` - Browse all keymaps (fuzzy search)
- `:Telescope commands` - Browse all commands

## Tips

### Discover Keymaps

**Which-key (Recommended):**
Press `<leader>` and wait - which-key will show all available keymaps starting with leader.
Or press `<leader>?` to show buffer-local keymaps.

**Telescope (Fuzzy Search):**
```vim
:Telescope keymaps
```
Shows all available keymaps with fuzzy search.

### Check Keymap Conflicts
```vim
:verbose map <leader>x
```
Shows if a key is mapped and where it was set.

### Reload Config
```vim
:source ~/.config/nvim/init.lua
```
Reload config without restarting Neovim (some plugins may require restart).

### Format on Save (optional)
Add to `init.lua` after the conform setup:
```lua
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
```

## File Locations

- Main config: `~/.config/nvim/init.lua`
- Keymaps: `~/.config/nvim/lua/keymaps.lua`
- Plugin data: `~/.local/share/nvim/`
- Lazy.nvim: `~/.local/share/nvim/lazy/`

## Getting Help

- `:help` - Neovim help system
- `:help keymaps` - Help on keymaps
- `:Telescope help_tags` - Search help with telescope
- Check [KEYMAPS.md](KEYMAPS.md) for keymap customization
- Check [EXAMPLES.md](EXAMPLES.md) for plugin integration examples
