local status_ok, toggle_term = pcall(require, "toggleterm")
if not status_ok then
  return
end

local function set_nvimtree_when_open_term(terminal)
  local nvimtree = require("nvim-tree")
  local nvimtree_view = require("nvim-tree.view")
  if nvimtree_view.is_visible() and terminal.direction == "horizontal" then
    local nvimtree_width = vim.fn.winwidth(nvimtree_view.get_winnr())
    nvimtree.toggle()
    nvimtree_view.View.width = nvimtree_width
    nvimtree.toggle(false, true)
  end
end

toggle_term.setup({
  -- size can be a number or function which is passed the current terminal
  size = function(term) -- size = 20,
    if term.direction == "horizontal" then
      return 10
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-_>]],
  on_open = function(terminal)
    set_nvimtree_when_open_term(terminal)
  end, -- function to run when the terminal opens
  -- on_close = fun(t: Terminal), -- function to run when the terminal closes
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = "horizontal", --'vertical' | 'horizontal' | 'window' | 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = "curved", --'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    -- width = <value>,
    -- height = <value>,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  -- highlights = {
  -- 	-- highlights which map to a highlight group name and a table of it's values
  -- 	-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
  -- 	Normal = {
  -- 		guibg = "#21252b",
  -- 		-- link = "Normal",
  -- 	},
  -- 	NormalFloat = {
  -- 		link = "Normal",
  -- 	},
  -- },
})
