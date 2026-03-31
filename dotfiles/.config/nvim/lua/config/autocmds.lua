-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Чтобы LazyGit искал файлы в той репе, в которой открыт текущий файл
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
      return
    end

    local dir = vim.fn.fnamemodify(file, ":p:h")
    local git_root = vim.fn.systemlist("git -C " .. dir .. " rev-parse --show-toplevel")[1]

    if git_root and git_root ~= "" then
      vim.cmd("lcd " .. git_root)
    end
  end,
})
