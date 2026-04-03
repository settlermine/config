return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
          no_ignore = true,
        })
      end,
      desc = "Find all files",
    },
  },
}
