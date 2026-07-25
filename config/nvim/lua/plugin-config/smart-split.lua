local helpers = require("utils.helpers")
local smart_splits = helpers.safe_require("smart-splits")

smart_splits.setup({
  disable_multiplexer_nav_when_zoomed = false,
  -- nil = auto-detect (resolves to 'tmux' inside tmux); false = disabled.
  -- Set SMART_SPLITS_DISABLE=1 to opt out (e.g. on ssh sessions).
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
    return true -- can't tell; don't block navigation
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

local function smart_move(dir_key, mux_fn)
  return function()
    local in_float = vim.api.nvim_win_get_config(0).relative ~= ''
    local has_neighbor = vim.fn.winnr() ~= vim.fn.winnr(dir_key)
    if not in_float and has_neighbor then
      vim.cmd.wincmd(dir_key)
      return
    end

    if vim.env.TMUX then
      local ok, res = pcall(function()
        return vim.system(
          { 'tmux', 'display-message', '-p', '#{window_zoomed_flag}\n#{window_layout}' },
          { text = true }
        ):wait()
      end)
      if ok and res.code == 0 then
        local zoomed, layout = res.stdout:match('(%d+)\n(%S+)')
        if zoomed == '1' and not tmux_pane_exists(parse_tmux_layout(layout or ''), DIR_NAME[dir_key]) then
          return -- no real pane there: stay in nvim, stay zoomed
        end
      end
    end

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
