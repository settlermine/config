-- Need to install sudo pacman -S tree-sitter-cli base-devel curl zathura zathura-pdf-mupdf texlive-core luakit node npm 
-- Also needed to execute :call mkdp#util#install() in comand line once
vim.g.mapleader = ' '
vim.g.vimtex_view_method = "zathura"
vim.g.mkdp_browser = "luakit"
vim.g.mkdp_theme = "dark"

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.exrc = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.swapfile = false

vim.opt.clipboard = "unnamedplus"

-- LSP settings
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	flat = { source = 'if_many' },
	jump = { float = true }
})

local servers = { "lua_ls", "pyright", "texlab", "marksman"}

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
    "https://github.com/stevearc/overseer.nvim",
	"https://github.com/lervag/vimtex",
 	"https://github.com/iamcco/markdown-preview.nvim",
    "https://github.com/xiantang/darcula-dark.nvim",
    "https://github.com/3rd/image.nvim",
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
-- VSCode-like tasks
require('overseer').setup({
	disable_template_modules = {
		'overseer.template.vscode',
		'overseer.template.make',
	},
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
require("image").setup({
  backend = "kitty", -- or "ueberzug" or "sixel"
  processor = "magick_cli", -- or "magick_rock"
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      only_render_image_at_cursor_mode = "popup", -- or "inline"
      floating_windows = false, -- if true, images will be rendered in floating markdown windows
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    },
    asciidoc = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      only_render_image_at_cursor_mode = "popup",
      floating_windows = false,
      filetypes = { "asciidoc", "adoc" },
    },
    neorg = {
      enabled = true,
      filetypes = { "norg" },
    },
    rst = {
      enabled = true,
    },
    typst = {
      enabled = true,
      filetypes = { "typst" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  scale_factor = 1.0,
  kitty_direct_chunk_size = 4096, -- chunk size for direct Kitty graphics protocol transmission
  window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})
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
    if path == nil then
        return
    else
	    return vim.fs.root(path, ".git")
    end
end

vim.keymap.set("n", "<leader>sh", ":Pick help<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
-- File picker
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>fe", ":Oil<CR>")
vim.keymap.set("n", "<leader>fr", function() require("mini.pick").builtin.buffers() end)
-- Git
vim.keymap.set("n", "<leader>gg", ":LazyGitCurrentFile<CR>")
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

-- Tasks
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>")
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<CR>")

vim.keymap.set("n", "<leader>h", vim.diagnostic.open_float)
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>")


-- Theme
require("darcula").setup({
	theme = "darcula"  -- loads built-in colors/themes/darcula.json
})

-- Load .nvim.lua from project folder
vim.opt.exrc = true
vim.keymap.set("n", "]c", function() require("gitsigns").nav_hunk("next") end)
vim.keymap.set("n", "[c", function() require("gitsigns").nav_hunk("last") end)

-- Tasks
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>")
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<CR>")

vim.keymap.set("n", "<leader>h", vim.diagnostic.open_float)
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>")


-- Theme
require("darcula").setup({
	theme = "darcula"  -- loads built-in colors/themes/darcula.json
})

-- Load .nvim.lua from project folder
vim.opt.exrc = true
