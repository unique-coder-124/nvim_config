require('rose-pine').setup({
  disable_background = false
})

function ColorMyPencils(color) 
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })

end

-- ColorMyPencils()
ColorMyPencils("sorbet")
