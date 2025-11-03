return {
  -- Live-render markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  -- Manage screenshots and figures
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<leader>P', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },

  --  [markdown markmap]
  --  https://github.com/Zeioth/markmap.nvim
  {
    'Zeioth/markmap.nvim',
    build = 'yarn global add markmap-cli',
    cmd = { 'MarkmapOpen', 'MarkmapSave', 'MarkmapWatch', 'MarkmapWatchStop' },
    opts = {
      html_output = '/tmp/markmap.html', -- (default) Setting a empty string "" here means: [Current buffer path].html
      hide_toolbar = false, -- (default)
      grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts)
      require('markmap').setup(opts)
    end,
  },
}
