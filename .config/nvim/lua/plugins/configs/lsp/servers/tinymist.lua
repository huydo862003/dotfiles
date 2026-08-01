return {
  root_markers = { "main.typ", ".git" },
  offset_encoding = "utf-8",
  settings = {
    exportPdf = "onType",
    formatterMode = "typstyle",
    formatterPrintWidth = 80,
    outputPath = "$root/target/$dir/$name",
  },
  on_attach = function(client, bufnr)
    local root = vim.fs.root(0, { "main.typ" })
    if root then
      vim.lsp.buf.execute_command({
        command = "tinymist.pinMain",
        arguments = { vim.fs.joinpath(root, "main.typ") },
      })
    end
  end,
}
