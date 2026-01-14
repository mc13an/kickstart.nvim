return {
  'romgrk/barbar.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'lweis6991/gitsigns.nvim' },
  init = function()
    vim.g.barber_auto_setup = false
  end,
  config = function()
    vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>', { desc = 'Go to previous buffer' })
    vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>', { desc = 'Go to next buffer' })
  end,
}
