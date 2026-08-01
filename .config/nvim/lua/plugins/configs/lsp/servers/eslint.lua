local eslint_configs = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  ".eslintrc.json",
  ".eslintrc.cjs",
  ".eslintrc.mjs",
  ".eslintrc.js",
}

return {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
    format = true,
    codeActionOnSave = { enable = false, mode = "all" },
    run = "onType",
    validate = "on",
  },
  root_markers = eslint_configs,
  on_attach = function(client, bufnr)
    local root = client.root_dir
    if not root then return end
    local has_config = false
    for _, file in ipairs(eslint_configs) do
      if vim.fn.filereadable(root .. "/" .. file) == 1 then
        has_config = true
        break
      end
    end
    if not has_config then
      vim.notify("No ESLint config file found, detaching server.", vim.log.levels.WARN)
      client:stop()
    end
  end,
  single_file_support = false,
}
