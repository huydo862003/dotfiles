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
  handlers = {
    -- Required for the server to actually run eslint (without this it stays disabled)
    ["eslint/confirmESLintExecution"] = function() return 4 end,
    ["eslint/noLibrary"] = function()
      vim.notify("ESLint: no eslint library found", vim.log.levels.WARN)
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("ESLint: probe failed", vim.log.levels.WARN)
    end,
  },
  root_markers = eslint_configs,
  single_file_support = false,
}
