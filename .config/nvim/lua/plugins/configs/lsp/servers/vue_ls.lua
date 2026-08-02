return function()
  local mason_registry = require("mason-registry")
  local typescript_path = mason_registry.get_package("typescript-language-server"):get_install_path()
    .. "/node_modules/typescript/lib"

  return {
    -- Hybrid mode: vue_ls handles Vue-specific features, ts_ls handles TypeScript
    -- ts_ls must have @vue/typescript-plugin in init_options for this to work
    init_options = {
      typescript = {
        tsdk = typescript_path,
      },
    },
  }
end
