local builtin = require('telescope.builtin')
-- pf stands for ProjectFinder
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- control+p for finding git files(?)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- ps for Project Search(?)
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
