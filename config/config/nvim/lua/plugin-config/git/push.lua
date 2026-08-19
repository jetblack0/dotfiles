-- Async git push, lazygit-style, without leaving Neovim or blocking the editor.
--
--   * has upstream      -> `git push` in the background
--   * no upstream (new) -> pick a remote (snacks `vim.ui.select`), then
--                          `git push --set-upstream <remote> <branch>`
--   * push rejected     -> offer a safe `--force-with-lease` retry
--
-- The slow part (the network push) runs via async `vim.system`, so the key
-- returns control immediately and a notification fires when it finishes.

local M = {}

-- in-flight pushes keyed by repo root, so mashing the key can't double-push the
-- same repo while still allowing pushes in other repos.
M._inflight = {}

local TITLE = "Git Push"

-- vim.system exit callbacks run in a fast event context, so every user-facing
-- call is wrapped in vim.schedule.
local function notify(msg, level)
  vim.schedule(function()
    vim.notify(msg, level or vim.log.levels.INFO, { title = TITLE })
  end)
end

local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

-- Synchronous git for the local/instant queries (branch, upstream, remotes).
-- Only the push itself is async — these complete in milliseconds.
local function git(cwd, args)
  local cmd = { "git" }
  vim.list_extend(cmd, args)
  return vim.system(cmd, { text = true, cwd = cwd }):wait()
end

--- Run the push asynchronously.
--- @param cwd string repo root
--- @param spec string[] full git argument list (e.g. { "push" })
--- @param branch string local branch name (for messages)
--- @param target string display target (e.g. "origin/feature")
--- @param allow_force boolean whether to offer force-with-lease on rejection
local function do_push(cwd, spec, branch, target, allow_force)
  if M._inflight[cwd] then
    notify("A push is already in progress for this repo", vim.log.levels.WARN)
    return
  end
  M._inflight[cwd] = true
  notify(("Pushing %s → %s …"):format(branch, target))

  local cmd = { "git" }
  vim.list_extend(cmd, spec)

  vim.system(cmd, { text = true, cwd = cwd }, function(res)
    M._inflight[cwd] = nil
    local out = trim((res.stderr or "") .. (res.stdout or ""))

    if res.code == 0 then
      if out:find("Everything up%-to%-date") then
        notify(("%s is already up to date on %s"):format(branch, target))
      else
        notify(("Pushed %s → %s"):format(branch, target))
      end
      return
    end

    local rejected = out:find("rejected")
      or out:find("non%-fast%-forward")
      or out:find("tip of your current branch is behind")

    if rejected and allow_force then
      vim.schedule(function()
        vim.ui.select(
          { "No — cancel (pull/rebase first)", "Yes — force-with-lease" },
          { prompt = ("Push rejected: '%s' is behind '%s'. Force push?"):format(branch, target) },
          function(choice)
            if choice ~= "Yes — force-with-lease" then
              notify("Push cancelled — remote is ahead; pull or rebase first", vim.log.levels.WARN)
              return
            end
            local forced = vim.deepcopy(spec)
            table.insert(forced, "--force-with-lease")
            do_push(cwd, forced, branch, target, false) -- only offer force once
          end
        )
      end)
    else
      notify("Push failed:\n" .. out, vim.log.levels.ERROR)
    end
  end)
end

--- Entry point: push the current buffer's repo.
function M.push()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end

  local top = git(dir, { "rev-parse", "--show-toplevel" })
  if top.code ~= 0 then
    notify("Not a git repository", vim.log.levels.ERROR)
    return
  end
  local root = trim(top.stdout)

  local branch = trim(git(root, { "branch", "--show-current" }).stdout)
  if branch == "" then
    notify("Detached HEAD — check out a branch before pushing", vim.log.levels.WARN)
    return
  end

  -- Does the branch already track an upstream?
  local up = git(root, { "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}" })
  if up.code == 0 then
    do_push(root, { "push" }, branch, trim(up.stdout), true)
    return
  end

  -- New branch: choose a remote, then push with --set-upstream.
  local remotes = vim.split(trim(git(root, { "remote" }).stdout), "\n", { trimempty = true })
  if #remotes == 0 then
    notify("No remotes configured (add one with `git remote add`)", vim.log.levels.ERROR)
    return
  end

  local function push_to(remote)
    do_push(root, { "push", "--set-upstream", remote, branch }, branch, remote .. "/" .. branch, false)
  end

  if #remotes == 1 then
    push_to(remotes[1]) -- single remote: no point prompting
  else
    vim.ui.select(remotes, {
      prompt = ("Push new branch '%s' to which remote?"):format(branch),
    }, function(choice)
      if not choice then
        notify("Push cancelled", vim.log.levels.WARN)
        return
      end
      push_to(choice)
    end)
  end
end

vim.keymap.set("n", "<leader>gp", M.push, {
  noremap = true,
  silent = false,
  desc = "Git push (async, upstream-aware)",
})

return M
