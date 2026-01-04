vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
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

-- Netrw
vim.g.netrw_banner = 0 -- No banner
vim.g.netrw_liststyle = 3 -- Tree style file tree
vim.g.netrw_sort_by = "time" -- Most recent at top
vim.g.netrw_sort_direction = "reverse"

local map = vim.keymap.set

map('n', '<leader>s', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')

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

-- Lazygit, Files, Grep and Help
map('n', '<leader>gg', function()
	vim.cmd('terminal lazygit')
	vim.cmd('startinsert')
end, { desc = "Open lazygit in terminal" })


vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/RakshithNM/logdebug.nvim" },
  { src = "https://github.com/m4xshen/hardtime.nvim" },
  { src = "https://github.com/ellisonleao/glow.nvim" }
})
require("glow").setup {
  cmd = "Glow",
  config = true
}
require("hardtime").setup {
  max_time = 300,
  max_count = 1
}
require("logdebug").setup {
  keymap_visual = "<leader>lv",
  keymap_find = "<leader>fl",
  filetypes = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "go",
    "lua",
    "ruby",
    "python",
  },
-- optional filetype filter
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

require "nvim-treesitter".setup {
	ensure_installed = { 
    "javascript", 
    "typescript", 
    "lua", 
    "c", 
    "cpp", 
    "go", 
    "html", 
    "css", 
    "json", 
    "vim", 
    "bash"
  },
	sync_install = false,
	auto_install = false,
	ignore_install = {},
  indent = { enable = true },
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	incremental_selection = { enable = true },
	textobjects = { enable = false },
}

vim.lsp.enable({ 'lua_ls', 'ts_ls', 'html', 'cssls', 'jsonls' })
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local nmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
    end
    nmap('<leader>lf', vim.lsp.buf.format)
    nmap('gd', vim.lsp.buf.definition, "Go to definition")
    nmap('gr', vim.lsp.buf.references, "References")
    nmap('K',  vim.lsp.buf.hover, "Hover")
    nmap('<leader>rn', vim.lsp.buf.rename, "Rename")
    nmap('<leader>ca', vim.lsp.buf.code_action, "Code action")
    -- Ctrl-x Ctrl-o in normal mode
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true }
})
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = "Diagnostics: line float" })
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map('n', '<leader>dq', function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics → Quickfix" })
map('n', '<leader>dl', function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Diagnostics → Loclist" })

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

local builtin = require('telescope.builtin')
map('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })
map('n', '<leader>a', 'ggVG')

-- Completion in insert mode
map('i', '<leader>f', '<C-x><C-n>', { noremap = true, silent = true })

-- Autowrite template file to new C files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.c",
  command = "0r ~/REPOS/config/nvim/2025/templates/c.c"
})
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cc",
  command = "0r ~/REPOS/config/nvim/2025/templates/cpp.cc"
})

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
      if is_loclist then
        vim.cmd("ll")
        vim.cmd("lclose")
      else
        vim.cmd("cc")
        vim.cmd("cclose")
      end
    end

    vim.keymap.set("n", "<CR>", open_and_close, { buffer = ev.buf, silent = true })
    vim.keymap.set("n", "<2-LeftMouse>", open_and_close, { buffer = ev.buf, silent = true })
  end,
})
map('n', '<leader>q', ':cclose<CR>', { silent = true, desc = 'Quickfix: close' })
map('n', '<leader>cn',':cnext<CR>', { silent = true, desc = 'Quickfix: next' })
map('n', '<leader>cp',':cprevious<CR>', { silent = true, desc = 'Quickfix: prev' })

-- Line numbers in netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end
})

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
