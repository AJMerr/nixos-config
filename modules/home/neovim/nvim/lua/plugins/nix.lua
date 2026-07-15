-- Disable Mason on NixOS.
--
-- Mason downloads pre-built LSP/formatter/DAP binaries that are dynamically
-- linked against FHS paths (/lib64/ld-linux, /usr/lib) which don't exist on
-- NixOS, so they crash at launch. We provide every tool from Nix instead (see
-- modules/home/neovim/default.nix). With mason-lspconfig absent, LazyVim falls
-- back to setting each server up directly through nvim-lspconfig, starting
-- whatever it finds on $PATH — which is exactly the Nix-provided binaries.
--
-- Mason was moved from the williamboman/* org to mason-org/* upstream, and
-- current LazyVim references the mason-org/* names. Disable spec entries by
-- their *current* names only: naming the old williamboman/* repos here makes
-- LazyVim's rename-detector fire a "was renamed to mason-org/…" warning on
-- every startup (that is the banner this file exists to prevent).
return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
