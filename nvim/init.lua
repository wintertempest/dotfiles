local vim = vim
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.g.mapleader = ' '
vim.o.winborder = 'rounded'


vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

-- Pour pouvoir valider l'autocomplete avec TAB
-- vim.keymap.del("i", "<Tab>")

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

require "mini.pick".setup()
require "oil".setup({
	columns = {
		"icon",
		"filename",
	},
})
require "blink.cmp".setup({
	keymap = { preset = "super-tab" },
	appearance = {
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "buffer", "path", "snippets" },
	},
	fuzzy = { implementation = "lua" },
})

vim.lsp.enable({ "lua_ls", "clangd", "gopls", "rust_analyzer", "tinymist" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')

vim.keymap.set('n', '<leader>e', ':Oil<CR>')

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)


vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
		for _, client in ipairs(clients) do
			if client.supports_method("textDocument/formatting") then
				vim.lsp.buf.format({ async = false })
				break
			end
		end
	end,
})
vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		vim.diagnostic.open_float(nil,
			{ focusable = false, close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" } })
	end,
})
