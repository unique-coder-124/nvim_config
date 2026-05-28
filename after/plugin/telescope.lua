local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pg', function()
    builtin.live_grep({
        -- Force ripgrep to output text in a format Telescope can parse natively on Windows
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            -- Forces ripgrep to follow Git tracking rules (ignores untracked and hidden metadata)
            '--no-ignore-vcs', 
        }
    })
end)
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
