return {
  {
    "doums/darcula",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme darcula]])
      
      -- Фикс темных системных файлов
      vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#999999" })
    end,
  },
}
