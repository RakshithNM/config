-- Performance: Enable Lua bytecode caching for faster startup
vim.loader.enable()

-- Disable optional providers to reduce warnings (uncomment if you don't need them)
-- vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Options
vim.o.winborder = "rounded"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.swapfile = false
vim.o.undofile = false
vim.o.termguicolors = true
vim.o.incsearch = true
vim.o.wrap = false
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.autocomplete = true
vim.g.mapleader = " "
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

local map = vim.keymap.set
-- Source current file (useful for config files)
map('n', '<leader>s', function()
  vim.cmd('update | source %')
end, { desc = "Save and source current file" })
map('n', '<leader>w', ':write<CR>', { desc = "Write file" })

-- Lazygit, Files, Grep and Help
map('n', '<leader>gg', function()
	vim.cmd('terminal lazygit')
	-- Ensure terminal buffer gets focus and enters insert mode
	vim.schedule(function()
		vim.cmd('startinsert')
	end)
end, { desc = "Open lazygit in terminal" })

-- Essential plugins (loaded at startup)
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/m4xshen/hardtime.nvim" }, -- Must load at startup to intercept keys
})

-- Optional plugins (lazy loaded)
vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", opt = true },
  { src = "https://github.com/RakshithNM/logdebug.nvim", opt = true },
  { src = "https://github.com/ellisonleao/glow.nvim", opt = true },
})

-- Plugin configurations (lazy loaded)
-- Glow (markdown preview) - setup at startup, command available when needed
vim.schedule(function()
  vim.cmd("packadd glow.nvim")
  local glow_ok, glow = pcall(require, "glow")
  if glow_ok then
    -- Find glow binary path - try exepath first, then common locations
    local glow_path = vim.fn.exepath("glow")
    if glow_path == "" or glow_path == vim.NIL then
      -- Check common Homebrew locations
      local homebrew_paths = { "/opt/homebrew/bin/glow", "/usr/local/bin/glow" }
      for _, path in ipairs(homebrew_paths) do
        if vim.fn.executable(path) == 1 then
          glow_path = path
          break
        end
      end
    end

    glow.setup {
      glow_path = (glow_path ~= "" and glow_path ~= vim.NIL) and glow_path or "/opt/homebrew/bin/glow",
      install_path = (glow_path ~= "" and glow_path ~= vim.NIL) and glow_path or "/opt/homebrew/bin/glow",
      style = "dark",
      border = "rounded",
      pager = false,
      width = 90,
      height = 90,
      width_ratio = 0.9,
      height_ratio = 0.9,
    }
  end
end)

