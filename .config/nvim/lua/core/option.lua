local opt = vim.opt
local g = vim.g

-- Config
opt.autowriteall = true
opt.completeopt = "menu,menuone,noselect"
opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
opt.mouse = "a"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.shell = "fish"
opt.showbreak = string.rep(" ", 3)
opt.shortmess:append("c")
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.title = true
opt.wildoptions = "pum"
opt.winfixwidth = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- UI
-- opt.cmdheight = 0
opt.cursorline = true
-- opt.foldcolumn = "1"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldnestmax = 0
-- opt.foldmethod = "expr"
opt.guicursor:append({ "n-i:blinkon1" })
opt.laststatus = 3
opt.number = true
opt.numberwidth = 4
opt.pumheight = 10
opt.relativenumber = true
opt.ruler = false
opt.showmode = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.winminwidth = 10

-- Indenting
opt.breakindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- fix markdown indent
g.markdown_recommended_style = 0

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Text Thing
opt.linebreak = true
opt.whichwrap:append("<,>,[,],h,l")

-- Performance
opt.redrawtime = 1500
opt.timeoutlen = 300
opt.ttimeoutlen = 25
opt.updatetime = 200

-- grep
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Session
g.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Leader key
g.mapleader = " "

-- Clipboard
g.clipboard = {
  name = "xsel",
  copy = {
    ["+"] = "xsel -i -b",
    ["*"] = "xsel -i -p",
  },
  paste = {
    ["+"] = "xsel -o -b",
    ["*"] = "xsel -o -p",
  },
  cache_enabled = 0,
}
-- opt.clipboard = "unnamedplus"

-- Border and hide STL
opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  stl = " ",
  stlnc = " ",
  eob = " ",
  diff = "╱",
  -- fold = " ",
  -- foldopen = "",
  -- foldsep = " ",
  -- foldclose = "",
}

-- env
g.python3_host_prog = "/usr/bin/python3"
