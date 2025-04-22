vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

-- mappings for moving current selection up or down
local keysUp = {"K", "<M-k>", "<M-Up>"}
local keysDown = {"J", "<M-j>", "<M-Down>"}

for _, key in ipairs(keysUp) do
  vim.keymap.set("v", key, ":m '<-2<CR>gv=gv")
  vim.keymap.set("n", key, "V:m '<-2<CR>gv=gv<C-c>")
end

for _, key in ipairs(keysDown) do
  vim.keymap.set("v", key, ":m '>+1<CR>gv=gv")
  vim.keymap.set("n", key, "V:m '>+1<CR>gv=gv<C-c>")
end

vim.keymap.set("n", "<leader>wl", function() 
  vim.opt.wrap = not vim.opt.wrap:get()
end)

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set('t', '<c-w><c-w>', [[<c-\><c-n><c-w><c-w>]])
vim.keymap.set('t', '<c-w>', [[<c-\><c-n><c-w>]])

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-Down>", "<C-d>zz")
vim.keymap.set("n", "<C-Up>", "<C-u>zz")
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

vim.keymap.set("n", "<S-Tab>", "V<")

vim.keymap.set("n", "<C-_>", "gcc", { remap = true })
vim.keymap.set("v", "<C-_>", "gcgv", { remap = true })

vim.keymap.set("n", "<leader><leader>", ":so<CR>")

vim.keymap.set("n", "<M-v>", ":vsplit<CR><C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "<M-h>", ":split<CR><C-w>j", { noremap = true, silent = true })