-- Hardtime (vim practice) - must load at startup to intercept keys
vim.schedule(function()
  local hardtime_ok, hardtime = pcall(require, "hardtime")
  if hardtime_ok then
    hardtime.setup {
      max_time = 300,
      max_count = 1,
      disable_mouse = true,
      hint = true,
      notification = true,
      allow_different_key = false,
      restriction_mode = "block", -- "block" or "hint"
      restricted_keys = {
        ["h"] = { "n", "x" },
        ["j"] = { "n", "x" },
        ["k"] = { "n", "x" },
        ["l"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
      },
      disabled_keys = {
        ["<Up>"] = { "", "i" },
        ["<Down>"] = { "", "i" },
        ["<Left>"] = { "", "i" },
        ["<Right>"] = { "", "i" },
      },
    }
  end
end)

-- Logdebug - setup at startup for all supported filetypes
vim.schedule(function()
  vim.cmd("packadd logdebug.nvim")
  local logdebug_ok, logdebug = pcall(require, "logdebug")
  if logdebug_ok then
    local logdebug_filetypes = {
      "javascript", "typescript", "javascriptreact", "typescriptreact",
      "vue", "go", "lua", "ruby", "python"
    }
    logdebug.setup {
      keymap_below = "<leader>wlb", -- log word below cursor
      keymap_above = "<leader>wla", -- log word above cursor
      keymap_remove = "<leader>dl", -- delete all console logs
      keymap_comment = "<leader>kl", -- comment out all console logs
      keymap_toggle = "<leader>tll", -- toggle log level
      keymap_visual = "<leader>lv", -- visual mode log
      keymap_find = "<leader>fl", -- find logs
      filetypes = logdebug_filetypes,
      languages = {
        go = {
          build_log = function(indent, _level, expr)
            return string.format('%slog.Printf("%%+v", %s)', indent, expr)
          end,
          is_log_line = function(line, _levels)
            return line:match("^%s*log%.Printf%(") ~= nil
          end,
        },
        lua = {
          build_log = function(indent, _level, expr)
            return string.format("%sprint(vim.inspect(%s))", indent, expr)
          end,
          is_log_line = function(line, _levels)
            return line:match("^%s*print%(") ~= nil
              or line:match("^%s*vim%.print%(") ~= nil
          end,
        },
        ruby = {
          build_log = function(indent, _level, expr)
            return string.format("%sputs(%s.inspect)", indent, expr)
          end,
          is_log_line = function(line)
            return line:match("^%s*puts%(") ~= nil
          end,
        },
        python = {
          build_log = function(indent, _level, expr)
            return string.format("%sprint(%s)", indent, expr)
          end,
          is_log_line = function(line)
            return line:match("^%s*print%(") ~= nil
          end,
        },
      },
    }
  end
end)

-- Treesitter setup (deferred until first buffer)
local treesitter_setup_done = false
local treesitter_filetypes = {
  javascript = true, typescript = true, lua = true, c = true, cpp = true,
  go = true, html = true, css = true, json = true, vim = true, bash = true,
  markdown = true, python = true, ruby = true, vue = true
}
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if not treesitter_setup_done then
      local ft = vim.bo.filetype
      if ft ~= "" and treesitter_filetypes[ft] then
        treesitter_setup_done = true
        local treesitter_ok, treesitter = pcall(require, "nvim-treesitter")
        if treesitter_ok then
          treesitter.setup {
            ensure_installed = { 
              "javascript", "typescript", "lua", "c", "cpp", "go",
              "html", "css", "json", "vim", "bash"
            },
            sync_install = false,
            auto_install = false,
            ignore_install = {},
            indent = { enable = true },
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            incremental_selection = { enable = true },
            textobjects = { enable = false },
          }
        end
      end
    end
  end,
  once = true,
})

-- LSP Configuration
-- Enable LSP servers
vim.lsp.enable({ 'lua_ls', 'ts_ls', 'html', 'cssls', 'jsonls' })
-- Configure LSP servers (must be done before enable or in LspAttach)
vim.lsp.config('cssls', {})
vim.lsp.config('ts_ls', {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	root_dir = vim.fs.root(0, { "tsconfig.json", "package.json", ".git" }),
})
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
})
-- LSP keymaps and setup
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local nmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
    end
    
    -- LSP keymaps
    nmap('<leader>lf', vim.lsp.buf.format, "Format buffer")
    nmap('gd', vim.lsp.buf.definition, "Go to definition")
    nmap('gr', vim.lsp.buf.references, "References")
    nmap('K',  vim.lsp.buf.hover, "Hover")
    nmap('<leader>rn', vim.lsp.buf.rename, "Rename")
    nmap('<leader>ca', vim.lsp.buf.code_action, "Code action")
    
    -- Set omnifunc for completion
    vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end
})

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true }
})

-- Diagnostic keymaps
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = "Diagnostics: line float" })
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map('n', '<leader>dq', function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics → Quickfix" })
map('n', '<leader>dl', function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Diagnostics → Loclist" })

-- Telescope setup (lazy loaded on first use)
local telescope_initialized = false
local function init_telescope()
  if telescope_initialized then return end
  telescope_initialized = true
  local telescope_ok, telescope = pcall(require, 'telescope')
  if telescope_ok then
    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      }
    })
    -- Load fzf-native extension if available
    pcall(telescope.load_extension, 'fzf')
  end
