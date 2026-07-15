-- lazy.nvim bootstrap + LazyVim setup.
--
-- Language support is turned on by importing LazyVim's "extras" below. Each
-- extra pulls in the right plugins, treesitter parsers, LSP server config,
-- formatters and DAP for that language. The binaries those need do NOT come
-- from Mason (disabled in lua/plugins/nix.lua on NixOS) — they come from Nix,
-- from the home.packages list in modules/home/neovim/default.nix. Keep the two
-- in sync: add an extra here => add its tools there.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core and its default plugin set.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Language extras (see header). HTML/CSS have no dedicated extra and are
    -- wired by hand in lua/plugins/lsp.lua instead.
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- JS + TS (vtsls)
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.clangd" },      -- C / C++

    -- Local overrides: colorscheme, Mason-off, html/css. (lua/plugins/*.lua)
    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false }, -- background update check, quiet
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
