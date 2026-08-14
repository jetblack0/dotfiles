local helpers = require("utils.helpers")
local gitsigns = helpers.safe_require("gitsigns")
local git_util = require("utils.git")

if not gitsigns then return end

gitsigns.setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "│" },
  },

  on_attach = function(bufnr)
    local keymap = vim.keymap.set
    local opts = { silent = false }
    local function opt(desc, others)
      return vim.tbl_extend("force", opts, { desc = desc }, others or {})
    end

    keymap("n", "<leader>gs", function() gitsigns.toggle_signs() end, opt("Toggle git sign"))
    keymap("n", "<leader>gc", function()
      gitsigns.stage_hunk()
      git_util.refresh_explorer_git()
    end, opt("Git sign toggle stage hunk"))
    keymap("v", "<leader>gc", function()
      local s, e = vim.fn.line("v"), vim.fn.line(".")
      if s > e then s, e = e, s end
      gitsigns.stage_hunk({ s, e })
      git_util.refresh_explorer_git()
    end, opt("Git sign stage all hunks in visual selection"))
    keymap("n", "<leader>gv", function()
      vim.schedule(function()
        gitsigns.preview_hunk_inline()
      end)
    end, opt("Preview hunk inline"))

    keymap("n", "<leader>gV", function()
      vim.schedule(function()
        gitsigns.preview_hunk()
      end)
    end, opt("Preview hunk"))

    keymap("n", "<leader>gn", function()
      vim.schedule(function()
        gitsigns.next_hunk()
      end)
    end, opt("Next hunk"))

    keymap("n", "<leader>gN", function()
      vim.schedule(function()
        gitsigns.prev_hunk()
      end)
    end, opt("Previous hunk"))
  end
}

vim.keymap.set("n", "<leader>ga", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("Buffer has no file", vim.log.levels.WARN)
    return
  end
  local rel = vim.fn.fnamemodify(file, ":.")

  local status = vim.system({ "git", "status", "--porcelain", "--", file }, { text = true }):wait()
  if status.code ~= 0 then
    vim.notify("git status failed: " .. (status.stderr or ""), vim.log.levels.ERROR)
    return
  end
  local line = status.stdout or ""
  if line == "" then
    vim.notify("Clean — nothing to stage or unstage", vim.log.levels.INFO)
    return
  end
  local x, y = line:sub(1, 1), line:sub(2, 2)

  local function refresh()
    pcall(gitsigns.refresh)
    git_util.refresh_explorer_git(file)
  end

  local function unstage()
    local cmd = (x == "A")
      and { "git", "rm", "--cached", "--quiet", "--", file }
      or { "git", "restore", "--staged", "--", file }
    local r = vim.system(cmd, { text = true }):wait()
    if r.code == 0 then
      vim.notify("Unstaged: " .. rel, vim.log.levels.INFO)
      refresh()
    else
      vim.notify("Unstage failed: " .. ((r.stderr or "") .. (r.stdout or "")), vim.log.levels.ERROR)
    end
  end

  if x == "?" then
    local r = vim.system({ "git", "add", "--", file }, { text = true }):wait()
    if r.code == 0 then
      vim.notify("Staged untracked file: " .. rel, vim.log.levels.INFO)
      refresh()
    else
      vim.notify("git add failed: " .. ((r.stderr or "") .. (r.stdout or "")), vim.log.levels.ERROR)
    end
  elseif y == " " then
    unstage()
  else
    local hunks = gitsigns.get_hunks() or {}
    if #hunks > 0 then
      local n = #hunks
      gitsigns.stage_buffer(function(err)
        if err then
          vim.notify("stage_buffer: " .. tostring(err), vim.log.levels.ERROR)
        else
          vim.notify("Staged " .. n .. " hunk" .. (n == 1 and "" or "s") .. " in buffer", vim.log.levels.INFO)
          git_util.refresh_explorer_git(file)
        end
      end)
    else
      local r = vim.system({ "git", "add", "--", file }, { text = true }):wait()
      if r.code == 0 then
        vim.notify("Staged: " .. rel, vim.log.levels.INFO)
        refresh()
      else
        vim.notify("git add failed: " .. ((r.stderr or "") .. (r.stdout or "")), vim.log.levels.ERROR)
      end
    end
  end
end, { silent = false, desc = "Toggle staging for buffer (stage/unstage)" })

-- Re-read git state on focus so gitsigns isn't stale.
local last_git_reload = 0
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("gitsigns_reload_on_focus", { clear = true }),
  callback = function()
    local now = vim.uv.hrtime()
    if now - last_git_reload < 1e9 then return end
    last_git_reload = now

    local ok, gs_config = pcall(require, "gitsigns.config")
    local base = ok and gs_config.config and gs_config.config.base or nil
    pcall(gitsigns.change_base, base, true)
  end,
  desc = "Re-read git state after external git operations",
})
