local helpers = require("utils.helpers")
local codediff = helpers.safe_require("codediff")

if not codediff then return end

codediff.setup({
  keymaps = {
    view = {
      quit = "q",
      toggle_explorer = "<c-b>",
      next_hunk = "<leader>gn",
      prev_hunk = "<leader>gN",
      show_help = "<leader>g?",
    },
    explorer = {
      select = "o",
      toggle_staged = "s",
      toggle_changes = "c",
      toggle_view_mode = "i",
      restore = "X",
    },
    history = {
      select = "o",
      toggle_view_mode = "i",
    },
    conflict = {
      next_conflict = "<leader>gn",
      prev_conflict = "<leader>gN",
      accept_incoming = "<leader>ct",
      accept_current = "<leader>co",
      accept_both = "<S-CR>",
      discard = "<ESC>",
      discard_all = "<S-ESC>",
    }
  },
})

local default_map_opts = { noremap = true, silent = false }
local function opt(desc, others)
  return vim.tbl_extend("force", default_map_opts, { desc = desc }, others or {})
end
local keymap = vim.keymap.set

keymap("n", "<leader>gd", ":CodeDiff<CR>", opt("Codediff on HEAD"))

keymap("n", "<leader>gm", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("CodeDiff merge: current buffer has no file", vim.log.levels.WARN)
    return
  end
  vim.cmd("CodeDiff merge " .. vim.fn.fnameescape(file))
end, opt("CodeDiff merge on current file"))

local function bind_smart_accept(tabpage, tries)
  tries = tries or 0
  local session = require("codediff.ui.lifecycle").get_session(tabpage)
  if not session then
    if tries < 40 then
      vim.defer_fn(function() bind_smart_accept(tabpage, tries + 1) end, 25)
    end
    return
  end

  local function smart_accept()
    local buf = vim.api.nvim_get_current_buf()
    local conflict = require("codediff.ui.conflict")
    if buf == session.original_bufnr then
      conflict.accept_incoming(tabpage)
    elseif buf == session.modified_bufnr then
      conflict.accept_current(tabpage)
    else
      vim.notify("CodeDiff smart-accept: not in a side panel", vim.log.levels.INFO)
    end
  end

  for _, bufnr in ipairs({ session.original_bufnr, session.modified_bufnr }) do
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.keymap.set("n", "<CR>", smart_accept, {
        buffer = bufnr,
        desc = "CodeDiff: smart accept (left=incoming, right=current)",
      })
    end
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffOpen",
  callback = function(args)
    if args.data and args.data.tabpage then
      bind_smart_accept(args.data.tabpage)
    end
  end,
})
