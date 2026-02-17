# nvim-config

Neovim config managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

**Plugins:** Catppuccin, Snacks, barbar.nvim (buffer tabs), Telescope, nvim-treesitter, conform.nvim, fugit2.nvim (Git), claudecode.nvim (AI), which-key.nvim.

**Leader:** `<Space>`

## Structure

```
nvim-config/
├── init.lua              # Main config (bootstrap, plugins, options)
└── lua/
    └── keymaps.lua       # All keybindings organized by category
```

## Features

- **Which-key** - Press `<leader>` and wait to see available keymaps, or `<leader>?` for buffer-local keymaps
- **Modular Keymap System** - All keymaps organized in categories
- **Multiple Search Methods** - Telescope fuzzy search or which-key hints
- **Well Documented** - Comprehensive guides and examples

## Default Keybindings

### File Navigation

| Key          | Action                               |
| ------------ | ------------------------------------ |
| `<leader>e`  | Toggle file explorer                 |
| `<leader>E`  | Focus explorer / reveal current file |
| `<leader>ff` | Find files                           |
| `<leader>fg` | Live grep                            |
| `<leader>fb` | Buffers                              |
| `<leader>fh` | Help tags                            |
| `<leader>fc` | Find commands                        |
| `<leader>fk` | Find keymaps                         |
| `<leader>fr` | Recent files                         |

### Quit
| Key           | Action                 |
| ------------- | ---------------------- |
| `<leader>qq`  | Quit Neovim (all)      |
| `<leader>wq`  | Save all and quit      |

### Window Management

| Key              | Action           |
| ---------------- | ---------------- |
| `<C-h/j/k/l>`    | Navigate windows |
| `<C-Up/Down>`    | Resize height    |
| `<C-Left/Right>` | Resize width     |

### Buffer Management (barbar)

| Key                         | Action                          |
| --------------------------- | ------------------------------- |
| `<Tab>` / `<S-Tab>`         | Next / previous buffer          |
| `<leader>bn` / `<leader>bp` | Next / previous buffer          |
| `<leader>w`                 | Close buffer (tab)              |
| `<leader>bd`                | Close buffer                    |
| `<leader>bb`                | Pick buffer                     |
| `<leader>b1` … `<leader>b9` | Goto buffer 1–9                 |
| `<S-h>` / `<S-l>`           | Previous / next buffer (legacy) |

### Formatting & Code

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>cf` | Format file/range |
| `<leader>ca` | Code action (LSP) |
| `<leader>rn` | Rename symbol     |

### Git (Fugit2)

| Key          | Action      |
| ------------ | ----------- |
| `<leader>F`  | Open Fugit2 |
| `<leader>gd` | Git diff    |
| `<leader>gg` | Git graph   |

### AI (Claude Code)

| Key          | Action             |
| ------------ | ------------------ |
| `<leader>ac` | Toggle Claude      |
| `<leader>af` | Focus Claude       |
| `<leader>ab` | Add current buffer |
| `<leader>aa` | Accept diff        |
| `<leader>ad` | Deny diff          |

## Install

Symlink this repo into Neovim’s config directory:

```bash
git clone git@github.com:amirmamaghani/nvim-config.git
cd nvim-config
ln -sf "$(pwd)" ~/.config/nvim
```

If `~/.config/nvim` already exists, remove or rename it first.

**macOS users:** Install libgit2 for Git integration:

```bash
brew install libgit2
```

Start Neovim; lazy.nvim will install plugins on first run.

## Documentation

- **[QUICKREF.md](QUICKREF.md)** - Quick reference card (start here!)
- **[KEYMAP-ORGANIZATION.md](KEYMAP-ORGANIZATION.md)** - Where are my keymaps? (init.lua vs keymaps.lua)
- **[GIT-SETUP.md](GIT-SETUP.md)** - Git integration with Fugit2
- **[KEYMAPS.md](KEYMAPS.md)** - Complete keymap management guide
- **[EXAMPLES.md](EXAMPLES.md)** - Real-world plugin integration examples
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System overview and design patterns

## Customization

### Adding/Modifying Keymaps

All keymaps are organized in `lua/keymaps.lua` by category. See [KEYMAPS.md](KEYMAPS.md) for details:

- Adding new keymaps
- Creating custom categories
- LSP keybindings
- Best practices and conventions

### Adding Plugins

1. Add plugin spec to `init.lua` under the appropriate section
2. Add keymaps to `lua/keymaps.lua` in a new or existing category
3. Update `M.setup()` if you created a new category

See [EXAMPLES.md](EXAMPLES.md) for complete examples of adding LSP, Git, Debug, and other plugins.

## Recommendations

### Fonts

For the best experience, install a [Nerd Font](https://github.com/ryanoasis/nerd-fonts) to display icons properly in the file tree and statusline. Follow the [font installation guide](https://github.com/ryanoasis/nerd-fonts?tab=readme-ov-file#font-installation), then configure your terminal to use the installed font.

For iTerm2 users: Go to **Settings → Profiles → Text** and set the font to "Hack Nerd Font" (or your preferred Nerd Font).
