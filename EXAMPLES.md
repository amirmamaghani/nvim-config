# Keymap Extension Examples

Real-world examples of extending the keymap system for common use cases.

## Example 1: Adding Git Integration (Gitsigns)

### 1. Add the plugin to `init.lua`:

```lua
{
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end,
}
```

### 2. Add keymaps to `lua/keymaps.lua`:

```lua
function M.setup_git()
    -- Git hunk navigation
    map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })
    map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous git hunk" })
    
    -- Git actions
    map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
    map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
    map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
    map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
    map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
    map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
    
    -- Git diff
    map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })
end
```

## Example 2: Adding LSP Support

### 1. Add LSP plugin to `init.lua`:

```lua
{
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "tsserver", "gopls" },
        })
        
        local lspconfig = require("lspconfig")
        local keymaps = require("keymaps")
        
        -- Setup LSP servers with keymaps
        local servers = { "lua_ls", "tsserver", "gopls" }
        for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup({
                on_attach = function(client, bufnr)
                    keymaps.setup_lsp(bufnr)
                end,
            })
        end
    end,
}
```

### 2. LSP keymaps are already defined in `lua/keymaps.lua`

The `M.setup_lsp(bufnr)` function already contains standard LSP keymaps. To customize:

```lua
function M.setup_lsp(bufnr)
    local opts = { buffer = bufnr }
    
    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
    
    -- Actions
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    
    -- Add custom LSP keymaps here
    map("n", "<leader>li", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP info" }))
end
```

## Example 3: Adding Note-Taking (Obsidian.nvim)

### 1. Add plugin to `init.lua`:

```lua
{
    "epwalsh/obsidian.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        workspaces = {
            { name = "personal", path = "~/notes/personal" },
            { name = "work", path = "~/notes/work" },
        },
    },
}
```

### 2. Create new keymap category in `lua/keymaps.lua`:

```lua
function M.setup_notes()
    -- Note creation
    map("n", "<leader>nn", "<cmd>ObsidianNew<cr>", { desc = "New note" })
    map("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Find notes" })
    map("n", "<leader>ns", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
    
    -- Note navigation
    map("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
    map("n", "<leader>nt", "<cmd>ObsidianTags<cr>", { desc = "Search tags" })
    
    -- Note management
    map("n", "<leader>no", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian" })
    map("n", "<leader>nr", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
    
    -- Templates
    map("n", "<leader>ni", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })
end

-- Add to main setup
function M.setup()
    M.setup_general()
    M.setup_explorer()
    M.setup_telescope()
    M.setup_formatting()
    M.setup_notes()  -- Add this line
    M.setup_git()
    M.setup_debug()
end
```

## Example 4: Adding Debug Support (DAP)

### 1. Add DAP plugins to `init.lua`:

```lua
{
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        
        dapui.setup()
        require("nvim-dap-virtual-text").setup()
        
        -- Auto open/close UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
    end,
}
```

### 2. Update debug keymaps in `lua/keymaps.lua`:

```lua
function M.setup_debug()
    -- Breakpoints
    map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle breakpoint" })
    map("n", "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", 
        { desc = "Conditional breakpoint" })
    
    -- Control
    map("n", "<leader>dc", "<cmd>lua require('dap').continue()<cr>", { desc = "Continue" })
    map("n", "<leader>di", "<cmd>lua require('dap').step_into()<cr>", { desc = "Step into" })
    map("n", "<leader>do", "<cmd>lua require('dap').step_over()<cr>", { desc = "Step over" })
    map("n", "<leader>dO", "<cmd>lua require('dap').step_out()<cr>", { desc = "Step out" })
    map("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", { desc = "Toggle REPL" })
    map("n", "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", { desc = "Run last" })
    
    -- UI
    map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle DAP UI" })
    map("n", "<leader>de", "<cmd>lua require('dapui').eval()<cr>", { desc = "Eval under cursor" })
end
```

## Example 5: Custom Window Management

Add advanced window management to `lua/keymaps.lua`:

```lua
function M.setup_windows()
    -- Split management
    map("n", "<leader>wv", ":vsplit<CR>", { desc = "Vertical split" })
    map("n", "<leader>wh", ":split<CR>", { desc = "Horizontal split" })
    map("n", "<leader>wc", ":close<CR>", { desc = "Close window" })
    map("n", "<leader>wo", ":only<CR>", { desc = "Close other windows" })
    
    -- Window rotation
    map("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows down/right" })
    map("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows up/left" })
    
    -- Window movement
    map("n", "<leader>wH", "<C-w>H", { desc = "Move window far left" })
    map("n", "<leader>wJ", "<C-w>J", { desc = "Move window far down" })
    map("n", "<leader>wK", "<C-w>K", { desc = "Move window far up" })
    map("n", "<leader>wL", "<C-w>L", { desc = "Move window far right" })
    
    -- Equal size
    map("n", "<leader>w=", "<C-w>=", { desc = "Equal window sizes" })
end

-- Add to main setup
function M.setup()
    M.setup_general()
    M.setup_windows()  -- Add this
    -- ... rest of setup
end
```

## Tips for Organization

1. **Keep related functionality together**: Git operations under `<leader>g`, debug under `<leader>d`
2. **Use descriptive names**: `{ desc = "..." }` helps with discoverability
3. **Group by mode first**: Separate normal, visual, insert mode keymaps
4. **Comment complex keymaps**: Explain non-obvious functionality
5. **Test incrementally**: Add a few keymaps at a time and test before adding more
