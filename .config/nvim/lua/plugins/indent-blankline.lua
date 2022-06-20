local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
  return
end

indent_blankline.setup({
  indentLine_enabled = 1,
  show_current_context = true,
  -- show_current_context_start = true,
  use_treesitter = true,
  char = "▏",
  buftype_exclude = { "terminal", "help", "nofile", "prompt", "popup" },
  filetype_exclude = {
    "alpha",
    "packer",
    "TelescopePrompt",
    "TelescopeResults",
    "terminal",
    "help",
    "lsp-installer",
    "log",
    "Outline",
    "Trouble",
  },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
})
