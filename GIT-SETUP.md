# Git Integration with Fugit2

## Overview

Fugit2 is a modern Git interface for Neovim, providing a full-featured Git UI similar to Magit (Emacs) or lazygit.

## Installation

### Prerequisites

**macOS users** must install libgit2 first:
```bash
brew install libgit2
```

**Linux users** - libgit2 is usually included, but if needed:
```bash
# Ubuntu/Debian
sudo apt install libgit2-dev

# Arch
sudo pacman -S libgit2

# Fedora
sudo dnf install libgit2-devel
```

### Plugin Installation

The plugin is already configured in `init.lua` and will install automatically when you restart Neovim or run `:Lazy sync`.

## Dependencies

Fugit2 includes:
- **fugit2.nvim** - Main Git interface
- **nvim-tinygit** - GitHub PR view (optional)
- **dressing.nvim** - Better UI for inputs
- **nui.nvim**, **plenary.nvim**, **nvim-web-devicons** - UI components

## Keybindings

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>F` | `:Fugit2` | Open Fugit2 main interface |
| `<leader>gd` | `:Fugit2Diff` | Show git diff |
| `<leader>gg` | `:Fugit2Graph` | Show git graph/log |

## Commands

```vim
:Fugit2           " Open main Git UI
:Fugit2Diff       " Show diff view
:Fugit2Graph      " Show commit graph
```

## Features

### Main Interface (`<leader>F`)
The Fugit2 interface shows:
- Current branch
- Staged/unstaged changes
- Untracked files
- Recent commits
- Stashes

### Common Operations

**In Fugit2 interface:**
- `s` - Stage file/hunk
- `u` - Unstage file/hunk
- `c` - Commit (opens commit message editor)
- `P` - Push
- `p` - Pull
- `F` - Fetch
- `l` - View log
- `d` - View diff
- `?` - Show help

### Staging Workflow
1. Press `<leader>F` to open Fugit2
2. Navigate to changed files
3. Press `s` to stage files
4. Press `c` to commit
5. Write commit message and save
6. Press `P` to push

### Diff View (`<leader>gd`)
Shows changes in a split view:
- Left: Original file
- Right: Modified file
- Highlights additions/deletions

### Graph View (`<leader>gg`)
Visual representation of:
- Commit history
- Branch structure
- Merge points
- Tags

## Configuration

Current settings in `init.lua`:

```lua
{
  "SuperBo/fugit2.nvim",
  opts = {
    width = 100,  -- Width of Fugit2 window
  },
}
```

### Customization Options

Add to the `opts` table in `init.lua`:

```lua
opts = {
  width = 100,
  height = 20,
  min_width = 50,
  
  -- Commit editor settings
  commit_editor = {
    cmd = "edit",  -- or "vsplit", "split", "tabnew"
  },
  
  -- Git settings
  git = {
    cmd = "git",
    max_jobs = 4,
  },
},
```

## GitHub Integration (nvim-tinygit)

The optional tinygit plugin provides:
- PR creation
- PR review
- Issue browsing
- GitHub-specific features

To use GitHub features, ensure you have:
1. GitHub CLI (`gh`) installed
2. Authenticated with `gh auth login`

## Tips

### Quick Status Check
```vim
<leader>F    " Open Fugit2 to see current status
```

### Stage and Commit
```vim
<leader>F    " Open Fugit2
s            " Stage file (cursor on file)
c            " Open commit editor
:wq          " Save commit message
```

### View History
```vim
<leader>gg   " Open graph view
```

### Review Changes
```vim
<leader>gd   " Open diff view
```

### Keyboard-Driven Workflow
Fugit2 is designed for keyboard navigation:
- `j/k` - Move up/down
- `Enter` - Expand/collapse sections
- `s` - Stage
- `u` - Unstage
- `c` - Commit
- `?` - Show all keybindings

## Comparison with Other Git Tools

| Feature | Fugit2 | Telescope Git | vim-fugitive | lazygit |
|---------|--------|---------------|--------------|---------|
| Staging | ✅ | ❌ | ✅ | ✅ |
| Visual diff | ✅ | ❌ | ✅ | ✅ |
| Graph view | ✅ | ❌ | ✅ | ✅ |
| Commit UI | ✅ | ❌ | ✅ | ✅ |
| In Neovim | ✅ | ✅ | ✅ | ❌ (external) |
| Keyboard-first | ✅ | ✅ | ✅ | ✅ |
| GitHub integration | ✅ (tinygit) | ❌ | ❌ | ✅ |

## Troubleshooting

### Fugit2 won't open
1. **macOS users:** Ensure libgit2 is installed: `brew install libgit2`
2. Check git is installed: `git --version`
3. Ensure you're in a git repository: `git status`
4. Restart Neovim: `:qa` then reopen

### Commands not found
Run `:Lazy sync` to ensure all plugins are installed.

### Want lazygit instead?
If you prefer lazygit (external terminal UI):

```lua
-- Add to init.lua
{
  "kdheepak/lazygit.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
```

### Using with Gitsigns
Fugit2 and Gitsigns complement each other:
- **Fugit2** - Full Git UI, staging, commits
- **Gitsigns** - Inline git blame, hunk operations

To add Gitsigns, see [EXAMPLES.md](EXAMPLES.md).

## Resources

- [Fugit2 GitHub](https://github.com/SuperBo/fugit2.nvim)
- [Fugit2 Documentation](https://github.com/SuperBo/fugit2.nvim/blob/master/README.md)
- [nvim-tinygit](https://github.com/chrisgrieser/nvim-tinygit)

## Quick Reference

```vim
" Open Fugit2
<leader>F

" In Fugit2:
?           Show help
s           Stage
u           Unstage
c           Commit
P           Push
p           Pull
F           Fetch
l           Log
d           Diff
q           Quit

" Direct commands:
<leader>gd   Git diff
<leader>gg   Git graph
```
