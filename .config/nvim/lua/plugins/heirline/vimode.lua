local M = {}
M.label = {
  n = "NORMAL",
  op = "OP",
  v = "VISUAL",
  v_line = "VISUAL_LINE",
  v_block = "VISUAL_BLOCK",
  s = "SELECT",
  block = "BLOCK",
  i = "INSERT",
  r = "REPLACE",
  vr = "V_REPLACE",
  c = "COMMAND",
  e = "ENTER",
  m = "MORE",
  confirm = "CONFIRM",
  sh = "SHELL",
  t = "TERMINAL",
}

M.display = {
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = "n",
      no = "op",
      nov = "op",
      noV = "op",
      ["no\22"] = "op",
      niI = "n",
      niR = "n",
      niV = "n",
      nt = "n",
      v = "v",
      vs = "v",
      V = "v_line",
      Vs = "v_line",
      ["\22"] = "v_block",
      ["\22s"] = "v_block",
      s = "s",
      S = "s",
      ["\19"] = "block",
      i = "i",
      ic = "i",
      ix = "i",
      R = "r",
      Rc = "r",
      Rx = "r",
      Rv = "vr",
      Rvc = "vr",
      Rvx = "vr",
      c = "c",
      cv = "c",
      r = "e",
      rm = "m",
      ["r?"] = "confirm",
      ["!"] = "sh",
      t = "t",
    },
    mode_colors = {
      n = "red",
      i = "green",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan",
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple",
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "red",
    },
  },
  provider = function(self)
    return "%2(" .. M.label[self.mode_names[self.mode]] .. "%)"
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

return M
