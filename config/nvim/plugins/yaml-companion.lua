local helpers = require("utils.helpers")
local telescope = helpers.safe_require("telescope")
local yaml_companion = helpers.safe_require("yaml-companion")
-- local lspconfig = helpers.safe_require("lspconfig")

if not telescope then return end
if not yaml_companion then return end

telescope.load_extension("yaml_schema")

local cfg = yaml_companion.setup({
  -- NOTE: https://github.com/someone-stole-my-name/yaml-companion.nvim
  builtin_matchers = {
    kubernetes = { enabled = true },
    cloud_init = { enabled = true }
  },
  schemas = {
  },
  -- lspconfig = {
  --   flags = {
  --     debounce_text_changes = 150,
  --   },
  --   settings = {
  --     redhat = { telemetry = { enabled = false } },
  --     yaml = {
  --       validate = true,
  --       format = { enable = true },
  --       hover = true,
  --       schemaStore = {
  --         enable = true,
  --         url = "https://www.schemastore.org/api/json/catalog.json",
  --       },
  --       schemaDownload = { enable = true },
  --       schemas = {},
  --       trace = { server = "debug" },
  --     },
  --   },
  -- }
})

-- require("lspconfig")["yamlls"].setup(cfg)
