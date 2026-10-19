-- Disable Mason: its prebuilt binaries don't run on NixOS. Tools come from Nix
-- (modules/home/neovim/default.nix) and LazyVim starts servers from $PATH.
-- Use the current mason-org/* names; the old williamboman/* names trigger a
-- rename warning at startup.
return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
