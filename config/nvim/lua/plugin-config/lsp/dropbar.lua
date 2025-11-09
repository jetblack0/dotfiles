local helpers = require("utils.helpers")
local dropbar = helpers.safe_require("dropbar")
local dropbar_api = helpers.safe_require("dropbar.api")
local dropbar_utils = helpers.safe_require("dropbar.utils")

if not dropbar then return end
if not dropbar_api then return end
if not dropbar_utils then return end

dropbar.setup({
  menu = {
    keymaps = {
      ["h"] = "<C-w>c",
      ['l'] = function()
        local menu = dropbar_utils.menu.get_current()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
        if component then
          menu:click_on(component, nil, 1, 'l')
        end
      end,
      ['o'] = function()
        local menu = dropbar_utils.menu.get_current()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
        if component then
          menu:click_on(component, nil, 1, 'l')
        end
      end,
    }
  }
})
vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
vim.keymap.set('n', '<Leader>K', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
vim.keymap.set('n', '<Leader>J', dropbar_api.select_next_context, { desc = 'Select next context' })
