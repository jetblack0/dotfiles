local helpers = require("utils.helpers")
local fallback_colorscheme = "habamax"

local M = {}

local lualine_colors = {
  bg = '#3C3836',
  fg = '#D1CFC0',
  yellow = '#FABD2F',
  cyan = '#689D6A',
  darkblue = '#081633',
  green = '#98971A',
  orange = '#D79921',
  violet = '#a9a1e1',
  magenta = '#D3869B',
  blue = '#83a598',
  red = '#cc241d',
  pink = '#D19097',

  red_diff = '#eb6f92',
  green_diff = '#31748f',
  orange_diff = '#f6c177',

  green_diff_light = '#40A02B',
  orange_diff_light = '#DF8E1D',
  red_diff_light = '#D20F39',
}


M.colorscheme_conf = {
  gruvbox = function()
    local gruvbox = helpers.safe_require("gruvbox")
    if not gruvbox then
      vim.notify("color scheme gruvbox not installed, fallback to " .. fallback_colorscheme, vim.log.levels.ERROR)
      vim.cmd("colorscheme " .. fallback_colorscheme)
      return
    end

    gruvbox.setup({
      transparent_mode = true,
      underline = true,
      bold = true,
      strikethrough = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },

      overrides = {
        -- Override some highlights for Markdown.
        ["@markup.strong.markdown_inline"] = { fg = "#D19097", bold = true },
        ["@markup.italic.markdown_inline"] = { fg = "#D19097", italic = true },
        ["@markup.raw.block.markdown"] = { fg = "#8ec07c", italic = true },
        ["@markup.raw.markdown_inline"] = { fg = "#8ec07c", italic = true },
        -- Headings.
        ["@markup.heading.6.markdown"] = { fg = "#D1CFC0", bold = true },
        ["@markup.heading.5.markdown"] = { fg = "#a9a1e1", bold = true },
        ["@markup.heading.4.markdown"] = { fg = "#fabd2f", bold = true },
        ["@markup.heading.3.markdown"] = { fg = "#fe8019", bold = true },
        ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true },
        ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true },

        IlluminatedWordRead = { bg = "#45475A" },
        IlluminatedWordText = { bg = "#45475A" },
        IlluminatedWordWrite = { bg = "#45475A" },

        NvimTreeOpenedHL = { bold = true },
        NvimTreeIndentMarker = { fg = "#6c7087", bold = true },
        NvimTreeOpenedFile = { fg = "#e8dcb7", bold = true },
        NvimTreeFolderName = { fg = "#83a598", bold = true },
        NvimTreeOpenedFolderName = { fg = "#83a598", bold = true },
        NvimTreeEmptyFolderName = { fg = "#83a598", bold = true },
        NvimTreeRootFolder = { fg = "#d19097" },

        BlinkCmpMenuSelection = { bg = "#32302f" },

        DiagnosticSignError = { fg = '#eb6f92' },
        DiagnosticSignWarn = { fg = '#f6c177' },
        DiagnosticSignInfo = { fg = '#31748f' },
        DiagnosticSignHint = { fg = '#83a598' },

        LualineDiagnosticSignError = { fg = '#eb6f92', bg = lualine_colors.bg },
        LualineDiagnosticSignWarn = { fg = '#f6c177', bg = lualine_colors.bg },
        LualineDiagnosticSignInfo = { fg = '#31748f', bg = lualine_colors.bg },
        LualineDiagnosticSignHint = { fg = '#83a598', bg = lualine_colors.bg },
        NormalFloat = { bg = '#393633' },
      }
    })

    require("plugin-config.lualine")(lualine_colors)

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

    require("plugin-config.lualine")(lualine_colors)

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

    lualine_colors = {
      bg = '#1C1E26',
      fg = '#bbc2cf',
      yellow = '#ECBE7B',
      cyan = '#008080',
      darkblue = '#081633',
      green = '#98be65',
      orange = '#FF8800',
      violet = '#a9a1e1',
      magenta = '#c678dd',
      blue = '#51afef',
      red = '#ec5f67',
      pink = '#F35588',

      red_diff = '#eb6f92',
      green_diff = '#31748f',
      orange_diff = '#f6c177',

      green_diff_light = '#40A02B',
      orange_diff_light = '#DF8E1D',
      red_diff_light = '#D20F39',
    }

    require("plugin-config.lualine")(lualine_colors)

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

    require("plugin-config.lualine")(lualine_colors)

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

    require("plugin-config.lualine")(lualine_colors)
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
