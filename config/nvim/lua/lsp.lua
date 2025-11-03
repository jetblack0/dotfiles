-- LSP server configuration and keybindings.
local helpers = require("utils.helpers")
local nvim_navic = helpers.safe_require("nvim-navic")
local cmp_nvim_lsp = helpers.safe_require("cmp_nvim_lsp")
local yaml_schema = helpers.safe_require('utils.yaml-schemas')


----------------
-- Diagnostic UI
----------------
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
	},
})

-- Set color for diagnostic signs
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg='#eb6f92'} )
vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg='#f6c177'} )
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg='#31748f'} )
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg='#83a598'} )

-- Set background color for the popup window 
vim.api.nvim_set_hl(0, 'NormalFloat', { bg='#393633'} )



---------------------
-- LSP configurations
---------------------
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
  if client.server_capabilities.documentSymbolProvider then
    nvim_navic.attach(client, bufnr)
  end

  if client.name == 'yamlls' then
    vim.keymap.set('n', '<leader>t', function() require("utils.yaml-schemas").list_schemas() end, { silent = false })
  end
end

local on_attach_noformat = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
  if client.server_capabilities.documentSymbolProvider then
    nvim_navic.attach(client, bufnr)
  end
end

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
    local opts = { silent = false }
    local function opt(desc, others)
      return vim.tbl_extend("force", opts, { desc = desc }, others or {})
    end

    keymap("n", "<leader>j", function() vim.diagnostic.jump({ count = 1, float = true }) end, opt("Next Diagnostic"))
    keymap("n", "<leader>k", function() vim.diagnostic.jump({ count =-1, float = true }) end, opt("Prev Diagnostic"))
    keymap("n", "<leader>l", vim.diagnostic.open_float, opt("Open diagnostic in float"))
    -- keymap("n", "<Leader>f", vim.cmd.FormatToggle, opt("Toggle AutoFormat"))
    keymap("n", "<leader>a", lsp.buf.code_action, opt("Code Action"))

    keymap("n", "<leader>H", lsp.buf.signature_help, opts)
    keymap("i", "<a-m>", lsp.buf.signature_help, opts)
    keymap("n", "<leader>h", function() lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 }) end, opt("Toggle hover"))
    keymap("n", "<leader>D", lsp.buf.declaration, opt("Go to declaration"))
    keymap("n", "<leader>d", lsp.buf.definition, opt("Go to definition"))
    keymap("n", "<leader>g", lsp.buf.references, opt("Show References"))
    keymap("n", "<leader>i", function() lsp.buf.implementation({ border = "single" })  end, opt("Go to implementation"))
    keymap("n", "<Leader>L", lsp.codelens.run, opt("Run CodeLens"))

    pcall(vim.keymap.del, "n", "K", { buffer = ev.buf })
  end,
})



---------------------------------
-- Server specific configurations
---------------------------------
-- Complied languages
---------------------
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
vim.lsp.enable("rust_analyzer")


-- Interpreted languages
------------------------
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
  on_attach = on_attach_noformat,
	capabilities = capabilities,
}
vim.lsp.enable("lua_ls")

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
vim.lsp.enable("bashls")

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
vim.lsp.enable({ "ruff", "basedpyright" })


-- Markup languages
-------------------
-- Typescript and Javascript
vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		hostInfo = "neovim",
	},
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	on_attach = on_attach_noformat,
	capabilities = capabilities,
}

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

vim.lsp.enable({ "ts_ls", "cssls", "htmlls", "jsonls" })

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
vim.lsp.enable("yamlls")


-- Ops
-------------------
-- Ansible
vim.lsp.config.ansiblels = {
  filetypes = { "yaml.ansible", "ansible" },
  cmd = { "ansible-language-server", "--stdio" },
	capabilities = capabilities,
	on_attach = on_attach_noformat,
  root_markers = { "ansible.cfg", ".ansible-lint" },
  single_file_support = true,
	settings = {
    ansible = {
      ansible = {
        path = "ansible"
      },
      executionEnvironment = {
        enabled = false
      },
      python = {
        interpreterPath = "python"
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = "ansible-lint --profile basic --offline"
        }
      }
    }
	},
}
vim.lsp.enable("ansiblels")

-- Terraform
vim.lsp.config.terraformls = {
  filetypes = { "terraform", "terraform-vars" },
  cmd = { "terraform-ls", "serve" },
	capabilities = capabilities,
  root_markers = { ".terraform", ".git" },
  on_attach = on_attach
}
vim.lsp.enable("terraformls")

-- Docker and docker compose
vim.lsp.config.docker_compose_language_service = {
  filetypes = { "yaml.docker-compose", "docker-compose" },
  cmd = { "docker-compose-langserver", "--stdio" },
  root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
  on_attach = on_attach
}
vim.lsp.enable('docker_compose_language_service')

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
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.semanticTokensProvider = nil
  --   client.server_capabilities.documentFormattingProvider = true
  --   if client.server_capabilities.documentSymbolProvider then
  --     nvim_navic.attach(client, bufnr)
  --   end
  -- end
  on_attach = on_attach
}
vim.lsp.enable('dockerls')

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
vim.lsp.enable("groovyls")
