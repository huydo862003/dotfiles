require("transparent").setup({
  groups = {
    "Normal",
    "NormalNC",
    "LineNr",
    "NonText",
    "SignColumn",
    "CursorLine",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
    "EndOfBuffer",
  },
  extra_groups = {},
  exclude_groups = {},
  on_clear = function() end,
})
