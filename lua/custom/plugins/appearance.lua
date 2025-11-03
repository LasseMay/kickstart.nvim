return {
  -- Colorschemes
  {
    'webhooked/kanso.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanso').setup {
        bold = true,
        italics = true,
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = {},
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { zen = {}, pearl = {}, ink = {}, all = {} },
        },
        overrides = function(_colors)
          return {}
        end,
        theme = 'zen',
        background = {
          dark = 'zen',
          light = 'pearl',
        },
      }
    end,
  },
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenbones_darken_comments = 45
      vim.cmd.colorscheme 'kanagawabones'
    end,
  },
  {
    'RostislavArts/naysayer.nvim',
    priority = 1000,
    lazy = false,
  },
  {
    'savq/melange-nvim',
    config = function()
      -- vim.cmd.colorscheme 'melange'
    end,
  },

  -- Focus and writing ambience
  {
    'folke/zen-mode.nvim',
    opts = {},
  },
}
