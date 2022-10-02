-- Var
local bind = function(op, outer_opts)
  outer_opts = vim.tbl_extend("force", { silent = true }, outer_opts or {})
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", outer_opts, opts or {})
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

local nmap = bind("n", { noremap = false })
local nnoremap = bind("n")
local vnoremap = bind("v")
local xnoremap = bind("x")
local inoremap = bind("i")
local nxonoremap = bind({"n", "x", "o"})

-- Spacebar to nothing
nnoremap("<Space>", "<Nop>")

-- Save
nnoremap("<C-s>", ":w<CR>")
inoremap("<C-s>", "<Esc>:w<Cr>a")

-- Visual indent
vnoremap(">", ">gv")
vnoremap("<", "<gv")

-- Better enter insert mode on blank line
inoremap("i", function()
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil
      and vim.bo.filetype ~= "toggleterm"
      and vim.bo.filetype ~= "TelescopePrompt"
      and "cc"
    or "i"
end, { expr = true })

-- delete a character without yank into register
nnoremap("x", '"_x')
nnoremap("X", '"_X')
vnoremap("x", '"_x')
vnoremap("X", '"_X')

-- Don't yank on visual paste
vnoremap("p", '"_dP')

-- paste
xnoremap("<leader>p", '"_dP')

-- delete blank line without yank into register
local function smart_dd()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  end
  return "dd"
end

nnoremap("dd", smart_dd, { expr = true })

-- Delete buffer
nnoremap("<C-c>", ":Bdelete<cr>")
nnoremap("<C-q>", ":bd<cr>")

-- Increment/Decrement
nnoremap("+", "<C-a>")
nnoremap("-", "<C-x>")

-- Ctrl-W to Alt
nnoremap("<A-h>", "<C-w>h")
nnoremap("<A-j>", "<C-w>j")
nnoremap("<A-k>", "<C-w>k")
nnoremap("<A-l>", "<C-w>l")
nnoremap("<A-o>", "<C-w>o")
nnoremap("<A-w>", "<C-w>w")

-- Split
nnoremap("<leader>ss", ":split<cr><C-w>w")
nnoremap("<leader>sv", ":vsplit<cr><C-w>w")

-- Split resize
nnoremap("<A-Up>", ":resize +2<cr>")
nnoremap("<A-Down>", ":resize -2<cr>")
nnoremap("<A-Left>", ":vertical resize -2<cr>")
nnoremap("<A-Right>", ":vertical resize +2<cr>")

-- Tab
nnoremap("<leader>te" , ":tabedit<cr>")
nnoremap("<leader>tq" , ":tabclose<cr>")

-- Keep it center
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")

-- Undo break points
inoremap(",", ",<C-g>u")
inoremap(".", ".<C-g>u")
inoremap("!", "!<C-g>u")
inoremap("?", "?<C-g>u")

-- Moving text
nnoremap("<leader>j" , ":m .+1<cr>==")
nnoremap("<leader>k" , ":m .-2<cr>==")
inoremap("<C-j>", "<Esc>:m .+1<CR>==gi")
inoremap("<C-k>", "<Esc>:m .-2<CR>==gi")
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- Select All Text
nnoremap("<leader>a" , ":keepjumps normal! ggVG<cr>")

-- Format Async on save
vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])

-- Clear highlight
nnoremap("<c-h>", ":nohlsearch<cr>")

-- LSP
nnoremap('<space>e', vim.diagnostic.open_float)
nnoremap('[d', vim.diagnostic.goto_prev)
nnoremap(']d', vim.diagnostic.goto_next)
nnoremap('<space>q', vim.diagnostic.setloclist)

-- Coderunner
nnoremap("<leader>r" , ":Run<cr>")
nnoremap("<leader>R" , ":RunUpdate<cr>")

------------
-- Plugin --
------------

-- NvimTree
nnoremap("<C-n>", ":NvimTreeToggle<cr>")
nnoremap("<leader>nr", ":NvimTreeRefresh<cr>")

-- Toggle Terminal
vim.api.nvim_create_autocmd("TermOpen", {
  -- pattern = "term://*toggleterm#*",
  callback = function()
    local opts = { noremap = true, silent = true }
    vim.schedule(function()
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<A-h>", [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<A-j>", [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<A-k>", [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<A-l>", [[<C-\><C-n><C-W>l]], opts)
    end)
  end,
})

-- Buffer line
nnoremap("<Tab>", ":BufferLineCycleNext<CR>")
nnoremap("<S-Tab>", ":BufferLineCyclePrev<CR>")

-- Hop
nnoremap("s", ":HopChar1<cr>")
nnoremap("S", ":HopWord<cr>")

