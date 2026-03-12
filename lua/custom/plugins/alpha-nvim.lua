-- Alpha is a fast and fully programmable greeter for neovim. It allows you to create a custom start screen with various widgets, such as a header, buttons, and a footer. You can also use it to display recent files, bookmarks, and other useful information.
return {
  'goolord/alpha-nvim',
  config = function()
    -- require('alpha').setup(require('alpha.themes.dashboard').config)
    local startify = require 'alpha.themes.startify'
    startify.file_icons.provider = 'devicons'
    require('alpha').setup(startify.config)
  end,
}
