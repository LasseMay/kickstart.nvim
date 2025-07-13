return {
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
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { 'zsh' },
          },
          python = {
            -- command = { 'python3' }, -- or { "python", "-i" }
            command = { 'uv', 'run', 'python' }, -- or { "python", "-i" }
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
          -- Add more languages as needed
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.vertical.botright(50),
        -- repl_open_cmd = view.split.horizontal.botright(20),
        -- repl_open_cmd = view.split.topleft(30),
        -- repl_open_cmd = view.split.topright(30),
        -- repl_open_cmd = view.split.bottomleft(30),
        -- repl_open_cmd = view.split.bottomright(30),
        -- repl_open_cmd = view.split("40%"),
        -- repl_open_cmd = view.split.horizontal("40%"),
        -- repl_open_cmd = view.split.vertical("40%"),
        -- repl_open_cmd = view.split.topleft("40%"),
        -- repl_open_cmd = view.split.topright("40%"),
        -- repl_open_cmd = view.split.bottomleft("40%"),
        -- repl_open_cmd = view.split.bottomright("40%"),
        -- repl_open_cmd = view.curry(view.split("40%"), view.split.horizontal("40%")),
        -- repl_open_cmd = view.curry(view.split.vertical("40%"), view.split.horizontal("40%")),
        -- repl_open_cmd = require("iron.view").center(30),
        -- repl_open_cmd = require("iron.view").center("40%"),
        -- repl_open_cmd = require("iron.view").center("40%", 30),
        -- repl_open_cmd = require("iron.view").center("40%", "40%"),
        -- repl_open_cmd = require("iron.view").right(30),
        -- repl_open_cmd = require("iron.view").right("40%"),
        -- repl_open_cmd = require("iron.view").left(30),
        -- repl_open_cmd = require("iron.view").left("40%"),
        -- repl_open_cmd = require("iron.view").bottom(30),
        -- repl_open_cmd = require("iron.view").bottom("40%"),
        -- repl_open_cmd = require("iron.view").top(30),
        -- repl_open_cmd = require("iron.view").top("40%"),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
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
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>', { desc = 'Toggle REPL' })
    vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>', { desc = 'Restart REPL' })
    vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
    vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = 'Hide REPL' })

    -- Send text to REPL
    vim.keymap.set('v', '<leader>rc', "<cmd>lua require('iron.core').visual_send()<cr>", { desc = 'Send visual selection to REPL' })
    vim.keymap.set('n', '<leader>rc', "<cmd>lua require('iron.core').send_motion()<cr>", { desc = 'Send motion to REPL' })
    vim.keymap.set('n', '<leader>rl', "<cmd>lua require('iron.core').send_line()<cr>", { desc = 'Send line to REPL' })
    vim.keymap.set('n', '<leader>rp', "<cmd>lua require('iron.core').send_paragraph()<cr>", { desc = 'Send paragraph to REPL' })
    vim.keymap.set('n', '<leader>ru', "<cmd>lua require('iron.core').send_until_cursor()<cr>", { desc = 'Send until cursor to REPL' })

    -- Mark and send
    vim.keymap.set('n', '<leader>rm', "<cmd>lua require('iron.core').send_mark()<cr>", { desc = 'Send mark to REPL' })
    vim.keymap.set('v', '<leader>rmc', "<cmd>lua require('iron.core').mark_visual()<cr>", { desc = 'Mark visual selection' })
    vim.keymap.set('n', '<leader>rmd', "<cmd>lua require('iron.core').remove_mark()<cr>", { desc = 'Remove mark' })

    -- REPL control
    vim.keymap.set('n', '<leader>r<cr>', "<cmd>lua require('iron.core').send_cr()<cr>", { desc = 'Send CR to REPL' })
    vim.keymap.set('n', '<leader>r<space>', "<cmd>lua require('iron.core').send_interrupt()<cr>", { desc = 'Send interrupt to REPL' })
    vim.keymap.set('n', '<leader>rq', "<cmd>lua require('iron.core').send_exit()<cr>", { desc = 'Send exit to REPL' })
    vim.keymap.set('n', '<leader>rx', "<cmd>lua require('iron.core').send_clear()<cr>", { desc = 'Send clear to REPL' })
  end,
}
