return {

  --{ "ellisonleao/gruvbox.nvim" },
  --{ "maxmx03/dracula.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  -- Conrfigure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      --colorscheme = "rose-pine",
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          --base = "#181825",
        },
      },
    },
  },
  --[[require("catppuccin").setup({
    color_overrides = {
      all = {
        text = "#ffffff",
      },
      latte = {},
      frappe = {},
      macchiato = {},
      mocha = {
        base = "#232627",
        mantle = "#232627",
        crust = "#232627",
      },
    },
  }),]]
}
