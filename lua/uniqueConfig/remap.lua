vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set({"n", "v"}, "<leader>Y", [["+Y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }) -- unix only

vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.keymap.set("n", "<C-_>", "gcc", { remap = true })
vim.keymap.set("v", "<C-_>", "gcgv", { remap = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- -- Define a function to handle the new line behavior
-- function insert_new_list_item()
--   local line = vim.fn.getline('.')
--   -- Check if the line starts with "- " (with possible leading whitespace)
--   if line:match('^%s*%- ') then
--     -- Insert a new line with "- " at the beginning
--     vim.api.nvim_feedkeys("\n- ", 'n', true)
--   else
--     -- If not a list item, just insert a new line normally
--     vim.api.nvim_feedkeys("\n", 'n', true)
--   end
-- end
-- 
-- -- Map the function to a keybinding, for example, <Enter>
-- vim.keymap.set('i', '<CR>', insert_new_list_item, { noremap = true })
