return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-vitest' {
          -- Options for neotest-vitest
          vitestCommand = 'pnpm vitest', -- Command to run vitest
          vitestConfigFile = 'vitest.config.ts', -- Path to vitest config file
          env = { CI = true, DB_LOCAL = true }, -- Environment variables for test runs
          cwd = function(path)
            return vim.fn.getcwd()
          end, -- Function to determine the current working directory
        },
      },
    }

    -- Test running keymaps
    vim.api.nvim_set_keymap('n', '<leader>tr', "<cmd>lua require('neotest').run.run()<cr>", { desc = 'Run Nearest Test' })
    vim.api.nvim_set_keymap('n', '<leader>tf', "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = 'Run Test File' })
    vim.api.nvim_set_keymap('n', '<leader>twr', "<cmd>lua require('neotest').run.run({ vitestCommand = 'vitest --watch' })<cr>", { desc = 'Run Watch' })
    vim.api.nvim_set_keymap(
      'n',
      '<leader>twf',
      "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), vitestCommand = 'vitest --watch' })<cr>",
      { desc = 'Run Watch File' }
    )

    -- Output and summary keymaps
    vim.api.nvim_set_keymap('n', '<leader>to', "<cmd>lua require('neotest').output.open({ enter = true })<cr>", { desc = 'Show Test Output' })
    vim.api.nvim_set_keymap('n', '<leader>ts', "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = 'Toggle Test Summary' })
    vim.api.nvim_set_keymap('n', '<leader>tp', "<cmd>lua require('neotest').output_panel.toggle()<cr>", { desc = 'Toggle Output Panel' })
  end,
}
