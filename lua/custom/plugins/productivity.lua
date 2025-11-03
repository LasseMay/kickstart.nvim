return {
  -- Search and replace across projects
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>sR',
        function()
          local grug = require 'grug-far'
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          }
        end,
        mode = { 'n', 'v' },
        desc = '[s]earch and [R]eplace (grug-far)',
      },
    },
  },

  -- Inspect and edit CSV/TSV files
  {
    'hat0uma/csvview.nvim',
    ---@module 'csvview'
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  },

  -- Keep an interactive REPL close at hand
  {
    'Vigemus/iron.nvim',
    keys = {
      { '<leader>rs', '<cmd>IronRepl<cr>', desc = 'Toggle REPL' },
      { '<leader>rr', '<cmd>IronRestart<cr>', desc = 'Restart REPL' },
      { '<leader>rf', '<cmd>IronFocus<cr>', desc = 'Focus REPL' },
      { '<leader>rh', '<cmd>IronHide<cr>', desc = 'Hide REPL' },
    },
    config = function()
      local iron = require 'iron.core'
      local view = require 'iron.view'

      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { 'zsh' },
            },
            python = {
              command = { 'uv', 'run', 'python' },
              format = require('iron.fts.common').bracketed_paste,
            },
            javascript = {
              command = { 'node' },
            },
            typescript = {
              command = { 'npx', 'ts-node' },
            },
            lua = {
              command = { 'lua' },
            },
            r = {
              command = { 'R', '--no-save' },
            },
            julia = {
              command = { 'julia' },
            },
            ruby = {
              command = { 'irb' },
            },
            scala = {
              command = { 'scala' },
            },
            clojure = {
              command = { 'lein', 'repl' },
            },
            haskell = {
              command = { 'ghci' },
            },
            elixir = {
              command = { 'iex' },
            },
            erlang = {
              command = { 'erl' },
            },
            go = {
              command = { 'gore' },
            },
            rust = {
              command = { 'evcxr' },
            },
            php = {
              command = { 'php', '-a' },
            },
            perl = {
              command = { 'perl', '-de', '0' },
            },
          },
          repl_open_cmd = view.split.vertical.botright(50),
        },
        keymaps = {
          send_motion = '<leader>rc',
          visual_send = '<leader>rc',
          send_file = '<leader>rf',
          send_line = '<leader>rl',
          send_paragraph = '<leader>rp',
          send_until_cursor = '<leader>ru',
          send_mark = '<leader>rm',
          mark_motion = '<leader>rmc',
          mark_visual = '<leader>rmc',
          remove_mark = '<leader>rmd',
          cr = '<leader>r<cr>',
          interrupt = '<leader>r<space>',
          exit = '<leader>rq',
          clear = '<leader>rx',
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      }

      vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>', { desc = 'Toggle REPL' })
      vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>', { desc = 'Restart REPL' })
      vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
      vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = 'Hide REPL' })
      vim.keymap.set('v', '<leader>rc', "<cmd>lua require('iron.core').visual_send()<cr>", { desc = 'Send visual selection to REPL' })
      vim.keymap.set('n', '<leader>rc', "<cmd>lua require('iron.core').send_motion()<cr>", { desc = 'Send motion to REPL' })
      vim.keymap.set('n', '<leader>rl', "<cmd>lua require('iron.core').send_line()<cr>", { desc = 'Send line to REPL' })
      vim.keymap.set('n', '<leader>rp', "<cmd>lua require('iron.core').send_paragraph()<cr>", { desc = 'Send paragraph to REPL' })
      vim.keymap.set('n', '<leader>ru', "<cmd>lua require('iron.core').send_until_cursor()<cr>", { desc = 'Send until cursor to REPL' })
      vim.keymap.set('n', '<leader>rm', "<cmd>lua require('iron.core').send_mark()<cr>", { desc = 'Send mark to REPL' })
      vim.keymap.set('v', '<leader>rmc', "<cmd>lua require('iron.core').mark_visual()<cr>", { desc = 'Mark visual selection' })
      vim.keymap.set('n', '<leader>rmd', "<cmd>lua require('iron.core').remove_mark()<cr>", { desc = 'Remove mark' })
      vim.keymap.set('n', '<leader>r<cr>', "<cmd>lua require('iron.core').send_cr()<cr>", { desc = 'Send CR to REPL' })
      vim.keymap.set('n', '<leader>r<space>', "<cmd>lua require('iron.core').send_interrupt()<cr>", { desc = 'Send interrupt to REPL' })
      vim.keymap.set('n', '<leader>rq', "<cmd>lua require('iron.core').send_exit()<cr>", { desc = 'Send exit to REPL' })
      vim.keymap.set('n', '<leader>rx', "<cmd>lua require('iron.core').send_clear()<cr>", { desc = 'Send clear to REPL' })
    end,
  },
}
