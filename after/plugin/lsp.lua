-- ============================
-- LSP-ZERO v3.x CONFIG
-- ============================

local lsp = require("lsp-zero").preset("recommended")

-- ============================
-- CMP Setup
-- ============================

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = {
  ['<Enter>'] = cmp.mapping.confirm({ select = true }),
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback("<Tab>")
    end
  end, { 'i', 's' }),
  ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-q>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-e>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
}

cmp.setup({
  mapping = cmp_mappings,
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- CMP toggle
local cmp_active = true
function ToggleCMP()
  cmp.setup({ enabled = cmp_active })
  cmp_active = not cmp_active
end

-- ============================
-- on_attach for buffer-local mappings
-- ============================

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>gb", "<C-o>", opts)
  vim.keymap.set("n", "<leader>gf", "<C-i>", opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>vod", function()
    vim.diagnostic.setqflist()
    vim.cmd("copen")
  end, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set({ "n", "i" }, "<M-d>", ToggleCMP, opts)
  vim.keymap.set("n", "<leader>vcd", function()
    local diag = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })[1]
    if diag and diag.message then
      vim.fn.setreg("+", diag.message)
      print("Copied diagnostic message!")
    else
      print("No diagnostic message found.")
    end
  end, { desc = "Copy LSP diagnostic message" })
end)

-- ============================
-- Capabilities for CMP completion
-- ============================

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ============================
-- Server-specific configuration
-- ============================

-- -- Lua language server
-- lsp.configure("lua_ls", {
--   settings = {
--     Lua = {
--       diagnostics = { globals = { "vim" }, maxLineLength = 120 },
--     },
--   },
--   capabilities = capabilities,
-- })

-- ============================
-- Optional: Mason setup
-- ============================

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {},
})

-- ============================
-- Finalize LSP setup
-- ============================

lsp.setup()

-- ============================
-- Keybind Help (documentation)
-- ============================
-- <leader> is the space bar
-- gd : go to definition
-- gb : jump back
-- gf : jump forward
-- K  : hover info
-- <leader>vws : workspace symbol search
-- <leader>vd : open diagnostic float
-- [d / ]d : previous/next diagnostic
-- <leader>vca : code action
-- <leader>vrr : references
-- <leader>vrn : rename
-- <C-h> : signature help
-- <M-d> : toggle completion menu
