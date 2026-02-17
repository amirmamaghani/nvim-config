-- =============================================================================
-- Keymap Viewer
-- Pretty display and search for keymaps
-- =============================================================================

local M = {}

-- Get all keymaps for a mode
local function get_keymaps(mode)
    local keymaps = vim.api.nvim_get_keymap(mode)
    local buf_keymaps = vim.api.nvim_buf_get_keymap(0, mode)
    
    -- Merge global and buffer-local keymaps
    for _, keymap in ipairs(buf_keymaps) do
        keymap.buffer = true
        table.insert(keymaps, keymap)
    end
    
    return keymaps
end

-- Format a single keymap entry
local function format_keymap(keymap, max_lhs, max_mode)
    local lhs = keymap.lhs or ""
    local desc = keymap.desc or ""
    local mode = keymap.mode or "?"
    local buffer = keymap.buffer and "[B]" or "   "
    
    -- Handle rhs - show description if available, otherwise show the mapping
    local action = desc
    if action == "" then
        local rhs = keymap.rhs or keymap.callback and "[function]" or ""
        -- Clean up lua references
        rhs = rhs:gsub(":<C%-U>", ":")
        rhs = rhs:gsub("<Cmd>", ":")
        rhs = rhs:gsub("<CR>", "")
        action = rhs
    end
    
    -- Truncate long actions
    if #action > 60 then
        action = action:sub(1, 57) .. "..."
    end
    
    -- Format with padding
    local lhs_padded = lhs .. string.rep(" ", max_lhs - #lhs)
    local mode_padded = mode .. string.rep(" ", max_mode - #mode)
    
    return string.format("%s %s  %s  %s", buffer, mode_padded, lhs_padded, action)
end

-- Calculate max widths for formatting
local function get_max_widths(keymaps)
    local max_lhs = 0
    local max_mode = 0
    
    for _, keymap in ipairs(keymaps) do
        local lhs = keymap.lhs or ""
        local mode = keymap.mode or ""
        max_lhs = math.max(max_lhs, #lhs)
        max_mode = math.max(max_mode, #mode)
    end
    
    return max_lhs, max_mode
end

-- Display keymaps in a buffer
function M.show(opts)
    opts = opts or {}
    local modes = opts.modes or { "n", "v", "i", "x", "s", "o", "c", "t" }
    local filter = opts.filter or ""
    
    -- Collect all keymaps
    local all_keymaps = {}
    for _, mode in ipairs(modes) do
        local keymaps = get_keymaps(mode)
        for _, keymap in ipairs(keymaps) do
            keymap.mode = mode
            table.insert(all_keymaps, keymap)
        end
    end
    
    -- Filter keymaps
    local filtered = {}
    for _, keymap in ipairs(all_keymaps) do
        local lhs = keymap.lhs or ""
        local desc = keymap.desc or ""
        local rhs = keymap.rhs or ""
        
        if filter == "" or 
           lhs:lower():find(filter:lower(), 1, true) or
           desc:lower():find(filter:lower(), 1, true) or
           rhs:lower():find(filter:lower(), 1, true) then
            table.insert(filtered, keymap)
        end
    end
    
    -- Sort by mode then lhs
    table.sort(filtered, function(a, b)
        if a.mode ~= b.mode then
            return a.mode < b.mode
        end
        return (a.lhs or "") < (b.lhs or "")
    end)
    
    -- Calculate widths
    local max_lhs, max_mode = get_max_widths(filtered)
    
    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    
    -- Header
    table.insert(lines, "╔═══════════════════════════════════════════════════════════════════════════╗")
    table.insert(lines, "║                           NEOVIM KEYMAPS                                  ║")
    table.insert(lines, "╠═══════════════════════════════════════════════════════════════════════════╣")
    if filter ~= "" then
        table.insert(lines, string.format("║ Filter: %-66s ║", filter))
        table.insert(lines, "╠═══════════════════════════════════════════════════════════════════════════╣")
    end
    table.insert(lines, string.format("║ %s MODE  %-"..max_lhs.."s  ACTION%".. (54-max_lhs) .."s ║", 
        "   ", "KEY", ""))
    table.insert(lines, "╠═══════════════════════════════════════════════════════════════════════════╣")
    
    -- Group by mode
    local current_mode = nil
    for _, keymap in ipairs(filtered) do
        if keymap.mode ~= current_mode then
            if current_mode ~= nil then
                table.insert(lines, "╟───────────────────────────────────────────────────────────────────────────╢")
            end
            current_mode = keymap.mode
        end
        
        local formatted = format_keymap(keymap, max_lhs, max_mode)
        -- Ensure line fits in box (75 chars max content)
        if #formatted > 75 then
            formatted = formatted:sub(1, 72) .. "..."
        end
        table.insert(lines, "║ " .. formatted .. string.rep(" ", 75 - #formatted) .. " ║")
    end
    
    -- Footer
    table.insert(lines, "╚═══════════════════════════════════════════════════════════════════════════╝")
    table.insert(lines, "")
    table.insert(lines, "Legend: [B] = Buffer-local | Modes: n=Normal v=Visual i=Insert x=Visual Block")
    table.insert(lines, "")
    table.insert(lines, string.format("Total keymaps: %d | Showing: %d", #all_keymaps, #filtered))
    table.insert(lines, "")
    table.insert(lines, "Press 'q' to close | '/' to search | 'r' to refresh")
    
    -- Set buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "keymaps")
    
    -- Open in a new window
    local width = 80
    local height = math.min(#lines, vim.o.lines - 4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
    
    -- Set window options
    vim.api.nvim_win_set_option(win, "wrap", false)
    vim.api.nvim_win_set_option(win, "cursorline", true)
    
    -- Buffer-local keymaps
    local function close_window()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end
    
    local function search_keymaps()
        close_window()
        vim.ui.input({ prompt = "Search keymaps: " }, function(input)
            if input then
                M.show({ filter = input, modes = modes })
            end
        end)
    end
    
    local function refresh()
        close_window()
        M.show(opts)
    end
    
    vim.keymap.set("n", "q", close_window, { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", close_window, { buffer = buf, silent = true })
    vim.keymap.set("n", "/", search_keymaps, { buffer = buf, silent = true })
    vim.keymap.set("n", "r", refresh, { buffer = buf, silent = true })
    vim.keymap.set("n", "n", function()
        search_keymaps()
    end, { buffer = buf, silent = true, desc = "Search normal mode" })
end

-- Show only normal mode keymaps
function M.show_normal()
    M.show({ modes = { "n" } })
end

-- Show only leader keymaps
function M.show_leader()
    M.show({ filter = vim.g.mapleader or " " })
end

-- Show only custom keymaps (with descriptions)
function M.show_custom()
    local modes = { "n", "v", "i", "x" }
    local all_keymaps = {}
    
    for _, mode in ipairs(modes) do
        local keymaps = get_keymaps(mode)
        for _, keymap in ipairs(keymaps) do
            keymap.mode = mode
            if keymap.desc and keymap.desc ~= "" then
                table.insert(all_keymaps, keymap)
            end
        end
    end
    
    -- Create custom filtered view
    M.show({ modes = modes, filter = "" })
end

return M
