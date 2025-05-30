---@diagnostic disable: undefined-field
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

local surrounders = {
  [ '"' ] = '"',
  [ "'" ] = "'",
  [ "`" ] = "`",
  [ "(" ] = ")",
  [ "[" ] = "]",
  [ "{" ] = "}"
}

vim.keymap.set('v', 'S', function()
  local ok, open = pcall(vim.fn.nr2char, vim.fn.getchar())
  if not ok then
    return
  end

  local close = surrounders[open]
  if close then
    vim.api.nvim_feedkeys('S' .. open, 'm', false)
  else
    vim.api.nvim_feedkeys('S' .. open, 'n', false)
  end
end)

for open, close in pairs(surrounders) do
  vim.keymap.set('v', 'S'..open, '<Esc>`>a'..close..'<Esc>`<i'..open..'<Esc>gvlol')

  if (open == close) then
    vim.keymap.set('i', open, function()
      local col  = vim.fn.col('.')
      local line = vim.api.nvim_get_current_line()
      if line:sub(col, col) == close then
        local keys = vim.api.nvim_replace_termcodes('<ESC>la', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', true)
      else
        local keys = vim.api.nvim_replace_termcodes(open..close..'<Esc>i', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', true)
      end
    end)

    vim.keymap.set('i', '<M-'..close..'>', function()
      local keys = vim.api.nvim_replace_termcodes(close, true, false, true)
      vim.api.nvim_feedkeys(keys, 'n', true)
    end)
  else
    vim.keymap.set('i', open, function()
      local keys = vim.api.nvim_replace_termcodes(open..close..'<Esc>i', true, false, true)
      vim.api.nvim_feedkeys(keys, 'n', true)
    end)
    vim.keymap.set('i', close, function()
      local col  = vim.fn.col('.')
      local line = vim.api.nvim_get_current_line()
      if line:sub(col, col) == close then
        local keys = vim.api.nvim_replace_termcodes('<ESC>la', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', true)
      else
        local keys = vim.api.nvim_replace_termcodes(close, true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', true)
      end
    end)
  end
end

-- 1) In the quickfix window: <CR>, n, p do your quickfix stuff
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    -- <CR>: open entry in the main window
    vim.keymap.set("n", "<CR>", function()
      local lnum = vim.fn.line(".")
      vim.cmd("wincmd p")     -- back to main window
      vim.cmd("cc " .. lnum)  -- go to that entry
      vim.cmd("wincmd p")     -- back to main window
    end, { buffer = true, silent = true })

    -- n/p: next/prev in quickfix
    vim.keymap.set("n", "n", "<cmd>cnext<CR><cmd>wincmd p<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "p", "<cmd>cprev<CR><cmd>wincmd p<CR>", { buffer = true, silent = true })
  end,
})

-- 2) Everywhere else: Ctrl-n / Ctrl-p jump through quickfix only if it's open
local function ctrl_qf(nav)
  -- winid = 0 means no quickfix window open
  local winid = vim.fn.getqflist({ winid = 0 }).winid
  if winid ~= 0 and vim.bo.filetype ~= "qf" then
    vim.cmd((nav == "next") and "cnext" or "cprev")
  else
    -- fallback to your normal <C-n>/<C-p>
    local key = (nav == "next") and "<C-n>" or "<C-p>"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true),
                          "n", true)
  end
end

vim.keymap.set("n", "<M-n>", function() ctrl_qf("next") end, { noremap = true, silent = true })
vim.keymap.set("n", "<M-p>", function() ctrl_qf("prev") end, { noremap = true, silent = true })

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
