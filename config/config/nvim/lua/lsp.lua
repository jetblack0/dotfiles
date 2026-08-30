-- LSP server configuration and keybindings.
local helpers = require("utils.helpers")
local blink = helpers.safe_require("blink.cmp")
local yaml_schema = helpers.safe_require('utils.yaml-schemas')
local lsputils = helpers.safe_require('utils.lsp')


-- Diagnostic UI
-- ---------------------------------------------
WINDOW_BORDER_STYLE = "rounded"
vim.diagnostic.config({
	virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "󰃤",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    }
  },
	underline = false,
	update_in_insert = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		prefix = "",
    border = WINDOW_BORDER_STYLE,
	},
})


-- LSP configurations
-- ---------------------------------------------
local capabilities = blink.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local opts = { silent = false }
local function opt(desc, others)
  return vim.tbl_extend("force", opts, { desc = desc }, others or {})
end

local on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true

  if client.name == 'yamlls' then
    vim.keymap.set('n', '<leader>t', function() require("utils.yaml-schemas").list_schemas() end, opt("List available YAML/JSON schemas"))
  end
end

-- Diagnostics also come from nvim-lint, so these must not wait for an LSP.
vim.keymap.set("n", "<leader>j", function() vim.diagnostic.jump({ count = 1, float = true }) end, opt("Next Diagnostic"))
vim.keymap.set("n", "<leader>k", function() vim.diagnostic.jump({ count =-1, float = true }) end, opt("Prev Diagnostic"))
vim.keymap.set("n", "<leader>l", vim.diagnostic.open_float, opt("Open diagnostic in float"))

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local ft = vim.bo[bufnr].filetype

    if ft ~= "yaml.ansible" and client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider = nil
    end

    local keymap = vim.keymap.set
    local lsp = vim.lsp

    -- keymap("n", "<Leader>f", vim.cmd.FormatToggle, opt("Toggle AutoFormat"))
    keymap("n", "<leader>a", lsp.buf.code_action, opt("Code Action"))

    keymap("n", "<leader>H", function() lsp.buf.signature_help({ border = WINDOW_BORDER_STYLE }) end, opt("LSP signature help (normal)"))
    keymap("i", "<a-s>", function() lsp.buf.signature_help({ border = WINDOW_BORDER_STYLE }) end, opt("LSP signature help (input)"))
    keymap("n", "<leader>h", function() lsp.buf.hover({ border = WINDOW_BORDER_STYLE, max_height = 30, max_width = 120 }) end, opt("LSP toggle hover"))
    keymap("n", "<leader>D", lsp.buf.declaration, opt("LSP go to declaration"))
    keymap("n", "<leader>d", lsp.buf.definition, opt("LSP go to definition"))
    keymap("n", "<leader>G", lsp.buf.references, opt("LSP show References"))
    keymap("n", "<leader>i", function() lsp.buf.implementation({ border = "single" })  end, opt("LSP show to implementation"))
    keymap("n", "<Leader>L", lsp.codelens.run, opt("LSP run CodeLens"))

    pcall(vim.keymap.del, "n", "K", { buffer = ev.buf })
  end,
})



-- Server specific configurations
-- ---------------------------------------------


-- Complied languages
-- ---------------------------------------------
-- Rust
vim.lsp.config.rust_analyzer = {
  filetypes = { "rust" },
  cmd = { "rust-analyzer" },
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
			},
			completion = {
				postfix = {
					enable = false,
				},
			},
      diagnostics = {
        enable = true;
      }
		},
	},
	capabilities = capabilities,
  on_attach = on_attach,
}


-- Interpreted languages
-- ---------------------------------------------
-- lua
vim.lsp.config.lua_ls = {
  filetypes = { "lua" },
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", ".luacheckrc", ".stylua.toml", ".git", vim.uv.cwd() },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      hint = { enable = true },
      diagnostics = {
        disable = { 'undefined-global' },
        globals = { 'vim' },
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = on_attach,
	capabilities = capabilities,
}

-- Bash
vim.lsp.config.bashls = {
  filetypes = { "bash", "sh", "zsh" },
  cmd = { "bash-language-server", "start" },
  root_markers = { ".git", vim.uv.cwd() },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
    },
  },
	capabilities = capabilities,
  on_attach = on_attach,
}

-- Python
vim.lsp.config.ruff = {
  filetypes = { "python" },
  cmd = { "ruff", "server" },
	capabilities = capabilities,
  on_attach = on_attach,
}

vim.lsp.config.basedpyright = {
  filetypes = { "python" },
  cmd = { "basedpyright-langserver", "--stdio" },
	settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off",
      }
    }
	},
	capabilities = capabilities,
	on_attach = on_attach,
}

-- Typescript and Javascript
vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		hostInfo = "neovim",
	},
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	on_attach = on_attach,
	capabilities = capabilities,
}