end

-- Telescope keymaps (lazy load on first use)
map('n', '<leader><leader>', function()
  init_telescope()
  require('telescope.builtin').find_files()
end, { desc = 'Telescope find files' })
map('n', '<leader>/', function()
  init_telescope()
  require('telescope.builtin').live_grep()
end, { desc = 'Telescope live grep' })
map('n', '<leader>h', function()
  init_telescope()
  require('telescope.builtin').help_tags()
end, { desc = 'Telescope help tags' })
map('n', '<leader>a', 'ggVG', { desc = "Select all" })

-- Completion in insert mode
map('i', '<leader>f', '<C-x><C-n>', { noremap = true, silent = true, desc = "Keyword completion" })

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = [[rg --vimgrep --smart-case --hidden --glob '!.git/*']]
  vim.opt.grepformat = { "%f:%l:%c:%m" }
end
-- <leader>gr => grep word under cursor, open quickfix
map('n', '<leader>gr', function()
  local word = vim.fn.expand('<cword>')
  if word == '' then return end
  vim.cmd('silent! grep! ' .. vim.fn.shellescape(word))
  if #vim.fn.getqflist() > 0 then
    vim.cmd('copen')
  else
    vim.notify('No matches for: ' .. word)
  end
end, { desc = 'Grep word under cursor' })
-- Close quickfix (or loclist) after jumping to an item
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(ev)
    local function open_and_close()
      local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
      local is_loclist = info and info.loclist == 1
      vim.cmd(is_loclist and "ll | lclose" or "cc | cclose")
    end

    vim.keymap.set("n", "<CR>", open_and_close, { buffer = ev.buf, silent = true })
    vim.keymap.set("n", "<2-LeftMouse>", open_and_close, { buffer = ev.buf, silent = true })
  end,
})
map('n', '<leader>q', ':cclose<CR>', { silent = true, desc = 'Quickfix: close' })
map('n', '<leader>cn',':cnext<CR>', { silent = true, desc = 'Quickfix: next' })
map('n', '<leader>cp',':cprevious<CR>', { silent = true, desc = 'Quickfix: prev' })

-- Template file paths (cached to avoid repeated expansions)
local template_c = vim.fn.expand("~/.config/nvim/templates/c.c")
local template_cpp = vim.fn.expand("~/.config/nvim/templates/cpp.cc")
local template_c_exists = vim.fn.filereadable(template_c) == 1
local template_cpp_exists = vim.fn.filereadable(template_cpp) == 1

-- Autowrite template file to new C files
if template_c_exists then
  vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.c",
    command = "0r " .. template_c
  })
end

-- Autowrite template file to new CPP files
if template_cpp_exists then
  vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.cc",
    command = "0r " .. template_cpp
  })
end

-- Compile C programs within vim
map('n', '<F5>', function()
  vim.cmd.write()
  local file = vim.fn.expand('%:p')
  local out  = vim.fn.expand('%:p:r')
  vim.cmd('!gcc -Wall -Wextra -O2 ' .. vim.fn.shellescape(file) .. ' -o ' .. vim.fn.shellescape(out))
end, { desc = "Build C" })

-- Run built binary
map('n', '<F6>', function()
  local out = vim.fn.expand('%:p:r')
  vim.cmd('!' .. vim.fn.shellescape(out))
end, { desc = "Run built binary" })

-- Netrw
vim.g.netrw_banner = 0 -- No banner
vim.g.netrw_liststyle = 3 -- Tree style file tree
vim.g.netrw_sort_by = "time" -- Most recent at top
vim.g.netrw_sort_direction = "reverse"
-- Line numbers in netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end
})

-- Colorscheme (deferred to avoid blocking startup)
vim.schedule(function()
  local vague_ok, vague = pcall(require, "vague")
  if vague_ok then
    vague.setup({ transparent = true })
    vim.cmd("colorscheme vague | hi statusline guibg=NONE")
  end
end)
