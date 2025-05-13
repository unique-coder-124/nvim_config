local function align_backslashes(opts)
  local bufnr       = opts.buf or 0
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  -- If the user didn’t actually select more than one line, do the whole buffer:
  local start_line, end_line
  if opts.line1 == opts.line2 then
    start_line = 1
    end_line   = total_lines
  else
    start_line = opts.line1
    end_line   = opts.line2
  end

  local padding = 5

  -- 1) Reset any spaces before a trailing '\' in the range,
  --    but do it silently so it won’t error if no matches exist.
  vim.cmd(string.format(
    "silent! %d,%ds/\\s\\+\\\\$/\\\\/",
    start_line, end_line
  ))

  -- 2) Pull in those lines
  local lines = vim.api.nvim_buf_get_lines(bufnr,
                                           start_line - 1,
                                           end_line,
                                           false)

  -- 3) Find max display-width among lines that end in '\'
  local max_width = 0
  for _, line in ipairs(lines) do
    if vim.endswith(line, "\\") then
      local w = vim.fn.strdisplaywidth(line)
      if w > max_width then max_width = w end
    end
  end
  max_width = max_width + padding

  -- 4) Rebuild each line: pad before the '\' so they all line up
  for idx, line in ipairs(lines) do
    if vim.endswith(line, "\\") then
      -- strip off the backslash to measure the “core” width
      local core = line:sub(1, -2)
      local w    = vim.fn.strdisplaywidth(core)
      lines[idx] = core .. string.rep(" ", max_width - w) .. "\\"
    end
  end

  -- 5) Write them back
  vim.api.nvim_buf_set_lines(bufnr,
                             start_line - 1,
                             end_line,
                             false,
                             lines)
end

-- Create the command, allowing a visual or explicit range
vim.api.nvim_create_user_command(
  'AlignBackSlashes',
  align_backslashes,
  { range = true }
)
