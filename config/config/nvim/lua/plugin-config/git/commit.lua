local default_map_opts = { noremap = true, silent = false }
local function opt(desc, others)
  return vim.tbl_extend("force", default_map_opts, { desc = desc }, others or {})
end

local function do_commit(msg, tries)
  tries = tries or 0
  local res = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
  local out = ((res.stdout or "") .. (res.stderr or "")):gsub("%s+$", "")

  if res.code ~= 0 and out:find("index%.lock.*File exists") and tries < 6 then
    vim.defer_fn(function() do_commit(msg, tries + 1) end, 150)
    return
  end

  if res.code == 0 then
    vim.notify(out, vim.log.levels.INFO)
    local ok, gs = pcall(require, "gitsigns")
    if ok then gs.refresh() end
    require("utils.git").refresh_explorer_git()
  else
    vim.notify(out, vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<leader>gC", function()
  vim.ui.input({ prompt = "commit -m: " }, function(msg)
    if not msg or msg == "" then return end
    do_commit(msg)
  end)
end, opt("Quick git commit -m"))
