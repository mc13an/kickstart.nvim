return {
  { -- Folds with ufo
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async', -- Required dependency
    },
    config = function()
      -- Folding options
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- using ufo provider need a large value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.statuscolumn = '%=%l%s%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : "  " }%*'
      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' } -- or 'treesitter', 'syntax'
        end,
      }
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'z2', function()
        require('ufo').closeFoldsWith(2)
      end, { desc = 'Fold to level 2' })

      vim.keymap.set('n', 'z1', function()
        require('ufo').closeFoldsWith(1)
      end, { desc = 'Fold to level 1' })
    end,
  },
}
