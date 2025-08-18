-- Load lsp-zero
local lsp = require("lsp-zero")

-- Setup cmp
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = {
  ['<Enter>'] = cmp.mapping.confirm({ select = true }),
  ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback("<Tab>")
    end
  end, { 'i', 's' }),
}

cmp.setup({
  mapping = cmp_mappings,
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- Toggle CMP enable/disable
local active = true
function ToggleCMP()
  if active then
    cmp.setup({ enabled = false })
    active = false
  else
    cmp.setup({ enabled = true })
    active = true
  end
end

-- Common on_attach for all servers
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>gb", "<C-o>", opts)
  vim.keymap.set("n", "<leader>gf", "<C-i>", opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({
      border = "rounded"
    })
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
  vim.keymap.set({"n","i"}, '<M-d>', ToggleCMP, opts)
  vim.keymap.set("n", "<leader>vcd", function()
    local diag = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })[1]
    if diag and diag.message then
      vim.fn.setreg("+", diag.message)
      print("Copied diagnostic message!")
    else
      print("No diagnostic message found.")
    end
  end, { desc = "Copy LSP diagnostic message" })
end

-- Capabilities (for cmp completion)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup servers via mason-lspconfig
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { },
  handlers = {
    function(server)
      require("lspconfig")[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    ["lua_ls"] = function()
      require("lspconfig").lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
              maxLineLength = 120,
            },
          },
        },
      })
    end,
  },
})

-- Keybind help

-- The key combination <leader> is the space bar
-- The keys gd trigger the go to definition
-- The key K triggers the hover
-- The key <leader>vws triggers the workspace symbol search which is a fuzzy search for symbols in the workspace
-- The key <leader>vd triggers the diagnostic float
-- The keys [d and ]d trigger the next and previous diagnostic
-- The key <leader>vca triggers the code action which is a list of possible actions to take
-- The key <leader>vrr triggers the references
-- The key <leader>vrn triggers the rename
-- The key <C-h> triggers the signature help which is a list of possible signatures for the function meaning the possible arguments and return types
-- The key <M-d> triggers the toggle of the completion menu
