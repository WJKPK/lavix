local blink_cmp = require('blink.cmp')
local capabilities = blink_cmp.get_lsp_capabilities()

-- Global LSP capabilities
vim.lsp.config('*', {
  capabilities = capabilities,
})

local servers = {
  'basedpyright',
  'clangd',
  'rust_analyzer',
  'cmake',
  'ruff',
}

-- Add conditional servers
if not vim.g.nix_minimal_mode then
  table.insert(servers, 'nixd')
  table.insert(servers, 'zls')
  table.insert(servers, 'lua_ls')
  table.insert(servers, 'tinymist')
end

-- Enable all configured servers
vim.lsp.enable(servers)
