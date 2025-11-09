local helpers = require("utils.helpers")
local lualine = helpers.safe_require("lualine")
local web_devicons = helpers.safe_require("nvim-web-devicons")
-- local nvim_navic = helpers.safe_require("nvim-navic")

if not lualine then return end

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir

return function(colors)
  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand("%:p:h")
      local gitdir = vim.fn.finddir(".git", filepath .. ";")
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
    -- is_navic_available = function()
    --   return nvim_navic.is_available
    -- end,
  }

  -- Config
  local config = {
    options = {
      component_separators = "",
      section_separators = "",
      theme = {
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.bg } },
      },
      ignore_focus = { },
      disabled_filetypes = { "netrw" },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left({
    function()
      return "▊"
    end,
    color = { fg = colors.pink },
    padding = { left = 0, right = 1 },
  })

  ins_left({
    -- mode component
    function()
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      return web_devicons.get_icon(filename, extension, { default = true })
    end,
    padding = { right = 1, left = 1 },
    color = { fg = colors.pink }
    --[[ color = function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = colors.pink,
        i = colors.violet,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.orange,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end, ]]
  })

  ins_left({
    "filename",
    cond = conditions.buffer_not_empty,
    color = { fg = colors.pink, gui = "bold" },
  })

  ins_left({
    -- filesize component
    "filesize",
    cond = conditions.buffer_not_empty,
  })

  ins_left({ "location" })

  ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

  -- Add components to right sections
  ins_left({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = "󰃤 ", info = "󰋽 ", hint = " " },
    -- color = { fg = colors.darkblue, gui = "bold"},
    diagnostics_color = {
      error = 'LualineDiagnosticSignError',
      warn  = 'LualineDiagnosticSignWarn',
      info  = 'LualineDiagnosticSignInfo',
      hint  = 'LualineDiagnosticSignHint',
    },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  })

  ins_right({
    -- Lsp server name.
    cond = is_lsp_available,
    icon = '󰅩',
    color = { fg = colors.blue, gui = "bold" },

    function()
      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local clients = vim.lsp.get_clients()

      -- if next(client) == nil then
      --   return ""
      -- end

      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
    end,
  })

  -- ins_right({
  --   function ()
  --     return nvim_navic.get_location()
  --   end,
  --   cond = is_navic_available,
  --   color = { fg = colors.blue, gui = "bold" },
  -- })

  ins_right({
    "branch",
    icon = "",
    color = { fg = colors.fg },
  })

  ins_right({
    "diff",
    -- Is it me or the symbol for modified us really weird
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added = { fg = colors.green_diff },
      modified = { fg = colors.orange_diff },
      removed = { fg = colors.red_diff },
    },

    cond = conditions.hide_in_width,
  })

  ins_right({
    function()
      return "▊"
    end,
    color = { fg = colors.pink },
    padding = { left = 1 },
  })

  lualine.setup(config)
end
