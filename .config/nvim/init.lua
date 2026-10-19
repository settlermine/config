-- Need to install sudo pacman -S tree-sitter-cli base-devel curl zathura zathura-pdf-mupdf texlive-core luakit node npm fzf ripgrep fd
-- Also needed to execute :call mkdp#util#install() in comand line once

--------------------------------------------------
-- UTILS 
--------------------------------------------------
local function get_git_root()
    local path = require("oil").get_current_dir() or vim.api.nvim_buf_get_name(0)
    if path == "" or path:match("^%a+://") then
        return vim.fn.getcwd()
    end
    return vim.fs.root(path, ".git") or vim.fn.getcwd()
end

--------------------------------------------------
-- VIM 
--------------------------------------------------
vim.g.mapleader = ' '
vim.g.vimtex_view_method = "zathura"

vim.g.mkdp_browser = "luakit"
vim.g.mkdp_theme = "dark"
vim.g.mkdp_combine_preview = 1
vim.g.mkdp_combine_preview_auto_refresh = 1
vim.g.mkdp_auto_close = 0

-- Hide top panel (git plugins trying to show it)
vim.o.showtabline = 0

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
-- tab settings
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
-- OSC 52 clipboard setting to make clipboard work in devcontainer
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}
vim.o.clipboard = "unnamedplus"
vim.o.exrc = true

-- Aliases
vim.api.nvim_create_user_command("Do", "DiffviewOpen <args>", { nargs = "*" })
vim.api.nvim_create_user_command("Dh", "DiffviewFileHistory <args>", { nargs = "*" })
vim.api.nvim_create_user_command("Df", "DiffviewFileHistory %", { nargs = "*" })
vim.api.nvim_create_user_command("Dc", "DiffviewClose <args>", { nargs = "*" })

--------------------------------------------------
-- PLUGINS  
--------------------------------------------------
vim.pack.add({
    "https://github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/oil.nvim",
    "https://github.com/refractalize/oil-git-status.nvim",
    "https://github.com/xiantang/darcula-dark.nvim",
    "https://github.com/AnsonH/copy-python-path.nvim",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
    "https://github.com/rmagatti/auto-session",
    "https://github.com/brenoprata10/nvim-highlight-colors",
    "https://github.com/nvim-tree/nvim-web-devicons", -- dep for other plugins
    -- document editing and preview
 	"https://github.com/iamcco/markdown-preview.nvim",
    "https://github.com/3rd/image.nvim",
	"https://github.com/lervag/vimtex",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim", --preview markdown in terminal
    -- lsp
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/folke/lazydev.nvim", -- fix vim api calls lsp errors in nvim config
    -- debugging and testing
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/mfussenegger/nvim-dap-python",
    -- git 
    "https://github.com/sindrets/diffview.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/neogitorg/neogit",
    "https://github.com/linrongbin16/gitlinker.nvim",
})


-- Auto-sessions
-- !!! NEEDS TO BE BEFORE OIL SETUP !!! 
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,winsize,winpos,localoptions"
require("auto-session").setup()

require("oil").setup({
    win_options = {
        signcolumn = "yes:2"
    },
	view_options = {
		show_hidden = true
	}
})
require('oil-git-status').setup({ show_ignored = true })

local fzf = require("fzf-lua")
fzf.setup()

-- LSP
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	flat = { source = 'if_many' },
	jump = { float = true }
})

local servers = { "lua_ls", "pyright", "ruff", "texlab", "marksman", "clangd"}

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = servers })
vim.lsp.enable(servers)

local gitsigns = require("gitsigns")
gitsigns.setup()

require("blink.cmp").setup({
    keymap = {
        preset = "default",
        -- Autocompletion menu only triggering by pressing Ctrl+Space
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
        menu = {
            auto_show = false,
        },
    }
})
require("lazydev").setup()
require("image").setup()

-- Debugging
local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

vim.fn.sign_define('DapBreakpoint', { text = '🔴', })
vim.fn.sign_define('DapStopped', { text = '🟠', linehl = 'Visual' })
require("dap-python").setup("python3")
require("dap.ext.vscode")

-- Colors
require("nvim-highlight-colors").setup({})
-- Theme
require("darcula").setup()
-- Diff groups without fg, otherwise they override syntax highlighting in diffs
-- TODO: suggest PR in original plugin
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#294436" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#303c4d" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#3d5a80" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#484a4a", fg = "#656e76" })

--------------------------------------------------
-- KEYMAPS
--------------------------------------------------
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "-", ":Oil<CR>")

-- File picker
vim.keymap.set("n", "<leader>ff", function() fzf.files({ cwd = get_git_root(), hidden = false }) end)
vim.keymap.set("n", "<leader>fa", function() fzf.files( { no_ignore = true }) end)
vim.keymap.set("n", "<leader>fr", function() fzf.oldfiles({ cwd_only = true, include_current_session = true }) end)
-- Live grep
vim.keymap.set("n", "<leader>//", function() fzf.live_grep( { cwd = get_git_root(), hidden = true } ) end)
vim.keymap.set("n", "<leader>/a", function() fzf.live_grep( { hidden = true, no_ignore = true } ) end)

-- Git
vim.keymap.set("n", "<leader>gp", function() gitsigns.preview_hunk() end)
vim.keymap.set("n", "<leader>gr", function() gitsigns.reset_hunk() end)
vim.keymap.set("n", "<leader>gb", function() gitsigns.blame() end)
vim.keymap.set("n", "<leader>gd", function() gitsigns.diffthis() end)
vim.keymap.set("n", "<leader>gg", function() require("neogit").open({ cwd = get_git_root() }) end)
vim.keymap.set("n", "]c", function() gitsigns.nav_hunk("next") end)
vim.keymap.set("n", "[c", function() gitsigns.nav_hunk("prev") end)

-- Debugging
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>dr", ":DapNew<CR>")
vim.keymap.set("n", "<leader>dt", ":DapTerminate<CR>")
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")
vim.keymap.set("n", "<leader>di", ":DapStepInto<CR>")
vim.keymap.set("n", "<leader>do", ":DapStepOver<CR>")
vim.keymap.set("n", "<leader>dO", ":DapStepOut<CR>")
vim.keymap.set("n", "<leader>du", function() dapui.toggle() end)

-- Document viewing 
vim.keymap.set("n", "<leader>mv", ":MarkdownPreviewToggle <CR>")
vim.keymap.set("n", "<leader>mr", ":RenderMarkdown toggle<CR>")

-- Exit terminal-mode (go back to Normal mode) using Esc
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Features
vim.keymap.set("n", "<leader>yf", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
	vim.notify("Copied: " .. vim.fn.expand("%"))
end)
vim.keymap.set({ "n", "x" }, "<leader>yl", function()
    local path = vim.fn.expand("%")
    local s, e = vim.fn.line("v"), vim.fn.line(".")
    if s > e then s, e = e, s end
    local ref = s == e and ("%s:%d"):format(path, s) or ("%s:%d-%d"):format(path, s, e)
    vim.fn.setreg("+", ref)
    vim.notify("Copied: " .. ref)
    if vim.fn.mode():match("[vV\22]") then
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
    end
end)
vim.keymap.set("n", "<leader>yp", ':CopyPythonPath dotted<CR>')
vim.keymap.set({ "n", "v" }, "<leader>yg", ":GitLink<cr>")

vim.keymap.set("n", "<leader>h", vim.diagnostic.open_float)
