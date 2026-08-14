-- General
-- ---------------------------------------------
-- Don't continue comments onto the next line, and don't auto-wrap code.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable automatic commenting on newline",
})

-- Highlight a selection on yank.
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function() vim.hl.on_yank({ on_visual = false, timeout = 250 }) end,
-- })

-- Remember folds between sessions.
local folds = vim.api.nvim_create_augroup("remember_folds", { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = folds,
  pattern = "*.*",
  command = "mkview",
  desc = "Save the view (folds, cursor) on leaving a window",
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = folds,
  pattern = "*.*",
  command = "silent! loadview",
  desc = "Restore the saved view on entering a window",
})


-- External changes
-- ---------------------------------------------
-- Pick up changes made to open files by anything outside nvim.
local external_changes = vim.api.nvim_create_augroup("external_changes", { clear = true })

-- CursorHoldI is deliberately absent: on a locally-modified buffer `checktime`
-- raises the W12 conflict prompt, which must not interrupt insert mode.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = external_changes,
  callback = function()
    if vim.fn.mode() == "c" then return end
    if vim.bo.buftype ~= "" then return end
    vim.cmd("checktime")
  end,
  desc = "Check for external file changes and reload",
})

-- Say so when a buffer is swapped out from under the cursor.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = external_changes,
  callback = function(args)
    vim.notify(
      ("Reloaded from disk: %s"):format(vim.fn.fnamemodify(args.file, ":t")),
      vim.log.levels.INFO
    )
  end,
  desc = "Notify when a buffer was reloaded from disk",
})


-- Input method
-- ---------------------------------------------
-- Switch fcitx5 back to English when leaving insert mode.
-- vim.cmd[[let fcitx5state=system("fcitx5-remote")]]
-- vim.cmd[[autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c]]
-- vim.cmd[[autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif]]


-- Filetype detection
-- ---------------------------------------------
vim.filetype.add({
  extension = {
    -- Terraform / OpenTofu.
    tf = "terraform",
    tfvars = "terraform",
    tfstate = "json",
    alloy = "hcl",
    hcl = "hcl",
    -- Templating.
    j2 = "jinja",
    ejs = "html",
    gotmpl = "gotmpl",
    -- Jenkins.
    groovy = "groovy",
  },
  filename = {
    [".terraformrc"] = "hcl",
    ["terraform.rc"] = "hcl",
    ["Dockerfile"] = "dockerfile",
  },
  pattern = {
    -- Ansible: playbooks, plus role tasks and handlers.
    [".*/playbooks/.*%.ya?ml"] = { "yaml.ansible", { priority = 10 } },
    [".*/roles/.*/tasks/.*%.ya?ml"] = { "yaml.ansible", { priority = 10 } },
    [".*/roles/.*/handlers/.*%.ya?ml"] = { "yaml.ansible", { priority = 10 } },
    -- Helm charts.
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
    -- Terraform state backups.
    [".*%.tfstate%.backup"] = "json",
    [".*[Jj]enkinsfile.*"] = "groovy",
  },
})

-- Any YAML inside an Ansible project is yaml.ansible.
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.yml", "*.yaml" },
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    while dir ~= "/" do
      if vim.fn.filereadable(dir .. "/ansible.cfg") == 1 then
        vim.bo[args.buf].filetype = "yaml.ansible"
        return
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
  end,
  desc = "Detect Ansible YAML by a nearby ansible.cfg",
})

-- Docker Compose.
-- vim.filetype.add({
--   filename = {
--     ["compose.yaml"] = "yaml.docker-compose",
--     ["compose.yml"] = "yaml.docker-compose",
--     ["docker-compose.yaml"] = "yaml.docker-compose",
--     ["docker-compose.yml"] = "yaml.docker-compose",
--   },
-- })


-- Indentation
-- ---------------------------------------------
local two_space_filetypes = {
  "sh", "text", "yuck",
  "html", "htmldjango", "xml", "css",
  "json", "jsonc",
  "javascript", "javascriptreact", "typescript", "typescriptreact",
  "lua", "ruby", "nix", "groovy",
  "jinja", "yaml", "helm", "yaml.helm", "yaml.ansible",
}

local four_space_filetypes = {
  "markdown", "java",
}

local function set_indent(width)
  return function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = width
    vim.opt_local.tabstop = width
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = two_space_filetypes,
  callback = set_indent(2),
  desc = "Indent with two spaces",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = four_space_filetypes,
  callback = set_indent(4),
  desc = "Indent with four spaces",
})
