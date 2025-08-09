vim.o.winborder = "rounded"
vim.o.cursorcolumn = false
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
vim.o.autocomplete = true
vim.g.mapleader = " "

-- Netrw
vim.g.netrw_banner = 0 -- No banner
vim.g.netrw_liststyle = 3 -- Tree style file tree

local map = vim.keymap.set

map('n', '<leader>s', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')

map({ 'n', 'v', 'x' }, 'yy', '"+y<CR>')

-- Lazygit, Files, Grep and Help
map('n', '<leader>gg', function()
	vim.cmd('terminal lazygit')
	vim.cmd('startinsert')
end, { desc = "Open lazygit in terminal" })
map('n', '<leader><leader>', ":Pick files<CR>")
map('n', '<leader>/', ":Pick grep<CR>")
map('n', '<leader>h', ":Pick help<CR>")

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }
})
require "mini.pick".setup()
require "nvim-treesitter.configs".setup {
	ensure_installed = { "javascript", "typescript", "lua", "c" },
	sync_install = false,
	auto_install = false,
	ignore_install = {},
  indent = { enable = true },
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	incremental_selection = { enable = true },
	textobjects = { enable = true },
}

vim.lsp.enable({ 'lua_ls', 'tsserver' })
map('n', '<leader>lf', vim.lsp.buf.format)

vim.lsp.config('tsserver', {
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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	end,
})

-- Autowrite template file to new C files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.c",
  command = "0r ~/.config/nvim/templates/hello.c"
})

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
