local status_lsp, nvim_lsp = pcall(require, 'lspconfig')
if (not status_lsp) then return end

local status_coq, coq = pcall(require, 'coq')
if (not status_coq) then return end

local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
  -- formatting
end

nvim_lsp.volar.setup {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript" },
  cmd = { "typescript-language-server", "--stdio" },
  coq.lsp_ensure_capabilities()
}

nvim_lsp.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the 'vim' global
        globals = { 'vim' }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true)
      },
    }
  }
}
