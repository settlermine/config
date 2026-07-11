vim.opt.number = true
vim.opt.relativenumber = true

-- Настройка табов на 4 пробела
vim.opt.tabstop = 4      -- Ширина табуляции в пробелах
vim.opt.softtabstop = 4  -- Сколько пробелов вставлять при нажатии Tab
vim.opt.shiftwidth = 4   -- Ширина отступа при командах >> и <<
vim.opt.expandtab = true -- Превращать табы в пробелы

vim.opt.clipboard = "unnamedplus"

-- Lazy Plugin Manager. On fresh install do
-- git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/site/pack/lazy/start/lazy.nvim
require("lazy").setup({
    "lervag/vimtex",

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local langs = { "python", "lua", "vim", "vimdoc", "markdown" }
            require("nvim-treesitter").install(langs)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- "neovim/nvim-lspconfig",
})

-- Shorctuts
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

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
