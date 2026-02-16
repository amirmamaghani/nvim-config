# nvim-config

Neovim config managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

**Plugins:** Catppuccin, neo-tree, Telescope, nvim-treesitter, claudecode.nvim (AI).

**Leader:** `<Space>`

| Key       | Action              |
| --------- | ------------------- |
| `<leader>e`  | Toggle file tree (neo-tree) |
| `<leader>ff` | Find files (Telescope)     |
| `<leader>fg` | Live grep                  |
| `<leader>fb` | Buffers                    |
| `<leader>fh` | Help tags                  |
| `<leader>a*` | Claude Code (AI)           |

## Install

Symlink this repo into Neovim’s config directory:

```bash
git clone git@github.com:amirmamaghani/nvim-config.git
cd nvim-config
ln -sf "$(pwd)" ~/.config/nvim
```

If `~/.config/nvim` already exists, remove or rename it first. Start Neovim; lazy.nvim will install plugins on first run.
