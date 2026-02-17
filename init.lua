-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Leader (must be set before lazy so keymaps are correct)
-- =============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =============================================================================
-- Plugins (lazy.nvim)
-- =============================================================================
require("lazy").setup({
  spec = {
    -- Colorscheme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        require("catppuccin").setup()
        vim.cmd.colorscheme("catppuccin")
      end,
    },

    -- Snacks
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      config = function()
        require("snacks").setup({
          bigfile = { enabled = true },
          dashboard = { enabled = true },
          explorer = {
            enabled = true,
            open = "tabopen",
            mappings = {
              ["<CR>"] = "tabopen", -- Enter key opens in new tab
              ["t"] = "edit",      -- 't' key for edit in current window
            },
          },
          indent = { enabled = true },
          input = { enabled = true },
          picker = { enabled = true },
          notifier = { enabled = true },
          quickfile = { enabled = true },
          scope = { enabled = true },
          scroll = { enabled = true },
          statuscolumn = { enabled = true },
          words = { enabled = true },
        })
      end,
    },

    -- Buffer tabs (barbar)
    {
      "romgrk/barbar.nvim",
      dependencies = {
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      init = function()
        vim.g.barbar_auto_setup = false
      end,
      opts = {},
      version = "^1.0.0",
    },

    -- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      version = "*",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      keys = {
        { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Help tags" },
      },
      opts = {
        defaults = {
          mappings = {
            i = { ["<C-h>"] = "which_key" },
          },
        },
      },
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = { "javascript", "typescript", "go" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- Formatting (conform)
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            rust = { "rustfmt", lsp_format = "fallback" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            markdown = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            yaml = { "prettierd", "prettier", stop_after_first = true },
            html = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettierd", "prettier", stop_after_first = true },
            go = { "gofmt" },
          },
        })
      end,
    },

    -- Git (fugit2)
    {
      "SuperBo/fugit2.nvim",
      build = false,
      opts = {
        width = 100,
      },
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        {
          "chrisgrieser/nvim-tinygit",
          dependencies = { "stevearc/dressing.nvim" },
        },
      },
      cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
      keys = {
        { "<leader>F", mode = "n", "<cmd>Fugit2<cr>", desc = "Fugit2" },
      },
    },

    -- Claude Code (AI)
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      config = true,
      keys = {
        { "<leader>a", nil, desc = "AI/Claude Code" },
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
        {
          "<leader>as",
          "<cmd>ClaudeCodeTreeAdd<cr>",
          desc = "Add file",
          ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      },
    },

    -- Which-key (keybinding hints)
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- =============================================================================
-- Keymaps
-- =============================================================================
require("keymaps").setup()

-- =============================================================================
-- Editor options
-- =============================================================================
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
