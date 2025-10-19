return {
  -- Using Lazy
  {
    'webhooked/kanso.nvim',
    lazy = false,
    priority = 1000,

    config = function()
      -- Default options:
      require('kanso').setup {
        bold = true, -- enable bold fonts
        italics = true, -- enable italics
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = {},
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { zen = {}, pearl = {}, ink = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = 'zen', -- Load "zen" theme
        background = { -- map the value of 'background' option to a theme
          dark = 'zen', -- try "ink" !
          light = 'pearl', -- try "mist" !
        },
      }

      -- setup must be called before loading
      -- vim.cmd 'colorscheme kanso'
    end,
  },
  {
    'zenbones-theme/zenbones.nvim',
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    config = function()
      vim.g.zenbones_darken_comments = 45
      vim.cmd.colorscheme 'seoulbones'
    end,
  },
  {
    'RostislavArts/naysayer.nvim',
    priority = 1000,
    lazy = false,
    -- config = function()
    --   vim.cmd.colorscheme 'naysayer'
    -- end,
  },
  {
    'savq/melange-nvim',

    config = function()
      -- vim.cmd.colorscheme 'melange'
    end,
  },
}
