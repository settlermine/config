-- Need to install sudo pacman -S tree-sitter-cli base-devel curl  
vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"

-- LSP settings
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	flat = { source = 'if_many' },
	jump = { float = true }
})

local servers = { "lua_ls", "pyright"}

vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/lazydev.nvim",
	"https://github.com/kdheepak/lazygit.nvim",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }
})

require("oil").setup({
	view_options = {
		show_hidden = true
	}
})
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.extra").setup()
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers
})
require("blink.cmp").setup()
require("lazydev").setup()
-- Enable syntax highlight
vim.api.nvim_create_autocmd('FileType', {
	callback = function() pcall(vim.treesitter.start) end
})
vim.lsp.enable(servers)

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>sh", ":Pick help<CR>")
vim.keymap.set("n", "<leader>fe", ":Oil<CR>")
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>")
vim.keymap.set("n", "<leader>h", vim.diagnostic.open_float)
-- Use terminal theme
vim.opt.termguicolors = true
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
]])
-- Lighter line numbers 
vim.cmd('highlight LineNr guifg=#AAAAAA')

-- Load .nvim.lua from project folder
vim.opt.exrc = true
