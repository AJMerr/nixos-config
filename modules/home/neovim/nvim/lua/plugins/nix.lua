-- Disable Mason on NixOS.
--
-- Mason downloads pre-built LSP/formatter/DAP binaries that are dynamically
-- linked against FHS paths (/lib64/ld-linux, /usr/lib) which don't exist on
-- NixOS, so they crash at launch. We provide every tool from Nix instead (see
-- modules/home/neovim/default.nix). With mason-lspconfig absent, LazyVim falls
-- back to setting each server up directly through nvim-lspconfig, starting
-- whatever it finds on $PATH — which is exactly the Nix-provided binaries.
--
-- Both the current (mason-org/*) and legacy (williamboman/*) plugin names are
-- listed so this keeps working across LazyVim's rename; disabling a name that
-- isn't in the spec is a harmless no-op.
return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
