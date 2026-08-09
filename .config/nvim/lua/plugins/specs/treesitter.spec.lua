return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang then return end

        local installed = ts.get_installed()
        if vim.tbl_contains(installed, lang) then
          pcall(vim.treesitter.start, args.buf, lang)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          return
        end

        -- auto_install: only for langs that actually exist upstream
        if not vim.tbl_contains(ts.get_available(), lang) then return end
        ts.install(lang):await(function()
          pcall(vim.treesitter.start, args.buf, lang)
        end)
  end,
})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
  },
}
