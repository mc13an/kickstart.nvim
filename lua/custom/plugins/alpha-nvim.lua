return {
  'goolord/alpha-nvim',
  config = function()
    -- require('alpha').setup(require('alpha.themes.dashboard').config)
    local startify = require 'alpha.themes.startify'
    startify.file_icons.provider = 'devicons'
    require('alpha').setup(startify.config)
  end,
}
