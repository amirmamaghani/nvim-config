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

    -- File tree
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      lazy = false,
      keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
      },
      opts = {
        filesystem = {
          follow_current_file = { enabled = true },
        },
      },
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
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- =============================================================================
-- Editor options
-- =============================================================================
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
