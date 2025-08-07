-- Utility: get the indentation of the current line
local function get_current_indent()
  local line = vim.fn.getline(".")
  return line:match("^%s*") or ""
end

local M = {}

function M.log_word_under_cursor()
  local word = vim.fn.expand("<cword>")
  local indent = get_current_indent()
  local line_num = vim.fn.line(".")
  local log_line = string.format("%sconsole.log({ %s });", indent, word)
  vim.fn.append(line_num, log_line)
end

function M.setup(opts)
  opts = opts or {}
  local keymap = opts.keymap or "<leader>wl"

  vim.keymap.set("n", keymap, M.log_word_under_cursor, { desc = "Console log word under cursor" })
end

return M
