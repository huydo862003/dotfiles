local capabilities = require("cmp_nvim_lsp").default_capabilities()

return function()
  local mason_registry = require("mason-registry")
  local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
    .. "/node_modules/@vue/language-server"

  return {
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
        },
      },
    },
    capabilities = capabilities,
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    root_markers = { "package.json" },
    single_file_support = false,
  }
end
