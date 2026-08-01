local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason = require("plugins.configs.lsp.mason")

local custom_configs = {
  ["lua_ls"] = true,
  ["denols"] = true,
  ["texlab"] = true,
  ["ts_ls"] = true,
  ["eslint"] = true,
  ["ruff"] = true,
  ["tinymist"] = true,
  ["nil_ls"] = true,
}

local function setup(server)
  local config = {}
  if custom_configs[server] then
    config = require("plugins.configs.lsp.servers." .. server)
    if type(config) == "function" then
      config = config()
    end
  end
  config.capabilities = config.capabilities or capabilities
  vim.lsp.config(server, config)
end

-- Mason-managed servers
for _, server in ipairs(mason.servers) do
  setup(server)
end

-- Nix-provided servers (not managed by Mason)
setup("nil_ls")

vim.lsp.enable(vim.list_extend(mason.servers, { "nil_ls" }))
