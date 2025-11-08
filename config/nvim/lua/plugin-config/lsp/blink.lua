local helpers = require("utils.helpers")
local blink = helpers.safe_require("blink.cmp")

if not blink then return end

blink.setup {
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_and_accept", "fallback" },
    ["<a-k>"] = { "select_prev", "fallback" },
    ["<a-j>"] = { "select_next", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<a-e>"] = { "cancel", "fallback" },
    ["<a-m>"] = { "show", "fallback" },
    -- ["<a-space>"] = {
    --   function(cmp)
    --     cmp.show({ providers = { 'snippets' } })
    --   end
    -- },
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ["<a-l>"] = { "snippet_forward", "fallback" },
    ["<a-h>"] = { "snippet_backward", "fallback" },
    -- ["<Tab>"] = { "snippet_forward", "fallback" },
    ['<S-Tab>'] = { 'snippet_backward', 'show', 'select_prev', 'fallback' },
  },

  sources = {
    default = { "lsp", "path", "buffer" },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        columns = {
          { 'kind_icon', 'label', gap = 2 },
          { 'label_description', gap = 1 },
          { 'source_name' },
        },
      },
    }
  },

  cmdline = {
    completion = {
      ghost_text = {
        enabled = true
      },
      menu = {
        auto_show = false,
      },
    },
    keymap = {
      ['<Tab>'] = { 'show', "select_and_accept" },
      ['<S-Tab>'] = { 'show', "select_and_accept" },
      ["<a-k>"] = { "select_prev", "fallback" },
      ["<a-j>"] = { "select_next", "fallback" },
      ["<a-e>"] = { "cancel", "fallback" },
      ["<a-m>"] = { "show", "fallback" },
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning"
  },
}




-- Additional keybindings
-------------------------
-- vim.keymap.set("n", "<leader>z", function()
--   blink.setup.buffer({ enabled = false }) 
--     vim.notify("Turn off cmp", vim.log.levels.INFO, { title = "Autocomplete" })
-- end, { desc = "Turn off blink.cmp" })
--
-- vim.keymap.set("n", "<leader>x", function()
--     vim.notify("Turn on blink.cmp", vim.log.levels.INFO, { title = "Autocomplete" })
--   blink.setup.buffer({ enabled = true }) 
-- end, { desc = "Turn on cmp" })
