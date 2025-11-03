return {
  -- AI assisted editing
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        provider = 'openai',
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            accept = '<A-A>',
            accept_line = '<A-a>',
            accept_n_lines = '<A-z>',
            prev = '<A-[>',
            next = '<A-]>',
            dismiss = '<A-e>',
          },
        },
      }
    end,
  },
  {
    'saghen/blink.cmp',
    optional = true,
    opts = {
      keymap = {
        ['<A-y>'] = {
          function(cmp)
            cmp.show { providers = { 'minuet' } }
          end,
        },
      },
    },
  },

  -- Local agent workflows
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
      vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask about this' })
      vim.keymap.set({ 'n', 'x' }, '<leader>os', function()
        require('opencode').select()
      end, { desc = 'Select prompt' })
      vim.keymap.set({ 'n', 'x' }, '<leader>o+', function()
        require('opencode').prompt '@this'
      end, { desc = 'Add this' })
      vim.keymap.set('n', '<leader>ot', function()
        require('opencode').toggle()
      end, { desc = 'Toggle embedded' })
      vim.keymap.set('n', '<leader>oc', function()
        require('opencode').command()
      end, { desc = 'Select command' })
      vim.keymap.set('n', '<leader>on', function()
        require('opencode').command 'session_new'
      end, { desc = 'New session' })
      vim.keymap.set('n', '<leader>oi', function()
        require('opencode').command 'session_interrupt'
      end, { desc = 'Interrupt session' })
      vim.keymap.set('n', '<leader>oA', function()
        require('opencode').command 'agent_cycle'
      end, { desc = 'Cycle selected agent' })
      vim.keymap.set('n', '<S-C-u>', function()
        require('opencode').command 'messages_half_page_up'
      end, { desc = 'Messages half page up' })
      vim.keymap.set('n', '<S-C-d>', function()
        require('opencode').command 'messages_half_page_down'
      end, { desc = 'Messages half page down' })
    end,
  },

  -- Git integration
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
  },
}
