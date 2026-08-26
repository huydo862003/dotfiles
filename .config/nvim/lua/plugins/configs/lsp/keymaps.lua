vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>li", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>lf", function()
  -- Run prettier first (sync), then eslint fixes so there's no intermediate flash
  local prettier_configs = {
    ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml",
    ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
    "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs", ".prettierrc.toml",
  }
  local root = vim.fs.root(0, prettier_configs)
  if root then
    vim.lsp.buf.format({ async = false, filter = function(c) return c.name ~= "eslint" end })
    local eslint_clients = vim.lsp.get_clients({ bufnr = 0, name = "eslint" })
    if #eslint_clients > 0 then
      vim.lsp.buf.format({ async = false, filter = function(c) return c.name == "eslint" end })
    end
    return
  end
  -- Fall through to any available LSP formatter
  vim.lsp.buf.format({ async = false })
end, {})
vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, {})
vim.keymap.set("n", "<leader>lc", vim.lsp.buf.outgoing_calls, {})
vim.keymap.set("n", "<leader>lo", vim.diagnostic.open_float, {})

vim.diagnostic.config({ update_in_insert = true })