local hopHorizontal = require("hop").hint_char1
local hintDirection = require("hop.hint").HintDirection

nxonoremap("f", function ()
  hopHorizontal({direction = hintDirection.AFTER_CURSOR, current_line_only = true})
end)
nxonoremap("F", function ()
  hopHorizontal({direction = hintDirection.BEFORE_CURSOR, current_line_only = true})
end)
nxonoremap("t", function ()
  hopHorizontal({direction = hintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1})
end)
nxonoremap("T", function ()
  hopHorizontal({direction = hintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1})
end)

-- Hlslens
nnoremap("*", [[<Plug>(asterisk-z*):lua require('hlslens').start()<CR>]])
nnoremap("#", [[<Plug>(asterisk-z#):lua require('hlslens').start()<CR>]])
nnoremap("g*", [[<Plug>(asterisk-gz*):lua require('hlslens').start()<CR>]])
nnoremap("g#", [[<Plug>(asterisk-gz#):lua require('hlslens').start()<CR>]])

xnoremap("*", [[<Plug>(asterisk-z*):lua require('hlslens').start()<CR>]])
xnoremap("#", [[<Plug>(asterisk-z#):lua require('hlslens').start()<CR>]])
xnoremap("g*", [[<Plug>(asterisk-gz*):lua require('hlslens').start()<CR>]])
xnoremap("g#", [[<Plug>(asterisk-gz#):lua require('hlslens').start()<CR>]])

-- UFO
nnoremap("zR", ":lua require('ufo').openAllFolds()<cr>")
nnoremap("zM", ":lua require('ufo').closeAllFolds()<cr>")
-- nnoremap("zr", ":lua require('ufo').openFoldsExceptKinds()<cr>")
-- nnoremap("zm", ":lua require('ufo').closeFoldsWith(0)<cr>")

-- Dial
nnoremap("<C-a>", require("dial.map").inc_normal())
nnoremap("<C-x>", require("dial.map").dec_normal())
vnoremap("<C-a>", require("dial.map").inc_visual())
vnoremap("<C-x>", require("dial.map").dec_visual())
vnoremap("g<C-a>", require("dial.map").inc_gvisual())
vnoremap("g<C-x>", require("dial.map").dec_gvisual())

-- ISwap
nnoremap("<leader>sw", ":ISwap<cr>")

-- Telescope
nnoremap("<leader>ff", ":Telescope find_files<cr>")
nnoremap("<leader>fg", ":Telescope live_grep<cr>")
nnoremap("<leader>fb" , ":Telescope buffers<cr>")
nnoremap("<leader>fh" , ":Telescope help_tags<cr>")
nnoremap("<leader>fo" , ":Telescope oldfiles<cr>")
nnoremap("<leader>fn" , ":Telescope file_browser<cr>")
nnoremap("<leader>fN" , ":Telescope file_browser path=%:p:h<cr>")


-- Trouble
nnoremap("<leader>xx" , ":TroubleToggle<cr>")
nnoremap("<leader>xw" , ":TroubleToggle workspace_diagnostics<cr>")
nnoremap("<leader>xd" , ":TroubleToggle document_diagnostics<cr>")
nnoremap("<leader>xq" , ":TroubleToggle quickfix<cr>")
nnoremap("<leader>xl" , ":TroubleToggle loclist<cr>")
nnoremap("<leader>xr" , ":TroubleToggle lsp_references<cr>")
nnoremap("<leader>xt" , ":TodoTrouble<cr>")

-- Symbols Outline
nnoremap("<leader>so", ":SymbolsOutline<cr>")

-- Session Manager
nnoremap("<leader>sl" , ":SessionManager load_last_session<cr>")
nnoremap("<leader>so" , ":SessionManager load_session<cr>")

-- Git
nnoremap("<leader>gs", ":Neogit<cr>")
-- nnoremap("<leader>gh" , ":diffget //2<cr>")
-- nnoremap("<leader>gl" , ":diffget //3<cr>")

-- Diffview
nnoremap("<leader>dd" , ":DiffviewOpen<cr>")
nnoremap("<leader>df" , ":DiffviewFileHistory %<cr>")
nnoremap("<leader>dF" , ":DiffviewFileHistory<cr>")

-- Neogen
nnoremap("<leader>nf" , ":Neogen func<cr>")
nnoremap("<leader>nc" , ":Neogen class<cr>")
nnoremap("<leader>nt" , ":Neogen type<cr>")

-- Bufferline
nnoremap("<leader><Tab>" , ":BufferLineMoveNext<CR>")
nnoremap("<leader><S-Tab>" , ":BufferLineMovePrev<CR>")

-- LSP line
-- nnoremap("<Leader>l", ": lua require('lsp_lines').toggle<cr>")
