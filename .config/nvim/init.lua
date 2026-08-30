-- Need to install sudo pacman -S tree-sitter-cli base-devel curl zathura zathura-pdf-mupdf texlive-core luakit node npm lazygit
-- Also needed to execute :call mkdp#util#install() in comand line once

--------------------------------------------------
-- GLOBAL VARIABLES 
--------------------------------------------------
local mkdp_enabled = false

--------------------------------------------------
-- UTILS 
--------------------------------------------------
-- TODO: fix for oil
local function get_current_path()
	if vim.bo.filetype == "oil" then
		return require("oil").get_current_dir()
	end
	return vim.api.nvim_buf_get_name(0)
end

local function get_git_root()
	local path = get_current_path()
    if path == nil then
        return
    else
	    return vim.fs.root(path, ".git")
    end
end

local function toggle_md_preview()
    if vim.bo.filetype ~= "markdown" then
        return
    end
    mkdp_enabled = not mkdp_enabled
    if mkdp_enabled then
        vim.cmd("MarkdownPreview")
    else
        vim.cmd("MarkdownPreviewStop")
    end
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
vim.o.clipboard = "unnamedplus"
vim.o.exrc = true

--------------------------------------------------
-- PLUGINS  
--------------------------------------------------
vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/refractalize/oil-git-status.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/tpope/vim-fugitive",
	"https://github.com/lervag/vimtex",
 	"https://github.com/iamcco/markdown-preview.nvim",
    "https://github.com/xiantang/darcula-dark.nvim",
    "https://github.com/3rd/image.nvim",
    "https://github.com/AnsonH/copy-python-path.nvim",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rmagatti/auto-session",
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

-- require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.extra").setup()
require("mini.icons").setup()
require("mini.visits").setup()

-- LSP
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	flat = { source = 'if_many' },
	jump = { float = true }
})

local servers = { "lua_ls", "pyright", "texlab", "marksman", "clangd"}
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers
})

vim.lsp.enable(servers)

require("gitsigns").setup()

require("blink.cmp").setup()
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

vim.fn.sign_define('DapBreakpoint', {
    text = '🔴',
})
vim.fn.sign_define('DapStopped', {
    text = '🟠',
    linehl = 'Visual'
})

dap.adapters.debugpy = {
    type = 'executable';
    command = '/usr/bin/python';
    args = {'-m', 'debugpy.adapter'}
}
dap.configurations.python = {
    {
        type = 'debugpy';
        request = 'launch';
        name = 'Launch file';
        program = '${file}';
        just_my_code = false;
        pythonPath = function()
            return '/usr/bin/python'
        end;
    }
}

-- Theme
require("darcula").setup()

--------------------------------------------------
-- KEYMAPS
--------------------------------------------------
vim.keymap.set("n", "<leader>sh", ":Pick help<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
-- File picker
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>fe", ":Oil<CR>")
vim.keymap.set("n", "<leader>fr", ":Pick visit_paths<CR>")
vim.keymap.set("n", "<leader>fb", function() require("mini.pick").builtin.buffers() end)
vim.keymap.set("n", "<leader>ft", function()
    local items = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[b].buftype == "terminal" then
            table.insert(items, {
                text = vim.api.nvim_buf_get_name(b),
                bufnr = b,
            })
        end
    end
    require("mini.pick").start({
        source = { name = "Terminals", items = items },
    })
end)

-- Git
vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end)
vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_hunk() end)
vim.keymap.set("n", "<leader>gb", function() require("gitsigns").blame() end)
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
vim.keymap.set("n", "<leader>gm", function()
    require("mini.extra").pickers.git_files({ scope = "modified", path = get_git_root() })
end)
vim.keymap.set("n", "<leader>gu", function()
    require("mini.extra").pickers.git_files({ scope = "untracked", path = get_git_root() })
end)
vim.keymap.set("n", "]c", function() require("gitsigns").nav_hunk("next") end)
vim.keymap.set("n", "[c", function() require("gitsigns").nav_hunk("last") end)

-- Debugging
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>dr", ":DapNew<CR>")
vim.keymap.set("n", "<leader>dt", ":DapTerminate<CR>")
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")
vim.keymap.set("n", "<leader>di", ":DapStepInto<CR>")
vim.keymap.set("n", "<leader>do", ":DapStepOver<CR>")
vim.keymap.set("n", "<leader>dO", ":DapStepOut<CR>")
vim.keymap.set("n", "<leader>du", function() dapui.toggle() end)

-- Exit terminal-mode (go back to Normal mode) using Esc
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Features
vim.keymap.set("n", "<leader>yf", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
	vim.notify("Copied: " .. vim.fn.expand("%"))
end)
vim.keymap.set("n", "<leader>yp", ':CopyPythonPath dotted<CR>')

vim.keymap.set("n", "<leader>h", vim.diagnostic.open_float)
-- TODO: Add LaTeX
vim.keymap.set("n", "<leader>v", toggle_md_preview)

