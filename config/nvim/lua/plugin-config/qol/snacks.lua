local helpers = require("utils.helpers")
local snacks = helpers.safe_require("snacks")
if not snacks then return end

-- Define which file types should the plguin be loaded.
local indent_line_filetypes = {
  "html", "css", "htmldjango",
  "javascript", "javascriptreact", "tsx", "typescript",
  "yaml*", "json", "jsonc", "yaml.ansible", "yml",
  "rust", "java", "c", "make", "go",
  "lua", "sh", "python", "ruby",
  "groovy", "terraform", "nginx"
}

snacks.setup({
  bigfile = {
    enabled = true
  },
  indent = {
    enabled = false,
    indent = {
      char = "╎",
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
      enabled = false
    }
  },
  input = {
    enabled = true
  },
  notifier = {
    enabled = true
  },
  quickfile = {
    enabled = true
  },

  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["/"] = "toggle_focus",
          ["<a-j>"] = { "list_down", mode = { "i", "n" } },
          ["<a-k>"] = { "list_up", mode = { "i", "n" } },
          ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
          ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
          ["<c-y>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-e>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["G"] = { "list_bottom", mode = { "i", "n" } },
          ["gg"] = { "list_top", mode = { "i", "n" } },
          ["<CR>"] = { "confirm", mode = { "n", "i" } },
          ["<Esc>"] = { "cancel", mode = { "n" } },
          ["<C-c>"] = { "cancel", mode = "i" },
          ["?"] = "toggle_help_input",
        }
      }
    }
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

  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
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
vim.keymap.set("n", "<c-w>d", function()
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
end, { desc = "Delete current buffer" })

-- image
vim.keymap.set("n", "<leader>p", function()
  Snacks.image.hover()
end, { desc = "Show hovered image" })

