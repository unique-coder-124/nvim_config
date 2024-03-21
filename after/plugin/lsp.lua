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
      local success, result = pcall(vim.exec, "copilot#Accept('<CR>')")
      if not success then
        fallback("<Tab>")
      end
    end
  end, { 'i', 's', })
})

lsp.set_preferences({
  sign_icons = {}
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

active = true

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
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set({"n", "i"}, '<M-d>', function() ToggleCMP() end, opts)
end)

lsp.setup()


-- keybind help
--
-- the key combination <leader> is the space bar
-- the keys gd trigger the go to definition
-- the key K triggers the hover
-- the key <leader>vws triggers the workspace symbol search which is a fuzzy search for symbols in the workspace
-- the key <leader>vd triggers the diagnostic float
-- the keys [d and ]d trigger the next and previous diagnostic
-- the key <leader>vca triggers the code action which is a list of possible actions to take
-- the key <leader>vrr triggers the references
-- the key <leader>vrn triggers the rename
-- the key <C-h> triggers the signature help which is a list of possible signatures for the function meaning the possible arguments and return types
-- the key <M-d> triggers the toggle of the completion menu
