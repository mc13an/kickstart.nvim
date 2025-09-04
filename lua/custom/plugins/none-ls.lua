return {
  -- none-ls
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local null_ls = require 'null-ls'
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.biome,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.formatting.codespell,
      },
    }
  end,
}