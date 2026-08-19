local helpers = require("utils.helpers")
local lualine = helpers.safe_require("lualine")
local web_devicons = helpers.safe_require("nvim-web-devicons")

if not lualine then
  return function() end
end

-- Fallback only. colorscheme.lua passes statusbar_colors on every call.
local palette = {
  ground = "none",

  accent = "#D19097",
  quiet  = "#9c8f91",
  rule   = "#7c6f64",

  -- right half
  chip1  = "#3c3836",
  chip2  = "#504945",
  text   = "#d5c4a1",
  ink    = "#1d2021",

  diag_error = "#eb6f92",
  diag_warn  = "#f6c177",
  diag_info  = "#7daea3",
  diag_hint  = "#83a598",

  -- gruvbox-material green / yellow / red
  diff_added    = "#a9b665",
  diff_modified = "#d8a657",
  diff_removed  = "#ea6962",
}

local function define_highlights(p)
  local groups = {
    StatusBarId    = { fg = p.accent, bold = true },
    StatusBarQuiet = { fg = p.quiet },
    StatusBarRule  = { fg = p.rule },
    StatusBarError = { fg = p.diag_error },
    StatusBarWarn  = { fg = p.diag_warn },
    StatusBarInfo  = { fg = p.diag_info },
    StatusBarHint  = { fg = p.diag_hint },
  }
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec) -- transparent
  end

  for _, group in ipairs({ "StatusLine", "StatusLineNC", "StatusLineTerm", "StatusLineTermNC" }) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok then
      hl.bg, hl.ctermbg = nil, nil
      pcall(vim.api.nvim_set_hl, 0, group, hl)
    end
  end
end

return function(colors)
  local p = vim.tbl_extend("force", palette, colors or {})

  local function chip(fg, bg, gui)
    return { fg = fg, bg = bg, gui = gui }
  end

  local function wide_enough()
    return vim.o.columns > 90
  end

  local lsp_ignore = { ["null-ls"] = true, ["none-ls"] = true, copilot = true }

  local function lsp_names()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      if not lsp_ignore[client.name] then
        names[#names + 1] = client.name
      end
    end
    return table.concat(names, " ")
  end

  ---------------------------------------------------------------------------
  -- the left half: one flat line
  ---------------------------------------------------------------------------
  local severities = {
    { severity = vim.diagnostic.severity.ERROR, hl = "StatusBarError", symbol = " " },
    { severity = vim.diagnostic.severity.WARN,  hl = "StatusBarWarn",  symbol = "󰃤 " },
    { severity = vim.diagnostic.severity.INFO,  hl = "StatusBarInfo",  symbol = "󰋽 " },
    { severity = vim.diagnostic.severity.HINT,  hl = "StatusBarHint",  symbol = " " },
  }

  local function hl(group)
    return "%#" .. group .. "#"
  end

  local function identity()
    local name = vim.fn.expand("%:t")
    if name == "" then return nil end

    local icon = ""
    if web_devicons then
      icon = (web_devicons.get_icon(name, vim.fn.expand("%:e"), { default = true }) or "") .. " "
    end

    local flag = ""
    if vim.bo.modified then
      flag = " ●"
    elseif vim.bo.readonly or not vim.bo.modifiable then
      flag = " "
    end

    return hl("StatusBarId") .. icon .. name:gsub("%%", "%%%%") .. flag
  end

  local function position()
    return hl("StatusBarQuiet") .. ("%d:%d"):format(vim.fn.line("."), vim.fn.charcol("."))
  end

  local function diagnostics()
    local counts = vim.diagnostic.count(0)
    local out = {}
    for _, s in ipairs(severities) do
      local n = counts[s.severity]
      if n and n > 0 then
        out[#out + 1] = hl(s.hl) .. s.symbol .. n
      end
    end
    if #out == 0 then return nil end
    return table.concat(out, " ")
  end

  local function left_line()
    local groups = {}
    local function add(part)
      if part then groups[#groups + 1] = part end
    end
    add(identity())
    add(position())
    add(diagnostics())
    return table.concat(groups, hl("StatusBarRule") .. " | ")
  end

  ---------------------------------------------------------------------------

  local config = {
    options = {
      globalstatus = true,
      component_separators = "",
      section_separators = "",
      theme = {
        normal   = { c = { fg = p.quiet, bg = p.ground } },
        inactive = { c = { fg = p.quiet, bg = p.ground } },
      },
      disabled_filetypes = { statusline = { "netrw" } },
      ignore_focus = {},
    },
    sections = {
      lualine_a = {}, lualine_b = {}, lualine_c = {},
      lualine_x = {}, lualine_y = {}, lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {}, lualine_b = {}, lualine_c = {},
      lualine_x = {}, lualine_y = {}, lualine_z = {},
    },
  }

  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left({ left_line })

  -- right: #3c3836 -> #504945 -> rose ---------------------------------------

  ins_right({
    "diff",
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added    = chip(p.diff_added, p.chip1),
      modified = chip(p.diff_modified, p.chip1),
      removed  = chip(p.diff_removed, p.chip1),
    },
    cond = wide_enough,
  })

  ins_right({
    lsp_names,
    cond = function()
      return lsp_names() ~= ""
    end,
    icon = "󰅩",
    color = chip(p.text, p.chip2),
  })

  ins_right({
    "branch",
    icon = "",
    color = chip(p.ink, p.accent, "bold"),
  })

  ins_right({
    function()
      return " "
    end,
    padding = 0,
  })

  lualine.setup(config)

  local group = vim.api.nvim_create_augroup("StatusBarHighlights", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      define_highlights(p)
    end,
  })
  define_highlights(p)
end
