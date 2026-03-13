return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  opts = { -- set to setup table
  },
  config = function()
    require('colorizer').setup {
      filetypes = { css = { mode = 'virtualtext' }, 'javascript', html = { mode = 'foreground' } },
      user_default_options = {
        names = false,
        css = true,
        oklch = true,
      },
    }
  end,
}
