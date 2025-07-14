require('mason').setup()
require('mason-lspconfig').setup({
   ensure_installed = {'pyright', 'clangd'}
})

local servers = { "clangd","rust_analyzer", "pyright", "lua_ls" }

for _, server in ipairs(servers) do
  require("lspconfig")[server].setup({})
end

