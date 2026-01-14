return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('notify').setup {
      stages = 'slide',
      merge_duplicates = true,
    }
  end,
}
