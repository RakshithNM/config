-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("logger").setup()
require("lazy").setup("plugins")
