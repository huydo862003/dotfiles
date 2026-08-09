local M = {}

M.servers = {
  "denols",
  "ruff",
  "lua_ls",
  "rust_analyzer",
  "ast_grep",
  "jdtls",
  "cssls",
  "dockerls",
  "eslint",
  "html",
  "marksman",
  "tailwindcss",
  "ts_ls",
  "jsonls",
  "pyright",
  "golangci_lint_ls",
  "vue_ls",
  "sqls",
  "elp",
  "clangd",
  "tinymist",
  "texlab",
}

require("mason").setup({
  PATH = "append", -- Prioritize system packages, for Nix
})

require("mason-lspconfig").setup({
  ensure_installed = M.servers,
})

return M
