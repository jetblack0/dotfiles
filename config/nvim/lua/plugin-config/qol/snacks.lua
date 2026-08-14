local helpers = require("utils.helpers")
local snacks = helpers.safe_require("snacks")
-- local opencode = helpers.safe_require("opencode")
-- if not snacks and opencode then return end

-- Define which file types should the plguin be loaded.
local indent_line_filetypes = {
  "html", "css", "htmldjango",
  "javascript", "javascriptreact", "tsx", "typescript",
  "yaml*", "json", "jsonc", "yaml.ansible", "yml", "helm", "yaml.helm",
  "rust", "java", "c", "make", "go",
  "lua", "sh", "python", "ruby",
  "groovy", "terraform", "nginx", "nix"
}

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
        diagnostics = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
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
              ["f"] = "explorer_focus",
              ["."] = "toggle_hidden",
              [">"] = "toggle_toggle_ignored",
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
--------------------
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
vim.keymap.set({ "n", "t" }, "<c-b>", function()
  Snacks.explorer()
end, { desc = "File Explorer" })

vim.keymap.set("n", "F", function()
  Snacks.explorer.reveal()
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
