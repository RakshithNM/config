local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  modules = { "" },
  sync_install = false,
  auto_install = true,
  ignore_install = { 'javascript' },
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    'tsx',
    'lua',
    'json',
    'css',
    'scss',
  },
  autotag = {
    enable = true
  }
}
