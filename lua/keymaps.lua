-- =============================================================================
-- Keymaps Module
-- Organized by category for easy maintenance and extension
--
-- NOTE: Plugin-specific keymaps are defined in init.lua under each plugin's
--       'keys' spec for better lazy-loading. Check init.lua for:
--       - Telescope: <leader>ff, fg, fb, fh
--       - Fugit2: <leader>F
--       - Claude Code: <leader>a*
--       - Which-key: <leader>? (show buffer local keymaps)
--       Barbar keymaps are in this file (setup_barbar).
-- =============================================================================

local M = {}

-- Helper function to set keymaps with consistent defaults
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- =============================================================================
-- General Editor Keymaps
-- =============================================================================
function M.setup_general()
    -- Better window navigation
    map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

    -- Resize windows
    map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
    map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
    map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
    map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

    -- Buffer navigation
    map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
    map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

    -- Better indenting
    map("v", "<", "<gv", { desc = "Indent left" })
    map("v", ">", ">gv", { desc = "Indent right" })

    -- Move text up and down
    map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
    map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

    -- Clear search highlighting
    map("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

    -- Better paste (don't yank replaced text)
    map("v", "p", '"_dP', { desc = "Paste without yanking" })

    -- Quit Neovim
    map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all (close Neovim)" })
    map("n", "<leader>wq", "<cmd>wqa<cr>", { desc = "Save all and quit" })
end

-- =============================================================================
-- File Explorer
-- =============================================================================
function M.setup_explorer()
    map("n", "<leader>e", function()
        require("snacks").explorer()
    end, { desc = "Toggle Explorer" })

    -- Focus back: reveal current file in explorer (opens/focuses explorer)
    map("n", "<leader>E", function()
        require("snacks").explorer.reveal()
    end, { desc = "Reveal current file in explorer (focus explorer)" })
end

-- =============================================================================
-- Telescope (Fuzzy Finder)
-- =============================================================================
function M.setup_telescope()
    -- Core telescope keymaps are in init.lua (lazy-loaded with plugin):
    --   <leader>ff - Find files
    --   <leader>fg - Live grep
    --   <leader>fb - Buffers
    --   <leader>fh - Help tags
    
    -- Additional telescope keymaps here:
    map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>", { desc = "Find commands" })
    map("n", "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>", { desc = "Find keymaps (Telescope)" })
    map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", { desc = "Recent files" })
end

-- =============================================================================
-- Formatting (Conform)
-- =============================================================================
function M.setup_formatting()
    map({ "n", "v" }, "<leader>cf", function()
        require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
        })
    end, { desc = "Format file or range" })
end

-- =============================================================================
-- LSP Keymaps (to be set when LSP attaches)
-- =============================================================================
function M.setup_lsp(bufnr)
    local opts = { buffer = bufnr }

    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
    map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
end

-- =============================================================================
-- Buffer Tabs (barbar)
-- =============================================================================
function M.setup_barbar()
    -- Navigation
    map("n", "<leader>bn", "<cmd>BufferNext<cr>", { desc = "Next buffer" })
    map("n", "<leader>bp", "<cmd>BufferPrevious<cr>", { desc = "Previous buffer" })
    map("n", "<Tab>", "<cmd>BufferNext<cr>", { desc = "Next buffer" })
    map("n", "<S-Tab>", "<cmd>BufferPrevious<cr>", { desc = "Previous buffer" })

    -- Close / restore
    map("n", "<leader>w", "<cmd>BufferClose<cr>", { desc = "Close buffer (tab)" })
    map("n", "<leader>bd", "<cmd>BufferClose<cr>", { desc = "Close buffer" })
    map("n", "<leader>bq", "<cmd>BufferClose<cr>", { desc = "Close buffer" })
    map("n", "<leader>br", "<cmd>BufferRestore<cr>", { desc = "Restore closed buffer" })

    -- Pick buffer (fuzzy / letter jump)
    map("n", "<leader>bb", "<cmd>BufferPick<cr>", { desc = "Pick buffer" })

    -- Goto buffer by number
    for i = 1, 9 do
        map("n", ("<leader>b%d"):format(i), ("<cmd>BufferGoto %d<cr>"):format(i), {
            desc = ("Goto buffer %d"):format(i),
        })
    end

    -- Reorder
    map("n", "<leader>bmn", "<cmd>BufferMoveNext<cr>", { desc = "Move buffer right" })
    map("n", "<leader>bmp", "<cmd>BufferMovePrevious<cr>", { desc = "Move buffer left" })
end

-- =============================================================================
-- Git Keymaps (fugit2)
-- =============================================================================
function M.setup_git()
    -- Core fugit2 keymap is in init.lua (lazy-loaded with plugin):
    --   <leader>F - Open Fugit2
    
    -- Additional git commands:
    map("n", "<leader>gd", "<cmd>Fugit2Diff<cr>", { desc = "Git diff" })
    map("n", "<leader>gg", "<cmd>Fugit2Graph<cr>", { desc = "Git graph" })
    
    -- Placeholder for gitsigns if you add it later:
    -- map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
    -- map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk" })
end

-- =============================================================================
-- Debug Keymaps (for future DAP integration)
-- =============================================================================
function M.setup_debug()
    -- Placeholder for debugging keymaps
    -- Example:
    -- map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle breakpoint" })
    -- map("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "Continue debugging" })
end

-- =============================================================================
-- Initialize all keymaps
-- =============================================================================
function M.setup()
    M.setup_general()
    M.setup_explorer()
    M.setup_telescope()
    M.setup_formatting()
    M.setup_barbar()
    M.setup_git()
    M.setup_debug()
end

return M
