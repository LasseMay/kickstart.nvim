return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'VimEnter',
  config = function()
    local files = require 'mini.files'
    local starter = require 'mini.starter'

    files.setup()

    local function open_cwd()
      files.open(nil, true)
    end

    local function open_buffer_dir()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == '' then
        files.open(vim.loop.cwd(), true)
      else
        files.open(bufname, true)
      end
    end

    vim.keymap.set('n', '-', open_cwd, { desc = 'Mini Files (cwd)', silent = true })
    vim.keymap.set('n', '<leader>fm', open_buffer_dir, { desc = 'Mini Files (buffer dir)', silent = true })

    local logo = table.concat({
      " ___                                ",
      "/\\_ \\             __                ",
      "\\//\\ \\    __  __ /\\_\\    ___ ___    ",
      "  \\ \\ \\  /\\ \\/\\ \\\\/\\ \\ /' __` __`\\  ",
      "   \\_\\ \\_\\ \\ \\_/ |\\ \\ \\ \\/\\ \\/\\ \\/\\ \\ ",
      "   /\\____\\\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\",
      "   \\/____/ \\/__/    \\/_/\\/_/\\/_/\\/_/",
    }, '\n')

    local fzf_section = function()
      local section = 'FzfLua'
      return function()
        return {
          { action = 'FzfLua files', name = 'Files', section = section },
          { action = 'FzfLua oldfiles', name = 'Old files', section = section },
          { action = 'FzfLua live_grep', name = 'Live grep', section = section },
          { action = 'FzfLua help_tags', name = 'Help tags', section = section },
          { action = 'FzfLua buffers', name = 'Buffers', section = section },
        }
      end
    end

    starter.setup {
      evaluate_single = true,
      header = logo,
      items = {
        starter.sections.recent_files(5, true),
        starter.sections.builtin_actions(),
        fzf_section(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning('center', 'center'),
      },
    }
  end,
}
