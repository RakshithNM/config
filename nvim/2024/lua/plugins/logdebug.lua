return {
  "RakshithNM/logdebug.nvim",
  config = function()
    require("logdebug").setup({
      keymap_above = "<leader>wla",
      keymap_below = "<leader>wlb",
      keymap_remove = "<leader>dl",
      keymap_comment = "<leader>kl",
      keymap_toggle = "<leader>tll",
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
    })
  end,
}
