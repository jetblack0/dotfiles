local helpers = require("utils.helpers")
local snacks = helpers.safe_require("snacks")
-- local opencode = helpers.safe_require("opencode")
-- if not snacks and opencode then return end

-- Define which file types should the plguin be loaded.
local indent_line_filetypes = {
  "html", "css", "htmldjango",
  "javascript", "javascriptreact", "typescriptreact", "typescript",
  "yaml*", "json", "jsonc", "yaml.ansible", "yml", "helm", "yaml.helm",
  "rust", "java", "c", "make", "go",
  "lua", "sh", "python", "ruby",
  "groovy", "terraform", "nginx", "nix"
}

-- Fix snacks explorer icons showing partially staged files as fully staged.
local function worktree_icon(item, picker)
  local xy = item.status
  if type(xy) ~= "string" or #xy < 2 or xy:sub(2, 2) == " " then
    return nil
  end

  local git = require("snacks.picker.source.git")
  local ok, status = pcall(git.git_status, xy)
  if not ok or not status.staged or status.unmerged then
    return nil
  end

  local ok_wt, worktree = pcall(git.git_status, " " .. xy:sub(2, 2))
  local name = ok_wt and worktree.status or "modified"
  local icons = picker.opts.icons.git
  -- Keep the icon exactly as configured, leading space included.
  return icons[name] or icons.modified,
    "SnacksPickerGitStatus" .. name:sub(1, 1):upper() .. name:sub(2)
end

-- Remember cursor and expanded dirs, restore on the next open.
local last_explorer = nil

