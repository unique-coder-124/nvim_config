local config_path = vim.fn.stdpath("config")

package.path = package.path
  .. ";" .. config_path .. "/lua/?.lua"
  .. ";" .. config_path .. "/lua/?/init.lua"

require("uniqueConfig")
