-- Catppuccin Mocha — matches the rest of the system (Ghostty theme, Noctalia).
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- load before other plugins so highlights are set first
    opts = {
      flavour = "mocha",
      background = { dark = "mocha" },
    },
  },
  -- Tell LazyVim to actually use it.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