snacks.setup({
  bigfile = {
    enabled = true
  },
  indent = {
    enabled = false,
    indent = {
      char = "╎",
      hl = "SnacksIndent",
    },
    scope = {
      enabled = true,
      priority = 200,
      char = "╎",
      underline = false,
      only_current = false,
      hl = "SnacksIndentScope",
    },
    animate = {
      enabled = true
    }
  },
  input = {
    enabled = true,
    win = {
      keys = {
        n_esc = false,
      },
    },
  },
  notifier = {
    enabled = true
  },
  quickfile = {
    enabled = true
  },

  picker = {
    enabled = true,

    actions = {
      opencode_send = function(...) return opencode.snacks_picker_send(...) end,

      -- Like explorer_focus, but moves nvim's cwd too so the new root outlives
      -- the explorer. snacks' own DirChanged handler re-roots and refreshes.
      explorer_focus_cd = function(picker)
        vim.cmd.cd(picker:dir())
      end,

      codediff_commit = function(picker, item)
        local commit = item.commit
        picker:close()
        vim.schedule(function()
          vim.cmd("CodeDiff " .. commit .. "^ " .. commit)
        end)
      end,

      codediff_worktree = function(picker, item)
        local commit = item.commit
        picker:close()
        vim.schedule(function()
          vim.cmd("CodeDiff " .. commit)
        end)
      end,

      codediff_range = function(picker)
        local sel = picker:selected()
        if #sel ~= 2 then
          vim.notify(
            "CodeDiff range: select exactly 2 commits with <Tab> (got " .. #sel .. ")",
            vim.log.levels.WARN
          )
          return
        end
        local a, b = sel[1].commit, sel[2].commit
        if not a or not b then
          vim.notify("codediff_range: selected items have no .commit field", vim.log.levels.ERROR)
          return
        end
        picker:close()
        vim.schedule(function()
          vim.cmd("CodeDiff " .. a .. " " .. b)
        end)
      end,
    },

    icons = {
      git = {
        enabled   = true,
        commit    = " 󰜘",
        staged    = " ",
        added     = " ",
        deleted   = " ",
        ignored   = " ◌",
        modified  = " ",
        renamed   = " ",
        unmerged  = " ",
        untracked = " ",
      },
      diagnostics = {
        Error = " ",
        Warn  = "󰃤 ",
        Hint  = " ",
        Info  = "󰋽 ",
      },
    },

    layout = {
      layout = {
        backdrop = false,
        row = 1,
        width = 0.4,
        min_width = 80,
        height = 0.9,
        border = "none",
        box = "vertical",
        { win = "preview", title = "{preview}", height = 0.6, border = true },
        {
          box = "vertical",
          border = true,
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
        },
      },
    },

    previewers = {
      diff = {
      }
    },

    formatters = {
      file = {
        -- Never tint a name by its git status -- not files, not directories.
        -- The right-aligned git icon is the indicator.
        git_status_hl = false,
      },
    },

    win = {
      input = {
        keys = {
          ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
          ["/"] = "toggle_focus",
          ["<a-j>"] = { "list_down", mode = { "i", "n" } },
          ["<a-k>"] = { "list_up", mode = { "i", "n" } },
          ["<a-n>"] = { "cycle_win", mode = { "i", "n" } },
          ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
          ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
          ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
          ["<c-y>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-e>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["G"] = { "list_bottom", mode = { "i", "n" } },
          ["gg"] = { "list_top", mode = { "i", "n" } },
          ["<CR>"] = { "confirm", mode = { "n", "i" } },
          ["l"] = { "confirm", mode = { "n" } },
          ["<Esc>"] = { "cancel", mode = { "n" } },
          ["<C-c>"] = { "cancel", mode = "i" },
          ["?"] = "toggle_help_input",
        }
      },
      list = {
        keys = {
          ["/"] = false,
          ["<c-f>"] = "toggle_focus",
          ["<c-y>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-e>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
          ["<a-n>"] = { "cycle_win", mode = { "i", "n" } },
          ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        }
      },
      preview = {
        keys = {
          ["<a-n>"] = "cycle_win",
          ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        }
      }
    },

    sources = {
      git_log = {
        win = {
          input = {
            keys = {
              ["<c-j>"] = {
                "codediff_worktree",
                mode = { "i", "n" },
                desc = "CodeDiff: working tree vs this commit",
              },
              ["<c-k>"] = {
                "codediff_commit",
                mode = { "i", "n" },
                desc = "CodeDiff: changes introduced by this commit (parent^ vs commit)",
              },
              ["<c-l>"] = {
                "codediff_range",
                mode = { "i", "n" },
                desc = "CodeDiff: range diff between 2 commits (mark both with <Tab>)",
              },
            },
          },
        },
      },
      git_log_file = {
        win = {
          input = {
            keys = {
              ["<c-j>"] = {
                "codediff_worktree",
                mode = { "i", "n" },
                desc = "CodeDiff: working tree vs this commit",
              },
              ["<c-k>"] = {
                "codediff_commit",
                mode = { "i", "n" },
                desc = "CodeDiff: changes introduced by this commit (parent^ vs commit)",
              },
              ["<c-l>"] = {
                "codediff_range",
                mode = { "i", "n" },
                desc = "CodeDiff: range diff between 2 commits (mark both with <Tab>)",
              },
            },
          },
        },
      },

      explorer = {
        ignored = false,
        -- Opening the explorer shouldn't yank the cursor to the current file;
        -- `F` reveals on demand.
        follow_file = false,

        on_close = function(picker)
          local tree = require("snacks.explorer.tree")
          local cwd, item, open = picker:cwd(), picker:current(), {}
          tree:walk(tree:find(cwd), function(node)
            if node.dir and node.open then open[#open + 1] = node.path end
          end, { all = true })
          last_explorer = { cwd = cwd, file = item and item.file or nil, open = open }
        end,

        -- `Snacks.explorer.reveal` passes its own on_show, so `F` still wins.
        on_show = function(picker)
          local state = last_explorer
          if not state or state.cwd ~= picker:cwd() then return end
          -- snacks re-expands the path to the current buffer on every open,
          -- which undoes a `W`. Put the tree back the way it was left.
          -- Flip the flag directly rather than tree:open(): that re-walks every
          -- parent, and recreates nodes for directories deleted meanwhile.
          -- `nodes` is keyed by the same string as `node.path`, so index it
          -- rather than tree:node(), which normalises the path twice.
          local tree = require("snacks.explorer.tree")
          tree:close_all(state.cwd)
          for _, path in ipairs(state.open) do
            local node = tree.nodes[path]
            if node then node.open = true end
          end
          require("snacks.explorer.actions").update(picker, { target = state.file, refresh = true })
        end,

        diagnostics = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,

        format = function(item, picker)
          local ret = Snacks.picker.format.file(item, picker)
          local icon, hl = worktree_icon(item, picker)
          if not icon then
            return ret
          end
          -- Append to the git icon, identified by its highlight: diagnostics
          -- can also render right-aligned.
          for _, entry in ipairs(ret) do
            local vt = entry.virt_text
            if vt and vt[1] and type(vt[1][2]) == "string" and vt[1][2]:find("^SnacksPickerGitStatus") then
              entry.virt_text = { vt[1], { icon, hl }, { " " } }
              break
            end
          end
          return ret
        end,

        -- Swap in this version to keep the status colour on files, but not on
        -- directories. Needs `formatters.file.git_status_hl = true` above.
        -- format = function(item, picker)
        --   local formatter = picker.opts.formatters.file
        --   local saved = formatter.git_status_hl
        --   if item.dir then
        --     formatter.git_status_hl = false
        --     item.filename_hl = nil -- drop anything stamped on by an earlier render
        --   end
        --   local ok, ret = pcall(Snacks.picker.format.file, item, picker)
        --   formatter.git_status_hl = saved
        --   if not ok then error(ret) end
        --   local icon, hl = worktree_icon(item, picker)
        --   if icon then
        --     for _, entry in ipairs(ret) do
        --       local vt = entry.virt_text
        --       if vt and vt[1] and type(vt[1][2]) == "string" and vt[1][2]:find("^SnacksPickerGitStatus") then
        --         entry.virt_text = { vt[1], { icon, hl }, { " " } }
        --         break
        --       end
        --     end
        --   end
        --   return ret
        -- end,

        layout = {
          preset = "sidebar",
          preview = false,
          layout = {
            position = "left",
            width = 0.2,
          },
        },
        win = {
          list = {
            keys = {
              ["<a-h>"] = false,
              ["<Esc>"] = false,
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["H"] = "explorer_up",
              -- ["<Space>"] = "select_and_next",
              ["o"] = "confirm",
              ["W"] = "explorer_close_all",
              ["f"] = "explorer_focus_cd",
              ["."] = "toggle_hidden",
              [">"] = "toggle_ignored",
              ["O"] = "explorer_open",
              ["<leader>w"] = "picker_grep",
              ["<leader>gn"] = "explorer_git_next",
              ["<leader>gN"] = "explorer_git_prev",
              ['<c-t>'] = { 'tab', mode = { 'i', 'n' } },
              ['<c-b>'] = { function ()
                Snacks.explorer()
              end, mode = { 'i', 'n' } },
            },
          },
        },
      }
    }
  },

  explorer = {
    enabled = true,
    replace_netrw = true,
    trash = true,
  },

  image = {
    enabled = true,
    cache = vim.fn.stdpath("cache") .. "/snacks/image",
    formats = {
      "png", "jpg", "jpeg", "gif", "bmp", "webp",
      "tiff", "heic", "avif", "icns",
    },
    doc = {
      enabled = true,
      inline = false,
      float = false,
      max_width = 60,
      max_height = 20,
    }
  },

  dim = {
    enabled = true,
  },
  zen = {
    enabled = true,
    toggles = {
      dim = true,
      git_signs = true,
      mini_diff_signs = true,
      diagnostics = false,
      inlay_hints = false,
    },
  },

  statuscolumn = { enabled = true },
  scroll = { enabled = false },
  words = {
    enabled = true,
    debounce = 300,
    notify_jump = false,
    notify_end = false,
    filter = function(buf)
      local denylist = {
        dirvish = true,
        fugitive = true,
        NvimTree = true,
        packer = true,
        Netrw = true,
      }
      if denylist[vim.bo[buf].filetype] then return false end
      return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
  },
  dashboard = { enabled = false },
  scope = { enabled = false },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = indent_line_filetypes,
  callback = function()
    Snacks.indent.enable()
  end,
})


-- Keymaps
-- ---------------------------------------------
-- indent
vim.g.snacks_scope = false
vim.keymap.set("n", "<leader>o", function()
  vim.g.snacks_scope = not vim.g.snacks_scope
  if vim.g.snacks_scope then
    vim.notify("indent scope enabled", vim.log.levels.INFO)
  else
    vim.notify("indent scope disabled", vim.log.levels.WARN)
  end
end, { desc = "Toggle my snack indent scope" })

-- buffer
vim.keymap.set("n", "<c-w>D", function()
  Snacks.bufdelete()
  vim.notify("Deleted current buffer", vim.log.levels.WARN)
end, { desc = "Delete current buffer" })

vim.keymap.set("n", "<c-w>D", function()
  Snacks.bufdelete.others()
  vim.notify("Deleted all buffers except the curent one", vim.log.levels.WARN)
end, { desc = "Delete current buffer" })

-- zen mode
vim.keymap.set("n", "<leader>z", function()
  vim.g.snacks_scope = true
  Snacks.zen.zen()
end, { desc = "Toggle zen mode" })

-- image
vim.keymap.set("n", "<leader>p", function()
  Snacks.image.hover()
end, { desc = "Show hovered image" })

-- explorer
local function explorer_initializing()
  local ok, pending = pcall(function()
    for _, p in ipairs(Snacks.picker.get({ source = "explorer", tab = false })) do
      local shown = p.layout ~= nil and p.layout:valid()
      local age_ms = (vim.uv.hrtime() - (p.start_time or 0)) / 1e6
      if not shown and not p.closed and age_ms < 2000 then
        return true
      end
    end
    return false
  end)
  return ok and pending == true
end

vim.keymap.set({ "n", "t" }, "<c-b>", function()
  if explorer_initializing() then return end
  Snacks.explorer()
end, { desc = "File Explorer" })

vim.keymap.set("n", "F", function()
  if explorer_initializing() then return end
  -- Pressed from inside the explorer, buf 0 is its nameless scratch buffer and
  -- there'd be nothing to reveal. Target the window it was opened from.
  local picker = Snacks.picker.get({ source = "explorer" })[1]
  local win = picker and picker.main
  local buf = win and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) or 0
  Snacks.explorer.reveal({ buf = buf })
end, { desc = "Locate the current buffer" })

-- telescope
vim.keymap.set("n", "<leader>e", function()
	Snacks.picker()
end, { desc = "Snacks picker" })

vim.keymap.set("n", "<leader>q", function()
	Snacks.picker.files()
end, { desc = "Snacks file picker" })

vim.keymap.set("n", "<leader>r", function()
	Snacks.picker.command_history()
end, { desc = "Snacks command history" })

vim.keymap.set("n", "<leader>w", function()
	Snacks.picker.grep()
end, { desc = "Snacks live grep" })

vim.keymap.set("n", "<leader>gl", function()
	Snacks.picker.git_log()
end, { desc = "Snacks show git log" })

vim.keymap.set("n", "<leader>gL", function()
	Snacks.picker.git_log_file()
end, { desc = "Snacks show git log for this file" })

vim.keymap.set("n", "<leader>gg", function()
	Snacks.picker.git_status()
end, { desc = "Snacks show git status" })

vim.keymap.set("n", "<leader>gb", function()
	Snacks.picker.git_branches()
end, { desc = "Snacks show git branches" })

vim.keymap.set({ "n", "t" }, "<c-f>", function ()
  Snacks.zen.zoom()
end, { desc = "Snacks toggle maximizing a window" })
