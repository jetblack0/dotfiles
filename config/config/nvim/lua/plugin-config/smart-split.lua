local helpers = require("utils.helpers")
local smart_splits = helpers.safe_require("smart-splits")

smart_splits.setup({
  disable_multiplexer_nav_when_zoomed = false,
  multiplexer_integration = os.getenv("SMART_SPLITS_DISABLE") == "1" and false or nil,
})

-- vim.keymap.set({ 'n', 't' }, '<a-1>', smart_splits.resize_left)
-- vim.keymap.set({ 'n', 't' }, '<a-2>', smart_splits.resize_down)
-- vim.keymap.set({ 'n', 't' }, '<a-3>', smart_splits.resize_up)
-- vim.keymap.set({ 'n', 't' }, '<a-4>', smart_splits.resize_right)

-- Moving between splits.
local function parse_tmux_layout(layout)
  local panes = {}
  for w, h, x, y, id in layout:gmatch('(%d+)x(%d+),(%d+),(%d+),(%d+)') do
    panes[tonumber(id)] = { w = tonumber(w), h = tonumber(h), x = tonumber(x), y = tonumber(y) }
  end
  return panes
end

local function tmux_pane_exists(panes, direction)
  local my_id = tonumber((vim.env.TMUX_PANE or ''):match('%%(%d+)'))
  local me = my_id and panes[my_id]
  if not me then
    return true
  end
  for id, p in pairs(panes) do
    if id ~= my_id then
      local h_overlap = p.x < me.x + me.w and p.x + p.w > me.x
      local v_overlap = p.y < me.y + me.h and p.y + p.h > me.y
      if direction == 'down' and h_overlap and p.y >= me.y + me.h then return true end
      if direction == 'up' and h_overlap and p.y + p.h <= me.y then return true end
      if direction == 'right' and v_overlap and p.x >= me.x + me.w then return true end
      if direction == 'left' and v_overlap and p.x + p.w <= me.x then return true end
    end
  end
  return false
end

local DIR_NAME = { h = 'left', j = 'down', k = 'up', l = 'right' }
local REVERSE = { h = 'l', j = 'k', k = 'j', l = 'h' }

local function wrap_within_nvim(dir_key)
  local rev = REVERSE[dir_key]
  for _ = 1, 50 do
    local before = vim.fn.winnr()
    vim.cmd.wincmd(rev)
    if vim.fn.winnr() == before then
      return
    end
  end
end

local function tmux_has_pane(dir_key)
  if not vim.env.TMUX then
    return nil
  end
  local ok, res = pcall(function()
    return vim.system({ 'tmux', 'display-message', '-p', '#{window_layout}' }, { text = true }):wait()
  end)
  if not ok or res.code ~= 0 then
    return nil
  end
  local layout = vim.trim(res.stdout or '')
  if layout == '' then
    return nil
  end
  return tmux_pane_exists(parse_tmux_layout(layout), DIR_NAME[dir_key])
end

local function window_in_direction(dir_key)
  local cur = vim.api.nvim_get_current_win()
  local pos = vim.fn.win_screenpos(vim.fn.win_id2win(cur))
  local me = {
    y = pos[1], x = pos[2],
    h = vim.api.nvim_win_get_height(cur), w = vim.api.nvim_win_get_width(cur),
  }

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= cur and vim.api.nvim_win_get_config(win).relative == '' then
      local p = vim.fn.win_screenpos(vim.fn.win_id2win(win))
      local it = {
        y = p[1], x = p[2],
        h = vim.api.nvim_win_get_height(win), w = vim.api.nvim_win_get_width(win),
      }
      local h_overlap = it.x < me.x + me.w and it.x + it.w > me.x
      local v_overlap = it.y < me.y + me.h and it.y + it.h > me.y
      if dir_key == 'j' and h_overlap and it.y >= me.y + me.h then return win end
      if dir_key == 'k' and h_overlap and it.y + it.h <= me.y then return win end
      if dir_key == 'l' and v_overlap and it.x >= me.x + me.w then return win end
      if dir_key == 'h' and v_overlap and it.x + it.w <= me.x then return win end
    end
  end
end

local function smart_move(dir_key, mux_fn)
  return function()
    local in_float = vim.api.nvim_win_get_config(0).relative ~= ''

    -- 1. Another nvim window lies that way: move natively. smart-splits adds
    --    nothing here, and going through it flickers the statusline.
    if in_float then
      local target = window_in_direction(dir_key)
      if target then
        vim.api.nvim_set_current_win(target)
        return
      end
    elseif vim.fn.winnr() ~= vim.fn.winnr(dir_key) then
      vim.cmd.wincmd(dir_key)
      return
    end

    -- At an nvim edge. Only hand over to tmux when a pane really exists.
    if tmux_has_pane(dir_key) == false then
      if not in_float then
        wrap_within_nvim(dir_key)
      end
      return
    end

    -- 2. A real tmux pane that way (or tmux unreachable).
    mux_fn()
  end
end

vim.keymap.set({ 'n', 't' }, '<C-h>', smart_move('h', smart_splits.move_cursor_left))
vim.keymap.set({ 'n', 't' }, '<C-j>', smart_move('j', smart_splits.move_cursor_down))
vim.keymap.set({ 'n', 't' }, '<C-k>', smart_move('k', smart_splits.move_cursor_up))
vim.keymap.set({ 'n', 't' }, '<C-l>', smart_move('l', smart_splits.move_cursor_right))
-- swapping buffers between windows
vim.keymap.set('n', '<leader><a-h>', smart_splits.swap_buf_left)
vim.keymap.set('n', '<leader><a-j>', smart_splits.swap_buf_down)
vim.keymap.set('n', '<leader><a-k>', smart_splits.swap_buf_up)
vim.keymap.set('n', '<leader><a-l>', smart_splits.swap_buf_right)

vim.keymap.set("x", "<a-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<a-k>", ":move '<-2<CR>gv-gv")
vim.keymap.set("v", "<a-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<a-k>", ":m '<-2<CR>gv=gv")
