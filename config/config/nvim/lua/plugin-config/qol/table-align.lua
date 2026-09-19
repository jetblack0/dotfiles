-- Align the markdown table under the cursor: every column is padded to its
-- widest cell except the last, which stays ragged. Escaped pipes (\|) inside
-- cells are not handled.
local M = {}

local function width_of(s)
  return vim.fn.strdisplaywidth(s)
end

function M.align()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local function is_row(i) return lines[i] and lines[i]:match("^%s*|") end
  if not is_row(row) then return end

  local first, last = row, row
  while is_row(first - 1) do first = first - 1 end
  while is_row(last + 1) do last = last + 1 end

  local indent = lines[first]:match("^%s*")
  local rows, ncols = {}, 0
  for i = first, last do
    local body = lines[i]:gsub("^%s*|", ""):gsub("|%s*$", "")
    local cells = {}
    for cell in (body .. "|"):gmatch("(.-)|") do
      cells[#cells + 1] = vim.trim(cell)
    end
    ncols = math.max(ncols, #cells)
    rows[#rows + 1] = { cells = cells, sep = lines[i]:match("^%s*[|%s%-:]+$") ~= nil }
  end

  -- The last column is sized by the header alone, so long cells stay ragged.
  local width = {}
  for _, r in ipairs(rows) do
    if not r.sep then
      for c = 1, ncols - 1 do
        width[c] = math.max(width[c] or 0, width_of(r.cells[c] or ""))
      end
    end
  end
  width[ncols] = width_of(rows[1].cells[ncols] or "")

  local out = {}
  for _, r in ipairs(rows) do
    local parts = {}
    for c = 1, ncols do
      local cell = r.cells[c] or ""
      if r.sep then
        local l = cell:sub(1, 1) == ":" and ":" or "-"
        local rgt = cell:sub(-1) == ":" and ":" or "-"
        parts[c] = l .. string.rep("-", width[c]) .. rgt
      elseif c < ncols then
        parts[c] = " " .. cell .. string.rep(" ", width[c] - width_of(cell)) .. " "
      else
        parts[c] = " " .. cell .. " "
      end
    end
    out[#out + 1] = indent .. "|" .. table.concat(parts, "|") .. "|"
  end
  vim.api.nvim_buf_set_lines(0, first - 1, last, false, out)
end

vim.api.nvim_create_user_command("TableAlign", M.align, { desc = "Align the markdown table under the cursor" })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("table_align", { clear = true }),
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>A", M.align, { buffer = ev.buf, desc = "Align markdown table" })
  end,
})

return M
