local helpers = require("utils.helpers")
local schema_companion = helpers.safe_require("schema-companion")
local cmp_nvim_lsp = helpers.safe_require("cmp_nvim_lsp")
local nvim_navic = helpers.safe_require("nvim-navic")

if not schema_companion then return end
if not cmp_nvim_lsp then return end

schema_companion.setup({
  log_level = vim.log.levels.INFO,
})

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
  if client.server_capabilities.documentSymbolProvider then
    nvim_navic.attach(client, bufnr)
  end
end

-- your LSP file: ./after/lsp/yamlls.lua
schema_companion.setup_client(
  schema_companion.adapters.yamlls.setup({
    sources = {
      -- your sources for the language server
      schema_companion.sources.matchers.kubernetes.setup({ version = "master" }),
      schema_companion.sources.lsp.setup(),
      schema_companion.sources.schemas.setup({
        {
          name = "Kubernetes master",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
        },
      }),
    },
  }),
  {}
)

vim.lsp.config.yamlls = {
  filetypes = { "yaml" },
  cmd = { "yaml-language-server", "--stdio" },
  settings = {
    yaml = {
      completion = {
        enable = true
      },
      format = {
        enable = true
      },
    },
  },
	capabilities = capabilities,
  on_attach = on_attach,
}
vim.lsp.enable("yamlls")
