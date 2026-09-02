local helpers = require("utils.helpers")
local Hydra = helpers.safe_require("hydra")
if not Hydra then return end

local git_util = require("utils.git")

local NAV = { target = "all", wrap = true }

-- gitsigns' actions are async in themselves, so there is nothing to defer.
local function run(fn)
  return function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
      fn(gitsigns)
    end
  end
end

local function nav(direction)
  return run(function(gitsigns) gitsigns.nav_hunk(direction, NAV) end)
end

Hydra({
  name = "Git hunks",
  mode = "n",
  body = "<C-g>",
  config = {
    color = "pink", -- unmapped keys work and still in the mode until ESC
    invoke_on_body = true,
    hint = { type = "window", position = { "bottom" } },
  },
  heads = {
    { "j", nav("next"), { desc = "next" } },
    { "k", nav("prev"), { desc = "prev" } },
    { "g", nav("first"), { desc = "first" } },
    { "G", nav("last"), { desc = "last" } },
    {
      "s",
      run(function(gitsigns)
        gitsigns.stage_hunk()
        git_util.refresh_explorer_git()
      end),
      { desc = "stage/unstage" },
    },
    { "p", run(function(gitsigns) gitsigns.preview_hunk_inline() end), { desc = "preview" } },
    { "b", run(function(gitsigns) gitsigns.blame_line({ full = true }) end), { desc = "blame" } },
    { "<Esc>", nil, { exit = true, desc = "done" } },
    { "q", nil, { exit = true, desc = false } },
  },
})
