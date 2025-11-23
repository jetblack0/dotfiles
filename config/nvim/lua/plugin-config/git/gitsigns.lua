local helpers = require("utils.helpers")
local gitsigns = helpers.safe_require("gitsigns")

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
    keymap("n", "<leader>gp", function()
      vim.schedule(function()
        gitsigns.preview_hunk_inline()
      end)
    end, opt("Preview hunk inline"))

    keymap("n", "<leader>gP", function()
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
