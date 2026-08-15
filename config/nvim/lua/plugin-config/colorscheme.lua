local helpers = require("utils.helpers")
local fallback_colorscheme = "habamax"

local M = {}

local statusbar_colors = {
  ground = 'none',    -- the bar itself -- inherit the terminal

  accent = '#D19097', -- identity only: the filename, and the branch chip
  ink    = '#1d2021', -- text on the accent chip
  quiet  = '#9c8f91', -- the position, and any other secondary text
  rule   = '#7c6f64', -- the " | " between groups on the left

  chip1  = '#3c3836', -- diff
  chip2  = '#504945', -- lsp
  text   = '#d5c4a1', -- text on chip2

  diag_error = '#eb6f92',
  diag_warn  = '#f6c177',
  diag_info  = '#7daea3',
  diag_hint  = '#83a598',

  diff_added    = '#a9b665',
  diff_modified = '#d8a657',
  diff_removed  = '#ea6962',
}


M.colorscheme_conf = {
  gruvbox_shokry = function()
    local gruvbox_shokry = helpers.safe_require("gruvbox")
    if not gruvbox_shokry then
      vim.notify("color scheme gruvbox shokry not installed, fallback to " .. fallback_colorscheme, vim.log.levels.ERROR)
      vim.cmd("colorscheme " .. fallback_colorscheme)
      return
    end

    gruvbox_shokry.setup({
      enable = {
        terminal = true,
        migrations = true,
        devicons = true,
        lualine = true,
      },

      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },

      highlight_groups = {
        BlinkCmpMenu = { bg = "#32302f" },
        BlinkCmpMenuSelection = { bg = "#504945" },

        SnacksIndentScope = { fg = "#9ccfd8", bold = true },

        IlluminatedWordRead = { bg = "#45475A", underline = false },
        IlluminatedWordText = { bg = "#45475A", underline = false },
        IlluminatedWordWrite = { bg = "#45475A", underline = false },

        LspReferenceRead = { bg = "#504945", underline = false },
        LspReferenceText = { bg = "#504945", underline = false },
        LspReferenceWrite = { bg = "#504945", underline = false },

        Comment = { fg = "#928374" },

        ["@markup.heading.6.markdown"] = { fg = "#D1CFC0", bold = true },
        ["@markup.heading.5.markdown"] = { fg = "#a9a1e1", bold = true },
        ["@markup.heading.4.markdown"] = { fg = "#fabd2f", bold = true },
        ["@markup.heading.3.markdown"] = { fg = "#fe8019", bold = true },
        ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true },
        ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true },
        ["@markup.strong.markdown_inline"] = { fg = "#D19097", bold = true },
        ["@markup.italic.markdown_inline"] = { fg = "#D19097", italic = true },
      },
    })

    require("plugin-config.lualine")(statusbar_colors)

    vim.g['colortheme'] = "gruvbox"
    vim.cmd("colorscheme gruvbox")
  end,

  catppuccin_light = function()
    local catppuccin = helpers.safe_require("catppuccin")
    if not catppuccin then
      vim.notify("color scheme catppuccin not installed, fallback to " .. fallback_colorscheme, vim.log.levels.ERROR)
      vim.cmd("colorscheme " .. fallback_colorscheme)
      return
    end

    catppuccin.setup({
      -- use command :CatppuccinCompile to compile this config into cache
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      flavour = "latte",
      transparent_background = true,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
      },
    })

    local latte_statusbar = {
      ground = 'none',

      accent = '#933d46', -- darkened rose
      ink    = '#eff1f5', -- base
      quiet  = '#5c5f77', -- subtext1
      rule   = '#7c7f93', -- overlay2

      chip1  = '#ccd0da', -- surface0
      chip2  = '#bcc0cc', -- surface1
      text   = '#4a4d67', -- text

      diag_error = '#d20f39', -- red, verbatim
      diag_warn  = '#966014', -- yellow, darkened
      diag_info  = '#1e66f5', -- blue, verbatim
      diag_hint  = '#13787e', -- teal, darkened

      diff_added    = '#28651b', -- green, darkened
      diff_modified = '#7d4f10', -- yellow, darkened
      diff_removed  = '#b30d31', -- red, darkened
    }

    require("plugin-config.lualine")(latte_statusbar)

    vim.g['colortheme'] = "catppuccin_light"
    vim.cmd("colorscheme catppuccin")
  end,

  catppuccin_dark = function()
    local catppuccin = helpers.safe_require("catppuccin")
    if not catppuccin then
      vim.notify("color scheme catppuccin not installed, fallback to " .. fallback_colorscheme, vim.log.levels.ERROR)
      vim.cmd("colorscheme " .. fallback_colorscheme)
      return
    end

    catppuccin.setup({
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
      },
    })

    local catppuccin_statusbar = {
      ground = 'none',

      accent = '#f5c2e7', -- pink
      ink    = '#1e1e2e', -- base
      quiet  = '#a6adc8', -- subtext0
      rule   = '#6c7086', -- overlay0

      chip1  = '#313244', -- surface0
      chip2  = '#45475a', -- surface1
      text   = '#bac2de', -- subtext1

      diag_error = '#f38ba8', -- red
      diag_warn  = '#f9e2af', -- yellow
      diag_info  = '#89b4fa', -- blue
      diag_hint  = '#94e2d5', -- teal

      diff_added    = '#a6e3a1', -- green
      diff_modified = '#f9e2af', -- yellow
      diff_removed  = '#f38ba8', -- red
    }

    require("plugin-config.lualine")(catppuccin_statusbar)

    vim.g['colortheme'] = "catppuccin_dark"
    vim.cmd("colorscheme catppuccin")
  end,

  rosepine_dark = function()
    local rosepine = helpers.safe_require("rose-pine")
    if not rosepine then
      vim.notify("color scheme rose-pine not installed, fallback to " .. fallback_colorscheme, vim.log.levels.ERROR)
      vim.cmd("colorscheme " .. fallback_colorscheme)
      return
    end

    rosepine.setup({
      variant = "moon",
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
    })

    require("plugin-config.lualine")(statusbar_colors)

    vim.g['colortheme'] = "rosepine_dark"
		vim.cmd("colorscheme rose-pine")
  end,

  gruvbox_material_dark = function()
    require("lazy").load({ plugins = { "gruvbox-material" } })

    vim.g.gruvbox_material_foreground = "original"
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_transparent_background = 1

    vim.g['colortheme'] = "gruvbox_material_dark"
		vim.cmd("colorscheme gruvbox-material")

    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#45475A" })
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#45475A" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#45475A" })

    vim.api.nvim_set_hl(0, "NvimTreeOpenedHL", { bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#6c7087", bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = "#e8dcb7", bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#83a598", bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#83a598", bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#83a598", bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#d19097" })

    require("plugin-config.lualine")(statusbar_colors)
  end,
}

M.colorscheme_selector = function ()
  local items = vim.tbl_keys(M.colorscheme_conf)

  vim.ui.select(items, { prompt = "Select colorscheme " }, function(selection)
    if not selection then
      vim.notify("Canceled.", vim.log.levels.WARN)
      return
    end

    local fn = M.colorscheme_conf[selection]
    if fn then
      fn()
    else
      vim.notify("Invalid option: " .. selection, vim.log.levels.ERROR)
    end
  end)
end

return M
