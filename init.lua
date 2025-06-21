-- Plugin Manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Function to Run Code (Fixed)
function _run_code()
  local filetype = vim.bo.filetype
  local cmd = {
    java = "javac % && java %:r",
    python = "python3 %",
    c = "gcc % -o %:r && ./%:r",
    cpp = "g++ % -o %:r && ./%:r",
  }
  if cmd[filetype] then
    vim.cmd("TermExec cmd='" .. cmd[filetype] .. "'")
  else
    print("No run command for filetype: " .. filetype)
  end
end

-- Load Plugins
require("lazy").setup({
  -- Tokyo Night Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Dashboard (Start Page)
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
    " ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ",
    " ████╗  ██║██║   ██║██║████╗ ████║ ",
    " ██╔██╗ ██║██║   ██║██║██╔████╔██║ ",
    " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "Welcome to Neovim!",
          },
          center = {
            { icon = "  ", desc = " Find File", action = "Telescope find_files" },
            { icon = "  ", desc = " Recent Files", action = "Telescope oldfiles" },
            { icon = "  ", desc = " Find Word", action = "Telescope live_grep" },
            { icon = "  ", desc = " Bookmarks", action = "Telescope marks" },
            { icon = "  ", desc = " Start Coding", action = ":ene" },
          },
          footer = { "Crafted with Neovim & Lazy.nvim" },
        },
      })
    end,
  },

    -- ToggleTerm for running code
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-t>]],
        direction = "float",
        shell = vim.o.shell,
      })
    end,
  },

  -- Treesitter (Syntax Highlighting & Better Code Parsing)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = { enable = true },
      })
    end,
  },

  -- Lualine (Modern Status Line)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- File Explorer (nvim-tree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "NvimTreeToggle",
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
        renderer = { icons = { show = { folder = true, file = true } } },
      })
    end,
  },

  -- Telescope (Fuzzy Finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },

  -- Git Integration
  {
    "tpope/vim-fugitive",
   event = "BufReadPre",
  },

  -- Commenting Utility
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Autocompletion (nvim-cmp + LuaSnip)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- Transparent Background (for aesthetic look)
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        enable = true,
        extra_groups = { "Normal", "NormalNC", "EndOfBuffer" },
      })
    end,
  },

  -- Icons for UI Enhancements
  "kyazdani42/nvim-web-devicons",
})

-- Set Tokyo Night Theme
vim.cmd([[colorscheme tokyonight]])

-- Enable Transparency
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Key Mappings
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true })

-- Key Mapping for Running Code (Fixed)
vim.keymap.set("n", "<leader>r", ":lua _run_code()<CR>", { noremap = true, silent = true })

-- Enable Clipboard & Mouse Support
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
vim.opt.mouse = "a"                -- Enable mouse support
