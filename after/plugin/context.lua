-- Enable the plugin
vim.g.context_enabled = 1

-- Blacklist filetypes where context window will not appear
vim.g.context_filetype_blacklist = { 'markdown', 'txt' }

-- Blacklist buftypes where context window will not appear
vim.g.context_buftype_blacklist = { 'help' }

-- Enable automatic creation of mappings for context window update on scroll
vim.g.context_add_mappings = 1

-- Enable autocmds for updating context
vim.g.context_add_autocmds = 1

-- Set presenter for the context window (use 'vim-popup', 'nvim-float', or 'preview')
vim.g.context_presenter = 'nvim-float'

-- Set the max height of the context window
vim.g.context_max_height = 15

-- Set the maximum number of lines per indentation level
vim.g.context_max_per_indent = 5

-- Set the character for ellipses in context window
vim.g.context_ellipsis_char = '·'

-- Set the border character for context window
vim.g.context_border_char = '━' -- '━', '-', '_', '~', '^', '*', '#', '.'

-- Set highlight group for normal context content
vim.g.context_highlight_normal = 'PMenu'

-- Set highlight group for context border
vim.g.context_highlight_border = 'Comment'

-- Set highlight group for context tag (e.g., <context.vim>)
vim.g.context_highlight_tag = 'Special'

-- Skip regex for lines that should be ignored in context window
vim.g.context_skip_regex = [[^\s*\($\|#\|//\|/\*\|\*\($\|/s\|\/\)\)]]

-- Extend regex for lines that should extend context at current indentation level
-- vim.g.context_extend_regex = [[^\s*\([]{})]\|end\|else\|case\>\|default\>\)]] -- simple case
vim.g.context_extend_regex = [[^\s*(?:(?!\(\s*\)).*(?!\)\s*).*(?!\[\s*\]).*(?!\]\s*).*(?!\{\s*\}).*(?!\}\s*).*(?!end\|else\|case\>\|default\>\).)*$]] -- complex case to handle complete context pairs e.g. (), [], {}

-- Regex for joining lines that should be compacted into one context line
vim.g.context_join_regex = [[^\W*$]]

-- Custom indentation function for context window
vim.g.Context_indent = function(line) return { indent(line), indent(line) } end

-- Custom function for adjusting indentation of the border line
vim.g.Context_border_indent = function() return { 0, 0 } end
