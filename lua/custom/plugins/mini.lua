return {
  -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    require('mini.indentscope').setup()
    require('mini.notify').setup()
    require('mini.animate').setup()
    require('mini.icons').setup()
    require('mini.tabline').setup()
    require('mini.cursorword').setup()
    require('mini.sessions').setup()
    require('mini.files').setup {
      mappings = {
        go_in = 'l',
        go_in_plus = '<CR>',
        go_out = 'h',
        go_out_plus = '-',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },
    }

    local starter = require 'mini.starter'
    starter.setup {
      items = {
        starter.sections.sessions(5, true),
        starter.sections.recent_files(5, true, false),
      },
    }
    -- Custom mappings for opening files in splits
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set('n', '<C-x>', function()
          local entry = require('mini.files').get_fs_entry()
          if entry and entry.fs_type == 'file' then
            vim.cmd('split ' .. entry.path)
          end
        end, { buffer = buf_id, desc = 'Open in horizontal split' })

        vim.keymap.set('n', '<C-y>', function()
          local entry = require('mini.files').get_fs_entry()
          if entry and entry.fs_type == 'file' then
            vim.cmd('vsplit ' .. entry.path)
          end
        end, { buffer = buf_id, desc = 'Open in vertical split' })
      end,
    })

    -- Keybinding for mini.files
    vim.keymap.set('n', '<leader>fm', function()
      MiniFiles.open(vim.api.nvim_buf_get_name(0))
    end, { desc = '[F]ile [M]anager (Mini Files)' })

    -- Keybindings for mini.tabline navigation
    vim.keymap.set('n', '[[', '<cmd>:bprev<CR>', { desc = '[T]ab [N]ext' })
    vim.keymap.set('n', ']]', '<cmd>:bnext<CR>', { desc = '[T]ab [P]revious' })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
