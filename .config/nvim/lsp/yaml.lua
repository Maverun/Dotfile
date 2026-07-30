---@type vim.lsp.Config
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = {
		".git",
	},
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	},
	before_init = function(_, config)
		config.settings.yaml.schemas = config.settings.yaml.schemas or {}
		-- vim.list_extend(config.settings.yaml.schemas, require("schemastore").yaml.schemas())
	end,
	settings = {
		-- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
		redhat = { telemetry = { enabled = false } },
		yaml = {
                        schemas = {
                                -- PRIVATE DUE TO WORK...
                                -- ["URL"] = "/Filename"
                                ["https://github-pages.cloud.capitalone.com/cyber-sre-automation/BogieValidator/schema/bogiefile.json"] = "/Bogiefile",
                                ["https://github-pages.cloud.capitalone.com/cyber-sre-automation/BogieValidator/schema/gearsfile.json"] = "/Gearsfile",
                                ["https://github.cloud.capitalone.com/raw/7ps/7ps-engine-test-lambda/master/src/schemas/test_config/test_config.json"] = "/test_config.yml",
                        },
			keyOrdering = false,
			format = {
				enable = true,
			},
			validate = true,
			schemaStore = {
				-- Must disable built-in schemaStore support to use
				-- schemas from SchemaStore.nvim plugin
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
		},
	},
}
