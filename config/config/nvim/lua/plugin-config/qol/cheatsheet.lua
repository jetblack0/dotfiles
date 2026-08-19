-- A curated list of the keymaps, grouped into named sections and shown in a
-- centered float:
--
--   <leader>?            toggle the cheatsheet
--   a   (in the sheet)   add a keymap (global keymaps + explorer action keys)
--   d   (in the sheet)   delete an entry
--   q / <Esc>            close
--
-- Entries live in cheatsheet.json inside the nvim config directory, so they
-- travel with the dotfiles. The file is plain JSON (one section per line) and
-- safe to hand-edit:
--   [
--     {"name":"Git","keys":[{"key":"<leader>gp","mode":"n","desc":"Git push"}]}
--   ]
--
-- Optionally configure the window size via setup():
--   require("plugin-config.qol.cheatsheet").setup({
--     size = {
--       mode = "auto",   -- grow with content instead of the fixed default
--       min_width = 50,
--       min_height = 12,
--     },
--   })

local M = {}

M.config = {
  size = {
    -- "fixed": the window is always width x height.
    -- "auto":  the window grows with the number of keys.
    -- Sizes > 1 are cells; sizes <= 1 are a fraction of the editor.
    mode = "fixed",
    width = 0.6,     -- fixed mode
    height = 0.6,
    min_width = 40,  -- auto mode floor
    min_height = 10,
  },
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

local store = vim.fn.stdpath("config") .. "/cheatsheet.json"
local ns = vim.api.nvim_create_namespace("cheatsheet")
local GAP = 4 -- spaces between columns

-- Headers get their own color (borrowed from Function so it follows the
-- colorscheme) plus bold; keys stay on Special so the two never blend.
local function apply_highlights()
  local src = vim.api.nvim_get_hl(0, { name = "Function", link = false })
  vim.api.nvim_set_hl(0, "CheatsheetHeader", { fg = src.fg, bold = true })
  vim.api.nvim_set_hl(0, "CheatsheetKey", { link = "Special", default = true })
end
apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

-- Storage
-- ---------------------------------------------
--- @return table[] list of { name = string, keys = { { key, mode, desc } } }
local function load()
  local f = io.open(store, "r")
  if not f then return {} end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  return (ok and type(data) == "table") and data or {}
end

local function save(sections)
  local rows = {}
  for _, s in ipairs(sections) do
    rows[#rows + 1] = "  " .. vim.json.encode(s)
  end
  local f = assert(io.open(store, "w"))
  f:write("[\n" .. table.concat(rows, ",\n") .. "\n]\n")
  f:close()
end

-- Rendering
-- ---------------------------------------------
local function entry_label(e)
  return (e.mode and e.mode ~= "n") and (e.key .. " [" .. e.mode .. "]") or e.key
end

-- One section -> a block of display lines (header first, then aligned keys).
local function build_block(sec)
  local block = { { text = sec.name, header = true } }
  local key_w = 0
  for _, e in ipairs(sec.keys) do
    key_w = math.max(key_w, vim.fn.strdisplaywidth(entry_label(e)))
  end
  for _, e in ipairs(sec.keys) do
    local k = entry_label(e)
    local pad = string.rep(" ", key_w - vim.fn.strdisplaywidth(k))
    block[#block + 1] = {
      text = "  " .. k .. pad .. "   " .. (e.desc or ""),
      -- byte offsets of the key, for the highlight extmark
      key_from = 2,
      key_to = 2 + #k,
    }
  end
  return block
end

-- Distribute section blocks over columns, filling top to bottom.
local function layout(blocks, max_h)
  local cols, col = {}, nil
  for _, b in ipairs(blocks) do
    local gap = (col and #col.lines > 0) and 1 or 0 -- blank line between sections
    if not col or (#col.lines + gap + #b > max_h and #col.lines > 0) then
      col, gap = { lines = {}, width = 0 }, 0
      cols[#cols + 1] = col
    end
    if gap == 1 then col.lines[#col.lines + 1] = { text = "" } end
    for _, l in ipairs(b) do
      col.lines[#col.lines + 1] = l
      col.width = math.max(col.width, vim.fn.strdisplaywidth(l.text))
    end
  end
  return cols
end

-- Merge the columns into final buffer lines + highlight positions.
local function render(cols)
  local rows = 0
  for _, c in ipairs(cols) do rows = math.max(rows, #c.lines) end
  local lines, marks = {}, {}
  for r = 1, rows do
    local parts, byte = { " " }, 1 -- one column of left padding
    for ci, c in ipairs(cols) do
      local l = c.lines[r] or { text = "" }
      if l.header then
        marks[#marks + 1] = { r - 1, byte, byte + #l.text, "CheatsheetHeader" }
      elseif l.key_from then
        marks[#marks + 1] = { r - 1, byte + l.key_from, byte + l.key_to, "CheatsheetKey" }
      end
      local pad = ci < #cols and (c.width - vim.fn.strdisplaywidth(l.text) + GAP) or 0
      parts[#parts + 1] = l.text .. string.rep(" ", pad)
      byte = byte + #parts[#parts]
    end
    lines[r] = table.concat(parts)
  end
  return lines, marks
end

-- Window
-- ---------------------------------------------
local win

local function close()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  win = nil
end

-- <= 1 means a fraction of the editor, > 1 means cells
local function resolve(size, total)
  return math.floor(size > 1 and size or total * size)
end

function M.open()
  close()
  local sections = load()
  local size = M.config.size
  local max_w, max_h = vim.o.columns - 4, vim.o.lines - 4

  local width, height
  if size.mode == "fixed" then
    width = math.min(resolve(size.width, vim.o.columns), max_w)
    height = math.min(resolve(size.height, vim.o.lines), max_h)
  end

  -- in fixed mode fill columns to the window; in auto mode to 75% of the screen
  local fill_h = height or math.max(5, math.floor(vim.o.lines * 0.75))
  local lines, marks = { " Cheatsheet is empty — press a to add a keymap " }, {}
  if #sections > 0 then
    local blocks = {}
    for _, s in ipairs(sections) do blocks[#blocks + 1] = build_block(s) end
    lines, marks = render(layout(blocks, fill_h))
  end

  if size.mode ~= "fixed" then
    local content_w = 0
    for _, l in ipairs(lines) do content_w = math.max(content_w, vim.fn.strdisplaywidth(l)) end
    width = math.min(math.max(content_w + 1, resolve(size.min_width, vim.o.columns)), max_w)
    height = math.min(math.max(#lines, resolve(size.min_height, vim.o.lines)), max_h)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, m in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buf, ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
  end
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "cheatsheet"

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2)),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
    footer = " a add · d delete · q close ",
    footer_pos = "center",
  })
  vim.wo[win].wrap = false

  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("n", "a", function() close(); M.add() end, opts)
  vim.keymap.set("n", "d", function() close(); M.remove() end, opts)
  vim.api.nvim_create_autocmd("BufLeave", { buffer = buf, once = true, callback = close })
end

function M.toggle()
  if win and vim.api.nvim_win_is_valid(win) then close() else M.open() end
end

-- Adding / removing entries
-- ---------------------------------------------
local NEW_SECTION = "＋ new section…"

local function ask_desc_and_save(sections, section, entry)
  for _, e in ipairs(section.keys) do
    if e.key == entry.key and e.mode == entry.mode then
      vim.notify(entry.key .. " is already in “" .. section.name .. "”", vim.log.levels.WARN)
      return
    end
  end
  vim.ui.input({ prompt = "Description: ", default = entry.desc }, function(desc)
    if desc == nil then return end -- aborted
    entry.desc = desc
    section.keys[#section.keys + 1] = entry
    save(sections)
    M.open()
  end)
end

local function choose_section(entry)
  local sections = load()
  local names = {}
  for _, s in ipairs(sections) do names[#names + 1] = s.name end
  names[#names + 1] = NEW_SECTION

  vim.ui.select(names, { prompt = "Cheatsheet section" }, function(choice, idx)
    if not choice then return end
    if choice == NEW_SECTION then
      vim.ui.input({ prompt = "New section name: " }, function(name)
        if not name or name == "" then return end
        sections[#sections + 1] = { name = name, keys = {} }
        ask_desc_and_save(sections, sections[#sections], entry)
      end)
    else
      ask_desc_and_save(sections, sections[idx], entry)
    end
  end)
end

-- Global keymaps, the same set the snacks `keymaps` picker shows.
local function keymap_items()
  local items, seen = {}, {}
  for _, mode in ipairs({ "n", "v", "x", "s", "o", "i", "c", "t" }) do
    for _, km in ipairs(vim.api.nvim_get_keymap(mode)) do
      -- keytrans must run on the raw lhs: on the printable form it escapes
      -- "<", turning "<C-B>" into "<lt>C-B>"
      local key = vim.fn.keytrans(km.lhsraw or km.lhs)
      local id = km.mode .. " " .. key
      if not key:find("<Plug>", 1, true) and not seen[id] then
        seen[id] = true
        items[#items + 1] = {
          key = key:gsub("^<Space>", "<leader>"),
          mode = km.mode,
          desc = km.desc or km.rhs or "",
          tag = km.mode,
          preview = { text = vim.inspect(km), ft = "lua" },
        }
      end
    end
  end
  return items
end

-- Keys bound inside the snacks explorer window. These are picker actions,
-- not real keymaps, so nvim_get_keymap can't see them -- read them from the
-- resolved explorer source config instead (defaults + user overrides).
local function explorer_items()
  local ok, conf = pcall(Snacks.picker.config.get, { source = "explorer" })
  if not ok then return {} end
  local items, seen = {}, {}
  for _, w in ipairs({ "list", "input" }) do
    for lhs, spec in pairs(vim.tbl_get(conf, "win", w, "keys") or {}) do
      if spec and not seen[lhs] then -- false = a disabled key
        seen[lhs] = true
        local action = type(spec) == "string" and spec
          or type(spec) == "table" and type(spec[1]) == "string" and spec[1]
          or nil
        local desc = type(spec) == "table" and spec.desc or nil
        items[#items + 1] = {
          key = lhs,
          mode = "n",
          desc = desc or (action and action:gsub("_", " ")) or "custom action",
          tag = "explorer",
          preview = { text = vim.inspect(spec), ft = "lua" },
        }
      end
    end
  end
  table.sort(items, function(a, b) return a.key < b.key end)
  return items
end

--- Pick a keymap or an explorer action key and add it to the sheet.
function M.add()
  local items = explorer_items()
  vim.list_extend(items, keymap_items())
  for _, it in ipairs(items) do
    it.text = it.tag .. " " .. it.key .. " " .. it.desc -- what the picker matches on
  end
  Snacks.picker({
    title = "Add to cheatsheet",
    items = items,
    format = function(item)
      return {
        { ("%-10s"):format(item.tag), "Comment" },
        { ("%-16s "):format(item.key), "CheatsheetKey" },
        { item.desc },
      }
    end,
    preview = "preview",
    confirm = function(picker, item)
      picker:close()
      if not item then return end
      vim.schedule(function()
        choose_section({ key = item.key, mode = item.mode, desc = item.desc })
      end)
    end,
  })
end

function M.remove()
  local sections = load()
  local labels, refs = {}, {}
  for si, s in ipairs(sections) do
    for ki, e in ipairs(s.keys) do
      labels[#labels + 1] = ("%s: %s — %s"):format(s.name, entry_label(e), e.desc or "")
      refs[#refs + 1] = { si, ki }
    end
  end
  if #labels == 0 then
    vim.notify("Cheatsheet is empty", vim.log.levels.INFO)
    return
  end
  vim.ui.select(labels, { prompt = "Remove from cheatsheet" }, function(_, idx)
    if not idx then return end
    local si, ki = refs[idx][1], refs[idx][2]
    table.remove(sections[si].keys, ki)
    if #sections[si].keys == 0 then table.remove(sections, si) end
    save(sections)
    M.open()
  end)
end

vim.keymap.set("n", "<leader>?", M.toggle, { desc = "Toggle keybind cheatsheet" })
vim.api.nvim_create_user_command("Cheatsheet", M.toggle, { desc = "Toggle keybind cheatsheet" })
vim.api.nvim_create_user_command("CheatsheetAdd", M.add, { desc = "Add a keymap to the cheatsheet" })

return M
