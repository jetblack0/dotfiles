local M = {}

--- Force the snacks explorer to re-fetch git status and re-render.
--- @param path? string a path inside the repo whose root's cache to invalidate.
---   Defaults to the current buffer's file.
function M.refresh_explorer_git(path)
  path = path or vim.fn.expand("%:p")

  local ok_git, egit = pcall(require, "snacks.explorer.git")
  if ok_git and path and path ~= "" then
    egit.refresh(path) -- sets cache `last = 0` for the matching root
  end

  local ok_watch, watch = pcall(require, "snacks.explorer.watch")
  if ok_watch then
    watch.refresh()
  end
end

return M
