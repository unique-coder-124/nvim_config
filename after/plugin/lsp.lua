local lsp = require("lsp-zero")

lsp.preset("recommended")

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-q>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-e>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-Enter>'] = cmp.mapping.confirm( { select = true } ),
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback("<Tab>")
    end
  end, { 'i', 's', })
})

lsp.set_preferences({
  sign_icons = {}
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

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

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "<leader>vod", function() vim.diagnostic.setqflist() vim.cmd("copen") end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set({"n", "i"}, '<M-d>', function() ToggleCMP() end, opts)
  vim.keymap.set("n", "<leader>vcd", function()
    local diag = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })[1]
    if diag and diag.message then
      vim.fn.setreg("+", diag.message)  -- Copy to system clipboard
      print("Copied diagnostic message!")  -- Notify user
    else
      print("No diagnostic message found.")
    end
  end, { desc = "Copy LSP diagnostic message" })
end)

lsp.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, context, config)
      if err then print(err) end
    end,
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},
        maxLineLength = 120,
      }
    }
  }
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
