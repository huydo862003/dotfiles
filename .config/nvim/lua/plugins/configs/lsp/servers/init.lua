local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason = require("plugins.configs.lsp.mason")

-- Servers with custom configs (filename must match server name)
local custom_servers = {
  "lua_ls",
  "denols",
  "texlab",
  "ts_ls",
  "eslint",
  "ruff",
  "tinymist",
  "nil_ls",
}

-- Servers installed via Nix (not Mason)
local nix_servers = {
  "nil_ls",
}

-- Check if server has custom config
local function has_custom_config(server)
  for _, name in ipairs(custom_servers) do
    if name == server then
      return true
    end
  end
  return false
end

-- Setup Mason-managed servers
for _, server in ipairs(mason.servers) do
  local config

  if has_custom_config(server) then
    config = require("plugins.configs.lsp.servers." .. server)
    if type(config) == "function" then
      config = config()
    end
  else
    config = { capabilities = capabilities }
  end

  lspconfig[server].setup(config)
end

-- Setup Nix-provided servers (not managed by Mason)
for _, server in ipairs(nix_servers) do
  local config = require("plugins.configs.lsp.servers." .. server)
  if type(config) == "function" then
    config = config()
  end
  config.capabilities = capabilities
  lspconfig[server].setup(config)
end
