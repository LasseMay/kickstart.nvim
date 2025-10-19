return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'VimEnter',
  config = function()
    local starter = require 'mini.starter'

    local logo = table.concat({
      " ___                                ",
      "/\\_ \\             __                ",
      "\\//\\ \\    __  __ /\\_\\    ___ ___    ",
      "  \\ \\ \\  /\\ \\/\\ \\\\/\\ \\ /' __` __`\\  ",
      "   \\_\\ \\_\\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ ",
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
