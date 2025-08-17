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
      -- Strip off the backslash to measure the “core” width
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

  vim.api.nvim_win_set_cursor(bufnr, {end_line, 0})
end

-- Create the command, allowing a visual or explicit range
vim.api.nvim_create_user_command(
'AlignBackSlashes',
align_backslashes,
{ range = true }
)

vim.api.nvim_create_user_command('Scratch', function()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end,
{})

vim.api.nvim_create_user_command('UpdateClangdFlags', function(opts)
  local std_stuff = {}
  local common_lib = {}

  if vim.loop.os_uname().sysname == "Windows_NT" then
    std_stuff = {
      "C:/Users/Michael_dev/scoop/apps/mingw-winlibs-llvm-msvcrt/14.2.0-19.1.7-12.0.0-r3/lib/clang/19/include",
      "C:/Users/Michael_dev/scoop/apps/mingw-winlibs-llvm-msvcrt/14.2.0-19.1.7-12.0.0-r3/x86_64-w64-mingw32/include",
      "C:/Users/Michael_dev/scoop/apps/mingw-winlibs-llvm-msvcrt/14.2.0-19.1.7-12.0.0-r3/include",
    }
  else
    std_stuff = {
      "/usr/lib/llvm-14/lib/clang/14.0.0/include",
      "/usr/local/include",
      "/usr/include/x86_64-linux-gnu",
    }
    common_lib = {
      "/usr/include",
    }
  end
  local project_path = vim.fn.getcwd()

  local path = project_path .. '/.clangd'
  -- read all existing lines
  local orig = {}
  local f = io.open(path, 'r')
  if f then
    for ln in f:lines() do table.insert(orig, ln) end
    f:close()
  end

  -- parse existing Add: entries into a set
  local existing = {}
  for _, ln in ipairs(orig) do
    local items = ln:match('Add:%s*%[([^%]]+)%]')
    if items then
      for item in items:gmatch('[^,]+') do
        item = item:match('^%s*(.-)%s*$')
        existing[item] = true
      end
      break
    end
  end

  local function in_list(tbl, v)
    for _,x in ipairs(tbl) do if x==v then return true end end
  end

  -- build `additional` from existing that are not std/common/project
  local additional = {}
  for item in pairs(existing) do
    if item ~= '-I'..project_path
       and not in_list(std_stuff, item:sub(3))
       and not in_list(common_lib, item:sub(3))
    then
      table.insert(additional, item:sub(3))
    end
  end
  -- merge user args
  for _, newp in ipairs(opts.fargs) do
    if newp ~= '' and not in_list(additional, newp) then
      table.insert(additional, newp)
    end
  end

  -- build final list
  local final = {}
  for _, p in ipairs(std_stuff)    do table.insert(final, '-I'..p) end
  for _, p in ipairs(common_lib)    do table.insert(final, '-I'..p) end
  for _, p in ipairs(additional)    do table.insert(final, '-I'..p) end
  table.insert(final, '-I'..project_path)

  -- build the new CompileFlags/Add block
  local block = {
    'CompileFlags:',
    '  Add: [',
  }
  for _, item in ipairs(final) do
    table.insert(block, '    ' .. item .. ',')
  end
  -- remove trailing comma on last entry, then close
  block[#block] = block[#block]:gsub(',$', '')
  table.insert(block, '  ]')

  -- now rebuild `orig`, replacing or inserting that block
  local out = {}
  local i = 1
  local n = #orig
  local replaced = false

  while i <= n do
    if not replaced and orig[i]:match('^CompileFlags:') then
      -- skip over old CompileFlags/Add block
      i = i + 1
      while i <= n and orig[i]:match('^%s') do
        i = i + 1
      end
      -- insert new block
      for _, ln in ipairs(block) do table.insert(out, ln) end
      replaced = true
    else
      table.insert(out, orig[i])
      i = i + 1
    end
  end

  -- if we never saw CompileFlags, append it
  if not replaced then
    table.insert(out, '')
    for _, ln in ipairs(block) do table.insert(out, ln) end
  end

  -- write back
  local wf, err = io.open(path, 'w')
  if not wf then
    error("Failed to open file for writing: " .. err)
  end
  for _, ln in ipairs(out) do
    wf:write(ln, '\n')
  end
  wf:close()

  print('.clangd updated (now has ' .. #final .. ' includes).')
end, {
  nargs    = '*',
  complete = 'file',
})

