local helpers = require("utils.helpers")

local M = {}

M.enabled_servers = {
  -- Devs
  rust_analyzer =                   { cmd = "rust-analyzer", mason = "rust_analyzer" },
  lua_ls =                          { cmd = "lua-language-server", mason = "lua_ls" },
  bashls =                          { cmd = "bash-language-server", mason = "bashls" },
  ruff =                            { cmd = "ruff", mason = "ruff" },
  basedpyright =                    { cmd = "basedpyright-langserver", mason = "basedpyright" },
  ts_ls =                           { cmd = "typescript-language-server", mason = "ts_ls" },
  htmlls =                          { cmd = "vscode-html-language-server", mason = "html" },
  cssls =                           { cmd = "vscode-css-language-server", mason = "cssls" },
  jsonls =                          { cmd = "vscode-json-language-server", mason = "jsonls" },

  -- Ops
  yamlls =                          { cmd = "yaml-language-server", mason = "yamlls" },
  ansiblels =                       { cmd = "ansible-language-server", mason = "ansiblels" },
  terraformls =                     { cmd = "terraform-ls", mason = "terraformls" },
  -- nil_ls =                          { cmd = "nil" },
  dockerls =                        { cmd = "docker-langserver", mason = "dockerls" },
  -- groovyls =                     { cmd = "java", mason = "groovyls" },
  -- nginx_language_server =           { cmd = "nginx-language-server", mason = "nginx_language_server" },
  docker_compose_language_service = { cmd = "docker-compose-langserver", mason = "docker_compose_language_service" },
}


M.ensured_installed = helpers.extract(M.enabled_servers, "mason")

M.tools = {
  "npm-groovy-lint",
  "statix",
}

return M
