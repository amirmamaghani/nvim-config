-- =============================================================================
-- Telescope Ignore Patterns Loader
-- Loads file_ignore_patterns from .telescope_ignore files
-- =============================================================================

local M = {}

--- Load ignore patterns from .telescope_ignore file
--- Checks project directory first, then home directory
---@return string[] patterns List of ignore patterns
function M.load_patterns()
  local patterns = {}
  local ignore_files = {
    vim.fn.getcwd() .. "/.telescope_ignore",
    vim.fn.expand("~/.telescope_ignore"),
  }

  for _, file in ipairs(ignore_files) do
    local f = io.open(file, "r")
    if f then
      for line in f:lines() do
        line = line:match("^%s*(.-)%s*$") -- trim whitespace
        if line ~= "" and not line:match("^#") then -- skip empty lines and comments
          table.insert(patterns, line)
        end
      end
      f:close()
      break -- use first found file
    end
  end

  return patterns
end

return M
