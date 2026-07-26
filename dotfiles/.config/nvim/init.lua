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
    "https://github.com/refractalize/oil-git-status.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/tpope/vim-fugitive",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }
})

require("oil").setup({
    win_options = {
        signcolumn = "yes:2"
    },
	view_options = {
		show_hidden = true
	}
})
require('oil-git-status').setup({
  show_ignored = true
})

require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.extra").setup()
require("mini.icons").setup()

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers
})

require("gitsigns").setup()

require("blink.cmp").setup()
require("lazydev").setup()
-- Enable syntax highlight
vim.api.nvim_create_autocmd('FileType', {
	callback = function() pcall(vim.treesitter.start) end
})
vim.lsp.enable(servers)

-- Keymap
local function get_current_path()
	if vim.bo.filetype == "oil" then
		return require("oil").get_current_dir()
	end
	return vim.api.nvim_buf_get_name(0)
end

local function get_git_root()
	local path = get_current_path()
	return vim.fs.root(path, ".git")
end

vim.keymap.set("n", "<leader>sh", ":Pick help<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
-- File picker
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>fe", ":Oil<CR>")
-- Git
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>")
vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end)
vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_hunk() end)
vim.keymap.set("n", "<leader>gb", function() require("gitsigns").blame() end)
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
vim.keymap.set("n", "<leader>gs", function()
    require("mini.extra").pickers.git_files({ scope = "modified", path = get_git_root(), })
end)
vim.keymap.set("n", "]c", function() require("gitsigns").next_hunk() end)
vim.keymap.set("n", "[c", function() require("gitsigns").prev_hunk() end)

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
