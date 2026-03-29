return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP
          "lua-language-server",
          "pyright",
	  "ruff",
	  "debugpy",

          -- formatters
          "stylua",
          "prettier",

          -- linters
          "eslint_d",
        },
        run_on_start = true,
      })
    end,
  },
}
