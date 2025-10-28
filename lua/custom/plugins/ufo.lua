return {
  { -- Folds with ufo
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async', -- Required dependency
    },
    config = function()
      -- Folding options
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99   -- using ufo provider need a large value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' } -- or 'treesitter', 'syntax'
        end,
      }
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', '<leader>fM', require('ufo').closeAllFolds, { desc = 'Close all follds' })
      vim.keymap.set('n', '<leader>fa', 'zA', { desc = 'Toggle all folds at curssor' })

      -- Fold level 1
      vim.keymap.set('n', '<leader>f1', function()
        require('ufo').closeFoldsWith(1)
      end, { desc = 'Fold to level 1' })

      -- Fold level 2
      vim.keymap.set('n', '<leader>f2', function()
        require('ufo').closeFoldsWith(2)
      end, { desc = 'Fold to levl 2' })
    end,
  },
}
