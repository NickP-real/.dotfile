local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.api.nvim_command([[packadd packer.nvim]])
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
  pattern = "plugins.lua",
  command = "source <afile> | PackerCompile",
})

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

local function lazy(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      packer.loader(plugin)
    end, timer)
  end
end

packer.init({
  git = { clone_timeout = 6000 },
  profile = {
    enable = true,
    threshold = 1, -- the amount in ms that a plugin's load time must be over for it to be included in the profile
  },
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return packer.startup({
  function()
    -------------
    -- Startup --
    -------------

    use({
      -- Cache
      "lewis6991/impatient.nvim",

      -- Packer
      "wbthomason/packer.nvim",

      -- Load first
      { "nvim-lua/plenary.nvim", module = "plenary" },
      { "nvim-lua/popup.nvim", module = "popup" },
    })

    ---------------------------------
    -- Theme, Statusbar, Bufferbar --
    ---------------------------------

    use({
      {
        -- "ful1e5/onedark.nvim",
        "olimorris/onedarkpro.nvim",
        -- "navarasu/onedark.nvim",
        -- "RRethy/nvim-base16",
        -- "sainnhe/edge",
        -- "lunarvim/Onedarker.nvim"
        as = "theme",
        -- config = function()
        --   require("plugins.onedark")
        -- end,
      },
      { "kyazdani42/nvim-web-devicons", after = "theme" },

      -- Bufferline
      {
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        requires = "nvim-web-devicons",
        after = "theme",
        config = function()
          require("plugins.bufferline")
        end,
      },

      -- Statusline
      {
        "nvim-lualine/lualine.nvim",
        after = "theme",
        config = function()
          require("plugins.lualine")
        end,
      },
    })

    -- Float UI
    use({
      "stevearc/dressing.nvim",
      event = "BufRead",
      config = function()
        require("plugins.dressing")
      end,
    })

    -- First Page
    use({
      "goolord/alpha-nvim",
      event = "VimEnter",
      config = function()
        require("plugins.alpha")
      end,
    })

    ----------------
    -- Treesitter --
    ----------------

    use({
      {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        run = ":TSUpdate",
        config = function()
          require("plugins.treesitter")
        end,
      },
      { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
      { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
      { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
      {
        "andymass/vim-matchup",
        after = "nvim-treesitter",
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "popup", border = "rounded" }
        end,
      },
      { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" },
      {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
          require("plugins.treesitter-context")
        end,
      },
    })

    -- Log Highlight
    use({ "MTDL9/vim-log-highlighting", ft = "log" })

    --------
    -- UI --
    --------

    use({
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
      config = function()
        require("plugins.indent-blankline")
      end,
    })

    use({
      "norcalli/nvim-colorizer.lua",
      event = "BufRead",
      config = function()
        require("plugins.colorizer")
      end,
    })

    use({
      "lewis6991/gitsigns.nvim",
      event = "BufRead",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("plugins.gitsigns")
      end,
    })

    use({
      "folke/todo-comments.nvim",
      after = "nvim-treesitter",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("plugins.todo-comment")
      end,
    })

    use({
      "m-demare/hlargs.nvim",
      after = "nvim-treesitter",
      config = function()
        require("plugins.hlargs")
      end,
    })

    use({
      "kevinhwang91/nvim-ufo",
      -- after = { "nvim-treesitter", "nvim-lspconfig" },
      event = "BufRead",
      requires = "kevinhwang91/promise-async",
      config = function()
        require("plugins.nvim-ufo")
      end,
    })

    -- use({
    --   "folke/noice.nvim",
    --   event = "VimEnter",
    --   config = function()
    --     require("plugins.noice")
    --   end,
    --   requires = {
    --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --     "MunifTanjim/nui.nvim",
    --     "rcarriga/nvim-notify",
    --   },
    -- })

    ----------------
    -- Navigation --
    ----------------

    use({
      "kyazdani42/nvim-tree.lua",
      event = "BufRead",
      config = function()
        require("plugins.nvim-tree")
      end,
    })

    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-media-files.nvim",
      },
      cmd = "Telescope",
      module = "telescope",
      config = function()
        require("plugins.telescope_conf")
      end,
    })

    use({
      "phaazon/hop.nvim",
      branch = "v2", -- optional but strongly recommended
      cmd = { "HopChar1", "HopWord" },
      config = function()
        require("plugins.hop")
      end,
    })

    use({
      "declancm/cinnamon.nvim",
      event = "BufRead",
      config = function()
        require("plugins.cinnamon")
      end,
    })

    -- Terminal
    use({
      "akinsho/toggleterm.nvim",
      event = "CursorHold",
      config = function()
        require("plugins.toggleterm")
      end,
    })

    ---------
    -- LSP --
    ---------

    use({
      {
        "neovim/nvim-lspconfig",
        event = "BufRead",
        module = "lspconfig",
        requires = {
          "b0o/SchemaStore.nvim",
          "jose-elias-alvarez/typescript.nvim",
          "ray-x/lsp_signature.nvim",
          "mrshmllow/document-color.nvim",
          {
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig",
            config = function()
              require("plugins.nvim-navic")
            end,
          },
        },
        config = function()
          require("lsp.config")
          require("lsp.lspconfigs")
        end,
      },
      {
        "jose-elias-alvarez/null-ls.nvim",
        -- event = "BufRead",
        after = "nvim-lspconfig",
        config = function()
          require("lsp.null-ls")
        end,
      },
      {
        "lvimuser/lsp-inlayhints.nvim",
        after = "nvim-lspconfig",
        config = function()
          require("plugins.lsp-inlayhints")
        end,
      },
    })

    -- Mason, lsp installer
    use({
      {
        "williamboman/mason.nvim",
        event = "BufRead",
        config = function()
          require("lsp.mason")
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
          require("lsp.mason-lsp")
        end,
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        after = "mason.nvim",
        config = function()
          require("lsp.mason-tool-installer")
        end,
      },
    })

    -- Flutter
    use({
      {
        "akinsho/flutter-tools.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        ft = { "flutter", "dart" },
        after = "nvim-lspconfig",
        -- event = "BufRead",
        config = function()
          require("lsp.flutter")
        end,
      },
      {
        "akinsho/pubspec-assist.nvim",
        requires = "plenary.nvim",
        rocks = {
          {
            "lyaml",
            server = "http://rocks.moonscript.org",
            -- If using macOS or Ubuntu, you may need to install the `libyaml` package.
            -- if you install libyaml with homebrew you will need to set the YAML_DIR
            -- to the location of the homebrew installation of libyaml e.g.
            -- env = { YAML_DIR = '/opt/homebrew/Cellar/libyaml/0.2.5/' },
          },
        },
        ft = { "dart", "flutter", "yaml" },
        config = function()
          require("plugins.pubspec-assist")
        end,
      },
    })

    ---------------
    -- LSP Addon --
    ---------------

    use({
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
      module = "trouble",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("plugins.trouble")
      end,
    })
    use({ "folke/lsp-colors.nvim", after = "nvim-lspconfig" })

    -- LSP progress indicator
    use({
      "j-hui/fidget.nvim",
      after = "nvim-lspconfig",
      config = function()
        require("plugins.fidget")
      end,
    })

    -- use({
    --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --   after = "nvim-lspconfig",
    --   config = function()
    --     require("plugins.lsp_lines")
    --   end,
    -- })
    -- use("mfussenegger/nvim-lint")

    ----------------
    -- Completion --
    ----------------

    use({
      "rafamadriz/friendly-snippets",
      event = "InsertEnter",
      module = { "cmp", "cmp_nvim_lsp" },
    })

    use({
      "L3MON4D3/LuaSnip",
      wants = "friendly-snippets",
      after = "nvim-cmp",
      config = function()
        require("plugins.luasnip")
      end,
    })

    use({

      { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
      { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
      { "hrsh7th/cmp-path", after = "cmp-buffer" },
    })

    use({
      {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        config = function()
          require("plugins.cmp")
        end,
        requires = {
          "lukas-reineke/cmp-under-comparator",
        },
      },
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
      -- { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
      { "mtoohey31/cmp-fish", after = "cmp-nvim-lsp", ft = "fish" },
      {
        "danymat/neogen",
        after = "nvim-cmp",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
          require("plugins.neogen")
        end,
      },
    })

    -------------
    -- Editing --
    -------------

    use({
      "numToStr/Comment.nvim",
      event = "BufRead",
      after = "nvim-treesitter",
      config = function()
        require("plugins.comment")
      end,
    })

    use({
      "kylechui/nvim-surround",
      event = "CursorHold",
      config = function()
        require("plugins.nvim-surround")
      end,
    })

    use({
      "abecodes/tabout.nvim",
      wants = "nvim-treesitter",
      after = "nvim-cmp",
      config = function()
        require("plugins.tabout")
      end,
    })

    use({
      "windwp/nvim-autopairs",
      event = "InsertCharPre",
      after = { "nvim-treesitter", "nvim-cmp" },
      config = function()
        require("plugins.autopairs")
      end,
    })

    use({
      "monaqa/dial.nvim",
      event = "CursorHold",
      config = function()
        require("plugins.dial")
      end,
    })

    use({
      "axelvc/template-string.nvim",
      key = "$",
      ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      config = function()
        require("plugins.template-string")
      end,
    })

    use({
      "mizlan/iswap.nvim",
      cmd = "ISwap",
      config = function()
        require("plugins.iswap")
      end,
    })

    ---------
    -- Git --
    ---------

    use({
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      event = "CursorHold",
      config = function()
        require("plugins.neogit")
      end,
    })

    use({
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
      event = "BufRead",
      config = function()
        require("plugins.diffview")
      end,
    })

    ----------------------------
    -- Debug Adapter Protocol --
    ----------------------------

    use({
      {
        "mfussenegger/nvim-dap",
        module = "dap",
        config = function()
          require("plugins.dap")
        end,
      },
      { "rcarriga/nvim-dap-ui", module = "dapui" },
    })

    ---------------
    -- Previewer --
    ---------------

    -- Markdown
    use({
      { "ellisonleao/glow.nvim", event = "CursorHold", ft = "markdown" },
      {
        "iamcco/markdown-preview.nvim",
        event = "CursorHold",
        ft = "markdown",
        run = "cd app && yarn install",
        cmd = "MarkdownPreview",
      },
    })

    -- HTML
    use({
      "turbio/bracey.vim",
      event = "CursorHold",
      ft = { "html", "css", "javascript" },
      run = "npm install --prefix server",
      config = function()
        vim.g.bracey_refresh_on_save = 1
      end,
    })

    -------------
    -- Utility --
    -------------

    -- Discord Presence
    use({ "andweeb/presence.nvim", event = "BufRead" })

    -- Symbols Outline
    use({
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      config = function()
        require("plugins.symbol-outline")
      end,
    })

    -- Session Manager
    use({
      "Shatur/neovim-session-manager",
      cmd = "SessionManager",
      config = function()
        require("plugins.session-manager")
      end,
    })

    -- Startuptime
    use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

    use({ "wsdjeg/vim-fetch", event = "CursorHold" })
    use({ "famiu/bufdelete.nvim", cmd = "Bdelete" })
    use({
      "kwkarlwang/bufresize.nvim",
      event = "BufRead",
      config = function()
        require("plugins.bufresize")
      end,
    })
    use({
      "jghauser/mkdir.nvim",
      event = "BufRead",
    })
    use({
      "kevinhwang91/nvim-bqf",
      ft = "qf",
      config = function()
        require("plugins.nvim-bqf")
      end,
    })

    -- Notify
    use({
      "rcarriga/nvim-notify",
      config = function()
        require("plugins.notify")
      end,
      event = "BufRead",
      module = "notify",
    })

    -- Search
    use({ "haya14busa/vim-asterisk", event = "CursorHold" })

    -- for highlight
    use({
      "kevinhwang91/nvim-hlslens",
      after = "vim-asterisk",
      event = "CursorHold",
      config = function()
        require("plugins.hlslens")
      end,
    })

    -- Tmux
    use({
      "aserowy/tmux.nvim",
      event = "BufRead",
      config = function()
        require("plugins.tmux")
      end,
    })

    -- Swap the split
    use({ "xorid/swap-split.nvim", cmd = "SwapSplit" })

    if PACKER_BOOSTRAP then
      require("packer").sync()
    end
  end,
})
