-- Отключаем встроенную принудительную тему, чтобы юзать прозрачность и цвета терминала
vim.opt.termguicolors = true

-- Говорим Neovim сбросить фон, чтобы он стал прозрачным/цвета Alacritty
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
]])


-- Относительные номера строк (текущая строка показывает свой номер, остальные — расстояние до нее)
vim.opt.number = true
vim.opt.relativenumber = true

-- Настройка табов на 4 пробела
vim.opt.tabstop = 4      -- Ширина табуляции в пробелах
vim.opt.softtabstop = 4  -- Сколько пробелов вставлять при нажатии Tab
vim.opt.shiftwidth = 4   -- Ширина отступа при командах >> и <<
vim.opt.expandtab = true -- Превращать табы в пробелы

vim.opt.clipboard = "unnamedplus"
