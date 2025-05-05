vim.opt.guicursor = "a:block"

vim.opt.laststatus = 3

vim.g.mapleader = " "

vim.o.mouse = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.relativenumber = true
  end,
})

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = (os.getenv("USERPROFILE") or os.getenv("HOME")) .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    if vim.bo.buftype == "terminal" and vim.fn.mode() ~= "t" then
      vim.cmd("startinsert")
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

local shell_pref_order = {
  [1] = "pwsh.exe",
  [2] = "powershell.exe",
  [3] = "cmd.exe",
  [4] = "zsh",
  [5] = "bash"
}

for _, shell in ipairs(shell_pref_order) do
  if vim.fn.executable(shell) == 1 then
    vim.opt.shell = shell
    break
  end
end
