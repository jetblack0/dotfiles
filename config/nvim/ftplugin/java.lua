local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
  return
end

local lsp_keybind = function(client, bufnr)
	-- NOTE: null-ls doesn't use these binding
	-- Mappings
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>H", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
end
------------------------------------------ keybindings when attach to a server -----------------------------------------

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
	lsp_keybind(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
end





local jdtls_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls/"

WORKSPACE_PATH = vim.fn.stdpath "data" .. "/workspace/"
if vim.fn.has "mac" == 1 then
  OS_NAME = "mac/"
elseif vim.fn.has "unix" == 1 then
  OS_NAME = "linux/"
elseif vim.fn.has "win32" == 1 then
  OS_NAME = "win/"
else
  vim.notify("Unsupported OS", vim.log.levels.WARN, { title = "Jdtls" })
end

local equinox_path = vim.split(vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/jdtls/plugins/*jar"), "\n")
local equinox_launcher = ""

for _, file in pairs(equinox_path) do
  if file:match "launcher_" then
    equinox_launcher = file
    break
  end
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name

local config = {
  cmd = {
    -- 💀
    "java", -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. jdtls_path .. "/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    -- 💀
    "-jar",
    equinox_launcher,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version
    -- 💀
    "-configuration",
    jdtls_path .. "config_" .. OS_NAME,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    "-data",
    workspace_dir,
  },
  -- on_attach = require("pluginConfig.lsp").on_attach,
  -- capabilities = require("pluginConfig.lsp").capabilities,
  on_attach = on_attach,
  capabilities = capabilities,

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require("jdtls.setup").find_root(root_markers),
  -- init_options = {
  --   bundles = {
  --     vim.fn.glob(java_debug_path .. "extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
  --   },
  -- },
}

config.settings = {
    java = {
      project = {
        referencedLibraries = {
			-- '/usr/lib/jvm/java-17-openjdk/lib/javafx.base.jar',
			-- '/usr/lib/jvm/java-17-openjdk/lib/javafx.controls.jar',
			-- '/usr/lib/jvm/java-17-openjdk/lib/javafx.graphics.jar',
			--[[ '/home/jetblack/Downloads/library/java/apache-tomcat-10.1.16/lib/servlet-api.jar', ]]
        },
      }
    }
  }

local keymap = vim.keymap.set

-- keymap("n", "A-o", ":lua require'jdtls'.organize_imports()<cr>", { silent = true })
-- keymap("n", "crv", ":lua require'jdtls'.extract_variable()<cr>", { silent = true })
-- keymap("v", "crv", "<Esc>:lua require'jdtls'.extract_variable(true)<cr>", { silent = true })
-- keymap("n", "crc", ":lua require'jdtls'.extract_constant()<cr>", { silent = true })
-- keymap("v", "crc", "<Esc>:lua require'jdtls'.extract_constant(true)<cr>", { silent = true })
-- keymap("v", "crm", "<Esc>:lua require'jdtls'.extract_method(true)<cr>", { silent = true })
--
vim.cmd [[
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
command! -buffer JdtJol lua require('jdtls').jol()
command! -buffer JdtBytecode lua require('jdtls').javap()
command! -buffer JdtJshell lua require('jdtls').jshell()
]]

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
