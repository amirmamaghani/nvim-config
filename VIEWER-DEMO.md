# Keymap Viewer Demo

## What You'll See

Instead of this ugly output from `:map`:

```
n  <Space>fk      * <Cmd>lua require('telescope.builtin').keymaps()<CR>
n  <Space>cf      * <Lua function 1>
n  gd              * <Lua function 2>
```

You get this beautiful formatted view:

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                           NEOVIM KEYMAPS                                  ║
╠═══════════════════════════════════════════════════════════════════════════╣
║     MODE  KEY            ACTION                                           ║
╠═══════════════════════════════════════════════════════════════════════════╣
║     n     <C-h>          Move to left window                              ║
║     n     <C-j>          Move to bottom window                            ║
║     n     <C-k>          Move to top window                               ║
║     n     <C-l>          Move to right window                             ║
║     n     <Esc>          Clear search highlight                           ║
║     n     <S-h>          Previous buffer                                  ║
║     n     <S-l>          Next buffer                                      ║
╟───────────────────────────────────────────────────────────────────────────╢
║     n     <leader>e      Toggle Explorer                                  ║
║     n     <leader>ff     Find files                                       ║
║     n     <leader>fg     Live grep                                        ║
║     n     <leader>fb     Buffers                                          ║
║     n     <leader>fh     Help tags                                        ║
║     n     <leader>fk     Find keymaps (Telescope)                         ║
║     n     <leader>fK     Show all keymaps (pretty viewer)                 ║
║     n     <leader>cf     Format file or range                             ║
╟───────────────────────────────────────────────────────────────────────────╢
║ [B] n     gd             Go to definition                                 ║
║ [B] n     gr             Show references                                  ║
║ [B] n     K              Hover documentation                              ║
║ [B] n     <leader>rn     Rename symbol                                    ║
║ [B] n     <leader>ca     Code action                                      ║
╟───────────────────────────────────────────────────────────────────────────╢
║     v     <              Indent left                                      ║
║     v     >              Indent right                                     ║
║     v     J              Move text down                                   ║
║     v     K              Move text up                                     ║
║     v     p              Paste without yanking                            ║
╚═══════════════════════════════════════════════════════════════════════════╝

Legend: [B] = Buffer-local | Modes: n=Normal v=Visual i=Insert x=Visual Block

Total keymaps: 156 | Showing: 24

Press 'q' to close | '/' to search | 'r' to refresh
```

## Usage Examples

### View All Keymaps
```vim
:Keymaps
" or
<leader>fK
```

### View Only Normal Mode
```vim
:KeymapsNormal
" or
<leader>fn
```

### View Only Leader Keymaps
```vim
:KeymapsLeader
" or
<leader>fl
```

### Search for Specific Keymaps
```vim
:KeymapsSearch telescope
" or
:KeymapsSearch format
" or
:KeymapsSearch <C-
```

### Interactive Search (While in Viewer)
1. Press `<leader>fK` to open the viewer
2. Press `/` to open search prompt
3. Type your search term (e.g., "telescope")
4. Press Enter to see filtered results
5. Press `r` to clear filter and see all again

## Features

### Clean Display
- ✅ No Lua function pointers
- ✅ Clear descriptions for all custom keymaps
- ✅ Grouped by mode
- ✅ Sorted alphabetically
- ✅ Shows buffer-local keymaps with [B] indicator

### Interactive Controls
- `/` - Search/filter keymaps
- `r` - Refresh display
- `q` or `Esc` - Close viewer

### Smart Filtering
Search matches:
- Key combination (e.g., "leader", "C-h")
- Description (e.g., "telescope", "format")
- Action/command (e.g., "split", "grep")

### Multiple Views
- **All keymaps** - Every keymap in your config
- **Normal mode** - Only `n` mode keymaps
- **Leader keymaps** - Only keymaps starting with leader
- **Custom search** - Filter by any term

## Comparison

| Feature | `:map` | `:Telescope keymaps` | `:Keymaps` |
|---------|--------|---------------------|------------|
| Clean format | ❌ | ✅ | ✅ |
| No Lua refs | ❌ | ✅ | ✅ |
| Grouped by mode | ❌ | ❌ | ✅ |
| Shows descriptions | ❌ | ✅ | ✅ |
| Interactive search | ❌ | ✅ | ✅ |
| Table format | ❌ | ❌ | ✅ |
| Built-in | ✅ | ❌ | ❌ |
| Fuzzy search | ❌ | ✅ | ❌ |
| Exact search | ✅ | ❌ | ✅ |

## Tips

1. **Finding conflicts**: Use `:Keymaps` and search for a key to see if it's already mapped
2. **Learning keymaps**: Browse `:KeymapsLeader` to discover all leader keymaps
3. **Mode-specific**: Use `:KeymapsNormal` when configuring normal mode
4. **Quick reference**: Keep it open in a split while configuring

## Keybindings Summary

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>fK` | `:Keymaps` | Show all keymaps |
| `<leader>fn` | `:KeymapsNormal` | Show normal mode |
| `<leader>fl` | `:KeymapsLeader` | Show leader keymaps |
| `<leader>fk` | `:Telescope keymaps` | Fuzzy search (Telescope) |

**Inside the viewer:**
| Key | Action |
|-----|--------|
| `/` | Search keymaps |
| `r` | Refresh display |
| `q` | Close viewer |
| `Esc` | Close viewer |
