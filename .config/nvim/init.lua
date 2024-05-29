require("config.options")
require("config.filetypes")
require("config.styles")
require("config.lazy")

local group = vim.api.nvim_create_augroup("startup_lazy_load", { clear = true })
vim.api.nvim_create_autocmd("User", {
  desc = "lazy load on startup",
  group = group,
  pattern = "VeryLazy",
  callback = function()
    require("config.mappings")
    require("config.autocmds")
    require("config.usercmds")
  end,
})
