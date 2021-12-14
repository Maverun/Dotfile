vim.o.completeopt = "menuone,noselect"

local lspkind = require'lspkind'
lspkind.init()
-- nvim-cmp setup
local cmp = require 'cmp'
local setting = {
	-- completion = {autocomplete = true  },
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = {
		-- ['<C-y>'] = cmp.mapping.complete(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(),{'i','c'}),
		['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(),{'i','c'}),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.close(),
		['<C-h>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		-- ['<C-Space>'] = cmp.mapping(function(fallback) require'cmp'.completion = {autocomplete = not require'cmp'.completion.autocomplete} end),
		['<Tab>'] = cmp.mapping(function(fallback)
			-- if cmp.visible() then
				-- cmp.select_next_item()
				-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
			if require'luasnip'.expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
			else
				fallback()
			end
		end,{'i','s'}),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			-- if cmp.visible() then
				-- cmp.select_next_item()
			if require'luasnip'.jumpable(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
			else
				-- fallback()
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<esc><<a',true,true,true))
			end
		end, { "i", "s", })},

	experimental = {
		-- temp testing to see if i like this or not.
		ghost_text = true
	},

	sources = {
		{ name = 'luasnip', priority = 99 },
		{ name = 'path'},
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'orgmode'},
		{ name = 'buffer',keyword_length = 5},
	},


	formatting = {
		format = lspkind.cmp_format {
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
			},
		},
	},
}

cmp.setup(setting)

