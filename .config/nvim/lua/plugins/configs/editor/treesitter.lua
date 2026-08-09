local ts = require("nvim-treesitter")

ts.setup({
  -- install_dir defaults to stdpath("data") .. "/site"
})

local ensure_installed = {
  "c", "lua", "rust", "ruby", "vim", "javascript", "typescript", "cpp", "nix",
}
ts.install(ensure_installed)

-- highlight + indent + auto_install, all folded into one autocmd
local function attach(buf, lang)
  if not vim.treesitter.language.add(lang) then
    return false
  end
  vim.treesitter.start(buf, lang)
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  return true
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- skip plugin buffers (nvim-tree, telescope, lazy, mason, quickfix, terminals)
    if vim.bo[args.buf].buftype ~= "" then return end

    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end

    if attach(args.buf, lang) then return end

    -- auto_install: parser not present, fetch it then retry
    if not vim.tbl_contains(ts.get_available(), lang) then return end
    ts.install(lang):await(function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          attach(args.buf, lang)
        end
      end)
    end)
  end,
})

-- textobjects (main branch)
require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    include_surrounding_whitespace = true,
  },
  move = {
    set_jumps = false,
  },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local map = vim.keymap.set

for lhs, obj in pairs({
  ["af"] = "@function.outer",
  ["if"] = "@function.inner",
  ["ac"] = "@class.outer",
  ["ic"] = "@class.inner",
  ["as"] = "@local.scope",
}) do
  map({ "x", "o" }, lhs, function()
    select.select_textobject(obj, obj == "@local.scope" and "locals" or "textobjects")
  end)
end

map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
map({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end,
  { desc = "Next class start" })

map({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
map({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end)

map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)

map({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
map({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)