-- Markup languages
-- ---------------------------------------------
-- HTML/CSS
vim.lsp.config.htmlls = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
	single_file_support = true,
	capabilities = capabilities,
  on_attach = on_attach
}

-- CSS
vim.lsp.config.cssls = {
	filetypes = { "css", "scss", "less" },
	cmd = { "vscode-css-language-server", "--stdio" },
	settings = {
		css = {
			validate = true,
		},
		less = {
			validate = true,
		},
		scss = {
			validate = true,
		},
	},
	single_file_support = true,
	capabilities = capabilities,
  on_attach = on_attach,
}

-- JSON
vim.lsp.config.jsonls = {
  filetypes = { "json", "jsonc" },
  cmd = { "vscode-json-language-server", "--stdio" },
	capabilities = capabilities,
  init_options = {
    provideFormatter = true
  },
  on_attach = on_attach
}


vim.lsp.config.yamlls = {
  filetypes = { "yaml" },
  cmd = { "yaml-language-server", "--stdio" },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      validate = true,
      completion = {
        enable = true
      },
      format = {
        enable = true
      },
      schemaStore = {
        enable = false,
        url = "",
      },
      -- schemas = require('schemastore').yaml.schemas(),
      schemas = yaml_schema.as_lsp_schemas(),
    },
  },
	capabilities = capabilities,
  on_attach = on_attach,
}


-- Ops
-- ---------------------------------------------
-- Ansible
local ansible_lint_fatal = {
  ["args"] = true,
  ["internal-error"] = true,
  ["jinja[invalid]"] = true,
  ["load-failure"] = true,
  ["no-free-form"] = true,
  ["parser-error"] = true,
  ["schema"] = true,
  ["syntax-check"] = true,
  ["var-naming[no-jinja]"] = true,
  ["var-naming[no-reserved]"] = true,
  ["var-naming[pattern]"] = true,
}

local publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

local function ansible_diagnostics(err, result, ctx)
  for _, d in ipairs(result and result.diagnostics or {}) do
    -- Codes are "rule" or "rule[subrule]" and a subrule can be listed alone.
    local code = type(d.code) == "string" and d.code or ""
    local fatal = ansible_lint_fatal[code] or ansible_lint_fatal[code:gsub("%[.*", "")]
    if d.source == "ansible-lint" and not fatal
      and d.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
      d.severity = vim.lsp.protocol.DiagnosticSeverity.Warning
    end
  end
  return publish_diagnostics(err, result, ctx)
end

vim.lsp.config.ansiblels = {
  filetypes = { "yaml.ansible", "ansible" },
  cmd = { "ansible-language-server", "--stdio" },
	capabilities = capabilities,
	on_attach = on_attach,
  root_markers = { "ansible.cfg", ".ansible-lint", "galaxy.yml", ".git" },
  handlers = {
    ["textDocument/publishDiagnostics"] = ansible_diagnostics,
  },
	settings = {
    ansible = {
      ansible = {
        path = "ansible"
      },
      executionEnvironment = {
        enabled = false
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = "ansible-lint",
          arguments = ""
        }
      }
    }
	},
}

-- Terraform
vim.lsp.config.terraformls = {
  filetypes = { "terraform", "terraform-vars" },
  cmd = { "terraform-ls", "serve" },
	capabilities = capabilities,
  root_markers = { ".terraform", ".git" },
  on_attach = on_attach
}

-- Nix (oxalica/nil).
vim.lsp.config.nil_ls = {
  filetypes = { "nix" },
  cmd = { "nil" },
  capabilities = capabilities,
  root_markers = { "flake.nix", "shell.nix", ".git" },
  on_attach = on_attach,
  settings = {
    ["nil"] = {
      formatting = { command = { "nixfmt" } },
    },
  },
}

-- Docker and docker compose
-- vim.lsp.config.docker_compose_language_service = {
--   filetypes = { "yaml.docker-compose", "docker-compose" },
--   cmd = { "docker-compose-langserver", "--stdio" },
--   root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
--   on_attach = on_attach
-- }

vim.lsp.config.dockerls = {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile" },
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true
        }
      }
    }
  },
  on_attach = on_attach
}

-- Groovy (Jenkins)
local home = vim.fn.expand("$HOME")
vim.lsp.config.groovyls = {
  filetypes = { "groovy" },
  cmd = {
    "java",
    "-jar",
    home .. "/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

-- Nginx
vim.lsp.config.nginx_language_server = {
  filetypes = { "nginx" },
  cmd = { "nginx-language-server" },
  capabilities = capabilities,
  on_attach = on_attach,
}


-- Enable clients
-- ---------------------------------------------
for server_name, v in pairs(lsputils.enabled_servers) do
  if helpers.command_exists(v["cmd"]) then
    vim.lsp.enable(server_name)
  else
    local msg = string.format(
      "Executable '%s' for server '%s' not found! Server will not be enabled",
      lsp_executable,
      server_name
    )
    vim.notify(msg, vim.log.levels.WARN, { title = "Nvim-config" })
  end
end
